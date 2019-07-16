//
//  iFSquareViewController.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFSquareViewController.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "AppDelegate.h"
#import "iFAlertController.h"
#import "iFGetDataTool.h"

#define tiltMax 350
#define Dead_Zone 0.2f
#define Vspeed 32.11

@interface iFSquareViewController ()
{
    int wCount, hCount;
    CGFloat ActiveVX; // 动态横坐标
    CGFloat ActiveVY; // 动态纵坐标
    SendDataView * _sendView;
    ReceiveView * _receiveView;
    NSUInteger               Encode;//编码模式 ascii or  hex
    NSData * data;
    AppDelegate * appDelegate;
    BOOL _iSstart, _iSend;
    
    NSTimer * receiveTimer;
    NSTimer * startTimer;
    NSTimer * endTimer;
    
    NSTimer * playTimer;
    NSTimer * returnZeroTimer;
    NSTimer * pauseTimer;
    
    
    NSTimer * runTimer;
   
    UInt64  startTime;
    UIView * rightBackgroundView;
    
    
}
@end

static int count;

@implementation iFSquareViewController

#warning 进来要发送 功能字

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _rightunit = 1.0f;
    
    
    self.titleLabel.text = NSLocalizedString(Stiching_Grid, nil);
    _sendView = [[SendDataView alloc]init];
    _receiveView = [ReceiveView sharedInstance];
    appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;

    
    
    self.intervalLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, kScreenHeight * 0.1, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Interval, nil) andInitValueStr:@"0s"];
    self.intervalLabel.ValueLabel.text = self.interval;
    [self.view addSubview:self.intervalLabel];
    
    self.PicturesLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.35, kScreenHeight * 0.1, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Pictures, nil) andInitValueStr:@"0/1"];
    [self.view addSubview:self.PicturesLabel];
    
    self.RuntimeLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, kScreenHeight * 0.1, AutoKscreenWidth * 0.4, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_RunTime, nil) andInitValueStr:@"00:00/00:00"];
    [self.view addSubview:self.RuntimeLabel];
    

    self.backView = [[iFPanoView alloc]initWithFrame:CGRectMake(50, AutoKScreenHeight * 0.2, AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5) andwCount:1 andhCount:1];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
    
    
    self.PanValueLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(60, self.backView.frame.origin.y + 50 + self.backView.frame.size.height, 100, 50) andTitle:@"Pan value" andInitValueStr:[NSString stringWithFormat:@"%.2lf°", self.PanAngle]];
    [self.view addSubview:self.PanValueLabel];
    
    self.TiltValueLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(60, self.PanValueLabel.frame.origin.y + self.PanValueLabel.frame.size.height + 30, 100, 50) andTitle:@"Tilt value" andInitValueStr:[NSString stringWithFormat:@"%.2lf°", self.TiltAngle]];
    [self.view addSubview:self.TiltValueLabel];
    
    rightBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.45, self.backView.frame.origin.y + 30 + self.backView.frame.size.height, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    rightBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rightBackgroundView];
    self.GigaplexlStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(209), iFSize(400), 125, 125)];
    self.GigaplexlStick.delegate = self;
    self.GigaplexlStick.center = CGPointMake(rightBackgroundView.frame.size.width * 0.5, rightBackgroundView.frame.size.height * 0.5);
    [rightBackgroundView addSubview:self.GigaplexlStick];
    
   
    
    
    self.stopBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(60, rightBackgroundView.frame.origin.y + rightBackgroundView.frame.size.height, 50, 50) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    [self.stopBtn.actionBtn addTarget:self action:@selector(pauseActionTimer:) forControlEvents:UIControlEventTouchUpInside];

//    [self.view addSubview:self.stopBtn];
    
    
    self.SetStartBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(20, rightBackgroundView.frame.origin.y + rightBackgroundView.frame.size.height + 25, 100, 40) WithTitle:@"Set start" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    
    _iSstart = NO;
    [self.SetStartBtn.actionBtn addTarget:self action:@selector(setStartPoint) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.SetStartBtn];
    
    
    self.SetEndBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(self.SetStartBtn.frame.size.width + self.SetStartBtn.frame.origin.x + 24, rightBackgroundView.frame.origin.y + rightBackgroundView.frame.size.height + 25, 100, 40) WithTitle:@"Set end" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    _iSend = NO;
    self.SetEndBtn.actionBtn.selected = _iSend;
    [self.SetEndBtn.actionBtn addTarget:self action:@selector(setEndPoint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.SetEndBtn];
    NSLog(@"T= %f, P = %f , %@",_TiltAngle, _PanAngle, _interval);
    
    self.pauseBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(self.SetEndBtn.frame.size.width + self.SetEndBtn.frame.origin.x + 20,rightBackgroundView.frame.origin.y + rightBackgroundView.frame.size.height + 20, 50, 50) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    [self.pauseBtn.actionBtn addTarget:self action:@selector(pauseAction) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.alpha = 0;
    [self.view addSubview:self.pauseBtn];
    
    
    self.playBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(self.SetEndBtn.frame.size.width + self.SetEndBtn.frame.origin.x + 20, rightBackgroundView.frame.origin.y + rightBackgroundView.frame.size.height + 20, 50, 50) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PALYBTNIMG];
    self.playBtn.alpha = 1;
    [self.playBtn.actionBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
    runTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(runtimeTimer:) userInfo:nil repeats:YES];
    runTimer.fireDate = [NSDate distantFuture];
    

    startTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(judgeIsSetStartPointSuccess:) userInfo:nil repeats:YES];
    startTimer.fireDate = [NSDate distantFuture];
    
    endTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(judgeIsSetEndPointSuccess:) userInfo:nil repeats:YES];
    endTimer.fireDate = [NSDate distantFuture];
    
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(readyGoAction:) userInfo:nil repeats:YES];
    playTimer.fireDate = [NSDate distantFuture];
    
    returnZeroTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(readyGoReturnZero:) userInfo:nil repeats:YES];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    
    pauseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(pauseActionTimer:) userInfo:nil repeats:YES];
    pauseTimer.fireDate = [NSDate distantFuture];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [[UIApplication sharedApplication] setStatusBarHidden:NO];

        [self VerticalscreenUI];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        [self LandscapescreenUI];
        
    }
}
//竖屏
- (void)VerticalscreenUI{
    
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    [self.PicturesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(self.intervalLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
        
    }];
    [self.RuntimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(self.PicturesLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AutoKScreenHeight * 0.2);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5));
    }];
    [self.PanValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
    }];
    [self.TiltValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.equalTo(self.PanValueLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
    }];
    [rightBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PanValueLabel.mas_right);
        make.top.equalTo(self.PanValueLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5));
    }];
    
    [self.SetStartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(rightBackgroundView.mas_bottom);
        }
        
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.SetEndBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetStartBtn.mas_right).offset(10);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(rightBackgroundView.mas_bottom);
        }
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.pauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(rightBackgroundView.mas_bottom);
        }        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(rightBackgroundView.mas_bottom);
        }        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
}
//横屏
- (void)LandscapescreenUI{
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    [self.PicturesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(self.intervalLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    [self.RuntimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44 + [UIApplication sharedApplication].statusBarFrame.size.height);
        make.left.equalTo(self.PicturesLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intervalLabel.mas_bottom);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5));
    }];
    [self.PanValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
    }];
    [self.TiltValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PanValueLabel.mas_right).offset(30);
        make.top.equalTo(self.PanValueLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
        
    }];
    [rightBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5));
    }];
    
    [self.SetStartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_right).offset(20);
        make.top.equalTo(self.backView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.SetEndBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetStartBtn.mas_right).offset(10);
        make.top.equalTo(self.backView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.pauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        make.top.equalTo(self.backView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        make.top.equalTo(self.backView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint rightPoint = [[touches anyObject] locationInView:rightBackgroundView];
    
    //    NSLog(@"R = %@",NSStringFromCGRect(rightBackGroundView.frame));
    //    NSLog(@"L = %@",NSStringFromCGRect(leftBackGroundView.frame));
    if ([rightBackgroundView.layer containsPoint:rightPoint]) {
        //        if ([secondView.layer containsPoint:rightPoint]) {
        self.GigaplexlStick.center = rightPoint;
        [self.GigaplexlStick touchesBegan];
        
        //        }
    }
    
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    [self.GigaplexlStick reset];
    [self.GigaplexlStick touchesEnded];
    
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    CGPoint rightPoint = [[touches anyObject] locationInView:rightBackgroundView];
    
    if ([rightBackgroundView.layer containsPoint:rightPoint]){
        [self.GigaplexlStick autoPoint:rightPoint];
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self.GigaplexlStick reset];
    [self.GigaplexlStick touchesCancelled];
    
}

- (void)changeVectorForTheSegment:(UISegmentedControl *)seg{
    
    if (seg.selectedSegmentIndex == 0) {
        _rightunit = 0.2f;
    }else if(seg.selectedSegmentIndex == 1){
        _rightunit = 0.4f;
    }else{
        _rightunit = 1.0f;
    }

}
- (void)runtimeTimer:(NSTimer *)timer{

    
  
    UInt64 nowTime = [[NSDate date]timeIntervalSince1970] * 1000;
    if (_receiveView.Gimode == 0x02) {
        self.RuntimeLabel.ValueLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: (nowTime - startTime) / 1000], [iFGetDataTool getTimeWith:self.totalTime]];
    }else{
        timer.fireDate = [NSDate distantFuture];
        
    }

    
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(receiveRealData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];

    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    receiveTimer.fireDate = [NSDate distantFuture];
    startTimer.fireDate = [NSDate distantFuture];
    endTimer.fireDate = [NSDate distantFuture];
    playTimer.fireDate = [NSDate distantFuture];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    pauseTimer.fireDate = [NSDate distantFuture];
    
    receiveTimer = nil;
    
}


- (void)receiveRealData{
//    NSLog(@"receiveRealData");

    
    NSLog(@"MODE = %d", _receiveView.Gimode);
    NSLog(@"sPANA = %f", (_receiveView.GipanStartAngle - 3600) / 10.00f);
    NSLog(@"sTILT = %f", (_receiveView.GitiltStartAngle - tiltMax) / 10.00f);
    NSLog(@"ePan = %f", (_receiveView.GipanEndAngle - 3600) / 10.00f);
    NSLog(@"eTilt = %f", (_receiveView.GitiltEndAngle - tiltMax) / 10.00f);
    
    CGFloat panStartAngle = (_receiveView.GipanStartAngle - 3600) / 10.00f;
    CGFloat tiltStartAngle = (_receiveView.GitiltStartAngle - tiltMax) / 10.00f;
    CGFloat panEndAngle = (_receiveView.GipanEndAngle - 3600) / 10.00f;
    CGFloat tiltEndAngle = (_receiveView.GitiltEndAngle - tiltMax) / 10.00f;
    int panNumber = ceil(fabs(panEndAngle - panStartAngle) / _PanAngle) + 1;
    int tiltNumber = ceil(fabs(tiltEndAngle - tiltStartAngle) / _TiltAngle) + 1;
    self.totalTime = panNumber * tiltNumber * [self.interval integerValue];
    
//    if (_receiveView.GiFrameCurrent <= 0 ) {
//        
//    }else{
  
    
        [self changeBackViewWithPanNumber:panNumber andTiltNumber:tiltNumber];
        [self.backView showLabelColorWith:_receiveView.GiFrameCurrent];
    
//        self.RuntimeValueLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith:count], [iFGetDataTool getTimeWith:self.totalTime]];
        self.PicturesLabel.ValueLabel.text = [NSString stringWithFormat:@"%d/%d", _receiveView.GiFrameCurrent, panNumber * tiltNumber];
//    }
    
    if (_receiveView.Gimode == 0x02) {
        self.pauseBtn.alpha = 1;
        self.playBtn.alpha = 0;
    }
//    else if (_receiveView.Gimode == 0x01){
//        self.pauseBtn.alpha = 1;
//        self.playBtn.alpha = 0;
//    }
    else{
        self.pauseBtn.alpha = 0;
        self.playBtn.alpha = 1;
    }
    
    
}
- (void)changeBackViewWithPanNumber:(int)pannumber andTiltNumber:(int)tiltnumber{
    
    [self.backView removeFromSuperview];
    self.backView = [[iFPanoView alloc]initWithFrame:CGRectMake(50, AutoKScreenHeight * 0.2, AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5) andwCount:pannumber andhCount:tiltnumber];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
}

- (void)setStartPoint{
    
    if (_iSstart) {
        _iSstart = NO;
        self.SetStartBtn.backgroundColor = [UIColor clearColor];
        self.SetStartBtn.actionBtn.selected = NO;
        
        
    }else{
    
    startTimer.fireDate = [NSDate distantPast];
    UInt16 widthAngle = _PanAngle * 100;
    UInt16 heightAngle = _TiltAngle * 100;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    [_sendView sendGigaplexlWithCb:appDelegate.bleManager.panCB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x05 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
    }
}
- (void)setEndPoint{
    if (_iSend) {
        _iSend = NO;
        self.SetEndBtn.backgroundColor = [UIColor clearColor];
        self.SetEndBtn.actionBtn.selected = NO;
        
    }else{
    
    endTimer.fireDate = [NSDate distantPast];
    UInt16 widthAngle = _PanAngle * 100;
    UInt16 heightAngle = _TiltAngle * 100;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    [_sendView sendGigaplexlWithCb:appDelegate.bleManager.panCB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x06 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
    }
    
}

- (void)judgeIsSetStartPointSuccess:(NSTimer *)timer{
    
    CGFloat tiltStartAngle = (_receiveView.GitiltStartAngle - tiltMax) / 10.00f;
    CGFloat panStartAngle = (_receiveView.GipanStartAngle - 3600) / 10.00f;
    CGFloat panRealAngle = (_receiveView.GipanRealAngle - 3600) / 10.00f;
    CGFloat tiltRealAngle = (_receiveView.GitiltRealAngle - tiltMax) / 10.00f;
    
    if (_receiveView.Gimode != 2) {
        if (panRealAngle == panStartAngle && tiltRealAngle == tiltStartAngle) {
            _iSstart = YES;
            self.SetStartBtn.backgroundColor = [UIColor grayColor];
            self.SetStartBtn.actionBtn.selected = YES;
            
            timer.fireDate = [NSDate distantFuture];
            if (_iSend == YES && _iSstart == YES) {
                
                CGFloat panStartAngle = (_receiveView.GipanStartAngle - 3600) / 10.00f;
                CGFloat tiltStartAngle = (_receiveView.GitiltStartAngle - tiltMax) / 10.00f;
                CGFloat panEndAngle = (_receiveView.GipanEndAngle - 3600) / 10.00f;
                CGFloat tiltEndAngle = (_receiveView.GitiltEndAngle - tiltMax) / 10.00f;
                int panNumber = ceil(fabs(panEndAngle - panStartAngle) / _PanAngle) + 1;
                int tiltNumber = ceil(fabs(tiltEndAngle - tiltStartAngle) / _TiltAngle) + 1;
                [self changeBackViewWithPanNumber:panNumber andTiltNumber:tiltNumber];
                self.RuntimeLabel.ValueLabel.text =[NSString stringWithFormat:@"00:00/%@", [iFGetDataTool getTimeWith:(panNumber * tiltNumber * [self.interval integerValue])]];

                self.PicturesLabel.ValueLabel.text = [NSString stringWithFormat:@"%d/%d", _receiveView.GiFrameCurrent, panNumber * tiltNumber];

            }

        }
    }
}
- (void)judgeIsSetEndPointSuccess:(NSTimer *)timer{
    
    CGFloat panRealAngle = (_receiveView.GipanRealAngle - 3600) / 10.00f;
    CGFloat tiltRealAngle = (_receiveView.GitiltRealAngle - tiltMax) / 10.00f;
    CGFloat tiltEndAngle = (_receiveView.GitiltEndAngle - tiltMax) / 10.00f;
    CGFloat panEndAngle = (_receiveView.GipanEndAngle - 3600) / 10.00f;
    
    if (_receiveView.Gimode != 2) {
        
        if (panRealAngle == panEndAngle && tiltRealAngle == tiltEndAngle) {
            _iSend = YES;
//            self.SetEndBtn.backgroundColor = [UIColor grayColor];
            self.SetEndBtn.actionBtn.selected = YES;
            
            timer.fireDate = [NSDate distantFuture];
            
            if (_iSend == YES && _iSstart == YES) {
                NSLog(@"end +++++++++++++++++++++++++++++++++++++");
                CGFloat panStartAngle = (_receiveView.GipanStartAngle - 3600) / 10.00f;
                CGFloat tiltStartAngle = (_receiveView.GitiltStartAngle - tiltMax) / 10.00f;
                CGFloat panEndAngle = (_receiveView.GipanEndAngle - 3600) / 10.00f;
                CGFloat tiltEndAngle = (_receiveView.GitiltEndAngle - tiltMax) / 10.00f;
                int panNumber = ceil(fabs(panEndAngle - panStartAngle) / _PanAngle) + 1;
                int tiltNumber = ceil(fabs(tiltEndAngle - tiltStartAngle) / _TiltAngle) + 1;
                
                [self changeBackViewWithPanNumber:panNumber andTiltNumber:tiltNumber];
                
                self.RuntimeLabel.ValueLabel.text =[NSString stringWithFormat:@"00:00/%@", [iFGetDataTool getTimeWith:(panNumber * tiltNumber * [self.interval integerValue])]];
                
                
                self.PicturesLabel.ValueLabel.text = [NSString stringWithFormat:@"%d/%d", _receiveView.GiFrameCurrent, panNumber * tiltNumber];

            }
        }
    }
}

- (void)readyGoReturnZero:(NSTimer *)timer{
    if (_receiveView.Gimode == 0x01) {
        timer.fireDate = [NSDate distantFuture];
        playTimer.fireDate = [NSDate distantPast];
    }else{
    
    UInt16 widthAngle = _PanAngle * 100;
    UInt16 heightAngle = _TiltAngle * 100;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    [_sendView sendGigaplexlWithCb:appDelegate.bleManager.panCB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x00 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
    }
}

- (void)readyGoAction:(NSTimer *)timer{

    if (_receiveView.Gimode == 0x02) {
        
        startTime = [[NSDate date]timeIntervalSince1970] * 1000;

        runTimer.fireDate = [NSDate distantPast];
        timer.fireDate = [NSDate distantFuture];

    }else{
        UInt16 widthAngle = _PanAngle * 100;
        UInt16 heightAngle = _TiltAngle * 100;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        [_sendView sendGigaplexlWithCb:appDelegate.bleManager.panCB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x02 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
    }

}
- (void)pauseAction{
    
    pauseTimer.fireDate = [NSDate distantPast];
    
}
- (void)pauseActionTimer:(NSTimer *)timer{
    
    if (_receiveView.Gimode == 0x04) {
        count = 0;
        timer.fireDate = [NSDate distantFuture];
        runTimer.fireDate = [NSDate distantFuture];
    }else{
    UInt16 widthAngle = _PanAngle * 100;
    UInt16 heightAngle = _TiltAngle * 100;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    [_sendView sendGigaplexlWithCb:appDelegate.bleManager.panCB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x04 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
    
    }
}
- (void)playAction{
    if (!_iSend || !_iSstart) {
        
         UIAlertController * alertView = [iFAlertController showAlertControllerWith:NSLocalizedString(Timeline_WarmTips, nil) Message:NSLocalizedString(Timeline_AddRightFramesWarning, nil) SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
             
         }];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        returnZeroTimer.fireDate = [NSDate distantPast];

    }
    
}

- (void)changeBackViewState{
    [self.backView removeFromSuperview];
    self.backView = [[iFPanoView alloc]initWithFrame:CGRectMake(50, kScreenHeight * 0.2, kScreenWidth * 0.75, kScreenWidth * 0.5) andwCount:wCount andhCount:hCount];
    self.backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.backView];
}
- (void)analogueStickDidChangeValue:(iFootageRocker *)analogueStick
{
    [self rightUpdateAnalogue];
}

- (void)rightUpdateAnalogue
{
    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.GigaplexlStick.xValue * 100];
    data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];
    
    CGFloat xV;
    CGFloat yV;
#pragma mark  死驱算法
    if (fabs(self.GigaplexlStick.xValue)  < Dead_Zone) {
        xV = 0.0f;
    }else{
        xV = (fabs(self.GigaplexlStick.xValue) - Dead_Zone) / (1 - Dead_Zone);
        if (self.GigaplexlStick.xValue < 0) {
            xV = -xV;
        }
    }
    if (fabs(self.GigaplexlStick.yValue)  < Dead_Zone) {
        yV = 0.0f;
    }else{
        yV = (fabs(self.GigaplexlStick.yValue) - Dead_Zone) / (1- Dead_Zone);
        if (self.GigaplexlStick.yValue < 0) {
            yV = -yV;
        }
    }
#pragma  mark 曲线加速
    ActiveVX = tan(xV) * Vspeed;
    ActiveVY = tan(yV) * Vspeed;
    
    if (ActiveVX > 50.0f) {
        ActiveVX = 50.0f;
    }
    if (ActiveVX < -50.0f) {
        ActiveVX = -50.0f;
    }
    if (ActiveVY > 50.0f) {
        ActiveVY = 50.0f;
    }
    if (ActiveVY < -50.0f) {
        ActiveVY = -50.0f;
    }

    
    _RightvelocityVectorX = (UInt16)(ActiveVX * _rightunit / 50.0f * TiltVelocMaxValue * 100 + 3000);
    
    _RightvelocityVectorY = (UInt16)(ActiveVY * _rightunit / 50.0f * TiltVelocMaxValue * 100 + 3000);
    
    NSLog(@"Pan = %f Tilt = %f", ActiveVX , ActiveVY);
    NSLog(@"X = %d, Y = %d", _RightvelocityVectorX, _RightvelocityVectorY);
    
    UInt16 widthAngle = _PanAngle * 100;
    UInt16 heightAngle = _TiltAngle * 100;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    [_sendView sendGigaplexlWithCb:appDelegate.bleManager.panCB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x01 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:_RightvelocityVectorX andTiltSpeed:_RightvelocityVectorY andInterVal:intervalValue andStr:SendStr];
    
}


//string To十六进制字符串
- (NSString *)stringToHex:(NSString *)string
{
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    return hexStr;
}

- (void)viewDidAppear:(BOOL)animated{
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
