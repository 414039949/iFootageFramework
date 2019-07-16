//
//  iFFocusSlideView.m
//  iFootage
//
//  Created by 黄品源 on 2016/12/16.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFFocusSlideView.h"

@implementation iFFocusSlideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];
        CGAffineTransform transform1= CGAffineTransformMakeRotation(M_PI_2 / 6);
        CGAffineTransform transform2= CGAffineTransformMakeRotation(-M_PI_2 / 6);

        UIImageView * view1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(30), iFSize(40))];
        view1.center = CGPointMake(iFSize(189), iFSize(155));
        view1.backgroundColor = [UIColor clearColor];
        view1.image = [UIImage imageNamed:target_RED_CAMERAIMG];
        [self addSubview:view1];
        
        UIImageView * view2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(30), iFSize(40))];
        
        view2.center = CGPointMake(iFSize(480), iFSize(155));
        view2.backgroundColor = [UIColor clearColor];
        view2.image = [UIImage imageNamed:target_RED_CAMERAIMG];
        [self addSubview:view2];
        
        
        view1.transform = transform1;
        view2.transform = transform2;

    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor grayColor] set];
    
    //x,y 圆心
    //radius 半径
    //startAngle 画弧的起始位置
    //endAngel 画弧的结束位置
    //clockwise 0 顺针 1 逆时针
    CGContextSetLineWidth(context, 5);
    CGContextAddArc(context, iFSize(334), iFSize(-350), iFSize(525), M_PI_2 / 6 * 5, M_PI_2 /6  * 7, 0);
    //    CGContextClosePath(context);
    //渲染
    CGFloat total = M_PI_2 / 6 * 2;
    CGContextStrokePath(context);
    [[UIColor whiteColor] set];
    
    if (self.direction == 0x01) {
//        向左
        CGContextAddArc(context, iFSize(334), iFSize(-350), iFSize(525), M_PI_2 / 6 * 5, M_PI_2 / 6 * 5 + total * self.progress, 0);
        CGContextStrokePath(context);
    
    }else if(self.direction == 0x02){
        /*向右*/
        CGContextAddArc(context, iFSize(334), iFSize(-350), iFSize(525), M_PI_2 / 6 * 7, M_PI_2 / 6 * 7 + total * self.progress, 1);
        CGContextStrokePath(context);
    }

    

    
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
//    NSLog(@"%lf", progress);
    
    if (self.direction == 0x02) {
        if (progress < -0.999)
            _progress = -0.999;
        else if(progress > 0)
            _progress = 0;
    }else{
        if (progress > 0.999)
            _progress = 0.999;
        else if(progress < 0)
            _progress = 0;
    }
    [self setNeedsDisplay];
    
}


@end
