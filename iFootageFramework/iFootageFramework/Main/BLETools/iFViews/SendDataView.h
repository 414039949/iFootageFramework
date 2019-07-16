//
//  SendDataView.h
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
// 用于发送数据

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Tools.h"

@protocol SendDataViewTextViewDelegate <NSObject>

-(BOOL)sendDataTextViewShouldBeginEditing:(UITextView *)textView;  //开始编辑
-(BOOL)sendDataTextViewShouldEndEditing:(UITextView *)textView;    //结束编辑

@end
@interface SendDataView : UIView <UITextViewDelegate>

{
    AppDelegate            *appDelegate;
    long                   sendByteSize;
    NSString               *sendMessage;
    BOOL              IsAscii ;          //默认为Ascii显示
}

@property(nonatomic , strong) UITextView         *messageTxt;

//要发送的数据长度和发送的所有数据长度的总和
@property(nonatomic , strong) UILabel            *lengthTxt,*sendBytesSizeTxt,*intervalTxt;
@property(nonatomic , strong) UILabel            *lengthLabel, *byteLabel,*intervalLabel;
//@property(nonatomic , strong) CBPeripheral * panCB;
//@property(nonatomic , strong) CBPeripheral  * sliderCB;
//@property(nonatomic , strong) CBPeripheral * tiltCB;


@property(nonatomic , strong) id<SendDataViewTextViewDelegate> delegate;


-(void)clearText;
-(void)sendData;
-(void)resetText;
-(void)textViewBecomeFirstResponder;

-(void)setIsAscii:(BOOL)boo; //为假时显示 hex
/**
 *  给X2发送数据
 *
 *  @param str    str description
 *  @param velocX Tilt的值
 *  @param velocY Pan的值
 */
-(void)sendData:(NSString *)str andXVeloc:(SInt16)velocX andYVeloc:(SInt16)velocY;


-(void)sendData:(NSString *)str andVeloc:(SInt16)veloc andCBper:(CBPeripheral *)cbper;


#warning mark--------待修改------需求更改------摇杆暂时不符合要求-------
- (void)sendX2BackZeroWith:(NSString *)str WithCB:(CBPeripheral *)cb;


- (void)sendSliderBackZeroWith:(NSString *)str WithCB:(CBPeripheral *)cb;

/**
 *  发送数据X轴(右边摇杆)
 *
 *  @param str    数据长度字符串（辅助字符串）
 *  @param velocX X的值（速度）
 */
-(void)sendXData:(NSString *)str andXVeloc:(SInt16)velocX;
/**
 *  发送数据Y轴(右边摇杆)
 *
 *  @param str    数据长度字符串（辅助字符串）
 *  @param velocY Y的值（速度）
 */
-(void)sendYDate:(NSString *)str andYVeloc:(SInt16)velocY;
-(void)sendSliderValue:(NSString *)str andSliderValue:(SInt16)velocSlider;
;

/**
 *  发送曲线配置的参数（02）
 *
 *  @param str           str description
 *  @param Mode          功能选择 0 无动作  1 配合时间戳开始  2 回起始点 3 停止运行
 *  @param count         三阶贝塞尔曲线的数量
 *  @param frames        拍摄总张数
 *  @param Exposuretimes 曝光时间
 *  @param Intervaltimes 间隔时间
 *  @param startTimes    校验时间（ms）
 */
- (void)sendData:(NSString *)str andShootingMode:(UInt8)Mode andBaizerCount:(UInt8)count andFrames:(UInt32)frames andExposureTimes:(UInt16)Exposuretimes andIntervalTimes:(UInt16)Intervaltimes andStartTimes:(UInt64)startTimes;
/**
 * AAAF（02） Mode Set 发送曲线数量，判断是否是new曲线 选择功能，拍摄模式，传入校验时间
 *
 *  @param str          str description
 *  @param functionMode 功能选择
 *  @param mode         拍摄模式
 *  @param count        三阶贝塞尔曲线数量
 *  @param isNewBaizer  是否是新的贝塞尔曲线
 *  @param startTime    校验时间
 */
- (void)sendData:(NSString *)str FunctionSEL:(UInt8)functionMode  andShootingMode:(UInt8)mode andBaizerCount:(UInt8)count andIsNewBaizer:(UInt8)isNewBaizer andStartTimes:(UInt64)startTime  WithCBper:(CBPeripheral *)cbPeripheral andSettingIsClear:(UInt8)isclear;

/**
 * AAAF (03) Bezier Parameter 发送总帧数 曝光时间 间隔时间 实际间隔时间
 *
 *  @param str            str description
 *  @param totalframes    totalframes description
 *  @param exposure       exposure description
 *  @param interval       interval description
 *  @param actualInterval actualInterval description
 */
- (void)sendData:(NSString *)str TotalFrames:(UInt32)totalframes Exposure:(UInt16)exposure Interval:(UInt16)interval ActualInterval:(UInt16)actualInterval WithCBper:(CBPeripheral *)cbPeripheral;

/**
 *  AAAF (05， 06 ， 07, 08, 09, 10)发送贝塞尔曲线的每一个点的细节
 *
 *  @param str   str description
 *  @param array array description
 */
- (void)sendData:(NSString *)str WithFunctionNumber:(UInt8)functionNumber andUint16PointsNsArray:(NSArray *)Pointarray WithCBper:(CBPeripheral *)cbPeripheral;


/**
 *  555F (02) Mode Set 发送X2的曲线数量  ， 判断是否需要清除， 选择功能， 拍摄模式， 传入校验时间
 *
 *  @param str           str description
 *  @param functionMode  功能选择
 *  @param mode          拍摄模式
 *  @param count         高四位 pan 数量  低四位 tilt 数量
 *  @param isClearBezier 是否清除
 *  @param startTime     校验时间
 *  @param cbPeripheral  传入蓝牙设备
 *  @param isclear       是否清除
 */
- (void)sendDataX2:(NSString *)str WithFunctionNumber:(UInt8)functionMode andShootingMode:(UInt8)mode andBeizerCount:(UInt8)count andIsClearBezier:(UInt8)isClearBezier andStartTimes:(UInt64)startTime WithCBper:(CBPeripheral *)cbPeripheral andSettingIsClear:(UInt8)isclear;
/**
 *  555F(03) Bezier Parameter
 *
 *  @param str            str description
 *  @param totalframes    totalframes description
 *  @param exposure       exposure description
 *  @param interval       interval description
 *  @param actualInterval actualInterval description
 *  @param cbPeripheral   cbPeripheral description
 */
- (void)sendDataX2:(NSString *)str TotalFrames:(UInt32)totalframes Exposure:(UInt16)exposure Interval:(UInt16)interval ActualInterval:(UInt16)actualInterval WithCBper:(CBPeripheral *)cbPeripheral;
/**
 *  发送曲线
 *
 *  @param str            str description
 *  @param functionNumber functionNumber description
 *  @param Pointarray     Pointarray description
 *  @param cbPeripheral   cbPeripheral description
 */
- (void)sendDataX2:(NSString *)str WithFunctionNumber:(UInt8)functionNumber andUint16PointsNsArray:(NSArray *)Pointarray WithCBper:(CBPeripheral *)cbPeripheral;
#pragma mark - Slide 和 pan/tilt 兼容发送数据方法
/**
 *  Mode Set
 *
 *  @param cb             蓝牙设备
 *  @param frameHead      帧头
 *  @param functionNumber 功能字
 *  @param functionMode   功能选择
 *  @param shootingMode   拍摄模式
 *  @param beizerCount    贝塞尔曲线的数量 如果X2 高4位 为pan的数量 低四位为tilt 的数量
 *  @param isClearBezier  是否清除贝塞尔
 *  @param checktime      校验时间
 *  @param isClearSetting 是否清除设置
 */

- (void)sendDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andShootingMode:(UInt8)shootingMode andBeizerCount:(UInt8)beizerCount andIsClearBeizer:(UInt8)isClearBezier andcheckTime:(UInt64)checktime andIsSettingClear:(UInt8)isClearSetting str:(NSString *)str;
/**
 *  Mode Parameter
 *
 *  @param cb             cb description
 *  @param frameHead      frameHead description
 *  @param totalframes    totalframes description
 *  @param exposure       exposure description
 *  @param interval       interval description
 *  @param actualInterval actualInterval description
 */
- (void)sendDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andTotalFrames:(UInt32)totalframes Exposure:(UInt16)exposure Interval:(UInt16)interval ActualInterval:(UInt16)actualInterval str:(NSString *)str;
/**
 *  贝塞尔曲线的传输
 *
 *  @param cb             cb description
 *  @param frameHead      frameHead description
 *  @param functionNumber functionNumber description
 *  @param pointarray     pointarray description
 */

- (void)sendDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andUint16PointNsArray:(NSArray *)pointarray str:(NSString *)str;



- (void)sendRealTimeSlideYWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andMode:(UInt8)mode andSlideY:(UInt16)slideY str:(NSString *)str;


#pragma mark ----new delegate(蓝牙三轴协议)-----

/**
 AAAF(02) Start - Cancel - Pause

 @param cb                 cb description
 @param frameHead          frameHead description
 @param functionNumber     functionNumber description
 @param mode               mode description
 @param UpperByteTimestamp UpperByteTimestamp (高八位）
 @param LowerByteTimestamp LowerByteTimestamp (低八位)
 */
- (void)sendStartCancelPauseDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFiveFunctionMode:(UInt8)mode andTimestamp:(UInt64)timestamp WithStr:(NSString *)str andisLoop:(UInt8)isloop;
/**
 AAAF(03) （曲线设置）Timelapse Set

 @param cb cb description
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param interval interval description
 @param exposure exposure description
 @param frames frames description
 @param mode mode description
 @param count count description
 @param str str description
 */
- (void)sendTimelapseSetDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andInterval:(UInt16)interval andExposure:(UInt16)exposure andFrames:(UInt32)frames  andMode:(UInt8)mode andBezierCount:(UInt8)count WithStr:(NSString *)str andBuffer_second:(UInt16)Buffer_second;

/**
 555F(03) (曲线参数设置)

 @param cb cb description
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param interval interval description
 @param exposure exposure description
 @param frames frames description
 @param mode mode description
 @param pancount pancount description
 @param tiltcount tiltcount description
 @param str str description
 */

- (void)sendTimelapseSetDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andInterval:(UInt16)interval andExposure:(UInt16)exposure andFrames:(UInt32)frames  andMode:(UInt8)mode andPanBezierCount:(UInt8)pancount andTiltBezierCount:(UInt8)tiltcount WithStr:(NSString *)str andBuffer_second:(UInt16)Buffer_second;



/**
 AAAF(04) （video 设置）Video Set

 @param cb             cb description
 @param frameHead      frameHead description
 @param functionNumber functionNumber description
 @param videoTime      videoTime description
 */
- (void)sendVedioTimeDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andVideoTime:(UInt32)videoTime andBezierCount:(UInt8)count WithStr:(NSString *)str;

/**
 555F(04) (video 设置)

 @param cb <#cb description#>
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param videoTime videoTime description
 @param count count description
 @param count count description
 @param str str description
 */
- (void)sendVedioTimeDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andVideoTime:(UInt32)videoTime andPanBezierCount:(UInt8)pancount andTiltBezierCount:(UInt8)tiltcount WithStr:(NSString *)str;
/**
 AAAF(06)（预览） Bezier Preview

 @param cb             cb description
 @param frameHead      frameHead description
 @param functionNumber functionNumber description
 @param mode           mode description
 @param postion        postion description
 */
- (void)sendBezierPreviewWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode sliderPostion:(Float32)postion WithStr:(NSString *)str;
- (void)sendBezierPreviewWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFuntionMode:(UInt8)mode panPostion:(Float32)panPostion tiltPostion:(Float32)tiltPostion WithStr:(NSString *)str;


/**
 AAAF(A0, A1, A2, A3, A4, A5, A6, A7)SliderShifting
 555F(50, 51, 52, 53, 54, 55, 56, 57)PanShifting
 @param cb             cb description
 @param frameHead      frameHead description
 @param functionNumber functionNumber description
 @param postion        postion description(3到4个点组成的一个位置点的集合)
 */
- (void)sendBezierShiftingWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andPostionArray:(NSArray *)postionarr WithStr:(NSString *)str;


/**
 AAAF(A8, A9, AA, AB, AC, AD, AE, AF)SliderTime
 555F(68, 69, 6A, 6B, 6C, 6D, 6E, 6F)

 @param cb             cb description
 @param frameHead      frameHead description
 @param functionNumber functionNumber description
 @param timearr        timearr description(3到4个点组成的一个时间点的集合)
 */
- (void)sendBezierTimeWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andTimeArray:(NSArray *)timearr WithStr:(NSString *)str;


/**
 AAAF(05) Stop Motion
 555F
 
 @param cb cb description
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param mode mode description
 @param timestamp timestamp description
 @param currentFrame currentFrame description
 @param longestTime longestTime description
 */
- (void)sendStopMotionSetWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode andTimestamp:(UInt64)timestamp CurrentFrame:(UInt32)currentFrame andlongestTime:(UInt16)longestTime WithStr:(NSString *)str;



/**
 555F(07) Panorama(矩阵模式)

 @param cb cb description
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param angle angle description
 @param startAngle startAngle description
 @param endAngle endAngle description
 @param interval interval description
 @param str str description
 */
- (void)sendPanoramaWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode andAngle:(UInt16)angle andStartAngle:(UInt16)startAngle andEndAngle:(UInt16)endAngle andInterVal:(UInt8)interval  WithStr:(NSString *)str andTiltVeloc:(UInt16)tiltVoloc;


/**
 555F(08) Gigaplexl(矩阵模式)

 @param cb cb description
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param mode mode description
 @param widthAngle widthAngle description
 @param heightAngle heightAngle description
 @param panSpeed panSpeed description
 @param tiltSpeed tiltSpeed description
 @param interval interval description
 @param str str description
 */

- (void)sendGigaplexlWithCb:(CBPeripheral *)cb andFameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode andWidthAngle:(UInt16)widthAngle andHeightAngle:(UInt16)heightAngle andPanSpeed:(UInt16)panSpeed andTiltSpeed:(UInt16)tiltSpeed andInterVal:(UInt8)interval andStr:(NSString *)str;

/**
 AAAF 555F(00)

 @param cb cb description
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param timeStamp timeStamp description
 @param version version description
 @param versionBytes versionBytes description
 @param slideSection slideSection description
 @param isUpdate isUpdate description
 */
- (void)sendVersionWith:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andTimeStamp_ms:(UInt64)timeStamp andVersion:(UInt16)version andVersionBytes:(UInt32)versionBytes andSlideSections:(UInt8)slideSection andiSmandatoryUpdate:(UInt8)isUpdate WithStr:(NSString *)str;


/**
 0x65(帧头) Update发送更新

 @param cb cb description
 @param frameHead frameHead description
 @param bytesNumber bytesNumber description
 @param dataArray dataArray description
 @param str str description
 */
- (void)sendUpdateTheCb:(CBPeripheral *)cb andFrameHead:(UInt8)frameHead BytesNumber:(UInt16)bytesNumber andDataArray:(NSArray * )dataArray WithStr:(NSString *)str;


/**
 0x09(555F帧头) focusMode设置两个点的位置
 

 @param cb cb description
 @param frameHead frameHead description
 @param functionMode functionMode description
 @param panVeloc panVeloc description
 @param tiltVeloc tiltVeloc description
 @param islocktilt islocktilt description
 @param totaltime totaltime description
 @param str str description
 */
- (void)sendX2FoucsModeTwoPointWith:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andMode:(UInt8)functionMode PanVeloc:(UInt16)panVeloc tiltVeloc:(UInt16)tiltVeloc andisLockTilt:(UInt8)islocktilt andTotalTime:(UInt16)totaltime WithStr:(NSString *)str;

/**
 0X09(AAAF)

 @param cb cb description
 @param frameHead frameHead description
 @param funtionMode funtionMode description
 @param slideveloc slideveloc description
 @param totaltime totaltime description
 @param str
 */
- (void)sendSlideFocusModeTwoPointWith:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andMode:(UInt8)funtionMode SlideVeloc:(UInt16)slideveloc andTotalTime:(UInt16)totaltime withStr:(NSString *)str;

/**
 0x0A（focusMode）555F

 @param cb cb description
 @param frameHead frameHead description
 @param functionNumber functionNumber description
 @param dirction dirction description
 @param isloop isloop description
 @param timeStamp timeStamp description
 */
- (void)sendFocusModeWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andDirction:(UInt8)dirction andIsloop:(UInt8)isloop andTimeStamp_ms:(UInt64)timeStamp  WithStr:(NSString *)str andAllTime:(UInt16)totaltime;


- (void)sendSetFocusModeWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFuntionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andSlideOrPanVeloc:(UInt16)slideOrPanVeloc andTiltVeloc:(UInt16)tiltVeloc andIsLockTilt:(UInt8)islockTilt andTotalTime:(UInt16)totaltime WithStr:(NSString *)str;


/**
 0x0B (2.4G address)AAAF 555F

 @param cb cb description
 @param framed framed description
 @param functionNumber functionNumber description
 @param timeStamp timeStamp description
 */
- (void)send24GAddressWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andTimeStamp:(UInt64)timeStamp WithStr:(NSString *)str;
- (void)send24Gx2AddresssWithCB:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andTimeStamp:(UInt64)timeStamp WithStr:(NSString *)str;

- (void)sendReturnX2ZeroWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode WithStr:(NSString *)str;


/**
 0x09 AAAF

 @param cb cb description
 @param framed framed description
 @param functionNumber functionNumber description
 @param functionMode functionMode description
 @param slider_A_point slider_A_point description
 @param slider_B_point slider_B_point description
 @param totaltime totaltime description
 */
- (void)sendTarget_prepare_SliderWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andVeloc:(UInt16)veloc andSlider_A_point:(UInt32)slider_A_point andSlider_B_point:(UInt32)slider_B_point andTotalTime:(UInt16)totaltime WithStr:(NSString *)str;

/**
 0x0a AAAF

 @param cb cb description
 @param framed framed description
 @param functionNumber functionNumber description
 @param functionMode functionMode description
 @param direction direction description
 @param isloop isloop description
 @param totaltime totaltime description
 @param smoothnesslevel smoothnesslevel description
 @param timestamp timestamp description
 */
- (void)sendTarget_play_SliderWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andDirection:(UInt8)direction andIsloop:(UInt8)isloop andTotaltime:(UInt16)totaltime andsmoothnessLevel:(UInt8)smoothnesslevel andTimeStamp:(UInt64)timestamp WithStr:(NSString *)str;

/**
 0x09 555F

 @param cb cb description
 @param framed framed description
 @param functionNumber functionNumber description
 @param functionMode functionMode description
 @param panveloc panveloc description
 @param tiltveloc tiltveloc description
 @param pan_A_point pan_A_point description
 @param tilt_A_point tilt_A_point description
 @param pan_B_point pan_B_point description
 @param tilt_B_point tilt_B_point description
 @param totaltime totaltime description
 */
- (void)sendTarget_prepare_X2WithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andpanVeloc:(UInt16)panveloc andtiltVeloc:(UInt16)tiltveloc andPan_A_point:(UInt16)pan_A_point andTilt_A_Point:(UInt16)tilt_A_point andPan_B_point:(UInt16)pan_B_point andTilt_B_Point:(UInt16)tilt_B_point andTotalTime:(UInt16)totaltime WithStr:(NSString *)str;


/**
0x0a 555F

 @param cb cb description
 @param framed framed description
 @param functionNumber functionNumber description
 @param functionMode functionMode description
 @param direction direction description
 @param isloop isloop description
 @param totaltime totaltime description
 @param smoothnesslevel smoothnesslevel description
 @param timestamp timestamp description
 */
- (void)sendTarget_play_X2WithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctinMode:(UInt8)functionMode andDirection:(UInt8)direction andIsloop:(UInt8)isloop andTotaltime:(UInt16)totaltime andsmoothnessLevel:(UInt8)smoothnesslevel andTimeStamp:(UInt64)timestamp WithStr:(NSString *)str andSingleorMulti:(UInt8)isSingleorMulti;



#pragma mark --------------------S1A3发送数据协议---------------------

- (void)sendS1A3_S1VelocWith:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andVeloc:(UInt16)realVeloc With:(NSString *)str;
- (void)sendS1A3_X2VelocWith:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFuntionNumber:(UInt8)functionNumber andPanVeloc:(UInt16)realPanVeloc andTiltVeloc:(UInt16)realTiltVeloc With:(NSString *)str;


#pragma mark -------全局发2.4G信号--------------
- (void)send2_4GWithCB:(CBPeripheral *)cb andFrameHead:(UInt16)framed andTimestamp:(UInt64)timestamp;



@end
