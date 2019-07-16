//
//  iFTransmitViewController.m
//  iFootage
//
//  Created by iFootage-iOS on 16/6/20.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFTransmitViewController.h"
#import "iFScanViewController.h"
#import "iFAdjustVelocView.h"
#import "iFStatusBarView.h"
#import "iF3DButton.h"

#define Dead_Zone 0.2f

#define BYTE0(dwTemp)       ( *( (char *)(&dwTemp)		) )
#define BYTE1(dwTemp)       ( *( (char *)(&dwTemp) + 1) )
#define Vspeed 32.11

#define LeftSegmentTag 333
#define RightSegmetTag 444

#define RightanalogueStickTag  111
#define LeftanalogueStickTag   222
@interface iFTransmitViewController ()<AdjustVelocCurveDelegate>


@end

@implementation iFTransmitViewController

{
    iFAdjustVelocView * slideAdjustView;
    iFAdjustVelocView * panAdjustView;
    iFAdjustVelocView * tiltAdjustView;
    
    
    CGFloat slideadjustV, panadjustV, tiltadjustV;
    iF3DButton * lockTiltBtn;
    iF3DButton * lockPanBtn;
    iF3DButton * SliderGetBackBtn;
    iF3DButton * X2GetBackBtn;
    
    
    NSInteger islockpan, islocktilt;
    
    UIView * leftBackgroundView;
    UIView * rightBackgroundView;
    UIView * leftSecondView;
    UIView * rightSecondView;
    
}

@synthesize TrackRealTimePositionLabel;
@synthesize TiltRealTimePositionLabel;
@synthesize PanRealTimePositionLabel;

@synthesize RightActiveXlabel;
@synthesize RightActiveYlabel;

@synthesize modfiNameBtn;
@synthesize appDelegate;
@synthesize backBtn;
@synthesize LeftStickLabel;
@synthesize leftTitleLabel;
@synthesize rightTitleLabel;
@synthesize SlideProView;
@synthesize PanProView;
@synthesize TiltProView;




- (void)viewDidLoad {
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [super viewDidLoad];
    // Do any additional setup after loading the view.  
    self.titleLabel.text = NSLocalizedString(All_ManualControl, nil);
    NSLog(@"kDevice_Is_iPhoneX%d", kDevice_Is_iPhoneX);

    self.view.backgroundColor = COLOR(66, 66, 66, 1);
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    Encode = Encode_ASCII;
    intervalTimer = 0.01;  //初始为0.5秒

    
    _leftunit = 1.0f;
    _rightunit = 1.0f;
    islockpan = 1;
    islocktilt = 1;
    
    /**
     接收的视图
     */
    _receiveView = [ReceiveView sharedInstance];
    
    _sendView = [[SendDataView alloc]init];

#pragma mark ---------横向UI🔽---------------



#warning 注释掉了部分必须数据

    

    

    
   
    
    

    
    rightTitleLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(492), iFSize(186), iFSize(60), iFSize(17.5)) WithTitle:[NSString stringWithFormat:@"%@/%@", TILTName, PanName]];
    rightTitleLabel.textAlignment = NSTextAlignmentCenter;
    rightTitleLabel.font = [UIFont systemFontOfSize:iFSize(14.5)];
    
#pragma mark ---------横向UI🔼----------------

    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    slideadjustV = [[ud objectForKey:SlideCurveValue] floatValue];
    
    if (slideadjustV) {
        
    }else{
        slideadjustV = 0.9f;
    }
    
    panadjustV = [[ud objectForKey:PanCurveValue] floatValue];
    if (panadjustV) {
        
    }else{
        panadjustV = 0.9f;
    }
    tiltadjustV = [[ud objectForKey:TiltCurveValue] floatValue];
    if (tiltadjustV) {
        
    }else{
        tiltadjustV = 0.9f;
    }
    
    
    lockTiltBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2, iFSize(80), iFSize(35)) WithTitle:@"Lock tilt" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    lockTiltBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [lockTiltBtn.actionBtn addTarget:self action:@selector(lockTiltAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lockTiltBtn];
    
    lockPanBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2 + lockTiltBtn.frame.size.height + 15, iFSize(80), iFSize(35)) WithTitle:@"Lock pan" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    lockPanBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [lockPanBtn.actionBtn addTarget:self action:@selector(lockPanAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:lockPanBtn];
    
    
    SliderGetBackBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.05, AutoKscreenWidth * 0.2, iFSize(120), iFSize(35)) WithTitle:@"Slider get back" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
//    SliderGetBackBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [SliderGetBackBtn.actionBtn addTarget:self action:@selector(SlidergetBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SliderGetBackBtn];
    
    X2GetBackBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.05, AutoKscreenWidth * 0.2 + lockTiltBtn.frame.size.height + 15, iFSize(120), iFSize(35)) WithTitle:@"X2 get back" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    [X2GetBackBtn.actionBtn addTarget:self action:@selector(X2getBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:X2GetBackBtn];
    
#pragma mark ------- 手动调整加速曲线----------
    
    slideAdjustView = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(89), iFSize(89)) WithColor:COLOR(255, 0, 255, 1) WithTitle:nil];
    
    slideAdjustView.center = CGPointMake(AutoKScreenHeight * 0.3 , AutoKscreenWidth * 0.27);
    
    slideAdjustView.delegate = self;
    slideAdjustView.tag = 1111;
    
    [slideAdjustView initCurveWithaValue:slideadjustV];
    
    slideAdjustView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:slideAdjustView];
    
    panAdjustView    = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(89), iFSize(89)) WithColor:COLOR(0, 255, 255, 1) WithTitle:nil];
    panAdjustView.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth * 0.27);
    panAdjustView.delegate = self;
    panAdjustView.tag = 2222;
    
    panAdjustView.backgroundColor = [UIColor clearColor];
    [panAdjustView initCurveWithaValue:panadjustV];
    
    [self.view addSubview:panAdjustView];
    
    tiltAdjustView = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(89), iFSize(89)) WithColor:COLOR(255, 255, 0, 1) WithTitle:nil];
    tiltAdjustView.center = CGPointMake(AutoKScreenHeight * 0.7, AutoKscreenWidth * 0.27);
    tiltAdjustView.backgroundColor = [UIColor clearColor];
    [tiltAdjustView initCurveWithaValue:tiltadjustV];
    tiltAdjustView.tag = 3333;
    
    tiltAdjustView.delegate = self;
    
    [self.view addSubview:tiltAdjustView];

    
    
    
    self.slideVelocView = [[iFProgressView alloc]initShowRealVelocViewWithFrame:CGRectMake(iFSize(182.5), iFSize(155), iFSize(71), iFSize(48.5)) WithTitle:@"Slide"];
    self.slideVelocView.center = CGPointMake(slideAdjustView.center.x, AutoKscreenWidth * 0.5);
    self.panVelocView = [[iFProgressView alloc]initShowRealVelocViewWithFrame:CGRectMake(iFSize(297.5), iFSize(155), iFSize(71), iFSize(48.5)) WithTitle:@"Pan"];
    self.panVelocView.center = CGPointMake(panAdjustView.center.x, AutoKscreenWidth * 0.5);
    self.TiltVelocView = [[iFProgressView alloc]initShowRealVelocViewWithFrame:CGRectMake(iFSize(413), iFSize(155), iFSize(71), iFSize(48.5)) WithTitle:@"Tilt"];
    self.TiltVelocView.center = CGPointMake(tiltAdjustView.center.x, AutoKscreenWidth * 0.5);
    [self.view addSubview:self.slideVelocView];
    [self.view addSubview:self.panVelocView];
    [self.view addSubview:self.TiltVelocView];

    
#pragma mark  ----Value-----
    SlideProView = [[iFProgressView alloc]initWithFrame:CGRectMake(iFSize(253), iFSize(239), 165, 30) andProgressValue:50 title:@"Slide value"];
    SlideProView.center = CGPointMake(AutoKScreenHeight * 0.5, self.slideVelocView.frame.size.height + self.slideVelocView.frame.origin.y + 30);
    [self.view addSubview:SlideProView];
    PanProView = [[iFProgressView alloc]initWithFrame:CGRectMake(iFSize(253), iFSize(279), 165, 30) andProgressValue:100 title:@"Pan value"];
    PanProView.center = CGPointMake(AutoKScreenHeight * 0.5, SlideProView.frame.size.height + SlideProView.frame.origin.y + 30);
    [self.view addSubview:PanProView];
    TiltProView = [[iFProgressView alloc]initWithFrame:CGRectMake(iFSize(253), iFSize(315), 165, 30) andProgressValue:150 title:@"Tilt value"];
    TiltProView.center = CGPointMake(AutoKScreenHeight * 0.5, PanProView.frame.size.height + PanProView.frame.origin.y + 30);
    [self.view addSubview:TiltProView];
    

    
}

- (void)X2getBackAction{
    
    [self.sendView sendX2BackZeroWith:SendStr WithCB:appDelegate.bleManager.panCB];
    
}
- (void)SlidergetBackAction{
   
    [self.sendView sendSliderBackZeroWith:SendStr WithCB:appDelegate.bleManager.sliderCB];
    
    
}
- (void)woyaozuie:(UILongPressGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:self.view];

    NSLog(@"center %@", NSStringFromCGPoint(point));
    
    
    
    if (tap.state == UIGestureRecognizerStateBegan) {
        NSLog(@"center开始");
        self.RightanalogueStick.center = point;

    }
    if (tap.state == UIGestureRecognizerStateEnded) {
        NSLog(@"center结束");
        
        
    }


    
    
}
- (void)lockPanAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        islockpan = 0;
    }else{
        islockpan = 1;
    }
    
}
- (void)lockTiltAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        islocktilt = 0;
    }else{
        islocktilt = 1;
    }

}

- (void)changeVectorForTheSegment:(UISegmentedControl *)segm{
    if (segm.tag == LeftSegmentTag) {
//        NSLog(@"%ld", segm.selectedSegmentIndex);
        if (segm.selectedSegmentIndex == 0) {
            _leftunit = 0.2f;
        }else if(segm.selectedSegmentIndex == 1){
            _leftunit = 0.4f;
        }else{
            _leftunit = 1.0f;
        }
    }else{
//        NSLog(@"%ld", segm.selectedSegmentIndex);
        if (segm.selectedSegmentIndex == 0) {
            _rightunit = 0.2f;
        }else if(segm.selectedSegmentIndex == 1){
            _rightunit = 0.4f;
        }else{
            _rightunit = 1.0f;
        }
    }
}

- (void)gotoScanViewController{
    iFScanViewController * scanVC = [[iFScanViewController alloc]init];
    [self presentViewController:scanVC animated:YES completion:nil];
    
}
- (void)returnZeroTimer:(NSTimer *)timer{
    
    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.LeftanalogueStick.xValue * 100];
    NSData * data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];

    CGFloat slideVeloc = _receiveView.TrackRealTimeVeloc;
    CGFloat panVeloc = _receiveView.panRealTimeVeloc;
    CGFloat tiltVeloc = _receiveView.tiltRealTimeVeloc;
    
    if (!self.RightanalogueStick.isRunning) {
        if (panVeloc != 300.0f || tiltVeloc != 300.0f) {
//            NSLog(@"发了X2");
            [_sendView sendData:SendStr andXVeloc:(SInt16)300.0f andYVeloc:(SInt16)300.0f];
        }
    }
    if (!self.LeftanalogueStick.isRunning) {
        
        if (slideVeloc != 500.0f) {
//            NSLog(@"发了S1");
            [_sendView sendSliderValue:SendStr andSliderValue:(SInt16)500.0f];
        }
    }

}
- (void)backtolastViewC{
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark ------接收数据---------
- (void)viewWillAppear:(BOOL)animated{
    
    [self forceOrientationLandscape];

    [super viewWillAppear:animated];
    
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    navi.preferredInterfaceOrientationForPresentation;
    
    navi.interfaceOrientation =   UIInterfaceOrientationLandscapeRight;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];


    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(receiveRealTimeData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantFuture];
    receiveTimer.fireDate = [NSDate distantPast];
    [leftBackgroundView removeFromSuperview];
    
    leftBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(30), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    leftBackgroundView.backgroundColor = [UIColor clearColor];
    leftBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.15, AutoKscreenWidth * 0.7);
    [self.view addSubview:leftBackgroundView];
    
    [rightBackgroundView removeFromSuperview];
    rightBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(455), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    rightBackgroundView.backgroundColor = [UIColor clearColor];
    rightBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.7);
    [self.view addSubview:rightBackgroundView];
    
    
    
    /**
     右边摇杆
     */
    [self.RightanalogueStick removeFromSuperview];
    
    self.RightanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(455), iFSize(214), 125, 125)];
    self.RightanalogueStick.tag = RightanalogueStickTag;
    self.RightanalogueStick.delegate = self;
    self.RightanalogueStick.center = CGPointMake(rightBackgroundView.frame.size.width * 0.5, rightBackgroundView.frame.size.height * 0.5);
    
    [rightBackgroundView addSubview:self.RightanalogueStick];
    
    /**
     左边摇杆
     */
    [self.LeftanalogueStick removeFromSuperview];
    self.LeftanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(79.5), iFSize(214), 125, 125)];
    self.LeftanalogueStick.center = CGPointMake(leftBackgroundView.frame.size.width * 0.5, leftBackgroundView.frame.size.height * 0.5);
    self.LeftanalogueStick.tag = LeftanalogueStickTag;
    self.LeftanalogueStick.delegate = self;
    [leftBackgroundView addSubview:self.LeftanalogueStick];
    
}


- (void)viewDidAppear:(BOOL)animated{
    
    
  
    self.RightanalogueStick.delegate = self;
    self.LeftanalogueStick.delegate = self;
}


- (void)viewWillDisappear:(BOOL)animated{
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [super viewWillDisappear:animated];
    [self forceOrientationPortrait];

    [loopSendDataTimer invalidate]; //关闭时器
    [receiveTimer invalidate];
    [returnTimer invalidate];
    [self.LeftanalogueStick.timer invalidate];
    self.LeftanalogueStick.timer = nil;
    self.LeftanalogueStick.timer.fireDate = [NSDate distantFuture];
    [self.RightanalogueStick.timer invalidate];
    self.RightanalogueStick.timer = nil;
    self.RightanalogueStick.timer.fireDate = [NSDate distantFuture];
    
//    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.RightanalogueStick.xValue * 100];
//    NSData * data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];
    
    [_sendView sendSliderValue:SendStr andSliderValue:500];
    [_sendView sendData:SendStr andXVeloc:300 andYVeloc:300];
    
    
    returnTimer = nil;
    receiveTimer = nil;
    loopSendDataTimer = nil;
    
    returnTimer.fireDate = [NSDate distantFuture];
    
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    
    navi.interfaceOrientation = UIInterfaceOrientationMaskAll;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

//强制横屏
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    
}
//- (BOOL)prefersStatusBarHidden{
//    return NO;
//
//}



- (void)receiveRealTimeData{
    
    NSInteger slideCount = 2;
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    if ([ud objectForKey:SLIDECOUNT]) {
        slideCount = [[ud objectForKey:SLIDECOUNT] integerValue];
    }

    
    CGFloat SlideValue = _receiveView.TrackRealTimePosition / 10.0f;
    
    [SlideProView changeValueWithProgresslabel:SlideValue / SlideConunt(slideCount) * 165 uint:SlideConunt(slideCount)];
    
    
    CGFloat PanValue = _receiveView.panRealTimePostion / 10.0f - 360.0f;
    CGFloat TiltValue = _receiveView.tiltRealTimePostion / 10.0f - 35.0f;
    if (_receiveView.panRealTimePostion == 0) {
        PanValue = 0;
        
    }
    if (_receiveView.tiltRealTimePostion == 0) {
        TiltValue = 0;
        
    }
    
    if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        
    }else{
        PanValue = 0;
        TiltValue = 0;
        
    }
    [PanProView changeValueWithProgresslabel:PanValue / 360 * 165 uint:360.0f];
    [TiltProView changeValueWithProgresslabel:TiltValue / 70.0f * 165 uint:70.0f];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear: animated];
 

    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.RightanalogueStick.xValue * 100];
    NSData * data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];
    
    receiveTimer.fireDate = [NSDate distantFuture];
    returnTimer.fireDate = [NSDate distantFuture];
    loopSendDataTimer.fireDate = [NSDate distantFuture];
    [_sendView sendSliderValue:SendStr andSliderValue:500];
    [_sendView sendData:SendStr andXVeloc:300 andYVeloc:300];
    
    [loopSendDataTimer invalidate]; //关闭时器
    [receiveTimer invalidate];
    [returnTimer invalidate];
    
    returnTimer = nil;
    receiveTimer = nil;
    loopSendDataTimer = nil;
    
    
}

- (NSString *)stringToHex:(NSString *)string
{
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    return hexStr;
}
-(void)disconnectBLE {
    
//    if ( appDelegate.bleManager.activePeripheral.state == CBPeripheralStateConnected) { //判定是否为连接状态
//        [appDelegate.bleManager.CM cancelPeripheralConnection : appDelegate.bleManager.activePeripheral ] ; //取消连接
//        appDelegate.bleManager.activePeripheral = nil;
//    }
    
}



- (void)rightUpdateAnalogue
{
    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.RightanalogueStick.xValue * 100];
    NSData * data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];

    CGFloat xV;
    CGFloat yV;
#pragma mark  死驱算法
    if (fabs(self.RightanalogueStick.xValue)  < Dead_Zone) {
        
        xV = 0.0f;
        
    }else{
        xV = (fabs(self.RightanalogueStick.xValue) - Dead_Zone) / (1 - Dead_Zone);
        if (self.RightanalogueStick.xValue < 0) {
            xV = -xV;
        }
        
    }
    if (fabs(self.RightanalogueStick.yValue)  < Dead_Zone) {
        yV = 0.0f;
    }else{
        yV = (fabs(self.RightanalogueStick.yValue) - Dead_Zone) / (1- Dead_Zone);
        if (self.RightanalogueStick.yValue < 0) {
            yV = -yV;
        }
    }
//    NSLog(@"xV = === %f", xV);
    
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
    
    //
    self.RightActiveXlabel.text = [NSString stringWithFormat:@"PanTCP:%.1f", ActiveVX * _rightunit];
    self.RightActiveYlabel.text = [NSString stringWithFormat:@"TiltTCP:%.1f", ActiveVY * _rightunit];
    
//    NSLog(@"%f", ActiveVX/ 50 * 30);
    
    
    
    _RightvelocityVectorX = (SInt16)(ActiveVX  / 50 * PanVelocMaxValue * 10 + 300);
    _RightvelocityVectorY = (SInt16)(ActiveVY  / 50 * TiltVelocMaxValue * 10 + 300);
//    NSLog(@"tilt = %ld", islocktilt);
//    NSLog(@"pan = %ld", islockpan);
    
    
//    NSLog(@"XY = %d %d", _RightvelocityVectorX, _RightvelocityVectorY);
    
    [_sendView sendData:SendStr andXVeloc:_RightvelocityVectorX andYVeloc:_RightvelocityVectorY];
    
}
- (void)leftUpdateAnalogue{
    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.LeftanalogueStick.xValue * 100];
    NSData * data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];
    
    ActiveSliderY = tan(self.LeftanalogueStick.xValue) * Vspeed;
    
    if (ActiveSliderY > 50.0f) {
        ActiveSliderY = 50.0f;
    }
    _LeftvelocityVectorX = (SInt16)(ActiveSliderY * _leftunit + 500);
    LeftStickLabel.text = [NSString stringWithFormat:@"SlideTCP:%.1f", ActiveSliderY * _leftunit];
    [_sendView sendSliderValue:SendStr andSliderValue:_LeftvelocityVectorX];
    
    
}
#pragma mark - JSAnalogueStickDelegate
- (void)AdjustVelocCurveWithpercentValue:(CGFloat)value andView:(UIView *)anyView{
//    NSLog(@"%lf, %@", value, anyView);
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    if (anyView.tag == 1111) {
        [ud setObject:[NSNumber numberWithFloat:value] forKey:SlideCurveValue];
        
        
    }else if (anyView.tag == 2222){
        [ud setObject:[NSNumber numberWithFloat:value] forKey:PanCurveValue];

    }else if (anyView.tag == 3333){
        
        [ud setObject:[NSNumber numberWithFloat:value] forKey:TiltCurveValue];
        
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touchLocation in touches) {
        NSLog(@"begin touch %@",NSStringFromCGPoint([touchLocation locationInView:rightBackgroundView]));
        if ([rightBackgroundView.layer containsPoint:[touchLocation locationInView:rightBackgroundView]]) {
            NSLog(@"right");
            self.RightanalogueStick.center = [touchLocation locationInView:rightBackgroundView];
            [self.RightanalogueStick touchesBegan];
            self.RightanalogueStick.touch = touchLocation;
        }
        
        if ([leftBackgroundView.layer containsPoint:[touchLocation locationInView:leftBackgroundView]]) {
            self.LeftanalogueStick.center = [touchLocation locationInView:leftBackgroundView];
            
            [self.LeftanalogueStick touchesBegan];
            self.LeftanalogueStick.touch = touchLocation;
        }
    }

    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];

    for (UITouch *touch in touches) {
        if (touch == self.RightanalogueStick.touch) {
            [self.RightanalogueStick reset];
            [self.RightanalogueStick touchesEnded];
            
        }
        if (touch == self.LeftanalogueStick.touch) {
            [self.LeftanalogueStick reset];

            [self.LeftanalogueStick touchesEnded];
            
        }
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];

    for (UITouch *touch in touches) {
        if (touch == self.RightanalogueStick.touch) {
            [self.RightanalogueStick autoPoint:[touch locationInView:rightBackgroundView]];
        }
        if (touch == self.LeftanalogueStick.touch) {
            [self.LeftanalogueStick autoPoint:[touch locationInView:leftBackgroundView]];
        }
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    

    for (UITouch *touch in touches) {
        if (touch == self.RightanalogueStick.touch) {
            [self.RightanalogueStick reset];
            [self.RightanalogueStick touchesEnded];

        }
        if (touch == self.LeftanalogueStick.touch) {
            [self.LeftanalogueStick reset];

            [self.LeftanalogueStick touchesEnded];

        }
    }
    
}

- (void)analogueStickDidChangeValue:(iFootageRocker *)analogueStick
{
    
    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.RightanalogueStick.xValue * 100];
    NSData * data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];
    CGFloat panV, tiltV = 0.0;
    CGFloat sliderV = 0.0;
    
//    NSLog(@"%f", analogueStick.xValue);
//    NSLog(@"%f", analogueStick.yValue);
    
    
    if (analogueStick.tag == RightanalogueStickTag) {

        if (analogueStick.xValue >= 1.0f) {
            
            panV =  [panAdjustView CountSomeThingsAndPointX:1.0f];
            
        }else{
            panV = [panAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
            

        }
        
        if (analogueStick.yValue >= 1.0f) {
            //            NSLog(@"P = %lf",         [panAdjustView CountSomeThingsAndPointX:1.0f]);
            tiltV = [tiltAdjustView CountSomeThingsAndPointX:1.0f];
            
            
        }else{
            tiltV = [tiltAdjustView CountSomeThingsAndPointX:analogueStick.yValue];
            
        }
      

        if (panV < 0.0001 && panV >= 0.0f) {
            panV = 0.0f;
        }
        if (panV > -0.0001 && panV < 0.0f) {
            panV = 0.0f;
        }
        if (tiltV < 0.0001 && tiltV >= 0.0f) {
            tiltV = 0.0f;
        }
        if (tiltV > -0.0001 && tiltV < 0.0f) {
            tiltV = 0.0f;
        }
      
        if (islockpan == 0) {
            panV = 0;
        }
        if (islocktilt == 0) {
            tiltV = 0;
        }
        
        _RightvelocityVectorX = panV * PanVelocMaxValue * 10.0f + 300.0f;
        _RightvelocityVectorY = tiltV * TiltVelocMaxValue * 10.0f + 300.0f;
        
      
        
        self.panVelocView.AxaiValueLabel.text = [NSString stringWithFormat:@"%.1lf", panV * PanVelocMaxValue];
        self.TiltVelocView.AxaiValueLabel.text = [NSString stringWithFormat:@"%.1lf", tiltV * TiltVelocMaxValue];
        
        
        
        [_sendView sendData:SendStr andXVeloc:_RightvelocityVectorX andYVeloc:_RightvelocityVectorY];

    }
    if (analogueStick.tag == LeftanalogueStickTag) {
        if (analogueStick.xValue >= 1.0f) {

            sliderV =  [slideAdjustView CountSomeThingsAndPointX:1.0f];
            
        }else if(analogueStick.xValue < 0.0001 && analogueStick.xValue > -0.0001){
            sliderV = 0.0f;

        }else{
            
            sliderV = [slideAdjustView CountSomeThingsAndPointX:analogueStick.xValue];

        }
        
        
        self.slideVelocView.AxaiValueLabel.text = [NSString stringWithFormat:@"%.1lf", sliderV * 50.0f];
        
        _LeftvelocityVectorX = sliderV * 50.0f * 10.0f + 500.0f;
        if (sliderV * 50.0f > 0 && sliderV * 50.0f < 1.0f) {
            _LeftvelocityVectorX  = 500.0f + 1.0f;
            
        }
        [_sendView sendSliderValue:SendStr andSliderValue:_LeftvelocityVectorX];
        
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
