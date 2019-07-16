//
//  iFAdjustVelocView.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/12.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdjustVelocCurveDelegate <NSObject>

- (void)AdjustVelocCurveWithpercentValue:(CGFloat)value andView:(UIView *)anyView;


@end

@interface iFAdjustVelocView : UIView


@property (nonatomic, strong) UIBezierPath * curve;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;

@property (nonatomic, strong) UIColor * color;

@property (nonatomic, assign) CGFloat initValue;


@property (nonatomic, strong)id<AdjustVelocCurveDelegate>delegate;


- (id)initWithFrame:(CGRect)frame WithColor:(UIColor *)color WithTitle:(NSString *)title;
- (CGFloat)CountSomeThingsAndPointX:(CGFloat)X;

- (void)initCurveWithaValue:(CGFloat)aValue;

@end
