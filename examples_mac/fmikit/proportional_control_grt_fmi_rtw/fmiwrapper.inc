#include "simstruc_types.h"

#include "proportional_control.h"
#include "proportional_control_private.h"

typedef struct {
	BuiltInDTypeId dtypeID;
	size_t size;
	void* address;
} ModelVariable;

#ifndef NO_FMI_FUNCTION_PREFIX
#define FMI2_FUNCTION_PREFIX proportional_control_
#endif

#define MODEL_GUID       "{7323f3b9-a2ef-41c1-afe1-0ffdc9933fad}"
#define MODEL            proportional_control
#define MODEL_INITIALIZE proportional_control_initialize
#define MODEL_STEP       proportional_control_step
#define MODEL_TERMINATE  proportional_control_terminate
#define RT_MDL_TYPE      RT_MODEL_proportional_control_T
#define STEP_SIZE        0.001
#define NUM_TASKS        1
#define NUM_SAMPLE_TIMES 1
#define FIRST_TASK_ID    0

/* since R2019a the block parameters are defined as extern */
#ifndef rtmGetDefaultParam
#define rtmGetDefaultParam(S) (&proportional_control_P)
#endif

/* Definitions for non-reusable models */
#define RT_MDL_INSTANCE     proportional_control_M
#define rtmGetU(S)          (&proportional_control_U)
#define rtmGetY(S)          (&proportional_control_Y)
#define rtmGetBlockIO(S)    (&proportional_control_B)

static void initializeModelVariables(RT_MDL_TYPE* S, ModelVariable modelVariables[]) {
    modelVariables[0].dtypeID = 0;
    modelVariables[0].size    = 0;
    modelVariables[0].address = &(rtmGetU(S)->reference);
    modelVariables[1].dtypeID = 0;
    modelVariables[1].size    = 0;
    modelVariables[1].address = &(rtmGetU(S)->real);
    modelVariables[2].dtypeID = 0;
    modelVariables[2].size    = 0;
    modelVariables[2].address = &(rtmGetY(S)->control_signal);
}

#define N_MODEL_VARIABLES 3
