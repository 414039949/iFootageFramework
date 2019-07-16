//
//  iFS1A3_TimelineViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_TimelineViewController.h"
#import "iFS1A3_Model.h"
#import "iFS1A3_InsertView.h"
#import "iFFunctionPicker.h"
#import "iFSliderView.h"
#import "iFBazierView.h"
#import <Masonry/Masonry.h>
#import "iFLabel.h"
#import "iF3DButton.h"
#import "AppDelegate.h"
#import "iFBackImageView.h"
#import "iFCenterInfoView.h"
#import "iFCustomSlider.h"
#import "iFLoopView.h"
#import "DXPopover.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "iFFramePickerView.h"
#import "iFTimePickerView.h"
#import "iFGetDataTool.h"
#import "SVProgressHUD.h"
#import "iFgetAxisY.h"
#import "iFProcessView.h"
#import "iFPickView.h"
#import "iFAlertController.h"

#define ProcessALPHA 1.0f
#define SendStr [self stringToHex:@"0000000000"]


#define ALPHA 0.6f
#define SlideTag 1111
#define PanTag 2222
#define TiltTag 3333
#define ExposureLabelTag 1212
#define BufferLabelTag 1213
#define second 0.1f





#define Point(x, y) [NSValue valueWithCGPoint:CGPointMake(x, y)]



@interface iFS1A3_TimelineViewController ()<previewMoveDelegate, changeValueDelegate, GetFunctionIndexDelegate, UIPickerViewDelegate, UIPickerViewDataSource, getSlideValueDelegate, framePickDelegate, TimePickDelegate, TimeLapseTimePickDelegate, processDelegate,getIndexDelegate,UITextFieldDelegate>




@property (nonatomic, strong)iF3DButton * KeyBtn;
@property (nonatomic, strong)iF3DButton * PauseBtn;
@property (nonatomic, strong)iF3DButton * PlayBtn;
@property (nonatomic, strong)iF3DButton * SaveBtn;
@property (nonatomic, strong)iF3DButton * preViewBtn;
@property (nonatomic, strong)iF3DButton * StopMotionBtn;
@property (nonatomic, strong)iF3DButton * StopBtn;
@property (nonatomic, strong)iF3DButton * returnBtn;
@property (nonatomic, strong)iFCenterInfoView * centerInfoView;
@property (nonatomic, strong)NSMutableArray * configs;
@property (nonatomic, assign)CGFloat YValue;


/**
 *  发送视图
 */
@property (nonatomic, strong)SendDataView * sendDataView;
/**
 *  接收视图
 */
@property (nonatomic, strong)ReceiveView * receiveView;

@property (nonatomic, strong)NSMutableArray * timeArr;


@property (nonatomic, strong) DXPopover *popover;//弹出视图 download的第三方


@end

@implementation iFS1A3_TimelineViewController
{
    CGFloat leftLimit;//左边限制位置
    CGFloat rightLimit;//右边限制位置
    CGFloat topLimit;//上边限制位置
    CGFloat downLimit;//下边限制位置
    NSInteger insertIndex; //插入的下标值
    CGFloat xValue;
    
    NSMutableArray * S1A3_SlidenewFrameArray;
    NSMutableArray * S1A3_PannewFrameArray;
    NSMutableArray * S1A3_TiltnewFrameArray;
    
    NSMutableArray * S1A3_SlidenewPostionArray;
    NSMutableArray * S1A3_PannewPostionArray;
    NSMutableArray * S1A3_TiltnewPostionArray;

    NSMutableArray * dataArray;//存储数据的数组
    
    AppDelegate     * appDelegate;
    iFBazierView    * SliderBazierView;
    iFBazierView    * PanBazierView;
    iFBazierView    * TiltBazierView;
    iFS1A3_InsertView * intervalView;//间隔中间视图层
    
    iFCustomSlider  * SlideCustomSlider;//控制slide区间
    iFCustomSlider  * PanCustomSlider;//控制pan区间
    iFCustomSlider  * TiltCustomSlider;//控制Tilt区间
    iFSliderView * insertslider;
    iFProcessView * processView;

    iFLoopView      * loopModeView;//选择Mode Timelapse Video StopMotion
    NSUInteger               Encode;//编码模式 ascii or  hex

    UInt8 isloop;
    
    UILabel * expoLabel;//曝光时间Label
    UILabel * bufferLabel;//缓冲时间Label
    UILabel * frameLabel;//Frame(帧数)Label
    UILabel * TimelapseTimeLabel;//TimelapseMode‘s TimeLabel
    UILabel * timeLabel;//Video's TimeLabel
    UILabel * fpsLabel;//fps‘s Label
    
    UILabel * xFrameLabel;
    UILabel * yDistanceLabel;
    
    
    iFS1A3_Model * S1A3Model;
    iFBackImageView * backView;
    UIButton * backBtn;
    UIView * insertBackView;
    UIView * partInsertView;


    NSTimer * S1A3_ReceiveTimer;//接受定时器

    NSTimer * S1A3_S1_SendPositionTimer;//发送S1位置信息
    NSTimer * S1A3_S1_SendTimeTimer;//发送S1时间信息定时器
    NSTimer * S1A3_X2_Pan_SendPositionTimer;
    NSTimer * S1A3_X2_Tilt_SendPositionTimer;
    NSTimer * S1A3_X2_Pan_SendTimeTimer;
    NSTimer * S1A3_X2_Tilt_SendTimetimer;//发送Tilt时间或者frame信息定时器
    NSTimer * S1A3_TimeCorrectTimer;//时间戳校准
    NSTimer * S1A3_SendSettingTimer;//发送配置参数
    NSTimer * S1A3_ClearSettingTimer;//清除数据
    NSTimer * S1A3_SendStopMotionTimer;//发送定格动画定时器
    NSTimer * S1A3_ReturnZeroTimer;//回零定时器
    NSTimer * S1A3_StopTimer;//停止定时器
    
    NSTimer * S1A3_ShowprocessTimer;//监测运行状态的定时器
    
    UInt64 startTime;//开始时间（64位）

    CGFloat runningTime;
    UInt16 finalRunningTime;
    NSInteger preViewSecond;
    
    BOOL isPlayOn;
    BOOL isStopOn;
    BOOL isTouchReturnBack;
    BOOL isTouchPreview;
    
}
@synthesize SliderBtn, PanBtn, TiltBtn;


- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
//    self.titleLabel.text = @"Time line";
    self.rootbackBtn.alpha = 1;
    self.connectBtn.alpha = 0;
    isloop = 0x00;
    self.YValue = 100;
    
    [self.rootbackBtn addTarget:self action:@selector(backTolastViewController) forControlEvents:UIControlEventTouchUpInside];

    //初始化数据
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _receiveView = [ReceiveView sharedInstance];
    _sendDataView = [[SendDataView alloc]init];
    S1A3_SlidenewPostionArray = [NSMutableArray new];
    S1A3_SlidenewFrameArray = [NSMutableArray new];
    S1A3_PannewPostionArray = [NSMutableArray new];
    S1A3_PannewFrameArray = [NSMutableArray new];
    S1A3_TiltnewPostionArray = [NSMutableArray new];
    S1A3_TiltnewFrameArray = [NSMutableArray new];

    [self initS1A3_Data];
    //创建Slide Pan Tilt视图
    [self createSlide_Pan_TiltBezierView];
    //创建所有按钮和中心信息视图
    [self createAll3DButtonAndCenterInfoView];
    //创建所有的PickerView选择视图(LoopView frame timelapsetime videotime fps)’s Label
    [self createAllPickerView];
    
    [self loopAction:S1A3Model.S1A3_FunctionMode];
    
    
}

#pragma mark ------ 创建所有定时器的集合 -----
- (void)createAllTimer{
    S1A3_ReceiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(S1A3_ReceiveTimerAction:) userInfo:nil repeats:YES];
    S1A3_ReceiveTimer.fireDate =  [NSDate distantPast];
    
    S1A3_S1_SendPositionTimer = [self getTimerMethodWithSEL:@selector(S1A3_S1_SendPositionTimerAction:)];
    S1A3_S1_SendTimeTimer = [self getTimerMethodWithSEL:@selector(S1A3_S1_SendTimeTimerAction:)];
    S1A3_X2_Pan_SendPositionTimer = [self getTimerMethodWithSEL:@selector(S1A3_X2_Pan_SendPositionTimerAction:)];
    S1A3_X2_Pan_SendTimeTimer = [self getTimerMethodWithSEL:@selector(S1A3_X2_Pan_SendTimeTimerAction:)];
    S1A3_X2_Tilt_SendPositionTimer = [self getTimerMethodWithSEL:@selector(S1A3_X2_Tilt_SendPositionTimerAction:)];
    S1A3_X2_Tilt_SendTimetimer = [self getTimerMethodWithSEL:@selector(S1A3_X2_Tilt_SendTimetimerAction:)];
    S1A3_TimeCorrectTimer = [self getTimerMethodWithSEL:@selector(S1A3_TimeCorrectTimerAction:)];
    S1A3_SendSettingTimer = [self getTimerMethodWithSEL:@selector(S1A3_SendSettingTimerAction:)];
    S1A3_ClearSettingTimer = [self getTimerMethodWithSEL:@selector(S1A3_ClearSettingTimerAction:)];
    S1A3_SendStopMotionTimer = [self getTimerMethodWithSEL:@selector(S1A3_SendStopMotionTimerAction:)];
    S1A3_ReturnZeroTimer = [self getTimerMethodWithSEL:@selector(S1A3_ReturnZeroTimerAction:)];
    S1A3_StopTimer = [self getTimerMethodWithSEL:@selector(S1A3_StopTimerAction:)];
    S1A3_ShowprocessTimer = [self getTimerMethodWithSEL:@selector(S1A3_ShowprocessTimerAction:)];
    
    [[NSRunLoop mainRunLoop] addTimer:S1A3_ReceiveTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_S1_SendPositionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_S1_SendTimeTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_X2_Pan_SendPositionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_X2_Pan_SendTimeTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_X2_Tilt_SendPositionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_X2_Tilt_SendTimetimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_TimeCorrectTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_SendSettingTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_ClearSettingTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_SendStopMotionTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_ReturnZeroTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_StopTimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:S1A3_ShowprocessTimer forMode:NSRunLoopCommonModes];
    
}
- (void)closeTimer{
    [self closeOneTimer:S1A3_ReceiveTimer];
    [self closeOneTimer:S1A3_S1_SendTimeTimer];
    [self closeOneTimer:S1A3_S1_SendPositionTimer];
    [self closeOneTimer:S1A3_X2_Pan_SendTimeTimer];
    [self closeOneTimer:S1A3_X2_Pan_SendPositionTimer];
    [self closeOneTimer:S1A3_X2_Tilt_SendTimetimer];
    [self closeOneTimer:S1A3_X2_Tilt_SendPositionTimer];
    [self closeOneTimer:S1A3_TimeCorrectTimer];
    [self closeOneTimer:S1A3_SendSettingTimer];
    [self closeOneTimer:S1A3_ClearSettingTimer];
    [self closeOneTimer:S1A3_SendStopMotionTimer];
    [self closeOneTimer:S1A3_ReturnZeroTimer];
    [self closeOneTimer:S1A3_StopTimer];
    [self closeOneTimer:S1A3_ShowprocessTimer];
}
- (void)pauseOneTimer:(NSTimer *)timer{
    timer.fireDate = [NSDate distantFuture];
}
- (void)closeOneTimer:(NSTimer *)timer{
    timer.fireDate = [NSDate distantFuture];
    [timer invalidate];
    timer = nil;
}
- (NSTimer * )getTimerMethodWithSEL:(SEL)Sel{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:second target:self selector:Sel userInfo:nil repeats:YES];
    timer.fireDate = [NSDate distantFuture];
    return timer;
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
            [totalArray addObject:arr2];
            [arr1 removeAllObjects];
        }
    }
    
    NSMutableArray * arr3 = [NSMutableArray arrayWithArray:arr1];
    for (int i = 0; i< 4 - arr1.count; i++) {
        [arr3 addObject:@0];
    }
    [totalArray addObject:arr3];
    return totalArray;
}
#pragma mark --- stringToHex -----
- (NSString *)stringToHex:(NSString *)string
{
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    return hexStr;
    
}
#warning - sendArray发送数组------------
- (void)sendArray:(NSArray *)array andFrameHead:(UInt16)framehead andfunNumber:(UInt8)funNum withCB:(CBPeripheral *)cb YesOrNo:(BOOL)on{
    if (on) {
        
        [_sendDataView sendBezierTimeWithCb:cb andFrameHead:framehead andFunctionNumber:funNum andTimeArray:array WithStr:SendStr];
        
    }
}
#pragma mark -------- getConntionStatus -
- (NSInteger)getConntionStatus{
    
    if (CBS1A3_S1.state == CBPeripheralStateConnected && CBS1A3_X2.state == CBPeripheralStateConnected) {
        
        _status = StatusSLIDEandX2AllConnected;
        return StatusSLIDEandX2AllConnected;
        
    }else if (CBS1A3_S1.state == CBPeripheralStateConnected && ((CBS1A3_X2 == nil) || (CBS1A3_X2.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting))){
        
        _status =  StatusSLIDEOnlyConnected;
        
        return StatusSLIDEOnlyConnected;
        
    }else if (((CBS1A3_S1 == nil) || (CBS1A3_S1.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting)) && CBS1A3_X2.state == CBPeripheralStateConnected){
        _status = StatusX2OnlyConnected;
        return StatusX2OnlyConnected;
        
    }else{
        
        _status = StatusSLIDEandX2AllDisConnected;
        return StatusSLIDEandX2AllDisConnected;
    }
}

#pragma mark --- startSendArray --
- (void)startSendArray{
    
    if (CBS1A3_S1.state == CBPeripheralStateConnected) {
        S1A3_S1_SendPositionTimer.fireDate = [NSDate distantPast];
        
    }
    if (CBS1A3_X2.state == CBPeripheralStateConnected) {
        S1A3_X2_Pan_SendPositionTimer.fireDate = [NSDate distantPast];
    }
}
- (void)S1A3_ReceiveTimerAction:(NSTimer *)timer{


    NSString * frameStr;
    
    UInt64 msecond1 = [[NSDate date] timeIntervalSince1970]*1000;

    
    if (loopModeView.MODEL == MODEL_STOPMOTION) {
        
        
            frameStr = [NSString stringWithFormat:@"%d", _receiveView.S1A3_X2_StopMotion_CurrentFrame > _receiveView.S1A3_S1_StopMotion_CurrentFrame ? _receiveView.S1A3_X2_StopMotion_CurrentFrame: _receiveView.S1A3_S1_StopMotion_CurrentFrame];
        
    }else{
        
        
        if (_status == StatusX2OnlyConnected) {
            
            //        frameLabel.text = [NSString stringWithFormat:@"Frame:%d/%ld", _receiveView.x2frames, self.ifmodel.totalFrames];
            frameStr = [NSString stringWithFormat:@"%d", (unsigned int)_receiveView.S1A3_X2_Timeline_Frames];
            
            if (_receiveView.S1A3_S1_Timeline_Frames >= S1A3Model.S1A3_TimelapseTotalFrames) {
                
                
            }
        }else{
            if (_receiveView.S1A3_S1_Timeline_Frames >= S1A3Model.S1A3_TimelapseTotalFrames) {
                
            }
            frameStr = [NSString stringWithFormat:@"%d", (unsigned int)_receiveView.S1A3_S1_Timeline_Frames];
        }
    }

    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = S1A3Model.S1A3_VideoTotalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
    }else{
        NSInteger fpsValue = [self.configs[S1A3Model.S1A3_DisPlayMode] integerValue];
        if (S1A3Model.S1A3_DisPlayMode == 1) {
            TotalFrames = (UInt32)(fpsValue * S1A3Model.S1A3_TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
        }
    }
    
    processView.OutputTimeView.valueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimelapseFrameWith:TotalFrames andFPS:[self.configs[S1A3Model.S1A3_fpsIndex]integerValue]]];
    
    processView.CurrentFrameView.valueLabel.text = frameStr;
    processView.TotalFrameView.valueLabel.text = [NSString stringWithFormat:@"%u", (unsigned int)TotalFrames];
    processView.ElapsedTimeView.valueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool get_HMS_TimeWith: ((NSInteger)(msecond1 - [[[NSUserDefaults standardUserDefaults] objectForKey:@"startime"] longLongValue]) / 1000)]];
    
    processView.RemainingTimeView.valueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool get_HMS_TimeWith:(NSInteger)finalRunningTime * TotalFrames - ((NSInteger)(msecond1 - [[[NSUserDefaults standardUserDefaults] objectForKey:@"startime"] longLongValue]) / 1000)]];
    
//    processView.countTimerLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith: (NSInteger)(msecond1 - [[[NSUserDefaults standardUserDefaults] objectForKey:@"startime"] longLongValue]) / 1000]];
    
    processView.countTimerLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: (NSInteger)(msecond1 - [[[NSUserDefaults standardUserDefaults] objectForKey:@"startime"] longLongValue]) / 1000], [iFGetDataTool getTimeWith:(NSInteger)finalRunningTime * TotalFrames]];
    
//    self.ifmodel.focalIndex = [[ud objectForKey:FPSValue] integerValue];
    if (isTouchPreview) {
        
        processView.TimeLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: (NSInteger)(msecond1 - [[[NSUserDefaults standardUserDefaults] objectForKey:@"startime"] longLongValue]) / 1000], [iFGetDataTool getTimeWith:preViewSecond]];
        
    }else{
        processView.TimeLabel.text = [NSString stringWithFormat:@"%@/%@", [iFGetDataTool getTimeWith: (NSInteger)(msecond1 - [[[NSUserDefaults standardUserDefaults] objectForKey:@"startime"] longLongValue]) / 1000], [iFGetDataTool getTimeWith:TotalFrames]];
    }
    
    
    
}
- (void)S1A3_S1_SendPositionTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_S1_SendPositionTimerAction, %d", _receiveView.S1A3_S1_Timeline_BezierPosParam);
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * SlideShiftHeadArray = @[@0xA0, @0xA1, @0xA2, @0xA3, @0xA4, @0xA5, @0xA6, @0xA7];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.S1A3_S1_Timeline_BezierPosParam]];
    NSArray * slideArray = [self getNewArray:S1A3_SlidenewPostionArray];
    
    if (a == slideArray.count) {
    
        S1A3_S1_SendPositionTimer.fireDate = [NSDate distantFuture];
        S1A3_S1_SendTimeTimer.fireDate = [NSDate distantPast];
        
    }else{
        
        if (a <= 7 ) {
            [self sendArray:slideArray[a] andFrameHead:OXAAAF andfunNumber:[SlideShiftHeadArray[a] intValue]withCB:CBS1A3_S1 YesOrNo:YES];
        }
        
    }
}
- (void)S1A3_S1_SendTimeTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_S1_SendTimeTimerAction");
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    
    NSArray * SlideFrameHeadArray = @[@0xA8, @0xA9, @0xAA, @0xAB, @0xAC, @0xAD, @0xAE, @0xAF];
    
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.S1A3_S1_Timeline_BezierTimeParam]];
    NSArray * slideArray = [self getNewArray:S1A3_SlidenewFrameArray];
    
    if (a == slideArray.count) {
        
        S1A3_S1_SendTimeTimer.fireDate = [NSDate distantFuture];
        if (CBS1A3_X2.state == CBPeripheralStateConnected) {
            
        }else{
            S1A3_ReturnZeroTimer.fireDate = [NSDate distantPast];
        }
        
    }else{
        if (a <= 7) {
            [self sendArray:slideArray[a] andFrameHead:OXAAAF andfunNumber:[SlideFrameHeadArray[a] intValue] withCB:CBS1A3_S1 YesOrNo:YES];
        }
    }
}
- (void)S1A3_X2_Pan_SendPositionTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_X2_Pan_SendPositionTimerAction");
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * PanShitfHeadArray = @[@0x50, @0x51, @0x52, @0x53, @0x54, @0x55, @0x56, @0x57];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.S1A3_X2_Timeline_Pan_BezierPosParam]];
    NSArray * panArray = [self getNewArray:S1A3_PannewPostionArray];
    if (a == panArray.count) {
        S1A3_X2_Pan_SendPositionTimer.fireDate = [NSDate distantFuture];
        S1A3_X2_Pan_SendTimeTimer.fireDate = [NSDate distantPast];
    }else{
        if (a <= 7 ) {
            
            [self sendArray:panArray[a] andFrameHead:OX555F andfunNumber:[PanShitfHeadArray[a] intValue] withCB:CBS1A3_X2 YesOrNo:YES];
        }
    }
}
- (void)S1A3_X2_Pan_SendTimeTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_X2_Pan_SendTimeTimerAction");
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * PanFrameHeadArray = @[@0x58, @0x59, @0x5A, @0x5B, @0x5C, @0x5D, @0x5E, @0x5F];
    
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.S1A3_X2_Timeline_Pan_BezierTimeParam]];
    NSArray * panArray = [self getNewArray:S1A3_PannewFrameArray];
    if (a == panArray.count) {
            S1A3_X2_Pan_SendTimeTimer.fireDate = [NSDate distantFuture];
            S1A3_X2_Tilt_SendPositionTimer.fireDate = [NSDate distantPast];
    }else{
        if (a <= 7 ) {
            [self sendArray:panArray[a] andFrameHead:OX555F andfunNumber:[PanFrameHeadArray[a] intValue] withCB:CBS1A3_X2 YesOrNo:YES];
        }
        
    }

    
}

- (void)S1A3_X2_Tilt_SendPositionTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_X2_Tilt_SendPositionTimerAction");


    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * TiltShitfHeadArray = @[@0x60, @0x61, @0x62, @0x63, @0x64, @0x65, @0x66, @0x67];
    
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.S1A3_X2_Timeline_Tilt_BezierPosParam]];
    
    NSArray * tiltArray = [self getNewArray:S1A3_TiltnewPostionArray];
    
    if (a == tiltArray.count) {
            S1A3_X2_Tilt_SendPositionTimer.fireDate = [NSDate distantFuture];
            S1A3_X2_Tilt_SendTimetimer.fireDate = [NSDate distantPast];
    }else{
        if (a <= 7 ) {
            [self sendArray:tiltArray[a] andFrameHead:OX555F andfunNumber:[TiltShitfHeadArray[a] intValue] withCB:CBS1A3_X2 YesOrNo:YES];
        }
    }
}

- (void)S1A3_X2_Tilt_SendTimetimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_X2_Tilt_SendTimetimerAction");
    
    NSArray * array = @[@0x00, @0x01, @0x03, @0x07, @0x0f, @0x1f, @0x3f, @0x7f, @0xff];
    NSArray * TiltFrameHeadArray = @[@0x68, @0x69, @0x6A, @0x6B, @0x6C, @0x6D, @0x6E, @0x6F];
    NSInteger a = [array indexOfObject:[NSNumber numberWithChar:_receiveView.S1A3_X2_Timeline_Tilt_BezierTimeParam]];
    NSArray * tiltArray = [self getNewArray:S1A3_TiltnewFrameArray];
    if (a == tiltArray.count) {
        timer.fireDate = [NSDate distantFuture];
        
//        [self performSelector:@selector(backToTheBeginning) withObject:nil afterDelay:second];
        
        S1A3_ReturnZeroTimer.fireDate = [NSDate distantPast];
        
    }else{
        if (a <= 7 ) {
            [self sendArray:tiltArray[a] andFrameHead:OX555F andfunNumber:[TiltFrameHeadArray[a] intValue] withCB:CBS1A3_X2 YesOrNo:YES];
        }
    }
}
static int scount = 0;

- (void)S1A3_TimeCorrectTimerAction:(NSTimer *)timer{
    int a = scount % 10;
    scount++;
    if (a == 0) {
        startTime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
    }
    
    [self getConntionStatus];
    
    NSLog(@"S1A3_TimeCorrectTimerAction");
    switch (_status) {
            
        case StatusSLIDEandX2AllConnected:
            
            if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x01 && _receiveView.S1A3_X2_Timeline_TaskMode == 0x01) {
//                dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                dispatch_async(globalQueue, ^{
                    [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];
                    [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];
                    
                    
//                });
            }
#warning 2017年03月04日09:24:41 修改正在运行的状态 ！！！！
            
            if (_receiveView.S1A3_S1_Timeline_StartTimer == (UInt32)startTime && _receiveView.S1A3_X2_Timeline_StartTimer == (UInt32)startTime) {
                //            [ud setObject:[NSNumber numberWithInteger:startTime] forKey:@"startime"];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
                
                
                [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];
                
                S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
                
                timer.fireDate = [NSDate distantFuture];
            }
            
            if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x02 && _receiveView.S1A3_X2_Timeline_TaskMode == 0x02) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
            
                
                S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
                
                timer.fireDate = [NSDate distantFuture];
            }
            break;
            case StatusSLIDEOnlyConnected:
            
            if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x01) {
                
                [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];
                
            }
            
            if (_receiveView.S1A3_S1_Timeline_StartTimer == (UInt32)startTime) {

                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
                [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];

                S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
                
                timer.fireDate = [NSDate distantFuture];
            }
            if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x02) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
                [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];

                S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
//
                timer.fireDate = [NSDate distantFuture];
                
            }
            
            
            break;
            case StatusX2OnlyConnected:
            //发送x2开始时间
            if (_receiveView.S1A3_X2_Timeline_TaskMode == 0x01) {
                NSLog(@"发送开始");
                
                [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x02 andTimestamp:startTime WithStr:SendStr andisLoop:isloop];
                
            }
//
            if (_receiveView.S1A3_X2_Timeline_StartTimer == (UInt32)startTime) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];

                [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];

                S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
                timer.fireDate = [NSDate distantFuture];
            }
//
            if (_receiveView.S1A3_X2_Timeline_TaskMode == 0x02) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedLongLong:startTime] forKey:@"startime"];
                
                S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
                [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];

                timer.fireDate = [NSDate distantFuture];
                
            }
         
            
            
            
            
            break;
            case StatusSLIDEandX2AllDisConnected:
            
            
        default:
            break;
    }
}
- (void)S1A3_SendSettingTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_SendSettingTimerAction");
    
    //    NSLog(@"标准T1 = %f ST2 = %d, X2T3 = %d",self.ifmodel.totalTimes, _receiveView.slideVideoTime, _receiveView.x2VideoTime);
    
    UInt32 sendTime = (UInt32)S1A3Model.S1A3_VideoTotalTimes;
//
    if (isTouchPreview) {
        sendTime = (UInt32)preViewSecond;
    }
    
    if (loopModeView.MODEL == MODEL_VIDEO) {
        if (CBS1A3_S1.state == CBPeripheralStateConnected) {
            [self.sendDataView sendVedioTimeDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x04 andVideoTime:sendTime andBezierCount:(UInt8)SliderBazierView.PointArray.count WithStr:SendStr];
        }
        if (CBS1A3_X2.state == CBPeripheralStateConnected) {
            [self.sendDataView sendVedioTimeDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x04 andVideoTime:sendTime andPanBezierCount:(UInt8)PanBazierView.PointArray.count andTiltBezierCount:(UInt8)TiltBazierView.PointArray.count WithStr:SendStr];
        }
        if (_status == StatusSLIDEandX2AllConnected) {
            
            if (_receiveView.S1A3_S1_Video_TotalTime == sendTime && _receiveView.S1A3_X2_Video_TotalTime == (Float32)sendTime) {
                
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
        }else if (_status == StatusSLIDEOnlyConnected){
            
            if (_receiveView.S1A3_S1_Video_TotalTime == sendTime) {
                
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
            
        }else if (_status == StatusX2OnlyConnected){
            if (_receiveView.S1A3_X2_Video_TotalTime == sendTime) {
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
        }else if (_status == StatusSLIDEandX2AllDisConnected){
                        NSLog(@"\r\n发送配置参数未连接");
        }
        
        
    }else if (loopModeView.MODEL == MODEL_TIMELAPSE){
        
        
//        NSInteger interval1 = ([_timeArr[self.ifmodel.intervalTimeIndex] integerValue]);
        NSInteger fpsValue = [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
        UInt32 TotalFrames = 0;
        if (S1A3Model.S1A3_DisPlayMode == 1) {
            TotalFrames = (UInt32)(fpsValue * S1A3Model.S1A3_TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
        }
        
        
        if (CBS1A3_S1.state == CBPeripheralStateConnected) {
            
            [self.sendDataView sendTimelapseSetDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x03 andInterval:finalRunningTime andExposure:S1A3Model.S1A3_ExpoSecond andFrames:TotalFrames andMode:S1A3Model.S1A3_ShootingMode andBezierCount:(UInt8)SliderBazierView.PointArray.count WithStr:SendStr andBuffer_second:S1A3Model.S1A3_BufferSecond];
            
        }
        if (CBS1A3_X2.state == CBPeripheralStateConnected) {
          
            [self.sendDataView sendTimelapseSetDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x03 andInterval:finalRunningTime andExposure:S1A3Model.S1A3_ExpoSecond andFrames:TotalFrames andMode:S1A3Model.S1A3_ShootingMode andPanBezierCount:(UInt8)PanBazierView.PointArray.count andTiltBezierCount:(UInt8)TiltBazierView.PointArray.count WithStr:SendStr andBuffer_second:S1A3Model.S1A3_BufferSecond];

        }
        
#pragma mark - (03)发送配置参数 -
        if (_status == StatusSLIDEandX2AllConnected) {
            if (_receiveView.S1A3_S1_Timelapse_TotalFrames == TotalFrames && _receiveView.S1A3_X2_Timelapse_TotalFrames == TotalFrames) {
                
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
            
        }else if (_status == StatusSLIDEOnlyConnected){
            
            if (_receiveView.S1A3_S1_Timelapse_TotalFrames == TotalFrames) {
                
                [self performSelector:@selector(startSendArray) withObject:nil afterDelay:0.1f];
                timer.fireDate = [NSDate distantFuture];
            }
            
        }else if (_status == StatusX2OnlyConnected){
            if (_receiveView.S1A3_X2_Timelapse_TotalFrames == TotalFrames) {
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
- (void)S1A3_ClearSettingTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_ClearSettingTimerAction");
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    if (CBS1A3_S1.state == CBPeripheralStateConnected) {
        [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    }
    if (CBS1A3_X2.state == CBPeripheralStateConnected) {
        [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F  andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    }
}
- (void)S1A3_SendStopMotionTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_SendStopMotionTimerAction");
    [self getConntionStatus];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
    if (_status == StatusSLIDEandX2AllConnected) {
        
        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            
            if (_receiveView.S1A3_S1_StopMotion_Mode == 0x01 && _receiveView.S1A3_X2_StopMotion_Mode == 0x01) {
                dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(globalQueue, ^{
                    
                    [self.sendDataView sendStopMotionSetWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
                    
                    [self.sendDataView sendStopMotionSetWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
                });
            }
            
            if (_receiveView.S1A3_S1_StopMotion_CurrentFrame > 0 && _receiveView.S1A3_X2_StopMotion_CurrentFrame > 0) {
                
                S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
                [SVProgressHUD dismiss];
                timer.fireDate = [NSDate distantFuture];
                
            }
            
        });
        
    }else if (_status == StatusSLIDEOnlyConnected) {
        if (_receiveView.S1A3_S1_StopMotion_Mode == 0x01) {
            [self.sendDataView sendStopMotionSetWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
        }
        if (_receiveView.S1A3_S1_StopMotion_CurrentFrame > 0) {
            [SVProgressHUD dismiss];
            S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
            
            timer.fireDate = [NSDate distantFuture];
        }
        
        
    }else if (_status == StatusX2OnlyConnected) {
        if (_receiveView.S1A3_X2_StopMotion_Mode == 0x01)  {
            [self.sendDataView sendStopMotionSetWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x02 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
        }
        if (_receiveView.S1A3_X2_StopMotion_CurrentFrame > 0)  {
            [SVProgressHUD dismiss];
            S1A3_ShowprocessTimer.fireDate = [NSDate distantPast];
            
            timer.fireDate = [NSDate distantFuture];
            
        }
        
    }else if (_status == StatusSLIDEandX2AllDisConnected) {
        timer.fireDate = [NSDate distantFuture];
        
    }
    
    
}

- (void)S1A3_ReturnZeroTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_ReturnZeroTimerAction");
    
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    [self getConntionStatus];
    
    switch (_status) {
        case StatusSLIDEandX2AllConnected:
            
            NSLog(@"回零StatusSLIDEandX2AllConnected");
            
            if (loopModeView.MODEL == MODEL_STOPMOTION) {
                
                if (_receiveView.S1A3_S1_StopMotion_Mode == 0x01 && _receiveView.S1A3_X2_StopMotion_Mode == 0x01) {
                    
                    
                    if (isTouchReturnBack) {
                        self.PlayBtn.alpha = 1;
                        self.StopBtn.alpha = 0;
//
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];
//
                        timer.fireDate = [NSDate distantFuture];
                        isTouchReturnBack = NO;
//
                    
                    }else{
                        S1A3_SendStopMotionTimer.fireDate = [NSDate distantPast];
                        timer.fireDate = [NSDate distantFuture];
                        startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                    }
                    
                }else{
                    
                    [self.sendDataView sendStopMotionSetWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
                    [self.sendDataView sendStopMotionSetWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
                    
                }
                
            }else{
                
                
                if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x01 && _receiveView.S1A3_X2_Timeline_TaskMode == 0x01) {
                    
                    
                    if (isTouchReturnBack) {
//
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];
                        self.PlayBtn.alpha = 1;
                        self.StopBtn.alpha = 0;
                        timer.fireDate = [NSDate distantFuture];
                        isTouchReturnBack = NO;
//
//
                    }else{
//
                        timer.fireDate = [NSDate distantFuture];
                        S1A3_TimeCorrectTimer.fireDate = [NSDate distantPast];
                        startTime = [[NSDate date] timeIntervalSince1970] * 1000;
//
                    }
                    
                }else{
                    [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
                    [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
                }
                
            }
            

            break;
            case StatusSLIDEOnlyConnected:
            NSLog(@"回零StatusSLIDEOnlyConnected");

            if (loopModeView.MODEL == MODEL_STOPMOTION) {
                if (_receiveView.S1A3_S1_StopMotion_Mode == 0x01) {
                    
                
                if (isTouchReturnBack) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];
                    self.PlayBtn.alpha = 1;
                    self.StopBtn.alpha = 0;
                    timer.fireDate = [NSDate distantFuture];
                    isTouchReturnBack = NO;
//
                }else{
//
                    S1A3_SendStopMotionTimer.fireDate = [NSDate distantPast];
                    timer.fireDate = [NSDate distantFuture];
                    startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                }
            }else{
                
                [self.sendDataView sendStopMotionSetWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
            }
                
            }else{
                if ( _receiveView.S1A3_S1_Timeline_TaskMode == 0x01) {
                    
                    if (isTouchReturnBack) {
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];                    self.PlayBtn.alpha = 1;
                        self.StopBtn.alpha = 0;
                        timer.fireDate = [NSDate distantFuture];
                        isTouchReturnBack = NO;
//
                    }else{
         
                        
                        S1A3_TimeCorrectTimer.fireDate = [NSDate distantPast];
                        timer.fireDate = [NSDate distantFuture];
                        startTime = [[NSDate date] timeIntervalSince1970] * 1000;
  
//
                    }
                }else{
                    
                    [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
//
                }
                
            }
            
            break;
            case StatusX2OnlyConnected:
            NSLog(@"回零StatusX2OnlyConnected");
            
            if (loopModeView.MODEL == MODEL_STOPMOTION) {
                if ( _receiveView.S1A3_X2_StopMotion_Mode == 0x01) {
                    if (isTouchReturnBack) {
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];                    self.PlayBtn.alpha = 1;
                        self.StopBtn.alpha = 0;
                        timer.fireDate = [NSDate distantFuture];
                        isTouchReturnBack = NO;
//
                        
                    }else{
//
                        S1A3_SendStopMotionTimer.fireDate = [NSDate distantPast];
                        timer.fireDate = [NSDate distantFuture];
                        startTime = [[NSDate date] timeIntervalSince1970] * 1000;
                    }
                    
                }else{
                    [self.sendDataView sendStopMotionSetWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:0x00 andTimestamp:recordTime CurrentFrame:0x00 andlongestTime:0x00 WithStr:SendStr];
                }
                
                
            }else{
                
                if (_receiveView.S1A3_X2_Timeline_TaskMode == 0x01) {
                    
                    if (isTouchReturnBack) {
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_ReturnToStart, nil)];                    self.PlayBtn.alpha = 1;
                        self.StopBtn.alpha = 0;
                        timer.fireDate = [NSDate distantFuture];
                        isTouchReturnBack = NO;
//
                    }else{
     
                        
                        S1A3_TimeCorrectTimer.fireDate = [NSDate distantPast];
                        timer.fireDate = [NSDate distantFuture];
                        startTime = [[NSDate date] timeIntervalSince1970] * 1000;
          
                    
                    }
                }else{
                    NSLog(@"发送回零");
                    [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x00 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
//
                }
            }
            break;
            case StatusSLIDEandX2AllDisConnected:
            break;
            
        default:
            break;
    }

}
- (void)S1A3_StopTimerAction:(NSTimer *)timer{
    
}
#pragma  mark -----processDelegate ------
- (void)stopActionDelegateMethod{
    [self StopBtnAction:nil];
    
}
- (void)stopMotion_lastPicActionDelegateMethod{
    [self stopMotionAction:0x03];

}
- (void)stopMotionActionDelegateMethod{
    
    [self stopMotionAction:0x02];
}
- (void)backActionDelegateMethod{
    [self backTolastViewController];
}
- (void)loopActionDelegateMethod{
    
    if (processView.isloopBtn.selected) {
        NSLog(@"1");
        isloop = 0x01;
        
    }else{
        isloop = 0x00;
        NSLog(@"2");
    }
    
    [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x01 andTimestamp:0x00 WithStr:SendStr andisLoop:isloop];
    [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x01 andTimestamp:0x00 WithStr:SendStr andisLoop:isloop];
    
}
- (void)S1A3_ShowprocessTimerAction:(NSTimer *)timer{
    NSLog(@"S1A3_ShowprocessTimerAction");
    processView.TimelapseMode = loopModeView.MODEL;
    if (isTouchPreview) {
        [processView showWithMode:loopModeView.MODEL andTitle:@"preview"];
    }
    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        NSLog(@"loopModeView.MODEL");
        
        TotalFrames = S1A3Model.S1A3_VideoTotalTimes;
        
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
    }else{
        NSInteger fpsValue = [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
        if (S1A3Model.S1A3_DisPlayMode == 1) {
            TotalFrames = (UInt32)(fpsValue * S1A3Model.S1A3_TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
        }
    }
    
    if (loopModeView.MODEL == MODEL_STOPMOTION) {
        
        if (_status == StatusSLIDEandX2AllConnected) {
            if (_receiveView.S1A3_S1_StopMotion_Mode == 0x02 && _receiveView.S1A3_X2_StopMotion_Mode == 0x02) {
                

                
                [SVProgressHUD dismiss];
                
                processView.alpha = ProcessALPHA;
                
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                [self.view bringSubviewToFront:processView];
                
            }else if (_receiveView.S1A3_S1_StopMotion_Mode == 0x01 || _receiveView.S1A3_X2_StopMotion_Mode == 0x01){
                //                NSLog(@"正在回零");
                //                showprocessTimer.fireDate = [NSDate distantPast];
                
            }
            else{
                
                if (isloop == 0x01) {
                    
                }else{
                    processView.alpha = 0;
                    
                    
                    NSLog(@"结束");
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        
                        loopModeView.MODEL = S1A3Model.S1A3_FunctionMode;
                    }
                    
//                    isStopMotionOn = NO;
                    
                    timer.fireDate = [NSDate distantFuture];
                }
                
            }
            
        }else if (_status == StatusSLIDEOnlyConnected){
            if (_receiveView.S1A3_S1_StopMotion_Mode == 0x02) {
                
                CGFloat moveXvalue = 0.0f;
                moveXvalue = (CGFloat)_receiveView.slideStopMotionCurruntFrame / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                intervalView.markShaft.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                
                [SVProgressHUD dismiss];
                processView.alpha = ProcessALPHA;
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                
                [self.view bringSubviewToFront:processView];
                
            }else if (_receiveView.S1A3_S1_StopMotion_Mode == 0x01 || _receiveView.S1A3_X2_StopMotion_Mode == 0x01){
                //                NSLog(@"正在回零");
                //                showprocessTimer.fireDate = [NSDate distantPast];
                
            }
            else{
                
                if (isloop == 0x01) {
                    
                }else{
                    processView.alpha = 0;
                    
                    //                    NSLog(@"结束");
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
//                    isStopMotionOn = NO;
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = S1A3Model.S1A3_FunctionMode;
                        
                    }
                    
                    timer.fireDate = [NSDate distantFuture];
                }
                
                
            }
            
            
            
        }else if (_status == StatusX2OnlyConnected){
            
            
            
            if (_receiveView.S1A3_X2_StopMotion_Mode == 0x02) {
//                CGFloat moveXvalue = 0.0f;
//                moveXvalue = (CGFloat)_receiveView.x2StopMotionCurruntFrame / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;                [SVProgressHUD dismiss];
//                insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                
                processView.alpha = ProcessALPHA;
                processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                
                [self.view bringSubviewToFront:processView];
                
            }else if (_receiveView.S1A3_S1_StopMotion_Mode == 0x01 || _receiveView.S1A3_X2_StopMotion_Mode == 0x01){
                //                NSLog(@"正在回零");
                //                showprocessTimer.fireDate = [NSDate distantPast];
                
            }
            else{
                
                if (isloop == 0x01) {
                    
                }else{
                    processView.alpha = 0;
                    
                    //                    NSLog(@"结束");
//                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Timeline_HasFinished, nil)];
//                    isStopMotionOn = NO;
                    if (isTouchPreview) {
                        isTouchPreview = NO;
                        loopModeView.MODEL = S1A3Model.S1A3_FunctionMode;
                        
                    }
                    
                    
                    timer.fireDate = [NSDate distantFuture];
                }
                
            }
            
            
            
        }else if (_status == StatusSLIDEandX2AllDisConnected) {
            
        }
    }else{
        
        if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x02 ||_receiveView.S1A3_X2_Timeline_TaskMode == 0x02) {
//            CGFloat moveXvalue = 0.0f;
//            moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//            insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
            
            isPlayOn = YES;
            self.PlayBtn.alpha = 0;
            self.StopBtn.alpha = 1;
            
            
        }
#pragma mark ---- 判断开始和结束显示状态-------
        if (_status == StatusSLIDEandX2AllConnected) {
            if (isPlayOn) {
                if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x02 && _receiveView.S1A3_X2_Timeline_TaskMode == 0x02) {
                    if (loopModeView.MODEL == MODEL_VIDEO) {
//                        CGFloat moveXvalue = 0.0f;
                        
                        
                        //                    moveXvalue = (CGFloat)(msecond1 - [[ud objectForKey:@"startime"] integerValue]) / 1000.0f / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                        moveXvalue = (CGFloat)(_receiveView.S1timelinePercent / 100.0f) * SliderBazierView.frame.size.width;
                        //                    NSLog(@"%lf", moveXvalue);
                        
                        
//                        insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                        
                    }else{
                        //
//                        CGFloat moveXvalue = 0.0f;
//                        moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
                        //                    NSLog(@"%lf", moveXvalue);
                        
//                        insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                    }
                    

                    [SVProgressHUD dismiss];
                    
                    processView.alpha = ProcessALPHA;
                    processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                    
                    [self.view bringSubviewToFront:processView];
                    
                }else if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x01 || _receiveView.S1A3_X2_Timeline_TaskMode == 0x01){
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
//                        isStopMotionOn = NO;
                        
                        if (isTouchPreview) {
                            isTouchPreview = NO;
                            loopModeView.MODEL =  S1A3Model.S1A3_FunctionMode;
                        }
                        
                        self.PauseBtn.alpha = 0;
                        self.preViewBtn.alpha = 1;
                        
                        timer.fireDate = [NSDate distantFuture];
                    }
                    
                }
            }
        }else if (_status == StatusSLIDEOnlyConnected){
            
            
            if (isPlayOn) {
                
                if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x02) {
                    [SVProgressHUD dismiss];
                    if (loopModeView.MODEL == MODEL_VIDEO) {
//                        CGFloat moveXvalue = 0.0f;
//                        moveXvalue = (CGFloat)(_receiveView.S1timelinePercent / 100.0f) * SliderBazierView.frame.size.width;
//                        insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                        
                    }else{
                        
//                        CGFloat moveXvalue = 0.0f;
//                        moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                        insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                    }
                    processView.alpha = ProcessALPHA;
                    processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                    [self.view bringSubviewToFront:processView];
                    
                }else if (_receiveView.S1A3_S1_Timeline_TaskMode == 0x01){
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
//                        isStopMotionOn = NO;
                        if (isTouchPreview) {
                            isTouchPreview = NO;
                            loopModeView.MODEL =  S1A3Model.S1A3_FunctionMode;
                        }
                        
                        self.PauseBtn.alpha = 0;
                        self.preViewBtn.alpha = 1;
                        
                        timer.fireDate = [NSDate distantFuture];
                    }
                    
                    
                }
            }
            
        }else if (_status == StatusX2OnlyConnected) {
            
            
            
            if (isPlayOn) {
                
                if ( _receiveView.S1A3_X2_Timeline_TaskMode == 0x02) {
                    
                    if (loopModeView.MODEL == MODEL_VIDEO) {
//                        CGFloat moveXvalue = 0.0f;
                        //                    CGFloat realmoveXvalue = (CGFloat)(msecond1 - [[ud objectForKey:@"startime"] integerValue]) / 1000.0f;
                        
                        //                    if (realmoveXvalue > TotalFrames) {
                        //                        realmoveXvalue = realmoveXvalue - TotalFrames;
                        //                    }
                        
                        //                    moveXvalue = realmoveXvalue / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
//                        moveXvalue = (CGFloat)(_receiveView.X2timelinePercent / 100.0f) * SliderBazierView.frame.size.width;
                        
                        //                    NSLog(@"%lf", moveXvalue);
                        
//                        insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                        
                    }else{
//                        CGFloat moveXvalue = 0.0f;
//                        moveXvalue = (CGFloat)_receiveView.slideframes / (CGFloat)TotalFrames * SliderBazierView.frame.size.width;
                        //                    NSLog(@"%lf", moveXvalue);
                        
//                        insertView.center = CGPointMake(leftLimit + moveXvalue , self.view.frame.size.height / 2);
                    }
                    
                    
                    [SVProgressHUD dismiss];
                    
                    processView.alpha = ProcessALPHA;
                    processView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.1f];
                    
                    [self.view bringSubviewToFront:processView];
                    
                    
                }else if (_receiveView.S1A3_X2_Timeline_TaskMode == 0x01){
                    //                showprocessTimer.fireDate = [NSDate distantPast];
                    
                                    NSLog(@"正在回零中 有bug！！！！");
                    
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
//                        isStopMotionOn = NO;
                        if (isTouchPreview) {
                            isTouchPreview = NO;
                            loopModeView.MODEL =  S1A3Model.S1A3_FunctionMode;
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
- (void)backTolastViewController{
    
    if (_isSaveData) {
        [self saveDataWithBOOLYES];
    }
    S1A3Model.S1A3_SlideUpValue = [SlideCustomSlider.uplabel.text floatValue];
    S1A3Model.S1A3_SlideDownValue = [SlideCustomSlider.downlabel.text floatValue];
    S1A3Model.S1A3_PanUpValue = [PanCustomSlider.uplabel.text floatValue];
    S1A3Model.S1A3_PanDownValue = [PanCustomSlider.downlabel.text floatValue];
    S1A3Model.S1A3_TiltUpValue = [TiltCustomSlider.uplabel.text floatValue];
    S1A3Model.S1A3_TiltDownValue = [TiltCustomSlider.downlabel.text floatValue];
    S1A3Model.S1A3_FunctionMode = (NSInteger)loopModeView.MODEL;
}
- (void)saveDataWithBOOLYES{
    
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_ProperKeyFrameList];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    dataArray = [NSMutableArray arrayWithArray:array];
    
    
    //    NSLog(@"%ld", (long)_indexRow);
    //    BOOL isindex =
    if (dataArray.count >= 1) {
        if (_indexRow) {
            S1A3Model.S1A3_NameStr =  dataArray[_indexRow][@"S1A3_NameStr"];
        }else if (_indexRow == 0){
            S1A3Model.S1A3_NameStr =  dataArray[_indexRow][@"S1A3_NameStr"];
        }
        
    }
    S1A3Model.S1A3_SlideArray = [self loopCreateNewTypeArray:SliderBazierView.PointArray];
    S1A3Model.S1A3_PanArray = [self loopCreateNewTypeArray:PanBazierView.PointArray];
    S1A3Model.S1A3_TiltArray = [self loopCreateNewTypeArray:TiltBazierView.PointArray];
    S1A3Model.S1A3_SlideControlArray = [self loopCreateNewControlTypeArray:SliderBazierView.ControlPointArray];
    S1A3Model.S1A3_PanControlArray = [self loopCreateNewControlTypeArray:PanBazierView.ControlPointArray];
    S1A3Model.S1A3_TiltControlArray = [self loopCreateNewControlTypeArray:TiltBazierView.ControlPointArray];
    
    
    S1A3Model.S1A3_SlideUpValue = [SlideCustomSlider.uplabel.text floatValue];
    S1A3Model.S1A3_SlideDownValue = [SlideCustomSlider.downlabel.text floatValue];
    S1A3Model.S1A3_PanUpValue = [PanCustomSlider.uplabel.text floatValue];
    S1A3Model.S1A3_PanDownValue = [PanCustomSlider.downlabel.text floatValue];
    S1A3Model.S1A3_TiltUpValue = [TiltCustomSlider.uplabel.text floatValue];
    S1A3Model.S1A3_TiltDownValue = [TiltCustomSlider.downlabel.text floatValue];
    S1A3Model.S1A3_FunctionMode = (NSInteger)loopModeView.MODEL;
    
    NSDictionary * dict = [S1A3Model dictionaryWithValuesForKeys:[S1A3Model allPropertyNames]];

    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initS1A3_Data{
    self.configs = [NSMutableArray arrayWithArray:@[@"24fps", @"25fps", @"30fps", @"50fps", @"60fps"]];
    
    if (_isSaveData) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        //    取得第一个Documents文件夹的路径
        NSString *filePath = [path objectAtIndex:0];
        NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_ProperKeyFrameList];
        NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
        dataArray = [NSMutableArray arrayWithArray:array];
        NSDictionary * dict = dataArray[_indexRow];
        
        S1A3Model.S1A3_TimelapseTotalFrames = [dict[@"S1A3_TimelapseTotalFrames"] integerValue];
        S1A3Model.S1A3_fpsIndex = [dict[@"S1A3_fpsIndex"] integerValue];
//        self.ifmodel.upSliderValue = [dict[@"upSliderValue"] floatValue];
//        if (self.ifmodel.upSliderValue >= SlideConunt(self.ifmodel.slideCount)) {
//            self.ifmodel.upSliderValue = SlideConunt(self.ifmodel.slideCount);
//        }
        S1A3Model.S1A3_SlideDownValue = [dict[@"S1A3_SlideDownValue"] floatValue];
        
        S1A3Model.S1A3_PanUpValue = [dict[@"S1A3_PanUpValue"] floatValue];
        S1A3Model.S1A3_PanDownValue = [dict[@"S1A3_PanDownValue"] floatValue];
        
        S1A3Model.S1A3_TiltUpValue = [dict[@"S1A3_TiltUpValue"] floatValue];
        S1A3Model.S1A3_TiltDownValue = [dict[@"S1A3_TiltDownValue"] floatValue];
//        S1A3Model.shootMode = [[ud objectForKey:SHOOTINGMODE] integerValue];
        //            self.ifmodel.displayUnit = [dict[@"displayUnit"] integerValue];
//        S1A3Model.displayUnit = [[ud objectForKey:DISPLAYUNIT] integerValue];
        
        S1A3Model.S1A3_VideoTotalTimes = [dict[@"S1A3_VideoTotalTimes"] floatValue];
        
        S1A3Model.S1A3_TimelapseTotalTimes = [dict[@"S1A3_TimelapseTotalTimes"] floatValue];
        S1A3Model.S1A3_FunctionMode = [dict[@"S1A3_FunctionMode"] integerValue];
        //            self.ifmodel.slideCount = [dict[@"slideCount"] integerValue];
        
        S1A3Model.S1A3_ExpoSecond = [dict[@"S1A3_ExpoSecond"] integerValue];
        S1A3Model.S1A3_BufferSecond = [dict[@"S1A3_BufferSecond"] integerValue];
        
        S1A3Model.S1A3_SlideArray = [self getValueArrayWithStringArray:dict[@"S1A3_SlideArray"]];
        S1A3Model.S1A3_SlideControlArray = [self getValueControlArrayWithStringControlArray:dict[@"S1A3_SlideControlArray"]];
        S1A3Model.S1A3_PanArray = [self getValueArrayWithStringArray:dict[@"S1A3_PanArray"]];
        S1A3Model.S1A3_PanControlArray = [self getValueControlArrayWithStringControlArray:dict[@"S1A3_PanControlArray"]];
        S1A3Model.S1A3_TiltArray = [self getValueArrayWithStringArray:dict[@"S1A3_TiltArray"]];
        S1A3Model.S1A3_TiltControlArray = [self getValueControlArrayWithStringControlArray:dict[@"S1A3_TiltControlArray"]];
    }else{
    
    if (!S1A3Model.S1A3_SlideArray) {
        S1A3Model.S1A3_SlideArray = @[Point(0, downLimit - topLimit), Point(rightLimit , downLimit - topLimit)];
    }
    if (!S1A3Model.S1A3_PanArray) {
        S1A3Model.S1A3_PanArray = @[Point(0, (downLimit - topLimit) * 0.5), Point((rightLimit ), (downLimit - topLimit) * 0.5)];
    }
    if (!S1A3Model.S1A3_TiltArray) {
        S1A3Model.S1A3_TiltArray = @[Point(0, (downLimit - topLimit) * 0.5), Point((rightLimit ), (downLimit - topLimit) * 0.5)];
    }
    }
}
- (NSArray *)getValueArrayWithStringArray:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray new];
    for (NSString * string in array) {
        
        [newArray addObject:[NSValue valueWithCGPoint:CGPointFromString(string)]];
    }
    NSLog(@"======%@", newArray);
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
#pragma mark -----创建Slide、Pan、Tilt曲线视图-------
- (void)createSlide_Pan_TiltBezierView{
    
    backView = [[iFBackImageView alloc]initWithFrame:CGRectMake(leftLimit, topLimit, rightLimit, downLimit - topLimit)];
    [backView createUIWithFrames:100 orWithTimes:0];
    [self.view addSubview:backView];
    
    SliderBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit, topLimit ,rightLimit, downLimit - topLimit)andColor:COLOR(255, 0, 255, 1) array:S1A3Model.S1A3_SlideArray WithControl:S1A3Model.S1A3_SlideControlArray];
    SliderBazierView.delegate = self;
    SliderBazierView.tag = 1;
    PanBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit,topLimit ,rightLimit, downLimit - topLimit)andColor: COLOR(0, 255, 255, 1) array:S1A3Model.S1A3_PanArray WithControl:nil];
    PanBazierView.delegate = self;
    PanBazierView.tag = 2;
    TiltBazierView = [[iFBazierView alloc]initWithFrame:CGRectMake(leftLimit,topLimit ,rightLimit, downLimit - topLimit) andColor:COLOR(255, 255, 0, 1) array:S1A3Model.S1A3_TiltArray WithControl:nil];
    TiltBazierView.delegate = self;
    TiltBazierView.tag = 3;
    [self.view addSubview:TiltBazierView];
    [self.view addSubview:PanBazierView];
    [self.view addSubview:SliderBazierView];
    
    int a = S1A3_TrackNumber(S1A3Model.S1A3_SlideCount);
    
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
                        :S1A3_PanMaxValue * 2];
    PanCustomSlider.alpha = 0;
    PanCustomSlider.changeDelegate = self;
    [self.view addSubview:PanCustomSlider];
    TiltCustomSlider  = [[iFCustomSlider alloc]initWithFrame
                         :CGRectMake(0, 0, a * 0.05, downLimit - topLimit)
                         :COLOR(255, 255, 0, 1)
                         :S1A3_TiltMaxValue * 2];
    TiltCustomSlider.changeDelegate = self;
    TiltCustomSlider.alpha = 0;
    [self.view addSubview:TiltCustomSlider];
    
    [SlideCustomSlider changeWithAllValue:S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue andUpValue:S1A3Model.S1A3_SlideUpValue andDownValue:S1A3Model.S1A3_SlideDownValue WithModel:MODEL_SLIDER];
    
    [PanCustomSlider changeWithAllValue:(S1A3_PanMaxValue * 2) andUpValue:S1A3Model.S1A3_PanUpValue andDownValue:S1A3Model.S1A3_PanDownValue WithModel:MODEL_PAN];
    [TiltCustomSlider changeWithAllValue:S1A3_TiltMaxValue * 2 andUpValue:S1A3Model.S1A3_TiltUpValue andDownValue:S1A3Model.S1A3_TiltDownValue WithModel:MODEL_TILT];

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
- (void)createAllPickerView{
    CGFloat BtnWidth;
    CGFloat interValDistance;
    CGFloat headDistance;
    
    if (kDevice_Is_iPhoneX) {
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
 
    UITapGestureRecognizer * loopGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loopGestureAction:)];
    UITapGestureRecognizer * ExpoGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ExpoGestureAction:)];
    UITapGestureRecognizer * BufferGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(BufferGestureAction:)];
    UITapGestureRecognizer * TimelapseFrameGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timelapseFrameGestureAction:)];
    UITapGestureRecognizer * TimelapseTimeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TimelapseTimeGestureAction:)];
    UITapGestureRecognizer * VideoTimeGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(VideoGestureAction:)];
    UITapGestureRecognizer * fpsGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fpsGestureAction:)];
    
    loopModeView = [[iFLoopView alloc]initWithFrame:CGRectMake(0, 0, iFSize(100), BtnWidth)];
    [loopModeView addGestureRecognizer:loopGesture];

    [loopModeView loopChangeTitle:S1A3Model.S1A3_FunctionMode];
    [self.view addSubview:loopModeView];
    expoLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.11, BtnWidth) andTitle:[NSString stringWithFormat:@"Expo:%.2lds", S1A3Model.S1A3_ExpoSecond]];
    [expoLabel addGestureRecognizer:ExpoGesture];
    expoLabel.tag = ExposureLabelTag;
    [self.view addSubview:expoLabel];
    bufferLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.12, BtnWidth) andTitle:[NSString stringWithFormat:@"Buffer:%.2lds", S1A3Model.S1A3_BufferSecond]];
    bufferLabel.tag = BufferLabelTag;
    [bufferLabel addGestureRecognizer:BufferGesture];
    
    [self.view addSubview:bufferLabel];
    
    frameLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.19, BtnWidth) andTitle:[NSString stringWithFormat:@"Frame:%ld",S1A3Model.S1A3_TimelapseTotalFrames]];
    [frameLabel addGestureRecognizer:TimelapseFrameGesture];
    
    [self.view addSubview:frameLabel];
    
    TimelapseTimeLabel = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.19, BtnWidth) andTitle:[NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimelapseTimeWith:S1A3Model.S1A3_TimelapseTotalTimes andFPS:[self.configs[S1A3Model.S1A3_fpsIndex] integerValue]]]];
    [TimelapseTimeLabel addGestureRecognizer:TimelapseTimeGesture];
                          
    
    
    if (S1A3Model.S1A3_DisPlayMode == 0) {
        frameLabel.alpha = 1;
        TimelapseTimeLabel.alpha = 0;

    }else{
        frameLabel.alpha = 0;
        TimelapseTimeLabel.alpha = 1;
    }
    
    [self.view addSubview:TimelapseTimeLabel];
    timeLabel  = [self getLabelWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.19, BtnWidth) andTitle:[NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimeWith:S1A3Model.S1A3_VideoTotalTimes]]];
    timeLabel.alpha = 0;
    [timeLabel addGestureRecognizer:VideoTimeGesture];
    
    [self.view addSubview:timeLabel];
    
    fpsLabel = [self getLabelWithFrame:CGRectMake(0, 0, iFSize(45), BtnWidth) andTitle:[NSString stringWithFormat:@"%@", self.configs[S1A3Model.S1A3_fpsIndex]]];
    [fpsLabel addGestureRecognizer:fpsGesture];
    
    [self.view addSubview:fpsLabel];
    
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
    xValue = intervalView.frame.size.width * Value;
    [intervalView changeMarkShaftXvalue:Value];
    [self judgeInsertIndex:intervalView.frame.size.width * Value];
    NSLog(@"%ld", insertIndex);
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
    
    if (_MODEL == MODEL_SLIDER) {
        ifView = SliderBazierView;
        
    }else if (_MODEL == MODEL_PAN){
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
//                XValue = X;
            }
        }else{
            point1 = [PointArray[i] CGPointValue];
            if (X > point1.x) {
                insertIndex = 9999;
//                XValue = X;
            }
        }
    }
    return insertIndex;
    
}
- (void)insertValue{
    iFBazierView * ifView;
    
    switch (_MODEL) {
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
    
    [ifView insertPoint:xValue andInsertIndex:insertIndex andYdistance:self.YValue];
}


#pragma mark ---所有手势响应方法---------
- (void)loopGestureAction:(UITapGestureRecognizer *)tap{
    NSLog(@"loopGestureAction");
    self.popover = [DXPopover new];
    iFFunctionPicker * picker = [[iFFunctionPicker alloc]init];
    picker.FunctionDelegate = self;
    [picker setInitValue:S1A3Model.S1A3_FunctionMode];
    [self.popover showAtView:tap.view withContentView:picker];
}
/**
 相应loop点击事件 选择timelapse video stopMotion
 
 @param tap 单击循环
 */
- (void)loopAction:(NSInteger)tapIndex{
    
    [loopModeView loopChangeTitle:tapIndex];
    
    if (loopModeView.MODEL == MODEL_TIMELAPSE) {//选择Timelapse 模式

        
        self.PlayBtn.alpha = 1;
        self.StopMotionBtn.alpha = 0;
        self.StopBtn.alpha = 0;

        S1A3Model.S1A3_FunctionMode = 0;
        if (S1A3Model.S1A3_DisPlayMode == 0) {
            frameLabel.alpha = 1;
            TimelapseTimeLabel.alpha = 0;
            [backView chageLabel:S1A3Model.S1A3_TimelapseTotalFrames];
        }else if (S1A3Model.S1A3_DisPlayMode == 1){
            frameLabel.alpha = 0;
            TimelapseTimeLabel.alpha = 1;
            [backView changeLabelWithTimeLapseTime:S1A3Model.S1A3_TimelapseTotalTimes andFPS:[self.configs[S1A3Model.S1A3_fpsIndex] integerValue]];
        }
        bufferLabel.alpha = 1;
        expoLabel.alpha = 1;
        timeLabel.alpha = 0;
        _centerInfoView.alpha = 1;
        
    }else if (loopModeView.MODEL == MODEL_VIDEO){// video 模式

        TimelapseTimeLabel.alpha = 0;
        self.PlayBtn.alpha = 1;
        self.StopBtn.alpha = 0;

        self.StopMotionBtn.alpha = 0;
        S1A3Model.S1A3_FunctionMode = 1;
        [backView chageLabel:S1A3Model.S1A3_VideoTotalTimes];
        
        bufferLabel.alpha = 0;
        expoLabel.alpha = 0;
        frameLabel.alpha = 0;
        timeLabel.alpha = 1;
        _centerInfoView.alpha = 0;
        
    }else if (loopModeView.MODEL == MODEL_STOPMOTION){// 选择stopMotion模式

        TimelapseTimeLabel.alpha = 0;
        S1A3Model.S1A3_FunctionMode = 2;
        self.PlayBtn.alpha = 0;
        self.StopBtn.alpha = 0;
        
        self.StopMotionBtn.alpha = 1;
        [backView chageLabel:S1A3Model.S1A3_TimelapseTotalFrames];
        TimelapseTimeLabel.alpha = 0;
        bufferLabel.alpha = 0;
        expoLabel.alpha = 0;
        frameLabel.alpha = 1;
        timeLabel.alpha = 0;
        _centerInfoView.alpha = 1;
        
    }
    [self countAllpointTime];
//    [self saveDataWithBOOLYES];
//    [self initData];
    
}

#pragma mark ---- getFunctionIndex ------
- (void)getFunctionIndex:(NSInteger)index{
    S1A3Model.S1A3_FunctionMode = index;
     [loopModeView loopChangeTitle:S1A3Model.S1A3_FunctionMode];
    [self loopAction:index];
}


- (void)ExpoGestureAction:(UITapGestureRecognizer *)tap{
    NSInteger timeIndex = 0;
    if (tap.view.tag == ExposureLabelTag) {
        timeIndex = S1A3Model.S1A3_ExpoSecond;
        
    }else if (tap.view.tag == BufferLabelTag){
        timeIndex = S1A3Model.S1A3_BufferSecond;
    }
    self.popover = [DXPopover new];
    [self.popover showAtView:tap.view withContentView:[self getChooseIntervalView:timeIndex withTag:tap.view.tag]];
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
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag == ExposureLabelTag) {
        expoLabel.text = [NSString stringWithFormat:@"Expo:%.2lds", [[_timeArr objectAtIndex:row] integerValue]];
        S1A3Model.S1A3_ExpoSecond = row;
    }else if (pickerView.tag == BufferLabelTag){
        bufferLabel.text = [NSString stringWithFormat:@"Expo:%.2lds", [[_timeArr objectAtIndex:row] integerValue]];
        S1A3Model.S1A3_BufferSecond = row;
    }
    
    [self countAllpointTime];
}

- (void)BufferGestureAction:(UITapGestureRecognizer *)tap{
    NSInteger timeIndex = 0;
    if (tap.view.tag == ExposureLabelTag) {
        timeIndex = S1A3Model.S1A3_ExpoSecond;
    }else if (tap.view.tag == BufferLabelTag){
        timeIndex = S1A3Model.S1A3_BufferSecond;
    }
    self.popover = [DXPopover new];
    [self.popover showAtView:tap.view withContentView:[self getChooseIntervalView:timeIndex withTag:tap.view.tag]];
}
- (void)timelapseFrameGestureAction:(UITapGestureRecognizer *)tap{
    self.popover = [DXPopover new];
    iFFramePickerView * view = [[iFFramePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200))];
    [self.popover showAtView:tap.view withContentView:view];
    __weak typeof(self)weakSelf = self;
    view.Framedelegate =  weakSelf;
    [view setInitValue:S1A3Model.S1A3_TimelapseTotalFrames];
    
     NSLog(@"timelapseFrameGestureAction");
}
- (void)getFrame:(NSInteger)sum{
    S1A3Model.S1A3_TimelapseTotalFrames = sum;
    [backView chageLabel:sum];
    
    frameLabel.text = [NSString stringWithFormat:@"Frame:%ld", sum];
    [self countAllpointTime];
    
}
- (void)TimelapseTimeGestureAction:(UITapGestureRecognizer *)tap{
    self.popover = [DXPopover new];
    iFTimePickerView * view = [[iFTimePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200)) WithFPS:[self.configs[S1A3Model.S1A3_fpsIndex]integerValue]];
    view.timelapseDelegate = self;
    [self.popover showAtView:tap.view withContentView:view];
    if (S1A3Model.S1A3_TimelapseTotalTimes) {
        [view setInitValue:S1A3Model.S1A3_TimelapseTotalTimes];
    }else{
        [view setInitValue:100 / 24.0f];
    }

}
- (void)getTimelapseTime:(CGFloat)totalTime{
    TimelapseTimeLabel.text = [NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimelapseTimeWith:totalTime andFPS:[self.configs[S1A3Model.S1A3_fpsIndex]integerValue]]];
    S1A3Model.S1A3_TimelapseTotalTimes = totalTime;
    S1A3Model.S1A3_TimelapseTotalFrames = totalTime * [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
    [backView changeLabelWithTimeLapseTime:totalTime andFPS:[self.configs[S1A3Model.S1A3_fpsIndex] integerValue]];
    [self countAllpointTime];
}
- (void)VideoGestureAction:(UITapGestureRecognizer *)tap{
    self.popover = [DXPopover new];
    iFTimePickerView * view = [[iFTimePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200)) WithFPS:0];
    view.timeDelegate = self;
    
    [self.popover showAtView:tap.view withContentView:view];
    [view setInitValue:S1A3Model.S1A3_VideoTotalTimes];
    
    NSLog(@"VideoGestureAction");
}
- (void)getTime:(NSInteger)totalSecond{
    
    timeLabel.text = [NSString stringWithFormat:@"Time:%@", [iFGetDataTool getTimeWith:totalSecond]];
    S1A3Model.S1A3_VideoTotalTimes = totalSecond;
    [backView changeLableWithTime:S1A3Model.S1A3_VideoTotalTimes];
    [self countAllpointTime];
    
}

- (void)fpsGestureAction:(UITapGestureRecognizer *)tap{
    iFPickView * pickView = [[iFPickView alloc]initFPSPickWithFrame:CGRectMake(0, 0, 200, 200) andArray:self.configs];
    [pickView setInitValue:S1A3Model.S1A3_fpsIndex];
    pickView.getDelegate = self;
    
    self.popover = [DXPopover new];
    [self.popover showAtView:tap.view withContentView:pickView];
    
    
    NSLog(@"fpsGestureAction");
}
- (void)getIndex:(NSUInteger)idex{
    S1A3Model.S1A3_fpsIndex = idex;
    fpsLabel.text = [NSString stringWithFormat:@"%@", self.configs[idex]];
    NSLog(@"S1A3_TimelapseTotalTimes%f", S1A3Model.S1A3_TimelapseTotalTimes);
    
    if (S1A3Model.S1A3_DisPlayMode == 1) {
        S1A3Model.S1A3_TimelapseTotalFrames = S1A3Model.S1A3_TimelapseTotalTimes * [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
        [backView changeLabelWithTimeLapseTime:S1A3Model.S1A3_TimelapseTotalTimes andFPS:[self.configs[idex] integerValue]];
    }else{
        S1A3Model.S1A3_TimelapseTotalTimes = (CGFloat)S1A3Model.S1A3_TimelapseTotalFrames / [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
    }

    
    [self countAllpointTime];
    
    
}
/**
 全部label的爸爸
 
 @param frame
 
 @return
 */
#pragma mark ----全部label的father------
- (UILabel *)getLabelWithFrame:(CGRect)frame andTitle:(NSString *)title{
    
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    if (kDevice_Is_iPhoneX) {
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.05];
    }else if(kDevice_Is_iPad){
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.03];
    }else{
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.04];
    }
    label.userInteractionEnabled = YES;
    UILabel * slognLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 10)];
    slognLabel.center = CGPointMake(frame.size.width * 0.5, frame.size.height + 5);
    slognLabel.backgroundColor = [UIColor clearColor];
    slognLabel.textColor =COLOR(97, 97, 97, 1);
    slognLabel.textAlignment = NSTextAlignmentCenter;
    
    slognLabel.text = @"﹀";
    [label addSubview:slognLabel];
    return label;
    
}
#pragma mark ---- PlayBtnAction -----
- (void)PlayBtnAction:(UIButton *)btn{
    
    NSLog(@" countAllVideoTime = %d", [self countAllVideoTime:S1A3Model.S1A3_VideoTotalTimes]);
    
    
    [self getConntionStatus];
    
    if (!isTouchPreview) {
        if (loopModeView.MODEL == MODEL_VIDEO) {
            CGFloat RealTimes = S1A3Model.S1A3_VideoTotalTimes;
            if (RealTimes == 0) {
                RealTimes = 1;
            }
            while (![self countAllVideoTime:RealTimes]) {
                RealTimes++;
            }
            if (RealTimes > S1A3Model.S1A3_VideoTotalTimes) {
                
                UIAlertController * alertView = [iFAlertController showAlertControllerWith:@"warm Tips" Message:[NSString stringWithFormat:NSLocalizedString(@"Timeline_VideoTimeWaring", nil), RealTimes] SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
                }];
                [self presentViewController:alertView animated:YES completion:nil];
                
                return;
            }else{
                NSLog(@"正常启动");
            }
        }
    }
    
    
    if (_status == StatusSLIDEandX2AllDisConnected) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_NoDeviceWarning, nil)];
        return;
    }else{
        isPlayOn = YES;
        
        if (isTouchReturnBack) {
            
            [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_ReturnZero, nil)];
        }else{
            
            [SVProgressHUD showWithStatus:NSLocalizedString(Timeline_Preparing, nil)];
        }
    }
    S1A3_StopTimer.fireDate = [NSDate distantFuture];
    [self countAllpointTime];
    
    [self getConntionStatus];
    [SliderBazierView hideControlPointAndLine];
    [TiltBazierView hideControlPointAndLine];
    [PanBazierView hideControlPointAndLine];
   
    self.PlayBtn.alpha = 0;
    self.StopBtn.alpha = 1;
    [self sendClearOrder];
    [self clearAllNSArrays];
    [self GetAllNsArray];
    
    [self performSelector:@selector(S1A3_dalaysendSetParams) withObject:nil afterDelay:0.2f];

}
- (void)StopBtnAction:(UIButton *)btn{
    [SVProgressHUD dismiss];
    
    self.PlayBtn.alpha = 1;
    self.StopBtn.alpha = 0;
    isTouchReturnBack = NO;
    
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
        loopModeView.MODEL = S1A3Model.S1A3_FunctionMode;
    }
    
    self.PauseBtn.alpha = 0;
    self.preViewBtn.alpha = 1;
    [self sendClearOrder];
    
    [self pauseOneTimer:S1A3_S1_SendTimeTimer];
    [self pauseOneTimer:S1A3_S1_SendPositionTimer];
    [self pauseOneTimer:S1A3_X2_Pan_SendTimeTimer];
    [self pauseOneTimer:S1A3_X2_Pan_SendPositionTimer];
    [self pauseOneTimer:S1A3_X2_Tilt_SendTimetimer];
    [self pauseOneTimer:S1A3_X2_Tilt_SendPositionTimer];
    [self pauseOneTimer:S1A3_TimeCorrectTimer];
    [self pauseOneTimer:S1A3_SendSettingTimer];
    [self pauseOneTimer:S1A3_ClearSettingTimer];
    [self pauseOneTimer:S1A3_SendStopMotionTimer];
    [self pauseOneTimer:S1A3_ReturnZeroTimer];
    [self pauseOneTimer:S1A3_StopTimer];
    [self pauseOneTimer:S1A3_ShowprocessTimer];
   
    [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:0x00 WithStr: SendStr andisLoop:isloop];
    [self.sendDataView sendStartCancelPauseDataWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:0x00 WithStr: SendStr andisLoop:isloop];
}
- (void)stopMotionAction:(UInt8)functionMode{
    
    isPlayOn = YES;
    if (!functionMode) {
        functionMode = 0x02;
    }
    
    
    [self getConntionStatus];
    
    if (_status == StatusSLIDEandX2AllConnected) {
        if (_receiveView.S1A3_S1_StopMotion_CurrentFrame > 0 && _receiveView.S1A3_X2_StopMotion_CurrentFrame > 0) {
            [self countStopMotionLongestTimeWithMode:functionMode];
            
        }else if (_receiveView.S1A3_S1_StopMotion_CurrentFrame > S1A3Model.S1A3_TimelapseTotalFrames || _receiveView.S1A3_X2_StopMotion_CurrentFrame > S1A3Model.S1A3_TimelapseTotalFrames){
            
            
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_HasFinishedMaking, nil)];
            
            
        }else{
            
            
            [self PlayBtnAction:nil];
        }
    }else if (_status == StatusSLIDEOnlyConnected){
        if (_receiveView.S1A3_S1_StopMotion_CurrentFrame > 0) {
            [self countStopMotionLongestTimeWithMode:functionMode];

        }else if(_receiveView.S1A3_S1_StopMotion_CurrentFrame > S1A3Model.S1A3_TimelapseTotalFrames){
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_HasFinishedMaking, nil)];
            
        }else{
            
            [self PlayBtnAction:nil];
        }
        
    }else if (_status == StatusX2OnlyConnected){
        if (_receiveView.S1A3_S1_StopMotion_CurrentFrame > 0) {
            [self countStopMotionLongestTimeWithMode:functionMode];
        }else if(_receiveView.S1A3_X2_StopMotion_CurrentFrame > S1A3Model.S1A3_TimelapseTotalFrames   ){
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Timeline_HasFinishedMaking, nil)];
            
        }else{
            
            [self PlayBtnAction:nil];
            
        }
    }else if (_status == StatusSLIDEandX2AllDisConnected) {
        
    }
}

- (void)SaveBtnAction:(UIButton *)btn{
    [self saveDataAndBack];
    
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
        NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_ProperKeyFrameList];
        
        NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
        
        dataArray = [NSMutableArray arrayWithArray:array];
        
        S1A3Model.S1A3_NameStr = newName.text;
        S1A3Model.S1A3_SlideArray = [self loopCreateNewTypeArray:SliderBazierView.PointArray];
        S1A3Model.S1A3_PanArray = [self loopCreateNewTypeArray:PanBazierView.PointArray];
        S1A3Model.S1A3_TiltArray = [self loopCreateNewTypeArray:TiltBazierView.PointArray];
        S1A3Model.S1A3_SlideControlArray = [self loopCreateNewControlTypeArray:SliderBazierView.ControlPointArray];
        S1A3Model.S1A3_PanControlArray = [self loopCreateNewControlTypeArray:PanBazierView.ControlPointArray];
        S1A3Model.S1A3_TiltControlArray = [self loopCreateNewControlTypeArray:TiltBazierView.ControlPointArray];
        S1A3Model.S1A3_FunctionMode = loopModeView.MODEL;
        
        //        self.ifmodel.totalFrames        = [[ud objectForKey:TOTALFRAMES] integerValue];
        //        self.ifmodel.fpsIndex           = [[ud objectForKey:FPSValue] integerValue];
        //        self.ifmodel.intervalTimeIndex  = [[ud objectForKey:INTERVALIndex] integerValue];
        S1A3Model.S1A3_SlideUpValue = [SlideCustomSlider.uplabel.text floatValue];
        
        //    self.ifmodel.downSliderValue    = [[ud objectForKey:DownSlideViewValue] floatValue];
        S1A3Model.S1A3_SlideDownValue = [SlideCustomSlider.downlabel.text floatValue];
        
        //    self.ifmodel.upPanValue         = [[ud objectForKey:UpPanViewValue] floatValue];
        S1A3Model.S1A3_PanUpValue = [PanCustomSlider.uplabel.text floatValue];
        //    self.ifmodel.downPanValue       = [[ud objectForKey:DownPanViewValue] floatValue];
        S1A3Model.S1A3_PanDownValue = [PanCustomSlider.downlabel.text floatValue];
        
        //    self.ifmodel.upTiltValue        = [[ud objectForKey:UpTiltViewValue] floatValue];
        S1A3Model.S1A3_TiltUpValue = [TiltCustomSlider.uplabel.text floatValue];
        //    self.ifmodel.downTiltValue      = [[ud objectForKey:DownTiltViewValue] floatValue];
        S1A3Model.S1A3_TiltDownValue = [TiltCustomSlider.downlabel.text floatValue];
        
//        self.ifmodel.shootMode          = [[ud objectForKey:SHOOTINGMODE] integerValue];
//        S1A3Model.S1A3_ShootingMode
        
        //        self.ifmodel.displayUnit        = [[ud objectForKey:DISPLAYUNIT] integerValue];
        //        self.ifmodel.totalTimes         = [[ud objectForKey:TOTALTIMES] floatValue];
        //        self.ifmodel.TimelapseTotalTimes = [[ud objectForKey:TIMELAPSETIME] floatValue];
        //        self.ifmodel.FunctionMode       = [[ud objectForKey:FUNCTIONMODE] integerValue];
        //        self.ifmodel.slideCount = [[ud objectForKey:SLIDECOUNT] integerValue];
        
        
        NSDictionary * dict = [S1A3Model dictionaryWithValuesForKeys:[S1A3Model allPropertyNames]];
        [dataArray addObject:dict];
        
        
        //        [dataArray replaceObjectAtIndex:_indexRow withObject:dict];
        
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
        NSArray * array1 = [NSArray arrayWithArray:dataArray];
        
        [array1 writeToFile:plistPath atomically:YES];
        
        //        NSLog(@"%@", plistPath);
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
- (NSArray *)loopCreateNewTypeArray:(NSArray *)array{
    NSMutableArray * newArray = [NSMutableArray new];
    for (NSValue * value in array) {
        [newArray addObject:[NSString stringWithFormat:@"%@", value]];
    }
    return newArray;
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
- (void)S1A3_dalaysendSetParams{
    NSLog(@"S1A3_dalaysendSetParams");
    NSLog(@"%@", CBS1A3_S1);
    S1A3_SendSettingTimer.fireDate = [NSDate distantPast];
}
/**
 *  合并数组  返回X的值和T的值
 */
#pragma mark ---- getNewArrayWithPointArray  ----
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
#pragma mark --- getNewNewArrayWithPointArray -----
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
    for (NSValue * point in array) {
        CGPoint p = point.CGPointValue;
        
        [array1 addObject:[NSNumber numberWithFloat:p.x]];
        [array2 addObject:[NSNumber numberWithFloat:p.y]];
    }
    [totalArray addObject:array1];
    [totalArray addObject:array2];
    
    return totalArray;
}

- (BOOL)countAllVideoTime:(CGFloat)realRunningTime{
    
    
    [self initS1A3_Data];
    [self getConntionStatus];
    
    CGFloat a, b, c;
    CGFloat A, B, C;
    CGFloat AA, AB, AC;
    
    
    NSArray * Slidearray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray];
    
    NSArray * Panarray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray];
    NSArray * Tiltarray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray];
    

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
                SlidePos[j] = (SliderBazierView.frame.size.height - [Slidearray[i][j] floatValue]) / SliderBazierView.frame.size.height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + - S1A3Model.S1A3_SlideDownValue;
                
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0; j < [Panarray[i] count]; j++) {
            if (i == 0) {
                PanT[j] = [Panarray[i][j] floatValue] / PanBazierView.frame.size.width * realTime;
                
            }else if (i == 1){
                PanPos[j] = (PanBazierView.frame.size.height - [Panarray[i][j] floatValue])/ PanBazierView.frame.size.height * (- S1A3Model.S1A3_PanUpValue - - S1A3Model.S1A3_PanDownValue) + - S1A3Model.S1A3_PanDownValue;
                
                
            }
        }
    }
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [Tiltarray[i] count]; j++) {
            if (i == 0 ) {
                TiltT[j]  = [Tiltarray[i][j] floatValue] / TiltBazierView.frame.size.width * realTime;
            }else if (i == 1){
                TiltPos[j] = (TiltBazierView.frame.size.height - [Tiltarray[i][j] floatValue]) / TiltBazierView.frame.size.height * (- S1A3Model.S1A3_TiltUpValue - - S1A3Model.S1A3_TiltDownValue) + - S1A3Model.S1A3_TiltDownValue;
                
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
       
        AA = fabsf(Slide_Accelerate_Calculate(a * i , SlidePos, SlideT));
        AB = fabsf(Slide_Accelerate_Calculate(b * i , PanPos, PanT));
        AC = fabsf(Slide_Accelerate_Calculate(c * i , TiltPos, TiltT));
        
        
        if (appDelegate.bleManager.S1A3_S1CB.state == CBPeripheralStateConnected) {
            if (A > S1A3_SlideVelocMaxValue) {
                //                NSLog(@"Slider超过跑不了");
                return NO;
            }
            if (AA > 500.0f) {
                return NO;
                
            }
        }
        if (appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
            if (B > S1A3_PanVelocMaxValue) {
                //                NSLog(@"Pan超过跑不了");
                
                return NO;
            }
            if (AB > 500.0f) {
                return NO;
                
            }
            if (C > S1A3_TiltVelocMaxValue) {
                
                //                NSLog(@"Tilt超过跑不了");
                return NO;
            }
            if (AC > 500.0f) {
                return NO;

            }
            
        }
        if (AA > 1450.0f) {
            NSLog(@"AccelerateS %f", AA);
            NSLog(@"AccelerateP %f", AB);
            NSLog(@"AccelerateT %f", AC);
        }
    }
    //        NSLog(@"speedP +++++++++++++++++++++++++++++++++++++++++++++++++++");
    return YES;
}
- (void)countAllpointTime{
    
//    [self initS1A3_Data];
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
        TotalFrames = S1A3Model.S1A3_VideoTotalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
    }else{
        NSInteger fpsValue = [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
        if (S1A3Model.S1A3_DisPlayMode == 1) {
            TotalFrames = (UInt32)(fpsValue * S1A3Model.S1A3_TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
        }
    }

    
    a = (slidelastF - slidefirstF) / TotalFrames;
    b = (panlastF - panfirstF) / TotalFrames;
    c = (tiltlastF - tiltfirstF) / TotalFrames;
    
    CGFloat S1time1 = 0.0f, S1time2 = 0.0f , P1time1 = 0.0f, P1time2 = 0.0f , T1time1 = 0.0f, T1time2 = 0.0f;
    
    
    for (int i = 0; i < TotalFrames; i++) {
        
        A = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * i, SlidePos, SlideT)) / SliderBazierView.frame.size.height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
        A1 = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * (i + 1), SlidePos, SlideT)) / SliderBazierView.frame.size.height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
        
        B = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * i, PanPos, PanT)) / PanBazierView.frame.size.height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue;
        B1 = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * (i + 1), PanPos, PanT)) / PanBazierView.frame.size.height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue;
        
    
        
        C = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * i, TiltPos, TiltT)) / TiltBazierView.frame.size.height * (S1A3Model.S1A3_TiltUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue;
        C1 = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * (i + 1), TiltPos, TiltT)) / TiltBazierView.frame.size.height * (S1A3Model.S1A3_TiltUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue;
        
        S1time2 = S1A3_GETTimelapseSlideLongestTime(fabs(fabs(A1) - fabs(A)));
        S1time1 = S1time1 > S1time2 ? S1time1 : S1time2;
        
        
        P1time2  = S1A3_GETTimelapseX2LongestTime(fabs(fabs(B1) - fabs(B)));
        P1time1 = P1time1 > P1time2 ? P1time1 : P1time2;
        
        T1time2 = S1A3_GETTimelapseX2LongestTime(fabs(fabs(C1) - fabs(C)));
        T1time1 = T1time1 > T1time2 ? T1time1 : T1time2;
        

    }
    
 
    
    
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
    finalRunningTime =ceilf(runningTime + 0.5 + S1A3Model.S1A3_ExpoSecond + S1A3Model.S1A3_BufferSecond);
    
    _centerInfoView.interValueLabel.text = [NSString stringWithFormat:@"%ds",finalRunningTime];
//    if (isTouchPreview) {
//
//    }else{
//
        if (loopModeView.MODEL == MODEL_STOPMOTION) {
            _centerInfoView.interValueLabel.alpha = 0;
            _centerInfoView.intervalLabel.alpha = 0;
            _centerInfoView.fimlingTimeLabel.alpha = 0;
            _centerInfoView.fimilingTimeValueLabel.alpha = 0;

        }else{
            _centerInfoView.interValueLabel.alpha = 1;
            _centerInfoView.intervalLabel.alpha = 1;
            _centerInfoView.fimlingTimeLabel.alpha = 1;
            _centerInfoView.fimilingTimeValueLabel.alpha = 1;
        }
//    }
    if (S1A3Model.S1A3_DisPlayMode == 1) {
        
        _centerInfoView.finalOutputValueLabel.text = [NSString stringWithFormat:@"%ldf", S1A3Model.S1A3_TimelapseTotalFrames];
        
    }else{
        S1A3Model.S1A3_TimelapseTotalTimes = (CGFloat)S1A3Model.S1A3_TimelapseTotalFrames / [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
        _centerInfoView.finalOutputValueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimelapseTimeWith:S1A3Model.S1A3_TimelapseTotalTimes andFPS:[self.configs[S1A3Model.S1A3_fpsIndex]integerValue]]];
        
    }
        _centerInfoView.fimilingTimeValueLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool get_HMS_TimeWith:(finalRunningTime * S1A3Model.S1A3_TimelapseTotalFrames)]];
//}

}

#pragma mark -----计算定格动画的每一步最长时间--------

- (void)countStopMotionLongestTimeWithMode:(UInt8)functionMode{
    
//    [self initData];
//    [self getConntionStatus];
    
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
    
    if (functionMode == 0x03) {
        m = _receiveView.S1A3_S1_StopMotion_CurrentFrame > _receiveView.S1A3_X2_StopMotion_CurrentFrame ?  _receiveView.S1A3_S1_StopMotion_CurrentFrame - 1 :  _receiveView.S1A3_X2_StopMotion_CurrentFrame - 1;
    }else{
        m =  _receiveView.S1A3_S1_StopMotion_CurrentFrame > _receiveView.S1A3_X2_StopMotion_CurrentFrame ?  _receiveView.S1A3_S1_StopMotion_CurrentFrame :  _receiveView.S1A3_X2_StopMotion_CurrentFrame;
    }
    n = m + 1;
    a = (slidelastF - slidefirstF) / S1A3Model.S1A3_TimelapseTotalFrames;
    b = (panlastF - panfirstF) / S1A3Model.S1A3_TimelapseTotalFrames;
    c = (tiltlastF - tiltfirstF) / S1A3Model.S1A3_TimelapseTotalFrames;
    
    
    A = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * m, SlidePos, SlideT)) / SliderBazierView.frame.size.height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
    B = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * m, PanPos, PanT)) / PanBazierView.frame.size.height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue;
    C = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * m, TiltPos, TiltT)) / TiltBazierView.frame.size.height * (S1A3Model.S1A3_TiltUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue;
    
    A1 = (SliderBazierView.frame.size.height - GETAXIS_Trace_Calculate(a * n, SlidePos, SlideT)) / SliderBazierView.frame.size.height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
    B1 = (PanBazierView.frame.size.height - GETAXIS_Trace_Calculate(b * n, PanPos, PanT)) / PanBazierView.frame.size.height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue;
    C1 = (TiltBazierView.frame.size.height - GETAXIS_Trace_Calculate(c * n, TiltPos, TiltT)) / TiltBazierView.frame.size.height * (S1A3Model.S1A3_TiltUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue;
    
    
    //    NSLog(@"A = %lf", A);
    //    NSLog(@"\r\n%lf \r\n%lf \r\n%lf", A1- A, B1- B, C1- C);
    //    NSLog(@"slidetime = %f", GETSlideLongestTIME(fabs(A1 - A)));
    //    NSLog(@"pantime = %f", GETX2longestTIME(fabs(B1 - B)));
    //    NSLog(@"tilttime = %f", GETX2longestTIME(fabs(C1 - C)));
    CGFloat slideLongestime = S1A3_GETTimelapseSlideLongestTime(fabs(A1 - A));
    CGFloat panLongestime = S1A3_GETTimelapseX2LongestTime(fabs(B1 - B));
    CGFloat tiltLongestime = S1A3_GETTimelapseTiltLongestTime(fabs(C1 - C));
    
    CGFloat longestime = MAX(MAX(slideLongestime, panLongestime), tiltLongestime);
    UInt16 sendLongestTime = (UInt16)(longestime * 1000);
    //    NSLog(@"long = %lf", longestime);
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
   
    [self.sendDataView sendStopMotionSetWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x05 andFunctionMode:functionMode andTimestamp:recordTime CurrentFrame:(UInt32)m andlongestTime:sendLongestTime WithStr:SendStr];
    [self.sendDataView sendStopMotionSetWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x05 andFunctionMode:functionMode andTimestamp:recordTime CurrentFrame:(UInt32)m andlongestTime:sendLongestTime WithStr:SendStr];
    
}

/**
 配置发送的数组Frame Time 位置信息参数
 */
- (void)GetAllNsArray{
    
    [self initS1A3_Data];
    
    NSArray * SlideoldFrameArray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray][0];
    NSArray * SlideoldPostionArray = [self getNewArrayWithPointArray:SliderBazierView.PointArray andControlArray:SliderBazierView.ControlPointArray][1];
    NSArray * PanoldFrameArray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray][0];
    NSArray * PanoldPostionArray = [self getNewArrayWithPointArray:PanBazierView.PointArray andControlArray:PanBazierView.ControlPointArray][1];
    NSArray * TiltoldFrameArray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray][0];
    NSArray * TiltoldPostionArray = [self getNewArrayWithPointArray:TiltBazierView.PointArray andControlArray:TiltBazierView.ControlPointArray][1];
    
    UInt32 TotalFrames;
    NSInteger intervaltime = 0;
    
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = S1A3Model.S1A3_VideoTotalTimes;
        intervaltime = 1;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        intervaltime = 1;
        TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
    }else{
        intervaltime = finalRunningTime;
#warning fps24 暂定 -------
        NSInteger fpsValue = [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
        if (S1A3Model.S1A3_DisPlayMode == 1) {
            TotalFrames = (UInt32)(fpsValue * S1A3Model.S1A3_TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
        }
        
    }
    if (isTouchPreview) {
        TotalFrames = (UInt32)preViewSecond;

    }
    
    for (NSNumber * value in SlideoldFrameArray) {
        CGFloat a = [value floatValue] / SliderBazierView.frame.size.width * TotalFrames * intervaltime;
        [S1A3_SlidenewFrameArray addObject:[NSNumber numberWithFloat:a]];
    }
    for (NSNumber * value in PanoldFrameArray) {
        CGFloat a = [value floatValue] / PanBazierView.frame.size.width * TotalFrames * intervaltime;
        [S1A3_PannewFrameArray addObject:[NSNumber numberWithFloat:a]];
    }
    for (NSNumber * value in TiltoldFrameArray) {
        CGFloat a = [value floatValue] / TiltBazierView.frame.size.width * TotalFrames * intervaltime;
        [S1A3_TiltnewFrameArray addObject:[NSNumber numberWithFloat:a]];
    }
    
    
    for (NSNumber * value in SlideoldPostionArray) {
        CGFloat b = (SliderBazierView.frame.size.height - [value floatValue]) / SliderBazierView.frame.size.height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
        if (b < 0 ) {
            b = 0;
        }
        [S1A3_SlidenewPostionArray addObject:[NSNumber numberWithFloat:b]];
        
    }
    for (NSNumber * value in PanoldPostionArray) {
        CGFloat b = (PanBazierView.frame.size.height - [value floatValue]) / PanBazierView.frame.size.height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue + S1A3_PanMaxValue;
        [S1A3_PannewPostionArray addObject:[NSNumber numberWithFloat:b]];
    }
    for (NSNumber * value in TiltoldPostionArray) {
        CGFloat b = (TiltBazierView.frame.size.height - [value floatValue]) / TiltBazierView.frame.size.height * (S1A3Model.S1A3_TiltUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue + S1A3_TiltMaxValue;
        [S1A3_TiltnewPostionArray addObject:[NSNumber numberWithFloat:b]];
    }
    
}
/**
 02）发送清除数据的指令
 */
- (void)sendClearOrder{
    //    NSLog(@"sendClearOrder");
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    if (CBS1A3_S1.state == CBPeripheralStateConnected) {
        [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    }
    if (CBS1A3_X2.state == CBPeripheralStateConnected) {
        [self.sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F  andFunctionNumber:0x02 andFiveFunctionMode:0x04 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    }
}

- (void)clearAllNSArrays{
    [S1A3_SlidenewPostionArray removeAllObjects];
    [S1A3_SlidenewFrameArray removeAllObjects];
    [S1A3_PannewFrameArray removeAllObjects];
    [S1A3_PannewPostionArray removeAllObjects];
    [S1A3_TiltnewFrameArray removeAllObjects];
    [S1A3_TiltnewPostionArray removeAllObjects];
}


#pragma mark ---- 创建所有的按钮 -------
- (void)createAll3DButtonAndCenterInfoView{
    CGFloat BtnWidth;
    CGFloat interValDistance;
    if (kDevice_Is_iPhoneX) {
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
        self.centerInfoView = [[iFCenterInfoView alloc]initWithFrame:CGRectMake(0, 0, BtnWidth * 3, BtnWidth * 0.75)];
    }else{
        self.centerInfoView = [[iFCenterInfoView alloc]initWithFrame:CGRectMake(0, 0, BtnWidth * 3, BtnWidth)];
    }
    self.SliderBtn.actionBtn.tag = SlideTag;
    self.PanBtn.actionBtn.tag = PanTag;
    self.TiltBtn.actionBtn.tag = TiltTag;
    [self chooseCurve:self.SliderBtn.actionBtn];//初始化Slide界面
    
    [self.SliderBtn.actionBtn addTarget:self action:@selector(chooseCurve:) forControlEvents:UIControlEventTouchUpInside];
    [self.PlayBtn.actionBtn addTarget:self action:@selector(PlayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.PanBtn.actionBtn addTarget:self action:@selector(chooseCurve:) forControlEvents:UIControlEventTouchUpInside];
    [self.TiltBtn.actionBtn addTarget:self action:@selector(chooseCurve:) forControlEvents:UIControlEventTouchUpInside];
    [self.KeyBtn.actionBtn addTarget:self action:@selector(KeyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.StopBtn.actionBtn addTarget:self action:@selector(StopBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.SaveBtn.actionBtn addTarget:self action:@selector(SaveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.StopMotionBtn.actionBtn addTarget:self action:@selector(stopMotionAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.returnBtn.actionBtn addTarget:self action:@selector(returnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.preViewBtn.actionBtn addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.centerInfoView];
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
    [self.centerInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint Point = [[touches anyObject] locationInView:SliderBazierView];
    
    if ([SliderBazierView.layer containsPoint:Point]){
        CGPoint location = [[touches anyObject] locationInView:self.view];
        
#warning rightLimit - leftLimit 代替 rightLimit
        if (_MODEL == MODEL_SLIDER) {
            if ([self judgeIsContainPoint:SliderBazierView.PointArray WithPoint:Point] && [self judgeIsContainPoint:[self getNewControlArrayCellsWithControlArray:SliderBazierView.ControlPointArray] WithPoint:Point]) {
                CGFloat Value = (location.x - leftLimit) / (rightLimit);
                xValue = intervalView.frame.size.width * Value;
                [intervalView changeMarkShaftXvalue:Value];
                [self judgeInsertIndex:intervalView.frame.size.width * Value];
                intervalView.valueLabel.alpha = 1;
                
            }
        }else if(_MODEL == MODEL_PAN){
            if ([self judgeIsContainPoint:PanBazierView.PointArray WithPoint:Point] && [self judgeIsContainPoint:[self getNewControlArrayCellsWithControlArray:PanBazierView.ControlPointArray] WithPoint:Point]) {
                CGFloat Value = (location.x - leftLimit) / (rightLimit);
                xValue = intervalView.frame.size.width * Value;
                [intervalView changeMarkShaftXvalue:Value];
                [self judgeInsertIndex:intervalView.frame.size.width * Value];
                intervalView.valueLabel.alpha = 1;
                
            }
        }else{
            
            if ([self judgeIsContainPoint:TiltBazierView.PointArray WithPoint:Point] && [self judgeIsContainPoint:[self getNewControlArrayCellsWithControlArray:TiltBazierView.ControlPointArray] WithPoint:Point]) {
                CGFloat Value = (location.x - leftLimit) / (rightLimit);
                xValue = intervalView.frame.size.width * Value;
                [intervalView changeMarkShaftXvalue:Value];
                [self judgeInsertIndex:intervalView.frame.size.width * Value];
                intervalView.valueLabel.alpha = 1;
                
            }
        }
    }
    UInt32 TotalFrames;
    if (loopModeView.MODEL == MODEL_VIDEO) {
        TotalFrames = S1A3Model.S1A3_VideoTotalTimes;
    }else if(loopModeView.MODEL == MODEL_STOPMOTION){
        TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
    }else{
        NSInteger fpsValue = [self.configs[S1A3Model.S1A3_fpsIndex] integerValue];
        if (S1A3Model.S1A3_DisPlayMode == 1) {
            TotalFrames = (UInt32)(fpsValue * S1A3Model.S1A3_TimelapseTotalTimes);
        }else{
            TotalFrames = (UInt32)S1A3Model.S1A3_TimelapseTotalFrames;
        }
    }
    intervalView.valueLabel.text = [NSString stringWithFormat:@"%.0f", (xValue) / SliderBazierView.frame.size.width * TotalFrames];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint Point = [[touches anyObject] locationInView:SliderBazierView];
    
    if ([SliderBazierView.layer containsPoint:Point]){
        [self moveInsertViewRealTimepreViewWithPointX:xValue];
        intervalView.valueLabel.alpha = 0;
    }
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
- (BOOL)judgeIsContainPoint:(NSArray *)PointArray WithPoint:(CGPoint)point{
    BOOL isContains = YES;
    for (NSValue * value in PointArray) {
        CGPoint valuePoint = [value CGPointValue];
        CGRect PointRect = CGRectMake(valuePoint.x - 20, valuePoint.y - 20, 40, 40);
//     NSLog(@"CGRectContainsPoint %d", CGRectContainsPoint(PointRect, point));
        if (CGRectContainsPoint(PointRect, point)) {
            return NO;
        }
    }
    return isContains;
}

- (void)moveInsertViewRealTimepreViewWithPointX:(CGFloat)x{
    CGFloat Height = SliderBazierView.frame.size.height;
    //    CGFloat Width = SliderBazierView.frame.size.width;
    
    
    [self initS1A3_Data];
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
    
    a = (Height - GETAXIS_Trace_Calculate(x, SlidePos, SlideT)) / Height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
    b = (Height - GETAXIS_Trace_Calculate(x, PanPos, PanT)) / Height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue;
    c = (Height - GETAXIS_Trace_Calculate(x, TiltPos, TiltT)) / Height * (S1A3Model.S1A3_TiltUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue;
    CGFloat A, B = 0.0, C;
    
    A = GETAXIS_Trace_Calculate(x, SlidePos, SlideT);
    B =  GETAXIS_Trace_Calculate(x, PanPos, PanT);
    C =  GETAXIS_Trace_Calculate(x, TiltPos, TiltT);
    
    if (_MODEL == MODEL_SLIDER) {
        self.YValue = A;
        
    }else if (_MODEL == MODEL_PAN){
        self.YValue = B;
        
    }else{
        self.YValue = C;
    }
    if (a > S1A3Model.S1A3_SlideUpValue) {
        a = S1A3Model.S1A3_SlideUpValue - 0.01;
    }
    //    NSLog(@"66666666%f, %f, %f ,%f", a, b, c, self.ifmodel.upSliderValue);
    
    
    //    NSLog(@"self.YValue = %lf", self.YValue);
    
#warning 拖动insertView 三轴同步预览 ！！！！！(暂时注释)
    //    if (isMoveInsertView) {
    [self RealTimeTrackingWithSlidePostion:a andPanPostion:(b + S1A3_PanMaxValue) andTiltPostion:(c + S1A3_TiltMaxValue) andSlideMode:0x00 andPanTiltMode:0x00];
    //        NSLog(@"1111111111111%f %f %f", a, b + PanMaxValue, c + TiltMaxValue);
    
    //    }
    
}
#pragma mark - previewBtnAction -
- (void)previewBtnAction:(iFButton *)btn{
    [self StopBtnAction:nil];
    
    self.preViewBtn.alpha = 0;
    self.PauseBtn.alpha = 1;
    
    CGFloat RealTimes = 1;
    while (![self countAllVideoTime:RealTimes]) {
        RealTimes++;
    }
    
    preViewSecond = S1A3Model.S1A3_TimelapseTotalTimes > RealTimes ? S1A3Model.S1A3_TimelapseTotalTimes + 1 : RealTimes;
    
    
    isTouchPreview = YES;
    
    loopModeView.MODEL = 1;
    processView.titleLabel.text = @"preview";
    [self PlayBtnAction:nil];
}

#pragma mark - returnBtnAction -
- (void)returnBtnAction:(iFButton *)btn{
    NSLog(@"点击了");
    
    [self StopBtnAction:nil];
    isTouchReturnBack = YES;
    isloop = 0x00;
    processView.isloopBtn.selected = NO;
    [self PlayBtnAction:nil];
    
}

#pragma mark ---KeyBtnAction: ------
- (void)KeyBtnAction:(UIButton *)btn{
    [self insertValue];
}
#pragma mark --- chooseCurve: -------
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
        _MODEL = MODEL_SLIDER;
        
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
        
        [self.view bringSubviewToFront:insertBackView];
        [self.view bringSubviewToFront:backBtn];
        
        TiltCustomSlider.alpha = 0;
        SlideCustomSlider.alpha = 1;
        PanCustomSlider.alpha = 0;
        
        
        
    }else if (btn.tag == PanTag){
        _MODEL = MODEL_PAN;
        
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
        
        [self.view bringSubviewToFront:insertBackView];
        [self.view bringSubviewToFront:backBtn];
        TiltCustomSlider.alpha = 0;
        SlideCustomSlider.alpha = 0;
        PanCustomSlider.alpha = 1;
        ;
    }else{
        _MODEL = MODEL_TILT;
        
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
        
        [self.view bringSubviewToFront:insertBackView];
        [self.view bringSubviewToFront:backBtn];
        
        TiltCustomSlider.alpha = 1;
        SlideCustomSlider.alpha = 0;
        PanCustomSlider.alpha = 0;
    }
//    [self judgeInsertIndex:XValue];
    //    if (btn) {
//    [self moveInsertViewRealTimepreViewWithPointX:XValue];
    //    }
    
}

#pragma mark --- changeValueDelegate -----
- (void)changeDistanceValue:(CGFloat)value{
    if (_MODEL == MODEL_SLIDER) {
        
        S1A3Model.S1A3_SlideUpValue = [SlideCustomSlider.uplabel.text integerValue];
        S1A3Model.S1A3_SlideDownValue = [SlideCustomSlider.downlabel.text integerValue];
        
        
    }else if (_MODEL == MODEL_PAN){
        
        S1A3Model.S1A3_PanUpValue = [PanCustomSlider.uplabel.text integerValue];
        S1A3Model.S1A3_PanDownValue = [PanCustomSlider.downlabel.text integerValue];
        
    }else if (_MODEL == MODEL_TILT) {
        S1A3Model.S1A3_TiltUpValue = [TiltCustomSlider.uplabel.text integerValue];
        S1A3Model.S1A3_TiltDownValue = [TiltCustomSlider.downlabel.text integerValue];
        
    }
    
    [self saveDataWithBOOLYES];
    [self initS1A3_Data];
    
}
#pragma mark --- PauseMotionActionDelegateMethod -
- (void)PauseMotionActionDelegateMethod{
    
    UInt64 recordTime = [[NSDate date]timeIntervalSince1970] * 1000;
    [_sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x03 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    [_sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x03 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    S1A3_ReceiveTimer.fireDate = [NSDate distantFuture];
    
    
}
#pragma mark --- restartMotionActionDelegateMethod ---
- (void)restartMotionActionDelegateMethod{
    UInt64 recordTime = [[NSDate date]timeIntervalSince1970] * 1000 + 1;
    
    [_sendDataView sendStartCancelPauseDataWithCb:CBS1A3_S1 andFrameHead:OXAAAF andFunctionNumber:0x02 andFiveFunctionMode:0x05 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    [_sendDataView sendStartCancelPauseDataWithCb:CBS1A3_X2 andFrameHead:OX555F andFunctionNumber:0x02 andFiveFunctionMode:0x05 andTimestamp:recordTime WithStr:SendStr andisLoop:isloop];
    S1A3_ReceiveTimer.fireDate = [NSDate distantPast];

}
#pragma mark ---previewMoveDelegate -------
//预览拖动时调用
- (void)moveRealTimePreViewPointY:(CGFloat)Y andPointX:(CGFloat)X andHeight:(CGFloat)Height andWidth:(CGFloat)Width{
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
    a = (Height - GETAXIS_Trace_Calculate(X, SlidePos, SlideT)) / Height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
    b = (Height - GETAXIS_Trace_Calculate(X, PanPos, PanT)) / Height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue;
    c = (Height - GETAXIS_Trace_Calculate(X, TiltPos, TiltT)) / Height * (S1A3Model.S1A3_TiltUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue;
    
    
    CGFloat SlidePostion;
    CGFloat PanPostion;
    CGFloat TiltPostion;
    UInt8 slideMode;
    UInt8 pantiltMode;
    
    //    NSLog(@"55555555%f, %f, %f, %f", X, a, GETAXIS_Trace_Calculate(X, SlidePos, SlideT), Y);
    
    switch (_MODEL) {
        case MODEL_SLIDER:
            slideMode = 0x01;
            SlidePostion = (Height - Y) / Height * (S1A3Model.S1A3_SlideUpValue - S1A3Model.S1A3_SlideDownValue) + S1A3Model.S1A3_SlideDownValue;
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
            PanPostion = (Height - Y) / Height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_PanDownValue) + S1A3Model.S1A3_PanDownValue;
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
            TiltPostion = (Height - Y) / Height * (S1A3Model.S1A3_PanUpValue - S1A3Model.S1A3_TiltDownValue) + S1A3Model.S1A3_TiltDownValue;
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
    
    
    [self RealTimeTrackingWithSlidePostion:SlidePostion andPanPostion:(PanPostion + S1A3_PanMaxValue) andTiltPostion:(TiltPostion + S1A3_TiltMaxValue) andSlideMode:slideMode andPanTiltMode:pantiltMode];
}
#pragma mark - RealTimeTrackingWithSlidePostion 实时追踪-
- (void)RealTimeTrackingWithSlidePostion:(CGFloat)slidePostion andPanPostion:(CGFloat)panPostion andTiltPostion:(CGFloat)tiltPostion andSlideMode:(UInt8)slideMode andPanTiltMode:(UInt8)pantiltMode{
    
    pantiltMode = 0x03;
    slideMode = 0x01;
    [self.sendDataView sendBezierPreviewWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:0x555F andFunctionNumber:0x06 andFuntionMode:pantiltMode panPostion:(Float32)panPostion tiltPostion:(Float32)tiltPostion WithStr:SendStr];
    [self.sendDataView sendBezierPreviewWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:0xAAAF andFunctionNumber:0x06 andFunctionMode:slideMode sliderPostion:(Float32)slidePostion WithStr:SendStr];
}
//触摸点结束时调用
- (void)touchEndChangeTime{
    [self countAllpointTime];

}
//拖动显示帧数和Y轴位置时调用
- (void)showXvalueStr:(NSString *)xstr andYvalueStr:(NSString *)ystr{
    
    if (_MODEL == MODEL_SLIDER) {
        xFrameLabel.textColor = COLOR(255, 0, 255, 1);
        yDistanceLabel.textColor = COLOR(255, 0, 255, 1);
        
    }else if (_MODEL == MODEL_PAN){
        xFrameLabel.textColor = COLOR(0, 255, 255, 1);
        yDistanceLabel.textColor = COLOR(0, 255, 255, 1);
    }else if (_MODEL == MODEL_TILT) {
        xFrameLabel.textColor = COLOR(255, 255, 0, 1);
        yDistanceLabel.textColor = COLOR(255, 255, 0, 1);
    }
    
    xFrameLabel.text = xstr;
    yDistanceLabel.text = ystr;
}
//显示警告 根据Mode
- (void)showAccordingToWarningWithMode:(NSInteger)mode{
    
}
//删除点时调用
- (void)delegateDeletePoint{
    
}

#pragma mark ----- (id)init ------
- (id)init{
    self.timeArr = [NSMutableArray new];
    for (int i=0; i<=60; i++) {
        [self.timeArr addObject:[[NSNumber alloc] initWithInt:i]];
    }
    NSLog(@"%d", [[UIDevice currentDevice].model isEqualToString:@"iPad"]);
    S1A3Model = [iFS1A3_Model new];
    if (kDevice_Is_iPhoneX) {
        leftLimit = AutoKScreenHeight * 0.1;
        rightLimit = AutoKScreenHeight * 0.8;
        topLimit = AutoKscreenWidth * 0.15;
        downLimit = AutoKscreenWidth * 0.85;
    }else if(kDevice_Is_iPad){
        leftLimit = AutoKScreenHeight * 0.05;
        rightLimit = AutoKScreenHeight * 0.85;
        topLimit = AutoKscreenWidth * 0.15;
        downLimit = AutoKscreenWidth * 0.75;
    }else{
        leftLimit = AutoKScreenHeight * 0.02;
        rightLimit = AutoKScreenHeight * 0.92;
        topLimit = AutoKscreenWidth * 0.15;
        downLimit = AutoKscreenWidth * 0.85;
    }
    return self;
}
#pragma mark ---- 赋值所有数据 -----
- (void)saveAllData{
    S1A3Model.S1A3_SlideArray = SliderBazierView.PointArray;
    S1A3Model.S1A3_PanArray = PanBazierView.PointArray;
    S1A3Model.S1A3_TiltArray = TiltBazierView.PointArray;
    S1A3Model.S1A3_SlideControlArray = SliderBazierView.ControlPointArray;
    S1A3Model.S1A3_PanControlArray = PanBazierView.ControlPointArray;
    S1A3Model.S1A3_TiltControlArray = TiltBazierView.ControlPointArray;
}
#pragma mark -------接收数据--------


#pragma mark --------需要旋转横屏--------退回返回全方位-------
- (void)viewWillDisappear:(BOOL)animated{
    [self forceOrientationPortrait];
    [self saveAllData];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO];

//    }
    [self closeTimer];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [self forceOrientationLandscape];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    }
    [self createAllTimer];
    
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
