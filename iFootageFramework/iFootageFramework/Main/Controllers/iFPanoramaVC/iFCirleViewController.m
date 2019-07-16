//
//  iFCirleViewController.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFCirleViewController.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "AppDelegate.h"
#import "iFCirlePanoVIew.h"
#import "iFGetDataTool.h"
#import "iFTiltView.h"


@interface iFCirleViewController ()<getStartAngleAndEndAngleDelegate, changeTiltVelocDelegate>

{
    UIView * cirBackView;
    SendDataView * _sendView;
    ReceiveView * _receiveView;
    NSTimer * receiveTimer;
    NSUInteger               Encode;//编码模式 ascii or  hex
    AppDelegate * appDelegate;
    CGFloat startValue;
    CGFloat endValue;
    NSData * data;
    iFCirlePanoVIew * ifcir;
    BOOL _isStart;
    
    NSTimer * playTimer;
    NSTimer * pauseTimer;
    NSTimer * stopTimer;
    NSTimer * returnTimer;
    NSTimer * runTimer;
    NSString * sendStr;
    
    UInt64 startTime;//开始时间（64位）

    iFTiltView * TiltView;
    
    
}
@end


@implementation iFCirleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.titleLabel.text = NSLocalizedString(Stiching_Pano, nil);
    
    _isStart = NO;
    
    _sendView = [[SendDataView alloc]init];
    _receiveView = [ReceiveView sharedInstance];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    cirBackView = [UIView new];
    cirBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cirBackView];
    
    [ifcir removeFromSuperview];
    ifcir = [[iFCirlePanoVIew alloc]initWithFrame:CGRectMake(0,  0, AutoKscreenWidth * 0.8, AutoKscreenWidth * 0.8)];
    ifcir.delegate = self;
    ifcir.sliceView.totalNumber = ceil(360.0f / self.aOneAngle);
//    ifcir.center = CGPointMake(self.view.bounds.size.width / 2, kScreenHeight * 0.5);
    ifcir.backgroundColor = [UIColor clearColor];
    [cirBackView addSubview:ifcir];
    
    [self.degreeLabel removeFromSuperview];
    self.degreeLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(60), iFSize(30)) WithTitle:@"0°" andFont:24];
    self.degreeLabel.textAlignment = NSTextAlignmentCenter;
    self.degreeLabel.center = ifcir.center;
    [cirBackView addSubview:self.degreeLabel];
    
    self.intervalLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.1, kScreenHeight * 0.1, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Interval, nil) andInitValueStr:@"0s"];
    self.intervalLabel.ValueLabel.text = self.interval;
    [self.view addSubview:self.intervalLabel];
    
    self.PicturesLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.35, kScreenHeight * 0.1, AutoKscreenWidth * 0.25, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_Pictures, nil) andInitValueStr:@"0/1"];
    [self.view addSubview:self.PicturesLabel];
    
    self.RuntimeLabel = [[iFLabelView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.6, kScreenHeight * 0.1, AutoKscreenWidth * 0.4, AutoKScreenHeight * 0.07) andTitle:NSLocalizedString(Stiching_RunTime, nil) andInitValueStr:@"00:00/00:00"];
    [self.view addSubview:self.RuntimeLabel];

    
    self.pauseBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(219), iFSize(527), 50, 50) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    self.pauseBtn.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5 + kScreenWidth * 0.5 + 30);
    
    [self.pauseBtn.actionBtn addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.pauseBtn.alpha = 0;
    [self.view addSubview:self.pauseBtn];
    
    
    self.playBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(219), iFSize(527), 50, 50) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PALYBTNIMG];
    self.playBtn.alpha = 1;
    self.playBtn.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5 + kScreenWidth * 0.5 + 30);
    [self.playBtn.actionBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playBtn];
    
    
    self.stopBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(109), iFSize(527), 50, 50) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    self.stopBtn.center = CGPointMake(kScreenWidth * 0.35, kScreenHeight * 0.5 + kScreenWidth * 0.5 + 30);
    [self.stopBtn.actionBtn addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.stopBtn];


    


    playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(playActionTimer:) userInfo:nil repeats:YES];
    playTimer.fireDate = [NSDate distantFuture];
    
    pauseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(pauseActionTimer:) userInfo:nil repeats:YES];
    pauseTimer.fireDate = [NSDate distantFuture];
    
    returnTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(returnZeroTimer:) userInfo:nil repeats:YES];
    returnTimer.fireDate = [NSDate distantFuture];
    
    runTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(runtimeTimer:) userInfo:nil repeats:YES];
    runTimer.fireDate = [NSDate distantFuture];
    NSLog(@"%lf", self.aOneAngle);
    
    NSData * dataStr = [[self stringToHex:self.RuntimeLabel.ValueLabel.text] dataUsingEncoding:NSUTF8StringEncoding];
    sendStr = [NSString stringWithFormat:@"%@", dataStr];
    
   
    
}
- (void)changeTiltVolocAction:(CGFloat)velocValue{
    NSLog(@"velocValue = %lf", velocValue);
    
    UInt16 tiltveloc = velocValue * 30.0f * 10.0f + 300.0f;
    
    NSLog(@"%hu", tiltveloc);
    
    [_sendView  sendPanoramaWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x05 andAngle:0x00 andStartAngle:0x00 andEndAngle:startValue * 10 andInterVal:endValue * 10 WithStr:SendStr andTiltVeloc:tiltveloc];
    
}

- (void)runtimeTimer:(NSTimer *)timer{
    UInt64 nowTime = [[NSDate date]timeIntervalSince1970] * 1000;
    if (_receiveView.Pamode == 0x02) {
         self.RuntimeLabel.ValueLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: (nowTime - startTime) / 1000], [iFGetDataTool getTimeWith:([_interval integerValue] * ifcir.sliceView.currentNumber)]];
    }else{
        timer.fireDate = [NSDate distantFuture];
        
    }
}
- (void)getStartAngle:(CGFloat)startAngle EndAngle:(CGFloat)endAngle{
    
    CGFloat angle;
    if (endAngle > 1) {
        angle = endAngle - 1.0f;
    }else{
        angle = endAngle;
    }
//    NSLog(@"Start = %lf end = %lf", startAngle * 360, angle * 360);
    self.degreeLabel.text = [NSString stringWithFormat:@"%.0f°", startAngle * 360];
    
    data = [[self stringToHex:self.RuntimeLabel.ValueLabel.text] dataUsingEncoding:NSUTF8StringEncoding];
    UInt16 oneAngle = self.aOneAngle * 100.0f;
    UInt16 StartAngle = (UInt16)(startAngle * 360.0f) * 10;
    UInt16 EndAngle = (UInt16)(endAngle * 360.0f) * 10;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    
    startValue = startAngle * 360.0f;
//        NSLog(@"start = %d", _isStart);
    endValue = angle * 360.0f;
    
    self.totalTime = (ceilf(abs((StartAngle - EndAngle)) / self.aOneAngle)) * intervalValue;

    if (ifcir.cir.isTouch) {
        
        
             [_sendView  sendPanoramaWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x01 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
        
        
    }
    
 
}

- (void)startAction:(UISlider *)slider{
    
    UISlider * slide1 = [self.view viewWithTag:101];
    startValue = slide1.value;
    NSLog(@"%f", slide1.value);
    UISlider * slide2 = [self.view viewWithTag:102];
    endValue = slide2.value;
    NSLog(@"%f", slide2.value);
    
    UInt16 oneAngle =self.aOneAngle * 100.0f;
    UInt16 StartAngle = slide1.value * 10;
    UInt16 EndAngle = slide2.value * 10;
    UInt8 intervalValue = (UInt8)[_interval integerValue];
    [_sendView  sendPanoramaWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x01 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
    
}
- (void)returnZeroTimer:(NSTimer *)timer{
    NSLog(@"回零点");
    
    if (_receiveView.Pamode == 0x01) {
        playTimer.fireDate = [NSDate distantPast];
        timer.fireDate = [NSDate distantFuture];
    }else{
        UInt16 oneAngle = self.aOneAngle * 100.0f;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        UInt16 StartAngle = startValue * 10;
        UInt16 EndAngle = endValue * 10;
        [_sendView sendPanoramaWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x00 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
    }
}

- (void)playAction:(iFButton *)btn{
    
    if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        _playBtn.alpha = 0;
        _pauseBtn.alpha = 1;
        returnTimer.fireDate = [NSDate distantPast];
    }else{
        NSLog(@"未连接");
        
    }
   
}
- (void)playActionTimer:(NSTimer *)timer{
    NSLog(@"开始跑");
    _isRunning = YES;
    
    if (_receiveView.Pamode == 0x02) {
        startTime = [[NSDate date]timeIntervalSince1970] * 1000;
        runTimer.fireDate = [NSDate distantPast];
        timer.fireDate = [NSDate distantFuture];
        
    }else{

        _isStart = YES;
        UInt16 oneAngle = self.aOneAngle * 100.0f;
        UInt8 intervalValue = (UInt8)[_interval integerValue];
        UInt16 StartAngle = (UInt16)startValue * 10;
        UInt16 EndAngle = (UInt16)endValue * 10;
        [_sendView sendPanoramaWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x02 andAngle:oneAngle andStartAngle:StartAngle andEndAngle:EndAngle andInterVal:intervalValue WithStr:sendStr andTiltVeloc:0x00];
    }
    
}
- (void)stopAction:(iFButton *)btn{

}

- (void)pauseAction:(iFButton *)btn{
    _isRunning = NO;
    
    _playBtn.alpha = 1;
    _pauseBtn.alpha = 0;
    pauseTimer.fireDate = [NSDate distantPast];
}
- (void)pauseActionTimer:(NSTimer *)timer{
    
    if (_receiveView.Pamode == 0x04) {
        timer.fireDate = [NSDate distantFuture];

    }else{
        [_sendView sendPanoramaWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x07 andFunctionMode:0x04 andAngle:0x00 andStartAngle:0x00 andEndAngle:0x00 andInterVal:0x00 WithStr:sendStr andTiltVeloc:0x00];

    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
   self.isAutoPush = NO;
    
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(receiveRealData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    CGFloat startAngle = [[ud objectForKey:@"startAngle"] floatValue];
    CGFloat endAngle = [[ud objectForKey:@"endAngle"] floatValue];
    

    
    ifcir.cir.progress = (startAngle);
    ifcir.sliceView.progress = (endAngle);
    
    [TiltView removeFromSuperview];
    
    TiltView = [[iFTiltView alloc]initWithFrame:CGRectMake(iFSize(310), iFSize(465), 30, 100)];
    TiltView.backgroundColor = [UIColor clearColor];
    TiltView.delegate = self;
    TiltView.center = CGPointMake(kScreenWidth * 0.85, kScreenHeight * 0.5 + kScreenWidth * 0.5);
    [self.view addSubview:TiltView];
    

    NSLog(@"viewWillAppear%f %f", ifcir.cir.progress, ifcir.sliceView.progress);

        
        if (_receiveView.Pamode == 0x02) {
            self.pauseBtn.alpha = 1;
            self.playBtn.alpha= 0;
            _isRunning = YES;
            
        }else if (_receiveView.Pamode == 0x01){
            //        self.pauseBtn.alpha = 1;
            //        self.playBtn.alpha= 0;
        }else{
            
            self.pauseBtn.alpha = 0;
            self.playBtn.alpha = 1;
            _isRunning = NO;
            
        }
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear: animated];
    
    
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithDouble:ifcir.cir.progress] forKey:@"startAngle"];
    [ud setObject:[NSNumber numberWithDouble:ifcir.sliceView.progress] forKey:@"endAngle"];
    
    receiveTimer.fireDate = [NSDate distantFuture];
    receiveTimer = nil;
    
}



- (void)receiveRealData{

    ifcir.sliceView.lightSliceNumber = _receiveView.PaFrameCurrent;
//    NSLog(@"Pamode = %hhu", _receiveView.Pamode);
    
    if (_isRunning) {
    
    if (_receiveView.Pamode == 0x02) {
        self.pauseBtn.alpha = 1;
        self.playBtn.alpha= 0;
    }else if (_receiveView.Pamode == 0x01){
//        self.pauseBtn.alpha = 1;
//        self.playBtn.alpha= 0;
    }else{
        _isRunning = NO;
        
        self.pauseBtn.alpha = 0;
        self.playBtn.alpha = 1;
    }
    }
//    CGFloat OneAngle = (_receiveView.PaAngle) / 100.00f;
//    CGFloat startAngle = (_receiveView.PaStartAngle) / 10.00f;
//    CGFloat endAngle = (_receiveView.PaEndAngle) / 10.00f;
//    NSInteger currentFrame = _receiveView.PaFrameCurrent;
    
//    NSLog(@"1 = %lu", (unsigned long)ifcir.sliceView.currentNumber);
//    NSLog(@"2 = %lu", (unsigned long)ifcir.sliceView.totalNumber);
//    NSLog(@"3 = %lu", (unsigned long)ifcir.sliceView.lightSliceNumber);
    
    self.PicturesLabel.ValueLabel.text = [NSString stringWithFormat:@"%d/%lu", _receiveView.PaFrameCurrent,(NSUInteger)ceil(360 / self.aOneAngle)];
//
//
//    NSLog(@" \r\n                                                                                                       单张宽角度 %f\r\n                                                                                                          起始角度 %f \r\n                                                                                         终止角度 %f \r\n                                                                                                当前帧%ld \r\n                                                                                                     间隔时间 %d \r\n模式%d"
//          , OneAngle
//          , startAngle
//          , endAngle
//          , currentFrame
//          , _receiveView.PaInterval
//          , _receiveView.Pamode);
////
//    NSLog(@"Start= %lf", startValue);
    
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
    [_degreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
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
    [_degreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
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
