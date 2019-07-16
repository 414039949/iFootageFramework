//
//  iFS1A3_TargetViewController.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFootageRocker.h"
#import "iF3DButton.h"
#import "iFSegmentView.h"
@interface iFS1A3_TargetViewController : iFRootViewController
@property (strong, nonatomic)  iFootageRocker *LeftanalogueStick;
@property (strong, nonatomic)  iFootageRocker *RightanalogueStick;

@property (nonatomic, strong) iFLabel * panValueLabel;
@property (nonatomic, strong) iFLabel * tiltValueLabel;
@property (nonatomic, strong) iFLabel * slideValueLabel;


@property (nonatomic, strong) iF3DButton * setStartBtn;
@property (nonatomic, strong) iF3DButton * setEndBtn;

@property (nonatomic, strong) iF3DButton * lockTiltBtn;
@property (nonatomic, strong) iF3DButton * lockPanBtn;
@property (nonatomic, strong) iFSegmentView *single_MultiSegmentView;

@property (nonatomic, strong) iF3DButton * leftPlayBtn;
@property (nonatomic, strong) iF3DButton * rightPlayBtn;
@property (nonatomic, strong) iF3DButton * fileBtn;
@property (nonatomic, strong) iF3DButton * saveBtn;
@property (nonatomic, strong) iF3DButton * playBtn;
@property (nonatomic, strong) iF3DButton * stopBtn;

@property (nonatomic, strong) iFButton * isLoopBtn;
@property (nonatomic, strong) iFLabel * timeLabel;

@end
