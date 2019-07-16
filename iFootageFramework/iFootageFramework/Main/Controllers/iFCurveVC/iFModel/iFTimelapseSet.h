//
//  iFTimelapseSet.h
//  iFootage
//
//  Created by 黄品源 on 16/8/9.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iFTimelapseSet : NSObject
/**
 *  拍摄模式 SMS   or      Continuous
 */
@property (nonatomic, copy)NSString * ShootingMode;

/**
 *  显示装置
 */
@property (nonatomic, copy)NSString * DisplayUnit;
/**
 *  帧率
 */
@property (nonatomic, copy)NSString * FramRate;
/**
 *  总帧率
 */
@property (nonatomic, copy)NSString * TotalFrames;
/**
 *  总时间
 */
@property (nonatomic, copy)NSString * TotalTimes;
/**
 *  曝光时间
 */
@property (nonatomic, copy)NSString * Exposure;
/**
 *  间隔时间
 */
@property (nonatomic, copy)NSString * Interval;
/**
 *  实际间隔时间
 */
@property (nonatomic, copy)NSString * ActualInterval;
/**
 *  最终输出
 */
@property (nonatomic, copy)NSString * FinalOutPut;


@end
