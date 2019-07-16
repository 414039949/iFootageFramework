//
//  iFFocusModeViewController.h
//  iFootage
//
//  Created by 黄品源 on 2016/10/24.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
//#import "JSAnalogueStick.h"
#import "iFootageRocker.h"

#import "iFLabel.h"
#import "iFButton.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "iFUpdateBtn.h"
#import "iF3DButton.h"


enum CBStatusConnected{
    CBS1ANDX2 = 0,
    CBOneS1,
    CBOneX2,
    CBAllNull,
};


@interface iFFocusModeViewController : iFRootViewController


@property enum CBStatusConnected status;

@property (strong, nonatomic)  iFootageRocker *LeftanalogueStick;
@property (strong, nonatomic)  iFootageRocker *RightanalogueStick;

@property (nonatomic, strong) iFLabel * panValueLabel;
@property (nonatomic, strong) iFLabel * tiltValueLabel;
@property (nonatomic, strong) iFLabel * slideValueLabel;

@property (nonatomic, strong) iF3DButton * setStartBtn;
@property (nonatomic, strong) iF3DButton * setEndBtn;

@property (nonatomic, strong) iF3DButton * lockTiltBtn;
@property (nonatomic, strong) iF3DButton * lockPanBtn;


@property (nonatomic, strong) iF3DButton * leftPlayBtn;
@property (nonatomic, strong) iF3DButton * rightPlayBtn;
@property (nonatomic, strong) iF3DButton * fileBtn;
@property (nonatomic, strong) iF3DButton * saveBtn;
@property (nonatomic, strong) iF3DButton * playBtn;
@property (nonatomic, strong) iF3DButton * stopBtn;
@property (nonatomic, assign)BOOL isRunning;


@property (nonatomic, strong) iFButton * pauseBtn;
@property (nonatomic, strong) iFButton * isLoopBtn;
@property (nonatomic, strong) iFLabel * timeLabel;
@property (nonatomic, strong) UIView * bannerView;
@property (nonatomic, strong) iFButton * pauseBtn2;

@property (nonatomic, strong)UISegmentedControl * leftSegmentedControl;
@property (nonatomic, strong)UISegmentedControl * rightSegmentedControl;
@property (nonatomic, assign)CGFloat leftunit;
@property (nonatomic, assign)CGFloat rightunit;

@property (nonatomic, assign) NSUInteger totalTime;


@end
