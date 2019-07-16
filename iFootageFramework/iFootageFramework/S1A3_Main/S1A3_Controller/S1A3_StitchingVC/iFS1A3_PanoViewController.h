//
//  iFS1A3_PanoViewController.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/24.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"

@interface iFS1A3_PanoViewController : iFRootViewController
@property (nonatomic, copy)NSString  * interval;
@property (nonatomic, assign)CGFloat aOneAngle;
@property (nonatomic, assign)NSInteger totalTime;

@property (nonatomic, assign)BOOL isRunning;

@end
