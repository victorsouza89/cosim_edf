#include "simstruc_types.h"

#include "integrator.h"
#include "integrator_private.h"

typedef struct {
	BuiltInDTypeId dtypeID;
	size_t size;
	void* address;
} ModelVariable;

#ifndef NO_FMI_FUNCTION_PREFIX
#define FMI2_FUNCTION_PREFIX integrator_
#endif

#define MODEL_GUID       "{95e7e37f-dabd-461f-979f-c3fd8cd75200}"
#define MODEL            integrator
#define MODEL_INITIALIZE integrator_initialize
#define MODEL_STEP       integrator_step
#define MODEL_TERMINATE  integrator_terminate
#define RT_MDL_TYPE      RT_MODEL_integrator_T
#define STEP_SIZE        0.001
#define NUM_TASKS        1
#define NUM_SAMPLE_TIMES 2
#define FIRST_TASK_ID    1

/* since R2019a the block parameters are defined as extern */
#ifndef rtmGetDefaultParam
#define rtmGetDefaultParam(S) (&integrator_P)
#endif

/* Definitions for non-reusable models */
#define RT_MDL_INSTANCE     integrator_M
#define rtmGetU(S)          (&integrator_U)
#define rtmGetY(S)          (&integrator_Y)
#define rtmGetBlockIO(S)    (&integrator_B)

static void initializeModelVariables(RT_MDL_TYPE* S, ModelVariable modelVariables[]) {
    modelVariables[0].dtypeID = 0;
    modelVariables[0].size    = 0;
    modelVariables[0].address = &(rtmGetDefaultParam(S)->TransferFcn_A);
    modelVariables[1].dtypeID = 0;
    modelVariables[1].size    = 0;
    modelVariables[1].address = &(rtmGetDefaultParam(S)->TransferFcn_C);
    modelVariables[2].dtypeID = 0;
    modelVariables[2].size    = 0;
    modelVariables[2].address = &(rtmGetU(S)->In1);
    modelVariables[3].dtypeID = 0;
    modelVariables[3].size    = 0;
    modelVariables[3].address = &(rtmGetY(S)->Out1);
}

#define N_MODEL_VARIABLES 4
