/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: DRSsimulink.h
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

#ifndef DRSsimulink_h_
#define DRSsimulink_h_
#ifndef DRSsimulink_COMMON_INCLUDES_
#define DRSsimulink_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "math.h"
#endif                                 /* DRSsimulink_COMMON_INCLUDES_ */

#include "DRSsimulink_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

/* Block signals (default storage) */
typedef struct {
  real_T AOA;                          /* '<Root>/Chart' */
} B_DRSsimulink_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  uint8_T is_active_c3_DRSsimulink;    /* '<Root>/Chart' */
  uint8_T is_c3_DRSsimulink;           /* '<Root>/Chart' */
  uint8_T temporalCounter_i1;          /* '<Root>/Chart' */
} DW_DRSsimulink_T;

/* Constant parameters (default storage) */
typedef struct {
  /* Expression: AOAConv
   * Referenced by: '<Root>/1-D Lookup Table2'
   */
  real_T uDLookupTable2_tableData[53];

  /* Expression: ServoConv
   * Referenced by: '<Root>/1-D Lookup Table2'
   */
  real_T uDLookupTable2_bp01Data[53];
} ConstP_DRSsimulink_T;

/* External inputs (root inport signals with default storage) */
typedef struct {
  real_T BrakePressure;                /* '<Root>/BrakePressure' */
  real_T Speed;                        /* '<Root>/Speed' */
  real_T SteeringAngle;                /* '<Root>/SteeringAngle' */
  real_T Throttle;                     /* '<Root>/Throttle' */
} ExtU_DRSsimulink_T;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  real_T Out1;                         /* '<Root>/Out1' */
} ExtY_DRSsimulink_T;

/* Real-time Model Data Structure */
struct tag_RTM_DRSsimulink_T {
  const char_T * volatile errorStatus;
};

/* Block signals (default storage) */
extern B_DRSsimulink_T DRSsimulink_B;

/* Block states (default storage) */
extern DW_DRSsimulink_T DRSsimulink_DW;

/* External inputs (root inport signals with default storage) */
extern ExtU_DRSsimulink_T DRSsimulink_U;

/* External outputs (root outports fed by signals with default storage) */
extern ExtY_DRSsimulink_T DRSsimulink_Y;

/* Constant parameters (default storage) */
extern const ConstP_DRSsimulink_T DRSsimulink_ConstP;

/* Model entry point functions */
extern void DRSsimulink_initialize(void);
extern void DRSsimulink_step(void);
extern void DRSsimulink_terminate(void);

/* Real-time Model object */
extern RT_MODEL_DRSsimulink_T *const DRSsimulink_M;

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
 * '<Root>' : 'DRSsimulink'
 * '<S1>'   : 'DRSsimulink/Chart'
 */
#endif                                 /* DRSsimulink_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
