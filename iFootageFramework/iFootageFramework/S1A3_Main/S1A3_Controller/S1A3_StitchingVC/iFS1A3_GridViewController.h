//
//  iFS1A3_GridViewController.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/24.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"

@interface iFS1A3_GridViewController : iFRootViewController

@property (nonatomic, assign)CGFloat TiltAngle;
@property (nonatomic, assign)CGFloat PanAngle;
@property (nonatomic, copy)NSString  * interval;
@property (nonatomic, assign)NSInteger totalTime;

@property UInt16 RightvelocityVectorX;
@property UInt16 RightvelocityVectorY;

@end
