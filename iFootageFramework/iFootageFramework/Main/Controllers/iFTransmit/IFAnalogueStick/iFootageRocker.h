//
//  iFootageRocker.h
//  手势测试
//
//  Created by 黄品源 on 2017/10/26.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iFootageRocker;

@protocol JSAnalogueStickDelegate <NSObject>

@optional

- (void)analogueStickDidChangeValue:(iFootageRocker *)analogueStick;

@end


@interface iFootageRocker : UIView

@property (nonatomic, strong)UIImageView * centerView;
@property (nonatomic, strong)UIImageView * backGroundView;

@property (nonatomic, readonly)CGFloat  xValue;
@property (nonatomic, readonly)CGFloat  yValue;
@property (nonatomic, strong)NSTimer * timer;
@property (nonatomic, assign) BOOL start;//是否开始计时
@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic,strong) UITouch *touch;

@property (nonatomic, assign)  id <JSAnalogueStickDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)autoPoint:(CGPoint)point;

- (void)reset;
- (void)dellocRcoker;
- (void)reStartRocker;
- (void)touchesBegan;
- (void)touchesEnded;
- (void)touchesCancelled;

@end
