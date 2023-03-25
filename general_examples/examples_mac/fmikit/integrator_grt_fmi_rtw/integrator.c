/*
 * integrator.c
 *
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * Code generation for model "integrator".
 *
 * Model version              : 1.4
 * Simulink Coder version : 9.8 (R2022b) 13-May-2022
 * C source code generated on : Wed Mar  1 14:04:15 2023
 *
 * Target selection: grtfmi.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "integrator.h"
#include "integrator_private.h"

/* Continuous states */
X_integrator_T integrator_X;

/* External inputs (root inport signals with default storage) */
ExtU_integrator_T integrator_U;

/* External outputs (root outports fed by signals with default storage) */
ExtY_integrator_T integrator_Y;

/* Real-time model */
static RT_MODEL_integrator_T integrator_M_;
RT_MODEL_integrator_T *const integrator_M = &integrator_M_;

/*
 * This function updates continuous states using the ODE3 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  /* Solver Matrices */
  static const real_T rt_ODE3_A[3] = {
    1.0/2.0, 3.0/4.0, 1.0
  };

  static const real_T rt_ODE3_B[3][3] = {
    { 1.0/2.0, 0.0, 0.0 },

    { 0.0, 3.0/4.0, 0.0 },

    { 2.0/9.0, 1.0/3.0, 4.0/9.0 }
  };

  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE3_IntgData *id = (ODE3_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T hB[3];
  int_T i;
  int_T nXc = 1;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  integrator_derivatives();

  /* f(:,2) = feval(odefile, t + hA(1), y + f*hB(:,1), args(:)(*)); */
  hB[0] = h * rt_ODE3_B[0][0];
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[0]);
  rtsiSetdX(si, f1);
  integrator_step();
  integrator_derivatives();

  /* f(:,3) = feval(odefile, t + hA(2), y + f*hB(:,2), args(:)(*)); */
  for (i = 0; i <= 1; i++) {
    hB[i] = h * rt_ODE3_B[1][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1]);
  }

  rtsiSetT(si, t + h*rt_ODE3_A[1]);
  rtsiSetdX(si, f2);
  integrator_step();
  integrator_derivatives();

  /* tnew = t + hA(3);
     ynew = y + f*hB(:,3); */
  for (i = 0; i <= 2; i++) {
    hB[i] = h * rt_ODE3_B[2][i];
  }

  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (f0[i]*hB[0] + f1[i]*hB[1] + f2[i]*hB[2]);
  }

  rtsiSetT(si, tnew);
  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void integrator_step(void)
{
  if (rtmIsMajorTimeStep(integrator_M)) {
    /* set solver stop time */
    if (!(integrator_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&integrator_M->solverInfo,
                            ((integrator_M->Timing.clockTickH0 + 1) *
        integrator_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&integrator_M->solverInfo,
                            ((integrator_M->Timing.clockTick0 + 1) *
        integrator_M->Timing.stepSize0 + integrator_M->Timing.clockTickH0 *
        integrator_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(integrator_M)) {
    integrator_M->Timing.t[0] = rtsiGetT(&integrator_M->solverInfo);
  }

  /* Outport: '<Root>/Out1' incorporates:
   *  TransferFcn: '<Root>/Transfer Fcn'
   */
  integrator_Y.Out1 = integrator_P.TransferFcn_C *
    integrator_X.TransferFcn_CSTATE;
  if (rtmIsMajorTimeStep(integrator_M)) {
    rt_ertODEUpdateContinuousStates(&integrator_M->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++integrator_M->Timing.clockTick0)) {
      ++integrator_M->Timing.clockTickH0;
    }

    integrator_M->Timing.t[0] = rtsiGetSolverStopTime(&integrator_M->solverInfo);

    {
      /* Update absolute timer for sample time: [0.001s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 0.001, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      integrator_M->Timing.clockTick1++;
      if (!integrator_M->Timing.clockTick1) {
        integrator_M->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void integrator_derivatives(void)
{
  XDot_integrator_T *_rtXdot;
  _rtXdot = ((XDot_integrator_T *) integrator_M->derivs);

  /* Derivatives for TransferFcn: '<Root>/Transfer Fcn' incorporates:
   *  Inport: '<Root>/In1'
   */
  _rtXdot->TransferFcn_CSTATE = integrator_P.TransferFcn_A *
    integrator_X.TransferFcn_CSTATE;
  _rtXdot->TransferFcn_CSTATE += integrator_U.In1;
}

/* Model initialize function */
void integrator_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)integrator_M, 0,
                sizeof(RT_MODEL_integrator_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&integrator_M->solverInfo,
                          &integrator_M->Timing.simTimeStep);
    rtsiSetTPtr(&integrator_M->solverInfo, &rtmGetTPtr(integrator_M));
    rtsiSetStepSizePtr(&integrator_M->solverInfo,
                       &integrator_M->Timing.stepSize0);
    rtsiSetdXPtr(&integrator_M->solverInfo, &integrator_M->derivs);
    rtsiSetContStatesPtr(&integrator_M->solverInfo, (real_T **)
                         &integrator_M->contStates);
    rtsiSetNumContStatesPtr(&integrator_M->solverInfo,
      &integrator_M->Sizes.numContStates);
    rtsiSetNumPeriodicContStatesPtr(&integrator_M->solverInfo,
      &integrator_M->Sizes.numPeriodicContStates);
    rtsiSetPeriodicContStateIndicesPtr(&integrator_M->solverInfo,
      &integrator_M->periodicContStateIndices);
    rtsiSetPeriodicContStateRangesPtr(&integrator_M->solverInfo,
      &integrator_M->periodicContStateRanges);
    rtsiSetErrorStatusPtr(&integrator_M->solverInfo, (&rtmGetErrorStatus
      (integrator_M)));
    rtsiSetRTModelPtr(&integrator_M->solverInfo, integrator_M);
  }

  rtsiSetSimTimeStep(&integrator_M->solverInfo, MAJOR_TIME_STEP);
  integrator_M->intgData.y = integrator_M->odeY;
  integrator_M->intgData.f[0] = integrator_M->odeF[0];
  integrator_M->intgData.f[1] = integrator_M->odeF[1];
  integrator_M->intgData.f[2] = integrator_M->odeF[2];
  integrator_M->contStates = ((X_integrator_T *) &integrator_X);
  rtsiSetSolverData(&integrator_M->solverInfo, (void *)&integrator_M->intgData);
  rtsiSetIsMinorTimeStepWithModeChange(&integrator_M->solverInfo, false);
  rtsiSetSolverName(&integrator_M->solverInfo,"ode3");
  rtmSetTPtr(integrator_M, &integrator_M->Timing.tArray[0]);
  integrator_M->Timing.stepSize0 = 0.001;

  /* states (continuous) */
  {
    (void) memset((void *)&integrator_X, 0,
                  sizeof(X_integrator_T));
  }

  /* external inputs */
  integrator_U.In1 = 0.0;

  /* external outputs */
  integrator_Y.Out1 = 0.0;

  /* InitializeConditions for TransferFcn: '<Root>/Transfer Fcn' */
  integrator_X.TransferFcn_CSTATE = 0.0;
}

/* Model terminate function */
void integrator_terminate(void)
{
  /* (no terminate code required) */
}
