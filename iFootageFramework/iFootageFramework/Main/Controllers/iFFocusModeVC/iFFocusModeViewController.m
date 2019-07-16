//
//  iFFocusModeViewController.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/24.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFFocusModeViewController.h"
#import "AppDelegate.h"
#import "iFFocusSlideView.h"
#import "DXPopover.h"
#import "iFTimePickerView.h"
#import "iFModel.h"
#import "iFGetDataTool.h"
#import "SVProgressHUD.h"
#import "iFAdjustVelocView.h"
#import "iFUpdateBtn.h"
#import "iF3DButton.h"
#import "iFAlertController.h"
#import "iFSmoothnessView.h"
#import "iFTargetModel.h"
#import "iFgetAxisY.h"
#import "iFTarget_PointValueView.h"
#import "iFSegmentView.h"


#define LeftStickTag 100
#define RightStickTag 101

#define LeftSegmentTag 333
#define RightSegmetTag 444

#define Dead_Zone 0.2f
#define Vspeed 32.11
#define LimitSecond 0.1f
#define Value(x) [NSNumber numberWithFloat:x]



@interface iFFocusModeViewController ()<JSAnalogueStickDelegate, TimeLapseTimePickDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, sendSelectedDelegete>



@property (nonatomic, strong) DXPopover *popover;
@property (nonatomic, strong) iFModel * ifmodel;

@property (nonatomic, strong)iFSegmentView * single_MultiSegmentView;

@end

@implementation iFFocusModeViewController
{
    iFFocusSlideView * slideView;
    CGFloat ActiveVX; // 动态横坐标
    CGFloat ActiveVY; // 动态纵坐标
    CGFloat ActiveSliderY;
    AppDelegate * appDelegate;
    NSUInteger               Encode;//编码模式 ascii or  hex
    ReceiveView * _receiveView;
    SendDataView * _sendView;
    CGFloat slideDistance, panDistance;
    iFAdjustVelocView * slideAdjustView;
    iFAdjustVelocView * panAdjustView;
    iFAdjustVelocView * tiltAdjustView;
    iFTargetModel * targetModel;
    iFSmoothnessView * smoothView;
    iFTarget_PointValueView * A_pointValueView;
    iFTarget_PointValueView * B_pointValueView;

    
    NSTimer * receiveTimer;
    NSTimer * returnZeroTimer;
    NSTimer * runTimer;
    NSTimer * StopTimer;
    NSTimer * LeftPointTimer;
    NSTimer * RightPointTimer;
    NSTimer * timeCorrectTimer;// 校准开始时间定时器
    NSTimer * setAandBpointTimer;
    NSTimer * freeReturnZeroTimer;
    

    NSString * sendStr;
    
    UInt16 alltime;
    UInt64 starttime;
    
    UInt8 direction;
    UInt8 isloop;
    UInt8 islockTilt;
    UInt8 issingleormulti;
    
    NSInteger islockpan;
    
    NSUserDefaults * ud;
    
    
    BOOL isStart;
    CGFloat slideadjustV, panadjustV, tiltadjustV;

    UIView * leftBackgroundView;
    UIView * rightBackgroundView;
    
    NSInteger record_A_panAngle;
    NSInteger record_B_panAngle;
    NSInteger record_A_TiltAngle;
    NSInteger record_B_TiltAngle;
    NSInteger record_A_SliderPosition;
    NSInteger record_B_SliderPosition;
    
    UITableView * fileTableView;
    UIView * fileview;
    NSMutableArray * fileDataArray;
    
}
@synthesize isRunning;


- (void)viewDidLoad {
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.rootbackBtn addTarget:self action:@selector(rootbackBtn) forControlEvents:UIControlEventTouchUpInside];
    //锁住tilt轴默认1为不锁住
    islockTilt = 0x01;
    //锁住pan轴默认
    islockpan = 0x01;
    //默认0为不循环
    isloop = 0x00;
    
    alltime = self.ifmodel.fmtotalTime;
    
    _leftunit = 1.0f;
    _rightunit = 1.0f;
    //默认multi模式 multi为0 single为1
    issingleormulti = 0x00;
    isStart = NO;
    //自适应方向0x03 01 左 02 右
    direction = 0x03;
    //存储文件数组
    fileDataArray = [NSMutableArray new];
    self.titleLabel.text = NSLocalizedString(All_TargetControl, nil);
    
    appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    _receiveView = [ReceiveView sharedInstance];
    _sendView = [[SendDataView alloc]init];
    
    self.connectBtn.alpha = 0;
    returnZeroTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(returnZeroActionTimer:) userInfo:nil repeats:YES];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    
    runTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(runActionTimer:) userInfo:nil repeats:YES];
    runTimer.fireDate = [NSDate distantFuture];
    
    StopTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(StopActionTimer:) userInfo:nil repeats:YES];
    StopTimer.fireDate = [NSDate distantFuture];

    LeftPointTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(ApointActionTimer:) userInfo:nil repeats:YES];
    LeftPointTimer.fireDate = [NSDate distantFuture];
    
    RightPointTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(BpointActionTimer:) userInfo:nil repeats:YES];
    RightPointTimer.fireDate = [NSDate distantFuture];
    
    timeCorrectTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(timeCurrentTimer:) userInfo:nil repeats:YES];
    timeCorrectTimer.fireDate = [NSDate distantFuture];
    
    setAandBpointTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(AandB_PointActionTimer:) userInfo:nil repeats:YES];
    setAandBpointTimer.fireDate = [NSDate distantFuture];
    
    freeReturnZeroTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(freeReturnZeroTimer:) userInfo:nil repeats:YES];
    freeReturnZeroTimer.fireDate = [NSDate distantFuture];
    [self createUI];
    
    
    slideadjustV = [[ud objectForKey:SlideCurveValue] floatValue];
    
    if (slideadjustV) {
        
    }else{
        slideadjustV = 0.75f;
    }
    
    panadjustV = [[ud objectForKey:PanCurveValue] floatValue];
    if (panadjustV) {
        
    }else{
        panadjustV = 0.75f;
    }
    tiltadjustV = [[ud objectForKey:TiltCurveValue] floatValue];
    if (tiltadjustV) {
        
    }else{
        tiltadjustV = 0.75f;
    }
    
    slideAdjustView = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(100), iFSize(100)) WithColor:COLOR(255, 0, 255, 1) WithTitle:@"SLIDE"];
    
    slideAdjustView.center = CGPointMake(kScreenHeight / 4 , kScreenWidth / 3);
    [slideAdjustView initCurveWithaValue:slideadjustV];
    
    slideAdjustView.backgroundColor = [UIColor clearColor];
    
//    [self.view addSubview:slideAdjustView];
    
    panAdjustView    = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(100), iFSize(100)) WithColor:COLOR(0, 255, 255, 1) WithTitle:@"PAN"];
    panAdjustView.center = CGPointMake(kScreenHeight / 4 * 2, kScreenWidth / 3);
    
    panAdjustView.backgroundColor = [UIColor clearColor];
    [panAdjustView initCurveWithaValue:panadjustV];
    
//    [self.view addSubview:panAdjustView];
    
    tiltAdjustView = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(100), iFSize(100)) WithColor:COLOR(255, 255, 0, 1) WithTitle:@"TILT"];
    tiltAdjustView.center = CGPointMake(kScreenHeight / 4 * 3, kScreenWidth / 3);
    tiltAdjustView.backgroundColor = [UIColor clearColor];
    [tiltAdjustView initCurveWithaValue:tiltadjustV];
    
//    [self.view addSubview:tiltAdjustView];
    
    targetModel = [[iFTargetModel alloc]init];
    
}
- (NSInteger)getStatus{
    CBPeripheral * s1 = appDelegate.bleManager.sliderCB;
    CBPeripheral * x2 = appDelegate.bleManager.panCB;
    
    if (s1.state == CBPeripheralStateConnected && x2.state == CBPeripheralStateConnected) {
        
        return CBS1ANDX2;
    }else if (s1.state == CBPeripheralStateConnected && ((x2 == nil) || (x2.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting))){
        
        return CBOneS1;
    }else if (((s1 == nil) || (s1.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting)) && x2.state == CBPeripheralStateConnected){
        return CBOneX2;
    }else {
        return CBAllNull;
    }
}
- (void)initData{
    
    self.ifmodel = [[iFModel alloc]init];
    self.ifmodel.fmtotalTime = [[ud objectForKey:FMRUNTIME] integerValue];
    if (self.ifmodel.fmtotalTime) {
        
    }else{
        self.ifmodel.fmtotalTime = 12;
    }
}
- (id)init{
    
    ud = [NSUserDefaults standardUserDefaults];
    [self initData];
    
    return self;
    
}
- (void)createUI{
    
    
    [leftBackgroundView removeFromSuperview];
    leftBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(30), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    leftBackgroundView.backgroundColor = [UIColor clearColor];
    leftBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.25, AutoKscreenWidth * 0.65);
    [self.view addSubview:leftBackgroundView];
    
    [rightBackgroundView removeFromSuperview];
    rightBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(455), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    rightBackgroundView.backgroundColor = [UIColor clearColor];
    rightBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.75, AutoKscreenWidth * 0.65);
    
    [self.view addSubview:rightBackgroundView];
    
    
    /**
     右边摇杆
     */
    [self.RightanalogueStick removeFromSuperview];
    
    self.RightanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(455), iFSize(214), rightBackgroundView.frame.size.width * 0.6, rightBackgroundView.frame.size.width * 0.6)];
    self.RightanalogueStick.tag = RightStickTag;
    self.RightanalogueStick.delegate = self;
    self.RightanalogueStick.center = CGPointMake(rightBackgroundView.frame.size.width * 0.5, rightBackgroundView.frame.size.height * 0.5);
    
    [rightBackgroundView addSubview:self.RightanalogueStick];
    
    /**
     左边摇杆
     */
    [self.LeftanalogueStick removeFromSuperview];
    self.LeftanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(79.5), iFSize(214), leftBackgroundView.frame.size.width * 0.6, leftBackgroundView.frame.size.width * 0.6)];
    self.LeftanalogueStick.center = CGPointMake(leftBackgroundView.frame.size.width * 0.5, leftBackgroundView.frame.size.height * 0.5);
    self.LeftanalogueStick.tag = LeftStickTag;
    self.LeftanalogueStick.delegate = self;
    [leftBackgroundView addSubview:self.LeftanalogueStick];

    
    iFButton * leftBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(206), iFSize(280), iFSize(55), iFSize(25)) andTitle:@"leftBtn"];
    leftBtn.tag = 101;
    [leftBtn addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:leftBtn];
    
    iFButton * rightBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(405), iFSize(280), iFSize(55), iFSize(25)) andTitle:@"rightBtn"];
    rightBtn.tag = 102;
    [rightBtn addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:rightBtn];
    
    self.single_MultiSegmentView = [[iFSegmentView alloc]initWithFrameTarget:CGRectMake(AutoKScreenHeight * 0.8, AutoKscreenWidth * 0.1, iFSize(120), iFSize(35)) andfirstTitle:@"Single" andSecondTitle:@"Multi" andSelectedIndex:1];
    self.single_MultiSegmentView.selectedIndex = 1;
    self.single_MultiSegmentView.delegate = self;
    
    [self.view addSubview:self.single_MultiSegmentView];
    
    
    
    self.lockTiltBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2, iFSize(80), iFSize(35)) WithTitle:nil selectedIMG:@"locktilt-selected" normalIMG:@"locktilt-normal"];
    self.lockTiltBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [self.lockTiltBtn.actionBtn addTarget:self action:@selector(lockTiltAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockTiltBtn];
    
    self.lockPanBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2 + self.lockTiltBtn.frame.size.height + 15, iFSize(80), iFSize(35)) WithTitle:nil selectedIMG:@"lockpan-selected" normalIMG:@"lockpan-normal"];
    self.lockPanBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [self.lockPanBtn.actionBtn addTarget:self action:@selector(lockPanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockPanBtn];

    [self.single_MultiSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lockPanBtn.mas_right);
        make.top.mas_equalTo(AutoKscreenWidth * 0.08);
        make.size.mas_equalTo(CGSizeMake(iFSize(120), iFSize(30)));
    }];
    
  
    
//    [self.view addSubview:MenuBtn];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseTotalTime:)];
    NSString * timeStr = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith:self.ifmodel.fmtotalTime]];
    
    self.timeLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(285), iFSize(67), iFSize(120), iFSize(40)) WithTitle:timeStr andFont:iFSize(35)];
    self.timeLabel.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth * 0.2);
    self.timeLabel.userInteractionEnabled = YES;
    [self.timeLabel addGestureRecognizer:tapGesture];
    [self.view addSubview:self.timeLabel];
    
    self.isLoopBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(75), iFSize(105), iFSize(30), iFSize(30)) andnormalImage:target_UNLOOPIMG andSelectedImage:target_LOOPIMG];
//    self.isLoopBtn.backgroundColor = [UIColor redColor];
    
    
    [self.isLoopBtn addTarget:self action:@selector(isloopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.isLoopBtn];

   
    
    
    
    
    slideView = [[iFFocusSlideView alloc]initWithFrame:CGRectMake(0, 0,  AutoKScreenHeight, AutoKscreenWidth)];
    slideView.progress = 0.0;
    slideView.layer.masksToBounds = YES;
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        slideView.frame = CGRectMake(0, -40, AutoKScreenHeight, AutoKscreenWidth);
    }else if(kDevice_Is_iPad){
        slideView.frame = CGRectMake(0, 10, AutoKScreenHeight, AutoKscreenWidth);
    }
    
    [self.view addSubview:slideView];
    [self.view sendSubviewToBack:slideView];
//    [self.view sendSubviewToBack:self.backimgaeView];
    
    
#warning 新的UI rebuild UI------------
    
#pragma mark - 新的UI 新的UI------
    
    UILabel * smoothLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.14, 20)];
    smoothLabel.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth * 0.5);
    smoothLabel.textColor = COLOR(121, 121, 121, 1);
    smoothLabel.backgroundColor = [UIColor clearColor];
    smoothLabel.textAlignment = NSTextAlignmentCenter;
    smoothLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:smoothLabel.frame.size.height * 0.7];
    smoothLabel.text = @"smoothness";
    [self.view addSubview:smoothLabel];
    CGFloat smoothwidth, btnWidth;
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        smoothwidth = AutoKscreenWidth * 0.05;
        
        btnWidth = AutoKscreenWidth * 0.14;
        
    }else if(kDevice_Is_iPad){
        smoothwidth =AutoKscreenWidth * 0.04;
        btnWidth = AutoKscreenWidth * 0.10;
    }else{
        
        smoothwidth =AutoKscreenWidth * 0.04;
        btnWidth = AutoKscreenWidth * 0.14;

    }
    smoothView = [[iFSmoothnessView alloc]initWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.20,  smoothwidth)];
    smoothView.backgroundColor = [UIColor clearColor];
    smoothView.center = CGPointMake(AutoKScreenHeight * 0.5, [self getYLimitWithAboveView:smoothLabel] + smoothLabel.frame.size.height / 2);
    [self.view addSubview:smoothView];
    
    self.panValueLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(274), [self getYLimitWithAboveView:smoothView], iFSize(130), iFSize(13)) WithTitle:@"Pan value 0.0°" andFont:iFSize(12)];
    [self.view addSubview:self.panValueLabel];
    
    self.tiltValueLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(274), [self getYLimitWithAboveView:self.panValueLabel], iFSize(130), iFSize(13)) WithTitle:@"Tilt value 0.0°" andFont:iFSize(12)];
    [self.view addSubview:self.tiltValueLabel];
    
    self.slideValueLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(274), [self getYLimitWithAboveView:self.tiltValueLabel], iFSize(130), iFSize(13)) WithTitle:@"slide value 000mm" andFont:iFSize(12)];
    [self.view addSubview:self.slideValueLabel];
    
    self.playBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PALYBTNIMG];
    self.playBtn.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth - 10 - AutoKscreenWidth * 0.07);
    [self.playBtn.actionBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.alpha = 1;
    [self.view addSubview:self.playBtn];
    
    self.stopBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    [self.stopBtn.actionBtn addTarget:self action:@selector(StopAction:) forControlEvents:UIControlEventTouchUpInside];
    self.stopBtn.center = self.playBtn.center;
    self.stopBtn.alpha = 0;
    [self.view addSubview:self.stopBtn];
    
    
    self.leftPlayBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(277), iFSize(332), btnWidth, btnWidth) WithTitle:nil selectedIMG:@"target_leftplay@3x" normalIMG:@"target_leftplay@3x"];
    self.leftPlayBtn.center = CGPointMake(self.playBtn.center.x - AutoKscreenWidth * 0.14 - 17,self.playBtn.center.y);
    [self.leftPlayBtn.actionBtn addTarget:self action:@selector(leftStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftPlayBtn];
    
    self.pauseBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(320), iFSize(332), iFSize(27), iFSize(30)) andnormalImage:@"pause" andSelectedImage:@"pause"];
    [self.pauseBtn addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.pauseBtn];
    
    self.rightPlayBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(365), iFSize(332), btnWidth, btnWidth) WithTitle:nil selectedIMG:@"targer_rightplay@3x" normalIMG:@"targer_rightplay@3x"];
    self.rightPlayBtn.center = CGPointMake(self.playBtn.center.x + 17 + AutoKscreenWidth * 0.14,self.playBtn.center.y);
    [self.rightPlayBtn.actionBtn addTarget:self action:@selector(rightStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightPlayBtn];
    
    self.setStartBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(167), iFSize(335), btnWidth * 1.5, btnWidth * 0.7) WithTitle:@"Set A" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    self.setStartBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(12.5)];
    [self.setStartBtn.actionBtn addTarget:self action:@selector(setStartAction:) forControlEvents:UIControlEventTouchUpInside];
    self.setStartBtn.center = CGPointMake(self.leftPlayBtn.center.x - 30 - AutoKScreenHeight * 0.075, self.leftPlayBtn.center.y);
    [self.view addSubview:self.setStartBtn];
    
    
    self.setEndBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(420), iFSize(335), btnWidth * 1.5, btnWidth * 0.7) WithTitle:@"Set B" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    self.setEndBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(12.5)];
    [self.setEndBtn.actionBtn addTarget:self action:@selector(setSetEndAction:) forControlEvents:UIControlEventTouchUpInside];
    self.setEndBtn.center = CGPointMake(self.rightPlayBtn.center.x + 30 + AutoKScreenHeight * 0.075, self.rightPlayBtn.center.y);
    [self.view addSubview:self.setEndBtn];
    
    self.fileBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth,btnWidth) WithTitle:nil selectedIMG:@"target_file@3x" normalIMG:@"target_file@3x"];
    self.fileBtn.center = CGPointMake(AutoKScreenHeight * 0.15,self.playBtn.center.y);
    [self.fileBtn.actionBtn addTarget:self action:@selector(fileAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fileBtn];
    
    self.saveBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth) WithTitle:nil selectedIMG:@"Timelapse_SaveBtn@3x" normalIMG:@"Timelapse_SaveBtn@3x"];
    self.saveBtn.center = CGPointMake(AutoKScreenHeight * 0.85, self.playBtn.center.y);
    [self.saveBtn.actionBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.saveBtn];
    
    
    self.bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, AutoKscreenWidth * 0.86, AutoKScreenHeight, AutoKscreenWidth * 0.14)];
    self.bannerView.backgroundColor = COLOR(66, 66, 66, 1);
    self.bannerView.layer.masksToBounds = YES;
    self.bannerView.alpha = 0;
    
//    [self.view addSubview:self.bannerView];
    
    self.pauseBtn2 = [[iFButton alloc]initWithFrame:CGRectMake(kScreenHeight * 0.49, iFSize(10), iFSize(27), iFSize(30)) andnormalImage:@"pause" andSelectedImage:@"pause"];
    [self.pauseBtn2 addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bannerView addSubview:self.pauseBtn2];
    
    
    A_pointValueView = [[iFTarget_PointValueView alloc]initWithFrame:CGRectMake(0, 0, 100, 80) WithTitle:@"A point"];
    A_pointValueView.center = CGPointMake(AutoKScreenHeight * 0.3, AutoKscreenWidth * 0.25);
    A_pointValueView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:A_pointValueView];
    
    B_pointValueView = [[iFTarget_PointValueView alloc]initWithFrame:CGRectMake(0, 0, 100, 80) WithTitle:@"B point"];
    B_pointValueView.center = CGPointMake(AutoKScreenHeight * 0.7, AutoKscreenWidth * 0.25);
    B_pointValueView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:B_pointValueView];
    
    fileview = [[UIView alloc]initWithFrame:CGRectMake(0, -AutoKscreenWidth, AutoKScreenHeight * 0.4, AutoKscreenWidth)];
    fileview.backgroundColor = [UIColor blackColor];
    fileview.layer.borderWidth = 2;
    fileview.layer.borderColor = [UIColor whiteColor].CGColor;
    fileview.layer.cornerRadius = 5;
    [self.view addSubview:fileview];
    
    
    iFButton * closeBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 80, 50) andTitle:@"close"];
//    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn addTarget:self action:@selector(closeFileAction:) forControlEvents:UIControlEventTouchUpInside];
    [fileview addSubview:closeBtn];
    
    iFLabel * FiletitleLabel = [[iFLabel alloc]initWithFrame:CGRectMake(closeBtn.frame.size.width, 0, fileview.frame.size.width - closeBtn.frame.size.width, 50) WithTitle:@"FileList" andFont:20];
    [fileview addSubview:FiletitleLabel];
    
    fileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, fileview.frame.size.width, fileview.frame.size.height - 50)];
    fileTableView.dataSource = self;
    fileTableView.delegate = self;
    fileTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:TARGETModelList];
    fileDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [fileview addSubview:fileTableView];
}
- (void)getSelectedIndex:(NSInteger)selectedIndex withTag:(NSInteger)tag{
    issingleormulti = !selectedIndex;
    
    NSLog(@"%d", issingleormulti);
}
- (NSString *)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
- (void)saveWithName:(NSString *)nameStr{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:TARGETModelList];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    fileDataArray = [NSMutableArray arrayWithArray:array];
    
    
    targetModel.fileName = nameStr;
    targetModel.slide_A_pointValue = record_A_SliderPosition;
    targetModel.slide_B_pointValue = record_B_SliderPosition;
    targetModel.X2_A_panValue = record_A_panAngle;
    targetModel.X2_B_panValue = record_B_panAngle;
    targetModel.X2_A_tiltValue = record_A_TiltAngle;
    targetModel.X2_B_tiltValue = record_B_TiltAngle;
    targetModel.smoothnessLevel = [smoothView getSmoothnesslevel];
    targetModel.SaveDataTime = [self getCurrentTimes];
    
    NSDictionary * dict = [targetModel dictionaryWithValuesForKeys:[targetModel allPropertyNames]];
    [fileDataArray addObject:dict];
    
    [fm createFileAtPath:plistPath contents:nil attributes:nil];
    NSArray * array1 = [NSArray arrayWithArray:fileDataArray];
    [array1 writeToFile:plistPath atomically:YES];
    NSLog(@"%@", plistPath);
    
}
- (void)saveAction:(iFButton *)btn{
    
    NSString *title = NSLocalizedString(Timeline_SavedAndNamed, nil);
    
    NSString *message = NSLocalizedString(Timeline_EnterPlaceSlogan, nil);
    
    NSString *cancelButtonTitle = NSLocalizedString(Timeline_Cancel, nil);
    
    NSString *okButtonTitle = NSLocalizedString(Timeline_OK, nil);
    
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(Timeline_EnterNameSlogan, nil);
        textField.secureTextEntry = NO;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.delegate = self;
        textField.tag = 100;
        
    }];
    
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //         读取文本框的值显示出来
        UITextField *newName = alertDialog.textFields.lastObject;
        [self saveWithName:newName.text];
        
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancel];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [alertDialog.view setNeedsLayout];
    [alertDialog.view layoutIfNeeded];
    [self presentViewController:alertDialog animated:YES completion:^{
        
    }];
}
- (void)closeFileAction:(iFButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        fileview.frame = CGRectMake(0, -AutoKscreenWidth, AutoKScreenHeight * 0.4, AutoKscreenWidth);
    }];
    [fileTableView reloadData];
}
- (void)fileAction:(iFButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        fileview.frame = CGRectMake(0, 0, AutoKScreenHeight * 0.4, AutoKscreenWidth);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fileDataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:TARGETModelList];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    fileDataArray = [NSMutableArray arrayWithArray:array];
    [UIView animateWithDuration:0.3 animations:^{
        fileview.frame = CGRectMake(0, -AutoKscreenWidth, AutoKScreenHeight * 0.4, AutoKscreenWidth);

    }];
//    NSDictionary * dict = fileDataArray[0];
    
    record_A_SliderPosition = [fileDataArray[indexPath.row][@"slide_A_pointValue"] integerValue];
    record_B_SliderPosition = [fileDataArray[indexPath.row][@"slide_B_pointValue"] integerValue];
    record_A_panAngle = [fileDataArray[indexPath.row][@"X2_A_panValue"] integerValue];
    record_A_TiltAngle = [fileDataArray[indexPath.row][@"X2_A_tiltValue"] integerValue];
    record_B_panAngle = [fileDataArray[indexPath.row][@"X2_B_panValue"] integerValue];
    record_B_TiltAngle = [fileDataArray[indexPath.row][@"X2_B_tiltValue"] integerValue];
    [smoothView initSmoothLevelWith: [fileDataArray[indexPath.row][@"smoothnessLevel"] integerValue]];
    

    self.setStartBtn.actionBtn.selected = YES;
    self.setEndBtn.actionBtn.selected = YES;
    setAandBpointTimer.fireDate = [NSDate distantPast];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.text = fileDataArray[indexPath.row][@"fileName"];
        cell.textLabel.backgroundColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
    
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
//      cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
//    cell.textLabel.backgroundColor = [UIColor redColor];
//    cell.detailTextLabel.backgroundColor = [UIColor blueColor];
}
#pragma mark -----删除操作---------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:TARGETModelList];
    
    [fileDataArray removeObjectAtIndex:indexPath.row];
    /*删除tableView中的一行*/
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [fileDataArray writeToFile:plistPath atomically:YES];
    
    NSLog(@"%@", plistPath);
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return NSLocalizedString(KeyFrame_delete, nil);
}
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willBeginEditingRowAtIndexPath 删除2");
    
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndEditingRowAtIndexPath 删除3");
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return UITableViewCellEditingStyleDelete;
}

#pragma mark - StopAction放弃指令-----------
- (void)StopAction:(iFButton *)btn{
    _receiveView.FMtaskSlidePercent = 0;
    _receiveView.FMx2taskPercent = 0;
    returnZeroTimer.fireDate = [NSDate distantFuture];
    isRunning = NO;
    StopTimer.fireDate = [NSDate distantPast];
    self.stopBtn.alpha = 0;
    self.playBtn.alpha = 1;
    self.leftPlayBtn.actionBtn.userInteractionEnabled = YES;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = YES;
    [_RightanalogueStick reStartRocker];
    [_LeftanalogueStick reStartRocker];
}
- (void)SendStopMethod:(UInt8)mode{
    
    [_sendView sendTarget_play_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:mode andFunctionMode:0x04 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:0x00 andTimeStamp:0x00 WithStr:SendStr];
    [_sendView sendTarget_play_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:mode andFunctinMode:0x04 andDirection:0x00 andIsloop:0x00 andTotaltime:alltime andsmoothnessLevel:0x00 andTimeStamp:0x00 WithStr:SendStr andSingleorMulti:issingleormulti];
}
- (CGFloat)getYLimitWithAboveView:(UIView *)aboveView{
    
    CGFloat y = 0.0f;
    y = aboveView.frame.size.height + aboveView.frame.origin.y + 5;
    return y;
}
- (CGFloat)getXLeftLimitWithCenterView:(UIView *)centerView{
    CGFloat x = 0.0f;
    x = centerView.frame.origin.x - 8.5 - AutoKscreenWidth * 0.13;
    return x;
}
- (CGFloat)getXRightLimitWithCenterView:(UIView *)centerView{
    CGFloat x = 0.0f;
    x = centerView.frame.origin.x + centerView.frame.size.width + 8.5;
    return x;
}
- (CGFloat)getYLimitWithFollowView:(UIView *)followView{
    
    CGFloat y = 0.0f;
    y = followView.frame.origin.y - 5 - AutoKscreenWidth * 0.07;
    return y;
}
- (void)changeVectorForTheSegment:(UISegmentedControl *)segm{
    if (segm.tag == LeftSegmentTag) {
        if (segm.selectedSegmentIndex == 0) {
            _leftunit = 0.2f;
        }else if(segm.selectedSegmentIndex == 1){
            _leftunit = 0.4f;
        }else{
            _leftunit = 1.0f;
        }
    }else{
        if (segm.selectedSegmentIndex == 0) {
            _rightunit = 0.2f;
        }else if(segm.selectedSegmentIndex == 1){
            _rightunit = 0.4f;
        }else{
            _rightunit = 1.0f;
        }
    }
}



- (void)testAction:(iFButton *)btn{
    if (btn.tag == 101) {
        slideView.progress = slideView.progress + 0.05;
    }else if(btn.tag == 102){
        slideView.progress = slideView.progress - 0.05;
    }
}
static int lcount = 0;
#pragma mark - 手势响应事件 - 
- (void)tapChooseTotalTime:(UITapGestureRecognizer *)tap{
    
//    int minTime = (int)ceil([self getMinTimeWithSlideABDistance:slideDistance andPanABDistance:panDistance]);
    self.popover = [DXPopover new];
    iFTimePickerView * view = [[iFTimePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200)) withMinValue:0];
    view.timelapseDelegate = self;
    [self.popover showAtView:tap.view withContentView:view];
    [view setInitValue:alltime];
    
}

- (void)getTimelapseTime:(CGFloat)totalTime{
    NSInteger TheTotalTime = totalTime;
    
    int minTime = (int)ceil([self getMinTimeWithSlideABDistance:slideDistance andPanABDistance:panDistance]);
    alltime = TheTotalTime > minTime ? TheTotalTime : minTime;
    self.ifmodel.fmtotalTime = alltime;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith:alltime]];
    [ud setObject:[NSNumber numberWithInteger:alltime] forKey:FMRUNTIME];
    
    [ud synchronize];
    
}



#pragma mark -- 定时器的集合------

static int b = 0;
//直接调用历史数据发送AB点位置的位置
- (void)AandB_PointActionTimer:(NSTimer *)timer{
    b++;
    BOOL conditions = NO;
    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMx2Mode == 0x03 && _receiveView.FMslideMode == 0x03);
            if (b > 3) {
                if (conditions) {
                    b = 0;
                    timer.fireDate = [NSDate distantFuture];
                }else{
                    [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x07 andVeloc:0x00 andSlider_A_point:(UInt32)(record_A_SliderPosition) andSlider_B_point:(UInt32)(record_B_SliderPosition) andTotalTime:alltime WithStr:SendStr];
                    [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x07 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:record_A_panAngle andTilt_A_Point:record_A_TiltAngle andPan_B_point:record_B_panAngle andTilt_B_Point:record_B_TiltAngle andTotalTime:alltime WithStr:SendStr];
                }
            }else{
                [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x04 andVeloc:0x00 andSlider_A_point:(UInt32)(record_A_SliderPosition) andSlider_B_point:(UInt32)(record_B_SliderPosition) andTotalTime:alltime WithStr:SendStr];
                [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x04 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:record_A_panAngle andTilt_A_Point:record_A_TiltAngle andPan_B_point:record_B_panAngle andTilt_B_Point:record_B_TiltAngle andTotalTime:alltime WithStr:SendStr];
            }
            break;
            case CBOneS1:
            conditions = (_receiveView.FMslideMode == 0x03);
            break;
            case CBOneX2:
            conditions = (_receiveView.FMx2Mode == 0x03);
            break;
            case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }

}

- (void)timeCurrentTimer:(NSTimer *)timer{

    NSLog(@"timeCurrentTimer");
    BOOL conditions = NO;
    UInt8 functionMode= 0x0a;
    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMtaskslideStarttime == (UInt32)starttime && _receiveView.FMx2taskStarttime == (UInt32)starttime);
            functionMode= 0x0a;
            break;
        case CBOneS1:
            conditions = (_receiveView.FMtaskslideStarttime == (UInt32)starttime);
            functionMode= 0x0d;
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2taskStarttime == (UInt32)starttime);
            functionMode= 0x0d;
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }
    int a = lcount % 10;
    if (a == 0) {
        starttime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
    }
    lcount++;
    
    if (conditions) {
        NSLog(@"时间戳校准了");
        
        isRunning = YES;
        timer.fireDate = [NSDate distantFuture];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Target_Running, nil)];
        
    }else{
        
        [_sendView sendTarget_play_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:functionMode andFunctionMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr];
        [_sendView sendTarget_play_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:functionMode andFunctinMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr andSingleorMulti:issingleormulti];
        
    }
}

static int a = 0;

- (void)returnZeroActionTimer:(NSTimer *)timer{
    NSLog(@"returnZeroActionTimer %d %d",_receiveView.FMTaskslideMode, _receiveView.FMx2taskMode);
    
    a++;
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    BOOL conditions = NO;
     UInt8 functionMode= 0x0a;
    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMTaskslideMode == 0x01 && _receiveView.FMx2taskMode == 0x01);
           functionMode= 0x0a;
            break;
        case CBOneS1:
            conditions = (_receiveView.FMTaskslideMode == 0x01);
            
            functionMode= 0x0d;
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2taskMode == 0x01);
            functionMode= 0x0d;
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }
    
    [_sendView sendTarget_play_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:functionMode andFunctionMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr];
    
    [_sendView sendTarget_play_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:functionMode andFunctinMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr andSingleorMulti:issingleormulti];

    if (a > 10) {
        
    if (conditions) {
    
        NSLog(@"归零了");
        self.stopBtn.alpha = 0;
        self.playBtn.alpha = 1;
        self.leftPlayBtn.actionBtn.userInteractionEnabled = YES;
        self.rightPlayBtn.actionBtn.userInteractionEnabled = YES;
        [_RightanalogueStick reStartRocker];
        [_LeftanalogueStick reStartRocker];
        
        [SVProgressHUD dismiss];
        a = 0;
//        if (record_A_SliderPosition == _receiveView.FMslideRealPosition) {
            timer.fireDate = [NSDate distantFuture];
//        }
//        [SVProgressHUD showWithStatus:@"归零了开始run"];

    }else{
        _receiveView.FMTaskslideMode = 0x00;
        _receiveView.FMx2taskMode = 0x00;
        self.stopBtn.alpha = 1;
        self.playBtn.alpha = 0;
    }
    }
}

/**
 暂停运行（放弃运行）（0x0A） Mode = 0x04

 @param timer timer description
 */
- (void)StopActionTimer:(NSTimer *)timer{
    NSLog(@"StopActionTimer");
    
    self.bannerView.alpha = 0;
//    self.rootbackBtn.alpha = 1;
    [SVProgressHUD dismiss];
    
    BOOL conditions = NO;
    UInt8 functionMode= 0x0a;

    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMTaskslideMode == 0x04 && _receiveView.FMx2taskMode == 0x04);
            functionMode= 0x0a;
            break;
        case CBOneS1:
            conditions = (_receiveView.FMTaskslideMode == 0x04);
            functionMode= 0x0d;
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2taskMode == 0x04);
            functionMode= 0x0d;
            
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }
    if (conditions) {
        
        returnZeroTimer.fireDate = [NSDate distantFuture];
        
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        
        [self SendStopMethod:functionMode];
        
        
    }

    
}

/**
 开始运行（0x0A）Mode = 0x02

 @param timer timer description
 */
- (void)runActionTimer:(NSTimer *)timer{
    NSLog(@"runActionTimer");
    BOOL conditions = NO;
    UInt8 functionMode= 0x0a;

    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMTaskslideMode == 0x02 && _receiveView.FMx2taskMode == 0x02);
            functionMode= 0x0a;
            break;
        case CBOneS1:
            conditions = (_receiveView.FMTaskslideMode == 0x02);
            functionMode= 0x0d;
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2taskMode == 0x02);
            functionMode= 0x0d;
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }
    if (conditions) {
        timer.fireDate = [NSDate distantFuture];
        isRunning = YES;
        
    }else{
        
        [_sendView sendTarget_play_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:functionMode andFunctionMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr];
        [_sendView sendTarget_play_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:functionMode andFunctinMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr andSingleorMulti:issingleormulti];
    }
    
}

/**
 设置A点 （0x09）Mode = 0x05

 @param timer timer description
 */
static int aaa = 0;

- (void)ApointActionTimer:(NSTimer *)timer{
    NSLog(@"ApointActionTimer");
    
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
    aaa++;
    BOOL conditions = NO;
    
    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMx2_AB_Mark == 0x05 && ((_receiveView.FMx2Mode & 0x0f) >> 1 == 1) && ((_receiveView.FMslideMode & 0x0f) >> 1 == 1) && _receiveView.FMslide_AB_Mark == 0x05);
           
            break;
        case CBOneS1:
            conditions = (_receiveView.FMslide_AB_Mark == 0x05) && ((_receiveView.FMslideMode & 0x0f) >> 1 == 1);
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2_AB_Mark == 0x05 && ((_receiveView.FMx2Mode & 0x0f) >> 1 == 1));
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }

    if (aaa<2) {
        [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x08 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideRealPosition andSlider_B_point:_receiveView.FMslideRealPosition andTotalTime:alltime WithStr:SendStr];
        [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x08 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RealPanAngle andTilt_A_Point:_receiveView.FMx2RealTiltAngle andPan_B_point:_receiveView.FMx2RealPanAngle andTilt_B_Point:_receiveView.FMx2RealTiltAngle andTotalTime:alltime WithStr:SendStr];
    }else{
        
        [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x05 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideRealPosition andSlider_B_point:_receiveView.FMslideRealPosition andTotalTime:alltime WithStr:SendStr];
        [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x05 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RealPanAngle andTilt_A_Point:_receiveView.FMx2RealTiltAngle andPan_B_point:_receiveView.FMx2RealPanAngle andTilt_B_Point:_receiveView.FMx2RealTiltAngle andTotalTime:alltime WithStr:SendStr];
    }
    if (aaa < 5) {
        return;
    }
    if (conditions) {
        aaa = 0;
        
        record_A_SliderPosition = _receiveView.FMslideApointPosition;
        record_A_panAngle = _receiveView.FMx2RecordPanAngle;
        record_A_TiltAngle = _receiveView.FMx2RecordTiltAngle;
        [SVProgressHUD dismiss];
        timer.fireDate = [NSDate distantFuture];
        
    }
}

/**
 设置B点（0x09）Mode = 0x06

 @param timer timer description
 */
- (void)BpointActionTimer:(NSTimer *)timer{
    
    NSLog(@"BpointActionTimer");
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
    BOOL conditions = NO;
    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMx2_AB_Mark == 0x06 && ((_receiveView.FMx2Mode & 0x01) == 1) && ((_receiveView.FMslideMode & 0x01)== 1) && _receiveView.FMslide_AB_Mark == 0x06);
            

            break;
        case CBOneS1:
            conditions = (_receiveView.FMslide_AB_Mark == 0x06) && ((_receiveView.FMslideMode & 0x01) == 1);
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2_AB_Mark == 0x06 && ((_receiveView.FMx2Mode & 0x01) == 1));
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }
   
    aaa++;
    if (aaa < 2) {
        [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x09 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideApointPosition andSlider_B_point:_receiveView.FMslideBpointPosition andTotalTime:alltime WithStr:SendStr];
        [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x09 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RecordPanAngle andTilt_A_Point:_receiveView.FMx2RecordTiltAngle andPan_B_point:_receiveView.FMx2RecordPanAngle andTilt_B_Point:_receiveView.FMx2RecordTiltAngle andTotalTime:alltime WithStr:SendStr];
    }else{
        
        [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x06 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideApointPosition andSlider_B_point:_receiveView.FMslideBpointPosition andTotalTime:alltime WithStr:SendStr];
        [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x06 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RecordPanAngle andTilt_A_Point:_receiveView.FMx2RecordTiltAngle andPan_B_point:_receiveView.FMx2RecordPanAngle andTilt_B_Point:_receiveView.FMx2RecordTiltAngle andTotalTime:alltime WithStr:SendStr];
    }
    if (aaa < 5) {
        return;
    }
    if (conditions) {
        [SVProgressHUD dismiss];
        aaa = 0;
        record_B_SliderPosition = _receiveView.FMslideBpointPosition;
        record_B_panAngle = _receiveView.FMx2RecordPanAngle;
        record_B_TiltAngle = _receiveView.FMx2RecordTiltAngle;
        timer.fireDate = [NSDate distantFuture];
        
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self closeFileAction:nil];
    
    
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


#pragma mark - JSAnalogueStick Delegate-
- (void)analogueStickDidChangeValue:(iFootageRocker *)analogueStick{
    
    CGFloat panV, tiltV = 0.0;
    CGFloat sliderV = 0.0;
    UInt16 panVelocityVector;
    UInt16 tiltVelocityVector;
    UInt16 slideVelocityVector;
    
    _receiveView.FMTaskslideMode = 0x00;
    _receiveView.FMx2taskMode = 0x00;
    
    
    //    NSLog(@"%f", analogueStick.xValue);
    //    NSLog(@"%f", analogueStick.yValue);
    if (analogueStick.tag == RightStickTag) {
        
        NSLog(@"%lf", analogueStick.xValue);
        if (analogueStick.xValue >= 1.0f) {
            //            NSLog(@"P = %lf",         [panAdjustView CountSomeThingsAndPointX:1.0f]);
            panV =  [panAdjustView CountSomeThingsAndPointX:1.0f];
            
            
        }else{
            panV = [panAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
            
            
        }
        NSLog(@"P = %lf", panV);
        
        NSLog(@"T = %lf", tiltV);
        
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
        panVelocityVector = panV * PanVelocMaxValue * islockpan * 100.0f + 3000;
        tiltVelocityVector = tiltV * TiltVelocMaxValue * islockTilt * 100.0f + 3000;
        
        NSLog(@"%d, %d", panVelocityVector, tiltVelocityVector);
        
        [_sendView sendSetFocusModeWithCb:appDelegate.bleManager.panCB andFrameHead:0x555F andFuntionNumber:0X09 andFunctionMode:0X01 andSlideOrPanVeloc:panVelocityVector andTiltVeloc:tiltVelocityVector andIsLockTilt:islockTilt andTotalTime:0X00 WithStr:SendStr];
        
    }else if (analogueStick.tag == LeftStickTag) {
        if (analogueStick.xValue >= 1.0f) {
            
            sliderV =  [slideAdjustView CountSomeThingsAndPointX:1.0f];
            
        }else{
            sliderV = [slideAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
        }
        slideVelocityVector = sliderV * 50.0f * 100.0f + 5000 ;
        [_sendView sendSetFocusModeWithCb:appDelegate.bleManager.sliderCB andFrameHead:0xAAAF andFuntionNumber:0x09 andFunctionMode:0x01 andSlideOrPanVeloc:slideVelocityVector andTiltVeloc:0x00 andIsLockTilt:islockTilt andTotalTime:0x00 WithStr:SendStr];
    }

//    NSLog(@"%f %f", analogueStick.xValue, analogueStick.yValue);
//    if (analogueStick.tag == LeftStickTag) {
//        [self leftUpdateAnalogue];
//    }else if(analogueStick.tag == RightStickTag){
//        [self rightUpdateAnalogue];
//    }
    
}
- (void)rightUpdateAnalogue
{

    
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
    UInt16 panVelocityVector = (UInt16)(ActiveVX * _rightunit * islockpan / 50.0f * 30.0f * 100 + 3000);
    UInt16 tiltVelocityVector = (UInt16)(ActiveVY * _rightunit / 50.0f * TiltVelocMaxValue * 100 + 3000);
    
    [_sendView sendSetFocusModeWithCb:appDelegate.bleManager.panCB andFrameHead:0x555F andFuntionNumber:0X09 andFunctionMode:0X01 andSlideOrPanVeloc:panVelocityVector andTiltVeloc:tiltVelocityVector andIsLockTilt:islockTilt andTotalTime:0X00 WithStr:SendStr];
    
}
- (void)leftUpdateAnalogue{

    
    ActiveSliderY = tan(self.LeftanalogueStick.xValue) * Vspeed;
    if (ActiveSliderY > 50.0f) {
        ActiveSliderY = 50.0f;
    }
    
    UInt16 slideVelocityVector = (UInt16)(ActiveSliderY * _leftunit * 100.0f + 5000);
    [_sendView sendSetFocusModeWithCb:appDelegate.bleManager.sliderCB andFrameHead:0xAAAF andFuntionNumber:0x09 andFunctionMode:0x01 andSlideOrPanVeloc:slideVelocityVector andTiltVeloc:0x00 andIsLockTilt:islockTilt andTotalTime:0x00 WithStr:SendStr];
    
}

#pragma mark - Btn的响应- 

- (void)backtolastViewC{

    UIAlertController * alertView = [iFAlertController showAlertControllerWith:NSLocalizedString(Timeline_WarmTips, nil) Message:@"" SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
        
    }];
    [self presentViewController:alertView animated:YES completion:^{
    
    }];

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)isloopAction:(iFButton *)btn{
    UInt8 functionMode = 0x0a;
    
    switch ([self getStatus]) {
        case CBS1ANDX2:
            functionMode = 0x0a;
            break;
        case CBOneS1:
            functionMode = 0x0d;
            break;
        case CBOneX2:
            functionMode = 0x0d;
            break;
        case CBAllNull:
            break;
        default:
            break;
    }
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        NSLog(@"1");
        isloop = 0x01;
        
    }else{
        isloop = 0x00;
        NSLog(@"2");
    }
    UInt64 time = ([[NSDate date] timeIntervalSince1970]) * 1000;
    
    [_sendView sendFocusModeWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:functionMode andFunctionMode:0x01 andDirction:direction andIsloop:isloop andTimeStamp_ms:time WithStr:SendStr andAllTime:alltime];
    [_sendView sendFocusModeWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:functionMode andFunctionMode:0x01 andDirction:direction andIsloop:isloop andTimeStamp_ms:time WithStr:SendStr andAllTime:alltime];
}

- (BOOL)judgeIsRightSettingWithPanValue{
    
    BOOL isPanAg = NO;
    
    CGFloat panAg;
    CGFloat TiltAg;
    CGFloat slideVa;
    CGFloat slidemin;
    panAg = (_receiveView.FMx2RealPanAngle - 3600.0f) / 10.0f;
    TiltAg = (_receiveView.FMx2RealTiltAngle - 350.0f) / 10.0f;
    slideVa = _receiveView.FMslideRealPosition / 100.0f;
    slidemin = _receiveView.FMslideBpointPosition < _receiveView.FMslideApointPosition ? _receiveView.FMslideBpointPosition : _receiveView.FMslideApointPosition;
    
    if (panAg >= -90.0f && panAg <= 90.0f) {
        isPanAg = YES;
        
    }else{
        isPanAg = NO;
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(Target_AngelError, nil)];
        
    }

    return isPanAg;
}


- (void)changeTheTimeLabelWithMinTime{
    [self GetMinTime];
    [self getTimelapseTime:alltime];
    
    
}
-(void)playAction:(iFButton *)btn{
    
    if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == NO) {
        NSLog(@"都没有设置");
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ABNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == YES && self.setEndBtn.actionBtn.selected == NO){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_BNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == YES){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ANoSettings, nil)];
        return;
    }

    
    [self changeTheTimeLabelWithMinTime];
    _receiveView.FMtaskSlidePercent = 0;
    _receiveView.FMx2taskPercent = 0;

    self.stopBtn.alpha = 1;
    self.playBtn.alpha = 0;

    self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
    StopTimer.fireDate = [NSDate distantFuture];

    [_RightanalogueStick dellocRcoker];
    [_LeftanalogueStick dellocRcoker];

    BOOL conditions = NO;
    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMTaskslideMode == 0x01 && _receiveView.FMx2taskMode == 0x01);
            
            break;
        case CBOneS1:
            conditions = (_receiveView.FMTaskslideMode == 0x01);
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2taskMode == 0x01);
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }
    
    if (conditions) {
        
        starttime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
        timeCorrectTimer.fireDate = [NSDate distantPast];
        
    }else{
        
        freeReturnZeroTimer.fireDate = [NSDate distantPast];
    }


    
}
- (void)freeReturnZeroTimer:(NSTimer *)timer{
    
    BOOL conditions = NO;
    UInt8 functionMode= 0x0a;

    switch ([self getStatus]) {
        case CBS1ANDX2:
            conditions = (_receiveView.FMTaskslideMode == 0x01 && _receiveView.FMx2taskMode == 0x01);
            functionMode= 0x0a;
            break;
        case CBOneS1:
            conditions = (_receiveView.FMTaskslideMode == 0x01);
            functionMode= 0x0d;
            break;
        case CBOneX2:
            conditions = (_receiveView.FMx2taskMode == 0x01);
            functionMode= 0x0d;
            break;
        case CBAllNull:
            conditions = NO;
            break;
        default:
            break;
    }
    
    if (conditions) {
        
        timeCorrectTimer.fireDate = [NSDate distantPast];
        starttime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        direction = 0x03;
        
        [_sendView sendTarget_play_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:functionMode andFunctionMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr];
        
        [_sendView sendTarget_play_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:functionMode andFunctinMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr andSingleorMulti:issingleormulti];
        
    }
   
}
- (void)leftStartAction:(iFButton *)btn{
    _receiveView.FMTaskslideMode = 0x00;
    _receiveView.FMx2taskMode = 0x00;
    
    NSLog(@"Start = %d", self.setStartBtn.actionBtn.selected);
    NSLog(@"End = %d", self.setEndBtn.actionBtn.selected);
    
    if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == NO) {
        NSLog(@"都没有设置");
        
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ABNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == YES && self.setEndBtn.actionBtn.selected == NO){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_BNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == YES){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ANoSettings, nil)];
        return;
        
    }
    
    self.stopBtn.alpha = 1;
    self.playBtn.alpha = 0;
//    self.rootbackBtn.alpha = 0;
//    self.bannerView.alpha = 1;
    a = 0;
    direction = 0x02;
    slideView.direction = direction;
    
    self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
    [_RightanalogueStick dellocRcoker];
    [_LeftanalogueStick dellocRcoker];
    
    returnZeroTimer.fireDate = [NSDate distantPast];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
    
//    NSLog(@"leftrun");
    
    
}
- (void)rightStartAction:(iFButton *)btn{
    _receiveView.FMTaskslideMode = 0x00;
    _receiveView.FMx2taskMode = 0x00;
    if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == NO) {
        NSLog(@"都没有设置");
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ABNoSettings, nil)];
        
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == YES && self.setEndBtn.actionBtn.selected == NO){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_BNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == YES){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ANoSettings, nil)];
        return;
        
    }
    
    NSLog(@"Start = %d", self.setStartBtn.actionBtn.selected);
    NSLog(@"End = %d", self.setEndBtn.actionBtn.selected);
//    self.rootbackBtn.alpha = 0;
//    self.bannerView.alpha = 1;
    self.stopBtn.alpha = 1;
    self.playBtn.alpha = 0;
    self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
    [_RightanalogueStick dellocRcoker];
    [_LeftanalogueStick dellocRcoker];
    
    
    a = 0;
    direction = 0x01;
    slideView.direction = direction;
    returnZeroTimer.fireDate = [NSDate distantPast];
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
    

//    NSLog(@"rigthrun");
    
}
- (void)pauseAction:(iFButton *)btn{
//    NSLog(@"pauserun");
    self.rootbackBtn.alpha = 1;
    StopTimer.fireDate = [NSDate distantPast];
}
- (void)setStartAction:(UIButton *)btn{
//    NSLog(@"setStart");
    
//    if ([self judgeIsRightSettingWithPanValue]) {
    
        if (btn.selected) {
            [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x08 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideRealPosition andSlider_B_point:_receiveView.FMslideRealPosition andTotalTime:alltime WithStr:SendStr];
            [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x08 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RealPanAngle andTilt_A_Point:_receiveView.FMx2RealTiltAngle andPan_B_point:_receiveView.FMx2RealPanAngle andTilt_B_Point:_receiveView.FMx2RealTiltAngle andTotalTime:alltime WithStr:SendStr];
            record_A_SliderPosition = 0;
            record_A_panAngle = 0;
            record_A_TiltAngle = 0;
            
            LeftPointTimer.fireDate = [NSDate distantFuture];
            
        }else{
            direction = 0x01;
            record_A_SliderPosition = _receiveView.FMslideApointPosition;
            record_A_panAngle = _receiveView.FMx2RecordPanAngle;
            record_A_TiltAngle = _receiveView.FMx2RecordTiltAngle;
            [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x05 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideRealPosition andSlider_B_point:_receiveView.FMslideRealPosition andTotalTime:alltime WithStr:SendStr];
            [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x05 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RealPanAngle andTilt_A_Point:_receiveView.FMx2RealTiltAngle andPan_B_point:_receiveView.FMx2RealPanAngle andTilt_B_Point:_receiveView.FMx2RealTiltAngle andTotalTime:alltime WithStr:SendStr];
            
            LeftPointTimer.fireDate = [NSDate distantPast];
        }
        [self changeBtnSelected:btn];
//    }
}
- (void)setSetEndAction:(UIButton *)btn{
    
//    NSLog(@"setend");
//    if ([self judgeIsRightSettingWithPanValue]) {
        if (btn.selected) {
            [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x09 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideRealPosition andSlider_B_point:_receiveView.FMslideRealPosition andTotalTime:alltime WithStr:SendStr];
            [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x09 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RealPanAngle andTilt_A_Point:_receiveView.FMx2RealTiltAngle andPan_B_point:_receiveView.FMx2RealPanAngle andTilt_B_Point:_receiveView.FMx2RealTiltAngle andTotalTime:alltime WithStr:SendStr];
            record_B_SliderPosition = 0;
            record_B_panAngle = 0;
            record_B_TiltAngle = 0;
            RightPointTimer.fireDate = [NSDate distantFuture];
        }else{
            [_sendView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x06 andVeloc:0x00 andSlider_A_point:_receiveView.FMslideApointPosition andSlider_B_point:_receiveView.FMslideBpointPosition andTotalTime:alltime WithStr:SendStr];
            
            [_sendView sendTarget_prepare_X2WithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x06 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.FMx2RecordPanAngle andTilt_A_Point:_receiveView.FMx2RecordTiltAngle andPan_B_point:_receiveView.FMx2RecordPanAngle andTilt_B_Point:_receiveView.FMx2RecordTiltAngle andTotalTime:alltime WithStr:SendStr];
            
            record_B_SliderPosition = _receiveView.FMslideBpointPosition;
            record_B_panAngle = _receiveView.FMx2RecordPanAngle;
            record_B_TiltAngle = _receiveView.FMx2RecordTiltAngle;
//            btn.userInteractionEnabled = NO;
            direction = 0x02;
            
            RightPointTimer.fireDate = [NSDate distantPast];
        }
        
        [self changeBtnSelected:btn];
//    }
}

- (void)lockTiltAction:(UIButton *)btn{
    
    if (btn.selected) {
        islockTilt = 0x01;
    }else{
        islockTilt = 0x00;
    }
    [self changeBtnSelected:btn];
   
}
- (void)lockPanAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        islockpan = 0;
    }else{
        islockpan = 1;
    }
//    NSLog(@"%ld", islockpan);
    
}
- (void)changeBtnSelected:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor grayColor];
    }else{
        btn.backgroundColor = [UIColor clearColor];
        
    }
}

#warning --count ---- 计算最小时间---------
/**
 *  合并数组  返回X的值和T的值
 */
- (NSArray *)getNewArrayWithPointArray:(NSArray *)pointArray andControlArray:(NSArray *)controlArray{
    NSMutableArray * array = [NSMutableArray new];
    NSMutableArray * totalArray = [NSMutableArray new];
    
    NSMutableArray * array1 = [NSMutableArray new];
    NSMutableArray * array2 = [NSMutableArray new];
    
    if (!pointArray.count) {
        
    }else{
        
        for (int i = 0 ; i < pointArray.count; i++) {
            [array addObject:pointArray[i]];
            if (i < pointArray.count - 1) {
                [array addObject:controlArray[i][0]];
                [array addObject:controlArray[i][1]];
            }
        }
    }
    
    for ( NSValue * point in array) {
        CGPoint p = point.CGPointValue;
        
        [array1 addObject:[NSNumber numberWithFloat:p.x]];
        [array2 addObject:[NSNumber numberWithFloat:p.y]];
        
    }
    [totalArray addObject:array1];
    [totalArray addObject:array2];
    
    return totalArray;
}


/**
 //判断当前时间代入速度是否超过slider的极限速度
 @param realRunningTime 代入测试时间
 @return 超过为NO  未超过为YES
 */
- (BOOL)countTargetVideoTime:(CGFloat)realRunningTime{
    CGFloat smoothpercent = (CGFloat)([smoothView getSmoothnesslevel] + 1) / 10.0f;
    NSArray * slidePointArray = @[
  @[Value(0),Value((realRunningTime * smoothpercent)), Value((realRunningTime * (1.0f - smoothpercent))), Value(realRunningTime)],
  @[Value((record_A_SliderPosition / 100.0f)), Value((record_A_SliderPosition / 100.0f)), Value((record_B_SliderPosition / 100.0f)), Value((record_B_SliderPosition / 100.0f))]];
    NSArray * panPointArray = @[@[Value(0),Value((realRunningTime * smoothpercent)), Value((realRunningTime * (1.0f - smoothpercent))), Value(realRunningTime)], @[Value((record_A_panAngle - 3600.0f) / 10.0f), Value((record_A_panAngle - 3600.0f) / 10.0f), Value((record_B_panAngle - 3600.0f) / 10.0f), Value((record_B_panAngle - 3600.0f) / 10.0f)]];


    CGFloat a,b;
    CGFloat A,B;
    
    CGFloat slidefirstF = [[slidePointArray[0] firstObject] floatValue];
    CGFloat slidelastF =  [[slidePointArray[0] lastObject] floatValue];
    CGFloat panfirstF = [[panPointArray[0] firstObject] floatValue];
    CGFloat panlastF = [[panPointArray[0] lastObject] floatValue];
    float SlidePos[31] = {0.0};
    float SlideT[31] = {0.0};
    float PanPos[31] = {0.0};
    float PanT[31] = {0.0};
 
//
    
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [slidePointArray[i] count]; j++) {
            if (i == 0) {
                SlideT[j] = [slidePointArray[i][j] floatValue];
            }else if (i == 1){
                SlidePos[j] = ([slidePointArray[i][j] floatValue]);
            }
        }
    }

    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [panPointArray[i] count]; j++) {
            if (i == 0 ) {
                PanT[j]  = [panPointArray[i][j] floatValue];
            }else if (i == 1){
                PanPos[j] = [panPointArray[i][j] floatValue];
                
                
            }
        }
    }

    for (int i = 0; i <= 1000; i++) {
        a = (slidelastF - slidefirstF) / 1000;
        b = (panlastF - panfirstF)/ 1000;
        
        A = fabsf(Slide_Speed_Calculate(a * i, SlidePos, SlideT));
        B = fabsf(Slide_Speed_Calculate(b * i, PanPos, PanT));
        if (A > 50.f) {
            return NO;
        }
        if (B > 30.0f) {
            return NO;
        }

    }
    return YES;
//
}

- (CGFloat)getMinTimeWithSlideABDistance:(CGFloat)slidedistance andPanABDistance:(CGFloat)pandistace{
    
    CGFloat mintime;
    CGFloat t1, t2;
    if (slidedistance >= 50.0f) {
        t1 = 3.0f + (slidedistance - 50.0f) / 50.0f;
    }else{
        t1 = 2.0f * sqrtf(slidedistance / 50.0f) + 1.0f;
    }
    
    if (pandistace >= 30.0f) {
        t2 = 3.0f + (pandistace - 30.0f) / 30.0f;
    }else{
        t2 = 2.0f * sqrtf(pandistace / 30.0f) + 1;
    }
//    NSLog(@"T2 = %lf", t2);
    
    mintime = t1 > t2 ? t1 : t2;
    
    return mintime;
}


#pragma mark ------接收数据---------

- (BOOL)getWithValue1:(UInt16)value1 andValue2:(UInt32)value2{
    if ((value2-value1 == 1) || (value1 == value2)) {
        return YES;
    }
    return NO;
}

- (void)receiveRealData{


    [self GetMinTime];
    BOOL conditions;
    NSLog(@"issingleormulti %d", issingleormulti);
//    NSLog(@"FMslideBpointPosition%d", _receiveView.FMslideBpointPosition);
//    NSLog(@"FMslideApointPosition%d", _receiveView.FMslideApointPosition);


    
    if (isRunning) {
        NSLog(@"FMslideBpointPosition%d", _receiveView.FMslideBpointPosition);
        
        
        NSLog(@"FMx2taskMode%d", _receiveView.FMx2taskMode);
        NSLog(@"FMx2taskPercent%d", _receiveView.FMx2taskPercent);
        NSLog(@"FMtaskSlidePercent%d", _receiveView.FMtaskSlidePercent);
        self.playBtn.alpha = 0;
        self.stopBtn.alpha = 1;
        if (isloop) {
          
            
        }else{
            switch ([self getStatus]) {
                case CBS1ANDX2:
                    conditions = (_receiveView.FMtaskSlidePercent == 0 && _receiveView.FMx2taskPercent == 0 && _receiveView.FMTaskslideMode == 0x04 && _receiveView.FMx2taskMode == 0x04);
                    break;
                case CBOneS1:
                    conditions = (_receiveView.FMtaskSlidePercent == 0 &&  _receiveView.FMTaskslideMode == 0x04);
                    break;
                case CBOneX2:
                    conditions = (_receiveView.FMx2taskPercent == 0 && _receiveView.FMx2taskMode == 0x04);
                    break;
                case CBAllNull:
                    conditions = NO;
                    break;
                default:
                    break;
            }
            
            if (conditions) {
                
                [self StopAction:nil];
                
            }

        }
        
    }
    slideDistance = fabs((float)(_receiveView.FMslideBpointPosition / 100.0f - _receiveView.FMslideApointPosition /100.0f));
    
#warning panDistance 是根据FMx2BpointPanAngle FMx2ApointPanAngle 来计算的 但是已经删掉 要根据计算的AB点再计算时间
//    panDistance = fabs((_receiveView.FMx2BpointPanAngle - 36000.0f) / 100.0f  - (_receiveView.FMx2ApointPanAngle - 36000.0f) / 100.0f);
    CGFloat panAg;
    CGFloat TiltAg;
    CGFloat slideVa;
    CGFloat slidemin;
    
    
    
        panAg = (_receiveView.FMx2RealPanAngle - 3600.0f) / 10.0f;
        TiltAg = (_receiveView.FMx2RealTiltAngle - 350.0f) / 10.0f;
        slideVa = _receiveView.FMslideRealPosition / 100.0f;

    
   
    slidemin = _receiveView.FMslideBpointPosition / 100.0f < _receiveView.FMslideApointPosition /100.0f ? _receiveView.FMslideBpointPosition /100.0f : _receiveView.FMslideApointPosition /100.0f;
    
    CGFloat Adistance = record_A_SliderPosition /100.0f - slideVa;
    CGFloat Bdistance = record_B_SliderPosition /100.0f - slideVa;
    
    if (direction == 0x01) {
        slideView.progress = (((slidemin - slideVa)/ slideDistance) + 1.0f);
    }else if(direction == 0x02){
        slideView.progress = -(slideVa - slidemin)  / slideDistance;
    }else{
        
        if (Adistance > Bdistance) {
            
            slideView.progress = (((slidemin - slideVa)/ slideDistance) + 1.0f);
            slideView.direction = 0x01;
            
        }else{
           
            slideView.progress = -(slideVa - slidemin)  / slideDistance;
            slideView.direction = 0x02;
        }
    }
//    NSLog(@"slideVa = %lf", slideVa);
//    NSLog(@"slidemin = %lf", slidemin);
    
    
    self.panValueLabel.text = [NSString stringWithFormat:@"Pan value %.1f°", panAg];
    self.tiltValueLabel.text = [NSString stringWithFormat:@"Tilt value %.1f°", TiltAg];
    self.slideValueLabel.text = [NSString stringWithFormat:@"slide value %.1fmm", slideVa];
    
//    int minTime = (int)ceil([self getMinTimeWithSlideABDistance:slideDistance andPanABDistance:panDistance]);
    alltime = [self GetMinTime];
    [self isLockAlluserInteractionEnabled];
    
    if (self.setStartBtn.actionBtn.selected) {
        A_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_panAngle - 3600.0f) / 10.0f];
        A_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_TiltAngle - 350.0f) / 10.0f];
        A_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_A_SliderPosition / 100.0f];
        
    }else{
        A_pointValueView.panValueLabel.text = @"no set";
        A_pointValueView.tiltValueLabel.text = @"no set";
        A_pointValueView.slideValueLabel.text = @"no set";
    }
    
    if (self.setEndBtn.actionBtn.selected) {
        B_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_TiltAngle - 350.0f) / 10.0f];
        B_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_panAngle - 3600.0f) / 10.0f];
        B_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_B_SliderPosition / 100.0f];
    }else{
        
        B_pointValueView.panValueLabel.text = @"no set";
        B_pointValueView.tiltValueLabel.text = @"no set";
        B_pointValueView.slideValueLabel.text = @"no set";
    }
    if (self.setStartBtn.actionBtn.selected && self.setEndBtn.actionBtn.selected) {
        if (issingleormulti == 1) {
            CGFloat apan = (record_A_panAngle - 3600.0f) / 10.0f + 360.0f;
            CGFloat bpan = (record_B_panAngle - 3600.0f) / 10.0f + 360.0f;
            CGFloat atilt = (record_A_TiltAngle - 350.0f) / 10.0f + 35.0f;
            CGFloat btilt = (record_B_TiltAngle - 350.0f) / 10.0f + 35.0f;
            if (record_A_SliderPosition > record_B_SliderPosition) {
                CGFloat slidelength = record_A_SliderPosition - record_B_SliderPosition;
                Focus_XY_Value_Get(apan , bpan, slidelength);
                CGFloat realTilt =  Focus_Tilt_Position_Get(slidelength, Focus_H_Value_Get(atilt, btilt)) - 35.0f;
                A_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", realTilt];
                B_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_TiltAngle - 350.0f) / 10.0f];
            }else{
            CGFloat slidelength = record_B_SliderPosition - record_A_SliderPosition;
            Focus_XY_Value_Get(apan , bpan, slidelength);
            CGFloat realTilt =  Focus_Tilt_Position_Get(slidelength, Focus_H_Value_Get(atilt, btilt)) - 35.0f;
            B_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", realTilt];
            A_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_TiltAngle - 350.0f) / 10.0f];
            }
            if ((record_A_SliderPosition - record_B_SliderPosition) == 0) {
                B_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_TiltAngle - 350.0f) / 10.0f];
                B_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_panAngle - 3600.0f) / 10.0f];
                B_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_B_SliderPosition / 100.0f];
                A_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_panAngle - 3600.0f) / 10.0f];
                A_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_TiltAngle - 350.0f) / 10.0f];
                A_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_A_SliderPosition / 100.0f];
                return;
            }
            if (![self judgeAandB_Angle_LessThan180angle]) {
                B_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_TiltAngle - 350.0f) / 10.0f];
                B_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_panAngle - 3600.0f) / 10.0f];
                B_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_B_SliderPosition / 100.0f];
                A_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_panAngle - 3600.0f) / 10.0f];
                A_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_TiltAngle - 350.0f) / 10.0f];
                A_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_A_SliderPosition / 100.0f];
            }
        }else{
            A_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_TiltAngle - 350.0f) / 10.0f];
            B_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_TiltAngle - 350.0f) / 10.0f];
        }
        B_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_B_panAngle - 3600.0f) / 10.0f];
        B_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_B_SliderPosition / 100.0f];
        A_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (record_A_panAngle - 3600.0f) / 10.0f];
        A_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.1fmm", (float)record_A_SliderPosition / 100.0f];
    }

}

- (void)isLockAlluserInteractionEnabled{
    if (self.stopBtn.alpha == 1 && self.playBtn.alpha == 0) {
        
        self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
        self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
        smoothView.userInteractionEnabled = NO;
        self.single_MultiSegmentView.userInteractionEnabled = NO;
        
        self.setStartBtn.userInteractionEnabled = NO;
        self.setEndBtn.userInteractionEnabled = NO;
        
        [_RightanalogueStick dellocRcoker];
        [_LeftanalogueStick dellocRcoker];
        
    }else{
        
        self.leftPlayBtn.actionBtn.userInteractionEnabled = YES;
        self.rightPlayBtn.actionBtn.userInteractionEnabled = YES;
        smoothView.userInteractionEnabled = YES;
        self.single_MultiSegmentView.userInteractionEnabled = YES;

        self.setStartBtn.userInteractionEnabled = YES;
        self.setEndBtn.userInteractionEnabled = YES;
        [_RightanalogueStick reStartRocker];
        [_LeftanalogueStick reStartRocker];
    }
 
}
- (CGFloat)GetMinTime{

    [self initData];
    CGFloat RealTimes = self.ifmodel.fmtotalTime;
    //这一步计算出slider的最小时间
    while (![self countTargetVideoTime:RealTimes]) {
        RealTimes++;
    }
    //这一步计算出tilt轴的最小时间
    CGFloat atilt = (record_A_TiltAngle - 350.0f) / 10.0f + 35.0f;
    CGFloat btilt = (record_B_TiltAngle - 350.0f) / 10.0f + 35.0f;
    float tiltlength = fabs(atilt - btilt);
    float tilttime = Fcous_Tilt_MinTime(tiltlength);
    //二者时间比对取大值
    return RealTimes > tilttime?RealTimes : tilttime;
}



#pragma mark ------接收数据---------
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self forceOrientationLandscape];
    
    
    
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(receiveRealData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];
    
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    navi.preferredInterfaceOrientationForPresentation;
    
    navi.interfaceOrientation =   UIInterfaceOrientationLandscapeRight;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [self forceOrientationPortrait];
    [SVProgressHUD dismiss];
    
    receiveTimer.fireDate = [NSDate distantFuture];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    StopTimer.fireDate = [NSDate distantFuture];
    runTimer.fireDate = [NSDate distantFuture];
    LeftPointTimer.fireDate = [NSDate distantFuture];
    RightPointTimer.fireDate = [NSDate distantFuture];
    freeReturnZeroTimer.fireDate = [NSDate distantFuture];
    setAandBpointTimer.fireDate = [NSDate distantFuture];
    timeCorrectTimer.fireDate = [NSDate distantFuture];
    

    
    [receiveTimer invalidate];
    [returnZeroTimer invalidate];
    [StopTimer invalidate];
    [runTimer invalidate];
    [LeftPointTimer invalidate];
    [RightPointTimer invalidate];
    [freeReturnZeroTimer invalidate];
    [setAandBpointTimer invalidate];
    [timeCorrectTimer invalidate];
    
    
    freeReturnZeroTimer = nil;
    setAandBpointTimer = nil;
    timeCorrectTimer = nil;
    receiveTimer = nil;
    returnZeroTimer = nil;
    StopTimer = nil;
    runTimer  = nil;
    LeftPointTimer  = nil;
    RightPointTimer = nil;
    
    [self.LeftanalogueStick.timer invalidate];
    self.LeftanalogueStick.timer = nil;
    self.LeftanalogueStick.timer.fireDate = [NSDate distantFuture];
    [self.RightanalogueStick.timer invalidate];
    self.RightanalogueStick.timer = nil;
    self.RightanalogueStick.timer.fireDate = [NSDate distantFuture];
    
    
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    self.navigationController.navigationBarHidden = YES;
    
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


- (BOOL)judgeAandB_Angle_LessThan180angle{
    
    CGFloat apan = (record_A_panAngle - 3600.0f) / 10.0f;
    CGFloat bpan = (record_B_panAngle - 3600.0f) / 10.0f;
    CGFloat aslider = record_A_SliderPosition / 100.0f;
    CGFloat bslider = record_B_SliderPosition / 100.0f;
    CGFloat atilt = (record_A_TiltAngle - 350.0f) / 10.0f;
    CGFloat btilt = (record_B_TiltAngle - 350.0f) / 10.0f;
    
    CGFloat sliderlength = aslider - bslider;
    BOOL isA_left = aslider - bslider < 0 ? YES : NO;
    
    if (isA_left) {
        
        if (apan < 90 && bpan < apan && bpan > -90 && sliderlength != 0) {
            Focus_XY_Value_Get(apan , bpan, sliderlength);
            CGFloat realTilt =  Focus_Tilt_Position_Get(sliderlength, Focus_H_Value_Get(atilt, btilt)) - 35.0f;
            NSLog(@"left = %lf = %lf", atilt, realTilt);
            return YES;
        }
    }else{
        
        if (bpan < 90 && apan < bpan && apan > -90 && sliderlength != 0) {
            Focus_XY_Value_Get(apan , bpan, sliderlength);
            CGFloat realTilt =  Focus_Tilt_Position_Get(sliderlength, Focus_H_Value_Get(atilt, btilt)) - 35.0f;
            NSLog(@"right =%lf =%lf", btilt, realTilt);
            return YES;
        }
    }
    return NO;
}

@end
