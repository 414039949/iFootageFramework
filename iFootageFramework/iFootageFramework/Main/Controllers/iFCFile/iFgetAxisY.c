//
//  iFgetAxisY.c
//  iFootage
//
//  Created by 黄品源 on 2016/11/3.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#include "iFgetAxisY.h"


/**
 * Get x sign bit only for little-endian
 * if x >= 0 then  1
 * if x <  0 then -1
 */
#define MathUtils_SignBit(x) \
(((signed char*) &x)[sizeof(x) - 1] >> 7 | 1)


__volatile float  Pos[31]={0.0};
__volatile float  T[31]={0.0};
struct Focus {
   float Pos_A_Tilt;
   float Pos_B_Tilt;
}Focus;



float  GETAXIS_Trace_Calculate(float time_s, __volatile float Pos[31], __volatile float T[31])//第n条贝塞尔曲线 n从0开始    time_s为开始运行到现在的时间 秒为单位 整段程序2ms左右计算时间
{
    uint8_t n=0; //后期根据time_s判断 第n条贝塞尔曲线
    __volatile float as,bs,cs;
    __volatile float at,bt,ct,dt;
    __volatile float trace;
    __volatile float A,B,C,Y1,Y2,t1=0,t2=0,t3=0,Temp=0,sita,t;
    
    __volatile float deta;
    
    __volatile float *Sptr;
    __volatile float *Tptr;
    
    if(time_s<=T[3])
        n=0;
    else if(time_s<=T[6])
        n=1;
    else if(time_s<=T[9])
        n=2;
    else if(time_s<=T[12])
        n=3;
    else if(time_s<=T[15])
        n=4;
    else if(time_s<=T[18])
        n=5;
    else if(time_s<=T[21])
        n=6;
    else if(time_s<=T[24])
        n=7;
    else if(time_s<=T[27])
        n=8;
    else if(time_s<=T[30])
        n=9;
    else
        n=10;              //此处n=10 判断手机端曲线不到100%时间便结束    若为10 则 speed 强制为0
    Sptr=&Pos[3*n];
    Tptr= &T[3*n];
    
    
    //    printf("\r\n第  %d  条贝塞尔曲线 \r\n",n);
    
    cs=3*( *(Sptr+1) - *Sptr );
    bs=3*( *(Sptr+2) - *(Sptr+1) ) - cs;
    as=*(Sptr+3)- *Sptr - cs - bs;
    
//      printf("Sptr%d  %f %f %f\r\n", aaa++, cs,bs,as);
    ct=3*( *(Tptr+1) - *Tptr );
    bt=3*( *(Tptr+2) - *(Tptr+1) ) - ct;
    at=*(Tptr+3)- *Tptr - ct - bt;
    dt=*Tptr-time_s ;
    
    //Run_Mode =Bezier_Mode ;
    //    printf("\r\n abcd依次为为%f,%f,%f,%f \r\n",at,bt,ct,dt);
    
    A=bt*bt-3*at*ct;
    B=bt*ct-9*at*dt;
    C=ct*ct-3*bt*dt;
    //    printf("\r\n ABC为%f,%f,%f \r\n",A,B,C);
    //        printf("\r\n deta为%f \r\n",B*B-4*A*C);
    deta=B*B-4*A*C;
    if(A==0&&B==0)
        t=-ct/bt;
    else if(deta>0)
    {
        Y1=A*bt+3*at*( -B+sqrtf(deta) )/2;
        Y2=A*bt+3*at*( -B-sqrtf(deta) )/2;
        
        t1 = (((signed char*) &Y1)[sizeof(Y1) - 1] >> 7 | 1);
        t2 = (((signed char*) &Y2)[sizeof(Y2) - 1] >> 7 | 1);
        
        t1=MathUtils_SignBit(Y1);
        t2=MathUtils_SignBit(Y2);
        
        //        printf("\r\n Y1 Y2符号 为%f    %f \r\n",t1,t2);
        t=( -bt-( t1*pow( fabs(Y1) ,1.0/3) +t2*pow( fabs(Y2),1.0/3) ) )/at/3.0;
        
    }
    else if(deta==0)
    {
        t1=-bt/at+B/A;
        t2=-B/A/2.0;
        if(t1>=0&&t1<=1)
            t=t1;
        else
            t=t2;
    }
    else             //deta<0
    {
        Temp=(2*A*bt-3*at*B)/A/2.0/sqrtf(A);
        sita =acosf(Temp);
        t1=( -bt-2*sqrtf(A)*cosf(sita/3) ) / at /3;
        t2=( -bt+sqrtf(A)*( cosf(sita/3)+sinf(sita/3)*sqrtf(3.0) ) ) / at /3;
        t3=( -bt+sqrtf(A)*( cosf(sita/3)-sinf(sita/3)*sqrtf(3.0) ) ) / at /3;
        t=t3;
        if (t1 >= -0.000001f && t1 <= 1.00000f) {
            t = t1;
        }
        if (t2 >= -0.000001f && t2 <= 1.00000f) {
            t = t2;
        }
        if (t3 >= -0.000001f && t3 <= 1.00000f) {
            t = t3;
        }

        
    }

        trace =as*t*t*t+bs*t*t+cs*t+*Sptr;
    if(time_s<=T[0])
        trace = Pos[0];
    return trace ;
}


float GETTimelapseSlideLongestTime(float slideSpacing){
    float t;
    
    if(slideSpacing >=50.0f)
    {
        t=2.0f+(slideSpacing -50.0f)/50.0f;
    }
    else
    {
        t=2.0f*sqrtf ((float)slideSpacing/50.0f);
        
    }
    return t;
    
}

float GETTimelapseX2LongestTime(float x2Spacing){
    float t;
    
    if(x2Spacing >=30.0f)
    {
        t=2.0f+(x2Spacing -30.0f)/30.0f;
    }
    else
    {
        t=2.0f*sqrtf(x2Spacing/30.0f);
    }

    return t;
}
float GETTimelapseTiltLongestTime(float TiltLimitTime){
    float t;
    if(TiltLimitTime >=30.0f)             //tilt时间限制  此处shift为绝对值
        t=4.0f+(TiltLimitTime -30.0f)/15.0f;
    else
        t=2.0f*sqrtf (TiltLimitTime/7.5f);
//    time_s =(time_s>t)?time_s:t;        //time_s取两者大值

    return t;
   
}

float GETSlideLongestTIME(float slideSpacing){

    float t;
    
    if(slideSpacing >=50.0f)
    {
        t=2.0f+(slideSpacing -50.0f)/50.0f + 1.0f;
    }
    else
    {
        t=2.0f*sqrtf ((float)slideSpacing/50.0f) + 1.0f;
        
    }
   
    return t;
}

float GETX2longestTIME(float x2Spacing){
    float t;
    
    if(x2Spacing >=30.0f)
    {
        t=3.0f+(x2Spacing -30.0f)/30.0f;
    }
    else
    {
        t=2.0f*sqrtf (x2Spacing/30.0) + 1.0f;
    }
   
    return t;
    
    /*
     if(Shifting_tilt >=30)             //tilt时间限制  此处shift为绝对值
     t=4.0+(Shifting_tilt -30)/15;
     else
     t=2.0*sqrtf (Shifting_tilt/7.5);
     time_s =(time_s>t)?time_s:t;        //time_s取两者大值
     */
}
float GETTiltLongestTIME(float TiltLimitTime){
    float t;
    if(TiltLimitTime >=30.0f)             //tilt时间限制  此处shift为绝对值
        t=4.0f+(TiltLimitTime -30.0f)/15.0f;
    else
        t=2.0f*sqrtf (TiltLimitTime/7.5f);
    //    time_s =(time_s>t)?time_s:t;        //time_s取两者大值
    return t;
}


float Slide_Speed_Calculate(float time_s , __volatile float Pos[31], __volatile float T[31])    //第n条贝塞尔曲线 n从0开始    time_s为开始运行到现在的时间 秒为单位 整段程序2ms左右计算时间
{
    
    
//    printf("2time_s = %f", T[2]);
    
    
    
    uint8_t n=0;                        //后期根据time_s判断 第n条贝塞尔曲线
    __volatile float as, bs, cs;
    __volatile float at, bt, ct, dt;
    __volatile float speed = 0.0;
    __volatile float Accelerate = 0.0;
    __volatile float A, B, C, Y1, Y2, t1 = 0, t2 = 0,t3 = 0, Temp = 0, sita, t;
    
    __volatile float deta;
    __volatile float *Sptr;
    __volatile float *Tptr;
    
    if(time_s<=T[3])
        n=0;
    else if(time_s<=T[6])
        n=1;
    else if(time_s<=T[9])
        n=2;
    else if(time_s<=T[12])
        n=3;
    else if(time_s<=T[15])
        n=4;
    else if(time_s<=T[18])
        n=5;
    else if(time_s<=T[21])
        n=6;
    else if(time_s<=T[24])
        n=7;
    else if(time_s<=T[27])
        n=8;
    else if(time_s<=T[30])
        n=9;
    else
        n=10;              //此处n=10 判断手机端曲线不到100%时间便结束    若为10 则 speed 强制为0
    Sptr=&Pos[3*n];
    Tptr= &T[3*n];
    
    //	printf("\r\n n为%d \r\n",n);
    //	printf("\r\n 距离依次为为%f,%f,%f,%f \r\n",*Sptr,*(Sptr+1),*(Sptr+2),*(Sptr+3));
    //	printf("\r\n 时间依次为为%f,%f,%f,%f \r\n",*Tptr,*(Tptr+1),*(Tptr+2),*(Tptr+3));
    //
    cs=3*( *(Sptr+1) - *Sptr );
    bs=3*( *(Sptr+2) - *(Sptr+1) ) - cs;
    as=*(Sptr+3)- *Sptr - cs - bs;
    
    ct=3*( *(Tptr+1) - *Tptr );
    bt=3*( *(Tptr+2) - *(Tptr+1) ) - ct;
    at=*(Tptr+3)- *Tptr - ct - bt;
    dt=*Tptr-time_s ;
    
    //Run_Mode =Bezier_Mode ;
    //	printf("\r\n abcd依次为为%f,%f,%f,%f \r\n",at,bt,ct,dt);
    
    A=bt*bt-3*at*ct;
    B=bt*ct-9*at*dt;
    C=ct*ct-3*bt*dt;
    //	printf("\r\n ABC为%f,%f,%f \r\n",A,B,C);
    //	printf("\r\n deta为%f \r\n",B*B-4*A*C);
    deta=B*B-4*A*C;
    if(A==0&&B==0)
        t=-ct/bt;
    else if(deta>0)
    {
        Y1=A*bt+3*at*( -B+sqrtf(deta) )/2;
        Y2=A*bt+3*at*( -B-sqrtf(deta) )/2;
        
        //		printf("\r\n Y1  Y2 为%f    %f \r\n",Y1,Y2);
        t1=MathUtils_SignBit(Y1);
        t2=MathUtils_SignBit(Y2);
        //		printf("\r\n Y1 Y2符号 为%f    %f \r\n",t1,t2);
        t=( -bt-( t1*pow( fabs(Y1) ,1.0/3) +t2*pow( fabs(Y2),1.0/3) ) )/at/3.0;
        //		printf("\r\n t为%f \r\n",t);
    }
    else if(deta==0)
    {
        t1=-bt/at+B/A;
        t2=-B/A/2.0;
        if(t1>=0&&t1<=1)
            t=t1;
        else
            t=t2;
    }
    else             //deta<0
    {
        Temp=(2*A*bt-3*at*B)/A/2.0/sqrtf(A);
        sita =acosf(Temp);
        t1=( -bt-2*sqrtf(A)*cosf(sita/3) ) / at /3;
        t2=( -bt+sqrtf(A)*( cosf(sita/3)+sinf(sita/3)*sqrtf(3.0) ) ) / at /3;
        t3=( -bt+sqrtf(A)*( cosf(sita/3)-sinf(sita/3)*sqrtf(3.0) ) ) / at /3;
        
        t=t3;
        if (t1 >= -0.000001f && t1 <= 1.00000f) {
            t = t1;
        }
        if (t2 >= -0.000001f && t2 <= 1.00000f) {
            t = t2;
        }
        if (t3 >= -0.000001f && t3 <= 1.00000f) {
            t = t3;
        }
        
        
    }
    
    
//    if(n<=Num_Bezier-1)
//        Position_Need =as*t*t*t+bs*t*t+cs*t+*Sptr;
//    else
//        Position_Need = Pos[3*Num_Bezier ];
    
    speed=(3*as*t*t+2*bs*t+cs)/(3*at*t*t+2*bt*t+ct);
    
    Accelerate=    ((6*as*bt-6*bs*at)*t*t+(6*as*ct-6*cs*at)*t-2*cs*bt+2*bs*ct)/(9*at*at*t*t*t*t+12*at*bt*t*t*t+(4*bt*bt+6*ct*at)*t*t+4*ct*bt*t+ct*ct)/(3*at*t*t+2*bt*t+ct);
    
    
//
//    if (Accelerate > 100.0f) {
//        printf("零之前加速度%f %f \r\n", Accelerate, time_s);
//    }
    
    
    if(n==10 || time_s<=T[0]){
    
        speed = 0;
    
    }
//    printf("+++++++++++++++++\r\n");
//    printf("零之后速度%f", speed);
    
    //		printf("\r\n t为%f \r\n",t);
    //	printf("\r\n t2为%f \r\n",t2);
    //	printf("\r\n t3为%f \r\n",t3);
    //	printf("\r\n deta为%f \r\n",deta);
    //		printf("\r\n speed为%d \r\n",speed);while(1);
    
    //	printf("\r\n t3为%f \r\n",t3);
    return speed ;
    
}
float Slide_Accelerate_Calculate(float time_s , __volatile float Pos[31], __volatile float T[31])    //第n条贝塞尔曲线 n从0开始    time_s为开始运行到现在的时间 秒为单位 整段程序2ms左右计算时间
{
    
    
    //    printf("2time_s = %f", T[2]);
    
    
    
    uint8_t n=0;                        //后期根据time_s判断 第n条贝塞尔曲线
    __volatile float as, bs, cs;
    __volatile float at, bt, ct, dt;
    __volatile float speed = 0.0;
    __volatile float Accelerate = 0.0;
    __volatile float A, B, C, Y1, Y2, t1 = 0, t2 = 0,t3 = 0, Temp = 0, sita, t;
    
    __volatile float deta;
    __volatile float *Sptr;
    __volatile float *Tptr;
    
    if(time_s<=T[3])
        n=0;
    else if(time_s<=T[6])
        n=1;
    else if(time_s<=T[9])
        n=2;
    else if(time_s<=T[12])
        n=3;
    else if(time_s<=T[15])
        n=4;
    else if(time_s<=T[18])
        n=5;
    else if(time_s<=T[21])
        n=6;
    else if(time_s<=T[24])
        n=7;
    else if(time_s<=T[27])
        n=8;
    else if(time_s<=T[30])
        n=9;
    else
        n=10;              //此处n=10 判断手机端曲线不到100%时间便结束    若为10 则 speed 强制为0
    Sptr=&Pos[3*n];
    Tptr= &T[3*n];
    
    //    printf("\r\n n为%d \r\n",n);
    //    printf("\r\n 距离依次为为%f,%f,%f,%f \r\n",*Sptr,*(Sptr+1),*(Sptr+2),*(Sptr+3));
    //    printf("\r\n 时间依次为为%f,%f,%f,%f \r\n",*Tptr,*(Tptr+1),*(Tptr+2),*(Tptr+3));
    //
    cs=3*( *(Sptr+1) - *Sptr );
    bs=3*( *(Sptr+2) - *(Sptr+1) ) - cs;
    as=*(Sptr+3)- *Sptr - cs - bs;
    
    ct=3*( *(Tptr+1) - *Tptr );
    bt=3*( *(Tptr+2) - *(Tptr+1) ) - ct;
    at=*(Tptr+3)- *Tptr - ct - bt;
    dt=*Tptr-time_s ;
    
    //Run_Mode =Bezier_Mode ;
    //    printf("\r\n abcd依次为为%f,%f,%f,%f \r\n",at,bt,ct,dt);
    
    A=bt*bt-3*at*ct;
    B=bt*ct-9*at*dt;
    C=ct*ct-3*bt*dt;
    //    printf("\r\n ABC为%f,%f,%f \r\n",A,B,C);
    //    printf("\r\n deta为%f \r\n",B*B-4*A*C);
    deta=B*B-4*A*C;
    if(A==0&&B==0)
        t=-ct/bt;
    else if(deta>0)
    {
        Y1=A*bt+3*at*( -B+sqrtf(deta) )/2;
        Y2=A*bt+3*at*( -B-sqrtf(deta) )/2;
        
        //        printf("\r\n Y1  Y2 为%f    %f \r\n",Y1,Y2);
        t1=MathUtils_SignBit(Y1);
        t2=MathUtils_SignBit(Y2);
        //        printf("\r\n Y1 Y2符号 为%f    %f \r\n",t1,t2);
        t=( -bt-( t1*pow( fabs(Y1) ,1.0/3) +t2*pow( fabs(Y2),1.0/3) ) )/at/3.0;
        //        printf("\r\n t为%f \r\n",t);
    }
    else if(deta==0)
    {
        t1=-bt/at+B/A;
        t2=-B/A/2.0;
        if(t1>=0&&t1<=1)
            t=t1;
        else
            t=t2;
    }
    else             //deta<0
    {
        Temp=(2*A*bt-3*at*B)/A/2.0/sqrtf(A);
        sita =acosf(Temp);
        t1=( -bt-2*sqrtf(A)*cosf(sita/3) ) / at /3;
        t2=( -bt+sqrtf(A)*( cosf(sita/3)+sinf(sita/3)*sqrtf(3.0) ) ) / at /3;
        t3=( -bt+sqrtf(A)*( cosf(sita/3)-sinf(sita/3)*sqrtf(3.0) ) ) / at /3;
        
        t=t3;
    }
    
    
    //    if(n<=Num_Bezier-1)
    //        Position_Need =as*t*t*t+bs*t*t+cs*t+*Sptr;
    //    else
    //        Position_Need = Pos[3*Num_Bezier ];
    
    speed=(3*as*t*t+2*bs*t+cs)/(3*at*t*t+2*bt*t+ct);
    
    Accelerate=    ((6*as*bt-6*bs*at)*t*t+(6*as*ct-6*cs*at)*t-2*cs*bt+2*bs*ct)/(9*at*at*t*t*t*t+12*at*bt*t*t*t+(4*bt*bt+6*ct*at)*t*t+4*ct*bt*t+ct*ct)/(3*at*t*t+2*bt*t+ct);
    
    
    //
//    if (Accelerate > 100.0f) {
//        printf("零之前加速度%f %f \r\n", Accelerate, time_s);
//    }
    
    
    if(n==10 || time_s<=T[0]){
        
        speed = 0;
        
    }
    //    printf("+++++++++++++++++\r\n");
    //    printf("零之后速度%f", speed);
    
    //        printf("\r\n t为%f \r\n",t);
    //    printf("\r\n t2为%f \r\n",t2);
    //    printf("\r\n t3为%f \r\n",t3);
    //    printf("\r\n deta为%f \r\n",deta);
    //        printf("\r\n speed为%d \r\n",speed);while(1);
    
    //    printf("\r\n t3为%f \r\n",t3);
    return Accelerate ;

}

float S1A3_GETTimelapseSlideLongestTime(float slideSpacing){
    float t;
    
    
    if(slideSpacing >= 256.0f)
    {
        
        t=3.2f+(slideSpacing - 256.0f) / 160.0f;
    }
    else
    {
        t=0.1*sqrtf((float)slideSpacing * 2);
    }
    
    return t;
}
float S1A3_GETTimelapseX2LongestTime(float x2Spacing){
    
    float t;
    if(x2Spacing >=20.0f)
    {
        t=2.0f+( x2Spacing -20.0f) / 40.0f;
    }
    else
    {
        t=sqrtf (x2Spacing / 20.0f);
    }
    return t;
    
    
}

float S1A3_GETTimelapseTiltLongestTime(float TiltLimitTime){
    float t;
    
    if(TiltLimitTime >=20.0f)
    {
        t=2.0f+(TiltLimitTime -20.0f)/40.0f;
    }
    else
    {
        t=sqrtf (TiltLimitTime/20.0f);
    }
    return t;
    
}
float Fcous_Tilt_MinTime(float tilt_length){
    float t;
    if (tilt_length >= 30) {
        t = 4.0 +(tilt_length - 30) / 15;
    }else{
        t = 2.0 +(tilt_length / 7.5);
    }
    return t;
}


//Focus.Pos_A_Pan  B_Pan均为真实值+360度     A_Tilt  B_Tilt 均为真实值+35度
float Focus_X_Value = 0.0, Focus_Y_Value = 0.0 ,Focus_H_Value_A = 0.0, Focus_H_Value_B = 0.0 ;
/************************************************************/
void Focus_XY_Value_Get(float Pos_A_Pan, float Pos_B_Pan, float Slider_AB_Length)     //通过运算得到物体相对于导轨左端点的 XY值 单位 mm
{
    
    float alpha_left=0.0,alpha_right=0.0;
    if(Pos_A_Pan>Pos_B_Pan)     //大值为左
    {
        alpha_left=(450.0f-Pos_A_Pan)/180.0f*3.14159265f;
        alpha_right=(450.0f- Pos_B_Pan)/180.0f*3.14159265f;
        if(Pos_A_Pan==360.0f)   //物体在导轨左端点正上方
        {
            Focus_X_Value=0.0;
            Focus_Y_Value=-1*Slider_AB_Length*(tanf)(alpha_right) ;
        }
        else if(Pos_B_Pan ==360.0f)
        {
            Focus_X_Value=Slider_AB_Length;
            Focus_Y_Value=Slider_AB_Length*(tanf)(alpha_left) ;
        }
        else
        {
            Focus_X_Value=Slider_AB_Length*tanf(alpha_right)/(tanf(alpha_right)-tanf(alpha_left));
            Focus_Y_Value=Focus_X_Value*tanf(alpha_left);
        }
    }
    else
    {
        alpha_left=(450.0f-Pos_B_Pan)/180.0f*3.14159265f;
        alpha_right=(450.0f-Pos_A_Pan)/180.0f*3.14159265f;
        if(Pos_B_Pan==360.0f)   //物体在导轨左端点正上方
        {
            Focus_X_Value=0.0;
            Focus_Y_Value=-1*Slider_AB_Length*(tanf)(alpha_right) ;
        }
        else if(Pos_A_Pan ==360.0f)
        {
            Focus_X_Value=Slider_AB_Length;
            Focus_Y_Value=Slider_AB_Length*(tanf)(alpha_left) ;
        }
        else
        {
            Focus_X_Value=Slider_AB_Length*tanf(alpha_right)/(tanf(alpha_right)-tanf(alpha_left));
            Focus_Y_Value=Focus_X_Value*tanf(alpha_left);
        }
    }
    //printf("\r\n 物体相对位置为（%f，%f)  \r\n",Focus_X_Value,Focus_Y_Value);
}

float Focus_H_Value_Get(float Pos_A_Tilt, float Pos_B_Tilt)

{
    Focus_H_Value_A=sqrt(Focus_X_Value*Focus_X_Value+Focus_Y_Value*Focus_Y_Value)*tan((Pos_A_Tilt - 35.0f)/180.0f*3.14159265f);
    Focus_H_Value_B=sqrt(Focus_X_Value*Focus_X_Value+Focus_Y_Value*Focus_Y_Value)*tan((Pos_B_Tilt - 35.0f)/180.0f*3.14159265f);
    return Focus_H_Value_A;
}


float Focus_Tilt_Position_Get(float Slider_AB_Length, float AAA)//计算FocusMode Tilt的实际角度   以 导轨A点为原点   被拍摄物体在导轨前方 以A点对应的高度为基础计算B点TIlt值，其余情况不成立
{
    
    float alpha_tilt=0.0f;
    alpha_tilt =atan(AAA / sqrt( (Focus_X_Value-Slider_AB_Length)*(Focus_X_Value-Slider_AB_Length)+Focus_Y_Value*Focus_Y_Value )) /3.14159265f *180.0f +35.0f;
    return alpha_tilt ;
}
//struct 
/************************************************************/


