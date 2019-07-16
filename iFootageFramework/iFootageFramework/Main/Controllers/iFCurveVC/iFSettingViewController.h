//
//  iFSettingViewController.h
//  iFootage
//
//  Created by 黄品源 on 16/8/6.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFTPSettingModel.h"

#import "iFCustomView.h"

#import "iFLabel.h"
#import "iFButton.h"

@protocol setTimelapseModeSettingDelegate <NSObject>

- (void)getTimelapseSettingData:(NSDictionary *)dict;



@end

@interface iFSettingViewController : iFRootViewController<chooseIndexValueDelegate>


@property (nonatomic, strong)iFLabel * ShootingModeLabel;
@property (nonatomic, strong)iFLabel * DisplayUnitLabel;
@property (nonatomic, strong)iFLabel * FrameRateLabel;
@property (nonatomic, strong)iFLabel * TotalFramesORTotalTimesLabel;

@property (nonatomic, strong)iFLabel * ExposureLabel;
@property (nonatomic, strong)iFLabel * IntervalLabel;
@property (nonatomic, strong)iFLabel * ActualIntervalLabel;

@property (nonatomic, strong)iFLabel * FinalOutPutLabel;
@property (nonatomic, strong)iFLabel * FilmingTimeLabel;



@property (nonatomic, strong)iFButton * SaveBtn;
@property (nonatomic, strong)iFButton * cancelBtn;

@property (nonatomic, strong)iFCustomView * shootingModelBtn;
@property (nonatomic, strong)iFCustomView * displayUnitBtn;
@property (nonatomic, strong)iFCustomView * frameRateBtn;

@property (nonatomic, strong)iFButton * TotalFramesBtnORTotalTimesBtn;
@property (nonatomic, strong)iFButton * ExposureBtn;
@property (nonatomic, strong)iFButton * IntervalBtn;
@property (nonatomic, strong)iFLabel * ActualIntervalValueLabel;
@property (nonatomic, strong)iFLabel * FilmingTimeValueLabel;
@property (nonatomic, strong)iFLabel * FinalOutputValueLabel;


@property (nonatomic, strong)iFTPSettingModel * setModel;


/**
 *  代理
 */
@property (nonatomic, strong)id<setTimelapseModeSettingDelegate>delegate;

@end
