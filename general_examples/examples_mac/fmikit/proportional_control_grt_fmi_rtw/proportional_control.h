/*
 * proportional_control.h
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "proportional_control".
 *
 * Model version              : 1.5
 * Simulink Coder version : 9.8 (R2022b) 13-May-2022
 * C source code generated on : Wed Mar  1 14:14:47 2023
 *
 * Target selection: grtfmi.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_proportional_control_h_
#define RTW_HEADER_proportional_control_h_
#ifndef proportional_control_COMMON_INCLUDES_
#define proportional_control_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                               /* proportional_control_COMMON_INCLUDES_ */

#include "proportional_control_types.h"
#include <stddef.h>

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T reference;                    /* '<Root>/reference' */
  real_T real;                         /* '<Root>/real' */
} ExtU_proportional_control_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T control_signal;               /* '<Root>/control_signal' */
} ExtY_proportional_control_T;

/* Real-time Model Data Structure */
struct tag_RTM_proportional_control_T {
  const char_T *errorStatus;
};

/* External inputs (root inport signals with default storage) */
extern ExtU_proportional_control_T proportional_control_U;

/* External outputs (root outports fed by signals with default storage) */
extern ExtY_proportional_control_T proportional_control_Y;

/* Model entry point functions */
extern void proportional_control_initialize(void);
extern void proportional_control_step(void);
extern void proportional_control_terminate(void);

/* Real-time Model object */
extern RT_MODEL_proportional_control_T *const proportional_control_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'proportional_control'
 */
#endif                                 /* RTW_HEADER_proportional_control_h_ */
