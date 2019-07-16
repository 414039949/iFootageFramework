//
//  iFTransmitViewController.h
//  iFootage
//
//  Created by iFootage-iOS on 16/6/20.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "BaseViewController.h"
#import "iFootageRocker.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "DialogView.h"
#import "HexKeyboardView.h"
#import "iFLabel.h"
#import "iFButton.h"
#import "iFProgressView.h"


#define FIRST_HEIGHT  90
#define SECOND_HEIGHT 60
#define THIRD_HEIGHT 60
#define FOURTH_HEIGHT  145
#define FIFTH_HEIGHT 60
#define SIXTH_HEIGHT  90
#define SEVENTH_HEIGHT 60
#define EIGHTTH_HEIGHT  132
#define NINETH_HEIGHT  255
#define CELL_BORDER_COLOR    @"#898989"

#define FIRST_TXT_TAG                    101
#define FIRST_EDIT_TAG                   102
#define FIRST_REFRESH_BTN_TAG            103
#define FIRST_SET_BTN_TAG                104
#define SECOND_REFRESH_BTN_TAG           105
#define SECOND_TXT_TAG                   106
#define THIRD_TXT_TAG                    107
#define THIRD_REFRESH_BTN_TAG            108
#define FIFTH_REFRESH_BTN_TAG            110
#define FIFTH_REFRESH_TXT_TAG            1010
#define SIXTH_SET_BTN_TAG                111
#define SIXTH_REFRESH_BTN_TAG            1111
#define SIXTH_REFRESH_TXT_TAG            1110
#define SIXTH_SET_EDIT_TAG               1112
#define SEVENTH_REFRESH_BTN_TAG          112
#define SEVENTH_REFRESH_TXT_TAG          1120
#define EIGHTTH_REFRESH_BTN_TAG          113
#define EIGHTTH_REFRESH_TXT_TAG          1130
#define EIGHTTH_SET_EDIT_TAG             1131
#define EIGHTTH_SET_BTN_TAG              114

#define FF91                             0xFF91
#define FF92                             0xFF92
#define FF93                             0xFF93
#define FF94                             0xFF94
#define FF95                             0xFF95
#define FF96                             0xFF96
#define FF97                             0xFF97
#define FF98                             0xFF98
#define FF99                             0xFF99
#define FF9A                             0xFF9A


#define    Encode_ASCII      1
#define  Encode_HEX         2

@interface iFTransmitViewController : BaseViewController<JSAnalogueStickDelegate>


{
    NSUInteger               Encode;
    NSTimer                 *loopSendDataTimer;  //循环发送的timer
    DialogView         *dialogView;
    UISlider            * trackSlider;
    NSMutableArray     *pickerArray; //发送数据的间隔
    float              intervalTimer;
    NSTimer * receiveTimer;
    NSTimer * returnTimer;
    
    /**
     *  x = 右摇杆的横坐标 
     *  y = 右摇杆的纵坐标
     */
        CGFloat analoSX; //x 的 绝对值
        CGFloat annloSY; //y 的 绝对值
        CGFloat  scaleX_dividedby_Y;//  x / y 的值
        CGFloat  scaleY_dividedby_X;//  y / x 的值
        CGFloat ActiveVX; // 动态横坐标
        CGFloat ActiveVY; // 动态纵坐标
        CGFloat ActiveSliderY;
    
}
/**
 *  左 右摇杆
 */

@property (strong, nonatomic)  iFootageRocker *LeftanalogueStick;
@property (strong, nonatomic)  iFootageRocker *RightanalogueStick;

/**
 *  发送视图
 */
@property (strong, nonatomic)  SendDataView     * sendView;
@property (strong, nonatomic)  NSMutableArray   * dataArray;
@property (strong, nonatomic)  AppDelegate      * appDelegate;
@property(nonatomic , strong)  ReceiveView      * receiveView;


@property(nonatomic , strong) UIButton              *sendBtn,*resetBtn,*clearBtn,*intervalBtn;
@property(nonatomic , strong) UISwitch              *switchReceive,*switchAutoSend; //开关接收，自动发送开关
@property(nonatomic , strong) UISegmentedControl   *segmentedView;  //编码控制


@property (nonatomic, strong)UIButton * btn1;
@property (nonatomic, strong)UIButton * btn2;
@property (nonatomic, strong)UIButton * modfiNameBtn;
@property (nonatomic, strong)UIButton * backBtn;
@property (nonatomic, strong)UILabel  * TrackRealTimePositionLabel;
@property (nonatomic, strong)UILabel  * PanRealTimePositionLabel;
@property (nonatomic, strong)UILabel  * TiltRealTimePositionLabel;
@property (nonatomic, strong)UILabel  * LeftStickLabel;

/**
 *  右边摇杆的的横纵坐标label
 */
@property (nonatomic, strong)UILabel * RightActiveXlabel;
@property (nonatomic, strong)UILabel * RightActiveYlabel;

@property (nonatomic, strong)iFLabel * leftTitleLabel;
@property (nonatomic, strong)iFLabel * rightTitleLabel;
@property (nonatomic, strong)iFProgressView * SlideProView;
@property (nonatomic, strong)iFProgressView * PanProView;
@property (nonatomic, strong)iFProgressView * TiltProView;


@property (nonatomic, strong)iFProgressView * slideVelocView;
@property (nonatomic, strong)iFProgressView * panVelocView;
@property (nonatomic, strong)iFProgressView * TiltVelocView;


@property (nonatomic, strong)UISegmentedControl * leftSegmentedControl;
@property (nonatomic, strong)UISegmentedControl * rightSegmentedControl;
@property (nonatomic, assign)CGFloat leftunit;
@property (nonatomic, assign)CGFloat rightunit;


@property SInt16 RightvelocityVectorX;
@property SInt16 RightvelocityVectorY;
@property SInt16 LeftvelocityVectorX;
@property SInt16 LeftvelocityVectorY;

@end
