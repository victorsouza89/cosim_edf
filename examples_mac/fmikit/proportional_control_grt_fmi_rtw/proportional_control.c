/*
 * proportional_control.c
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

#include "proportional_control.h"
#include <string.h>

/* External inputs (root inport signals with default storage) */
ExtU_proportional_control_T proportional_control_U;

/* External outputs (root outports fed by signals with default storage) */
ExtY_proportional_control_T proportional_control_Y;

/* Real-time model */
static RT_MODEL_proportional_control_T proportional_control_M_;
RT_MODEL_proportional_control_T *const proportional_control_M =
  &proportional_control_M_;

/* Model step function */
void proportional_control_step(void)
{
  /* Outport: '<Root>/control_signal' incorporates:
   *  Inport: '<Root>/real'
   *  Inport: '<Root>/reference'
   *  Sum: '<Root>/Sum'
   */
  proportional_control_Y.control_signal = proportional_control_U.reference -
    proportional_control_U.real;
}

/* Model initialize function */
void proportional_control_initialize(void)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus(proportional_control_M, (NULL));

  /* external inputs */
  (void)memset(&proportional_control_U, 0, sizeof(ExtU_proportional_control_T));

  /* external outputs */
  proportional_control_Y.control_signal = 0.0;
}

/* Model terminate function */
void proportional_control_terminate(void)
{
  /* (no terminate code required) */
}
