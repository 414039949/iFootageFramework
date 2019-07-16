//
//  CirleSlide.h
//  FinalCirleView
//
//  Created by 黄品源 on 2016/12/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeProgressAngleDelegate <NSObject>

- (void)changeDirectionWithProgressAngle:(CGFloat)angle;
- (void)endClickDelegate;

@end

@interface CirleSlide : UIControl

@property (nonatomic, assign)CGFloat startAngle;
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, assign)CGFloat lineWidth;
@property (nonatomic, assign)CGFloat handleOutSideRadius;
@property (nonatomic, assign)BOOL isTouch;

@property (nonatomic, strong)UIImageView * cameraImageView;
@property (nonatomic, strong)id<changeProgressAngleDelegate>delegate;


@end
