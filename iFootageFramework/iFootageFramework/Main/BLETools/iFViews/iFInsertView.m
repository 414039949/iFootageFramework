//
//  iFInsertView.m
//  iFootage
//
//  Created by 黄品源 on 16/8/3.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFInsertView.h"

@implementation iFInsertView
{
    CAShapeLayer * shapeLayer;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize label;

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
                
        
        UIBezierPath * mPath = [UIBezierPath bezierPath];
        [mPath moveToPoint:CGPointMake(10, 0)];
        [mPath addLineToPoint:CGPointMake(10, self.frame.size.height - 10)];
        [mPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
        [mPath addLineToPoint:CGPointMake(20, self.frame.size.height)];
        [mPath addLineToPoint:CGPointMake(10, self.frame.size.height - 10)];
        [mPath closePath];
        
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = [UIColor redColor].CGColor;
        shapeLayer.fillColor = [UIColor redColor].CGColor;
        shapeLayer.lineWidth = 2;
        shapeLayer.path = mPath.CGPath;
        shapeLayer.lineCap = kCALineCapSquare;
        [self.layer addSublayer:shapeLayer];
        
        
//        label.backgroundColor = [UIColor redColor];
//        [self addSubview:label];
//        self.backgroundColor= [UIColor clearColor];
    }
    return self;
}
#warning -----move 加大感应区域操作更顺畅 ----
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    //    NSLog(@"point = %@", NSStringFromCGPoint(point));
    
    //    NSLog(@"%@", self);
    if ((point.x >= -iFSize(10) && point.x < self.frame.size.width + iFSize(20)) && (point.y >= -iFSize(5) &&  point.y < self.frame.size.height + iFSize(20))) {
        
        return YES;
        
    }else{
        return  NO;
        
    }
}
@end
