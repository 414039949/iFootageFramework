//
//  iFTimelapseViewController.h
//  iFootage
//
//  Created by 黄品源 on 16/8/4.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFInsertView.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "iFLabel.h"
#import "iFButton.h"
#import "iFCustomSlider.h"
#import "iFCBStatus.h"
#import "iF3DButton.h"

enum MODEl_AXLE {
    MODEL_SLIDER = 0,
    MODEL_PAN,
    MODEL_TILT,
} ;
enum ConnectionStatus{
    
    StatusSLIDEandX2AllConnected = 0,
    StatusSLIDEOnlyConnected,
    StatusX2OnlyConnected,
    StatusSLIDEandX2AllDisConnected,
};



@interface iFTimelapseViewController : iFRootViewController



@property     enum MODEl_AXLE MODEL;
@property     enum ConnectionStatus status;


@property (nonatomic, strong)UIButton * backBtn;

@property (nonatomic, strong)iF3DButton * SliderBtn;
@property (nonatomic, strong)iF3DButton * PanBtn;
@property (nonatomic, strong)iF3DButton * TiltBtn;

@property (nonatomic, strong)iFButton * settingBtn;
@property (nonatomic, strong)iF3DButton * KeyBtn;
@property (nonatomic, strong)iF3DButton * PauseBtn;
@property (nonatomic, strong)iF3DButton * PlayBtn;
@property (nonatomic, strong)iF3DButton * SaveBtn;
@property (nonatomic, strong)iF3DButton * preViewBtn;
@property (nonatomic, strong)iF3DButton * StopMotionBtn;
@property (nonatomic, strong)iF3DButton * StopBtn;
@property (nonatomic, strong)iF3DButton * returnBtn;


@property (nonatomic, assign)BOOL isSaveData;
@property (nonatomic, assign)NSInteger indexRow;




@property (nonatomic, strong)iFLabel  * timerLabel;

@property (nonatomic, strong)UILabel * FrameLabel;
@property (nonatomic, strong)UILabel * fpsLabel;

@property (nonatomic, strong)NSTimer * InsertViewTimer;

@property NSInteger arrayIndex;


@property (nonatomic, strong)iFInsertView * insertView;
@property NSInteger insertIndex;
@property CGFloat  XValue;
@property CGFloat  YValue;


/**
 *  发送视图
 */
@property (nonatomic, strong)SendDataView * sendDataView;
/**
 *  接收视图
 */
@property (nonatomic, strong)ReceiveView * receiveView;

@property (nonatomic, strong)NSMutableArray * TimeValueArray;
@property (nonatomic, strong)NSMutableArray * YValueArray;


@property (nonatomic, strong)NSMutableArray * SlideTimeValueArray;
@property (nonatomic, strong)NSMutableArray * SlideYValueArray;
@property (nonatomic, strong)NSMutableArray * PanTimeValueArray;
@property (nonatomic, strong)NSMutableArray * PanYValueArray;
@property (nonatomic, strong)NSMutableArray * TiltTimeValueArray;
@property (nonatomic, strong)NSMutableArray * TiltYValueArray;


@property UInt8 functionMode;
@property UInt8 shootingMode;
@property UInt8 SlideBezierCount;
@property UInt8 PanBezierCount;
@property UInt8 TiltBezierCount;

@property UInt8 isNewBezier;
@property UInt8 isSettingClear;
@property UInt64 checkTime;
@property UInt32 totalFrames;
@property UInt16 exposure;
@property UInt16 interval;
@property UInt16 actualInterval;


#pragma mark -   test 测试用控件 --- 
//@property (nonatomic, strong)iFCBStatus * cbslideView;
//@property (nonatomic, strong)iFCBStatus * cbx2View;

@end
