//
//  iFPanoramaViewController.h
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFLabel.h"
#import "iFButton.h"

@interface iFPanoramaViewController : iFRootViewController


@property (nonatomic, strong)iFLabel * CameraSensorLabel;
@property (nonatomic, strong)iFLabel * FocalLengthLabel;
@property (nonatomic, strong)iFLabel * AspectRatioLabel;
@property (nonatomic, strong)iFLabel * intervalLabel;
@property (nonatomic, strong)iFButton * CameraSensorBtn;
@property (nonatomic, strong)iFButton * FocalLenthBtn;
@property (nonatomic, strong)iFButton * intervalBtn;
@property (nonatomic, strong)iFButton * AspectRatioBtn;


@property (nonatomic, strong)NSMutableArray * CameraSensorArray;
@property (nonatomic, strong)NSMutableArray * FocalLengthArray;
@property (nonatomic, strong)NSMutableArray * AspectRatioArray;
@property (nonatomic, strong)NSMutableArray * intervalArray;

@property (nonatomic, assign)NSUInteger identifier;
@property (nonatomic, assign)NSUInteger index;

@end

