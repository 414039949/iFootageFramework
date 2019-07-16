//
//  iFCustomSlider.h
//  iFootage
//
//  Created by 黄品源 on 2016/10/19.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeValueDelegate <NSObject>

- (void)changeDistanceValue:(CGFloat)value;


@end


@interface iFCustomSlider : UIView<UIGestureRecognizerDelegate>


@property(nonatomic, strong)UIView * upView;
@property(nonatomic, strong)UIView * downView;


@property (nonatomic, strong)UIBezierPath * actPath;
@property (nonatomic, strong)CAShapeLayer * actLayer;
@property (nonatomic, strong)UIColor * color;

@property (nonatomic, strong)UILabel * uplabel;
@property (nonatomic, strong)UILabel * downlabel;

@property CGFloat totalValue;
@property(nonatomic, strong)id<changeValueDelegate>changeDelegate;

- (id)initWithFrame:(CGRect)frame :(UIColor *)cscolor :(CGFloat)total;

- (void)changeWithAllValue:(CGFloat)allValue andUpValue:(CGFloat)upValue andDownValue:(CGFloat)downValue WithModel:(NSInteger)model;
@end
