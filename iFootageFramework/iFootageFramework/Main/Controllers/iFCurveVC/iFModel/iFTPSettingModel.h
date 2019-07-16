//
//  iFTPSettingModel.h
//  iFootage
//
//  Created by 黄品源 on 16/8/9.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iFTPSettingModel : NSObject

/**
 *  拍摄模式 SMS   or      Continuous
 */
@property NSInteger ShootingMode;

/**
 *  显示装置（显示模式）
 */
@property NSInteger DisplayUnit;
/**
 *  帧率
 */
@property NSInteger FramRate;
/**
 *  总帧率（总张数）
 */
@property (nonatomic, strong)NSString * TotalFrames;
/**
 *  总时间
 */
@property (nonatomic, copy)NSString * TotalTimes;
/**
 *  曝光时间
 */
@property (nonatomic, copy)NSString * Exposure;
/**
 *  间隔时间（降噪等待）
 */
@property (nonatomic, copy)NSString * Interval;
/**
 *  实际间隔时间
 */
@property (nonatomic, copy)NSString * ActualInterval;
/**
 *  拍摄时间
 */
@property (nonatomic, copy)NSString * Filmingtime;
/**
 *  视频合成时间
 */
@property (nonatomic, copy)NSString * Finaloutput;


@end
