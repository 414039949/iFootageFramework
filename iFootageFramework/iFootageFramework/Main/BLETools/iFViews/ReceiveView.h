//
//  ReceiveView.h
//  BLECollection
//
//  Created by rfstar on 14-1-8.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "iFStatusBarView.h"




typedef struct {
   
    __volatile float a;
    __volatile UInt8 b[4];
    
}FloatTransformation;






@interface ReceiveView : UIView
{
    AppDelegate       *appDelegate;
    long              receiveByteSize;  //返回数据的长度
    int               countPKSSize;     //计算收到数据包的次数
    NSMutableString   *receiveSBString;  //接收到的数据
    Boolean           isReceive;       //是否继续接收发过来的数据
    NSInteger         SBLength;            //控制显示字符的长度
    BOOL              IsAscii ;          //默认为Ascii显示
    FloatTransformation  _floatTran;
        
    
}

@property(nonatomic, strong)UITextView           *receiveDataTxt;
@property(nonatomic, strong)UILabel              *bytesSizeLabel,*PKSSizeLabel;

@property    UInt16            TrackRealTimePosition;//track的实时位置
@property    UInt16            TrackfinalPosition;//track的终点位置
@property    UInt16            TrackRealTimeVeloc;//track的实时速度


@property    UInt16            panRealTimePostion;// pan的实时位置
@property    UInt16            tiltRealTimePostion;// tilt 的实时位置
@property    UInt16            panRealTimeVeloc;//pan的实时速度
@property    UInt16            tiltRealTimeVeloc;//tilt的实时速度


#pragma mark - 贝塞尔曲线的传输判断参数
/**
 *  0 回位  1 完成
 */
@property UInt8 iSGetReady;

/**
 *  0 待机 1 动作中 2 完成
 */
@property UInt8 MissionState;

/**
 *  0xff 有曲线数据 0x00 或者其他  无数据 数据不全
 */
@property UInt8 iSTransfer;
/**
 *  参数是否传输成功 0x01 有数据 0 无数据
 */
@property UInt8 iSSuccessSet;

/**
 *  导轨的实时位置
 */
@property UInt16 SliderRealTimePosition;
/**
 *  已拍摄张数
 */
@property UInt32 RealTimesFrames;


@property UInt8 iSX2GetReady;
@property UInt8 X2MissionState;

@property UInt8 iSX2panTransfer;
@property UInt8 isX2tiltTransfer;
@property UInt8 isX2SuccessSet;

@property UInt16 X2panRealTimePosition;//pan的实时位置 单位°
@property UInt16 X2tiltRealTimePosition;//tilt的实时位置 单位°
@property UInt32 X2RealTimesFrams;



/**
 slide任务标志
 */
@property (nonatomic, assign) UInt8 slideModeID;

/**
 slide开始时间戳
 */
@property (nonatomic, assign) UInt32 slideTimer;

/**
 slide接收模式参数
 */
@property UInt8 slidereceiveMode;

/**
 slide接收到贝塞尔曲线信息
 */
@property UInt8 slidebezierPosParam;

/**
 slide时间（帧数）参数
 */
@property UInt8 slidebezierTimeParam;

/**
 slideTimelapse的参数
 */
@property UInt32 slideframes;

@property UInt32 slideTotalFrames;

@property UInt32 x2TotalFrames;

@property (nonatomic, assign)UInt8 slideIsloop;
@property (nonatomic, assign)UInt8 x2Isloop;

@property UInt8 S1timelineIsVideo;
@property UInt8 X2timelineIsVideo;
@property UInt8 S1timelinePercent;
@property UInt8 X2timelinePercent;

/**
 x2任务标志
 */
@property (nonatomic, assign) UInt8  x2ModeID;

/**
 x2开始时间戳
 */
@property UInt32 x2Timer;

/**
 x2接收模式参数
 */
@property UInt8 x2receiveMode;

/**
 pan的贝塞尔位置
 */
@property UInt8 panbezierPosParam;

/**
 pan的贝塞尔时间（帧数）
 */
@property UInt8 panbezierTimeParam;

/**
 tilt的贝塞尔位置
 */
@property UInt8 tiltbezierPosParam;
/**
 tilt的贝塞尔时间（帧数）
 */
@property UInt8 tiltbezierTimerParam;
/**
 x2总帧数
 */
@property UInt32 x2frames;



@property UInt32 slideVideoTime;

@property UInt32 x2VideoTime;

/**
 slide StopMotion 的当前模式
 */
@property UInt8 slideStopMotionMode;

/**
 slide StopMotion 的当前帧
 */
@property UInt32 slideStopMotionCurruntFrame;

/**
 x2 StopMotion 的当前模式
 */
@property UInt8 x2StopMotionTimeMode;

/**
 x2 StopMotion 的当前帧
 */
@property UInt32 x2StopMotionCurruntFrame;


/**
 Gigaplexl
 */
@property UInt8 Gimode;
@property UInt16 GipanRealAngle;
@property UInt16 GitiltRealAngle;
@property UInt16 GipanStartAngle;
@property UInt16 GitiltStartAngle;
@property UInt16 GipanEndAngle;
@property UInt16 GitiltEndAngle;
@property UInt16 GiFrameCurrent;
@property UInt8 GiInterval;


/**
 Panorama
 */
@property UInt8 Pamode;
@property UInt16 PaAngle;
@property UInt16 PaStartAngle;
@property UInt16 PaEndAngle;
@property UInt16 PaFrameCurrent;
@property UInt8 PaInterval;

/**
 版本更新
 */
@property UInt16 updateBytesNumber;
@property UInt8 updateMode;
@property UInt16 X2UpdateBytesNumber;
@property UInt64 X2PositionInfo;


@property UInt16 slideUpdateBytesNumber;
@property UInt8 slideUpdateMode;
@property UInt64 slidePositionInfo;

@property (nonatomic, copy)NSString * notiStr;


/**
 设备信息
 */
@property UInt32 X2ProNumber;
@property (nonatomic, copy)NSString * X2proStr;


/**
 X2版本号
 */
@property (nonatomic, assign)UInt8 X2version;
@property (nonatomic, assign)UInt8 X2isUpdateMode;

@property (nonatomic, assign)UInt64 X2_2_4GAddress;



@property UInt8 sectionsNumber;
@property UInt8 X2battery;
@property UInt32 X2bootCount;
@property (nonatomic, assign)UInt8 X2isConnect_24G;
@property UInt8 X2isConnect5V;




@property (nonatomic, copy)NSString * S1proStr;

@property UInt32 slideProNumber;

@property (nonatomic, assign)UInt64 slide_2_4GAddress;

@property (nonatomic, assign)UInt8 slideversion;
@property UInt8 slideisUpdateMode;
@property UInt8 slidesectionNumber;
@property UInt8 slideBattery;
@property UInt8 slidebootCount;
@property (nonatomic, assign)UInt8 slideisConnect_24G;
@property UInt8 slideisConnect5V;


/**
 0XAAAA 0X09
 */
@property UInt8 FMslideMode;

@property NSInteger FMslide_AB_Mark;


@property UInt16 FMslideVeloc;
@property UInt32 FMslideRealPosition;
@property UInt32 FMslideApointPosition;
@property UInt32 FMslideBpointPosition;
@property UInt16 FMslideTotalTime;


/**
 0XAAAA 0X0A
 */
@property UInt8 FMTaskslideMode;

@property UInt32 FMtaskslideStarttime;
@property UInt16 FMtaskslideRuntime;
@property UInt8 FMtaskslideisloop;
@property UInt8 FMtaskslidedirection;
@property UInt32 FMtaskslideRealPosition;
//新加的
@property UInt8 FMtaskSlideisMarkA_B;
@property UInt8 FMtaskSlidePercent;
@property UInt8 FMtaskSlideSmoothnessLevel;



/**
 0X555F 0X09
 */
@property UInt8 FMx2Mode;
@property NSInteger FMx2_AB_Mark;

@property UInt16 FMx2PanVeloc;
@property UInt16 FMx2tiltVeloc;

@property UInt16 FMx2RealPanAngle;
@property UInt16 FMx2RealTiltAngle;

@property UInt16 FMx2RecordPanAngle;
@property UInt16 FMx2RecordTiltAngle;

@property UInt16 FMx2Totaltime;


/**
 0X555F 0X0A
 */
@property UInt8 FMx2taskMode;
@property UInt32 FMx2taskStarttime;
@property UInt16 FMx2taskRuntime;
@property UInt8 FMx2taskisloop;
@property UInt8 FMx2taskdirection;
@property UInt16 FMx2taskPanRealAngle;
@property UInt16 FMx2taskTiltRealAngle;
//新加的
@property UInt8 FMx2taskisMarkA_B;
@property UInt8 FMx2taskPercent;
@property UInt8 FMx2taskSmoothnessLevel;



//===========分割线=======================

@property UInt64 slide24GAdress;
@property UInt64 x224GAdress;


@property BOOL isReturnZero;

@property UInt8  S1checkZeroMode;
@property UInt16 S1checkZeroRealPosition;
@property UInt16 S1checkZeroRealVeloc;
@property UInt16 S1checkZeroLeftSensorStandardValue;
@property UInt16 S1checkZeroRightSensorStandardValue;
@property UInt16 S1checkZeroLeftSensorRealValue;
@property UInt16 S1checkZeroRightSensorRealValue;

@property UInt8 X2checkZeroMode;
@property BOOL isX2ReturnWarning;


/**
 功能字MODE
 */
@property(nonatomic, assign) UInt8 S1MODE;
@property(nonatomic, assign) UInt8 X2MODE;


@property UInt8 X2isReturnOnSlide;


#pragma mark ------------ S1A3属性 ---------

@property(nonatomic, assign) UInt8 S1A3_S1MODE;
@property(nonatomic, assign) UInt8 S1A3_X2MODE;


/**
 AAAF 0X00
 */
@property(nonatomic, assign)UInt32 S1A3_S1_ProNumber;
@property(nonatomic, copy)NSString * S1A3_S1_proStr;

@property(nonatomic, assign)UInt64 S1A3_S1_2_4GAddress;
@property(nonatomic, assign)UInt8 S1A3_S1_Version;
@property(nonatomic, assign)UInt8 S1A3_S1_TrackNumber;
@property(nonatomic, assign)UInt8 S1A3_S1_BatteryNum;
@property(nonatomic, assign)UInt8 S1A3_S1_isConnect_24G;


/**
 555F 0X00
 */
@property(nonatomic, assign)UInt32 S1A3_X2_ProNumber;
@property(nonatomic, copy)NSString * S1A3_X2_proStr;

@property(nonatomic, assign)UInt64 S1A3_X2_2_4GAddress;
@property(nonatomic, assign)UInt8 S1A3_X2_Version;
@property(nonatomic, assign)UInt8 S1A3_X2_BatteryNum;
@property(nonatomic, assign)UInt8 S1A3_X2_isConnect_24G;


/**
 AAAF 0x01
 */
@property(nonatomic, assign)UInt16 S1A3_S1_TrackRealPosition;
@property(nonatomic, assign)UInt16 S1A3_S1_TrackLength;
@property(nonatomic, assign)UInt16 S1A3_S1_TrackRealVeloc;

/**
 555F 0X01
 */
@property(nonatomic, assign)UInt16 S1A3_X2_PanRealPosition;
@property(nonatomic, assign)UInt16 S1A3_X2_PanRealVeloc;
@property(nonatomic, assign)UInt16 S1A3_X2_TiltRealPosition;
@property(nonatomic, assign)UInt16 S1A3_X2_TiltRealVeloc;
/*
 AAAF 0X02
 u8 data[3] 0  1  2   3  4（任务标志）
 u32 data[4-7]开始时间戳低32 ms
 u8 data[8] 0 1      接受模式参数
 u8 data[9] 0 0xff   贝塞尔位移参数
 u8 data[10] 0 ff    贝塞尔时间参数
 u32 data[11-14] Frames(Timelapse参数)
 u8 data[17]  video 百分比   高8位=1 video
 u8 data[18]  是否循环运行 1循环
 */
@property(nonatomic, assign)UInt8 S1A3_S1_Timeline_TaskMode;
@property(nonatomic, assign)UInt32 S1A3_S1_Timeline_StartTimer;
@property(nonatomic, assign)UInt8 S1A3_S1_Timeline_ReceiveMode;
@property(nonatomic, assign)UInt8 S1A3_S1_Timeline_BezierPosParam;
@property(nonatomic, assign)UInt8 S1A3_S1_Timeline_BezierTimeParam;
@property(nonatomic, assign)UInt32 S1A3_S1_Timeline_Frames;
@property(nonatomic, assign)UInt8 S1A3_S1_Timeline_TimelineIsVideo;
@property(nonatomic, assign)UInt8 S1A3_S1_Timeline_TimelinePercent;
@property(nonatomic, assign)UInt8 S1A3_S1_Timeline_Isloop;

/**
 AAAF 0X03
 u16 data[3-4] Interval
 u16 data[5-6]  Exposure
 u32 data[7-10] Frames
 u8 data[11]   Mode
 u8 data[12]  NumBezier
 u16 data[13-14] Buffer_second
 */
@property(nonatomic, assign)UInt16 S1A3_S1_Timelapse_Interval;
@property(nonatomic, assign)UInt16 S1A3_S1_Timelapse_Exposure;
@property(nonatomic, assign)UInt32 S1A3_S1_Timelapse_TotalFrames;
@property(nonatomic, assign)UInt8 S1A3_S1_Timelapse_FunctionMode;
@property(nonatomic, assign)UInt8 S1A3_S1_Timelapse_NumBezier;
@property(nonatomic, assign)UInt16 S1A3_S1_Timelapse_Buffer_second;
/*
 AAAF 0X04
 u32 data[3-6]  Time
 u8 data[12]  NumBezier
 */
@property(nonatomic, assign)UInt32 S1A3_S1_Video_TotalTime;
@property(nonatomic, assign)UInt8 S1A3_S1_Video_NumBezier;

/**
 AAAF 0X05
 u8 data[3] 0  1  2   3  4
 
 u32 data[11-14] Frame_Now
 */
@property(nonatomic, assign)UInt8 S1A3_S1_StopMotion_Mode;
@property(nonatomic, assign)UInt32 S1A3_S1_StopMotion_CurrentFrame;

/**
 AAAF 0X06
 float data[3-6] slider位置
 */
@property(nonatomic, assign)UInt32 S1A3_S1_PreView_Position;
/*
 AAAF 0X09
 u8 data[3] 0B 0000  00AB
 u16 data[4-5] Slier速度*100+5000
 
 u32 data[6-9] Slider位置mm*100（实时）
 
 u16 data[12-13] Slider位置mm（A点）
 u16 data[14-15] Slider位置mm（B点）
 u16 data[17-18] 总运行时间 秒
 */
@property(nonatomic, assign)UInt8 S1A3_S1_Target_Mode;
@property(nonatomic, assign)UInt16 S1A3_S1_Target_Veloc;
@property(nonatomic, assign)UInt32 S1A3_S1_Target_RealPosition;
@property(nonatomic, assign)UInt16 S1A3_S1_Target_A_Position;
@property(nonatomic, assign)UInt16 S1A3_S1_Target_B_Position;
@property(nonatomic, assign)UInt16 S1A3_S1_Target_totaltime;
/*
 AAAF 0X09
 u8 data[3] 0  1  2   3  4（任务标志）
 u32 data[4-7]开始时间戳低32 ms
 u16 data[8-9]已运行时间 秒
 u8 data[10] 循环标志
 u8 data[11] 开始方向 1.向左 2.向右
 u32 data[12-15] Slider位置mm*100（实时）
 u8 data[16] 0B 0000  00AB
 u8 data[17] 任务百分比
 u8 data[18] 淡入淡出等级
 */
@property(nonatomic, assign)UInt8 S1A3_S1_Target_Task_Mode;
@property(nonatomic, assign)UInt32 S1A3_S1_Target_Task_StartTime;
@property(nonatomic, assign)UInt16 S1A3_S1_Target_Task_RunTime;

@property(nonatomic, assign)UInt16 S1A3_S1_Target_Task_Isloop;
@property(nonatomic, assign)UInt8 S1A3_S1_Target_Task_Direction;
@property(nonatomic, assign)UInt32 S1A3_S1_Target_Task_RealPosition;
@property(nonatomic, assign)UInt8 S1A3_S1_Target_Task_IsMark_A_B;
@property(nonatomic, assign)UInt8 S1A3_S1_Target_Task_Percent;
@property(nonatomic, assign)UInt8 S1A3_S1_Target_Task_SmoothLevel;

/*
 AAAF 0X0B
 u64 data[6-10]  时间戳后5个8位
 */
@property(nonatomic, assign)UInt64 S1A3_S1_2_4GAddress_TimeStamp;

/*
 AAAF 0X0C
 checkZero
 
 u8 data[3] 0 1 2 3 4
 u8 data[4]
 u16 data[5-6]导轨实时位置     mm*10
 u16 data[7-8]导轨实时速度  v+500  mm/s
 u16 data[9-10]导轨左传感器基准（2048+-100）
 u16 data[11-12]导轨右基准(2048+-100)
 
 u16 data[13-14]导轨左传感器值（0-4096）
 u16 data[15-16]导轨右值(0-4096)
 */
@property(nonatomic, assign)UInt8 S1A3_S1_CheckZero_Mode;
@property(nonatomic, assign)UInt16 S1A3_S1_CheckZero_RealPosition;
@property(nonatomic, assign)UInt16 S1A3_S1_CheckZero_RealVeloc;
@property(nonatomic, assign)UInt16 S1A3_S1_CheckZero_Sensor_LeftStandard;
@property(nonatomic, assign)UInt16 S1A3_S1_CheckZero_Sensor_RightStandard;
@property(nonatomic, assign)UInt16 S1A3_S1_CheckZero_LeftValue;
@property(nonatomic, assign)UInt16 S1A3_S1_CheckZero_RightValue;


/*
 AAAF 0XAB
 self.slideUpdateBytesNumber = buf1.buff[1] * 256 + buf1.buff[2];
 self.slideUpdateMode = buf1.buff[3];
 self.slidePositionInfo
*/

@property (nonatomic, assign)UInt16 S1A3_S1_UpdateBytesNumber;
@property (nonatomic, assign)UInt8 S1A3_S1_UpdateMode;
@property (nonatomic, assign)UInt64 S1A3_S1_PositionInfo;


/*555F 0x56
 
 */

@property (nonatomic, assign)UInt16 S1A3_X2_UpdateBytesNumber;
@property (nonatomic, assign)UInt8 S1A3_X2_UpdateMode;
@property (nonatomic, assign)UInt64 S1A3_X2_PositionInfo;


/*
 
 
 555f 0x02
 timeline
 u8 data[3] 0  1  2   3  4（任务标志）
 
 u32 data[4-7]开始时间戳低32 ms
 u8 data[8] 0 1
 u8 data[9] 0 0xff   贝塞尔位移参数
 u8 data[10] 0 ff    贝塞尔时间参数
 u8 data[11] 0 0xff   贝塞尔位移参数
 u8 data[12] 0 ff    贝塞尔时间参数
 u32 data[13-16] Frames(Timelapse参数)
 u8 data[17]  video 百分比   高8位=1 video
 u8 data[18] 是否循环运行
 */
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_TaskMode;
@property(nonatomic, assign)UInt32 S1A3_X2_Timeline_StartTimer;
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_ReceiveMode;

@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_Pan_BezierPosParam;
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_Pan_BezierTimeParam;
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_Tilt_BezierPosParam;
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_Tilt_BezierTimeParam;

@property(nonatomic, assign)UInt32 S1A3_X2_Timeline_Frames;
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_TimelineIsVideo;
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_TimelinePercent;
@property(nonatomic, assign)UInt8 S1A3_X2_Timeline_Isloop;

/*
 555f 0x03
 Timelapse
 Set
 u16 data[3-4] Interval
 u16 data[5-6]  Exposure
 u32 data[7-10] Frames
 u8 data[11]   Mode
 u8 data[12-13]  NumBezier.Pan—Tilt
 u16 data[14-15] Buffer_second
 */
@property(nonatomic, assign)UInt16 S1A3_X2_Timelapse_Interval;
@property(nonatomic, assign)UInt16 S1A3_X2_Timelapse_Exposure;
@property(nonatomic, assign)UInt32 S1A3_X2_Timelapse_TotalFrames;
@property(nonatomic, assign)UInt8 S1A3_X2_Timelapse_FunctionMode;
@property(nonatomic, assign)UInt8 S1A3_X2_Timelapse_NumBezier;
@property(nonatomic, assign)UInt16 S1A3_X2_Timelapse_Buffer_second;
/*
 555F 0X04
 u32 data[3-6]  Time
 u8 data[12-13]  NumBezier.Pan—Tilt
 */
@property(nonatomic, assign)UInt32 S1A3_X2_Video_TotalTime;
@property(nonatomic, assign)UInt8 S1A3_X2_Video_Pan_TiltNumBezier;
/*
 555F 0X05
 u8 data[3] 0  1  2   3  4
 
 u32 data[11-14] Frame_Now
 */
@property(nonatomic, assign)UInt8 S1A3_X2_StopMotion_Mode;
@property(nonatomic, assign)UInt32 S1A3_X2_StopMotion_CurrentFrame;
/*
 555F 0X06
 Bezier
 Preview
 float data[3-6]   Pan位置（保留0.1）
 float data[7-10]   Tilt 实时位置（0.1）
 */
@property(nonatomic, assign)UInt64 S1A3_X2_PreView_Pan_Position;
@property(nonatomic, assign)UInt64 S1A3_X2_PreView_Tilt_Position;


/*
 555F 0X07
 Panorama
 u8 data[3] 0 2  3  4
 u16 data[4-5]单张宽角度*100
 u16 data[6-7] 起始角度*10
 u16 data[8-9] 终止角度*10
 u8 data[10-11] Frame_Now
 u16 data[12-13] tilt 实时速度   0.1°/s  *10 +300
 u8 data[18] Interval  秒
 */

@property(nonatomic, assign)UInt8 S1A3_X2_Pano_Mode;
@property(nonatomic, assign)UInt16 S1A3_X2_Pano_Angle;
@property(nonatomic, assign)UInt16 S1A3_X2_Pano_StartAngle;
@property(nonatomic, assign)UInt16 S1A3_X2_Pano_EndAngle;
@property(nonatomic, assign)UInt8 S1A3_X2_Pano_CurrentFrame;
@property(nonatomic, assign)UInt16 S1A3_X2_Pano_Tilt_RealVeloc;
@property(nonatomic, assign)UInt8 S1A3_X2_Pano_Interval;

/*
 555F 0X08
 u8 data[3] 0 1 2 3 4 5 6
 u16 data[4-5] Pan角度*10+3600 (实际角度)
 u16 data[6-7] Tilt角度*10+3600
 u16 data[8-9] 起始Pan角度*10+3600
 u16 data[10-11] 起始Tilt角度*10+3600
 u16 data[12-13] 终点Pan角度*10+3600
 u16 data[14-15] 终点Tilt角度*10+3600
 u8 data[16-17] Frame_Now
 u8 data[18] Interval  秒
 
 */
@property(nonatomic, assign)UInt8 S1A3_X2_Grid_Mode;
@property(nonatomic, assign)UInt16 S1A3_X2_Grid_PanAngle;
@property(nonatomic, assign)UInt16 S1A3_X2_Grid_TiltAngle;
@property(nonatomic, assign)UInt16 S1A3_X2_Grid_StartPanAngle;
@property(nonatomic, assign)UInt16 S1A3_X2_Grid_StartTiltAngle;
@property(nonatomic, assign)UInt16 S1A3_X2_Grid_EndPanAngle;
@property(nonatomic, assign)UInt16 S1A3_X2_Grid_EndTiltAngle;
@property(nonatomic, assign)UInt8 S1A3_X2_Grid_FrameNow;
@property(nonatomic, assign)UInt8 S1A3_X2_Grid_Interval;




/*
 555F 0X09
 u8 data[3] 0B 0000  00AB
 u16 data[4-5]pan速度*100+4000
 u16 data[6-7] tilt速度*100+4000
 u16 data[8-9] Pan角度*10+3600（实时）
 u16 data[10-11] Tilt角度*10+3600（实时）
 u16 data[12-13] Pan角度*10+3600（记录点）
 u16 data[14-15] Tilt角度*10+3600（记录点）
 u16 data[17-18] 总运行时间 秒
 */
@property (nonatomic, assign)UInt8 S1A3_X2_Target_Mode;
@property (nonatomic, assign)UInt8 S1A3_X2_Target_AB_Mark;

@property (nonatomic, assign)UInt16 S1A3_X2_Target_Pan_Veloc;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Tilt_Veloc;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Pan_RealAngle;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Tilt_RealAngle;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Pan_RecordAngle;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Tilt_RecordAngle;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_totalTime;

/*
 555F 0X0a
 
 u8 data[3] 0  1  2   3  4（任务标志）
 u32 data[4-7]开始时间戳低32 ms
 
 u16 data[8-9]已运行时间 秒
 u8 data[10] 循环标志
 u8 data[11] 开始方向 1.向左 2.向右
 u16 data[12-13] Pan角度*10+3600（实时）
 u16 data[14-15] Tilt角度*10+3600（实时）
 u8 data[16] 0B 0000  00AB
 u8 data[17] 任务百分比
 u8 data[18] 淡入淡出等级
 */
@property (nonatomic, assign)UInt8 S1A3_X2_Target_Task_Mode;
@property (nonatomic, assign)UInt32 S1A3_X2_Target_Task_StartTime;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Task_RunTime;
@property (nonatomic, assign)UInt8 S1A3_X2_Target_Task_Isloop;
@property (nonatomic, assign)UInt8 S1A3_X2_Target_Task_Direction;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Task_PanRealAngle;
@property (nonatomic, assign)UInt16 S1A3_X2_Target_Task_TiltRealAngle;
@property (nonatomic, assign)UInt8 S1A3_X2_Target_Task_IsMark_A_B;
@property (nonatomic, assign)UInt8 S1A3_X2_Target_Task_Percent;
@property (nonatomic, assign)UInt8 S1A3_X2_Target_Task_smoothlevel;

/*
 555F 0X0b
 */
@property (nonatomic, assign)UInt64 S1A3_X2_2_4GAddress_TimeStamp;




/*
 555F 0X0c
 */


+(ReceiveView *)sharedInstance;

-(void)initReceviceNotification;
-(void)clearText;
-(void)receiveEnable:(Boolean)boo; //是否接收返回的数据
-(void)stopeReceive;
-(void)setIsAscii:(BOOL)boo;

//对receiveDataTxt的frame进行调整
-(void)setMessageHeightCut:(int)y;



@end
