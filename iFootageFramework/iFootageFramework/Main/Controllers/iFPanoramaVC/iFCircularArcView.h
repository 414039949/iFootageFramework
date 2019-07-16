//
//  iFCircularArcView.h
//  circularContext
//
//  Created by 黄品源 on 2016/11/24.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFCircularArcView : UIView


/**
 总共进度
 */
@property (assign, nonatomic) NSUInteger progressTotal;

/**
 当前位置（进度）
 */
@property (assign, nonatomic) NSUInteger progressCurrent;


/**
 完成的颜色
 */
@property (strong, nonatomic) UIColor *completedColor;


/**
 未完成的颜色
 */
@property (strong, nonatomic) UIColor *incompletedColor;


/**
 间隔厚度
 */
@property (assign, nonatomic) CGFloat thickness;


/**
 每一个间隔的颜色
 */
@property (strong, nonatomic) UIColor *sliceDividerColor;

/**
 隐藏间隔（YES 隐藏 NO 不隐藏）
 */
@property (assign, nonatomic) BOOL sliceDividerHidden;

/**
 每一片间隔的厚度
 */
@property (assign, nonatomic) NSUInteger sliceDividerThickness;

@property (assign , nonatomic)NSUInteger  startNumber;


@end
