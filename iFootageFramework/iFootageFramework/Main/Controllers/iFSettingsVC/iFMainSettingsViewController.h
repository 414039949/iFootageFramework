//
//  iFMainSettingsViewController.h
//  iFootage
//
//  Created by 黄品源 on 2016/10/24.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFLabel.h"
#import "iFButton.h"

#import "iFCustomView.h"

@interface iFMainSettingsViewController : iFRootViewController

@property(nonatomic, strong)iFLabel * shootingmodeLabel;
@property(nonatomic, strong)iFLabel * displayunitLabel;
@property(nonatomic, strong)iFLabel * delayplayLabel;
@property(nonatomic, strong)iFLabel * slideCountLabel;
@property(nonatomic, strong)iFButton * slideCountBtn;



@property(nonatomic, assign)BOOL isupdateS1;
@property(nonatomic, assign)BOOL isupdateX2;



@property(nonatomic, strong)iFCustomView * changeModeBtn;
@property(nonatomic, strong)iFCustomView * changeUnitBtn;

@property(nonatomic, strong)UISegmentedControl * shootModeSC;
@property(nonatomic, strong)UISegmentedControl * displayUnitSC;

@property(nonatomic, strong)iFButton * updateBtn;
@property(nonatomic, strong)iFButton * updateSlideBtn;


@property(nonatomic, strong)iFLabel * x2label;
@property(nonatomic, strong)iFLabel * slidelabel;



@end
