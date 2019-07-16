//
//  iFCirleViewController.h
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFLabel.h"
#import "iFButton.h"
#import "iFCircularArcView.h"
#import "iFLabelView.h"
#import "iF3DButton.h"



@interface iFCirleViewController : iFRootViewController


@property (nonatomic, strong)iFLabelView * intervalLabel;
@property (nonatomic, strong)iFLabelView * PicturesLabel;
@property (nonatomic, strong)iFLabelView * RuntimeLabel;

//@property (nonatomic, strong)iFLabelView * PanValueLabel;
//@property (nonatomic, strong)iFLabelView * TiltValueLabel;


@property (nonatomic, strong)iFLabel * intervalValueLabel;
@property (nonatomic, strong)iFLabel * picturesValueLabel;
@property (nonatomic, strong)iFLabel * RuntimeValueLabel;
@property (nonatomic, strong)iFLabel * degreeLabel;


@property (nonatomic, strong)iF3DButton * pauseBtn;
@property (nonatomic, strong)iF3DButton * playBtn;
@property (nonatomic, strong)iF3DButton * stopBtn;

@property (nonatomic, copy)NSString  * interval;
@property (nonatomic, assign)CGFloat aOneAngle;

@property (nonatomic, assign)BOOL isRunning;


@property (nonatomic, assign)NSInteger totalTime;


@end
