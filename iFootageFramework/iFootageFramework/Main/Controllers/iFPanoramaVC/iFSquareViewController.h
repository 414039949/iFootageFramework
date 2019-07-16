//
//  iFSquareViewController.h
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFLabel.h"
#import "iFPanoView.h"
#import "iFButton.h"
//#import "JSAnalogueStick.h"
#import "iFootageRocker.h"

#import "iF3DButton.h"
#import "iFLabelView.h"



@interface iFSquareViewController : iFRootViewController<JSAnalogueStickDelegate>


@property (nonatomic, strong)iFLabelView * intervalLabel;
@property (nonatomic, strong)iFLabelView * PicturesLabel;
@property (nonatomic, strong)iFLabelView * RuntimeLabel;

@property (nonatomic, strong)iFLabelView * PanValueLabel;
@property (nonatomic, strong)iFLabelView * TiltValueLabel;



@property (nonatomic, strong)iF3DButton * SetStartBtn;
@property (nonatomic, strong)iF3DButton * SetEndBtn;

@property (nonatomic, strong)iF3DButton * pauseBtn;
@property (nonatomic, strong)iF3DButton * playBtn;
@property (nonatomic, strong)iF3DButton * stopBtn;


@property (nonatomic, strong)iFPanoView * backView;
@property (nonatomic, strong)iFootageRocker * GigaplexlStick;
@property (nonatomic, strong)UISegmentedControl * rightSegmentedControl;

@property (nonatomic, assign)CGFloat TiltAngle;
@property (nonatomic, assign)CGFloat PanAngle;
@property (nonatomic, assign)NSInteger totalTime;
@property (nonatomic, copy)NSString  * interval;
@property (nonatomic, assign)CGFloat rightunit;

@property UInt16 RightvelocityVectorX;
@property UInt16 RightvelocityVectorY;

@end
