//
//  iFS1A3_Model.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/29.
//  Copyright © 2018年 iFootage. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface iFS1A3_Model : NSObject

@property (nonatomic, strong)NSArray * allPropertyNames;

@property (nonatomic, strong)NSString * S1A3_NameStr;

@property (nonatomic, strong)NSArray * S1A3_SlideArray;//Slide点的集合
@property (nonatomic, strong)NSArray * S1A3_PanArray;//Pan点的集合
@property (nonatomic, strong)NSArray * S1A3_TiltArray;//Tilt点的集合
@property (nonatomic, strong)NSArray * S1A3_SlideControlArray;//Slide控制点的集合
@property (nonatomic, strong)NSArray * S1A3_PanControlArray;//Pan控制点的集合
@property (nonatomic, strong)NSArray * S1A3_TiltControlArray;//Tilt控制点的集合

@property (nonatomic, assign)NSInteger S1A3_FunctionMode;//运行模式(Timelapse、Video、StopMotion)
@property (nonatomic, assign)NSInteger S1A3_ExpoSecond;//曝光时间
@property (nonatomic, assign)NSInteger S1A3_BufferSecond;//缓冲时间
@property (nonatomic, assign)NSInteger S1A3_TimelapseTotalFrames;//Timelapse模式下总帧数
@property (nonatomic, assign)NSInteger S1A3_fpsIndex;//FPS数组下标@[24fps, 25fps, 30fps, 60fps & 29.7fps];
@property (nonatomic, assign)CGFloat S1A3_TimelapseTotalTimes;//Timelapse模式下总时间（浮点）
@property (nonatomic, assign)CGFloat S1A3_VideoTotalTimes;//Video模式下总时间（浮点）

@property (nonatomic, assign)CGFloat S1A3_SlideUpValue;//SlideCustomSlider的上标值
@property (nonatomic, assign)CGFloat S1A3_SlideDownValue;//SlideCustomSlider的下标值
@property (nonatomic, assign)CGFloat S1A3_PanUpValue;//PanCustomSlider的上标值
@property (nonatomic, assign)CGFloat S1A3_PanDownValue;//PanCustomSlider的下标值
@property (nonatomic, assign)CGFloat S1A3_TiltUpValue;//TiltCustomSlider的上标值
@property (nonatomic, assign)CGFloat S1A3_TiltDownValue;//TiltCustomSlider的下标值

@property (nonatomic, assign)NSInteger S1A3_ShootingMode;//S1A3的拍摄模式
@property (nonatomic, assign)NSInteger S1A3_DisPlayMode;//S1A3曲线的陈列模式
@property (nonatomic, assign)NSInteger S1A3_SlideCount;//S1A3的滑轨的节数

@property (nonatomic, assign)NSInteger S1A3_CameraIndex;//S1A3传感器尺寸
@property (nonatomic, assign)NSInteger S1A3_FocalIndex;//S1A3相片比例
@property (nonatomic, assign)NSInteger S1A3_AspectIndex;//S1A3镜头焦距
@property (nonatomic, assign)NSInteger S1A3_PanIntervalIndex;//S1A3间隔时间

@property (nonatomic, assign)CGFloat S1A3_slideAdjustVeloc;//S1A3的手动曲线Slide调整参数
@property (nonatomic, assign)CGFloat S1A3_panAdjustVeloc;//S1A3的手动曲线Pan调整参数
@property (nonatomic, assign)CGFloat S1A3_tiltAdjustVeloc;//S1A3的手动曲线Tilt调整参数



@property (nonatomic, assign)CGFloat S1A3_Pano_StartAngle;
@property (nonatomic, assign)CGFloat S1A3_Pano_EndAngle;


@property (nonatomic, assign)NSInteger S1A3_Target_totaltime;



@end
