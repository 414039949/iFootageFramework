//
//  sliceCirleView.h
//  FinalCirleView
//
//  Created by 黄品源 on 2016/12/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeProgressDelegate <NSObject>

- (void)getProgressAngle:(CGFloat)angle;

@end


@interface sliceCirleView : UIControl

@property (nonatomic, assign)CGFloat startAngle;
@property (nonatomic, assign)CGFloat progress;
@property (nonatomic, assign)CGFloat lineWidth;
@property (nonatomic, assign)CGFloat handleOutSideRadius;

@property (nonatomic, assign)NSUInteger currentNumber;
@property (nonatomic, assign)NSUInteger totalNumber;
@property (nonatomic, assign)NSUInteger lightSliceNumber;

@property (nonatomic, strong)id<changeProgressDelegate>delegate;


@end
