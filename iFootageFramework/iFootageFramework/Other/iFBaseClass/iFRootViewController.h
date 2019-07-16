//
//  iFRootViewController.h
//  iFootage
//
//  Created by 黄品源 on 16/6/7.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFLabel.h"
#import "iFButton.h"
#import <Masonry/Masonry.h>

@class  iFButton, iFLabel;


@interface iFRootViewController : UIViewController



@property (nonatomic, strong)iFButton * connectBtn;
@property (nonatomic, strong)iFButton * rootbackBtn;
//@property (nonatomic, strong)UIImageView * backimgaeView;
@property (nonatomic, strong)iFLabel * titleLabel;
@property (nonatomic, assign)BOOL isAutoPush;
@property (nonatomic, assign)BOOL ispresent;


- (void)forceOrientationLandscape;
- (void)forceOrientationPortrait;
- (void)RootVerticalscreenUI;
- (void)RootLandscapescreenUI;




@end
