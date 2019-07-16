//
//  iFgetAxisY.h
//  iFootage
//
//  Created by 黄品源 on 2016/11/3.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#ifndef iFgetAxisY_h
#define iFgetAxisY_h

#include <stdio.h>
#include <math.h>


float  GETAXIS_Trace_Calculate(float time_s, __volatile float Pos[31], __volatile float T[31]);

float GETSlideLongestTIME(float slideSpacing);
float GETX2longestTIME(float x2Spacing);
float Slide_Speed_Calculate(float time_s , __volatile float Pos[31], __volatile float T[31]);
float Slide_Accelerate_Calculate(float time_s , __volatile float Pos[31], __volatile float T[31]);

float GETTimelapseSlideLongestTime(float slideSpacing);
float GETTimelapseX2LongestTime(float x2Spacing);
float GETTimelapseTiltLongestTime(float TiltLimitTime);
float GETTiltLongestTIME(float TiltLimitTime);

float S1A3_GETTimelapseSlideLongestTime(float slideSpacing);
float S1A3_GETTimelapseX2LongestTime(float x2Spacing);
float S1A3_GETTimelapseTiltLongestTime(float TiltLimitTime);

void Focus_XY_Value_Get(float Pos_A_Pan, float Pos_B_Pan, float Slider_AB_Length);


float Focus_H_Value_Get(float Pos_A_Tilt, float Pos_B_Tilt);
float Focus_Tilt_Position_Get(float Slider_AB_Length, float AAA);
float Fcous_Tilt_MinTime(float tilt_length);

#endif /* iFgetAxisY_h */
