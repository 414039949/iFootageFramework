//
//  iFNavgationController.h
//  iFootage
//
//  Created by 黄品源 on 16/6/7.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iFStatusBarView;

@interface iFNavgationController : UINavigationController

@property (nonatomic , strong)iFStatusBarView * statusView;

@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;

@end
