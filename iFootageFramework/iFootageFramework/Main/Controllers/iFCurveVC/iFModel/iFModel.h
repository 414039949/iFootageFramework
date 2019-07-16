//
//  iFModel.h
//  iFootage
//
//  Created by 黄品源 on 2016/10/27.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iFModel : NSObject



@property (nonatomic, copy)NSString * nameStr;
//@property (nonatomic, copy)NSString * timeStr;

/**
 总共的frames
 */
@property NSInteger totalFrames;

/**
 总共的times
 */
@property CGFloat totalTimes;

@property CGFloat TimelapseTotalTimes;


/**
 拍摄模式shootMode
 */
@property NSInteger shootMode;

/**
 displayUnit
 */
@property NSInteger displayUnit;

/**
 间隔时间
 */
@property NSInteger intervalTimeIndex;

@property NSInteger FunctionMode;


/**
 右边自定义Slide滑块的上View值
 */
@property CGFloat upSliderValue;

/**
 右边自定义Slide滑块的下View值
 */
@property CGFloat downSliderValue;

/**
 自定义选择Pan滑块的上View值
 */
@property CGFloat upPanValue;

/**
 自定义选择Pan滑块的下View值

 */
@property CGFloat downPanValue;

/**
 自定义选择Tilt滑块的上View值

 */
@property CGFloat upTiltValue;

/**
 自定义选择Tilt滑块的下View值

 */
@property CGFloat downTiltValue;



// fps的index值 通常情况是25fps
 /*
 
 0: 24
 1: 25
 2: 30
 3: 50
 4: 60
 */
@property NSInteger fpsIndex;

/**
 导轨的总长度 与节数有关
 */
@property CGFloat allLengthValue;


/**
 导轨的节数
 */
@property NSInteger slideCount;

@property NSInteger bufferSecond;
@property NSInteger exposureSecond;


/**
 slider pan  tilt 三轴数组
 */
@property (nonatomic, strong)NSArray * sliderArray;
@property (nonatomic, strong)NSArray * panArray;
@property (nonatomic, strong)NSArray * tiltArray;
//
- (instancetype)modelWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;

@property (nonatomic, strong)NSArray * slideControlArray;
@property (nonatomic, strong)NSArray * panControlArray;
@property (nonatomic, strong)NSArray * tiltControlArray;


@property (nonatomic, assign)NSUInteger cameraIndex;
@property (nonatomic, assign)NSUInteger focalIndex;
@property (nonatomic, assign)NSUInteger aspectIndex;
@property (nonatomic, assign)NSUInteger panIntervalIndex;

/**
 Fcous Mode 运行总时间
 */
@property (nonatomic, assign)NSInteger fmtotalTime;

@property (nonatomic, strong)NSArray * allPropertyNames;


@end
