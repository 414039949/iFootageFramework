//
//  iFCirlePanoVIew.h
//  iFootage
//
//  Created by 黄品源 on 2016/12/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CirleSlide.h"
#import "sliceCirleView.h"

@protocol getStartAngleAndEndAngleDelegate <NSObject>

- (void)getStartAngle:(CGFloat)startAngle EndAngle:(CGFloat)endAngle;

@end


@interface iFCirlePanoVIew : UIView<changeProgressAngleDelegate, changeProgressDelegate>



@property (nonatomic, assign)NSUInteger totalSlice;

@property (nonatomic, strong)sliceCirleView * sliceView;
@property (nonatomic, strong)CirleSlide * cir;
@property (nonatomic, strong)id<getStartAngleAndEndAngleDelegate>delegate;

@property (nonatomic, strong)NSTimer * timer;
@property (nonatomic) BOOL isStart;

@end
