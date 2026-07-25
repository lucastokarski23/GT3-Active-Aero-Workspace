/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: DRSsimulink.c
 *
 * Code generated for Simulink model 'DRSsimulink'.
 *
 * Model version                  : 1.7
 * Simulink Coder version         : 26.1 (R2026a) 20-Nov-2025
 * C/C++ source code generated on : Wed Jun 17 19:24:26 2026
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "DRSsimulink.h"
#include "rtwtypes.h"
#include "DRSsimulink_private.h"

/* Named constants for Chart: '<Root>/Chart' */
#define DRSsimulink_IN_Aerobrake       ((uint8_T)1U)
#define DRSsimulink_IN_DRS             ((uint8_T)2U)
#define DRSsimulink_IN_DRSArming       ((uint8_T)3U)
#define DRSsimulink_IN_Downforce       ((uint8_T)4U)

/* Block signals (default storage) */
B_DRSsimulink_T DRSsimulink_B;

/* Block states (default storage) */
DW_DRSsimulink_T DRSsimulink_DW;

/* External inputs (root inport signals with default storage) */
ExtU_DRSsimulink_T DRSsimulink_U;

/* External outputs (root outports fed by signals with default storage) */
ExtY_DRSsimulink_T DRSsimulink_Y;

/* Real-time model */
static RT_MODEL_DRSsimulink_T DRSsimulink_M_;
RT_MODEL_DRSsimulink_T *const DRSsimulink_M = &DRSsimulink_M_;
real_T look1_binlxpw(real_T u0, const real_T bp0[], const real_T table[],
                     uint32_T maxIndex)
{
  real_T frac;
  real_T yL_0d0;
  uint32_T iLeft;

  /* Column-major Lookup 1-D
     Search method: 'binary'
     Use previous index: 'off'
     Interpolation method: 'Linear point-slope'
     Extrapolation method: 'Linear'
     Use last breakpoint for index at or above upper limit: 'off'
     Remove protection against out-of-range input in generated code: 'off'
   */
  /* Prelookup - Index and Fraction
     Index Search method: 'binary'
     Extrapolation method: 'Linear'
     Use previous index: 'off'
     Use last breakpoint for index at or above upper limit: 'off'
     Remove protection against out-of-range input in generated code: 'off'
   */
  if (u0 <= bp0[0U]) {
    iLeft = 0U;
    frac = (u0 - bp0[0U]) / (bp0[1U] - bp0[0U]);
  } else if (u0 < bp0[maxIndex]) {
    uint32_T bpIdx;
    uint32_T iRght;

    /* Binary Search */
    bpIdx = maxIndex >> 1U;
    iLeft = 0U;
    iRght = maxIndex;
    while (iRght - iLeft > 1U) {
      if (u0 < bp0[bpIdx]) {
        iRght = bpIdx;
      } else {
        iLeft = bpIdx;
      }

      bpIdx = (iRght + iLeft) >> 1U;
    }

    frac = (u0 - bp0[iLeft]) / (bp0[iLeft + 1U] - bp0[iLeft]);
  } else {
    iLeft = maxIndex - 1U;
    frac = (u0 - bp0[maxIndex - 1U]) / (bp0[maxIndex] - bp0[maxIndex - 1U]);
  }

  /* Column-major Interpolation 1-D
     Interpolation method: 'Linear point-slope'
     Use last breakpoint for index at or above upper limit: 'off'
     Overflow mode: 'portable wrapping'
   */
  yL_0d0 = table[iLeft];
  return (table[iLeft + 1U] - yL_0d0) * frac + yL_0d0;
}

/* Model step function */
void DRSsimulink_step(void)
{
  /* Chart: '<Root>/Chart' incorporates:
   *  Inport: '<Root>/BrakePressure'
   *  Inport: '<Root>/Speed'
   *  Inport: '<Root>/SteeringAngle'
   *  Inport: '<Root>/Throttle'
   */
  if (DRSsimulink_DW.temporalCounter_i1 < 15) {
    DRSsimulink_DW.temporalCounter_i1++;
  }

  if (DRSsimulink_DW.is_active_c3_DRSsimulink == 0) {
    DRSsimulink_DW.is_active_c3_DRSsimulink = 1U;
    DRSsimulink_DW.is_c3_DRSsimulink = DRSsimulink_IN_Downforce;
    DRSsimulink_B.AOA = 14.0;
  } else {
    switch (DRSsimulink_DW.is_c3_DRSsimulink) {
     case DRSsimulink_IN_Aerobrake:
      DRSsimulink_B.AOA = 17.5;
      if (DRSsimulink_U.BrakePressure <= 15.0) {
        DRSsimulink_DW.is_c3_DRSsimulink = DRSsimulink_IN_Downforce;
        DRSsimulink_B.AOA = 14.0;
      }
      break;

     case DRSsimulink_IN_DRS:
      DRSsimulink_B.AOA = 0.25;
      if ((DRSsimulink_U.Throttle < 90.0) || (DRSsimulink_U.SteeringAngle >=
           10.0) || (DRSsimulink_U.BrakePressure >= 5.0)) {
        DRSsimulink_DW.is_c3_DRSsimulink = DRSsimulink_IN_Downforce;
        DRSsimulink_B.AOA = 14.0;
      }
      break;

     case DRSsimulink_IN_DRSArming:
      if (DRSsimulink_DW.temporalCounter_i1 >= 10) {
        DRSsimulink_DW.is_c3_DRSsimulink = DRSsimulink_IN_DRS;
        DRSsimulink_B.AOA = 0.25;
      } else if ((DRSsimulink_U.Throttle < 90.0) || (DRSsimulink_U.SteeringAngle
                  >= 10.0) || (DRSsimulink_U.BrakePressure >= 5.0)) {
        DRSsimulink_DW.is_c3_DRSsimulink = DRSsimulink_IN_Downforce;
        DRSsimulink_B.AOA = 14.0;
      }
      break;

     default:
      /* case IN_Downforce: */
      DRSsimulink_B.AOA = 14.0;
      if ((DRSsimulink_U.Speed > 15.0) && (DRSsimulink_U.Throttle > 95.0) &&
          (DRSsimulink_U.SteeringAngle < 5.0) && (DRSsimulink_U.BrakePressure <
           5.0)) {
        DRSsimulink_DW.temporalCounter_i1 = 0U;
        DRSsimulink_DW.is_c3_DRSsimulink = DRSsimulink_IN_DRSArming;
      } else if (DRSsimulink_U.BrakePressure > 50.0) {
        DRSsimulink_DW.is_c3_DRSsimulink = DRSsimulink_IN_Aerobrake;
        DRSsimulink_B.AOA = 17.5;
      }
      break;
    }
  }

  /* End of Chart: '<Root>/Chart' */

  /* Outport: '<Root>/Out1' incorporates:
   *  Lookup_n-D: '<Root>/1-D Lookup Table2'
   */
  DRSsimulink_Y.Out1 = look1_binlxpw(DRSsimulink_B.AOA,
    DRSsimulink_ConstP.uDLookupTable2_bp01Data,
    DRSsimulink_ConstP.uDLookupTable2_tableData, 52U);
}

/* Model initialize function */
void DRSsimulink_initialize(void)
{
  /* (no initialization code required) */
}

/* Model terminate function */
void DRSsimulink_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
