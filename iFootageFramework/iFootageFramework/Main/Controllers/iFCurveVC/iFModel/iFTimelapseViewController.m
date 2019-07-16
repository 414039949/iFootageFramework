
//
//  iFTimelapseViewController.m
//  iFootage
//
//  Created by 黄品源 on 16/8/4.
//  Copyright © 2016年 iFootage. All rights reserved.
//
//2019年07月16日10:37:17

#import "iFTimelapseViewController.h"
#import "iFSettingViewController.h"
#import "iFNavgationController.h"
#import "iFBackImageView.h"
#import "iFShowValueView.h"
#import "iFNumberPickerView.h"
#import "iFFramePickerView.h"
#import "iFTimePickerView.h"
#import "iFgetAxisY.h"
#import "iFLoopView.h"
#import "iFStateView.h"
#import "iFGetDataTool.h"
#import "iFModel.h"
#import "iFBazierView.h"
#import "iFAlertController.h"
#import "LuaContext.h"

#import "iFS1A3_InsertView.h"

#import "AppDelegate.h"
#import "iFProcessView.h"

#import "SVProgressHUD.h"
#import "DXPopover.h"
#import "iFTimer.h"
#import "iF3DButton.h"
#import "iFHPYGetInfo.h"
#import "iFCenterInfoView.h"
#import "iFFunctionPicker.h"

#define MiniModel self.ifmodel


#define Point(x, y) [NSValue valueWithCGPoint:CGPointMake(x, y)]
//#define SendStr [self stringToHex:FrameLabel.text]


//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define IS_ON_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SlideTag 1111
#define PanTag 2222
#define TiltTag 3333

#define ExposureLabelTag 1212
#define BufferLabelTag 1213

#define ZOOMINTAG 10000
#define ZOOMOUTTAG 10001
#define ALPHA 0.6f

#define ProcessALPHA 1.0f

#define second 0.1f

#define FullRunningTime 9000.0f


@interface iFTimelapseViewController ()<setTimelapseModeSettingDelegate, previewMoveDelegate, changeValueDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, framePickDelegate, TimePickDelegate, TimeLapseTimePickDelegate, UITextFieldDelegate, processDelegate, GetFunctionIndexDelegate>
{
    iFBazierView    * SliderBazierView;
    iFBazierView    * PanBazierView;
    iFBazierView    * TiltBazierView;
    
    iFShowValueView * sliderValueView;
    iFShowValueView * panValueView;
    iFShowValueView * tiltValueView;
    
    iFCustomSlider  * SlideCustomSlider;
    iFCustomSlider  * PanCustomSlider;
    iFCustomSlider  * TiltCustomSlider;
    
    AppDelegate     * appDelegate;
    iFBackImageView * backView ;
    iFLoopView      * loopModeView;
    
    iFProcessView * processView;
    iFCenterInfoView * centerInfoView;//展示中间三条信息 interval 、final output 、 filming time
    iFS1A3_InsertView * intervalView;//间隔中间视图层

    UILabel * intervalLabel;
    UILabel * expoLabel;
    UILabel * bufferLabel;
    
    UILabel * frameLabel;
    UILabel * TimelapseTimeLabel;
    UILabel * timeLabel;
    
    NSInteger allFrames;
    
    int loopi;

    NSMutableArray * SlidenewFrameArray;
    NSMutableArray * PannewFrameArray;
    NSMutableArray * TiltnewFrameArray;
    
    NSMutableArray * SlidenewPostionArray;
    NSMutableArray * PannewPostionArray;
    NSMutableArray * TiltnewPostionArray;
    
    NSUInteger               Encode;//编码模式 ascii or  hex
    
    /*定时器*/
    NSTimer * receiveTimer;
    
    /*new timer*/
    
    NSTimer * slideSendPostionTimer;//发送slide位置信息定时器
    NSTimer * pansendPostionTimer;//发送pan位置信息定时器
    NSTimer * slideSendTimeTimer;//发送slide时间信息定时器
    NSTimer * pansendTimeTimer;//发送pan时间信息定时器
    NSTimer * tiltsendTimeTimer;//发送tilt时间信息定时器
    NSTimer * tiltsendPostionTimer;//发送tilt位置信息定时器
    NSTimer * timeCorrectTimer;// 校准开始时间定时器
    NSTimer * sendSettingsTimer;//发送配置参数的定时器
    NSTimer * clearSettingsTimer;
    NSTimer * sendStopMotionTimer;//发送StopMotion的参数定时器
    NSTimer * returnZeroTimer;
    NSTimer * pauseTimer;
    NSTimer * showprocessTimer;//监测运行状态的定时器
    
    UIView * partView;
    NSInteger temp;
    
    
    UInt64 startTime;//开始时间（64位）
    UInt32 starttime2;//开始时间（32位）
    
    
    
    
    CGFloat moveX;
    
    CGFloat Xlenth;
    CGFloat Ylenth;
    
    
    CGFloat leftLimit;//左边限制位置
    CGFloat rightLimit;//右边限制位置
    CGFloat topLimit;//上边限制位置
    CGFloat downLimit;//下边限制位置
    
    NSUserDefaults * ud;
    
    BOOL isPauseOn; //是否按下暂停键
    BOOL isStopOn;
    BOOL isPlayOn;
    BOOL isStopMotionOn;
    BOOL isMoveInsertView;
    BOOL isTouchReturnBack;
    BOOL isTouchPreview;
    BOOL isHadSendSlideInfo;
    
    NSInteger preViewSecond;
    
    NSMutableArray * dataArray;
    
    UILabel * xFrameLabel;
    UILabel * yDistanceLabel;
    
    UInt8 isloop;

    CGFloat runningTime;
    UInt16 finalRunningTime;
    
    UInt64 pauseTime;
    UInt64 restartTime;
    UInt64 pasueTotaltime;
}
@property(nonatomic, strong)iFStateView * ArraystateView;
@property(nonatomic, strong)iFStateView * SetStateView;
@property(nonatomic, strong)iFStateView * X2SArrayStateView;
@property(nonatomic, strong)iFStateView * X2SetStateView;
@property(nonatomic, strong)iFStateView * getreadyView;
@property(nonatomic, strong)iFStateView * x2getreadyView;
@property(nonatomic, strong)iFButton * isloopBtn;
@property (nonatomic, strong) DXPopover *popover;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * configs;
@property (nonatomic, strong) NSMutableArray * timeArr;
@property (nonatomic, strong) iFNumberPickerView * framePicker;
@property (nonatomic, strong) iFModel * ifmodel;


@end

@implementation iFTimelapseViewController



@synthesize backBtn, SliderBtn, PanBtn, TiltBtn, insertView, insertIndex, XValue, KeyBtn, PauseBtn, PlayBtn, FrameLabel, fpsLabel, MODEL, InsertViewTimer, timerLabel, functionMode,shootingMode, isNewBezier, isSettingClear, checkTime, SlideBezierCount, totalFrames, exposure, interval, actualInterval, PanBezierCount, TiltBezierCount, SlideYValueArray, SlideTimeValueArray, PanYValueArray, PanTimeValueArray, TiltYValueArray, TiltTimeValueArray, settingBtn, returnBtn;




- (void)viewDidLoad {
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewDidLoad];
    self.rootbackBtn.alpha = 1;
    self.connectBtn.alpha = 0;
    isHadSendSlideInfo = NO;
    
    temp = 0;
    isPauseOn = NO;
    isMoveInsertView = NO;
    
    [self initData];
    [[LuaContext currentContext] loadScript:@"hpy.lua"];

    
    appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    _receiveView    = [ReceiveView sharedInstance];
    _sendDataView   = [SendDataView new];
    
    SlideTimeValueArray     = [NSMutableArray new];
    SlideYValueArray        = [NSMutableArray new];
    PanTimeValueArray       = [NSMutableArray new];
    PanYValueArray          = [NSMutableArray new];
    TiltTimeValueArray      = [NSMutableArray new];
    TiltYValueArray         = [NSMutableArray new];
    SlidenewFrameArray      = [NSMutableArray new];
    PannewFrameArray        = [NSMutableArray new];
    TiltnewFrameArray       = [NSMutableArray new];
    SlidenewPostionArray    = [NSMutableArray new];
    PannewPostionArray      = [NSMutableArray new];
    TiltnewPostionArray     = [NSMutableArray new];

    self.YValueArray    = [NSMutableArray new];
    self.TimeValueArray = [NSMutableArray new];
    
    /*
     0: 24
     1: 25
     2: 30 
     3: 50
     4: 60
     */
    insertIndex = 1;
//    [self createAllUI];
    MODEL = MODEL_SLIDER;

    [self createSlide_Pan_TiltBezierView];
    [self createAll3DButtonAndCenterInfoView];
    [self createAllPickerView];
    

    
    /**
     *  开启接收数据的定时器
     *
     *  @param receiveRealData receiveRealData description
     *
     *  @return return value description
     */
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(receiveRealData) userInfo:nil repeats:YES];
//    receiveTimer.fireDate = [NSDate distantPast];
    
    slideSendPostionTimer  = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendSlidetimer:) userInfo:nil repeats:YES];
    slideSendPostionTimer.fireDate = [NSDate distantFuture];
    
    slideSendTimeTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendSlideTimeTimer:) userInfo:nil repeats:YES];
    slideSendTimeTimer.fireDate = [NSDate distantFuture];
    
    pansendPostionTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(SendpanTimer:) userInfo:nil repeats:YES];
    pansendPostionTimer.fireDate = [NSDate distantFuture];
    
    pansendTimeTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendpanTimeTimer:) userInfo:nil repeats:YES];
    pansendTimeTimer.fireDate = [NSDate distantFuture];
    
    tiltsendPostionTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendtiltPostionTimer:) userInfo:nil repeats:YES];
    tiltsendPostionTimer.fireDate = [NSDate distantFuture];
    
    tiltsendTimeTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendtiltTimeTimer:) userInfo:nil repeats:YES];
    tiltsendTimeTimer.fireDate = [NSDate distantFuture];
    
    timeCorrectTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendtimecorrectTimer:) userInfo:nil repeats:YES];
    timeCorrectTimer.fireDate = [NSDate distantFuture];
    
    clearSettingsTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendClearOrder) userInfo:nil repeats:YES];
    clearSettingsTimer.fireDate = [NSDate distantFuture];
    
    sendSettingsTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendSettingParams:) userInfo:nil repeats:YES];
    sendSettingsTimer.fireDate = [NSDate distantFuture];
    
    sendStopMotionTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(sendStopMotionStartOrPauseOrAction:) userInfo:nil repeats:YES];
    sendStopMotionTimer.fireDate = [NSDate distantFuture];
    
    returnZeroTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(backToTheBeginning:) userInfo:nil repeats:YES];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    
    showprocessTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(showProcessStatusWithprocessTimer:) userInfo:nil repeats:YES];
    showprocessTimer.fireDate = [NSDate distantFuture];
    
    pauseTimer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(PauseAction:) userInfo:nil repeats:YES];
    pauseTimer.fireDate = [NSDate distantFuture];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(judgeWhetherHaveThread) userInfo:nil repeats:NO];
    
    [[NSRunLoop mainRunLoop] addTimer:receiveTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:slideSendTimeTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:slideSendPostionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:pansendPostionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:pansendTimeTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:tiltsendPostionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:tiltsendTimeTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:timeCorrectTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:clearSettingsTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:sendSettingsTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:sendStopMotionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:returnZeroTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:showprocessTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:pauseTimer forMode:NSRunLoopCommonModes];
    
    
    
}
#pragma mark -----创建Slide、Pan、Tilt曲线视图-------
- (void)createSlide_Pan_TiltBezierView{
    
    backView = [[iFBackImageView alloc]initWithFrame:CGRectMake(leftLimit, topLimit, rightLimit, downLimit - topLimit)];
    [backView createUIWithFrames:100 orWithTimes:0];
    [self.view addSubview:backView];
    
    SliderBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit, topLimit ,rightLimit, downLimit - topLimit)andColor:COLOR(255, 0, 255, 1) array:self.ifmodel.sliderArray WithControl:self.ifmodel.slideControlArray];
    
    SliderBazierView.delegate = self;
    SliderBazierView.tag = 1;
    PanBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit,topLimit ,rightLimit, downLimit - topLimit)andColor: COLOR(0, 255, 255, 1) array:self.ifmodel.panArray WithControl:self.ifmodel.panControlArray];
    PanBazierView.delegate = self;
    PanBazierView.tag = 2;
    TiltBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit,topLimit ,rightLimit, downLimit - topLimit) andColor:COLOR(255, 255, 0, 1) array:self.ifmodel.tiltArray WithControl:self.ifmodel.tiltControlArray];
    TiltBazierView.delegate = self;
    TiltBazierView.tag = 3;
    [self.view addSubview:TiltBazierView];
    [self.view addSubview:PanBazierView];
    [self.view addSubview:SliderBazierView];
    
    int a = SlideConunt(self.ifmodel.slideCount);
    SlideCustomSlider  = [[iFCustomSlider alloc]initWithFrame
                          :CGRectMake(0, 0, AutoKScreenHeight * 0.05, downLimit - topLimit)
                          :COLOR(255, 0, 255, 1)
                          :a];
    SlideCustomSlider.alpha = 1;
    SlideCustomSlider.changeDelegate = self;
    [self.view addSubview:SlideCustomSlider];
    PanCustomSlider  = [[iFCustomSlider alloc]initWithFrame
                        :CGRectMake(0, 0, AutoKScreenHeight * 0.05, downLimit - topLimit)
                        :COLOR(0, 255, 255, 1)
                        :PanMaxValue * 2];
    PanCustomSlider.alpha = 0;
    PanCustomSlider.changeDelegate = self;
    [self.view addSubview:PanCustomSlider];
    TiltCustomSlider  = [[iFCustomSlider alloc]initWithFrame
                         :CGRectMake(0, 0, a * 0.05, downLimit - topLimit)
                         :COLOR(255, 255, 0, 1)
                         :TiltMaxValue * 2];
    TiltCustomSlider.changeDelegate = self;
    TiltCustomSlider.alpha = 0;
    [self.view addSubview:TiltCustomSlider];
    
    [SlideCustomSlider changeWithAllValue:MiniModel.upSliderValue - MiniModel.downSliderValue andUpValue:MiniModel.upSliderValue andDownValue:MiniModel.downSliderValue WithModel:MODEL_SLIDER];
    [PanCustomSlider changeWithAllValue:(PanMaxValue * 2) andUpValue:MiniModel.upPanValue andDownValue:MiniModel.downPanValue WithModel:MODEL_PAN];
    [TiltCustomSlider changeWithAllValue:TiltMaxValue * 2 andUpValue:MiniModel.upTiltValue andDownValue:MiniModel.downTiltValue WithModel:MODEL_TILT];
    
    [SliderBazierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLimit);
        make.top.mas_equalTo(topLimit);
        make.size.mas_equalTo(CGSizeMake(rightLimit, downLimit - topLimit));
    }];
    [SlideCustomSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SliderBazierView.mas_right).offset(10);
        make.centerY.equalTo(SliderBazierView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.05, downLimit - topLimit));
    }];
    [PanCustomSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SliderBazierView.mas_right).offset(10);
        make.centerY.equalTo(SlideCustomSlider.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.05, downLimit - topLimit));
    }];
    [TiltCustomSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SliderBazierView.mas_right).offset(10);
        make.centerY.equalTo(SlideCustomSlider.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.05, downLimit - topLimit));
    }];
}

#pragma mark ---- 创建所有的按钮 -------
- (void)createAll3DButtonAndCenterInfoView{
    CGFloat BtnWidth;
    CGFloat interValDistance;
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        BtnWidth = AutoKscreenWidth * 0.12;
        interValDistance = 5;
    }else if (kDevice_Is_iPad){
        BtnWidth = AutoKscreenWidth * 0.10;
        interValDistance = 5;
        
    }else{
        BtnWidth = AutoKscreenWidth * 0.13;
        interValDistance = 5;
    }
    self.returnBtn= [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0,BtnWidth, BtnWidth) WithTitle:nil selectedIMG:@"target_leftplay@3x.png" normalIMG:@"target_leftplay@3x.png"];
    self.SliderBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:Timeline_S_SELECTED normalIMG:Timeline_S_unSELECTED];
    self.PanBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:Timeline_P_SELECTED normalIMG:Timeline_P_unSELECTED];
    self.TiltBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:Timeline_T_SELECTED normalIMG:Timeline_T_unSELECTED];
    self.KeyBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:Timeline_KEYBTN normalIMG:Timeline_KEYBTN];
    self.preViewBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:Timeline_PREVIEWBTN normalIMG:Timeline_PREVIEWBTN];
    self.StopMotionBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:@"all_addIMG" normalIMG:@"all_addIMG"];
    self.PlayBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PALYBTNIMG];
    self.PlayBtn.actionBtn.selected = YES;
    self.PauseBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:all_PAUSEBTNIMG normalIMG:all_PAUSEBTNIMG];
    self.StopBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    self.SaveBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, BtnWidth, BtnWidth) WithTitle:nil selectedIMG:Timeline_SAVEBTN normalIMG:Timeline_SAVEBTN];
    if (kDevice_Is_iPad) {
        centerInfoView = [[iFCenterInfoView alloc]initWithFrame:CGRectMake(0, 0, BtnWidth * 3, BtnWidth * 0.75)];
    }else{
        centerInfoView = [[iFCenterInfoView alloc]initWithFrame:CGRectMake(0, 0, BtnWidth * 3, BtnWidth)];
    }
    self.SliderBtn.actionBtn.tag = SlideTag;
    self.PanBtn.actionBtn.tag = PanTag;
    self.TiltBtn.actionBtn.tag = TiltTag;
    [self chooseCurve:self.SliderBtn.actionBtn];//初始化Slide界面
    
    [self.SliderBtn.actionBtn addTarget:self action:@selector(chooseCurve:) forControlEvents:UIControlEventTouchUpInside];
    [self.PlayBtn.actionBtn addTarget:self action:@selector(StartMoveWithInsertView) forControlEvents:UIControlEventTouchUpInside];
    [self.PanBtn.actionBtn addTarget:self action:@selector(chooseCurve:) forControlEvents:UIControlEventTouchUpInside];
    [self.TiltBtn.actionBtn addTarget:self action:@selector(chooseCurve:) forControlEvents:UIControlEventTouchUpInside];
    [self.KeyBtn.actionBtn addTarget:self action:@selector(insertValue) forControlEvents:UIControlEventTouchUpInside];
    [self.StopBtn.actionBtn addTarget:self action:@selector(PauseMoveWithInsertView) forControlEvents:UIControlEventTouchUpInside];
    [self.SaveBtn.actionBtn addTarget:self action:@selector(saveDataAndBack) forControlEvents:UIControlEventTouchUpInside];
    [self.StopMotionBtn.actionBtn addTarget:self action:@selector(stopMotionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.returnBtn.actionBtn addTarget:self action:@selector(returnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.preViewBtn.actionBtn addTarget:self action:@selector(preViewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:centerInfoView];
    [self.view addSubview:self.returnBtn];
    [self.view addSubview:self.SliderBtn];
    [self.view addSubview:self.PanBtn];
    [self.view addSubview:self.TiltBtn];
    [self.view addSubview:self.KeyBtn];
    //    [self.view addSubview:self.PauseBtn];
    [self.view addSubview:self.preViewBtn];
    [self.view addSubview:self.StopMotionBtn];
    [self.view addSubview:self.StopBtn];
    [self.view addSubview:self.SaveBtn];
    [self.view addSubview:self.PlayBtn];
    
    //
    //    insertBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rightLimit, AutoKScreenHeight * 0.05 - 20)];
    //    insertBackView.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:insertBackView];
    
    //    insertslider = [[iFSliderView alloc]initWithFrame:CGRectMake(0, 0, rightLimit, insertBackView.frame.size.height)];
    //    insertslider.delegate = self;
    //    [insertBackView addSubview:insertslider];
    
    //    [insertBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(SliderBazierView.mas_left);
    //        make.top.equalTo(SliderBazierView.mas_bottom);
    //        make.size.mas_equalTo(CGSizeMake(rightLimit, 10));
    //    }];
    [self.returnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SliderBazierView.mas_left).offset(interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    [self.SliderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.returnBtn.mas_right).offset(interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    [self.PanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.SliderBtn.mas_right).offset(interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    [self.TiltBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PanBtn.mas_right).offset(interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    [self.SaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(SliderBazierView.mas_right).offset(-interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    //stop and pause = play;
    [self.PlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.SaveBtn.mas_left).offset(-interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    
    [self.StopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.SaveBtn.mas_left).offset(-interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    
    [self.StopMotionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.SaveBtn.mas_left).offset(-interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    
    [self.preViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.PlayBtn.mas_left).offset(-interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    [self.KeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.preViewBtn.mas_left).offset(-interValDistance);
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.size.mas_equalTo(BtnWidth);
    }];
    [centerInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SliderBazierView.mas_bottom).offset(interValDistance);
        make.centerX.equalTo(SliderBazierView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(BtnWidth * 3, BtnWidth));
    }];
    
#warning 2017年03月08日14:18:24 更改新的显示UI processView
    processView = [[iFProcessView alloc]initWithFrame:CGRectMake(0, 0, AutoKScreenHeight, AutoKscreenWidth) WithMode:loopModeView.MODEL];
    
    processView.layer.borderWidth = iFSize(2);
    processView.layer.cornerRadius = iFSize(10);
    processView.alpha = 0.0f;
    processView.delegate = self;
    
    processView.backgroundColor = [UIColor clearColor];
    processView.center = CGPointMake(AutoKScreenHeight / 2, AutoKscreenWidth / 2);
    
    [processView showWithMode:loopModeView.MODEL andTitle:nil];
    [self.view addSubview:processView];
    [self.view bringSubviewToFront:processView];
}
- (void)createAllPickerView{
    CGFloat BtnWidth;
    CGFloat interValDistance;
    CGFloat headDistance;
    
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        BtnWidth = AutoKscreenWidth * 0.07;
        interValDistance = 5;
        headDistance = 20;
        
        
    }else if (kDevice_Is_iPad){
        BtnWidth = AutoKscreenWidth * 0.05;
        interValDistance = 5;
        headDistance = 60;
        
        
    }else{
        BtnWidth = AutoKscreenWidth * 0.07;
        interValDistance = 5;
        headDistance = 60;
        
    }
    UITapGestureRecognizer * loopGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFunctionMode:)];
    UITapGestureRecognizer * ExpoGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIntervalValue:)];
    UITapGestureRecognizer * BufferGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIntervalValue:)];
    UITapGestureRecognizer * TimelapseFrameGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFrameValue:)];
    UITapGestureRecognizer * TimelapseTimeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimelapseTimeValue:)];
    UITapGestureRecognizer * VideoTimeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimeValue:)];
    UITapGestureRecognizer * fpsGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fpschooseValue:)];
    
    loopModeView = [[iFLoopView alloc]initWithFrame:CGRectMake(0, 0, iFSize(100), BtnWidth)];
    [loopModeView addGestureRecognizer:loopGesture];
    [loopModeView loopChangeTitle:self.ifmodel.FunctionMode];
    [self.view addSubview:loopModeView];
    expoLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.11, BtnWidth) andTitle:[NSString stringWithFormat:@"Expo:%.2lds", MiniModel.exposureSecond]];
    [expoLabel addGestureRecognizer:ExpoGesture];
    expoLabel.tag = ExposureLabelTag;
    [self.view addSubview:expoLabel];
    bufferLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.12, BtnWidth) andTitle:[NSString stringWithFormat:@"Buffer:%.2lds", MiniModel.bufferSecond]];
    bufferLabel.tag = BufferLabelTag;
    [bufferLabel addGestureRecognizer:BufferGesture];
    
    [self.view addSubview:bufferLabel];
    
    frameLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.19, BtnWidth) andTitle:[NSString stringWithFormat:@"Frame:%ld",MiniModel.totalFrames]];
    [frameLabel addGestureRecognizer:TimelapseFrameGesture];
    
    [self.view addSubview:frameLabel];
    
    TimelapseTimeLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.19, BtnWidth) andTitle:[NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimelapseTimeWith:MiniModel.TimelapseTotalTimes andFPS:[self.configs[MiniModel.fpsIndex] integerValue]]]];
    [TimelapseTimeLabel addGestureRecognizer:TimelapseTimeGesture];
    
    
    
    if (MiniModel.displayUnit == 0) {
        frameLabel.alpha = 1;
        TimelapseTimeLabel.alpha = 0;
        
    }else{
        frameLabel.alpha = 0;
        TimelapseTimeLabel.alpha = 1;
    }
    
    [self.view addSubview:TimelapseTimeLabel];
    timeLabel  = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.19, BtnWidth) andTitle:[NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimeWith:MiniModel.totalTimes]]];
    timeLabel.alpha = 0;
    [timeLabel addGestureRecognizer:VideoTimeGesture];
    
    [self.view addSubview:timeLabel];
    
    fpsLabel = [self getLabelWithFrame:CGRectMake(0, 0, iFSize(45), BtnWidth) andTitle:[NSString stringWithFormat:@"%@", self.configs[MiniModel.fpsIndex]]];
    [fpsLabel addGestureRecognizer:fpsGesture];
    
    [self.view addSubview:fpsLabel];
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(0, 0, iFSize(100), 200);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.tableView = blueView;
    
    UIView * xyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.08, AutoKscreenWidth * 0.08)];
    xyView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:xyView];
    
    xFrameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, xyView.frame.size.width, xyView.frame.size.height * 0.5)];
    xFrameLabel.backgroundColor = [UIColor clearColor];
    xFrameLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:xyView.frame.size.height * 0.5];
    [xyView addSubview:xFrameLabel];
    
    yDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, xyView.frame.size.height * 0.5, xyView.frame.size.width, xyView.frame.size.height * 0.5)];
    yDistanceLabel.backgroundColor = [UIColor clearColor];
    yDistanceLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:xyView.frame.size.height * 0.5];
    [xyView addSubview:yDistanceLabel];
    
    [self loopAction:self.ifmodel.FunctionMode];

    [loopModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(SliderBazierView.mas_left).offset(headDistance);
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.15, BtnWidth));
    }];
    [expoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loopModeView.mas_right).offset(interValDistance);
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.11, BtnWidth));
    }];
    [bufferLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(expoLabel.mas_right).offset(interValDistance);
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.12, BtnWidth));
    }];
    [frameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bufferLabel.mas_right).offset(interValDistance);
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.19, BtnWidth));
    }];
    [TimelapseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bufferLabel.mas_right).offset(interValDistance);
        
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.19, BtnWidth));
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bufferLabel.mas_right).offset(interValDistance);
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.19, BtnWidth));
    }];
    [fpsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(TimelapseTimeLabel.mas_right).offset(interValDistance);
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.10, BtnWidth));
    }];
    
    [xyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fpsLabel.mas_right).offset(interValDistance);
        make.bottom.equalTo(SliderBazierView.mas_top).offset(-10);
        make.size.mas_equalTo(CGSizeMake(AutoKScreenHeight * 0.07, AutoKscreenWidth * 0.08));
    }];
}

#pragma mark ---sliderDelegate选择插入视图 --------
- (void)getSlideValueAction:(CGFloat)Value{
    
    NSLog(@"%lf", intervalView.frame.size.width * Value );
    XValue = intervalView.frame.size.width * Value;
    [intervalView changeMarkShaftXvalue:Value];
    [self judgeInsertIndex:intervalView.frame.size.width * Value];
    NSLog(@"%ld", insertIndex);
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint Point = [[touches anyObject] locationInView:SliderBazierView];

    if (isPlayOn == YES) {
        return;
        
    }
    if ([SliderBazierView.layer containsPoint:Point]){
        CGPoint location = [[touches anyObject] locationInView:self.view];

#warning rightLimit - leftLimit 代替 rightLimit
        if (MODEL == MODEL_SLIDER) {
            if ([self judgeIsContainPoint:SliderBazierView.PointArray WithPoint:Point] && [self judgeIsContainPoint:[self getNewControlArrayCellsWithControlArray:SliderBazierView.ControlPointArray] WithPoint:Point]) {
                CGFloat Value = (location.x - leftLimit) / (rightLimit);
                XValue = intervalView.frame.size.width * Value;
                [intervalView changeMarkShaftXvalue:Value];
                [self judgeInsertIndex:intervalView.frame.size.width * Value];
                intervalView.valueLabel.alpha = 1;
                
            }
        }else if(MODEL == MODEL_PAN){
            if ([self judgeIsContainPoint:PanBazierView.PointArray WithPoint:Point] && [self judgeIsContainPoint:[self getNewControlArrayCellsWithControlArray:PanBazierView.ControlPointArray] WithPoint:Point]) {
                CGFloat Value = (location.x - leftLimit) / (rightLimit);
                XValue = intervalView.frame.size.width * Value;
                [intervalView changeMarkShaftXvalue:Value];
                [self judgeInsertIndex:intervalView.frame.size.width * Value];
                intervalView.valueLabel.alpha = 1;

            }
        }else{
            
            if ([self judgeIsContainPoint:TiltBazierView.PointArray WithPoint:Point] && [self judgeIsContainPoint:[self getNewControlArrayCellsWithControlArray:TiltBazierView.ControlPointArray] WithPoint:Point]) {
                CGFloat Value = (location.x - leftLimit) / (rightLimit);
                XValue = intervalView.frame.size.width * Value;
                [intervalView changeMarkShaftXvalue:Value];
                [self judgeInsertIndex:intervalView.frame.size.width * Value];
                intervalView.valueLabel.alpha = 1;

            }
        }
    }
    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = self.ifmodel.totalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)self.ifmodel.totalFrames;
    }else{
        NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
        if (self.ifmodel.displayUnit == 1) {
            TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)self.ifmodel.totalFrames;
        }
    }
    intervalView.valueLabel.text = [NSString stringWithFormat:@"%.0f", (XValue) / SliderBazierView.frame.size.width * TotalFrames];
}
- (NSMutableArray *)getNewControlArrayCellsWithControlArray:(NSArray * )ControlArray{
    NSMutableArray * Carray = [NSMutableArray new];
    for (NSArray * valueArray in ControlArray) {
        for (NSValue * value in valueArray) {
            [Carray addObject:value];
        }
    }
    return Carray;
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint Point = [[touches anyObject] locationInView:SliderBazierView];

    if ([SliderBazierView.layer containsPoint:Point]){
        [self moveInsertViewRealTimepreViewWithPointX:XValue];
        intervalView.valueLabel.alpha = 0;
    }
}
- (BOOL)judgeIsContainPoint:(NSArray *)PointArray WithPoint:(CGPoint)point{
    
    BOOL isContains = YES;
    for (NSValue * value in PointArray) {
        CGPoint valuePoint = [value CGPointValue];
        CGRect PointRect = CGRectMake(valuePoint.x - 40, valuePoint.y - 40, 80, 80);
//        NSLog(@"CGRectContainsPoint %d", CGRectContainsPoint(PointRect, point));
        if (CGRectContainsPoint(PointRect, point)) {
            return NO;
        }
    }
    
    return isContains;
}

- (void)judgeWhetherHaveThread{
    
    
    if (_receiveView.slideIsloop == 0x01 || _receiveView.x2Isloop == 0x01) {
        
        isloop = 0x01;
        self.isloopBtn.selected = YES;
        processView.isloopBtn.selected = YES;
        showprocessTimer.fireDate = [NSDate distantPast];

        }else{
               isloop = 0x00;
               self.isloopBtn.selected = NO;
               processView.isloopBtn.selected = NO;
               
               
               if (_receiveView.slideModeID == 0x02 || _receiveView.x2ModeID == 0x02 || _receiveView.slideStopMotionMode == 0x02 || _receiveView.x2StopMotionTimeMode == 0x02) {
                   
                   showprocessTimer.fireDate = [NSDate distantPast];
               }else{
                   showprocessTimer.fireDate = [NSDate distantFuture];
               }

           }
}

#pragma mark -----初始化一切改初始化的东西-------
- (id)init{
    
    Xlenth = AutoKScreenHeight;
    Ylenth = AutoKscreenWidth;
    /*fps 配置数组*/
    self.configs = [NSMutableArray arrayWithArray:@[@"24fps", @"25fps", @"30fps", @"50fps", @"60fps"]];
    self.timeArr = [NSMutableArray new];
    for (int i=0; i<=60; i++) {
        
        [self.timeArr addObject:[[NSNumber alloc] initWithInt:i]];
    }
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        leftLimit = AutoKScreenHeight * 0.1;
        rightLimit = AutoKScreenHeight * 0.8;
        topLimit = AutoKscreenWidth * 0.15;
        downLimit = AutoKscreenWidth * 0.85;
    }else if([[UIDevice currentDevice].model isEqualToString:@"iPad"]){
        leftLimit = AutoKScreenHeight * 0.05;
        rightLimit = AutoKScreenHeight * 0.85;
        topLimit = AutoKscreenWidth * 0.15;
        downLimit = AutoKscreenWidth * 0.70;
    }else{
        leftLimit = AutoKScreenHeight * 0.02;
        rightLimit = AutoKScreenHeight * 0.92;
        topLimit = AutoKscreenWidth * 0.15;
        downLimit = AutoKscreenWidth * 0.85;
    }
    
    return self;
}
#pragma - initData 初始化数据---
- (void)initData{
    
    
    ud = [NSUserDefaults standardUserDefaults];

    self.ifmodel = [[iFModel alloc]init];
    if (_isSaveData) {
        
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        //    取得第一个Documents文件夹的路径
            NSString *filePath = [path objectAtIndex:0];
            NSString *plistPath = [filePath stringByAppendingPathComponent:ProperKeyFrameList];
            NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
        
            dataArray = [NSMutableArray arrayWithArray:array];
            NSDictionary * dict = dataArray[_indexRow];
            self.ifmodel.slideCount = [[ud objectForKey:SLIDECOUNT] integerValue];
        
            self.ifmodel.totalFrames = [dict[@"totalFrames"] integerValue];
            self.ifmodel.fpsIndex = [dict[@"fpsIndex"] integerValue];
            self.ifmodel.intervalTimeIndex = [dict[@"intervalTimeIndex"] integerValue];
            self.ifmodel.upSliderValue = [dict[@"upSliderValue"] floatValue];
            if (self.ifmodel.upSliderValue >= SlideConunt(self.ifmodel.slideCount)) {
                if (self.ifmodel.slideCount <= 1) {
                    self.ifmodel.upSliderValue = SlideConunt(1);
                }else{
                    self.ifmodel.upSliderValue = SlideConunt(self.ifmodel.slideCount);
                }
            }
            self.ifmodel.downSliderValue = [dict[@"downSliderValue" ] floatValue];
            self.ifmodel.upPanValue = [dict[@"upPanValue"] floatValue];
            self.ifmodel.downPanValue = [dict[@"downPanValue"] floatValue];
            self.ifmodel.upTiltValue = [dict[@"upTiltValue"] floatValue];
            self.ifmodel.downTiltValue = [dict[@"downTiltValue"] floatValue];
            self.ifmodel.shootMode = [[ud objectForKey:SHOOTINGMODE] integerValue];
//            self.ifmodel.displayUnit = [dict[@"displayUnit"] integerValue];
            self.ifmodel.displayUnit = [[ud objectForKey:DISPLAYUNIT] integerValue];
        
            self.ifmodel.totalTimes = [dict[@"totalTimes"] floatValue];
        
            self.ifmodel.TimelapseTotalTimes = [dict[@"TimelapseTotalTimes"] floatValue];
            self.ifmodel.FunctionMode = [dict[@"FunctionMode"] integerValue];
//            self.ifmodel.slideCount = [dict[@"slideCount"] integerValue];
            self.ifmodel.exposureSecond = [dict[@"exposureSecond"] integerValue];
            self.ifmodel.bufferSecond = [dict[@"bufferSecond"] integerValue];
            self.ifmodel.sliderArray = [self getValueArrayWithStringArray:dict[@"sliderArray"]];
            self.ifmodel.slideControlArray = [self getValueControlArrayWithStringControlArray:dict[@"slideControlArray"]];
            self.ifmodel.panArray = [self getValueArrayWithStringArray:dict[@"panArray"]];
            self.ifmodel.panControlArray = [self getValueControlArrayWithStringControlArray:dict[@"panControlArray"]];
            self.ifmodel.tiltArray = [self getValueArrayWithStringArray:dict[@"tiltArray"]];
            self.ifmodel.tiltControlArray = [self getValueControlArrayWithStringControlArray:dict[@"tiltControlArray"]];
        
        [ud setObject:dict[@"totalFrames"] forKey:TOTALFRAMES];
        [ud setObject:dict[@"fpsIndex"] forKey:FPSValue];
        [ud setObject:dict[@"intervalTimeIndex"] forKey:INTERVALIndex];
        [ud setObject:dict[@"upSliderValue"] forKey:UpSlideViewValue];
        [ud setObject:dict[@"downSliderValue" ] forKey:DownSlideViewValue];
        [ud setObject:dict[@"upPanValue"] forKey:UpPanViewValue];
        [ud setObject:dict[@"downPanValue"] forKey:DownPanViewValue];
        [ud setObject:dict[@"upTiltValue"] forKey:UpTiltViewValue];
        [ud setObject:dict[@"downTiltValue"] forKey:DownTiltViewValue];
//        [ud setObject:dict[@"shootMode"] forKey:SHOOTINGMODE];
//        [ud setObject:dict[@"displayUnit"] forKey:DISPLAYUNIT];
        [ud setObject:dict[@"totalTimes"] forKey:TOTALTIMES];
        [ud setObject:dict[@"TimelapseTotalTimes"]  forKey:TIMELAPSETIME];
        [ud setObject:dict[@"FunctionMode"] forKey:FUNCTIONMODE];
        [ud setObject:dict[@"exposureSecond"] forKey:EXPOSURE];
        [ud setObject:dict[@"bufferSecond"] forKey:BUFFERSECOND];
        
//        [ud setObject:dict[@"slideCount"] forKey:SLIDECOUNT];
        
        if (self.ifmodel.displayUnit == 0) {
            self.ifmodel.TimelapseTotalTimes = (CGFloat)self.ifmodel.totalFrames / [self.configs[self.ifmodel.fpsIndex] integerValue];
        }else if (self.ifmodel.displayUnit == 1){
            
            self.ifmodel.TimelapseTotalTimes = (CGFloat)self.ifmodel.totalFrames / [self.configs[self.ifmodel.fpsIndex] integerValue];
        }
        
    }else{
        
//        NSLog(@"NO=============================%d %ld", _isSaveData ,_indexRow );
            self.ifmodel.totalFrames         = [[ud objectForKey:TOTALFRAMES] integerValue];
            self.ifmodel.fpsIndex            = [[ud objectForKey:FPSValue] integerValue];
            self.ifmodel.intervalTimeIndex   = [[ud objectForKey:INTERVALIndex] integerValue];
            self.ifmodel.upSliderValue       = [[ud objectForKey:UpSlideViewValue] floatValue];
            self.ifmodel.downSliderValue     = [[ud objectForKey:DownSlideViewValue] floatValue];
            self.ifmodel.upPanValue          = [[ud objectForKey:UpPanViewValue] floatValue];
            self.ifmodel.downPanValue        = [[ud objectForKey:DownPanViewValue] floatValue];
            self.ifmodel.upTiltValue         = [[ud objectForKey:UpTiltViewValue] floatValue];
            self.ifmodel.downTiltValue       = [[ud objectForKey:DownTiltViewValue] floatValue];
            self.ifmodel.shootMode           = [[ud objectForKey:SHOOTINGMODE] integerValue];
            self.ifmodel.displayUnit         = [[ud objectForKey:DISPLAYUNIT] integerValue];
            self.ifmodel.totalTimes          = [[ud objectForKey:TOTALTIMES] floatValue];
        
            self.ifmodel.TimelapseTotalTimes = [[ud objectForKey:TIMELAPSETIME] floatValue];
            self.ifmodel.FunctionMode        = [[ud objectForKey:FUNCTIONMODE] integerValue];
            self.ifmodel.slideCount          = [[ud objectForKey:SLIDECOUNT] integerValue];
            self.ifmodel.exposureSecond = [[ud objectForKey:EXPOSURE] integerValue];
            self.ifmodel.bufferSecond = [[ud objectForKey:BUFFERSECOND] integerValue];
        
        
        
            NSData * slidedata              = [ud objectForKey:ArraySLIDE];
            NSData * pandata                = [ud objectForKey:ArrayPan];
            NSData * tlitdata               = [ud objectForKey:ArrayTilt];
        
            self.ifmodel.sliderArray        = [NSKeyedUnarchiver unarchiveObjectWithData:slidedata];
            self.ifmodel.panArray           = [NSKeyedUnarchiver unarchiveObjectWithData:pandata];
            self.ifmodel.tiltArray          = [NSKeyedUnarchiver unarchiveObjectWithData:tlitdata];
        
        
            self.ifmodel.slideControlArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:ControlArraySLIDE]];
            self.ifmodel.panControlArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:ControlArrayPan]];
            self.ifmodel.tiltControlArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:ControlArrayTilt]];
        
        if (self.ifmodel.bufferSecond) {
            
        }else{
            
            self.ifmodel.bufferSecond = 0;
        }
        if (self.ifmodel.exposureSecond) {
            
        }else{
            self.ifmodel.exposureSecond = 0;
            
        }
        
            if (self.ifmodel.slideCount) {
        
            }else{
                self.ifmodel.slideCount = 2;
            }
            if (self.ifmodel.FunctionMode) {
        
            }else{
                self.ifmodel.FunctionMode   = 0;
            }
        
            if (self.ifmodel.shootMode) {
        
            }else{
                self.ifmodel.shootMode      = 0;
            }
            if (self.ifmodel.displayUnit) {
        
            }else{
                self.ifmodel.displayUnit = 0;
            }
            if (self.ifmodel.totalFrames) {
            }else{
                self.ifmodel.totalFrames = 100;
            }
            if (self.ifmodel.TimelapseTotalTimes) {
            }else{
                self.ifmodel.TimelapseTotalTimes = 100 / 24.0f;
            }
            if (self.ifmodel.sliderArray) {
        
            }else{
                self.ifmodel.sliderArray = @[Point(0, downLimit - topLimit), Point(rightLimit , downLimit - topLimit)];
            }
            if (self.ifmodel.panArray) {
        
            }else{
                self.ifmodel.panArray = @[Point(0, (downLimit - topLimit) * 0.5), Point((rightLimit ), (downLimit - topLimit) * 0.5)];
            }
            if (self.ifmodel.tiltArray) {
        
            }else{
                self.ifmodel.tiltArray = @[Point(0, (downLimit - topLimit) * 0.5), Point((rightLimit ), (downLimit - topLimit) * 0.5)];
            }
            if (self.ifmodel.fpsIndex) {
        
            }else{
                self.ifmodel.fpsIndex = 0;
            }
            if (self.ifmodel.intervalTimeIndex) {
        
            }else{
                self.ifmodel.intervalTimeIndex = 0;
            }
            if ([ud objectForKey:UpSlideViewValue]) {
                if (self.ifmodel.upSliderValue >= SlideConunt(self.ifmodel.slideCount)) {
                    self.ifmodel.upSliderValue = SlideConunt(self.ifmodel.slideCount);
                }
            }else{
                self.ifmodel.upSliderValue = SlideConunt(self.ifmodel.slideCount);
            }
            if ([ud objectForKey:DownSlideViewValue]) {
                if (self.ifmodel.downSliderValue >= SlideConunt(self.ifmodel.slideCount)) {
                    self.ifmodel.downSliderValue = 0;
                }
                
            }else{
                self.ifmodel.downSliderValue = 0;
            }
            if ([ud objectForKey:UpPanViewValue]) {
                
            }else{
                self.ifmodel.upPanValue = 90.0f;
            }
            if ([ud objectForKey:DownPanViewValue]) {
            
            }else{
                self.ifmodel.downPanValue = -90.0f;
            }
        
            if ([ud objectForKey:UpTiltViewValue]) {
                
            }else{
                self.ifmodel.upTiltValue = TiltMaxValue;
            }
        
            if ([ud objectForKey:DownTiltViewValue] ) {
                
            }else{
                self.ifmodel.downTiltValue = TiltMinValue;
            }
        
            if ([ud objectForKey:TOTALTIMES]) {
                
            }else{
                self.ifmodel.totalTimes = 100;
            }
        
        if (self.ifmodel.displayUnit == 0) {
            self.ifmodel.TimelapseTotalTimes = (CGFloat)self.ifmodel.totalFrames / [self.configs[self.ifmodel.fpsIndex] integerValue];
        }else if (self.ifmodel.displayUnit == 1){
            
            self.ifmodel.TimelapseTotalTimes = (CGFloat)self.ifmodel.totalFrames / [self.configs[self.ifmodel.fpsIndex] integerValue];
        }
        
    }
    
}
- (void)delegateDeletePoint{
    self.insertIndex--;
}
#pragma mark - 创建插入的视图
- (void)createInsertView{
#warning - iFInsertView remodified（重新修改UI）
    
    insertView = [[iFInsertView alloc]initWithFrame:CGRectMake(leftLimit ,topLimit, 20, downLimit - topLimit)];
    [insertView addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(chooseValue:)]];
    [self.view addSubview:insertView];
    
}

- (void)createUI{
    
    backView = [[iFBackImageView alloc]initWithFrame:CGRectMake(leftLimit, topLimit, rightLimit, downLimit - topLimit)];
    [backView createUIWithFrames:self.ifmodel.totalFrames orWithTimes:0];
    
//    [self loopAction:self.ifmodel.FunctionMode];
    
    [self.view addSubview:backView];
}
/**
 *  跳转到设置参数的界面
 */
- (void)gotoiFSettingVC{
    iFSettingViewController * ifsvc = [[iFSettingViewController alloc]init];
    ifsvc.delegate = self;//签署协议
    [self.navigationController pushViewController:ifsvc animated:YES];
}


/**
 *  创建back按钮
 */
- (void)backActionDelegateMethod{
    [self backTolastViewController];
    
}
- (void)backTolastViewController{
    
    
//    NSLog(@"indexRow = %ld", (long)self.indexRow);
    [self closeNSTimer];
    
    if (_isSaveData) {
        
        
        
        [self saveDataWithBOOLYES];
    }
//
    /* 返回存储数据 */
    self.ifmodel.sliderArray = SliderBazierView.PointArray;
    self.ifmodel.panArray = PanBazierView.PointArray;
    self.ifmodel.tiltArray = TiltBazierView.PointArray;
    self.ifmodel.slideControlArray = SliderBazierView.ControlPointArray;
    self.ifmodel.panControlArray = PanBazierView.ControlPointArray;
    self.ifmodel.tiltControlArray = TiltBazierView.ControlPointArray;
    
    NSData * slidedata = [NSKeyedArchiver archivedDataWithRootObject:self.ifmodel.sliderArray];
    NSData * pandata = [NSKeyedArchiver archivedDataWithRootObject:self.ifmodel.panArray];
    NSData * tiltdata = [NSKeyedArchiver archivedDataWithRootObject:self.ifmodel.tiltArray];
    NSData * controlslidedata = [NSKeyedArchiver archivedDataWithRootObject:self.ifmodel.slideControlArray];
    NSData * controlpandata = [NSKeyedArchiver archivedDataWithRootObject:self.ifmodel.panControlArray];
    NSData * controltiltdata = [NSKeyedArchiver archivedDataWithRootObject:self.ifmodel.tiltControlArray];
    
    [ud setObject:controlslidedata forKey:ControlArraySLIDE];
    [ud setObject:controlpandata forKey:ControlArrayPan];
    [ud setObject:controltiltdata forKey:ControlArrayTilt];
    [ud setObject:slidedata forKey:ArraySLIDE];
    [ud setObject:pandata forKey:ArrayPan];
    [ud setObject:tiltdata forKey:ArrayTilt];
    [ud setObject:SlideCustomSlider.downlabel.text forKey:DownSlideViewValue];
    [ud setObject:SlideCustomSlider.uplabel.text forKey:UpSlideViewValue];
    [ud setObject:PanCustomSlider.downlabel.text forKey:DownPanViewValue];
    [ud setObject:PanCustomSlider.uplabel.text forKey:UpPanViewValue];
    [ud setObject:TiltCustomSlider.downlabel.text forKey:DownTiltViewValue];
    [ud setObject:TiltCustomSlider.uplabel.text forKey:UpTiltViewValue];
    

//    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"self.ifmodel.fpsIndex%ld", self.ifmodel.fpsIndex);
    
}

- (void)createBackBtnAndOtherBtn{
    /**
     返回按钮
     */
    backBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(21.5), iFSize(15), iFSize(40), iFSize(30)) andnormalImage:@"sigleBack@2x" andSelectedImage:@"sigleBack@2x"];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn addTarget:self action:@selector(backTolastViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self.view bringSubviewToFront:backBtn];
    
    
    /***********新的UI************/
    /**
     创建循环视图
     
     @param loopAction: 循环事件
     
     @return
     */
    UITapGestureRecognizer * tapgesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFunctionMode:)];
    
    /**
     选择间隔时间

     @param chooseIntervalValue: 选择间隔时间事件
     @return return value description
     */
    UITapGestureRecognizer * intervaltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIntervalValue:)];
    UITapGestureRecognizer * exposureTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIntervalValue:)];
    
    UITapGestureRecognizer * bufferTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIntervalValue:)];

    /**
     选择总共的帧数

     @param chooseFrameValue: 选择帧数事件
     @return return value description
     */
    UITapGestureRecognizer * frameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseFrameValue:)];
    
    /**
     选择Timelapse总时间

     @param chooseTimelapseTimeValue: 选择Timelapse的时间事件
     @return return value description
     */
    UITapGestureRecognizer * timelapseTimeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimelapseTimeValue:)];
    
    UITapGestureRecognizer * timeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTimeValue:)];
    
   
    
    
    /***********新的UI*************/
    
    FrameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iFSize(443), iFSize(32.5), iFSize(150), iFSize(16))];
    
    FrameLabel.textColor = [UIColor whiteColor];
    FrameLabel.font = [UIFont systemFontOfSize:iFSize(16)];
    FrameLabel.text = @"Frame:0/0";
    
 
    if (self.ifmodel.displayUnit == 0) {
        centerInfoView.finalOutputLabel.text = @"Output time:";
    }else{
        centerInfoView.finalOutputLabel.text = @"Output frame:";
    }
    [self.view addSubview:centerInfoView];

    /**
     循环选择模式按钮
     
     @return return value description
     */
    loopModeView = [[iFLoopView alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.15, [self getYLimitWithFollowView:SliderBazierView], iFSize(100), AutoKscreenWidth * 0.07)];
    [loopModeView addGestureRecognizer:tapgesure];
    

    [self.view addSubview:loopModeView];
//    loopModeView.index = self.ifmodel.FunctionMode;
    
    [loopModeView loopChangeTitle:self.ifmodel.FunctionMode];
    
    
    
    expoLabel = [self getLabelWithFrame:CGRectMake([self getXRightLimitWithCenterView:loopModeView], [self getYLimitWithFollowView:SliderBazierView], AutoKScreenHeight * 0.11, AutoKscreenWidth * 0.07) andTitle:[NSString stringWithFormat:@"Expo:%.2lds",self.ifmodel.exposureSecond]];
    expoLabel.tag = ExposureLabelTag;
    [expoLabel addGestureRecognizer:exposureTap];
    
    [self.view addSubview:expoLabel];
    
    bufferLabel = [self getLabelWithFrame:CGRectMake([self getXRightLimitWithCenterView:expoLabel], [self getYLimitWithFollowView:SliderBazierView], AutoKScreenHeight * 0.12, AutoKscreenWidth * 0.07) andTitle:[NSString stringWithFormat:@"Buffer:%.2lds", self.ifmodel.bufferSecond]];
    
    bufferLabel.tag = BufferLabelTag;
    
    [bufferLabel addGestureRecognizer:bufferTap];
    [self.view addSubview:bufferLabel];
    
    /**
     插入的移动标尺
     
     @return return value description
     */
    intervalLabel = [self getLabelWithFrame:CGRectMake(iFSize(180), [self getYLimitWithFollowView:SliderBazierView], AutoKScreenHeight * 0.19, AutoKscreenWidth * 0.07) andTitle:[NSString stringWithFormat:@"Interval:%@s", _timeArr[self.ifmodel.intervalTimeIndex]]];
    [intervalLabel addGestureRecognizer:intervaltap];
//        [self.view addSubview:intervalLabel];
    
    /**
     frameLabel
     
     @return return value description
     */
    frameLabel = [self getLabelWithFrame:CGRectMake([self getXRightLimitWithCenterView:bufferLabel], [self getYLimitWithFollowView:SliderBazierView], AutoKScreenHeight * 0.19, AutoKscreenWidth * 0.07) andTitle:[NSString stringWithFormat:@"Frame:%ld", (long)self.ifmodel.totalFrames]];
    [self.view addSubview:frameLabel];
    frameLabel.tag = 10000;
    [frameLabel addGestureRecognizer:frameTap];
    
    /**
     TimelapseTimeLabel
     @return return value description
     */
    TimelapseTimeLabel = [self getLabelWithFrame:CGRectMake([self getXRightLimitWithCenterView:bufferLabel], [self getYLimitWithFollowView:SliderBazierView], AutoKScreenHeight * 0.19, AutoKscreenWidth * 0.07) andTitle:[NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimelapseTimeWith:self.ifmodel.TimelapseTotalTimes andFPS:[self.configs[self.ifmodel.fpsIndex]integerValue]]]];
    TimelapseTimeLabel.tag = 10001;
    [TimelapseTimeLabel addGestureRecognizer:timelapseTimeTap];
    [self.view addSubview:TimelapseTimeLabel];
    
    
    /*判断Timelapse模式 0 -> Frame模式  1-> Time模式*/
    if (self.ifmodel.displayUnit == 0) {
        frameLabel.alpha = 1;
        TimelapseTimeLabel.alpha = 0;
    }else if (self.ifmodel.displayUnit == 1){
        frameLabel.alpha = 0;
        TimelapseTimeLabel.alpha = 1;
    }
    /**
     Video的时间label
     
     @return return value description
     */
    timeLabel  = [self getLabelWithFrame:CGRectMake([self getXRightLimitWithCenterView:bufferLabel], [self getYLimitWithFollowView:SliderBazierView], AutoKScreenHeight * 0.19, AutoKscreenWidth * 0.07) andTitle:[NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimeWith:self.ifmodel.totalTimes]]];
    timeLabel.alpha = 0;
    [timeLabel addGestureRecognizer:timeTap];
    [self.view addSubview:timeLabel];
    
    
    UITapGestureRecognizer * fpsgesure = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fpschooseValue:)];
    /**
     fpslabel
     
     @return return value description
     */
    fpsLabel = [self getLabelWithFrame:CGRectMake([self getXRightLimitWithCenterView:timeLabel], [self getYLimitWithFollowView:SliderBazierView], iFSize(45), AutoKscreenWidth * 0.07) andTitle:nil];
    fpsLabel.userInteractionEnabled = YES;
    fpsLabel.textColor = [UIColor whiteColor];
    fpsLabel.text = self.configs[self.ifmodel.fpsIndex];
    [fpsLabel addGestureRecognizer:fpsgesure];
    [self.view addSubview:fpsLabel];
    
    UITableView *blueView = [[UITableView alloc] init];
    blueView.frame = CGRectMake(0, 0, iFSize(100), 200);
    blueView.dataSource = self;
    blueView.delegate = self;
    self.tableView = blueView;
    
    
    UIView * xyView = [[UIView alloc]initWithFrame:CGRectMake([self getXRightLimitWithCenterView:fpsLabel], [self getYLimitWithFollowView:SliderBazierView] - 5, AutoKScreenHeight * 0.07, AutoKscreenWidth * 0.08)];
    [self.view addSubview:xyView];
    
    xFrameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, xyView.frame.size.width, xyView.frame.size.height * 0.5)];
    xFrameLabel.backgroundColor = [UIColor clearColor];
    xFrameLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:xyView.frame.size.height * 0.5];
    [xyView addSubview:xFrameLabel];
    
    yDistanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, xyView.frame.size.height * 0.5, xyView.frame.size.width, xyView.frame.size.height * 0.5)];
    yDistanceLabel.backgroundColor = [UIColor clearColor];
    yDistanceLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:xyView.frame.size.height * 0.5];
    [xyView addSubview:yDistanceLabel];
    
    [self loopAction:self.ifmodel.FunctionMode];

    
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
- (void)loopActionDelegateMethod{
    
    
    [self isloopAction:self.isloopBtn];
    
}
- (void)stopActionDelegateMethod{
    [self StopAction];
}


- (void)isloopAction:(iFButton *)btn{
    
    
    if (processView.isloopBtn.selected) {
        NSLog(@"1");
        isloop = 0x01;
        
    }else{
        isloop = 0x00;
        NSLog(@"2");
    }
    
    
    [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x01 andTimestamp:0x00 WithStr:SendStr andisLoop:isloop];
    [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x01 andTimestamp:0x00 WithStr:SendStr andisLoop:isloop];
}

- (void)showXvalueStr:(NSString *)xstr andYvalueStr:(NSString *)ystr{
    if (MODEL == MODEL_SLIDER) {
        xFrameLabel.textColor = COLOR(255, 0, 255, 1);
        yDistanceLabel.textColor = COLOR(255, 0, 255, 1);
        
    }else if (MODEL == MODEL_PAN){
        xFrameLabel.textColor = COLOR(0, 255, 255, 1);
        yDistanceLabel.textColor = COLOR(0, 255, 255, 1);
    }else if (MODEL == MODEL_TILT) {
        xFrameLabel.textColor = COLOR(255, 255, 0, 1);
        yDistanceLabel.textColor = COLOR(255, 255, 0, 1);
    }
    
    xFrameLabel.text = xstr;
    yDistanceLabel.text = ystr;

}
#pragma mark - previewBtnAction -
- (void)preViewBtnAction:(iFButton *)btn{
    [self StopAction];
    
    self.preViewBtn.alpha = 0;
    self.PauseBtn.alpha = 1;
    
    CGFloat RealTimes = 1;
    while (![self countAllVideoTime:RealTimes]) {
        RealTimes++;
    }
    
    preViewSecond = self.ifmodel.TimelapseTotalTimes > RealTimes ? self.ifmodel.TimelapseTotalTimes + 1 : RealTimes;
    
    isTouchPreview = YES;
    
    loopModeView.MODEL = 1;
    processView.titleLabel.text = @"preview";
    
    [self StartMoveWithInsertView];
    
}
#pragma mark - returnBtnAction -
- (void)returnBtnAction:(iFButton *)btn{
    NSLog(@"点击了");
    [self StopAction];
    isTouchReturnBack = YES;
    isloop = 0x00;
    processView.isloopBtn.selected = NO;
    [self StartMoveWithInsertView];
}


- (void)PauseMotionActionDelegateMethod{
    UInt64 recordTime = [[NSDate date]timeIntervalSince1970] * 1000;
    pauseTime = recordTime;
    receiveTimer.fireDate = [NSDate distantFuture];

    NSLog(@"recordTime%lld", recordTime);
    [_sendDataView sendStartCancelPauseDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x03 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    [_sendDataView sendStartCancelPauseDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x03 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
}

- (void)restartMotionActionDelegateMethod{
    UInt64 recordTime = [[NSDate date]timeIntervalSince1970] * 1000 + 1;
    restartTime = recordTime;
    receiveTimer.fireDate = [NSDate distantPast];
    
    pasueTotaltime = (restartTime - pauseTime + 1) + pasueTotaltime;
    
    NSLog(@"recordTime%lld", (restartTime - pauseTime) / 1000);
    [_sendDataView sendStartCancelPauseDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x05 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    [_sendDataView sendStartCancelPauseDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x05 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
}
- (void)stopMotionActionDelegateMethod{
    NSLog(@"stopMotionActionDelegateMethod");
    [self stopMotionAction:0x02];
}
- (void)stopMotion_lastPicActionDelegateMethod{
    [self stopMotionAction:0x03];
}
#pragma mark - (05)stopMotionAction -
- (void)stopMotionAction:(UInt8 )stopMotionMode{
    NSLog(@"StopMotionMode %d", stopMotionMode);
    [self countLongestTimeWithMode:stopMotionMode];

    isPlayOn = YES;
    
    [self getConntionStatus];
    
    if (_status == StatusSLIDEandX2AllConnected) {
        if (_receiveView.slideStopMotionCurruntFrame > 0 && _receiveView.x2StopMotionCurruntFrame > 0) {
            [self countLongestTimeWithMode:stopMotionMode];
            
        }else if (_receiveView.slideStopMotionCurruntFrame > self.ifmodel.totalFrames || _receiveView.x2StopMotionCurruntFrame > self.ifmodel.totalFrames){
            
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_HasFinishedMaking, nil)];
            

        }else{
            [self StartMoveWithInsertView];
        }
    }else if (_status == StatusSLIDEOnlyConnected){
        if (_receiveView.slideStopMotionCurruntFrame > 0) {
            [self countLongestTimeWithMode:stopMotionMode];
            
        }else if(_receiveView.slideStopMotionCurruntFrame > self.ifmodel.totalFrames){
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_HasFinishedMaking, nil)];
            
        }else{
        
        [self StartMoveWithInsertView];
        }
    
    }else if (_status == StatusX2OnlyConnected){
        if (_receiveView.x2StopMotionCurruntFrame > 0) {
            [self countLongestTimeWithMode:stopMotionMode];
        }else if(_receiveView.x2StopMotionCurruntFrame > self.ifmodel.totalFrames   ){
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_HasFinishedMaking, nil)];

        }else{
        
        [self StartMoveWithInsertView];
        }
    }else if (_status == StatusSLIDEandX2AllDisConnected) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_NoDeviceWarning, nil)];

        return;
    }
}

- (NSArray *)recursionGetsubLevelPointsWithSuperPoints:(NSArray *)points progress:(CGFloat)progress{
    // 得到最终的点 正确结束递归
    if (points.count == 1) return points;
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < points.count-1; i++) {
        // 第一个点
        NSValue *preValue = [points objectAtIndex:i];
        CGPoint prePoint = preValue.CGPointValue;
        // 第二个点
        NSValue *lastValue = [points objectAtIndex:i+1];
        CGPoint lastPoint = lastValue.CGPointValue;
        
        // 两点坐标差
        CGFloat diffX = lastPoint.x-prePoint.x;
        CGFloat diffY = lastPoint.y-prePoint.y;
        
        // 根据当前progress得出高一阶的点
        CGPoint currentPoint = CGPointMake(prePoint.x+diffX*progress, prePoint.y+diffY*progress);
        [tempArr addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
    // 继续下一次递归过程
    return [self recursionGetsubLevelPointsWithSuperPoints:tempArr progress:progress];
}

- (void)countAllpointTime{
    
    [self initData];
    [self getConntionStatus];
    
    CGFloat a, b, c;
    CGFloat A, B, C, A1, B1, C1;
    
    NSArray * Slidearray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray];
    NSArray * Panarray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray];
    NSArray * Tiltarray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray];
    
    
    CGFloat slidefirstF = [[Slidearray[0] firstObject] floatValue];
    CGFloat slidelastF = [[Slidearray[0] lastObject] floatValue];
    CGFloat panfirstF = [[Panarray[0] firstObject] floatValue];
    CGFloat panlastF = [[Panarray[0] lastObject] floatValue];
    CGFloat tiltfirstF = [[Tiltarray[0] firstObject] floatValue];
    CGFloat tiltlastF = [[Tiltarray[0] lastObject] floatValue];
    
    float SlidePos[31] = {0.0};
    float SlideT[31] = {0.0};
    float PanPos[31] = {0.0};
    float PanT[31] = {0.0};
    float TiltPos[31] = {0.0};
    float TiltT[31] = {0.0};
    
    
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Slidearray[i] count]; j++) {
            if (i == 0) {
                SlideT[j] = [Slidearray[i][j] floatValue];
                
            }else if (i == 1){
                SlidePos[j] =  [Slidearray[i][j] floatValue];
                
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < [Panarray[i] count]; j++) {
            if (i == 0) {
                PanT[j] = [Panarray[i][j] floatValue];
            }else if (i == 1){
                PanPos[j]  = [Panarray[i][j] floatValue];
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Tiltarray[i] count]; j++) {
            if (i == 0 ) {
                TiltT[j]  = [Tiltarray[i][j] floatValue];
            }else if (i == 1){
                TiltPos[j] = [Tiltarray[i][j] floatValue];
            }
        }
    }
    
//    NSInteger m = 0, n = 0;
    
//    if (_status == StatusSLIDEandX2AllConnected) {
//        m = _receiveView.slideStopMotionCurruntFrame;
//    }else if (_status == StatusSLIDEOnlyConnected){
//        m = _receiveView.slideStopMotionCurruntFrame;
//        
//    }else if (_status == StatusX2OnlyConnected){
//        m = _receiveView.x2StopMotionCurruntFrame;
//    }else if (_status == StatusSLIDEandX2AllDisConnected) {
//        
//    }
//    n = m + 1;
    
    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = self.ifmodel.totalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)self.ifmodel.totalFrames;
    }else{
        NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
        if (self.ifmodel.displayUnit == 1) {
            TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)self.ifmodel.totalFrames;
        }
    }
    
    
    a = (slidelastF - slidefirstF) / TotalFrames;
    b = (panlastF - panfirstF) / TotalFrames;
    c = (tiltlastF - tiltfirstF) / TotalFrames;
    
    CGFloat S1time1 = 0.0f, S1time2 = 0.0f , P1time1 = 0.0f, P1time2 = 0.0f , T1time1 = 0.0f, T1time2 = 0.0f;
//    NSLog(@"getNewArrayWithArray%@",  [self getNewArrayWithArray:Slidearray[0]]);
    
    
    for (int i = 0; i < TotalFrames; i++) {

        A = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * i, SlidePos, SlideT)) / SliderBazierView.frame.size.height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
        A1 = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * (i + 1), SlidePos, SlideT)) / SliderBazierView.frame.size.height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
        B = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * i, PanPos, PanT)) / PanBazierView.frame.size.height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
        B1 = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * (i + 1), PanPos, PanT)) / PanBazierView.frame.size.height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
        
        C = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * i, TiltPos, TiltT)) / TiltBazierView.frame.size.height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
        C1 = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * (i + 1), TiltPos, TiltT)) / TiltBazierView.frame.size.height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
    

            S1time2 = GETTimelapseSlideLongestTime(fabs(fabs(A1) - fabs(A)));
            S1time1 = S1time1 > S1time2 ? S1time1 : S1time2;
    
            P1time2  = GETTimelapseX2LongestTime(fabs(fabs(B1) - fabs(B)));
            P1time1 = P1time1 > P1time2 ? P1time1 : P1time2;

            T1time2 = GETTimelapseTiltLongestTime(fabs(fabs(C1) - fabs(C)));
            T1time1 = T1time1 > T1time2 ? T1time1 : T1time2;
        
//        NSLog(@"S1Time1 = %f", S1time1);
//        NSLog(@"P1Time1 = %f", P1time1);
//        NSLog(@"T1Time1 = %f", T1time1);
    }
    
    NSLog(@"S1Time1 = %f", S1time1);
    NSLog(@"P1Time1 = %f", P1time1);
    NSLog(@"T1Time1 = %f", T1time1);
    
    
    
    if (_status == StatusSLIDEandX2AllConnected) {
        runningTime = (S1time1 > P1time1 ? S1time1 : P1time1) > T1time1 ? (S1time1 > P1time1 ? S1time1 : P1time1) : T1time1;

    }else if (_status == StatusSLIDEOnlyConnected){
        runningTime = S1time1;
        
    }else if (_status == StatusX2OnlyConnected){
        
        runningTime = P1time1 > T1time1 ? P1time1 : T1time1;
        
    }else if (_status == StatusSLIDEandX2AllDisConnected) {
        runningTime = (S1time1 > P1time1 ? S1time1 : P1time1) > T1time1 ? (S1time1 > P1time1 ? S1time1 : P1time1) : T1time1;
        
    }

    NSLog(@"running  = %lf", runningTime);
    finalRunningTime =ceilf(runningTime + .5 + self.ifmodel.exposureSecond + self.ifmodel.bufferSecond);


    centerInfoView.interValueLabel.text = [NSString stringWithFormat:@"%ds",finalRunningTime];
    if (isTouchPreview) {
        
    }else{
    
    if (loopModeView.MODEL == MODEL_STOPMOTION) {
        centerInfoView.interValueLabel.alpha = 0;
        centerInfoView.intervalLabel.alpha = 0;
        centerInfoView.fimlingTimeLabel.alpha = 0;
        centerInfoView.fimilingTimeValueLabel.alpha = 0;
        
    }else{
        centerInfoView.interValueLabel.alpha = 1;
        centerInfoView.intervalLabel.alpha = 1;
        centerInfoView.fimlingTimeLabel.alpha = 1;
        centerInfoView.fimilingTimeValueLabel.alpha = 1;
    }
    }
    if (self.ifmodel.displayUnit == 1) {
    centerInfoView.finalOutputValueLabel.text = [NSString stringWithFormat:@"%ldf", self.ifmodel.totalFrames];
        
    }else{
        centerInfoView.finalOutputValueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimelapseTimeWith:self.ifmodel.TimelapseTotalTimes andFPS:[self.configs[self.ifmodel.fpsIndex]integerValue]]];
    }
//    centerInfoView.fimilingTimeValueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith:(finalRunningTime * self.ifmodel.totalFrames)]];
    centerInfoView.fimilingTimeValueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool get_HMS_TimeWith:(finalRunningTime * self.ifmodel.totalFrames)]];
    
//    }
//    NSLog(@"final = %hu", finalRunningTime);
    
}
- (NSArray *)getNewArrayWithArray:(NSArray *)array{
    NSMutableArray * NewArray = [NSMutableArray new];
    for (int i = 0; i < 30; i++) {
        if (i < array.count) {
            [NewArray addObject:array[i]];
        }else{
            [NewArray addObject:@0];
        }
    }
    return NewArray;
}
/**
 countLongestTime
 */
- (void)countLongestTimeWithMode:(UInt8)StopMotionMode{
    
    [self initData];
    [self getConntionStatus];
    
    CGFloat a, b, c;
    CGFloat A, B, C, A1, B1, C1;
    
    NSArray * Slidearray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray];
    NSArray * Panarray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray];
    NSArray * Tiltarray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray];
    
    CGFloat slidefirstF = [[Slidearray[0] firstObject] floatValue];
    CGFloat slidelastF = [[Slidearray[0] lastObject] floatValue];
    CGFloat panfirstF = [[Panarray[0] firstObject] floatValue];
    CGFloat panlastF = [[Panarray[0] lastObject] floatValue];
    CGFloat tiltfirstF = [[Tiltarray[0] firstObject] floatValue];
    CGFloat tiltlastF = [[Tiltarray[0] lastObject] floatValue];

    float SlidePos[31] = {0.0};
    float SlideT[31] = {0.0};
    float PanPos[31] = {0.0};
    float PanT[31] = {0.0};
    float TiltPos[31] = {0.0};
    float TiltT[31] = {0.0};
    
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Slidearray[i] count]; j++) {
            if (i == 0) {
                SlideT[j] = [Slidearray[i][j] floatValue];
                
            }else if (i == 1){
                SlidePos[j] =  [Slidearray[i][j] floatValue];
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < [Panarray[i] count]; j++) {
            if (i == 0) {
                PanT[j] = [Panarray[i][j] floatValue];
            }else if (i == 1){
                PanPos[j]  = [Panarray[i][j] floatValue];
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Tiltarray[i] count]; j++) {
            if (i == 0 ) {
                TiltT[j]  = [Tiltarray[i][j] floatValue];
            }else if (i == 1){
                TiltPos[j] = [Tiltarray[i][j] floatValue];
            }
        }
    }
    
    NSInteger m = 0, n = 0;
    
    if (_status == StatusSLIDEandX2AllConnected) {
        m = _receiveView.slideStopMotionCurruntFrame;
    }else if (_status == StatusSLIDEOnlyConnected){
        m = _receiveView.slideStopMotionCurruntFrame;
        
    }else if (_status == StatusX2OnlyConnected){
        m = _receiveView.x2StopMotionCurruntFrame;
    }else if (_status == StatusSLIDEandX2AllDisConnected) {
        
    }
    
 
    
    if (StopMotionMode == 0x03) {
        NSLog(@"data03 ==================");
        m = _receiveView.slideStopMotionCurruntFrame > _receiveView.x2StopMotionCurruntFrame ?  _receiveView.slideStopMotionCurruntFrame - 1 :  _receiveView.x2StopMotionCurruntFrame - 1;
    }else{
        NSLog(@"data02 ==================%d", StopMotionMode);
        m =  _receiveView.slideStopMotionCurruntFrame > _receiveView.x2StopMotionCurruntFrame ?  _receiveView.slideStopMotionCurruntFrame :  _receiveView.x2StopMotionCurruntFrame;
    }
//    NSLog(@"");
    n = m + 1;
    a = (slidelastF - slidefirstF) / self.ifmodel.totalFrames;
    b = (panlastF - panfirstF) / self.ifmodel.totalFrames;
    c = (tiltlastF - tiltfirstF) / self.ifmodel.totalFrames;
    
    A = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * m, SlidePos, SlideT)) / SliderBazierView.frame.size.height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
    B = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * m, PanPos, PanT)) / PanBazierView.frame.size.height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
    C = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * m, TiltPos, TiltT)) / TiltBazierView.frame.size.height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
    
    A1 = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * n, SlidePos, SlideT)) / SliderBazierView.frame.size.height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
    B1 = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * n, PanPos, PanT)) / PanBazierView.frame.size.height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
    C1 = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * n, TiltPos, TiltT)) / TiltBazierView.frame.size.height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
   
    CGFloat slideLongestime = GETSlideLongestTIME(fabs(A1 - A));
    CGFloat panLongestime = GETX2longestTIME(fabs(B1 - B));
    CGFloat tiltLongestime = GETTiltLongestTIME(fabs(C1 - C));
    
    CGFloat longestime = MAX(MAX(slideLongestime, panLongestime), tiltLongestime);
    UInt16 sendLongestTime = (UInt16)(longestime * 1000);
    NSLog(@"long = %lf", longestime);
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    if (m<=1) {
        m = 1;
    }
    NSLog(@"UInt32 %d", (UInt32)m);
    [self.sendDataView sendStopMotionSetWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:StopMotionMode andTimestamp:recordTime CurrentFrame:(UInt32)m andlongestTime:sendLongestTime WithStr:SendStr];
    [self.sendDataView sendStopMotionSetWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:StopMotionMode andTimestamp:recordTime CurrentFrame:(UInt32)m andlongestTime:sendLongestTime WithStr:SendStr];
    
}


/**
//判断当前时间代入速度是否超过slider 以及 pan 和 tilt的极限速度

 @param realRunningTime  代入测试时间
 @return 超过为NO  未超过为YES
 */
- (BOOL)countAllVideoTime:(CGFloat)realRunningTime{
    
    [self initData];
    [self getConntionStatus];
    
    CGFloat a, b, c;
    CGFloat A, B, C;
    
    NSArray * Slidearray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray];
    
    NSArray * Panarray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray];
    NSArray * Tiltarray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray];
    
//    NSLog(@"Slidearray%@", Slidearray);
//    NSLog(@"Panarray%@", Panarray);
//    NSLog(@"Tiltarray%@", Tiltarray);
    CGFloat realTime = realRunningTime;
    
    
    CGFloat slidefirstF = [[Slidearray[0] firstObject] floatValue]/ SliderBazierView.frame.size.width * realTime;
    CGFloat slidelastF =  [[Slidearray[0] lastObject] floatValue] / SliderBazierView.frame.size.width * realTime;
    CGFloat panfirstF = [[Panarray[0] firstObject] floatValue] / PanBazierView.frame.size.width * realTime;
    CGFloat panlastF = [[Panarray[0] lastObject] floatValue] / PanBazierView.frame.size.width * realTime;
    CGFloat tiltfirstF = [[Tiltarray[0] firstObject] floatValue] / TiltBazierView.frame.size.width * realTime;
    CGFloat tiltlastF = [[Tiltarray[0] lastObject] floatValue] / TiltBazierView.frame.size.width * realTime;
    
    float SlidePos[31] = {0.0};
    float SlideT[31] = {0.0};
    float PanPos[31] = {0.0};
    float PanT[31] = {0.0};
    float TiltPos[31] = {0.0};
    float TiltT[31] = {0.0};
    
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Slidearray[i] count]; j++) {
            if (i == 0) {
                SlideT[j] = [Slidearray[i][j] floatValue] / SliderBazierView.frame.size.width * realTime;
                
                
            }else if (i == 1){
                SlidePos[j] = (SliderBazierView.frame.size.height - [Slidearray[i][j] floatValue]) / SliderBazierView.frame.size.height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
                
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < [Panarray[i] count]; j++) {
            if (i == 0) {
                PanT[j] = [Panarray[i][j] floatValue] / PanBazierView.frame.size.width * realTime;
                
            }else if (i == 1){
                PanPos[j] = (PanBazierView.frame.size.height - [Panarray[i][j] floatValue])/ PanBazierView.frame.size.height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
                
                
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Tiltarray[i] count]; j++) {
            if (i == 0 ) {
                TiltT[j]  = [Tiltarray[i][j] floatValue] / TiltBazierView.frame.size.width * realTime;
            }else if (i == 1){
                TiltPos[j] = (TiltBazierView.frame.size.height - [Tiltarray[i][j] floatValue]) / TiltBazierView.frame.size.height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
                
            }
        }
    }
    
    for (int i = 0; i <= 1000; i++) {
        
            a = (slidelastF - slidefirstF) / 1000;
            b = (panlastF - panfirstF) / 1000;
            c = (tiltlastF - tiltfirstF) / 1000;
            
            A = fabsf(Slide_Speed_Calculate(a * i, SlidePos, SlideT));
            B = fabsf(Slide_Speed_Calculate(b * i, PanPos, PanT));
            C = fabsf(Slide_Speed_Calculate(c * i, TiltPos, TiltT));
        
        if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
            if (A > SlideVelocMaxValue) {
                //                NSLog(@"Slider超过跑不了");
                return NO;
            }
        }
        if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
            if (B > PanVelocMaxValue) {
                //                NSLog(@"Pan超过跑不了");
                
                return NO;
            }
            if (C > TiltVelocMaxValue) {
                
                //                NSLog(@"Tilt超过跑不了");
                return NO;
            }
            
        }

//            NSLog(@"speedS %f", A);
//            NSLog(@"speedP %f", B);
//            NSLog(@"speedT %f", C);
        }
//        NSLog(@"speedP +++++++++++++++++++++++++++++++++++++++++++++++++++");
    
    return YES;
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    int kMaxLength = 15;
    NSInteger strLength = textField.text.length - range.length + string.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    return (strLength <= kMaxLength);
    
}
- (void)saveDataAndBack{
    
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
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        //取得第一个Documents文件夹的路径
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:ProperKeyFrameList];
        
        NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
        
        dataArray = [NSMutableArray arrayWithArray:array];
        
        if (newName.text.length <= 0) {
            [SVProgressHUD showErrorWithStatus:@"Name is error"];
            return ;
        }
        self.ifmodel.nameStr = newName.text;
        self.ifmodel.sliderArray = [self loopCreateNewTypeArray:SliderBazierView.PointArray];
        self.ifmodel.panArray = [self loopCreateNewTypeArray:PanBazierView.PointArray];
        self.ifmodel.tiltArray = [self loopCreateNewTypeArray:TiltBazierView.PointArray];
        self.ifmodel.slideControlArray = [self loopCreateNewControlTypeArray:SliderBazierView.ControlPointArray];
        self.ifmodel.panControlArray = [self loopCreateNewControlTypeArray:PanBazierView.ControlPointArray];
        self.ifmodel.tiltControlArray = [self loopCreateNewControlTypeArray:TiltBazierView.ControlPointArray];
        self.ifmodel.FunctionMode = loopModeView.MODEL;
        self.ifmodel.upSliderValue = [SlideCustomSlider.uplabel.text floatValue];
        
        
        self.ifmodel.downSliderValue = [SlideCustomSlider.downlabel.text floatValue];
        
        self.ifmodel.upPanValue = [PanCustomSlider.uplabel.text floatValue];
        
        self.ifmodel.downPanValue = [PanCustomSlider.downlabel.text floatValue];
        
        self.ifmodel.upTiltValue = [TiltCustomSlider.uplabel.text floatValue];
        self.ifmodel.downTiltValue = [TiltCustomSlider.downlabel.text floatValue];
        
        self.ifmodel.shootMode          = [[ud objectForKey:SHOOTINGMODE] integerValue];
        

        
        NSDictionary * dict = [self.ifmodel dictionaryWithValuesForKeys:[self.ifmodel allPropertyNames]];
        [dataArray addObject:dict];
        
        
        
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
        NSArray * array1 = [NSArray arrayWithArray:dataArray];
        
        [array1 writeToFile:plistPath atomically:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
- (void)saveDataWithBOOLYES{
    
//    cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row][@"nameStr"];
    
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:ProperKeyFrameList];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    dataArray = [NSMutableArray arrayWithArray:array];
    
    
//    NSLog(@"%ld", (long)_indexRow);
//    BOOL isindex =
    if (dataArray.count >= 1) {
        if (_indexRow) {
            self.ifmodel.nameStr =  dataArray[_indexRow][@"nameStr"];
        }else if (_indexRow == 0){
            self.ifmodel.nameStr =  dataArray[_indexRow][@"nameStr"];
        }
    
    }
    

    self.ifmodel.sliderArray = [self loopCreateNewTypeArray:SliderBazierView.PointArray];
    self.ifmodel.panArray = [self loopCreateNewTypeArray:PanBazierView.PointArray];
    self.ifmodel.tiltArray = [self loopCreateNewTypeArray:TiltBazierView.PointArray];
    self.ifmodel.slideControlArray = [self loopCreateNewControlTypeArray:SliderBazierView.ControlPointArray];
    self.ifmodel.panControlArray = [self loopCreateNewControlTypeArray:PanBazierView.ControlPointArray];
    self.ifmodel.tiltControlArray = [self loopCreateNewControlTypeArray:TiltBazierView.ControlPointArray];
    self.ifmodel.totalFrames        = [[ud objectForKey:TOTALFRAMES] integerValue];
    self.ifmodel.fpsIndex           = [[ud objectForKey:FPSValue] integerValue];
    self.ifmodel.intervalTimeIndex  = [[ud objectForKey:INTERVALIndex] integerValue];
    self.ifmodel.upSliderValue = [SlideCustomSlider.uplabel.text floatValue];
    
    self.ifmodel.downSliderValue = [SlideCustomSlider.downlabel.text floatValue];
    self.ifmodel.upPanValue = [PanCustomSlider.uplabel.text floatValue];
    self.ifmodel.downPanValue = [PanCustomSlider.downlabel.text floatValue];
    self.ifmodel.upTiltValue = [TiltCustomSlider.uplabel.text floatValue];
    self.ifmodel.downTiltValue = [TiltCustomSlider.downlabel.text floatValue];
    
    self.ifmodel.totalTimes         = [[ud objectForKey:TOTALTIMES] floatValue];
    self.ifmodel.TimelapseTotalTimes = [[ud objectForKey:TIMELAPSETIME] floatValue];
    

    self.ifmodel.FunctionMode       = [[ud objectForKey:FUNCTIONMODE] integerValue];
    self.ifmodel.FunctionMode = loopModeView.MODEL;
    
    
    self.ifmodel.slideCount = [[ud objectForKey:SLIDECOUNT] integerValue];
    self.ifmodel.bufferSecond = [[ud objectForKey:BUFFERSECOND] integerValue];
    self.ifmodel.exposureSecond = [[ud objectForKey:EXPOSURE] integerValue];
    
//
//    self.ifmodel.nameStr = self.ifmodel.nameStr;
    
    NSDictionary * dict = [self.ifmodel dictionaryWithValuesForKeys:[self.ifmodel allPropertyNames]];
    
//    [dataArray addObject:dict];
    
    if (_isSaveData) {
        
    if (dataArray.count >= 1) {
        if (_indexRow) {
            [dataArray replaceObjectAtIndex:_indexRow withObject:dict];
        }else if (_indexRow == 0){
            [dataArray replaceObjectAtIndex:_indexRow withObject:dict];
        }
        }
    }
    
    [fm createFileAtPath:plistPath contents:nil attributes:nil];
    NSArray * array1 = [NSArray arrayWithArray:dataArray];
    
    [array1 writeToFile:plistPath atomically:YES];
    
    NSLog(@"%@", plistPath);
//    [self.navigationController popViewControllerAnimated:YES];

}
- (NSArray *)loopCreateNewControlTypeArray:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray new];
    
    for (NSArray * arr in array) {
        NSMutableArray * arr1 = [NSMutableArray new];
        for (NSValue * value in arr) {
            [arr1 addObject:[NSString stringWithFormat:@"%@", value]];
        }
        [newArray addObject:arr1];
        
    }
    return newArray;
}

- (NSArray *)getValueControlArrayWithStringControlArray:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray new];
    for (NSArray * arr in array) {
        NSMutableArray * arr1 = [NSMutableArray new];
        for (NSString * string in arr) {
            [arr1 addObject:[NSValue valueWithCGPoint:CGPointFromString(string)]];
        }
        [newArray addObject:arr1];
        
    }
    return newArray;
}
- (NSArray *)loopCreateNewTypeArray:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray new];
    for (NSValue * value in array) {
        [newArray addObject:[NSString stringWithFormat:@"%@", value]];
    }
    return newArray;
}

- (NSArray *)getValueArrayWithStringArray:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray new];
    for (NSString * string in array) {
        
        [newArray addObject:[NSValue valueWithCGPoint:CGPointFromString(string)]];
    }
    NSLog(@"======%@", newArray);
    return newArray;
}


- (void)createAllUI{
    
    
    /**
     *  初始化模式
     */
    MODEL = MODEL_SLIDER;
    
    /**
     *  创建UI
     */


#pragma -mark 创建Slide Pan tilt
    SliderBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit, Ylenth * 0.15 ,rightLimit, downLimit - topLimit)andColor:COLOR(255, 0, 255, 1) array:self.ifmodel.sliderArray WithControl:self.ifmodel.slideControlArray];

    SliderBazierView.delegate = self;
    
    SliderBazierView.tag = 1;
    PanBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit,Ylenth * 0.15 ,rightLimit, downLimit - topLimit)andColor: COLOR(0, 255, 255, 1) array:self.ifmodel.panArray WithControl:self.ifmodel.panControlArray];
    PanBazierView.delegate = self;
    
    PanBazierView.tag = 2;
    TiltBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit,Ylenth * 0.15 ,rightLimit, downLimit - topLimit) andColor:COLOR(255, 255, 0, 1) array:self.ifmodel.tiltArray WithControl:self.ifmodel.tiltControlArray];
    
    TiltBazierView.delegate = self;
    TiltBazierView.tag = 3;
    
    [self.view addSubview:SliderBazierView];
    [self.view addSubview:PanBazierView];
    [self.view addSubview:TiltBazierView];
    
//    [self createUI];
//    [self createBackBtnAndOtherBtn];
    
    /**
     *  创建选择的View
     */
    [self createInsertView];
    /**
     *  刷新视图View
     */
    [self refeshView];
    /**
     *  初始化视图位置
     */
    XValue = insertView.center.x;
    
    [self chooseCurve:SliderBtn.actionBtn];
}


- (void)moveInsertViewRealTimepreViewWithPointX:(CGFloat)x{
    CGFloat Height = SliderBazierView.frame.size.height;
//    CGFloat Width = SliderBazierView.frame.size.width;
    
    [self initData];
    CGFloat a, b, c;
    NSArray * Slidearray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray];
    NSArray * Panarray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray];
    NSArray * Tiltarray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray];
    
    float SlidePos[31] = {0.0};
    float SlideT[31] = {0.0};
    float PanPos[31] = {0.0};
    float PanT[31] = {0.0};
    float TiltPos[31] = {0.0};
    float TiltT[31] = {0.0};
    
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Slidearray[i] count]; j++) {
            if (i == 0) {
                SlideT[j] = [Slidearray[i][j] floatValue];
                
            }else if (i == 1){
                SlidePos[j] =  [Slidearray[i][j] floatValue];
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < [Panarray[i] count]; j++) {
            if (i == 0) {
                PanT[j] = [Panarray[i][j] floatValue];
            }else if (i == 1){
                PanPos[j]  = [Panarray[i][j] floatValue];
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Tiltarray[i] count]; j++) {
            if (i == 0 ) {
                TiltT[j]  = [Tiltarray[i][j] floatValue];
            }else if (i == 1){
                TiltPos[j] = [Tiltarray[i][j] floatValue];
            }
        }
    }
    
    a = (Height - GETAXIS_Trace_Calculate(x, SlidePos, SlideT)) / Height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
    b = (Height - GETAXIS_Trace_Calculate(x, PanPos, PanT)) / Height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
    c = (Height - GETAXIS_Trace_Calculate(x, TiltPos, TiltT)) / Height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
    CGFloat A, B = 0.0, C;
    
    A = GETAXIS_Trace_Calculate(x, SlidePos, SlideT);
    B =  GETAXIS_Trace_Calculate(x, PanPos, PanT);
    C =  GETAXIS_Trace_Calculate(x, TiltPos, TiltT);
    
    if (MODEL == MODEL_SLIDER) {
        self.YValue = A;
        
    }else if (MODEL == MODEL_PAN){
        self.YValue = B;
        
    }else{
        self.YValue = C;
    }
    if (a > self.ifmodel.upSliderValue) {
        a = self.ifmodel.upSliderValue - 0.01;
    }
//    NSLog(@"66666666%f, %f, %f ,%f", a, b, c, self.ifmodel.upSliderValue);
  
    
//    NSLog(@"self.YValue = %lf", self.YValue);
    
#warning 拖动insertView 三轴同步预览 ！！！！！(暂时注释)
//    if (isMoveInsertView) {
        [self RealTimeTrackingWithSlidePostion:a andPanPostion:(b + PanMaxValue) andTiltPostion:(c + TiltMaxValue) andSlideMode:0x00 andPanTiltMode:0x00];
//        NSLog(@"1111111111111%f %f %f", a, b + PanMaxValue, c + TiltMaxValue);
        
//    }
    
}



#pragma mark --moveRealTimePreViewPointY--- 发送预览修改Y值！！！！！！根据硬件协议----
- (void)moveRealTimePreViewPointY:(CGFloat)Y andPointX:(CGFloat)X andHeight:(CGFloat)Height andWidth:(CGFloat)Width{
    
    
    [self initData];
    CGFloat a, b, c;
    NSArray * Slidearray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray];
    NSArray * Panarray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray];
    NSArray * Tiltarray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray];
    
    CGFloat slidefirstF = [[Slidearray[0] firstObject] floatValue];
    CGFloat slidelastF = [[Slidearray[0] lastObject] floatValue];
    CGFloat panfirstF = [[Panarray[0] firstObject] floatValue];
    CGFloat panlastF = [[Panarray[0] lastObject] floatValue];
    CGFloat tiltfirstF = [[Tiltarray[0] firstObject] floatValue];
    CGFloat tiltlastF = [[Tiltarray[0] lastObject] floatValue];
    
    float SlidePos[31] = {0.0};
    float SlideT[31] = {0.0};
    float PanPos[31] = {0.0};
    float PanT[31] = {0.0};
    float TiltPos[31] = {0.0};
    float TiltT[31] = {0.0};
    
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Slidearray[i] count]; j++) {
            if (i == 0) {
                SlideT[j] = [Slidearray[i][j] floatValue];
                
            }else if (i == 1){
                SlidePos[j] =  [Slidearray[i][j] floatValue];
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < [Panarray[i] count]; j++) {
            if (i == 0) {
                PanT[j] = [Panarray[i][j] floatValue];
            }else if (i == 1){
                PanPos[j]  = [Panarray[i][j] floatValue];
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Tiltarray[i] count]; j++) {
            if (i == 0 ) {
                TiltT[j]  = [Tiltarray[i][j] floatValue];
            }else if (i == 1){
                TiltPos[j] = [Tiltarray[i][j] floatValue];
            }
        }
    }

    a = (Height - GETAXIS_Trace_Calculate(X, SlidePos, SlideT)) / Height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
    b = (Height - GETAXIS_Trace_Calculate(X, PanPos, PanT)) / Height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
    c = (Height - GETAXIS_Trace_Calculate(X, TiltPos, TiltT)) / Height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
    

    CGFloat SlidePostion;
    CGFloat PanPostion;
    CGFloat TiltPostion;
    UInt8 slideMode;
    UInt8 pantiltMode;
    
//    NSLog(@"55555555%f, %f, %f, %f", X, a, GETAXIS_Trace_Calculate(X, SlidePos, SlideT), Y);
    
    switch (MODEL) {
        case MODEL_SLIDER:
            slideMode = 0x01;
            SlidePostion = (Height - Y) / Height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
            PanPostion = b;
            TiltPostion = c;
            
            if ((X > panlastF && X - panlastF > 0.01) || X < panfirstF) {
                
                if ((X > tiltlastF && X - tiltlastF > 0.01) || X < tiltfirstF) {
                    pantiltMode = 0x00;
                    
                }else{
                    pantiltMode = 0x01;
                }
            }else{
                
                
                if ((X > tiltlastF && X - tiltlastF > 0.01) || X < tiltfirstF) {
                    
                    pantiltMode = 0x02;
                    
                }else{
                    
                    pantiltMode = 0x03;
                }
            }
            
            break;
        case MODEL_PAN:
            SlidePostion = a;
            PanPostion = (Height - Y) / Height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
            TiltPostion = c;
            if ((X > tiltlastF && X - tiltlastF > 0.01) || X < tiltfirstF) {
                pantiltMode = 0x02;
            }else{
                
                pantiltMode = 0x03;
                
            }
            if ((X > slidelastF && X - slidelastF > 0.01) || X < slidefirstF) {
                slideMode = 0x00;
                
            }else{
                slideMode = 0x01;
            }
            
            break;
        case MODEL_TILT:
            SlidePostion = a;
            PanPostion = b;
            TiltPostion = (Height - Y) / Height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
            if ((X > panlastF && X - panlastF > 0.01)  || X < panfirstF) {
                pantiltMode = 0x01;
            }else{
                pantiltMode = 0x03;
            }
            
            if ((X > slidelastF && X - slidelastF > 0.01) || X < slidefirstF) {
                slideMode = 0x00;
                
            }else{
                slideMode = 0x01;
            }
            break;
            
        default:
            break;
    }
    
//    NSLog(@"slidemode = %x %x", slideMode, pantiltMode);
    
    [self RealTimeTrackingWithSlidePostion:SlidePostion andPanPostion:(PanPostion + PanMaxValue) andTiltPostion:(TiltPostion + TiltMaxValue) andSlideMode:slideMode andPanTiltMode:pantiltMode];
}

#pragma mark - RealTimeTrackingWithSlidePostion 实时追踪-
- (void)RealTimeTrackingWithSlidePostion:(CGFloat)slidePostion andPanPostion:(CGFloat)panPostion andTiltPostion:(CGFloat)tiltPostion andSlideMode:(UInt8)slideMode andPanTiltMode:(UInt8)pantiltMode{
    
    pantiltMode = 0x03;
    slideMode = 0x01;
    
    [self.sendDataView sendBezierPreviewWithCb:appDelegate.bleManager.panCB andFrameHead:0x555F andFunctionNumber:0x06 andFuntionMode:pantiltMode panPostion:(Float32)panPostion tiltPostion:(Float32)tiltPostion WithStr:SendStr];
    [self.sendDataView sendBezierPreviewWithCb:appDelegate.bleManager.sliderCB andFrameHead:0xAAAF andFunctionNumber:0x06 andFunctionMode:slideMode sliderPostion:(Float32)slidePostion WithStr:SendStr];
    
//    NSLog(@"1212121212=%f, %f, %f", slidePostion, panPostion, tiltPostion);
    
}
//校验密码
- (void)delayMothed:(NSTimer *)timer{
    
    
    [appDelegate.bleManager writeValue:0xFFC0 characteristicUUID:0XFFC1 p:[timer userInfo] data:[@"920416920416" dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    
    
    
    
    if (dict) {
        for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
            NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];

            BOOL isSliderBool = [typeStr containsString:SLIDERINDENTEFIER];
            BOOL isX2Bool = [typeStr containsString:X2INDETEFIER];
            
            if (isSliderBool == YES && isX2Bool == NO) {
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
                }else{
                    [appDelegate.bleManager.CM cancelPeripheralConnection:cb];
                    
                }
                
            }else if (isSliderBool == NO && isX2Bool == YES){
                
                NSLog(@"%@, %@", dict[X2KEY], [NSString stringWithFormat:@"%@", cb.identifier]);
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
                    
                }else{
                    
                    [appDelegate.bleManager.CM cancelPeripheralConnection:cb];
                    
                }
                
            }
            
        }
    }
    

    
}
-(NSString *)getPrefixTypeString:(NSString *)str{
    
    NSRange range = {1, 4};
    NSString * string = [str substringWithRange:range];
    return string;
    
}

- (void)ReconnectThePer{
//    NSLog(@"%@", appDelegate.bleManager.peripherals);
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
//        [_receiveView initReceviceNotification];
    
    [self freeConnect];
    
}
- (void)freeConnect{
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    
    if (dict) {
        for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
            NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];

            BOOL isSliderBool = [typeStr containsString:SLIDERINDENTEFIER];
            BOOL isX2Bool = [typeStr containsString:X2INDETEFIER];
            if (isSliderBool == YES && isX2Bool == NO) {
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
                    [appDelegate.bleManager connectPeripheral: cb];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMothed:) userInfo:cb repeats:NO];
                }
                
            }else if (isSliderBool == NO && isX2Bool == YES){
                
                NSLog(@"%@, %@", dict[X2KEY], [NSString stringWithFormat:@"%@", cb.identifier]);
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
                    NSLog(@"%@", dict);
                    
                    [appDelegate.bleManager connectPeripheral: cb];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMothed:) userInfo:cb repeats:NO];
                }
                
            }
            
        }
    }
}

/**
 全部label的爸爸

 @param frame

 @return
 */
- (UILabel *)getLabelWithFrame:(CGRect)frame andTitle:(NSString *)title{
    
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.05];
    }else if(kDevice_Is_iPad){
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.03];
    }else{
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.04];
    }
    label.userInteractionEnabled = YES;
//    @"∨";＜＞v╲╱
    UILabel * slognLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 10)];
    slognLabel.center = CGPointMake(frame.size.width * 0.5, frame.size.height + 5);
    slognLabel.backgroundColor = [UIColor clearColor];
    slognLabel.textColor =COLOR(97, 97, 97, 1);
    slognLabel.textAlignment = NSTextAlignmentCenter;

    slognLabel.text = @"﹀";
    [label addSubview:slognLabel];
    return label;
    
}

- (void)chooseFunctionMode:(UITapGestureRecognizer *)tap{
    self.popover = [DXPopover new];
    iFFunctionPicker * picker = [[iFFunctionPicker alloc]init];
    picker.FunctionDelegate = self;
    [picker setInitValue:self.ifmodel.FunctionMode];
    [self.popover showAtView:tap.view withContentView:picker];
    
    
}
- (void)getFunctionIndex:(NSInteger)index{

    [self loopAction:index];
}

/**
 相应loop点击事件 选择timelapse video stopMotion
 
 @param tap 单击循环
 */
- (void)loopAction:(NSInteger)tap{
    
    [self initData];
    [loopModeView loopChangeTitle:tap];
    
    if (loopModeView.MODEL == MODEL_TIMELAPSE) {//选择Timelapse 模式
        PlayBtn.alpha = 1;
        self.StopMotionBtn.alpha = 0;
        self.ifmodel.FunctionMode = 0;
        _isloopBtn.alpha = 1;

        if (self.ifmodel.displayUnit == 0) {
            frameLabel.alpha = 1;
            TimelapseTimeLabel.alpha = 0;
            [backView chageLabel:self.ifmodel.totalFrames];
        }else if (self.ifmodel.displayUnit == 1){
            frameLabel.alpha = 0;
            TimelapseTimeLabel.alpha = 1;
            [backView changeLabelWithTimeLapseTime:self.ifmodel.TimelapseTotalTimes andFPS:[self.configs[self.ifmodel.fpsIndex] integerValue]];
        }
//        intervalLabel.alpha = 1;
        bufferLabel.alpha = 1;
        expoLabel.alpha = 1;
        timeLabel.alpha = 0;
        centerInfoView.alpha = 1;
        
        
    }else if (loopModeView.MODEL == MODEL_VIDEO){// video 模式
        PlayBtn.alpha = 1;
        self.StopMotionBtn.alpha = 0;
        self.ifmodel.FunctionMode = 1;
        _isloopBtn.alpha = 1;

        [backView changeLableWithTime:self.ifmodel.totalTimes];
        TimelapseTimeLabel.alpha = 0;
        
//        intervalLabel.alpha = 0;
        bufferLabel.alpha = 0;
        expoLabel.alpha = 0;
        
        frameLabel.alpha = 0;
        timeLabel.alpha = 1;
        centerInfoView.alpha = 0;

    
    }else if (loopModeView.MODEL == MODEL_STOPMOTION){// 选择stopMotion模式
        self.ifmodel.FunctionMode = 2;
        self.StopBtn.alpha = 0;
        
        PlayBtn.alpha = 0;
        self.StopMotionBtn.alpha = 1;
        _isloopBtn.alpha = 0;

        [backView chageLabel:self.ifmodel.totalFrames];
        
        TimelapseTimeLabel.alpha = 0;
//        intervalLabel.alpha = 0;
        bufferLabel.alpha = 0;
        expoLabel.alpha = 0;
        frameLabel.alpha = 1;
        timeLabel.alpha = 0;
        centerInfoView.alpha = 1;

    }
    [ud setObject:[NSNumber numberWithInteger:tap] forKey:FUNCTIONMODE];
    
    [self countAllpointTime];
    [self saveDataWithBOOLYES];
    [self initData];

}

/**
 选择interval 间隔时间

 @param tap 单击跳出选择视图
 */

- (void)chooseIntervalValue:(UITapGestureRecognizer *)tap{
    
    NSLog(@"%ld", tap.view.tag);
    NSInteger timeIndex = 0;
    if (tap.view.tag == ExposureLabelTag) {
        timeIndex = self.ifmodel.exposureSecond;
        
    }else if (tap.view.tag == BufferLabelTag){
        timeIndex = self.ifmodel.bufferSecond;
    }
    self.popover = [DXPopover new];
    [self.popover showAtView:tap.view withContentView:[self getChooseIntervalView:timeIndex withTag:tap.view.tag]];
}

/**
 选择FPS

 @param tap 单击弹出tableview 供选择
 */
- (void)fpschooseValue:(UITapGestureRecognizer *)tap{
    
    self.popover = [DXPopover new];
    [self updateTableViewFrame];
    CGPoint startPoint = CGPointMake(CGRectGetMidX(fpsLabel.frame), CGRectGetMaxY(fpsLabel.frame) + 5);
    
    [self.popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:self.tableView inView:self.view];

}

/**
 选择Frame

 @param tap tap description
 */
- (void)chooseFrameValue:(UITapGestureRecognizer *)tap{
    
    self.popover = [DXPopover new];
    iFFramePickerView * view = [[iFFramePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200))];
    [self.popover showAtView:tap.view withContentView:view];
    __weak typeof(self)weakSelf = self;
    view.Framedelegate =  weakSelf;
    
    if (self.ifmodel.totalFrames) {
        [view setInitValue:self.ifmodel.totalFrames];
    }else{
    [view setInitValue:100];
    }

    
}
- (void)chooseTimelapseTimeValue:(UITapGestureRecognizer *)tap{
    
    self.popover = [DXPopover new];
    iFTimePickerView * view = [[iFTimePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200)) WithFPS:[self.configs[self.ifmodel.fpsIndex]integerValue]];
    
    
    view.timelapseDelegate = self;
    
    [self.popover showAtView:tap.view withContentView:view];

    if (self.ifmodel.TimelapseTotalTimes) {
        
        [view setInitValue:self.ifmodel.TimelapseTotalTimes];
    }else{
        [view setInitValue:100 / 24.0f];
    }

}
/**
 选择时间

 @param tap tap description
 */
- (void)chooseTimeValue:(UITapGestureRecognizer *)tap{
    
    self.popover = [DXPopover new];
    iFTimePickerView * view = [[iFTimePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200)) WithFPS:0];
    view.timeDelegate = self;
    
    [self.popover showAtView:tap.view withContentView:view];
    
    if (self.ifmodel.totalTimes) {
        [view setInitValue:self.ifmodel.totalTimes];
    }else{

        [view setInitValue:100];
    }
    
}
#pragma mark - Framedelegate -
- (void)getFrame:(NSInteger)sum{
    
    frameLabel.text = [NSString stringWithFormat:@"Frame:%ld", (long)sum];
    [backView chageLabel:sum];
    self.ifmodel.totalFrames = sum;
    [ud setObject:[NSNumber numberWithInteger:sum] forKey:TOTALFRAMES];
    [ud synchronize];
    
    NSLog(@"frame");
    [self saveDataWithBOOLYES];
    [self initData];
    [self countAllpointTime];
    
    
}
- (void)getTimelapseTime:(CGFloat)totalTime{
    
    TimelapseTimeLabel.text = [NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimelapseTimeWith:totalTime andFPS:[self.configs[self.ifmodel.fpsIndex]integerValue]]];
    self.ifmodel.TimelapseTotalTimes = totalTime;
    self.ifmodel.totalFrames = totalTime * [self.configs[self.ifmodel.fpsIndex] integerValue];
    
    [backView changeLabelWithTimeLapseTime:totalTime andFPS:[self.configs[self.ifmodel.fpsIndex] integerValue]];
    [ud setObject:[NSNumber numberWithFloat:totalTime] forKey:TIMELAPSETIME];
    [ud setObject:[NSNumber numberWithInteger:totalTime * [self.configs[self.ifmodel.fpsIndex] integerValue]] forKey:TOTALFRAMES];
    
    [self saveDataWithBOOLYES];
    [self initData];
    [self countAllpointTime];
    
}
#pragma mark - TimeDelegate - 
- (void)getTime:(NSInteger)totalSecond{
    NSLog(@"Time");
    
    timeLabel.text = [NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimeWith:totalSecond]];
    self.ifmodel.totalTimes = totalSecond;
    [ud setObject:[NSNumber numberWithInteger:totalSecond] forKey:TOTALTIMES];
    [backView changeLableWithTime:self.ifmodel.totalTimes];
    
    [self saveDataWithBOOLYES];
    [self initData];
    [self countAllpointTime];
    
    
}
- (void)updateTableViewFrame
{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.width = iFSize(100);
    self.tableView.frame = tableViewFrame;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.configs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.configs[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /********选择FPS和存储************/
    fpsLabel.text = self.configs[indexPath.row];
    [ud setObject:[NSNumber numberWithInteger:indexPath.row] forKey:FPSValue];
//    NSLog(@"TimelapseTotalTimes%@", self.configs[indexPath.row]);
    
//    NSLog(@"TimelapseTotalTimes%lf %ld", self.ifmodel.TimelapseTotalTimes, self.ifmodel.totalFrames);
    
    if (self.ifmodel.displayUnit == 1) {
//        NSLog(@"TimelapseTotalTimes%lf %ld", self.ifmodel.TimelapseTotalTimes, self.ifmodel.totalFrames);

        self.ifmodel.totalFrames = self.ifmodel.TimelapseTotalTimes * [self.configs[self.ifmodel.fpsIndex] integerValue];
        
        [backView changeLabelWithTimeLapseTime:self.ifmodel.TimelapseTotalTimes andFPS:[self.configs[indexPath.row] integerValue]];
        [ud setObject:[NSNumber numberWithInteger:self.ifmodel.TimelapseTotalTimes * [self.configs[indexPath.row] integerValue]] forKey:TOTALFRAMES];
        
    }
//    NSLog(@"TimelapseTotalTimes%lf %ld", self.ifmodel.TimelapseTotalTimes, self.ifmodel.totalFrames);

//    [ud setObject:[NSNumber numberWithFloat:totalTime] forKey:TIMELAPSETIME];
//    sleep(2);
    
//    NSLog(@"fps%@", [ud objectForKey:FPSValue]);
    [self saveDataWithBOOLYES];
    [self initData];
    
    [self.popover dismiss];
    [self countAllpointTime];
    
//    NSLog(@"TimelapseTotalTimes%lf %ld", self.ifmodel.TimelapseTotalTimes, self.ifmodel.totalFrames);

}

- (UIView *)getChooseIntervalView:(NSInteger)timeIndex withTag:(NSInteger)tag{
    
    
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iFSize(100), iFSize(200))];
    UIPickerView *timePicker;
    timePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, iFSize(100), iFSize(200))];
    timePicker.tag = tag;
    timePicker.delegate = self;
    timePicker.dataSource = self;
    [timePicker selectRow:timeIndex inComponent:0 animated:NO];
    [bgView addSubview:timePicker];
    return bgView;
}

#pragma mark - UIPicker Delegate
//选择器分为几块
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//选择器有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_timeArr count];
}
//每一行显示的内容
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *timelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    timelabel.text = [[NSString alloc] initWithFormat:@"%@s",[_timeArr objectAtIndex:row]];
    timelabel.textAlignment = NSTextAlignmentCenter;
    return timelabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

//    NSLog(@"%ld", pickerView.tag);
//    NSLog(@"%ld", pickerView.maskView.tag);
    NSLog(@"pickerView%ld", pickerView.tag);
    
    if (pickerView.tag == ExposureLabelTag) {
        expoLabel.text = [NSString stringWithFormat:@"Expo:%@s", [_timeArr objectAtIndex:row]];
        
        [ud setObject:[NSNumber numberWithInteger:row] forKey:EXPOSURE];
        
    }else if (pickerView.tag == BufferLabelTag){
        bufferLabel.text = [NSString stringWithFormat:@"Buffer:%@s", [_timeArr objectAtIndex:row]];
        [ud setObject:[NSNumber numberWithInteger:row] forKey:BUFFERSECOND];
        
    }
//    intervalLabel.text = [NSString stringWithFormat:@"Interval:%@s", [_timeArr objectAtIndex:row]];
    //    [ud setObject:[NSNumber numberWithInteger:row] forKey:INTERVALIndex];
    [self saveDataWithBOOLYES];
    [self initData];
    [self countAllpointTime];
}

- (void)touchEndChangeTime{
    [self countAllpointTime];

//    NSLog(@"aaaaaaaaaaaaaaaa");
    
}
- (void)changeDistanceValue:(CGFloat)value{
    
#warning slidelength 没有了!!!!!!!-----
    if (MODEL == MODEL_SLIDER) {
        [sliderValueView changeValueWithTag:sliderValueView.tag andValue:value * SlideConunt(self.ifmodel.slideCount)];
        [ud setObject:SlideCustomSlider.uplabel.text forKey:UpSlideViewValue];
        [ud setObject:SlideCustomSlider.downlabel.text forKey:DownSlideViewValue];
//        NSLog(@"changeDistanceValue1Slider%@", SlideCustomSlider.uplabel.text);
//        NSLog(@"changeDistanceValue2Slider%@", SlideCustomSlider.downlabel.text);
    }else if (MODEL == MODEL_PAN){
        [panValueView changeValueWithTag:panValueView.tag andValue:(PanMaxValue * 2) * value];
//        NSLog(@"changeDistanceValue%@", PanCustomSlider.uplabel.text);
        [ud setObject:PanCustomSlider.uplabel.text forKey:UpPanViewValue];
        [ud setObject:PanCustomSlider.downlabel.text forKey:DownPanViewValue];
//        NSLog(@"changeDistanceValue1pan%@", PanCustomSlider.uplabel.text);
//        NSLog(@"changeDistanceValue2pan%@", PanCustomSlider.downlabel.text);
        
    }else if (MODEL == MODEL_TILT) {
        [tiltValueView changeValueWithTag:tiltValueView.tag andValue:TiltMaxValue * 2 * value];
        [ud setObject:TiltCustomSlider.uplabel.text forKey:UpTiltViewValue];
        [ud setObject:TiltCustomSlider.downlabel.text forKey:DownTiltViewValue];
//        NSLog(@"changeDistanceValue1Tilt%@", TiltCustomSlider.uplabel.text);
//        NSLog(@"changeDistanceValue2Tilt%@", TiltCustomSlider.downlabel.text);
    }
    
    [self saveDataWithBOOLYES];
    [self initData];
    
    
}

#pragma mark -- 选择值---
- (void)chooseValue:(UIPanGestureRecognizer *)pan {

    iFBazierView * ifView;
    if (MODEL == MODEL_SLIDER) {
        ifView = SliderBazierView;
        
    }else if (MODEL == MODEL_PAN){
        ifView = PanBazierView;
        
    }else{
        ifView = TiltBazierView;
        
    }
    static UILabel * label;
    
    NSMutableArray * PointArray = [NSMutableArray arrayWithArray:ifView.PointArray];
    CGPoint po = [pan translationInView:self.view];
    
    static CGPoint center;
    if (pan.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"开始1111111111111111111111");
        isMoveInsertView = YES;
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, iFSize(40), iFSize(40));
        label.backgroundColor = [UIColor redColor];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = iFSize(20);
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:iFSize(13)];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        center= pan.view.center;
    }
    
    pan.view.center = CGPointMake(center.x + po.x, center.y);
    
    if (pan.view.center.x <leftLimit) {
        pan.view.center = CGPointMake(leftLimit , center.y);
    }
    if (pan.view.center.x > rightLimit + leftLimit) {
        pan.view.center = CGPointMake(rightLimit + leftLimit , center.y);
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"结束1111111111111111111111111");
        isMoveInsertView = NO;
        
        [label removeFromSuperview];
        
    }
    
    label.center = CGPointMake(pan.view.center.x , pan.view.center.y - iFSize(100));
    

    
    CGPoint point1;
    CGPoint point2;
   

    for (int i = 0 ; i < PointArray.count; i++) {
        if (i < PointArray.count - 1) {
            point1 = [PointArray[i] CGPointValue];
            point2 = [PointArray[i + 1] CGPointValue];

            
            if (point1.x < pan.view.center.x && point2.x > pan.view.center.x) {
                insertIndex = i + 1;
                XValue = pan.view.center.x;
            }
//            NSLog(@"point1 = %@", NSStringFromCGPoint(point1));
//            NSLog(@"point2 = %@", NSStringFromCGPoint(point2));
        }else{
            point1 = [PointArray[i] CGPointValue];
            if (pan.view.center.x > point1.x) {
                insertIndex = 9999;
                XValue = pan.view.center.x;
            }
        }
     
//        NSLog(@"XValue = %lf", XValue);
    }
    
    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = self.ifmodel.totalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)self.ifmodel.totalFrames;
    }else{
        NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
        if (self.ifmodel.displayUnit == 1) {
            TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)self.ifmodel.totalFrames;
        }
    }
//    NSLog(@"%@", [NSString stringWithFormat:@"%.0f", (XValue - iFSize(13.34)) / SliderBazierView.frame.size.width * TotalFrames]);
    label.text = [NSString stringWithFormat:@"%.0f", (XValue - leftLimit) / SliderBazierView.frame.size.width * TotalFrames];
    
//    if (pan.state == UIGestureRecognizerStateEnded) {
//
//
        [self moveInsertViewRealTimepreViewWithPointX:XValue - leftLimit];
    NSLog(@"moveInsertViewRealTimepreViewWithPointX1");
    
//    }
    

}
/**
 *  判断插入的index
 *
 *  @param X X description
 *
 *  @return return value description
 */
- (NSInteger)judgeInsertIndex:(CGFloat)X{
    
    
    iFBazierView * ifView;
    
    if (MODEL == MODEL_SLIDER) {
        ifView = SliderBazierView;
        
    }else if (MODEL == MODEL_PAN){
        ifView = PanBazierView;
        
    }else{
        ifView = TiltBazierView;
    }
    NSMutableArray * PointArray = [NSMutableArray arrayWithArray:ifView.PointArray];
    
    CGPoint point1;
    CGPoint point2;
    
    for (int i = 0 ; i < PointArray.count; i++) {
        if (i < PointArray.count - 1) {
            point1 = [PointArray[i] CGPointValue];
            point2 = [PointArray[i + 1] CGPointValue];
            if (point1.x < X && point2.x > X) {
                insertIndex = i + 1;
                XValue = X;
            }
        }else{
            point1 = [PointArray[i] CGPointValue];
            if (X > point1.x) {
                insertIndex = 9999;
                XValue = X;
            }
        }
    }
    return insertIndex;
}
- (void)chooseCurve:(UIButton *)btn{
    
    [intervalView removeFromSuperview];
    intervalView= [[iFS1A3_InsertView alloc]initWithFrame:CGRectMake(0,0 ,rightLimit, downLimit - topLimit)];
    intervalView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:ALPHA];
    [self.view addSubview:intervalView];
    
    [intervalView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftLimit);
        make.top.mas_equalTo(topLimit);
        make.size.mas_equalTo(CGSizeMake(rightLimit, downLimit - topLimit));
    }];
    
        if (btn.tag == SlideTag) {
        MODEL = MODEL_SLIDER;
            SliderBtn.actionBtn.selected = YES;
            PanBtn.actionBtn.selected = NO;
            TiltBtn.actionBtn.selected = NO;
            
            [TiltBazierView hideControlPointAndLine];
            [PanBazierView hideControlPointAndLine];
            [self.view bringSubviewToFront:PanBazierView];
            [self.view bringSubviewToFront:TiltBazierView];
            
            [self.view bringSubviewToFront:intervalView];
            [self.view bringSubviewToFront:backView];
            [self.view bringSubviewToFront:SliderBazierView];
            
//            [self.view bringSubviewToFront:insertView];
            [self.view bringSubviewToFront:backBtn];
            
        TiltCustomSlider.alpha = 0;
        SlideCustomSlider.alpha = 1;
        PanCustomSlider.alpha = 0;
            
    }else if (btn.tag == PanTag){
        MODEL = MODEL_PAN;
        SliderBtn.actionBtn.selected = NO;
        PanBtn.actionBtn.selected = YES;
        TiltBtn.actionBtn.selected = NO;
        [SliderBazierView hideControlPointAndLine];
        [TiltBazierView hideControlPointAndLine];
        [self.view bringSubviewToFront:TiltBazierView];
        [self.view bringSubviewToFront:SliderBazierView];
        
        [self.view bringSubviewToFront:intervalView];
        [self.view bringSubviewToFront:backView];

        [self.view bringSubviewToFront:PanBazierView];
        
//        [self.view bringSubviewToFront:insertView];
        [self.view bringSubviewToFront:backBtn];
        TiltCustomSlider.alpha = 0;
        SlideCustomSlider.alpha = 0;
        PanCustomSlider.alpha = 1;
;
    }else{
        MODEL = MODEL_TILT;
        SliderBtn.actionBtn.selected = NO;
        PanBtn.actionBtn.selected = NO;
        TiltBtn.actionBtn.selected = YES;
        [SliderBazierView hideControlPointAndLine];
        [PanBazierView hideControlPointAndLine];
        [self.view bringSubviewToFront:SliderBazierView];
        [self.view bringSubviewToFront:PanBazierView];
        [self.view bringSubviewToFront:intervalView];
        [self.view bringSubviewToFront:backView];

        [self.view bringSubviewToFront:TiltBazierView];
        
//        [self.view bringSubviewToFront:insertView];
        [self.view bringSubviewToFront:backBtn];

        TiltCustomSlider.alpha = 1;
        SlideCustomSlider.alpha = 0;
        PanCustomSlider.alpha = 0;
    }
    [self judgeInsertIndex:XValue];
//    if (btn) {
//        [self moveInsertViewRealTimepreViewWithPointX:XValue];
//    NSLog(@"moveInsertViewRealTimepreViewWithPointX2");
    
//    }
    
}
/**
 *  更新视图的位置
 */
- (void)refeshView{
    
    [partView removeFromSuperview];
    
    partView = [[UIView alloc]initWithFrame:CGRectMake(leftLimit,Ylenth * 0.15 ,rightLimit, downLimit - topLimit)];
    partView.backgroundColor = [UIColor blackColor];
    partView.alpha = ALPHA;
    [self.view addSubview:partView];
    
    switch (MODEL) {
        case MODEL_SLIDER:
            
            [self.view bringSubviewToFront:SliderBazierView];
            [self.view bringSubviewToFront:backView];

            [self.view bringSubviewToFront:insertView];
            [self.view bringSubviewToFront:backBtn];

            break;
        case MODEL_PAN:
            [self.view bringSubviewToFront:PanBazierView];
            [self.view bringSubviewToFront:backView];

            [self.view bringSubviewToFront:insertView];
            [self.view bringSubviewToFront:backBtn];

            break;
            
        case MODEL_TILT:

            [self.view bringSubviewToFront:TiltBazierView];
            [self.view bringSubviewToFront:backView];

            [self.view bringSubviewToFront:insertView];
            [self.view bringSubviewToFront:backBtn];

            break;
        default:
            break;
    }
}
/**
 *  插入值
 */
- (void)insertValue{
    
    iFBazierView * ifView;
    
    switch (MODEL) {
        case MODEL_SLIDER:
            ifView = SliderBazierView;
            
            break;
        case MODEL_PAN:
            ifView = PanBazierView;
            
            break;
        case MODEL_TILT:
            ifView = TiltBazierView;
            
            break;
        default:
            break;
    }

    if (!insertIndex) {
        insertIndex = 1;
    }
    [self moveInsertViewRealTimepreViewWithPointX:XValue];
    [ifView insertPoint:XValue andInsertIndex:insertIndex andYdistance:self.YValue];
}
/**
 *  get到指定曲线
 *
 *  @return return value description
 */
- (iFBazierView *)AxieModelView{
    iFBazierView * ifView;
    
    switch (MODEL) {
        case MODEL_SLIDER:
            ifView = SliderBazierView;
            
            break;
        case MODEL_PAN:
            ifView = PanBazierView;
            
            break;
        case MODEL_TILT:
            ifView = TiltBazierView;
            
            break;
        default:
            break;
    }
    return ifView;
}


/**
 配置发送的数组Frame Time 位置信息参数
 */
- (void)GetAllNsArray{
    
    [self initData];
    
    NSArray * SlideoldFrameArray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray][0];
    NSArray * SlideoldPostionArray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray][1];
    NSArray * PanoldFrameArray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray][0];
    NSArray * PanoldPostionArray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray][1];
    NSArray * TiltoldFrameArray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray][0];
    NSArray * TiltoldPostionArray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray][1];
    /*
     a = (Height - GETAXIS_Trace_Calculate(X, SlidePos, SlideT)) / Height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
     b = (Height - GETAXIS_Trace_Calculate(X, PanPos, PanT)) / Height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue;
     c = (Height - GETAXIS_Trace_Calculate(X, TiltPos, TiltT)) / Height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue;
     */
    
    
    UInt32 TotalFrames;
    NSInteger intervaltime;
    
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = self.ifmodel.totalTimes;
        intervaltime = 1;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        intervaltime = 1;
        TotalFrames = (UInt32)self.ifmodel.totalFrames;
        }else{
            intervaltime = finalRunningTime;
            
            NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
            if (self.ifmodel.displayUnit == 1) {
                TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
            }else{
                TotalFrames = (UInt32)self.ifmodel.totalFrames;
            }
    }
    if (isTouchPreview) {
        TotalFrames = (UInt32)preViewSecond;
    }
    for (NSNumber * value in SlideoldFrameArray) {
        CGFloat a = [value floatValue] / SliderBazierView.frame.size.width * TotalFrames * intervaltime;
        [SlidenewFrameArray addObject:[NSNumber numberWithFloat:a]];
    }
    
    for (NSNumber * value in PanoldFrameArray) {
        CGFloat a = [value floatValue] / PanBazierView.frame.size.width * TotalFrames * intervaltime;
        [PannewFrameArray addObject:[NSNumber numberWithFloat:a]];
    }
    for (NSNumber * value in TiltoldFrameArray) {
        CGFloat a = [value floatValue] / TiltBazierView.frame.size.width * TotalFrames * intervaltime;
        [TiltnewFrameArray addObject:[NSNumber numberWithFloat:a]];
    }
    
//    NSLog(@"\r\n%@\r\n%@\r\n%@", SlidenewFrameArray, PannewFrameArray, TiltnewFrameArray);
    
    for (NSNumber * value in SlideoldPostionArray) {
        CGFloat b = (SliderBazierView.frame.size.height - [value floatValue]) / SliderBazierView.frame.size.height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue;
        if (b < 0) {
            b = 0;
        }
        [SlidenewPostionArray addObject:[NSNumber numberWithFloat:b]];
    }
    
    for (NSNumber * value in PanoldPostionArray) {
        CGFloat b = (PanBazierView.frame.size.height - [value floatValue]) / PanBazierView.frame.size.height * (self.ifmodel.upPanValue - self.ifmodel.downPanValue) + self.ifmodel.downPanValue + PanMaxValue;
        [PannewPostionArray addObject:[NSNumber numberWithFloat:b]];
    }
    for (NSNumber * value in TiltoldPostionArray) {
        CGFloat b = (TiltBazierView.frame.size.height - [value floatValue]) / TiltBazierView.frame.size.height * (self.ifmodel.upTiltValue - self.ifmodel.downTiltValue) + self.ifmodel.downTiltValue + TiltMaxValue;
        [TiltnewPostionArray addObject:[NSNumber numberWithFloat:b]];
    }
    
    
}
#pragma mark - 暂停

/**
 放弃指令（暂时取代放弃指令）
 */
- (void)PauseMoveWithInsertView{
    

    
//    [SVProgressHUD dismiss];
//    [iFTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(PauseAction:) WithisOn:isPauseOn];
//    
//    processView.alpha = 0;
//    isPauseOn = YES;
    [self StopAction];
    
}
static int pasuei = 0;

- (void)PauseAction:(NSTimer *)timer{
    pasuei++;
    NSLog(@"暂停");
//    isTouchPreview = NO;
    isTouchReturnBack = NO;
    
    if (pasuei >= 10) {
        pasuei = 0;
        self.StopBtn.alpha = 0;
        
        if (loopModeView.MODEL == MODEL_STOPMOTION) {
            self.PlayBtn.alpha = 0;
        }else{
        
            self.PlayBtn.alpha = 1;
        }
        timer.fireDate = [NSDate distantFuture];
        
        isPauseOn = NO;
        [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:0x00 WithStr:SendStr andisLoop:0x00];
        [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:0x00 WithStr:SendStr andisLoop:0x00];
    }
    
}

#pragma mark - 停止
- (void)StopAction{
    
    slideSendTimeTimer.fireDate = [NSDate distantFuture];
    slideSendPostionTimer.fireDate = [NSDate distantFuture];
    sendStopMotionTimer.fireDate = [NSDate distantFuture];
    pansendTimeTimer.fireDate = [NSDate distantFuture];
    pansendPostionTimer.fireDate = [NSDate distantFuture];
    tiltsendTimeTimer.fireDate = [NSDate distantFuture];
    tiltsendPostionTimer.fireDate = [NSDate distantFuture];
    timeCorrectTimer.fireDate = [NSDate distantFuture];
    sendSettingsTimer.fireDate = [NSDate distantFuture];
    clearSettingsTimer.fireDate = [NSDate distantFuture];
    showprocessTimer.fireDate = [NSDate distantFuture];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    
    [SVProgressHUD dismiss];
//    [iFTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(PauseAction:) WithisOn:isPauseOn];
    pauseTimer.fireDate = [NSDate distantPast];
    
    
    self.StopBtn.alpha = 0;
    if (loopModeView.MODEL == MODEL_STOPMOTION) {
        self.PlayBtn.alpha = 0;
        
    }else{
        
        self.PlayBtn.alpha = 1;
    }

    processView.alpha = 0;

    isPlayOn = NO;
    isStopOn = YES;
    isTouchReturnBack = NO;
    if (isTouchPreview) {
        isTouchPreview = NO;
        loopModeView.MODEL = self.ifmodel.FunctionMode;
    }
    
    self.PauseBtn.alpha = 0;
    self.preViewBtn.alpha = 1;
    
}
static int stopi = 0;

- (void)stopActionTimer:(NSTimer *)timer{
    NSLog(@"停止");
    stopi++;
    if (stopi >= 10) {
        stopi = 0;
        timer.fireDate = [NSDate distantFuture];
        isStopOn = NO;
        [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:0x00 WithStr:SendStr andisLoop:0x00];
        [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:0x00 WithStr:SendStr andisLoop:0x00];
    }
}
- (void)sendDataWithNsArrayforCount:(NSArray *)array{
    for (NSArray * sarray in array) {
        [self.sendDataView sendBezierTimeWithCb:appDelegate.bleManager.sliderCB andFrameHead:0xAAAF andFunctionNumber:0xA0 andTimeArray:sarray WithStr:SendStr];
    }
}
#warning - sendArray发送数组------------
- (void)sendArray:(NSArray *)array andFrameHead:(UInt16)framehead andfunNumber:(UInt8)funNum withCB:(CBPeripheral *)cb YesOrNo:(BOOL)on{
//    if (on) {
    
        [self.sendDataView sendBezierTimeWithCb:cb andFrameHead:framehead andFunctionNumber:funNum andTimeArray:array WithStr:SendStr];
        
//    }
}


- (void)sendAllPointsNsArray:(NSArray *)array{
    
    int snumber = loopi % array.count;
    
    NSArray * SlideShiftHeadArray = @[@0xA0, @0xA1, @0xA2, @0xA3, @0xA4, @0xA5, @0xA6, @0xA7];
    NSArray * SlideFrameHeadArray = @[@0xA8, @0xA9, @0xAA, @0xAB, @0xAC, @0xAD, @0xAE, @0xAF];
    NSArray * PanShitfHeadArray = @[@0x50, @0x51, @0x52, @0x53, @0x54, @0x55, @0x56, @0x57];
    NSArray * PanFrameHeadArray = @[@0x58, @0x59, @0x5A, @0x5B, @0x5C, @0x5D, @0x5E, @0x5F];
    NSArray * TiltShitfHeadArray = @[@0x60, @0x61, @0x62, @0x63, @0x64, @0x65, @0x66, @0x67];
    NSArray * TiltFrameHeadArray = @[@0x68, @0x69, @0x6A, @0x6B, @0x6C, @0x6D, @0x6E, @0x6F];
    
    [self sendArray:array[snumber] andFrameHead:OXAAAF andfunNumber:(UInt8)SlideShiftHeadArray withCB:CBSLIDE YesOrNo:YES];
    [self sendArray:array[snumber] andFrameHead:OXAAAF andfunNumber:(UInt8)SlideFrameHeadArray[snumber] withCB:CBSLIDE YesOrNo:YES];
    [self sendArray:array[snumber] andFrameHead:OX555F andfunNumber:(UInt8)PanShitfHeadArray withCB:CBPanTilt YesOrNo:YES];
    [self sendArray:array[snumber] andFrameHead:OX555F andfunNumber:(UInt8)PanFrameHeadArray withCB:CBPanTilt YesOrNo:YES];
    [self sendArray:array[snumber] andFrameHead:OX555F andfunNumber:(UInt8)TiltShitfHeadArray withCB:CBPanTilt YesOrNo:YES];
    [self sendArray:array[snumber] andFrameHead:OX555F andfunNumber:(UInt8)TiltFrameHeadArray withCB:CBPanTilt YesOrNo:YES];
  
}

- (void)showLowbatteryAttention{
    
//    NSInteger interval1 = ([_timeArr[self.ifmodel.intervalTimeIndex] integerValue]);
    NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
    UInt32 TotalFrames;
    if (self.ifmodel.displayUnit == 1) {
        TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
    }else{
        TotalFrames = (UInt32)self.ifmodel.totalFrames;
    }
    CGFloat runtime = 0.0, activeRunningTime = 0.0;

    if (_status == StatusSLIDEandX2AllConnected) {
        CGFloat x2time,slidetime;
        x2time = _receiveView.X2battery * FullRunningTime / 100.0f;
        slidetime = _receiveView.slideBattery * FullRunningTime / 100.0f;
        runtime = x2time < slidetime ? x2time : slidetime;
        if (loopModeView.MODEL == MODEL_TIMELAPSE) {
//            NSLog(@"%ld", TotalFrames * finalRunningTime);
          
            activeRunningTime = TotalFrames * finalRunningTime;
            
        }else if (loopModeView.MODEL == MODEL_VIDEO){
//            NSLog(@"%f", self.ifmodel.totalTimes);
            activeRunningTime = self.ifmodel.totalTimes;
        }else{
            
        }
    }else if (_status == StatusSLIDEOnlyConnected){
        runtime = _receiveView.slideBattery * FullRunningTime / 100.0f;

        if (loopModeView.MODEL == MODEL_TIMELAPSE) {
//            NSLog(@"%ld", TotalFrames * finalRunningTime);
            if (_receiveView.slideBattery > 0) {
                activeRunningTime = TotalFrames * finalRunningTime;
                
            }
        }else if (loopModeView.MODEL == MODEL_VIDEO){
//            NSLog(@"%f", self.ifmodel.totalTimes);
            activeRunningTime = self.ifmodel.totalTimes;
            
        }else{
            
        }
    
    }else if (_status == StatusX2OnlyConnected){
        runtime = _receiveView.X2battery * FullRunningTime / 100.0f;

        if (loopModeView.MODEL == MODEL_TIMELAPSE) {

//            NSLog(@"%ld", TotalFrames * finalRunningTime);
            if (_receiveView.X2battery > 0) {
                activeRunningTime = TotalFrames * finalRunningTime;
                
            }
        }else if (loopModeView.MODEL == MODEL_VIDEO){
            NSLog(@"%f", self.ifmodel.totalTimes);
            activeRunningTime = self.ifmodel.totalTimes;
            
        }else{
            
        }
        
    }else{
    
    }
    if (runtime < activeRunningTime) {

#warning 要改英文!!!!!!
        UIAlertController * alertView = [iFAlertController showAlertControllerWith:NSLocalizedString(Timeline_WarmTips, nil) Message:NSLocalizedString(Timeline_PowerAlarm, nil) SureButtonTitle:Timeline_OK SureAction:^(UIAlertAction * action) {
        }];
        [self presentViewController:alertView animated:YES completion:nil];
    }
    NSLog(@"%lf, %lf", runtime, activeRunningTime);
}
#pragma mark - 开始
+ (NSArray *)recursionGetsubLevelPointsWithSuperPoints:(NSArray *)points progress:(CGFloat)progress{
    // 得到最终的点 正确结束递归
    if (points.count == 1) return points;
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < points.count-1; i++) {
        // 第一个点
        NSValue *preValue = [points objectAtIndex:i];
        CGPoint prePoint = preValue.CGPointValue;
        // 第二个点
        NSValue *lastValue = [points objectAtIndex:i+1];
        CGPoint lastPoint = lastValue.CGPointValue;
        
        // 两点坐标差
        CGFloat diffX = lastPoint.x-prePoint.x;
        CGFloat diffY = lastPoint.y-prePoint.y;
        
        // 根据当前progress得出高一阶的点
        CGPoint currentPoint = CGPointMake(prePoint.x+diffX*progress, prePoint.y+diffY*progress);
        [tempArr addObject:[NSValue valueWithCGPoint:currentPoint]];
    }
    // 继续下一次递归过程
    return [self recursionGetsubLevelPointsWithSuperPoints:tempArr progress:progress];
}

- (void)StartMoveWithInsertView{
//    NSArray * array = @[Point(0, 262.5), Point(40, 262.5), Point(573.63999999, 0), Point(613.639999999, 0)];
//    NSLog(@"%@", [self recursionGetsubLevelPointsWithSuperPoints:array progress:0.5]);
    
    [[LuaContext currentContext] createJson:@"" args:@[]];
    
    pasueTotaltime = 0;
    processView.pauseBtn.actionBtn.selected = NO;
    
    pauseTimer.fireDate = [NSDate distantFuture];
    [self countAllpointTime];
    
    self.ifmodel.focalIndex = [[ud objectForKey:FPSValue] integerValue];

    if (!isTouchPreview) {
        
    if (loopModeView.MODEL == MODEL_VIDEO) {
    CGFloat RealTimes = self.ifmodel.totalTimes;
        if (RealTimes == 0) {
            RealTimes = 1;
        }
    while (![self countAllVideoTime:RealTimes]) {
        RealTimes++;
    }
        
    if (RealTimes > self.ifmodel.totalTimes) {

        UIAlertController * alertView = [iFAlertController showAlertControllerWith:@"warm Tips" Message:[NSString stringWithFormat:NSLocalizedString(@"Timeline_VideoTimeWaring", nil), RealTimes] SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
        }];
        [self presentViewController:alertView animated:YES completion:nil];
        
        return;
    }else{
        NSLog(@"正常启动");
        }
    }
    }
    [partView removeFromSuperview];
    [SliderBazierView hideControlPointAndLine];
    [TiltBazierView hideControlPointAndLine];
    [PanBazierView hideControlPointAndLine];
    
    if (_status == StatusSLIDEandX2AllDisConnected) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_NoDeviceWarning, nil)];
        self.StopBtn.alpha = 0;
        self.preViewBtn.alpha = 1;
        
    }else{
        isPauseOn = NO;
        isPlayOn = YES;
        
        if (isTouchReturnBack) {
            
            [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];
        }else{
            
            [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_Preparing, nil)];
        }
    }
    [self initData];
    [SlidenewPostionArray removeAllObjects];
    [SlidenewFrameArray removeAllObjects];
    [PannewFrameArray removeAllObjects];
    [PannewPostionArray removeAllObjects];
    [TiltnewFrameArray removeAllObjects];
    [TiltnewPostionArray removeAllObjects];
    
#pragma mark - （02）发送清除数据的指令 -
    if (isPlayOn) {
        PlayBtn.alpha = 0;
//        if (loopModeView.MODEL != MODEL_STOPMOTION) {
        self.StopBtn.alpha = 1;
//        }
        [self sendClearOrder];
#pragma mark - (03)发送配置参数 -
        [self performSelector:@selector(dalaysendSetParams) withObject:nil afterDelay:0.2f];
        [self GetAllNsArray];
    }
}
- (void)dalaysendSetParams{
    
    sendSettingsTimer.fireDate = [NSDate distantPast];
}

/**
 发送slide的位置参数
 
 @param timer <#timer description#>
 */
- (void)sendSlidetimer:(NSTimer *)timer{
    NSLog(@"SendSlideTimer%d", _receiveView.slidebezierPosParam);
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * SlideShiftHeadArray = @[@0xA0, @0xA1, @0xA2, @0xA3, @0xA4, @0xA5, @0xA6, @0xA7];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.slidebezierPosParam]];
    
    NSArray * slideArray = [self getNewArray:SlidenewPostionArray];
    
    if (a == slideArray.count) {
        
        slideSendPostionTimer.fireDate = [NSDate distantFuture];
        slideSendTimeTimer.fireDate = [NSDate distantPast];
        
    }else{
        if (a <= 7 ) {
            [self sendArray:slideArray[a] andFrameHead:OXAAAF andfunNumber:[SlideShiftHeadArray[a] intValue]withCB:CBSLIDE YesOrNo:YES];
//            NSLog(@"%ld ");
        }
        
    }

    
}

/**
 发送slide的时间参数
 
 @param timer timer description
 */
- (void)sendSlideTimeTimer:(NSTimer *)timer{
    NSLog(@"sendSlideTimeTimer%d", _receiveView.slidebezierTimeParam);
    [self getConntionStatus];
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * SlideFrameHeadArray = @[@0xA8, @0xA9, @0xAA, @0xAB, @0xAC, @0xAD, @0xAE, @0xAF];
    
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.slidebezierTimeParam]];
    NSArray * slideArray = [self getNewArray:SlidenewFrameArray];
    
    if (a == slideArray.count) {
        
        slideSendTimeTimer.fireDate = [NSDate distantFuture];
        if (CBPanTilt.state == CBPeripheralStateConnected) {
            isHadSendSlideInfo = YES;
        }else{
            returnZeroTimer.fireDate = [NSDate distantPast];
        }
        
    }else{
        if (a <= 7) {
            [self sendArray:slideArray[a] andFrameHead:OXAAAF andfunNumber:[SlideFrameHeadArray[a] intValue] withCB:CBSLIDE YesOrNo:YES];
        }
    }
}

/**
 发送pan的位置参数
 
 @param timer timer description
 */

- (void)SendpanTimer:(NSTimer *)timer{
    NSLog(@"SendpanTimer %d", _receiveView.panbezierPosParam);
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * PanShitfHeadArray = @[@0x50, @0x51, @0x52, @0x53, @0x54, @0x55, @0x56, @0x57];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.panbezierPosParam]];
    NSArray * panArray = [self getNewArray:PannewPostionArray];
    
    
//    NSLog(@"numnber = %@", array[a]);
#warning bug  崩溃！！！
    
    if (a == panArray.count) {
        pansendPostionTimer.fireDate = [NSDate distantFuture];
        pansendTimeTimer.fireDate = [NSDate distantPast];
    }else{
   if (a <= 7 ) {
        
        [self sendArray:panArray[a] andFrameHead:OX555F andfunNumber:[PanShitfHeadArray[a] intValue] withCB:CBPanTilt YesOrNo:YES];
       
   }
   }
}
/**
 发送pan的时间参数
 
 @param timer timer description
 */
- (void)sendpanTimeTimer:(NSTimer *)timer{
    NSLog(@"sendpanTimeTimer%d", _receiveView.panbezierTimeParam);
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * PanFrameHeadArray = @[@0x58, @0x59, @0x5A, @0x5B, @0x5C, @0x5D, @0x5E, @0x5F];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.panbezierTimeParam]];
    NSArray * panArray = [self getNewArray:PannewFrameArray];
//    NSLog(@"PannewFrameArray%@", panArray);
    
    
    if (a == panArray.count) {
        pansendTimeTimer.fireDate = [NSDate distantFuture];
        tiltsendPostionTimer.fireDate = [NSDate distantPast];
    }else{
        if (a <= 7 ) {
        [self sendArray:panArray[a] andFrameHead:OX555F andfunNumber:[PanFrameHeadArray[a] intValue] withCB:CBPanTilt YesOrNo:YES];
        }
    }
}

/**
 发送tilt的位置参数
 
 @param timer timer description
 */
- (void)sendtiltPostionTimer:(NSTimer *)timer{
    
    NSLog(@"sendtiltPostionTimer%d", _receiveView.tiltbezierPosParam);
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * TiltShitfHeadArray = @[@0x60, @0x61, @0x62, @0x63, @0x64, @0x65, @0x66, @0x67];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.tiltbezierPosParam]];
    
    NSArray * tiltArray = [self getNewArray:TiltnewPostionArray];
//    NSLog(@"TiltnewPostionArray%@", tiltArray);
    if (a == tiltArray.count) {
        tiltsendPostionTimer.fireDate = [NSDate distantFuture];
        tiltsendTimeTimer.fireDate = [NSDate distantPast];
    }else{
        if (a <= 7 ) {
        [self sendArray:tiltArray[a] andFrameHead:OX555F andfunNumber:[TiltShitfHeadArray[a] intValue] withCB:CBPanTilt YesOrNo:YES];
        }
    }
}

/**
 发送tilt时间参数
 
 @param timer timer description
 */
- (void)sendtiltTimeTimer:(NSTimer *)timer{
    NSLog(@"sendtiltTimeTimer%d", _receiveView.tiltbezierTimerParam);
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * TiltFrameHeadArray = @[@0x68, @0x69, @0x6A, @0x6B, @0x6C, @0x6D, @0x6E, @0x6F];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.tiltbezierTimerParam]];
    NSArray * tiltArray = [self getNewArray:TiltnewFrameArray];
//    NSLog(@"TiltnewFrameArray%@", tiltArray);
    
    if (a == tiltArray.count) {
        timer.fireDate = [NSDate distantFuture];
        
//        NSTimer * timer1 = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:@selector(delayTimer:) userInfo:nil repeats:YES];
//        timer1.fireDate = [NSDate distantPast];
        returnZeroTimer.fireDate = [NSDate distantPast];

        
    }else{
        if (a <= 7) {
        NSLog(@"a = %ld", a);
        [self sendArray:tiltArray[a] andFrameHead:OX555F andfunNumber:[TiltFrameHeadArray[a] intValue] withCB:CBPanTilt YesOrNo:YES];
        }
    }
}
- (void)delayTimer:(NSTimer *)timer{

//    if (isHadSendSlideInfo == YES) {
        timer.fireDate = [NSDate distantFuture];
        returnZeroTimer.fireDate = [NSDate distantPast];
//        isHadSendSlideInfo = NO;
    
//    }
}

/**
 发送校准开始时间
 
 @param timer timer description
 */
static int scount = 0;

- (void)sendtimecorrectTimer:(NSTimer *)timer{
    NSLog(@"sendtimecorrectTimer%d", isHadSendSlideInfo);
    
    int a = scount % 10;
    scount++;
    if (a == 0) {
        startTime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
        
    }
    
    /**
     Description
     
     @param %x" %x" description
     @param UInt32 UInt32 description
     @return return value description
     */
    [self getConntionStatus];
    
    if (_status == StatusSLIDEandX2AllConnected) {
        
        
        if (_receiveView.slideModeID == 0x01 && _receiveView.x2ModeID == 0x01) {
            dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQueue, ^{
                [self.sendDataView sendStartCancelPauseDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];

                [self.sendDataView sendStartCancelPauseDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];
            });
        }
#warning 2017年03月04日09:24:41 修改正在运行的状态 ！！！！
        if (_receiveView.slideTimer == (UInt32)startTime && _receiveView.x2Timer == (UInt32)startTime) {
            
//            [ud setObject:[NSNumber numberWithInteger:startTime] forKey:@"startime"];
            
            
            [ud setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
            
            
            [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];
            
            showprocessTimer.fireDate = [NSDate distantPast];
            
            timer.fireDate = [NSDate distantFuture];
        }
        
        if (_receiveView.slideModeID == 0x02 && _receiveView.x2ModeID == 0x02) {
            [ud setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
            
            
            
            
            
            
            showprocessTimer.fireDate = [NSDate distantPast];

            timer.fireDate = [NSDate distantFuture];
        }
        
        
        
    }else if (_status == StatusSLIDEOnlyConnected){
        //发送slide开始时间
        if (_receiveView.slideModeID == 0x01) {
            
            [self.sendDataView sendStartCancelPauseDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];
        }
        if (_receiveView.slideTimer == (UInt32)startTime || _receiveView.x2Timer == (UInt32)startTime) {
            [ud setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
           [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];
            
            showprocessTimer.fireDate = [NSDate distantPast];

            timer.fireDate = [NSDate distantFuture];
        }
        if (_receiveView.slideModeID == 0x02) {
            [ud setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];

            showprocessTimer.fireDate = [NSDate distantPast];

            timer.fireDate = [NSDate distantFuture];
            
        }
        
        
    }else if (_status == StatusX2OnlyConnected){
        //发送x2开始时间
        if (_receiveView.x2ModeID == 0x01) {
            [self.sendDataView sendStartCancelPauseDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];
        }
        
        
        if (_receiveView.slideTimer == (UInt32)startTime || _receiveView.x2Timer == (UInt32)startTime) {
            [ud setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];

            [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];
        
            showprocessTimer.fireDate = [NSDate distantPast];
            timer.fireDate = [NSDate distantFuture];
        }
        
        if (_receiveView.x2ModeID == 0x02) {
            [ud setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];

            showprocessTimer.fireDate = [NSDate distantPast];

            timer.fireDate = [NSDate distantFuture];
            
        }
    }else if (_status == StatusSLIDEandX2AllDisConnected){
//        NSLog(@"\r\n校准时间未连接");
    }
}
#pragma mark - (05)sendStopMotionStartOrPauseOrAction -
- (void)sendStopMotionStartOrPauseOrAction:(NSTimer *)timer{
//    NSLog(@"sendStopMotionStartOrPauseOrAction");
    NSLog(@"S1 = %hhu X2 =%hhu", _receiveView.slideStopMotionMode, _receiveView.x2StopMotionTimeMode);
    [self getConntionStatus];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    if (_status == StatusSLIDEandX2AllConnected) {
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            
            if (_receiveView.slideStopMotionMode == 0x01 && _receiveView.x2StopMotionTimeMode == 0x01) {
                dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(globalQueue, ^{
                    
                [self.sendDataView sendStopMotionSetWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
                    
                [self.sendDataView sendStopMotionSetWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
                });
            }
            
            if (_receiveView.slideStopMotionCurruntFrame > 0 && _receiveView.x2StopMotionCurruntFrame > 0) {
                
                showprocessTimer.fireDate = [NSDate distantPast];
                [SVProgressHUD dismiss];
                timer.fireDate = [NSDate distantFuture];
                
            }
            
        });

    }else if (_status == StatusSLIDEOnlyConnected) {
        if (_receiveView.slideStopMotionMode == 0x01) {
             [self.sendDataView sendStopMotionSetWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
        }
        if (_receiveView.slideStopMotionCurruntFrame > 0) {
            [SVProgressHUD dismiss];
            showprocessTimer.fireDate = [NSDate distantPast];

            timer.fireDate = [NSDate distantFuture];
        }
        
    
    }else if (_status == StatusX2OnlyConnected) {
        if (_receiveView.x2StopMotionTimeMode == 0x01)  {
             [self.sendDataView sendStopMotionSetWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
        }
        if (_receiveView.x2StopMotionCurruntFrame > 0)  {
            [SVProgressHUD dismiss];
            showprocessTimer.fireDate = [NSDate distantPast];

            timer.fireDate = [NSDate distantFuture];
            
        }
    
    }else if (_status == StatusSLIDEandX2AllDisConnected) {
        timer.fireDate = [NSDate distantFuture];
        
    }
    
    
}
#pragma mark - 回原点 -
/**
 回到原点
 */
- (void)backToTheBeginning:(NSTimer *)timer{
    isHadSendSlideInfo = NO;
    
    NSLog(@"backToTheBeginning1");
    
    if (_status == StatusSLIDEandX2AllConnected) {
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        if (loopModeView.MODEL == MODEL_STOPMOTION) {
            [self.sendDataView sendStopMotionSetWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
            [self.sendDataView sendStopMotionSetWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
            if (_receiveView.slideStopMotionMode == 0x01 && _receiveView.x2StopMotionTimeMode == 0x01) {
                if (isTouchReturnBack) {
                    self.StopMotionBtn.alpha = 1;
                    self.StopBtn.alpha = 0;
                    
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];
                    
                    timer.fireDate = [NSDate distantFuture];
                    isTouchReturnBack = NO;

                    
                }else{
                    
                sendStopMotionTimer.fireDate = [NSDate distantPast];
                timer.fireDate = [NSDate distantFuture];
                startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                }
            }
  
            
            
            
        }else{
            
            if (_receiveView.slideModeID == 0x01 && _receiveView.x2ModeID == 0x01) {
                if (isTouchReturnBack) {
                    
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];
                    self.PlayBtn.alpha = 1;
                    self.StopBtn.alpha = 0;
                    timer.fireDate = [NSDate distantFuture];
                    isTouchReturnBack = NO;

                    
                }else{
                    
                    timeCorrectTimer.fireDate = [NSDate distantPast];
                    timer.fireDate = [NSDate distantFuture];
                    startTime = [[NSDate date] timeIntervalSince1970] * 1000;

                }
                
            }else{
                
                [self.sendDataView sendStartCancelPauseDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
                [self.sendDataView sendStartCancelPauseDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
            }
        }
    }else if (_status == StatusSLIDEOnlyConnected){
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        if (loopModeView.MODEL == MODEL_STOPMOTION) {
            if (_receiveView.slideStopMotionMode == 0x01) {
                if (isTouchReturnBack) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];                    self.StopMotionBtn.alpha = 1;
                    self.StopBtn.alpha = 0;
                    timer.fireDate = [NSDate distantFuture];
                    isTouchReturnBack = NO;

                }else{
                    
                    sendStopMotionTimer.fireDate = [NSDate distantPast];
                    timer.fireDate = [NSDate distantFuture];
                    startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                }
                
                
            }else{
                [self.sendDataView sendStopMotionSetWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
            }
            
            
        }else{
            
            if ( _receiveView.slideModeID == 0x01) {
                
                if (isTouchReturnBack) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];                    self.PlayBtn.alpha = 1;
                    self.StopBtn.alpha = 0;
                    timer.fireDate = [NSDate distantFuture];
                    isTouchReturnBack = NO;
                    
                }else{
                    timeCorrectTimer.fireDate = [NSDate distantPast];
                    timer.fireDate = [NSDate distantFuture];
                    startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                    
                }
            }else{
                [self.sendDataView sendStartCancelPauseDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
                
            }
        }

    }else if (_status == StatusX2OnlyConnected){
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        
        
        if (loopModeView.MODEL == MODEL_STOPMOTION) {
            if ( _receiveView.x2StopMotionTimeMode == 0x01) {
                if (isTouchReturnBack) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];                    self.StopMotionBtn.alpha = 1;
                    self.StopBtn.alpha = 0;
                    timer.fireDate = [NSDate distantFuture];
                    isTouchReturnBack = NO;

                    
                }else{
                    
                    sendStopMotionTimer.fireDate = [NSDate distantPast];
                    timer.fireDate = [NSDate distantFuture];
                    startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                }
                
            }else{
                [self.sendDataView sendStopMotionSetWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
            }
            
            
        }else{
            
            if (_receiveView.x2ModeID == 0x01) {
                if (isTouchReturnBack) {
  [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];                    self.PlayBtn.alpha = 1;
                    self.StopBtn.alpha = 0;
                    timer.fireDate = [NSDate distantFuture];
                    isTouchReturnBack = NO;

                }else{
                    timeCorrectTimer.fireDate = [NSDate distantPast];
                    timer.fireDate = [NSDate distantFuture];
                    startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                    
                }
            }else{
                [self.sendDataView sendStartCancelPauseDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
                
            }
        }

    }else if (_status == StatusSLIDEandX2AllDisConnected){
    
    }
}

/**
 03) 发送配置参数的指令
 */
- (void)sendSettingParams:(NSTimer *)timer{
    NSLog(@"sendSettingParams");
    
//    NSLog(@"标准T1 = %f ST2 = %d, X2T3 = %d",self.ifmodel.totalTimes, _receiveView.slideVideoTime, _receiveView.x2VideoTime);
    
    UInt32 sendTime = (UInt32)self.ifmodel.totalTimes;
    
    if (isTouchPreview) {
        sendTime = (UInt32)preViewSecond;
    }
    
    if (loopModeView.MODEL == MODEL_VIDEO) {
        if (CBSLIDE.state == CBPeripheralStateConnected) {
            [self.sendDataView sendVedioTimeDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x04 andVideoTime:sendTime andBezierCount:(UInt8)SliderBazierView.PointArray.count WithStr:SendStr];
        }
        if (CBPanTilt.state == CBPeripheralStateConnected) {
            [self.sendDataView sendVedioTimeDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x04 andVideoTime:sendTime andPanBezierCount:(UInt8)PanBazierView.PointArray.count andTiltBezierCount:(UInt8)TiltBazierView.PointArray.count WithStr:SendStr];
        }
        
        if (_status == StatusSLIDEandX2AllConnected) {
            
            if (_receiveView.slideVideoTime == sendTime && _receiveView.x2VideoTime == (Float32)sendTime) {
                
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
        }else if (_status == StatusSLIDEOnlyConnected){
            if (_receiveView.slideVideoTime == sendTime) {
                
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
            
        }else if (_status == StatusX2OnlyConnected){
            if (_receiveView.x2VideoTime == sendTime) {
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
        }else if (_status == StatusSLIDEandX2AllDisConnected){
//            NSLog(@"\r\n发送配置参数未连接");
        }

        
    }else if (loopModeView.MODEL == MODEL_TIMELAPSE){
    
        
//    NSInteger interval1 = ([_timeArr[self.ifmodel.intervalTimeIndex] integerValue]);
    NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
    UInt32 TotalFrames;
        if (self.ifmodel.displayUnit == 1) {
            TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)self.ifmodel.totalFrames;
        }
        
    if (CBSLIDE.state == CBPeripheralStateConnected) {
         [self.sendDataView sendTimelapseSetDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x03 andInterval:(UInt16)finalRunningTime andExposure:self.ifmodel.exposureSecond andFrames:TotalFrames andMode:self.ifmodel.shootMode andBezierCount:(UInt8)SliderBazierView.PointArray.count WithStr:SendStr andBuffer_second:self.ifmodel.bufferSecond];
        
    }
    
    if (CBPanTilt.state == CBPeripheralStateConnected) {
//        [self.sendDataView sendTimelapseSetDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x03 andInterval:(UInt16)finalRunningTime andExposure:0x00 andFrames:TotalFrames andMode:self.ifmodel.shootMode andPanBezierCount:(UInt8)PanBazierView.PointArray.count andTiltBezierCount:(UInt8)TiltBazierView.PointArray.count WithStr:[self stringToHex:self.FrameLabel.text]];
        [self.sendDataView sendTimelapseSetDataWithCb:CBPanTilt andFrameHead:OX555F andFunctionNumber:0x03 andInterval:(UInt16)finalRunningTime andExposure:self.ifmodel.exposureSecond andFrames:TotalFrames andMode:self.ifmodel.shootMode andPanBezierCount:(UInt8)PanBazierView.PointArray.count andTiltBezierCount:(UInt8)TiltBazierView.PointArray.count WithStr:SendStr andBuffer_second:self.ifmodel.bufferSecond];
    }
#pragma mark - (03)发送配置参数 -
    if (_status == StatusSLIDEandX2AllConnected) {
        if (_receiveView.slideTotalFrames == TotalFrames && _receiveView.x2TotalFrames == TotalFrames) {

            [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
            timer.fireDate = [NSDate distantFuture];
        }

    }else if (_status == StatusSLIDEOnlyConnected){
        if (_receiveView.slideTotalFrames == TotalFrames) {
            
            [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
            timer.fireDate = [NSDate distantFuture];
        }

    }else if (_status == StatusX2OnlyConnected){
        if (_receiveView.x2TotalFrames == TotalFrames) {
            [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
            timer.fireDate = [NSDate distantFuture];
        }
    }else if (_status == StatusSLIDEandX2AllDisConnected){
//        NSLog(@"\r\n发送配置参数未连接");
    }
    
    }else if (loopModeView.MODEL == MODEL_STOPMOTION){
        
        timer.fireDate = [NSDate distantFuture];
        [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
    }
    
}

/**
 02）发送清除数据的指令
 */
- (void)sendClearOrder{
//    NSLog(@"sendClearOrder");
    
    _receiveView.slidebezierTimeParam = 0;
    _receiveView.slidebezierPosParam = 0;
    _receiveView.panbezierPosParam = 0;
    _receiveView.panbezierTimeParam = 0;
    _receiveView.tiltbezierTimerParam = 0;
    _receiveView.tiltbezierPosParam = 0;
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    if (CBSLIDE.state == CBPeripheralStateConnected) {
    [self.sendDataView sendStartCancelPauseDataWithCb:CBSLIDE andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:recordTime WithStr:SendStr andisLoop:0x00];
    }

    if (CBPanTilt.state == CBPeripheralStateConnected) {
    [self.sendDataView sendStartCancelPauseDataWithCb:CBPanTilt andFrameHead:OX555F  andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:recordTime WithStr:SendStr andisLoop:0x00];
        
    }
}

- (void)startSendArray{
    if (CBSLIDE.state == CBPeripheralStateConnected) {
        slideSendPostionTimer.fireDate = [NSDate distantPast];
    }
    if (CBPanTilt.state == CBPeripheralStateConnected) {
        pansendPostionTimer.fireDate = [NSDate distantPast];
    }
}

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
- (NSArray *)getNewNewArrayWithPointArray:(NSArray *)pointArray andControlArray:(NSArray *)controlArray{
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

#pragma mark -getNewArray 生成可传输的8个数组嵌入在里面！！！ -
- (NSArray *)getNewArray:(NSArray *)array{
    
    int count = 0;
    
    NSMutableArray * totalArray = [NSMutableArray new];
    NSMutableArray * arr1 = [NSMutableArray new];
    
    for (int i = 0 ; i < array.count; i++) {
        [arr1 addObject:array[i]];
        if ((i + 1) % 4 == 0) {
            count ++;
            NSArray * arr2 = [NSArray arrayWithArray:arr1];
//            NSLog(@"%d %@",count, arr1);
            [totalArray addObject:arr2];
            [arr1 removeAllObjects];
        }
    }
    NSMutableArray * arr3 = [NSMutableArray arrayWithArray:arr1];
    for (int i = 0; i< 4 - arr1.count; i++) {
        [arr3 addObject:@0];
    }
    [totalArray addObject:arr3];
//    NSLog(@"%@", totalArray);
    return totalArray;
}


#pragma mark -- iFSettingDelegate --- 
- (void)getTimelapseSettingData:(NSDictionary *)dict{
    
    FrameLabel.text = [NSString stringWithFormat:@"Frame:0/%@", dict[TOTALFRAMES]];
    allFrames = [dict[TOTALFRAMES] integerValue];
}

- (void)viewDidDisappear:(BOOL)animated{
    [self closeNSTimer];
}

-(void)closeNSTimer{
    
    receiveTimer.fireDate = [NSDate distantFuture];
    slideSendTimeTimer.fireDate = [NSDate distantFuture];
    slideSendPostionTimer.fireDate = [NSDate distantFuture];
    sendStopMotionTimer.fireDate = [NSDate distantFuture];
    pansendTimeTimer.fireDate = [NSDate distantFuture];
    pansendPostionTimer.fireDate = [NSDate distantFuture];
    tiltsendTimeTimer.fireDate = [NSDate distantFuture];
    tiltsendPostionTimer.fireDate = [NSDate distantFuture];
    timeCorrectTimer.fireDate = [NSDate distantFuture];
    sendSettingsTimer.fireDate = [NSDate distantFuture];
    clearSettingsTimer.fireDate = [NSDate distantFuture];
    returnZeroTimer.fireDate = [NSDate distantFuture];
    showprocessTimer.fireDate = [NSDate distantFuture];
    pauseTimer.fireDate = [NSDate distantFuture];
    
    
    
    [sendStopMotionTimer invalidate];
    [receiveTimer invalidate];
    [slideSendPostionTimer invalidate];
    [slideSendTimeTimer invalidate];
    [pansendTimeTimer invalidate];
    [pansendPostionTimer invalidate];
    [tiltsendTimeTimer invalidate];
    [tiltsendPostionTimer invalidate];
    [timeCorrectTimer invalidate];
    [sendSettingsTimer invalidate];
    [clearSettingsTimer invalidate];
    [showprocessTimer invalidate];
    [pauseTimer invalidate];
    
    
    
    receiveTimer = nil;
    slideSendTimeTimer = nil;
    slideSendPostionTimer = nil;
    pansendTimeTimer = nil;
    pansendPostionTimer = nil;
    tiltsendTimeTimer = nil;
    tiltsendPostionTimer = nil;
    timeCorrectTimer = nil;
    sendSettingsTimer = nil;
    clearSettingsTimer = nil;
    showprocessTimer = nil;
    pauseTimer  = nil;
    
    

}
- (void)viewWillDisappear:(BOOL)animated{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [super viewWillDisappear:animated];
    [self backActionDelegateMethod];
    
    
    [SVProgressHUD dismiss];
    
    //强制旋转竖屏
    [self forceOrientationPortrait];
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    self.navigationController.navigationBarHidden = YES;


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    [self forceOrientationLandscape];
    
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
    
    receiveTimer.fireDate = [NSDate distantPast];
    
}



#pragma mark -----横竖屏切换 ------------
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

- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)receiveRealData{


    [self getConntionStatus];

    UInt64 msecond1 = [[NSDate date] timeIntervalSince1970]*1000;
    

    
    FrameLabel.text = [NSString stringWithFormat:@"Frame:%d/%ld",(unsigned int)_receiveView.RealTimesFrames, (long)allFrames ];
    NSString * frameStr;
    
    
    if (loopModeView.MODEL == MODEL_STOPMOTION) {
        
        if (_status == StatusX2OnlyConnected) {
            int frame =  (unsigned int)_receiveView.x2StopMotionCurruntFrame - 1;
            if (frame < 0) {
                frame = 0;
            }
            frameStr = [NSString stringWithFormat:@"%d", frame];
        }else{
            int frame = (unsigned int)_receiveView.slideStopMotionCurruntFrame - 1;
            if (frame < 0) {
                frame = 0;
            }
            frameStr = [NSString stringWithFormat:@"%d", frame];
        }

    }else{
    
        
    if (_status == StatusX2OnlyConnected) {
        
        frameStr = [NSString stringWithFormat:@"%d", (unsigned int)_receiveView.x2frames];

        if (_receiveView.x2frames >= self.ifmodel.totalFrames) {

            
        }
    }else{
        if (_receiveView.slideframes >= self.ifmodel.totalFrames) {
            
        }
        frameStr = [NSString stringWithFormat:@"%d", (unsigned int)_receiveView.slideframes];
        }
    }
    
    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = self.ifmodel.totalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)self.ifmodel.totalFrames;
    }else{
        NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
        if (self.ifmodel.displayUnit == 1) {
            TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)self.ifmodel.totalFrames;
        }
    }
    
    processView.OutputTimeView.valueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimelapseFrameWith:TotalFrames andFPS:[self.configs[self.ifmodel.fpsIndex]integerValue]]];
    
    processView.CurrentFrameView.valueLabel.text = frameStr;
    processView.TotalFrameView.valueLabel.text = [NSString stringWithFormat:@"%u", (unsigned int)TotalFrames];
    
    NSInteger runtimeint = (msecond1 - [[ud objectForKey:@"startime"] longLongValue]) / 1000 - (pasueTotaltime / 1000);
    
    processView.ElapsedTimeView.valueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool get_HMS_TimeWith: runtimeint]];
    
    processView.RemainingTimeView.valueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool get_HMS_TimeWith:(NSInteger)finalRunningTime * TotalFrames - runtimeint]];
    
//    processView.countTimerLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith: (NSInteger)(msecond1 - [[ud objectForKey:@"startime"] longLongValue]) / 1000]];
    processView.countTimerLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: runtimeint], [iFGetDataTool getTimeWith:(NSInteger)finalRunningTime * TotalFrames]];
    
    self.ifmodel.focalIndex = [[ud objectForKey:FPSValue] integerValue];
    if (isTouchPreview) {
        processView.TimeLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: runtimeint], [iFGetDataTool getTimeWith:preViewSecond]];
    }else{
    processView.TimeLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: runtimeint], [iFGetDataTool getTimeWith:TotalFrames]];
    }
}
- (void)showProcessStatusWithprocessTimer:(NSTimer * )timer{
//    [processView showWithMode:loopModeView.MODEL andTitle:nil];
//    UInt64 msecond1 = [[NSDate date] timeIntervalSince1970]*1000;
    NSLog(@"slideStopMotionMode = %d", _receiveView.slideStopMotionMode);
    processView.TimelapseMode = loopModeView.MODEL;
    if (isTouchPreview) {
        [processView showWithMode:loopModeView.MODEL andTitle:@"preview"];
    }
    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = self.ifmodel.totalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)self.ifmodel.totalFrames;
    }else{
        NSInteger fpsValue = [self.configs[self.ifmodel.fpsIndex] integerValue];
        if (self.ifmodel.displayUnit == 1) {
            TotalFrames = (UInt32)(fpsValue * self.ifmodel.TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)self.ifmodel.totalFrames;
        }
}

    
    if (loopModeView.MODEL == MODEL_STOPMOTION) {
        if (_status == StatusSLIDEandX2AllConnected) {
            if (_receiveView.slideStopMotionMode == 0x02 && _receiveView.x2StopMotionTimeMode == 0x02) {
                
                CGFloat moveXvalue = 0.0f;
                moveXvalue = (CGFloat)_receiveView.slideStopMotionCurruntFrame / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
                insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);

                [SVProgressHUD dismiss];
                
                processView.alpha = ProcessALPHA;
                
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                [self.view bringSubviewToFront:processView];
                
            }else if (_receiveView.slideStopMotionMode == 0x01 || _receiveView.x2StopMotionTimeMode == 0x01){
//                NSLog(@"正在回零");
                //                showprocessTimer.fireDate = [NSDate distantPast];
                
            }
            else{
                
                if (isloop == 0x01) {
                    
                }else{
                processView.alpha = 0;
                    
                
                NSLog(@"结束");
                    self.StopBtn.alpha = 0;
                    
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = self.ifmodel.FunctionMode;
                        
                    }
                    
                 
                isStopMotionOn = NO;
                
                timer.fireDate = [NSDate distantFuture];
                }
                
            }

        }else if (_status == StatusSLIDEOnlyConnected){
            if (_receiveView.slideStopMotionMode == 0x02) {
                
                CGFloat moveXvalue = 0.0f;
                moveXvalue = (CGFloat)_receiveView.slideStopMotionCurruntFrame / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
                insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);

                [SVProgressHUD dismiss];
                processView.alpha = ProcessALPHA;
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                
                [self.view bringSubviewToFront:processView];
                
            }else if (_receiveView.slideStopMotionMode == 0x01 || _receiveView.x2StopMotionTimeMode == 0x01){
//                NSLog(@"正在回零");
                //                showprocessTimer.fireDate = [NSDate distantPast];
                
            }
            else{
                
                if (isloop == 0x01) {
                    
                }else{
                    processView.alpha = 0;
                    self.StopBtn.alpha = 0;

//                    NSLog(@"结束");
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
                    isStopMotionOn = NO;
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = self.ifmodel.FunctionMode;
                    }

                    timer.fireDate = [NSDate distantFuture];
                }

                
            }
            

        
        }else if (_status == StatusX2OnlyConnected){
            if (_receiveView.x2StopMotionTimeMode == 0x02) {
                CGFloat moveXvalue = 0.0f;
                moveXvalue = (CGFloat)_receiveView.x2StopMotionCurruntFrame / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;                [SVProgressHUD dismiss];
                insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);

                processView.alpha = ProcessALPHA;
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                
                [self.view bringSubviewToFront:processView];
                
            }else if (_receiveView.slideStopMotionMode == 0x01 || _receiveView.x2StopMotionTimeMode == 0x01){
//                NSLog(@"正在回零");
                //                showprocessTimer.fireDate = [NSDate distantPast];
                
            }
            else{
                
                if (isloop == 0x01) {
                    
                }else{
                    processView.alpha = 0;
                    self.StopBtn.alpha = 0;

//                    NSLog(@"结束");
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
                    isStopMotionOn = NO;
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = self.ifmodel.FunctionMode;
                    }

                    
                    timer.fireDate = [NSDate distantFuture];
                }
                
            }
            

        
        }else if (_status == StatusSLIDEandX2AllDisConnected) {
        
        }
    }else{
        
        if (_receiveView.slideModeID == 0x02 ||_receiveView.x2ModeID == 0x02) {
            CGFloat moveXvalue = 0.0f;
            moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
            insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);

            isPlayOn = YES;
            self.PlayBtn.alpha = 0;
            self.StopBtn.alpha = 1;
            
            
        }
#pragma mark ---- 判断开始和结束显示状态-------
    if (_status == StatusSLIDEandX2AllConnected) {
        if (isPlayOn) {
            if (_receiveView.slideModeID == 0x02 && _receiveView.x2ModeID == 0x02) {
                if (loopModeView.MODEL == MODEL_VIDEO) {
                    CGFloat moveXvalue = 0.0f;
                    
                    
//                    moveXvalue = (CGFloat)(msecond1 - [[ud objectForKey:@"startime"] integerValue]) / 1000.0f / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
                    moveXvalue = (CGFloat)(_receiveView.S1timelinePercent / 100.0f) * SliderBazierView.frame.size.width;
//                    NSLog(@"%lf", moveXvalue);
                    
                    
                    insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                    
                }else{
                    //      
                    CGFloat moveXvalue = 0.0f;
                    moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                    NSLog(@"%lf", moveXvalue);
                    
                    insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                }

                [SVProgressHUD dismiss];
                
                processView.alpha = ProcessALPHA;
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];

                [self.view bringSubviewToFront:processView];

            }else if (_receiveView.slideModeID == 0x01 || _receiveView.x2ModeID == 0x01){
//                NSLog(@"正在回零");
//                showprocessTimer.fireDate = [NSDate distantPast];
                
            }
            else{
                
                if (isloop == 0x01) {
                    
                }else{
                
                processView.alpha = 0;
                self.StopBtn.alpha = 0;
                self.PlayBtn.alpha = 1;
                if (loopModeView.MODEL == MODEL_STOPMOTION) {
                    self.PlayBtn.alpha = 0;
            
                }
                NSLog(@"结束");
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
                isPlayOn = NO;
                isStopOn = YES;
                isStopMotionOn = NO;
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = self.ifmodel.FunctionMode;
                    }

                    self.PauseBtn.alpha = 0;
                    self.preViewBtn.alpha = 1;
                
                timer.fireDate = [NSDate distantFuture];
                }
                
            }
        }
    }else if (_status == StatusSLIDEOnlyConnected){
        
        if (isPlayOn) {
            
            if (_receiveView.slideModeID == 0x02) {
                [SVProgressHUD dismiss];
                if (loopModeView.MODEL == MODEL_VIDEO) {
                    CGFloat moveXvalue = 0.0f;
                    
//                    moveXvalue = (CGFloat)(msecond1 - [[ud objectForKey:@"startime"] integerValue]) / 1000.0f / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                    NSLog(@"%lf", moveXvalue);
                    moveXvalue = (CGFloat)(_receiveView.S1timelinePercent / 100.0f) * SliderBazierView.frame.size.width;

                    insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                    
                }else{

                CGFloat moveXvalue = 0.0f;
                moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                NSLog(@"%lf", moveXvalue);
                
                insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                }

                processView.alpha = ProcessALPHA;
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                
                [self.view bringSubviewToFront:processView];
                
            }else if (_receiveView.slideModeID == 0x01){
//                showprocessTimer.fireDate = [NSDate distantPast];
//                NSLog(@"正在回零中 有bug！！！！");

            }
            else{
                if (isloop == 0x01) {
                    
                }else{
                    
                    processView.alpha = 0;
                    self.StopBtn.alpha = 0;
                    self.PlayBtn.alpha = 1;
                    if (loopModeView.MODEL == MODEL_STOPMOTION) {
                        self.PlayBtn.alpha = 0;
                        
                    }
                    NSLog(@"结束");
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
                    isPlayOn = NO;
                    isStopOn = YES;
                    isStopMotionOn = NO;
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = self.ifmodel.FunctionMode;
                    }
                    

                    self.PauseBtn.alpha = 0;
                    self.preViewBtn.alpha = 1;
                    
                    timer.fireDate = [NSDate distantFuture];
                }

                
            }
        }
        
    }else if (_status == StatusX2OnlyConnected) {
        
        
        if (isPlayOn) {
            if ( _receiveView.x2ModeID == 0x02) {
                
                if (loopModeView.MODEL == MODEL_VIDEO) {
                    CGFloat moveXvalue = 0.0f;
//                    CGFloat realmoveXvalue = (CGFloat)(msecond1 - [[ud objectForKey:@"startime"] integerValue]) / 1000.0f;
                    
//                    if (realmoveXvalue > TotalFrames) {
//                        realmoveXvalue = realmoveXvalue - TotalFrames;
//                    }
                    
//                    moveXvalue = realmoveXvalue / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
                    moveXvalue = (CGFloat)(_receiveView.X2timelinePercent / 100.0f) * SliderBazierView.frame.size.width;

//                    NSLog(@"%lf", moveXvalue);
                    
                    insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                    
                }else{
                    CGFloat moveXvalue = 0.0f;
                    moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                    NSLog(@"%lf", moveXvalue);
                    
                    insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                }

                [SVProgressHUD dismiss];

                processView.alpha = ProcessALPHA;
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                
                [self.view bringSubviewToFront:processView];
                
                
            }else if (_receiveView.x2ModeID == 0x01){
//                showprocessTimer.fireDate = [NSDate distantPast];
                
//                NSLog(@"正在回零中 有bug！！！！");
                
            }
            else{
                
                
                
                
                if (isloop == 0x01) {
                    
                }else{
                    
                    processView.alpha = 0;
                    self.StopBtn.alpha = 0;
                    self.PlayBtn.alpha = 1;
                    if (loopModeView.MODEL == MODEL_STOPMOTION) {
                        self.PlayBtn.alpha = 0;
                        
                    }
                    NSLog(@"结束");
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
                    isPlayOn = NO;
                    isStopOn = YES;
                    isStopMotionOn = NO;
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = self.ifmodel.FunctionMode;
                    }

                    self.PauseBtn.alpha = 0;
                    self.preViewBtn.alpha = 1;
                    
                    timer.fireDate = [NSDate distantFuture];
                }
                
            }
        }
        
    }else if (_status == StatusSLIDEandX2AllDisConnected) {
//        NSLog(@"二者都没有连接");
        self.StopBtn.alpha = 0;
        self.PlayBtn.alpha = 1;
    }
    }

}

- (void)setReceiveMode{
    Encode = Encode_HEX;
    [_receiveView setIsAscii:NO];
    [_sendDataView setIsAscii:NO];
}

- (NSInteger)getConntionStatus{
    
    if (CBSLIDE.state == CBPeripheralStateConnected && CBPanTilt.state == CBPeripheralStateConnected) {
        _status = StatusSLIDEandX2AllConnected;
        return StatusSLIDEandX2AllConnected;
    }else if (CBSLIDE.state == CBPeripheralStateConnected && ((CBPanTilt == nil) || (CBPanTilt.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting))){
        _status =  StatusSLIDEOnlyConnected;
        return StatusSLIDEOnlyConnected;
    }else if (((CBSLIDE == nil) || (CBSLIDE.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting)) && CBPanTilt.state == CBPeripheralStateConnected){
        _status = StatusX2OnlyConnected;
        return StatusX2OnlyConnected;
    }else{
        _status = StatusSLIDEandX2AllDisConnected;
        return StatusSLIDEandX2AllDisConnected;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)BLEBezierPreview:(float)sliderPostion{
    
    [self.sendDataView sendBezierPreviewWithCb:appDelegate.bleManager.sliderCB andFrameHead:0xAAAF andFunctionNumber:0x06 andFunctionMode:0x01 sliderPostion:0x00 WithStr:nil];
}
#pragma mark - 暂停（停止）指令
- (void)StopRunDataWithCB:(CBPeripheral *)cb frameHead:(UInt16)frameHead{
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    
    [_sendDataView sendDataWithCb:cb andFrameHead:frameHead andFunctionNumber:0x03 andFunctionMode:0x00 andShootingMode:0x00 andBeizerCount:0x00 andIsClearBeizer:0x00 andcheckTime:recordTime andIsSettingClear:0x00 str:SendStr];
    
    
}

#pragma mark -  beizierDelegate --- 
- (void)showAccordingToWarningWithMode:(NSInteger)mode{
    
    if (mode == 0) {
        UIAlertController * alertView = [iFAlertController showAlertControllerWith:NSLocalizedString(Timeline_WarmTips, nil) Message:NSLocalizedString(Timeline_AddRightFramesWarning, nil) SureButtonTitle:NSLocalizedString(Timeline_OK, nil) SureAction:^(UIAlertAction * action) {
        }];
        [self presentViewController:alertView animated:YES completion:nil];
    }else if (mode == 1){
    
    
    }else if (mode == 2){
    
    }
  
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self countAllpointTime];

    
}
- (void)check{
    NSLog(@"%lf", self.returnBtn.alpha);
    NSLog(@"%lf", self.preViewBtn.alpha);
    NSLog(@"%lf", self.PlayBtn.alpha);
    NSLog(@"%lf", self.StopMotionBtn.alpha);
    NSLog(@"%@", insertView);
    
    TimelapseTimeLabel.userInteractionEnabled = YES;
    fpsLabel.userInteractionEnabled = YES;
    loopModeView.userInteractionEnabled = YES;
    self.returnBtn.userInteractionEnabled = YES;
    self.preViewBtn.userInteractionEnabled = YES;
    self.PlayBtn.userInteractionEnabled = YES;
    self.backBtn.userInteractionEnabled = YES;
    
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
