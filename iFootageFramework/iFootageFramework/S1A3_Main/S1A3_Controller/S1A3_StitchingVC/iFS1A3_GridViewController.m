//
//  iFS1A3_GridViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/24.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_GridViewController.h"
#import "iFootageRocker.h"
#import "iFLabelView.h"
#import "iFPanoView.h"
#import "ReceiveView.h"
#import "SendDataView.h"
#import "AppDelegate.h"
#import "iF3DButton.h"
#import "iFGetDataTool.h"
#import "iFAlertController.h"

#define Dead_Zone 0.2f
#define Vspeed 32.11

@interface iFS1A3_GridViewController ()<JSAnalogueStickDelegate>


@property (nonatomic, strong)iFLabelView * intervalLabel;
@property (nonatomic, strong)iFLabelView * PicturesLabel;
@property (nonatomic, strong)iFLabelView * RuntimeLabel;
@property (nonatomic, strong)iFLabelView * PanValueLabel;
@property (nonatomic, strong)iFLabelView * TiltValueLabel;
@property (nonatomic, strong)iFootageRocker * GigaplexlStick;
@property (nonatomic, strong)iFPanoView * PanoView;

@property (nonatomic, strong)iF3DButton * SetStartBtn;
@property (nonatomic, strong)iF3DButton * SetEndBtn;
@property (nonatomic, strong)iF3DButton * pauseBtn;
@property (nonatomic, strong)iF3DButton * playBtn;
@property (nonatomic, strong)iF3DButton * stopBtn;

/**
 *  发送视图
 */
@property (nonatomic, strong)SendDataView * sendDataView;
/**
 *  接收视图
 */
@property (nonatomic, strong)ReceiveView * receiveView;


@end

@implementation iFS1A3_GridViewController
{
    UIView * RockerBackgroundView;
    NSTimer * receiveTimer;//接受的定时器 进入页面开始开启退出页面关闭
    NSUInteger               Encode;//编码模式 ascii or  hex
    AppDelegate * appDelegate;
    
    int wCount, hCount;
    CGFloat ActiveVX; // 动态横坐标
    CGFloat ActiveVY; // 动态纵坐标
    NSData * data;
    BOOL _iSstart, _iSend;
    BOOL isRunning;
    
    NSTimer * startTimer;
    NSTimer * endTimer;
    
    NSTimer * playTimer;
    NSTimer * returnZeroTimer;
    NSTimer * pauseTimer;
    NSTimer * runTimer;
    UInt64  startTime;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _receiveView = [ReceiveView sharedInstance];
    _sendDataView = [[SendDataView alloc]init];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    isRunning = NO;
    
    self.titleLabel.text = @"Grid";
    [self createRocker];
    [self createUI];
    
    NSLog(@"%lf %lf", self.PanAngle, self.TiltAngle);
    
}

- (void)createUI{
    
    self.intervalLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Interval, nil) andInitValueStr:@"0s"];
    self.intervalLabel.ValueLabel.text = self.interval;
    [self.view addSubview:self.intervalLabel];
    
    self.PicturesLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Pictures, nil) andInitValueStr:@"0/1"];
    [self.view addSubview:self.PicturesLabel];
    
    self.RuntimeLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.4, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_RunTime, nil) andInitValueStr:@"00:00/00:00"];
    [self.view addSubview:self.RuntimeLabel];
    
    self.PanoView = [[iFPanoView alloc]initWithFrame:CGRectMake(50, AutoKScreenHeight * 0.2, AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5) andwCount:1 andhCount:1];
    [self.PanoView showLabelColorWith:1];
    [self.view addSubview:self.PanoView];
    
    self.PanValueLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(60, self.PanoView.frame.origin.y + 50 + self.PanoView.frame.size.height, AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08) andTitle:@"Pan value" andInitValueStr:[NSString stringWithFormat:@"%.2lf°", self.PanAngle]];
    [self.view addSubview:self.PanValueLabel];
    
    self.TiltValueLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(60, self.PanValueLabel.frame.origin.y + self.PanValueLabel.frame.size.height + 30, AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08) andTitle:@"Tilt value" andInitValueStr:[NSString stringWithFormat:@"%.2lf°", self.TiltAngle]];
    [self.view addSubview:self.TiltValueLabel];
    
    self.GigaplexlStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(0, 0, 125, 125)];
    
    self.GigaplexlStick.delegate = self;
    self.GigaplexlStick.center = CGPointMake(RockerBackgroundView.frame.size.width * 0.5, RockerBackgroundView.frame.size.height * 0.5);
    [RockerBackgroundView addSubview:self.GigaplexlStick];
    
    
    self.SetStartBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(20, RockerBackgroundView.frame.origin.y + RockerBackgroundView.frame.size.height + 25, 100, 40) WithTitle:@"Set start" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    
    _iSstart = NO;
    [self.SetStartBtn.actionBtn addTarget:self action:@selector(setStartPoint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.SetStartBtn];
    
    
    self.SetEndBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(self.SetStartBtn.frame.size.width + self.SetStartBtn.frame.origin.x + 24, RockerBackgroundView.frame.origin.y + RockerBackgroundView.frame.size.height + 25, 100, 40) WithTitle:@"Set end" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    _iSend = NO;
    self.SetEndBtn.actionBtn.selected = _iSend;
    [self.SetEndBtn.actionBtn addTarget:self action:@selector(setEndPoint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.SetEndBtn];
    
    
    
    self.pauseBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(self.SetEndBtn.frame.size.width + self.SetEndBtn.frame.origin.x + 20,RockerBackgroundView.frame.origin.y + RockerBackgroundView.frame.size.height + 20, 50, 50) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    [self.pauseBtn.actionBtn addTarget:self action:@selector(pauseActionTimer:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.alpha = 0;
    [self.view addSubview:self.pauseBtn];
    
    
    self.playBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(self.SetEndBtn.frame.size.width + self.SetEndBtn.frame.origin.x + 20, RockerBackgroundView.frame.origin.y + RockerBackgroundView.frame.size.height + 20, 50, 50) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PALYBTNIMG];
    self.playBtn.alpha = 1;
    [self.playBtn.actionBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
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
        [_sendDataView sendGigaplexlWithCb:appDelegate.bleManager.S1A3_X2CB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x05 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
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
        [_sendDataView sendGigaplexlWithCb:appDelegate.bleManager.S1A3_X2CB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x06 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
    }
    
}
- (void)runtimeTimer:(NSTimer *)timer{
    NSLog(@"runtimeTimer");
    
    
    UInt64 nowTime = [[NSDate date]timeIntervalSince1970] * 1000;
    if (_receiveView.S1A3_X2_Grid_Mode == 0x02) {
        isRunning = YES;
        
        self.RuntimeLabel.ValueLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: (nowTime - startTime) / 1000], [iFGetDataTool getTimeWith:self.totalTime]];
        
    }else{
        timer.fireDate = [NSDate distantFuture];
        
    }
}
- (void)pauseActionTimer:(NSTimer *)timer{
    NSLog(@"pauseActionTimer");
    
    if (_receiveView.S1A3_X2_Grid_Mode == 0x04) {
//        count = 0;
        timer.fireDate = [NSDate distantFuture];
        runTimer.fireDate = [NSDate distantFuture];
    }else{
        UInt16 widthAngle = _PanAngle * 100;
        UInt16 heightAngle = _TiltAngle * 100;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        [_sendDataView sendGigaplexlWithCb:appDelegate.bleManager.S1A3_X2CB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x04 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
    }
}
- (void)playAction{
    NSLog(@"playAction");
    if (!_iSend || !_iSstart) {
        UIAlertController * alertView = [iFAlertController showAlertControllerWith:NSLocalizedString(Timeline_WarmTips, nil) Message:NSLocalizedString(Timeline_AddRightFramesWarning, nil) SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
        }];
        [self presentViewController:alertView animated:YES completion:nil];
    }else{
        self.playBtn.alpha = 0;
        self.pauseBtn.alpha = 1;
        returnZeroTimer.fireDate = [NSDate distantPast];
    }
}
- (void)changeBackViewWithPanNumber:(int)pannumber andTiltNumber:(int)tiltnumber{

    [self.PanoView removeFromSuperview];
    self.PanoView = [[iFPanoView alloc]initWithFrame:CGRectMake(50, kScreenHeight * 0.2, AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5) andwCount:pannumber andhCount:tiltnumber];
    self.PanoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.PanoView];
    
}
- (void)judgeIsSetStartPointSuccess:(NSTimer *)timer{
    NSLog(@"judgeIsSetStartPointSuccess");
    
    CGFloat tiltStartAngle = (_receiveView.S1A3_X2_Grid_StartTiltAngle - 3600) / 10.00f;
    CGFloat panStartAngle = (_receiveView.S1A3_X2_Grid_StartPanAngle - 3600) / 10.00f;
    CGFloat panRealAngle = (_receiveView.S1A3_X2_Grid_PanAngle - 3600) / 10.00f;
    CGFloat tiltRealAngle = (_receiveView.S1A3_X2_Grid_TiltAngle - 3600) / 10.00f;
    
    
    if (_receiveView.S1A3_X2_Grid_Mode!= 2) {
        if (panRealAngle == panStartAngle && tiltRealAngle == tiltStartAngle) {
            _iSstart = YES;
            self.SetStartBtn.backgroundColor = [UIColor grayColor];
            self.SetStartBtn.actionBtn.selected = YES;
            
            timer.fireDate = [NSDate distantFuture];
            if (_iSend == YES && _iSstart == YES) {
                
                CGFloat panStartAngle = (_receiveView.S1A3_X2_Grid_StartPanAngle - 3600) / 10.00f;
                CGFloat tiltStartAngle = (_receiveView.S1A3_X2_Grid_StartTiltAngle - 3600) / 10.00f;
                CGFloat panEndAngle = (_receiveView.S1A3_X2_Grid_EndPanAngle - 3600) / 10.00f;
                CGFloat tiltEndAngle = (_receiveView.S1A3_X2_Grid_EndTiltAngle - 3600) / 10.00f;
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
    NSLog(@"judgeIsSetEndPointSuccess");
    
    CGFloat panRealAngle = (_receiveView.S1A3_X2_Grid_PanAngle - 3600) / 10.00f;
    CGFloat tiltRealAngle = (_receiveView.S1A3_X2_Grid_TiltAngle - 3600) / 10.00f;
    CGFloat tiltEndAngle = (_receiveView.S1A3_X2_Grid_EndTiltAngle - 3600) / 10.00f;
    CGFloat panEndAngle = (_receiveView.S1A3_X2_Grid_EndPanAngle - 3600) / 10.00f;

    if (_receiveView.S1A3_X2_Grid_Mode != 2) {
        
        if (panRealAngle == panEndAngle && tiltRealAngle == tiltEndAngle) {
            _iSend = YES;
            //            self.SetEndBtn.backgroundColor = [UIColor grayColor];
            self.SetEndBtn.actionBtn.selected = YES;
            
            timer.fireDate = [NSDate distantFuture];
            
            if (_iSend == YES && _iSstart == YES) {
                NSLog(@"end +++++++++++++++++++++++++++++++++++++");
                
                CGFloat panStartAngle = (_receiveView.S1A3_X2_Grid_StartPanAngle - 3600) / 10.0f;
                CGFloat tiltStartAngle = (_receiveView.S1A3_X2_Grid_StartTiltAngle - 3600) / 10.0f;
                CGFloat panEndAngle = (_receiveView.S1A3_X2_Grid_EndPanAngle - 3600) / 10.0f;
                CGFloat tiltEndAngle = (_receiveView.S1A3_X2_Grid_EndTiltAngle - 3600) / 10.0f;
                int panNumber = ceil(fabs(panEndAngle - panStartAngle) / _PanAngle) + 1;
                int tiltNumber = ceil(fabs(tiltEndAngle - tiltStartAngle) / _TiltAngle) + 1;
                [self changeBackViewWithPanNumber:panNumber andTiltNumber:tiltNumber];
                
                self.RuntimeLabel.ValueLabel.text =[NSString stringWithFormat:@"00:00/%@", [iFGetDataTool getTimeWith:((panNumber * tiltNumber - 1) * [self.interval integerValue])]];
                self.PicturesLabel.ValueLabel.text = [NSString stringWithFormat:@"%d/%d", _receiveView.GiFrameCurrent, panNumber * tiltNumber];
                
            }
        }
    }
}

- (void)readyGoReturnZero:(NSTimer *)timer{
    NSLog(@"readyGoReturnZero");
    
    if (_receiveView.S1A3_X2_Grid_Mode == 0x01) {
        timer.fireDate = [NSDate distantFuture];
        playTimer.fireDate = [NSDate distantPast];
    }else{
        
        UInt16 widthAngle = _PanAngle * 100;
        UInt16 heightAngle = _TiltAngle * 100;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        NSLog(@"%d", intervalValue);
        
        [_sendDataView sendGigaplexlWithCb:appDelegate.bleManager.S1A3_X2CB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x00 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];

        
    }
}

- (void)readyGoAction:(NSTimer *)timer{
    NSLog(@"readyGoAction");
    
    if (_receiveView.S1A3_X2_Grid_Mode == 0x02) {
        
        startTime = [[NSDate date]timeIntervalSince1970] * 1000;
        
        runTimer.fireDate = [NSDate distantPast];
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        UInt16 widthAngle = _PanAngle * 100;
        UInt16 heightAngle = _TiltAngle * 100;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        [_sendDataView sendGigaplexlWithCb:appDelegate.bleManager.S1A3_X2CB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x02 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:0x00 andTiltSpeed:0x00 andInterVal:intervalValue andStr:SendStr];
        
    }
    
}

- (void)createRocker{
    RockerBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    RockerBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:RockerBackgroundView];
}

#pragma mark -----创建所有的定时器集合-------
- (void)createAllTimer{
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:ReceiveSecond target:self selector:@selector(S1A3_receiveRealTimeData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];
    
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
    
    pauseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(StopActionTimer:) userInfo:nil repeats:YES];
    pauseTimer.fireDate = [NSDate distantFuture];
    
}
- (void)closeAllTimer{

    startTimer.fireDate = [NSDate distantFuture];
    endTimer.fireDate = [NSDate distantFuture];
    playTimer.fireDate = [NSDate distantFuture];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    pauseTimer.fireDate = [NSDate distantFuture];
    receiveTimer.fireDate = [NSDate distantFuture];
    [receiveTimer invalidate];
    receiveTimer = nil;
}
#pragma mark ----S1A3_receiveRealTimeData -----
- (void)S1A3_receiveRealTimeData{
//    NSLog(@"S1A3_X2_Grid_Mode %d", _receiveView.S1A3_X2_Grid_Mode);
//    NSLog(@"S1A3_X2_Grid_PanAngle %d", _receiveView.S1A3_X2_Grid_PanAngle);
//    NSLog(@"S1A3_X2_Grid_TiltAngle %d", _receiveView.S1A3_X2_Grid_TiltAngle);
//    NSLog(@"S1A3_X2_Grid_Interval %d", _receiveView.S1A3_X2_Grid_Interval);
//    NSLog(@"S1A3_X2_Grid_StartPanAngle %d", _receiveView.S1A3_X2_Grid_StartPanAngle);
//    NSLog(@"S1A3_X2_Grid_StartTiltAngle %d", _receiveView.S1A3_X2_Grid_StartTiltAngle);
//    NSLog(@"S1A3_X2_Grid_EndPanAngle %d", _receiveView.S1A3_X2_Grid_EndPanAngle);
//    NSLog(@"S1A3_X2_Grid_EndTiltAngle %d", _receiveView.S1A3_X2_Grid_EndTiltAngle);
  
    CGFloat panStartAngle = (_receiveView.S1A3_X2_Grid_StartPanAngle - 3600) / 10.00f;
    CGFloat tiltStartAngle = (_receiveView.S1A3_X2_Grid_StartTiltAngle - 3600) / 10.00f;
    CGFloat panEndAngle = (_receiveView.S1A3_X2_Grid_EndPanAngle - 3600) / 10.00f;
    CGFloat tiltEndAngle = (_receiveView.S1A3_X2_Grid_EndTiltAngle - 3600) / 10.00f;
    int panNumber = ceil(fabs(panEndAngle - panStartAngle) / _PanAngle) + 1;
    int tiltNumber = ceil(fabs(tiltEndAngle - tiltStartAngle) / _TiltAngle) + 1;
    self.totalTime = panNumber * tiltNumber * [self.interval integerValue];
    
    //    if (_receiveView.GiFrameCurrent <= 0 ) {
    //
    //    }else{
    NSLog(@"%d", isRunning);
    
    [self changeBackViewWithPanNumber:panNumber andTiltNumber:tiltNumber];
    [self.PanoView showLabelColorWith:_receiveView.S1A3_X2_Grid_FrameNow];
    
    //        self.RuntimeValueLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith:count], [iFGetDataTool getTimeWith:self.totalTime]];
    self.PicturesLabel.ValueLabel.text = [NSString stringWithFormat:@"%d/%d", _receiveView.S1A3_X2_Grid_FrameNow, panNumber * tiltNumber];
    //    }
    if (isRunning) {
        
    if (_receiveView.S1A3_X2_Grid_Mode == 0x02) {
        self.pauseBtn.alpha = 1;
        self.playBtn.alpha = 0;
    }else if (_receiveView.S1A3_X2_Grid_Mode == 0x01){
            self.pauseBtn.alpha = 1;
            self.playBtn.alpha = 0;
    }else if( _receiveView.S1A3_X2_Grid_Mode == 0x04){
        self.pauseBtn.alpha = 0;
        self.playBtn.alpha = 1;
        isRunning = NO;
        }
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
    
    [self.PanoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(AutoKScreenHeight * 0.2);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5));
    }];
    [self.PanValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PanoView.mas_bottom);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
    }];
    [self.TiltValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.equalTo(self.PanValueLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
    }];
    [RockerBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PanValueLabel.mas_right);
        make.top.equalTo(self.PanValueLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5));
    }];
    
    [self.SetStartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(RockerBackgroundView.mas_bottom);
        }
        
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.SetEndBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetStartBtn.mas_right).offset(10);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(RockerBackgroundView.mas_bottom);
        }
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.pauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(RockerBackgroundView.mas_bottom);
        }        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        if(kDevice_Is_iPad){
            make.top.equalTo(self.TiltValueLabel.mas_bottom).offset(50);
        }else{
            make.top.equalTo(RockerBackgroundView.mas_bottom);
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
    [self.PanoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intervalLabel.mas_bottom);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.75, AutoKscreenWidth * 0.5));
    }];
    [self.PanValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PanoView.mas_bottom);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
    }];
    [self.TiltValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PanValueLabel.mas_right).offset(30);
        make.top.equalTo(self.PanValueLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08));
        
    }];
    [RockerBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-50);
        make.bottom.equalTo(self.PanoView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5));
    }];
    
    [self.SetStartBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PanoView.mas_right).offset(20);
        make.top.equalTo(self.PanoView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.SetEndBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetStartBtn.mas_right).offset(10);
        make.top.equalTo(self.PanoView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.pauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        make.top.equalTo(self.PanoView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.SetEndBtn.mas_right).offset(10);
        make.top.equalTo(self.PanoView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    
    
}
#pragma mark ------ 手动操作 ---------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint rightPoint = [[touches anyObject] locationInView:RockerBackgroundView];
    
    if ([RockerBackgroundView.layer containsPoint:rightPoint]) {
        self.GigaplexlStick.center = rightPoint;
        [self.GigaplexlStick touchesBegan];
        }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    [self.GigaplexlStick reset];
    [self.GigaplexlStick touchesEnded];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    CGPoint rightPoint = [[touches anyObject] locationInView:RockerBackgroundView];
    
    if ([RockerBackgroundView.layer containsPoint:rightPoint]){
        [self.GigaplexlStick autoPoint:rightPoint];
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    [self.GigaplexlStick reset];
    [self.GigaplexlStick touchesCancelled];
    
}
#pragma mark --------  摇杆代理  ------------

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
    
    
    _RightvelocityVectorX = (UInt16)(ActiveVX  / 50.0f * S1A3_TiltVelocMaxValue * 100 + 4000);
    
    _RightvelocityVectorY = (UInt16)(ActiveVY  / 50.0f * S1A3_TiltVelocMaxValue * 100 + 4000);
    
    NSLog(@"Pan = %f Tilt = %f", ActiveVX , ActiveVY);
    NSLog(@"X = %d, Y = %d", _RightvelocityVectorX, _RightvelocityVectorY);
    
    UInt16 widthAngle = _PanAngle * 100;
    UInt16 heightAngle = _TiltAngle * 100;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    
    [_sendDataView sendGigaplexlWithCb:appDelegate.bleManager.S1A3_X2CB andFameHead:OX555F andFunctionNumber:0x08 andFunctionMode:0x01 andWidthAngle:widthAngle andHeightAngle:heightAngle andPanSpeed:_RightvelocityVectorX andTiltSpeed:_RightvelocityVectorY andInterVal:intervalValue andStr:SendStr];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self VerticalscreenUI];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        [self LandscapescreenUI];
        
    }
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



- (void)viewWillAppear:(BOOL)animated{
    [self createAllTimer];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [self closeAllTimer];
    
    
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
