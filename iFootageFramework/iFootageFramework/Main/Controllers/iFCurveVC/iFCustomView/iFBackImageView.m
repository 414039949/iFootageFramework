//
//  iFBackImageView.m
//  iFootage
//
//  Created by 黄品源 on 16/10/14.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFBackImageView.h"
#import "iFGetDataTool.h"

@implementation iFBackImageView
{
    CAShapeLayer * shapeLayer1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createSquare];
    }
    return self;
}

- (void)createUIWithFrames:(NSInteger)total orWithTimes:(NSInteger)times{
    
    static  CGFloat Xlength;
    Xlength =  self.frame.size.width;
    static  CGFloat Ylength;
    Ylength = self.frame.size.height;
    
    NSInteger unit = total / 10;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    
    for (int i = 0 ; i < 9; i++) {
        
        [bezierPath moveToPoint:CGPointMake((Xlength / 10) * (i + 1), 0)];
        [bezierPath addLineToPoint:CGPointMake((Xlength / 10) * (i + 1), Ylength - 10)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 8)];
        label.center = CGPointMake((Xlength / 10) * (i + 1), Ylength - 5);
        label.tag = 10 + i;
        label.text = [NSString stringWithFormat:@"%ld", unit * (i + 1)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:8];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
    }
    
    [bezierPath moveToPoint:CGPointMake(0, Ylength / 2.0f)];
    [bezierPath addLineToPoint:CGPointMake(Xlength,Ylength / 2.0f )];
    
    shapeLayer1 = [CAShapeLayer layer];
    shapeLayer1.lineWidth = 0.1;
    shapeLayer1.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer1.fillColor = [UIColor clearColor].CGColor;
    shapeLayer1.path = bezierPath.CGPath;
    [self.layer addSublayer:shapeLayer1];
    
    
}
- (void)chageLabel:(NSInteger)total{
    
    CGFloat unit = total / 10.0f;
    for (int i = 0 ; i < 9; i++) {
        UILabel * label = (UILabel *)[self viewWithTag:10 + i];
        label.text = [NSString stringWithFormat:@"%.0lf", unit * (i + 1)];
    }
}
- (void)changeLableWithTime:(NSInteger)total{
    CGFloat unit = total / 10.0f;
    for (int i = 0 ; i < 9; i++) {
        UILabel * label = (UILabel *)[self viewWithTag:10 + i];
        label.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith:unit * (i + 1)]];
    }
}

- (void)changeLabelWithTimeLapseTime:(NSInteger)total andFPS:(NSInteger)fps{
    
    
    CGFloat unit = total / 10.0f;
    NSInteger intNumber = total / 10;
    CGFloat floatNumber = unit - intNumber;
    
    NSLog(@"unit = %lf", unit);
    NSLog(@"int = %ld", (long)intNumber);
    NSLog(@"f = %lf", floatNumber);
    
    
    for (int i = 0 ; i < 9; i++) {
        UILabel * label = (UILabel *)[self viewWithTag:10 + i];
        label.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimelapseTimeWith:unit * (i + 1) andFPS:fps]];
        NSLog(@"%f", unit * (i + 1));
              
    }
   
}
- (void)createSquare{
      CGFloat Xlength;
    Xlength =  self.frame.size.width;
      CGFloat Ylength;
    Ylength = self.frame.size.height;
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(Xlength, 0)];
    [bezierPath addLineToPoint:CGPointMake(Xlength, Ylength)];
    [bezierPath addLineToPoint:CGPointMake(0, Ylength)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineWidth = 2;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.path = bezierPath.CGPath;
    [self.layer addSublayer:shapeLayer];
    
}
- (NSString *)getDateString:(long long)seconds{
    
    NSString *str_hour = [NSString stringWithFormat:@"%02lld",(seconds)/3600];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02lld",(seconds%3600)/60];
    
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02lld",seconds%60];
    
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}


@end
