//
//  iFS1A3_PanoViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/24.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_PanoViewController.h"
#import "iFLabelView.h"
#import "iFCirlePanoVIew.h"
#import "ReceiveView.h"
#import "SendDataView.h"
#import "iF3DButton.h"
#import "AppDelegate.h"
#import "iFGetDataTool.h"
#import "iFS1A3_Model.h"
#import "iFTiltView.h"


@interface iFS1A3_PanoViewController ()<getStartAngleAndEndAngleDelegate, changeTiltVelocDelegate>



@property (nonatomic, strong)iFLabelView * intervalLabel;
@property (nonatomic, strong)iFLabelView * PicturesLabel;
@property (nonatomic, strong)iFLabelView * RuntimeLabel;
@property (nonatomic, strong)iFLabelView * PanValueLabel;
@property (nonatomic, strong)iFLabelView * TiltValueLabel;
@property (nonatomic, strong)iF3DButton * playBtn;
@property (nonatomic, strong)iF3DButton * pauseBtn;

/**
 *  发送视图
 */
@property (nonatomic, strong)SendDataView * sendDataView;
/**
 *  接收视图
 */
@property (nonatomic, strong)ReceiveView * receiveView;


@end

@implementation iFS1A3_PanoViewController
{
    UIView * cirBackView;
    NSTimer * receiveTimer;//接受的定时器 进入页面开始开启退出页面关闭
    NSUInteger               Encode;//编码模式 ascii or  hex
    AppDelegate * appDelegate;
    CGFloat startValue;
    CGFloat endValue;
    NSTimer * playTimer;
    NSTimer * pauseTimer;
    NSTimer * stopTimer;
    NSTimer * returnTimer;
    NSTimer * runTimer;
    UInt64 startTime;//开始时间（64位）
    BOOL _isStart;
    iFCirlePanoVIew * ifcir;
    iFS1A3_Model * S1A3Model;
    iFLabel * degreeLabel;
    
    iFTiltView * TiltView;

    NSString * sendStr;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isStart = NO;

    self.titleLabel.text = @"Pano";
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _receiveView = [ReceiveView sharedInstance];
    _sendDataView = [[SendDataView alloc]init];
    S1A3Model = [[iFS1A3_Model alloc]init];
    
    [self createUI];
    NSData * dataStr = [[self stringToHex:self.RuntimeLabel.ValueLabel.text] dataUsingEncoding:NSUTF8StringEncoding];
    sendStr = [NSString stringWithFormat:@"%@", dataStr];
    
    
}

- (void)createUI{
    
    self.intervalLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Interval, nil) andInitValueStr:@"0s"];
    self.intervalLabel.ValueLabel.text = self.interval;
    [self.view addSubview:self.intervalLabel];
    
    self.PicturesLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Pictures, nil) andInitValueStr:@"0/1"];
    [self.view addSubview:self.PicturesLabel];
    
    self.RuntimeLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.4, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_RunTime, nil) andInitValueStr:@"00:00/00:00"];
    [self.view addSubview:self.RuntimeLabel];
    
    cirBackView = [UIView new];
    cirBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cirBackView];
    
    ifcir = [[iFCirlePanoVIew alloc]initWithFrame:CGRectMake(0, 0, AutoKscreenWidth * 0.8, AutoKscreenWidth * 0.8)];
    ifcir.delegate = self;
    ifcir.sliceView.totalNumber = ceil(360.0f / self.aOneAngle);
    [cirBackView addSubview:ifcir];
    
    self.playBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(219), iFSize(527), 50, 50) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PALYBTNIMG];
    self.playBtn.alpha = 1;
    self.playBtn.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5 + kScreenWidth * 0.5 + 30);
    [self.playBtn.actionBtn addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
    self.pauseBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(109), iFSize(527), 50, 50) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    self.pauseBtn.center = CGPointMake(kScreenWidth * 0.35, kScreenHeight * 0.5 + kScreenWidth * 0.5 + 30);
    [self.pauseBtn.actionBtn addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.alpha = 0;
    
    [self.view addSubview:self.pauseBtn];
    
    degreeLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(60), iFSize(30)) WithTitle:@"0°" andFont:24];
    [cirBackView addSubview:degreeLabel];
    
//    self.PanValueLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(60, self.PanoView.frame.origin.y + 50 + self.PanoView.frame.size.height, AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08) andTitle:@"Pan value" andInitValueStr:[NSString stringWithFormat:@"%.2lf°", 99.99]];
//    [self.view addSubview:self.PanValueLabel];
    
//    self.TiltValueLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(60, self.PanValueLabel.frame.origin.y + self.PanValueLabel.frame.size.height + 30, AutoKscreenWidth * 0.3, AutoKScreenHeight * 0.08) andTitle:@"Tilt value" andInitValueStr:[NSString stringWithFormat:@"%.2lf°", 99.99]];
//    [self.view addSubview:self.TiltValueLabel];
    
}
- (void)getStartAngle:(CGFloat)startAngle EndAngle:(CGFloat)endAngle{
    
    CGFloat angle;
    if (endAngle > 1) {
        angle = endAngle - 1.0f;
    }else{
        angle = endAngle;
    }
    degreeLabel.text = [NSString stringWithFormat:@"%.0f°", startAngle * 360];

//    data = [[self stringToHex:self.RuntimeLabel.ValueLabel.text] dataUsingEncoding:NSUTF8StringEncoding];
    UInt16 oneAngle = (UInt16)self.aOneAngle * 100;
    UInt16 StartAngle = (UInt16)(startAngle * 360.0f) * 10;
    UInt16 EndAngle = (UInt16)(endAngle * 360.0f) * 10;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    
    startValue = startAngle * 360.0f;

    endValue = angle * 360.0f;
    
    self.totalTime = (ceilf(abs((StartAngle - EndAngle)) / self.aOneAngle)) * intervalValue;
    
//    self.RuntimeLabel.ValueLabel.text = [NSString stringWithFormat:@"00:00/%@", [iFGetDataTool getTimeWith:self.totalTime]];
    
    if (ifcir.cir.isTouch) {
        [_sendDataView sendPanoramaWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x01 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
    }
}
- (void)startAction:(UISlider *)slider{
    
    UISlider * slide1 = [self.view viewWithTag:101];
    startValue = slide1.value;
    
    NSLog(@"%f", slide1.value);
    UISlider * slide2 = [self.view viewWithTag:102];
    endValue = slide2.value;
    
    NSLog(@"%f", slide2.value);
    
    UInt16 oneAngle = (UInt16)self.aOneAngle * 100;
    UInt16 StartAngle = (UInt16)slide1.value * 10;
    UInt16 EndAngle = (UInt16)slide2.value * 10;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    
    [_sendDataView  sendPanoramaWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x01 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
    
    
}

- (void)playAction{
    if (appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
        _playBtn.alpha = 0;
        _pauseBtn.alpha = 1;
        
        returnTimer.fireDate = [NSDate distantPast];
    }else{
        _isRunning = NO;

        NSLog(@"未连接");
        
    }
}
- (void)stopAction{

    _playBtn.alpha = 1;
    _pauseBtn.alpha = 0;
    pauseTimer.fireDate = [NSDate distantPast];
    runTimer.fireDate = [NSDate distantFuture];
    playTimer.fireDate = [NSDate distantFuture];
    stopTimer.fireDate = [NSDate distantFuture];
    returnTimer.fireDate = [NSDate distantFuture];
    
}
#pragma mark -----创建所有的定时器集合-------
- (void)createAllTimer{
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:ReceiveSecond target:self selector:@selector(S1A3_receiveRealTimeData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];
    
    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(playActionTimer:) userInfo:nil repeats:YES];
    playTimer.fireDate = [NSDate distantFuture];
    
    pauseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(pauseActionTimer:) userInfo:nil repeats:YES];
    pauseTimer.fireDate = [NSDate distantFuture];
    
    
    returnTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(returnZeroTimer:) userInfo:nil repeats:YES];
    returnTimer.fireDate = [NSDate distantFuture];
    
    runTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(runtimeTimer:) userInfo:nil repeats:YES];
    runTimer.fireDate = [NSDate distantFuture];
    
    
}
- (void)closeAllTimer{
    receiveTimer.fireDate = [NSDate distantPast];
    [receiveTimer invalidate];
    receiveTimer = nil;
}
#pragma mark ----S1A3_receiveRealTimeData -----
- (void)S1A3_receiveRealTimeData{
    ifcir.sliceView.lightSliceNumber = _receiveView.S1A3_X2_Pano_CurrentFrame;
    self.PicturesLabel.ValueLabel.text = [NSString stringWithFormat:@"%d/%lu", _receiveView.S1A3_X2_Pano_CurrentFrame,(unsigned long)ceil(360 / self.aOneAngle)];

    NSLog(@"S1A3_X2_Pano_Mode %d", _receiveView.S1A3_X2_Pano_Mode);
    NSLog(@"S1A3_X2_Pano_Angle %d", _receiveView.S1A3_X2_Pano_Angle);
    NSLog(@"S1A3_X2_Pano_StartAngle %f", _receiveView.S1A3_X2_Pano_StartAngle / 10.0f);
    NSLog(@"S1A3_X2_Pano_EndAngle %f", _receiveView.S1A3_X2_Pano_EndAngle / 10.0f);
    NSLog(@"S1A3_X2_Pano_Interval %d", _receiveView.S1A3_X2_Pano_Interval);
    NSLog(@"S1A3_X2_Pano_CurrentFrame %d", _receiveView.S1A3_X2_Pano_CurrentFrame);

    
    if (_isRunning) {
        
        if (_receiveView.S1A3_X2_Pano_Mode == 0x02) {
            self.pauseBtn.alpha = 1;
            self.playBtn.alpha= 0;
        }else if (_receiveView.S1A3_X2_Pano_Mode == 0x01){
            //        self.pauseBtn.alpha = 1;
            //        self.playBtn.alpha= 0;
        }else{
            _isRunning = NO;
            
            self.pauseBtn.alpha = 0;
            self.playBtn.alpha = 1;
        }
    }


}
- (void)playActionTimer:(NSTimer *)timer{
    NSLog(@"playActionTimer");
    
    if (_receiveView.S1A3_X2_Pano_Mode == 0x02) {

        startTime = [[NSDate date]timeIntervalSince1970] * 1000;
        runTimer.fireDate = [NSDate distantPast];
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        _isStart = YES;
        UInt16 oneAngle = (UInt16)self.aOneAngle * 100;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        UInt16 StartAngle = (UInt16)startValue * 10;
        UInt16 EndAngle = (UInt16)endValue * 10;
        
        [_sendDataView sendPanoramaWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x02 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
    }
    
}
- (void)pauseActionTimer:(NSTimer *)timer{
    NSLog(@"pauseActionTimer");
    
    _isRunning = NO;
    _playBtn.alpha = 1;
    _pauseBtn.alpha = 0;
    if (_receiveView.S1A3_X2_Pano_Mode == 0x04) {
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        
        [_sendDataView sendPanoramaWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x04 andAngle:0x00 andStartAngle:0x00 andEndAngle:0x00 andInterVal:0x00 WithStr:sendStr andTiltVeloc:0x00];
        
    }}
- (void)returnZeroTimer:(NSTimer *)timer{
    NSLog(@"returnZeroTimer");
    
    if (_receiveView.S1A3_X2_Pano_Mode == 0x01) {
        
        playTimer.fireDate = [NSDate distantPast];
        timer.fireDate = [NSDate distantFuture];
    }else{
        UInt16 oneAngle = (UInt16)self.aOneAngle * 100;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        UInt16 StartAngle = (UInt16)startValue * 10;
        UInt16 EndAngle = (UInt16)endValue * 10;
        [_sendDataView sendPanoramaWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x00 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
    }
}
- (void)runtimeTimer:(NSTimer *)timer{
    NSLog(@"runtimeTimer");
    UInt64 nowTime = [[NSDate date]timeIntervalSince1970] * 1000;
    if (_receiveView.S1A3_X2_Pano_Mode == 0x02) {
        
        self.RuntimeLabel.ValueLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: (nowTime - startTime) / 1000], [iFGetDataTool getTimeWith:([_interval integerValue] * (ifcir.sliceView.currentNumber - 1))]];
        
    }else{
        self.playBtn.alpha = 1;
        self.pauseBtn.alpha = 0;
        
        timer.fireDate = [NSDate distantFuture];
//
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
    [cirBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(AutoKscreenWidth * 0.8);
    }];
    [degreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(60);
    }];
    
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cirBackView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.pauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cirBackView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [TiltView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(30, 100));
    }];
}
//横屏
- (void)LandscapescreenUI{
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    [self.PicturesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    [self.RuntimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-64);
        make.left.equalTo(self.rootbackBtn.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07));
    }];
    [cirBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(AutoKscreenWidth * 0.8);
    }];
    [degreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(60);
    }];
    [self.playBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(cirBackView.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.pauseBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(cirBackView.mas_right).offset(40);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [TiltView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(30, 100));
    }];
}
- (void)changeTiltVolocAction:(CGFloat)velocValue{
    NSLog(@"velocValue = %lf", velocValue);
    
    UInt16 tiltveloc = velocValue * 40.0f * 10.0f + 300.0f;
    
    
    [_sendDataView  sendPanoramaWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x05 andAngle:0x00 andStartAngle:0x00 andEndAngle:0x00 andInterVal:0x00 WithStr:SendStr andTiltVeloc:tiltveloc];
    
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


- (void)viewWillAppear:(BOOL)animated{
    [TiltView removeFromSuperview];
    
    TiltView = [[iFTiltView alloc]initWithFrame:CGRectMake(iFSize(310), iFSize(465), 30, 100)];
    TiltView.backgroundColor = [UIColor clearColor];
    TiltView.delegate = self;
    TiltView.center = CGPointMake(kScreenWidth * 0.85, kScreenHeight * 0.5 + kScreenWidth * 0.5);
    [self.view addSubview:TiltView];
    

    [self createAllTimer];
    ifcir.cir.progress = (S1A3Model.S1A3_Pano_StartAngle);
    ifcir.sliceView.progress = (S1A3Model.S1A3_Pano_EndAngle);
}
- (void)viewWillDisappear:(BOOL)animated{
    S1A3Model.S1A3_Pano_StartAngle = ifcir.cir.progress;
    S1A3Model.S1A3_Pano_EndAngle = ifcir.sliceView.progress;
    [self closeAllTimer];
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
