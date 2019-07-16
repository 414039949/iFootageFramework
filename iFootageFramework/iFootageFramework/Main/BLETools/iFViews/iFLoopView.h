//
//  iFLoopView.h
//  iFootage
//
//  Created by 黄品源 on 2016/10/26.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
enum MODEL_CURVE {
    MODEL_TIMELAPSE = 0,
    MODEL_VIDEO,
    MODEL_STOPMOTION,
} ;

@interface iFLoopView : UIView

@property(nonatomic, strong)UILabel * titleLabel;
@property enum MODEL_CURVE MODEL;

@property NSInteger index;
- (void)loopChangeTitle:(NSInteger)a;


@end
