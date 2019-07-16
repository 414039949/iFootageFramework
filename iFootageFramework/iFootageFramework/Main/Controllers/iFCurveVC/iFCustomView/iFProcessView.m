//
//  iFProcessView.m
//  iFootage
//
//  Created by 黄品源 on 2017/3/8.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFProcessView.h"

@implementation iFProcessView
@synthesize CurrentFrameLabel;
@synthesize TimeLabel;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame WithMode:(NSInteger)mode{
    CGFloat width = iFSize(200);
    CGFloat height = iFSize(200);
    
    if (self = [super initWithFrame:frame]) {
        NSLog(@"iFProcessView%@", self);
        
        
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200))];
        view.center = CGPointMake(AutoKScreenHeight / 2, AutoKscreenWidth / 2);
        view.layer.borderWidth = iFSize(2);
        view.layer.cornerRadius = iFSize(10);
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:view];
        
        _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoKScreenHeight, AutoKscreenWidth * 0.15)];
        _upView.backgroundColor = [UIColor blackColor];
        [self addSubview:_upView];
        
        self.backBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(21.5), iFSize(32.5), iFSize(58), iFSize(16)) andnormalImage:@"back" andSelectedImage:@"back"];
        [self.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_upView addSubview:self.backBtn];
        
        
        _downView = [[UIView alloc]initWithFrame:CGRectMake(0, AutoKscreenWidth * 0.85, AutoKScreenHeight, AutoKscreenWidth * 0.15)];
        _downView.backgroundColor = [UIColor blackColor];
        [self addSubview:_downView];
        
        self.stopBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, iFSize(34), iFSize(34)) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
        [self.stopBtn.actionBtn addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.stopBtn.center = CGPointMake(_downView.frame.size.width / 2, _downView.frame.size.height / 2);
        [_downView addSubview:_stopBtn];
        
        self.pauseBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, iFSize(34), iFSize(34)) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PAUSEBTNIMG];
        self.pauseBtn.actionBtn.selected = NO;
        [self.pauseBtn.actionBtn addTarget:self action:@selector(PauseMotionAction:) forControlEvents:UIControlEventTouchUpInside];
        self.pauseBtn.center = CGPointMake(_downView.frame.size.width / 2 + iFSize(50), _downView.frame.size.height / 2);

        [_downView addSubview:self.pauseBtn];
        
        self.isloopBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, iFSize(24), iFSize(24)) andnormalImage:target_UNLOOPIMG andSelectedImage:target_LOOPIMG];
        self.isloopBtn.center = CGPointMake(_downView.frame.size.width / 6, _downView.frame.size.height / 2);
        
        [self.isloopBtn addTarget:self action:@selector(isloopAction:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:self.isloopBtn];
        
        self.StopMotionBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, iFSize(34), iFSize(34)) WithTitle:nil selectedIMG:@"all_addIMG" normalIMG:@"all_addIMG"];
        
        self.StopMotionBtn.center = CGPointMake(_downView.frame.size.width / 2 + iFSize(250), _downView.frame.size.height / 2);
        [self.StopMotionBtn.actionBtn addTarget:self action:@selector(stopMotionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_downView addSubview:self.StopMotionBtn];
        
        self.StopMotion_lastPicBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, iFSize(34), iFSize(34)) WithTitle:nil selectedIMG:@"last_Pic" normalIMG:@"last_Pic"];
        [self.StopMotion_lastPicBtn.actionBtn addTarget:self action:@selector(stopMotion_lastPicAction:) forControlEvents:UIControlEventTouchUpInside];
        self.StopMotion_lastPicBtn.center = CGPointMake(_downView.frame.size.width / 2 + iFSize(200), _downView.frame.size.height / 2);
        [_downView addSubview:self.StopMotion_lastPicBtn];
        
//            CurrentFrameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width * 0.3, height * 0.2, width * 0.6 , height * 0.6)];
//            CurrentFrameLabel.backgroundColor = [UIColor clearColor];
//            CurrentFrameLabel.textAlignment = NSTextAlignmentCenter;
//            CurrentFrameLabel.textColor = [UIColor blackColor];
//            CurrentFrameLabel.font = [UIFont systemFontOfSize:width * 0.25];
////            [view addSubview:CurrentFrameLabel];
        
            TimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(width * 0.1, height * 0.2, width, height * 0.6)];
            TimeLabel.backgroundColor = [UIColor clearColor];
            TimeLabel.textAlignment = NSTextAlignmentCenter;
            TimeLabel.textColor = [UIColor blackColor];
            TimeLabel.font = [UIFont systemFontOfSize:width * 0.15];
            TimeLabel.center = CGPointMake(width / 2, height / 2);
            [view addSubview:TimeLabel];
        
//
//        self.countTimerLabel = [[UILabel alloc]initWithFrame:CGRectMake(width * 0.1, height * 0.8, width * 0.8, height * 0.2)];
//        self.countTimerLabel.textAlignment = NSTextAlignmentCenter;
//        self.countTimerLabel.backgroundColor = [UIColor clearColor];
//
//        self.countTimerLabel.textColor = [UIColor redColor];
////        [view addSubview:self.countTimerLabel];

        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height * 0.2)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = COLOR(66, 66, 66, 1);
        self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:height * 0.08];
        [view addSubview:self.titleLabel];
        
//        self.videoTimelabel = [[UILabel alloc]initWithFrame:CGRectMake(width * 0.2, height * 0.2, width * 0.6, height * 0.2)];
//        self.videoTimelabel.textAlignment = NSTextAlignmentCenter;
//        self.videoTimelabel.backgroundColor = [UIColor clearColor];
//        self.videoTimelabel.textColor = COLOR(66, 66, 0, 1);
////        [view addSubview:self.videoTimelabel];
        
//        self.TotalFrameLabel = [[UILabel alloc]initWithFrame:CGRectMake(width * 0.7, height * 0.6, width * 0.3, height * 0.2)];
//        self.TotalFrameLabel.backgroundColor = [UIColor clearColor];
//        self.TotalFrameLabel.textAlignment = NSTextAlignmentLeft;
//
////        [view addSubview:self.TotalFrameLabel];
//
        
/******新的UI******/
        
        self.OutputTimeView = [[iFTitle_ValueView alloc]initWithFrame:CGRectMake(0, height * 0.2, width, height * 0.12) andTitle:@"Output time:" andObject:@"00:00.00f"];
        [view addSubview:self.OutputTimeView];
        
        self.CurrentFrameView = [[iFTitle_ValueView alloc]initWithFrame:CGRectMake(0, height * 0.32, width, height * 0.12) andTitle:@"Current frame:" andObject:@"307000"];
        [view addSubview:self.CurrentFrameView];
        
        self.TotalFrameView = [[iFTitle_ValueView alloc]initWithFrame:CGRectMake(0, height * 0.44, width, height * 0.12) andTitle:@"Total frame:" andObject:@"500000"];
        [view addSubview:self.TotalFrameView];
        
        self.ElapsedTimeView = [[iFTitle_ValueView alloc]initWithFrame:CGRectMake(0, height * 0.56, width, height * 0.12) andTitle:@"Elapsed time:" andObject:@"00:15:19"];
        [view addSubview:self.ElapsedTimeView];
        
        self.RemainingTimeView = [[iFTitle_ValueView alloc]initWithFrame:CGRectMake(0, height * 0.68, width, height * 0.12) andTitle:@"Remaining time:" andObject:@"00:25:05"];
        [view addSubview:self.RemainingTimeView];
        self.TimelapseMode = mode;
    }
    return self;
}
- (void)isloopAction:(iFButton *)btn{
    btn.selected = !btn.selected;
    [_delegate loopActionDelegateMethod];
    
}
- (void)stopAction:(iFButton *)btn{
    [_delegate stopActionDelegateMethod];
    
}

- (void)stopMotion_lastPicAction:(UIButton *)btn{
    [_delegate stopMotion_lastPicActionDelegateMethod];
}
- (void)stopMotionAction:(iFButton *)btn{
    [_delegate stopMotionActionDelegateMethod];
    
}

- (void)PauseMotionAction:(iFButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [_delegate PauseMotionActionDelegateMethod];
    }else{
        [_delegate restartMotionActionDelegateMethod];
    }
}

- (void)backAction:(iFButton *)btn{
    [_delegate backActionDelegateMethod];
}
- (void)setTimelapseMode:(NSInteger)TimelapseMode{
    
    [self showWithMode:TimelapseMode andTitle:nil];
}
- (void)showWithMode:(NSInteger)mode andTitle:(NSString *)str{
    
//    NSLog(@"\r\n showWithMode %ld ", mode);
    
    if (mode == 0) {
        self.titleLabel.text = @"Timelapse Running";
        CurrentFrameLabel.alpha = 1;
        TimeLabel.alpha = 0;
//        self.videoTimelabel.alpha = 0;
        self.OutputTimeView.alpha = 1;
        self.CurrentFrameView.alpha = 1;
        self.TotalFrameView.alpha = 1;
        self.ElapsedTimeView.alpha = 1;
        self.RemainingTimeView.alpha = 1;
        self.StopMotionBtn.alpha = 0;
        self.isloopBtn.alpha = 1;
        self.pauseBtn.alpha = 1;
    }else if (mode == 1){
        if ([str isEqualToString:@"preview"] == YES) {
            self.titleLabel.text = str;
//            self.RemainingTimeView.alpha = 0;
            self.isloopBtn.alpha = 0;
            self.pauseBtn.alpha = 0;
            

        }else{        
        self.titleLabel.text = @"Video Running";
//            self.RemainingTimeView.alpha = 1;
            self.isloopBtn.alpha = 1;
            self.pauseBtn.alpha = 1;
        }
//        CurrentFrameLabel.alpha = 0;
//        self.TotalFrameLabel.alpha = 0;
//        self.countTimerLabel.alpha = 0;
//        self.videoTimelabel.alpha = 1;
        self.OutputTimeView.alpha = 0;
        self.CurrentFrameView.alpha = 0;
        self.TotalFrameView.alpha = 0;
        self.ElapsedTimeView.alpha = 0;
        self.RemainingTimeView.alpha = 0;
        self.StopMotionBtn.alpha = 0;
      
        TimeLabel.alpha = 1;
    }else if (mode == 2){
        self.titleLabel.text = @"StopMotion Running";
        CurrentFrameLabel.alpha = 1;
        TimeLabel.alpha = 0;
//        self.videoTimelabel.alpha = 0;
        self.OutputTimeView.alpha = 1;
        self.CurrentFrameView.alpha = 1;
        self.TotalFrameView.alpha = 1;
        self.ElapsedTimeView.alpha = 0;
        self.RemainingTimeView.alpha = 0;
        self.StopMotionBtn.alpha = 1;
        self.isloopBtn.alpha = 0;
        self.pauseBtn.alpha = 0;
    }
    self.StopMotion_lastPicBtn.alpha = self.StopMotionBtn.alpha;
}
- (void)showPreView{
    self.titleLabel.text = @"Preview Running";
    CurrentFrameLabel.alpha = 0;
    self.TotalFrameLabel.alpha = 0;
    self.countTimerLabel.alpha = 0;
    self.videoTimelabel.alpha = 0;
    self.StopMotionBtn.alpha = 0;
    TimeLabel.alpha = 1;
}

@end
