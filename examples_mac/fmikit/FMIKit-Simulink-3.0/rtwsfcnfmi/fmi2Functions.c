/*****************************************************************
 *  Copyright (c) Dassault Systemes. All rights reserved.        *
 *  This file is part of FMIKit. See LICENSE.txt in the project  *
 *  root for license information.                                *
 *****************************************************************/

/*
-----------------------------------------------------------
	Implementation of FMI 2.0 on top of C code
	generated by Simulink Coder S-function target.
-----------------------------------------------------------
*/

#include <stdio.h>
#include <stdarg.h>
#include <math.h>

#include "sfcn_fmi.h"
#include "fmi2Functions.h"	/* Official FMI 2.0 header */
#include "sfunction.h"
#include "model_interface.h"


/* -------------- Macro to check if initialized -------------- */

#define CHECK_INITIALIZED(model, label)                                        \
	if (model->status <= modelInitializationMode) {                             \
        logger(model, model->instanceName, fmi2Warning, "",                        \
			label": model is not initialized\n");                                \
		return fmi2Warning;                                                        \
	}

/* ------------- Macro for unsupported function -------------- */

#define FMI_UNSUPPORTED(label) \
	Model* model = (Model*)c; \
	logger(model, model->instanceName, fmi2Error, "error", "fmi2"#label": Currently not supported for FMI S-function\n"); \
	return fmi2Error


/* ------------------ Local help functions ------------------- */

static void logMessage(Model *model, int status, const char *message, ...) {

	char buf[1024];
	va_list args;

	va_start(args, message);
	vsnprintf(buf, 1024, message, args);
	va_end(args);

	fmi2CallbackFunctions *functions = (fmi2CallbackFunctions *)model->userData;

	functions->logger(functions->componentEnvironment, model->instanceName, status, "", buf);
}

/* Function for double precision comparison */
static int isEqual(double a, double b) {

    double A, B, largest;
    double diff = fabs(a-b);

    A = fabs(a);
    B = fabs(b);
    largest = (B > A) ? B : A;

    if (diff <= (1.0 + largest) * SFCN_FMI_EPS)
        return 1;
    return 0;
}

/* logger wrapper for handling of enabled/disabled logging */
static void logger(fmi2Component c, fmi2String instanceName, fmi2Status status,
				   fmi2String category, fmi2String message, ...);

/* ------------------ ODE solver functions ------------------- */
const char *RT_MEMORY_ALLOCATION_ERROR = "Error when allocating SimStruct solver data.";

/* Globals used for child S-functions */
extern Model* currentModel;

/***************************************************
Common Functions
****************************************************/

/* Inquire version numbers of header files and setting logging status */

const char* fmi2GetTypesPlatform() {
	return fmi2TypesPlatform;
}

const char* fmi2GetVersion() {
	return fmi2Version;
}

fmi2Status fmi2SetDebugLogging(fmi2Component c, fmi2Boolean loggingOn, size_t nCategories, const fmi2String categories[]) {
	Model* model = (Model*) c;
	model->loggingOn = loggingOn;
	/* Categories currently not supported */
	return fmi2OK;
}

/* Creation and destruction of FMU instances and setting debug status */

fmi2Component fmi2Instantiate(fmi2String	instanceName,
								fmi2Type	fmuType,
								fmi2String	GUID,
								fmi2String	fmuResourceLocation,
								const fmi2CallbackFunctions* functions,
								fmi2Boolean	visible,
								fmi2Boolean	loggingOn)
{
	/* The following arguments are ignored: fmuResourceLocation, visible */

	// check logger callback
	if (!functions || !functions->logger) {
		return NULL;
	}

	/* verify GUID */
	if (strcmp(GUID, MODEL_GUID) != 0) {
		functions->logger(NULL, instanceName, fmi2Error, "logError", "Invalid GUID \"%s\", expected \"%s\".", GUID, MODEL_GUID);
		return NULL;
	}

	fmi2CallbackFunctions *callbacks = (fmi2CallbackFunctions *)calloc(1, sizeof(fmi2CallbackFunctions));
	
	memcpy(callbacks, functions, sizeof(fmi2CallbackFunctions));

	Model *model = InstantiateModel(instanceName, logMessage, fmuType == fmi2CoSimulation, callbacks);

    initializeModelVariables(model->S, model->modelVariables);
	
	if (fmuType == fmi2CoSimulation) {
		
		if (functions->stepFinished) {
			logMessage(model, fmi2Warning, "Callback function stepFinished != NULL but asynchronous fmi2DoStep is not supported.");
		}
	}

	return model;
}

void fmi2FreeInstance(fmi2Component c) {
	Model* model = (Model*)c;
	free(model->userData);
	model->userData = NULL;
    FreeModel(model);
}

/* Enter and exit initialization mode, terminate and reset */

fmi2Status fmi2SetupExperiment(fmi2Component c,
										fmi2Boolean toleranceDefined,
										fmi2Real tolerance,
										fmi2Real startTime,
										fmi2Boolean stopTimeDefined,
										fmi2Real stopTime) {

	Model* model = (Model*) c;
	fmi2Status status = fmi2OK;

	/* Any supplied tolerance if toleranceDefined is not used */
	if (stopTimeDefined == fmi2True) {
		/* Provide information that stopTime will not be enforced by FMU */
		logger(model, model->instanceName, status, "", "fmi2SetupExperiment: The defined stopTime will not be enforced by the FMU\n");
	}
	if (fabs(startTime) > SFCN_FMI_EPS) {
		status = fmi2Error;
		logger(model, model->instanceName, status, "", "fmi2SetupExperiment: startTime other than 0.0 not supported\n");
	}
	return status;
}

fmi2Status fmi2EnterInitializationMode(fmi2Component c) {

	Model* model = (Model*) c;

	/* Initialize continuous-time states */
	if (ssGetmdlInitializeConditions(model->S) != NULL) {
		sfcnInitializeConditions(model->S);
	}
	if (_ssGetRTWGeneratedEnable(model->S) != NULL) {
		_sfcnRTWGeneratedEnable(model->S);
	}
	/* Check Simstruct error status and stop requested */
	if ((ssGetErrorStatus(model->S) != NULL) || (ssGetStopRequested(model->S) != 0)) {
		if (ssGetStopRequested(model->S) != 0) {
			logger(model, model->instanceName, fmi2Error, "", "Stop requested by S-function!\n");
		}
		if (ssGetErrorStatus(model->S) != NULL) {
			logger(model, model->instanceName, fmi2Error, "", "Error reported by S-function: %s\n", ssGetErrorStatus(model->S));
		}
		model->status = modelInitializationMode;
		return fmi2Error;
	}

	model->S->mdlInfo->t[0] = 0.0;
	if (model->fixed_in_minor_step_offset_tid != -1) {
		model->S->mdlInfo->t[model->fixed_in_minor_step_offset_tid] = 0.0;
	}

	if (!(model->isCoSim)) {
		/* Call mdlOutputs for continuous parts */
		if (model->fixed_in_minor_step_offset_tid != -1) {
			model->S->mdlInfo->sampleHits[model->fixed_in_minor_step_offset_tid] = 1;
			if (SFCN_FMI_LOAD_MEX) {
				copyPerTaskSampleHits(model->S);
			}
		}
		sfcnOutputs(model->S,0);
		_ssSetTimeOfLastOutput(model->S,model->S->mdlInfo->t[0]);
		if (model->fixed_in_minor_step_offset_tid != -1) {
			model->S->mdlInfo->sampleHits[model->fixed_in_minor_step_offset_tid] = 0;
			if (SFCN_FMI_LOAD_MEX) {
				copyPerTaskSampleHits(model->S);
			}
		}
	}

	model->status = modelInitializationMode;

	logger(model, model->instanceName, fmi2OK, "", "Enter initialization mode\n");
	return fmi2OK;
}

fmi2Status fmi2ExitInitializationMode(fmi2Component c) {

	Model* model = (Model*) c;
	fmi2Status status = fmi2OK;
	fmi2EventInfo eventInfo = { 0 };

	model->status = modelEventMode;

	if (model->isCoSim) {
		/* Evaluate model at t=0 */
		status = fmi2NewDiscreteStates(c, &eventInfo);
		if (status != fmi2OK) {
			model->status = modelInstantiated;
			return status;
		}
	}

	model->shouldRecompute = fmi2True;
	model->lastGetTime = -1.0;  /* to make sure that derivatives are computed in fmi2GetReal at t=0 */

	logger(model, model->instanceName, fmi2OK, "", "Exit initialization mode, enter event mode\n");
	return fmi2OK;
}

fmi2Status fmi2Terminate(fmi2Component c) {

	Model* model = (Model*) c;

	if (model == NULL) {
		return fmi2OK;
	}

	logger(model, model->instanceName, fmi2OK, "", "Terminating\n");
	model->status = modelTerminated;

	return fmi2OK;
}

fmi2Status fmi2Reset(fmi2Component c) {

	Model* model = (Model*) c;
	
	Model *temp = (Model *)calloc(1, sizeof(Model));

	memcpy(temp, model, sizeof(Model));

	Model *new_model = InstantiateModel(model->instanceName, logMessage, model->isCoSim, model->userData);
	
	initializeModelVariables(new_model->S, new_model->modelVariables);

	memcpy(model, new_model, sizeof(Model));

	FreeModel(temp);

	return fmi2OK;
}

/* Getting and setting variable values */

// helper function to update the outputs and derivatives
static void calculateOutputs(Model *model) {

	if (!model->isCoSim && !model->isDiscrete) {

		if ((!isEqual(ssGetT(model->S), model->lastGetTime)) || model->shouldRecompute) {

			sfcnOutputs(model->S, 0);
			_ssSetTimeOfLastOutput(model->S, model->S->mdlInfo->t[0]);

			if (ssGetmdlDerivatives(model->S) != NULL) {
				sfcnDerivatives(model->S);
			}

			model->S->mdlInfo->simTimeStep = MINOR_TIME_STEP;
			model->shouldRecompute = 0;
			model->lastGetTime = ssGetT(model->S);
		}
	}
}

fmi2Status fmi2GetReal(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, fmi2Real value[]) {
    
    Model* model = (Model*) c;

	if (model->status == modelInstantiated) {
		// not allowed before fmi2EnterInitializationMode has been called
		return fmi2Error;
	}

	calculateOutputs(model);

    for (size_t i = 0; i < nvr; i++) {
        
        if (vr[i] > N_MODEL_VARIABLES) {
            continue;
        }
        
        ModelVariable *mv = &(model->modelVariables[vr[i] - 1]);

        switch (mv->dtypeID) {
            case SS_SINGLE:
                value[i] = *((real32_T *)mv->address);
                break;
            case SS_DOUBLE:
                value[i] = *((real_T *)mv->address);
                break;
            default:
                return fmi2Error;
        }
    }
    
    return fmi2OK;
}

fmi2Status fmi2GetInteger(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, fmi2Integer value[]) {
    
    Model* model = (Model*) c;

	if (model->status == modelInstantiated) {
		// not allowed before fmi2EnterInitializationMode has been called
		return fmi2Error;
	}

	calculateOutputs(model);

    for (size_t i = 0; i < nvr; i++) {
        
        if (vr[i] > N_MODEL_VARIABLES) {
            continue;
        }
        
        ModelVariable *mv = &(model->modelVariables[vr[i] - 1]);

        switch (mv->dtypeID) {
            case SS_INT8:
                value[i] = *((int8_T *)mv->address);
                break;
            case SS_UINT8:
                value[i] = *((uint8_T *)mv->address);
                break;
            case SS_INT16:
                value[i] = *((int16_T *)mv->address);
                break;
            case SS_UINT16:
                value[i] = *((uint16_T *)mv->address);
                break;
            case SS_INT32:
                value[i] = *((int32_T *)mv->address);
                break;
            case SS_UINT32:
                value[i] = *((uint32_T *)mv->address);
                break;
            default:
                return fmi2Error;
        }
    }
    
    return fmi2OK;
}

fmi2Status fmi2GetBoolean(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, fmi2Boolean value[]) {
    
    Model* model = (Model*) c;

	if (model->status == modelInstantiated) {
		// not allowed before fmi2EnterInitializationMode has been called
		return fmi2Error;
	}

	calculateOutputs(model);

    for (size_t i = 0; i < nvr; i++) {
        
        if (vr[i] > N_MODEL_VARIABLES) {
            continue;
        }
        
        ModelVariable *mv = &(model->modelVariables[vr[i] - 1]);

        switch (mv->dtypeID) {
            case SS_BOOLEAN:
                value[i] = *((boolean_T *)mv->address);
                break;
            default:
                return fmi2Error;
        }
    }
    
    return fmi2OK;
}

fmi2Status fmi2GetString(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, fmi2String  value[]) {
	FMI_UNSUPPORTED(GetString);
}

fmi2Status fmi2SetReal(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, const fmi2Real value[]) {

    Model* model = (Model*)c;

    for (size_t i = 0; i < nvr; i++) {

        if (vr[i] > N_MODEL_VARIABLES) {
            return fmi2Error;
        }

        ModelVariable *mv = &(model->modelVariables[vr[i] - 1]);

        real_T *p;

        switch (mv->dtypeID) {
        case SS_DOUBLE: {
            p = (real_T *)mv->address;
            *((real_T *)mv->address) = value[i];
        }
                        break;
        case SS_SINGLE:
            *((real32_T *)mv->address) = value[i];
            break;
        default:
            return fmi2Error;
        }
    }

    model->shouldRecompute = 1;

    return fmi2OK;
}

fmi2Status fmi2SetInteger(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, const fmi2Integer value[]) {

    Model* model = (Model*)c;

    for (size_t i = 0; i < nvr; i++) {

        if (vr[i] > N_MODEL_VARIABLES) {
            return fmi2Error;
        }

        ModelVariable *mv = &(model->modelVariables[vr[i] - 1]);

        switch (mv->dtypeID) {
        case SS_INT8:
            *((int8_T *)mv->address) = value[i];
            break;
        case SS_UINT8:
            *((uint8_T *)mv->address) = value[i];
            break;
        case SS_INT16:
            *((int16_T *)mv->address) = value[i];
            break;
        case SS_UINT16:
            *((uint16_T *)mv->address) = value[i];
            break;
        case SS_INT32:
            *((int32_T *)mv->address) = value[i];
            break;
        case SS_UINT32:
            *((uint32_T *)mv->address) = value[i];
            break;
        default:
            return fmi2Error;
        }
    }

    model->shouldRecompute = 1;

    return fmi2OK;
}

fmi2Status fmi2SetBoolean(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, const fmi2Boolean value[]) {

    Model* model = (Model*)c;

    for (size_t i = 0; i < nvr; i++) {

        if (vr[i] > N_MODEL_VARIABLES) {
            return fmi2Error;
        }

        ModelVariable *mv = &(model->modelVariables[vr[i] - 1]);

        switch (mv->dtypeID) {
        case SS_BOOLEAN:
            *((boolean_T *)mv->address) = value[i];
            break;
        default:
            return fmi2Error;
        }
    }

    model->shouldRecompute = 1;

    return fmi2OK;
}

fmi2Status fmi2SetString(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, const fmi2String  value[]) {
    FMI_UNSUPPORTED(SetString);
}

/* Getting and setting the internal FMU state */

fmi2Status fmi2GetFMUstate(fmi2Component c, fmi2FMUstate* FMUstate) {
	FMI_UNSUPPORTED(GetFMUstate);
}

fmi2Status fmi2SetFMUstate(fmi2Component c, fmi2FMUstate FMUstate) {
	FMI_UNSUPPORTED(SetFMUstate);
}

fmi2Status fmi2FreeFMUstate(fmi2Component c, fmi2FMUstate* FMUstate) {
	FMI_UNSUPPORTED(FreeFMUstate);
}

fmi2Status fmi2SerializedFMUstateSize(fmi2Component c, fmi2FMUstate FMUstate, size_t* size) {
	FMI_UNSUPPORTED(SerializedFMUstateSize);
}

fmi2Status fmi2SerializeFMUstate(fmi2Component c, fmi2FMUstate FMUstate, fmi2Byte serializedState[], size_t size) {
	FMI_UNSUPPORTED(SerializeFMUstate);
}

fmi2Status fmi2DeSerializeFMUstate(fmi2Component c, const fmi2Byte serializedState[], size_t size, fmi2FMUstate* FMUstate) {
	FMI_UNSUPPORTED(DeSerializeFMUstate);
}

/* Getting partial derivatives */

fmi2Status fmi2GetDirectionalDerivative(fmi2Component c, const fmi2ValueReference vUnknown_ref[], size_t nUnknown,
                                                         const fmi2ValueReference vKnown_ref[], size_t nKnown,
                                                         const fmi2Real dvKnown[],
														       fmi2Real dvUnknown[]) {
	FMI_UNSUPPORTED(GetDirectionalDerivative);
}

/***************************************************
Functions for Model Exchange
****************************************************/

fmi2Status fmi2EnterEventMode(fmi2Component c) {

	Model* model = (Model*) c;

	CHECK_INITIALIZED(model, "fmi2EnterEventMode");

	if (model->status != modelContinuousTimeMode) {
		logger(model, model->instanceName, fmi2Warning, "", "fmi2EnterEventMode: May only be called in continuous-time mode\n");
		return fmi2Warning;
	}

	logger(model, model->instanceName, fmi2OK, "", "Enter event mode at time = %.16f\n", ssGetT(model->S));
	model->status = modelEventMode;
	return fmi2OK;
}

fmi2Status fmi2NewDiscreteStates(fmi2Component c, fmi2EventInfo* eventInfo) {

    Model* model = (Model*) c;

    CHECK_INITIALIZED(model, "fmi2NewDiscreteStates");
    
    fmi2Boolean valuesOfContinuousStatesChanged = fmi2False;
    real_T nextT = SFCN_FMI_MAX_TIME;
    
    NewDiscreteStates(model, &valuesOfContinuousStatesChanged, &nextT);

#if defined(SFCN_FMI_VERBOSITY)
	logger(model, model->instanceName, fmi2OK, "", "fmi2NewDiscreteStates: Call at time = %.16f\n", ssGetT(model->S));
#endif

	eventInfo->newDiscreteStatesNeeded			 = fmi2False;
    eventInfo->terminateSimulation				 = fmi2False;
    eventInfo->nominalsOfContinuousStatesChanged = fmi2False;
    eventInfo->valuesOfContinuousStatesChanged   = valuesOfContinuousStatesChanged;
	eventInfo->nextEventTimeDefined              = (nextT < SFCN_FMI_MAX_TIME);
	eventInfo->nextEventTime                     = nextT;

#if defined(SFCN_FMI_VERBOSITY)
		logger(model, model->instanceName, fmi2OK, "", "fmi2NewDiscreteStates: Event handled at time = %.16f, next event time at %.16f\n", ssGetT(model->S), nextT);
#endif
    
	return fmi2OK;
}

fmi2Status fmi2EnterContinuousTimeMode(fmi2Component c) {
	Model* model = (Model*) c;

	CHECK_INITIALIZED(model, "fmi2EnterContinuousTimeMode");

	if (model->status != modelEventMode) {
		logger(model, model->instanceName, fmi2Warning, "", "fmi2EnterContinuousTimeMode: May only be called in event mode\n");
		return fmi2Warning;
	}

	logger(model, model->instanceName, fmi2OK, "", "Enter continuous-time mode at time = %.16f\n", ssGetT(model->S));
	model->hasEnteredContMode = fmi2True;
	model->status = modelContinuousTimeMode;
	return fmi2OK;
}

fmi2Status fmi2CompletedIntegratorStep(fmi2Component c, fmi2Boolean noSetFMUStatePriorToCurrentPoint,
										fmi2Boolean* enterEventMode, fmi2Boolean* terminateSimulation) {

	int i;
	real_T currZC_i;
	Model* model = (Model*) c;
	int rising  = 0;
	int falling = 0;

	CHECK_INITIALIZED(model, "fmi2CompletedIntegratorStep");

#if defined(SFCN_FMI_VERBOSITY)
	logger(model, model->instanceName, fmi2OK, "", "fmi2CompletedIntegratorStep: Call at time %.16f\n", ssGetT(model->S));
#endif

	/* Evaluate zero-crossing functions */
	if (model->S->modelMethods.sFcn.mdlZeroCrossings != NULL) {
		sfcnZeroCrossings(model->S);
	}
	/* Check for zero crossings */
	for (i=0;i<SFCN_FMI_ZC_LENGTH;i++) {
		currZC_i = model->S->mdlInfo->solverInfo->zcSignalVector[i];
		rising  = ((model->oldZC[i] < 0.0) && (currZC_i >= 0.0)) || ((model->oldZC[i] == 0.0) && (currZC_i > 0.0));
		falling = ((model->oldZC[i] > 0.0) && (currZC_i <= 0.0)) || ((model->oldZC[i] == 0.0) && (currZC_i < 0.0));
#if defined(SFCN_FMI_VERBOSITY)
		logger(model, model->instanceName, fmi2OK, "", "fmi2CompletedIntegratorStep: oldZC[%d] = %.16f ; currZC[%d] = %.16f\n", i, model->oldZC[i], i, currZC_i);
#endif
		if (rising || falling) {
			break;
		}
	}
	/* Store current zero-crossing values at step */
	for (i=0;i<SFCN_FMI_ZC_LENGTH;i++) {
		model->oldZC[i] = model->S->mdlInfo->solverInfo->zcSignalVector[i];
	}

	/* Do not set major time step if we stepped passed a zero crossing
	   Will be a major time step in EventMode */
	if (!(rising || falling) && !model->isDiscrete) {
		model->S->mdlInfo->simTimeStep = MAJOR_TIME_STEP;
		/* Update continuous task with FIXED_IN_MINOR_STEP_OFFSET */
		if (model->fixed_in_minor_step_offset_tid != -1) {
			model->S->mdlInfo->sampleHits[model->fixed_in_minor_step_offset_tid] = 1;
			if (SFCN_FMI_LOAD_MEX) {
				copyPerTaskSampleHits(model->S);
			}
		}
		sfcnOutputs(model->S, 0);
		_ssSetTimeOfLastOutput(model->S,model->S->mdlInfo->t[0]);
		if (ssGetmdlUpdate(model->S) != NULL) {
#if defined(SFCN_FMI_VERBOSITY)
			logger(model, model->instanceName, fmi2OK, "", "fmi2CompletedIntegratorStep: Calling mdlUpdate at time %.16f\n", ssGetT(model->S));
#endif
			sfcnUpdate(model->S, 0);
		}
		if (model->fixed_in_minor_step_offset_tid != -1) {
			model->S->mdlInfo->sampleHits[model->fixed_in_minor_step_offset_tid] = 0;
			if (SFCN_FMI_LOAD_MEX) {
				copyPerTaskSampleHits(model->S);
			}
		}
		model->S->mdlInfo->simTimeStep = MINOR_TIME_STEP;
	}
	*enterEventMode = fmi2False;
	*terminateSimulation = fmi2False;
	model->shouldRecompute=fmi2True;

	return fmi2OK;
}

fmi2Status fmi2SetTime(fmi2Component c, fmi2Real time) {

	Model*  model = (Model*) c;

	model->S->mdlInfo->t[0] = time;
	if (model->fixed_in_minor_step_offset_tid != -1) {
		model->S->mdlInfo->t[model->fixed_in_minor_step_offset_tid] = time;
	}
	return fmi2OK;
}

fmi2Status fmi2SetContinuousStates(fmi2Component c, const fmi2Real x[], size_t nx) {

	Model* model = (Model*) c;
	fmi2Status status = fmi2OK;

	int_T nxS = ssGetNumContStates(model->S);
	if (((int_T) nx) != nxS) {
		status = fmi2Warning;
		logger(model, model->instanceName, status, "",
			"fmi2SetContinuousStates: argument nx = %u is incorrect, should be %u\n", nx, nxS);
		if (((int_T) nx) > nxS) {
			/* truncate */
			nx = nxS;
		}
	}
	memcpy(ssGetContStates(model->S), x, nx * sizeof(fmi2Real));
	model->shouldRecompute=fmi2True;

	return status;
}

fmi2Status fmi2GetDerivatives(fmi2Component c, fmi2Real derivatives[], size_t nx) {

	Model* model = (Model*) c;
	fmi2Status status = fmi2OK;
	int_T nxS;

	if (model->status == modelInstantiated) {
		logger(model, model->instanceName, fmi2Warning, "", "fmi2GetDerivatives: Not allowed before call to fmi2EnterInitializationMode\n");
		return fmi2Warning;
	}

	nxS = ssGetNumContStates(model->S);
	if (((int_T) nx) != nxS) {
		status = fmi2Warning;
		logger(model, model->instanceName, status, "",
			"fmi2GetDerivatives: argument nx = %u is incorrect, should be %u\n", nx, nxS);
		if (((int_T) nx) > nxS) {
			/* truncate */
			nx = nxS;
		}
	}

	sfcnOutputs(model->S,0);
	_ssSetTimeOfLastOutput(model->S,model->S->mdlInfo->t[0]);
	if (ssGetmdlDerivatives(model->S) != NULL) {
		sfcnDerivatives(model->S);
		memcpy(derivatives, ssGetdX(model->S), nx * sizeof(fmi2Real));
	}
	model->S->mdlInfo->simTimeStep = MINOR_TIME_STEP;
	return status;
}

fmi2Status fmi2GetEventIndicators(fmi2Component c, fmi2Real eventIndicators[], size_t ni) {

	Model* model = (Model*) c;
	fmi2Status status = fmi2OK;
	int_T nzS;

	if (model->status == modelInstantiated) {
		logger(model, model->instanceName, fmi2Warning, "", "fmi2GetEventIndicators: Not allowed before call to fmi2EnterInitializationMode\n");
		return fmi2Warning;
	}

	nzS = SFCN_FMI_ZC_LENGTH;
	if (((int_T) ni) != nzS) {
		status = fmi2Warning;
		logger(model, model->instanceName, status, "",
			"fmi2GetEventIndicators: argument ni = %u is incorrect, should be %u\n", ni, nzS);
		if (((int_T) ni) > nzS) {
			/* truncate */
			ni = nzS;
		}
	}

	sfcnOutputs(model->S,0);
	_ssSetTimeOfLastOutput(model->S,model->S->mdlInfo->t[0]);
	if (model->S->modelMethods.sFcn.mdlZeroCrossings != NULL) {
		sfcnZeroCrossings(model->S);
		memcpy(eventIndicators, model->S->mdlInfo->solverInfo->zcSignalVector, ni * sizeof(fmi2Real));
	}
	model->S->mdlInfo->simTimeStep = MINOR_TIME_STEP;
	return status;
}

fmi2Status fmi2GetContinuousStates(fmi2Component c, fmi2Real states[], size_t nx) {

	Model* model = (Model*) c;
	fmi2Status status = fmi2OK;
	int_T nxS;

	if (model->status == modelInstantiated) {
		logger(model, model->instanceName, fmi2Warning, "", "fmi2GetContinuousStates: Not allowed before call to fmi2EnterInitializationMode\n");
		return fmi2Warning;
	}

	nxS = ssGetNumContStates(model->S);
	if (((int_T) nx) != nxS) {
		status = fmi2Warning;
		logger(model, model->instanceName, status, "",
			"fmi2GetContinuousStates: argument nx = %u is incorrect, should be %u\n", nx, nxS);
		if (((int_T) nx) > nxS) {
			/* truncate */
			nx = nxS;
		}
	}

	memcpy(states, ssGetContStates(model->S), nx * sizeof(fmi2Real));
	return status;
}

fmi2Status fmi2GetNominalsOfContinuousStates(fmi2Component c, fmi2Real x_nominal[], size_t nx) {

	unsigned int i;
	Model* model = (Model*) c;
	fmi2Status status = fmi2OK;

	int_T nxS = ssGetNumContStates(model->S);
	if (((int_T) nx) != nxS) {
		status = fmi2Warning;
		logger(model, model->instanceName, status, "",
			"fmi2GetNominalContinuousStates: argument nx = %u is incorrect, should be %u\n", nx, nxS);
		if (((int_T) nx) > nxS) {
			/* truncate */
			nx = nxS;
		}
	}

	for (i=0;i<nx;i++) {
		x_nominal[i] = 1.0; /* Unknown nominal */
	}
	return status;
}


/***************************************************
Functions for Co-Simulation
****************************************************/

fmi2Status fmi2SetRealInputDerivatives(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, const fmi2Integer order[], const fmi2Real value[]) {
//	Model* model = (Model*) c;
//	size_t i;
//
//	if (model->status <= modelInitializationMode) {
//		logger(model, model->instanceName, fmi2Warning, "", "fmi2SetRealInputDerivatives: Slave is not initialized\n");
//		return fmi2Warning;
//	}
//	if (nvr == 0 || nvr > SFCN_FMI_NBR_INPUTS) {
//		logger(model, model->instanceName, fmi2Warning, "", "fmi2SetRealInputDerivatives: Invalid nvr = %d (number of inputs = %d)\n", nvr, SFCN_FMI_NBR_INPUTS);
//		return fmi2Warning;
//	}
//	for (i = 0; i < nvr; i++) {
//		const fmi2ValueReference r = vr[i];
//		int index    = SFCN_FMI_INDEX(r);
//		int dataType = SFCN_FMI_DATATYPE(r);
//
//		if (order[i] == 1) {
//			switch (SFCN_FMI_CATEGORY(r)) {
//			case SFCN_FMI_INPUT:
//				if (dataType == SS_DOUBLE) {
//					/* Non-zero derivatives only for double-valued real inputs */
//					model->inputDerivatives[index] = value[i];
//#if defined(SFCN_FMI_VERBOSITY)
//					logger(model, model->instanceName, fmi2OK, "", "fmi2SetRealInputDerivatives: Setting derivative at input #%d to %.16f at time = %.16f.\n", i, value[i], model->time);
//#endif
//				}
//				break;
//			default:
//				logger(model, model->instanceName, fmi2Warning, "", "fmi2SetRealInputDerivatives: variable is not input");
//				return fmi2Warning;
//			}
//		} else {
//			logger(model, model->instanceName, fmi2Warning, "", "fmi2SetRealInputDerivatives: derivative order %d is not supported", order[i]);
//			return fmi2Warning;
//		}
//	}
//	model->derivativeTime = model->time;
    FMI_UNSUPPORTED(SetRealInputDerivatives);
}

fmi2Status fmi2GetRealOutputDerivatives(fmi2Component c, const fmi2ValueReference vr[], size_t nvr, const fmi2Integer order[], fmi2Real value[]) {
//	Model* model = (Model*) c;
//	size_t i;
//
//	if (model->status <= modelInitializationMode) {
//        logger(model, model->instanceName, fmi2Warning, "", "fmi2GetRealOutputDerivatives: Slave is not initialized\n");
//		return fmi2Warning;
//	}
//	if (nvr == 0 || nvr > SFCN_FMI_NBR_OUTPUTS) {
//		logger(model, model->instanceName, fmi2Warning, "", "fmi2GetRealOutputDerivatives: Invalid nvr = %d (number of outputs = %d)\n", nvr, SFCN_FMI_NBR_OUTPUTS);
//		return fmi2Warning;
//	}
//	for (i = 0; i < nvr; i++) {
//		if (order[i] > 0) {
//			value[i] = 0.0;
//		} else {
//			logger(model, model->instanceName, fmi2Warning, "", "fmi2GetRealOutputDerivatives: Derivative order 0 is not allowed\n");
//			return fmi2Warning;
//		}
//	}
//	return fmi2OK;
    FMI_UNSUPPORTED(GetRealOutputDerivatives);
}

static void extrapolateInputs(Model* model, fmi2Real t)
{
    // TODO: fix this
//	size_t i;
//	fmi2Real dt = (t - model->derivativeTime);
//	for (i = 0; i < SFCN_FMI_NBR_INPUTS; i++) {
//		if (model->inputDerivatives[i] != 0.0) {
//			*((real_T*)(model->inputs[i])) += model->inputDerivatives[i] * dt;
//#if defined(SFCN_FMI_VERBOSITY)
//			logger(model, model->instanceName, fmi2OK, "", "Extrapolated input #%d to value = %.16f\n", i, *((real_T*)(model->inputs[i])));
//#endif
//		}
//	}
//	model->derivativeTime = t;
}

fmi2Status fmi2DoStep(fmi2Component c, fmi2Real currentCommunicationPoint, fmi2Real communicationStepSize, fmi2Boolean noSetFMUStatePriorToCurrentPoint) {

	Model* model = (Model*) c;
	fmi2Real lastSolverTime, nextSolverTime;
	fmi2Real endStepTime;
    fmi2Status status = fmi2OK;

	if (model->status <= modelInitializationMode) {
        logger(model, model->instanceName, fmi2Warning, "", "fmi2DoStep: Slave is not initialized\n");
		status = fmi2Warning;
	}
	
    if (model->status == modelTerminated) {
        logger(model, model->instanceName, fmi2Warning, "", "fmi2DoStep: Slave terminated in previous step\n");
        status = fmi2Warning;
    }

	if (!isEqual(model->time, currentCommunicationPoint)) {
		logger(model, model->instanceName, fmi2Warning, "", "fmi2DoStep: Invalid currentCommunicationPoint = %.16f, expected %.16f\n", currentCommunicationPoint, model->time);
        status = fmi2Warning;
    }
	
    model->S->mdlInfo->simTimeStep = MAJOR_TIME_STEP;
	
    if (fabs(communicationStepSize) < SFCN_FMI_EPS) {
		/* Zero step size; External event iteration, just recompute outputs */
		sfcnOutputs(model->S, 0);
		return status;
	}

	endStepTime = currentCommunicationPoint + communicationStepSize;
	lastSolverTime = model->nbrSolverSteps*SFCN_FMI_FIXED_STEP_SIZE;
	nextSolverTime = (model->nbrSolverSteps+1.0)*SFCN_FMI_FIXED_STEP_SIZE;
	
    while ( (nextSolverTime < endStepTime) || isEqual(nextSolverTime, endStepTime) ) {
#if defined(SFCN_FMI_VERBOSITY)
		logger(model, model->instanceName, fmi2OK, "", "fmi2DoStep: Internal solver step from %.16f to %.16f\n", lastSolverTime, nextSolverTime);
#endif
		/* Set time for state update */
		fmi2SetTime(c, lastSolverTime);
		/* Update continuous-time states */
		if (ssGetNumContStates(model->S) > 0) {
#if defined(SFCN_FMI_VERBOSITY)
			logger(model, model->instanceName, fmi2OK, "", "fmi2DoStep: Updating continuous states at time = %.16f.\n", model->S->mdlInfo->t[0]);
#endif
			/* Set ODE solver stop time */
			_ssSetSolverStopTime(model->S, nextSolverTime);
			/* Update states */
			rt_UpdateContinuousStates(model->S);
		}
		/* Set time for output calculations */
		fmi2SetTime(c, nextSolverTime);
		/* Extrapolate inputs */
		extrapolateInputs(model, nextSolverTime);
		/* Set sample hits and call mdlOutputs / mdlUpdate (always a discrete sample time = Fixed-step size) */
		fmi2EventInfo eventInfo = { 0 };
		fmi2NewDiscreteStates(c, &eventInfo);
		/* Update solver times */
		lastSolverTime = nextSolverTime;
		model->nbrSolverSteps++;
		nextSolverTime = (model->nbrSolverSteps+1.0)*SFCN_FMI_FIXED_STEP_SIZE;
	}

	model->time = endStepTime;

	return status;
}

fmi2Status fmi2CancelStep(fmi2Component c) {
    FMI_UNSUPPORTED(CancelStep);
}

fmi2Status fmi2GetStatus(fmi2Component c, const fmi2StatusKind s, fmi2Status*  value) {
    FMI_UNSUPPORTED(GetStatus);
}

fmi2Status fmi2GetRealStatus(fmi2Component c, const fmi2StatusKind s, fmi2Real* value) {
    FMI_UNSUPPORTED(CanceGetRealStatuslStep);
}

fmi2Status fmi2GetIntegerStatus(fmi2Component c, const fmi2StatusKind s, fmi2Integer* value) {
    FMI_UNSUPPORTED(GetIntegerStatus);
}

fmi2Status fmi2GetBooleanStatus(fmi2Component c, const fmi2StatusKind s, fmi2Boolean* value) {
    FMI_UNSUPPORTED(GetBooleanStatus);
}

fmi2Status fmi2GetStringStatus(fmi2Component c, const fmi2StatusKind s, fmi2String*  value) {
    FMI_UNSUPPORTED(GetStringStatus);
}

/* ----------------- Local function definitions ----------------- */

static void logger(fmi2Component c, fmi2String instanceName, fmi2Status status,
				   fmi2String category, fmi2String message, ...)
{
	char buf[4096];
	va_list ap;
    int capacity;
	Model* model;

	if (c==NULL) return;

	model = (Model*) c;
	if (model->loggingOn == fmi2False && (status == fmi2OK || status == fmi2Discard)) {
		return;
	}

	va_start(ap, message);
    capacity = sizeof(buf) - 1;
#if defined(_MSC_VER) && _MSC_VER>=1400
	vsnprintf_s(buf, capacity, _TRUNCATE, message, ap);
#else
    buf[capacity]=0;
	vsnprintf(buf, capacity, message, ap);
#endif
	va_end(ap);
	fmi2CallbackFunctions *functions = (fmi2CallbackFunctions *)model->userData;
	functions->logger(functions->componentEnvironment, instanceName, status, category, buf);
}

/* FMU mapping of ssPrintf for child C source S-functions (through rtPrintfNoOp) */
int rtPrintfNoOp(const char *fmt, ...)
{
	char buf[4096];
	va_list ap;
    int capacity;

	if (currentModel==NULL) return -1;

	va_start(ap, fmt);
    capacity = sizeof(buf) - 1;
#if defined(_MSC_VER) && _MSC_VER>=1400
	vsnprintf_s(buf, capacity, _TRUNCATE, fmt, ap);
#else
    buf[capacity]=0;
	vsnprintf(buf, capacity, fmt, ap);
#endif
	va_end(ap);
	logger(currentModel, currentModel->instanceName, fmi2OK, "", buf);

    return 0;
}

/* Wrapper function to be called from C++ implementation of rtPrintfNoOp */
int rtPrintfNoOp_C(const char *fmt, ...)
{
	char buf[4096];
	va_list ap;
    int capacity;

	if (currentModel==NULL) return -1;

	va_start(ap, fmt);
    capacity = sizeof(buf) - 1;
#if defined(_MSC_VER) && _MSC_VER>=1400
	vsnprintf_s(buf, capacity, _TRUNCATE, fmt, ap);
#else
    buf[capacity]=0;
	vsnprintf(buf, capacity, fmt, ap);
#endif
	va_end(ap);
	logger(currentModel, currentModel->instanceName, fmi2OK, "", buf);

    return 0;
}
