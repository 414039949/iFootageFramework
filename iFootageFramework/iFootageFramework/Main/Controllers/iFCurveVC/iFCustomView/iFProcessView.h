//
//  iFProcessView.h
//  iFootage
//
//  Created by 黄品源 on 2017/3/8.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFButton.h"
#import "iF3DButton.h"
#import "iFTitle_ValueView.h"


@protocol processDelegate <NSObject>

- (void)stopActionDelegateMethod;

- (void)stopMotionActionDelegateMethod;

- (void)stopMotion_lastPicActionDelegateMethod;

- (void)backActionDelegateMethod;

- (void)loopActionDelegateMethod;

- (void)PauseMotionActionDelegateMethod;
- (void)restartMotionActionDelegateMethod;

@end


@interface iFProcessView : UIView



@property (nonatomic, strong)UILabel * CurrentFrameLabel;

@property (nonatomic, strong)UILabel * TimeLabel;
@property (nonatomic, strong)UILabel * countTimerLabel;

@property (nonatomic, strong)UILabel * videoTimelabel;

@property (nonatomic, strong)UILabel * TotalFrameLabel;
@property (nonatomic, strong)UILabel * titleLabel;

@property (nonatomic, strong)UILabel * totalTimeLabel;

@property (nonatomic, strong)iFTitle_ValueView * OutputTimeView;
@property (nonatomic, strong)iFTitle_ValueView * CurrentFrameView;
@property (nonatomic, strong)iFTitle_ValueView * TotalFrameView;
@property (nonatomic, strong)iFTitle_ValueView * ElapsedTimeView;
@property (nonatomic, strong)iFTitle_ValueView * RemainingTimeView;


@property (nonatomic, strong)UIView * upView;
@property (nonatomic, strong)UIView * downView;



@property (nonatomic, strong)iF3DButton * stopBtn;
@property (nonatomic, strong)iF3DButton * StopMotionBtn;
@property (nonatomic, strong)iF3DButton * StopMotion_lastPicBtn;
@property (nonatomic, strong)iF3DButton * pauseBtn;

@property (nonatomic, strong)iFButton * backBtn;
@property (nonatomic, strong)UIButton * isloopBtn;

@property id<processDelegate>delegate;


@property (nonatomic)NSInteger TimelapseMode;



- (void)showWithMode:(NSInteger)mode andTitle:(NSString *)str;
- (instancetype)initWithFrame:(CGRect)frame WithMode:(NSInteger)mode;
- (void)showPreView;

@end
