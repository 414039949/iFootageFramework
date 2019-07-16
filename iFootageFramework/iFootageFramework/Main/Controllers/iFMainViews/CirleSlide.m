//
//  CirleSlide.m
//  FinalCirleView
//
//  Created by 黄品源 on 2016/12/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "CirleSlide.h"


/**
 角度转弧度

 @param angle angle description
 @return return value description
 */
static inline double DegreesToRadians(double angle) { return M_PI * angle / 180.0; }

/**
 弧度转角度

 @param angle angle description
 @return return value description
 */
static inline double RadiansToDegrees(double angle) { return angle * 180.0 / M_PI; }


/**
 求圆上的点

 @param c c 圆心坐标
 @param r r 半径
 @param a a 圆心角（弧度）
 @return return value 返回圆上的点
 */
static inline CGPoint CGPointCenterRadiusAngle(CGPoint c, double r, double a) {
    return CGPointMake(c.x + r * cos(a), c.y + r * sin(a));
}


/**
 求夹角（圆心角）

 @param a a A点
 @param b b B点
 @param c c 圆心
 @return return value 返回∠A0B
 
 */
static inline CGFloat AngleBetweenPoints(CGPoint a, CGPoint b, CGPoint c) {
    return atan2(a.y - c.y, a.x - c.x) - atan2(b.y - c.y, b.x - c.x);
}

@interface CirleSlide ()

@property (assign, nonatomic)CGPoint handcenterPoint;
@property (assign, nonatomic)CGPoint location;


@end

@implementation CirleSlide

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        _startAngle = 0.f;
        _lineWidth = 20.f;
        _progress = 0.0f;
        _handleOutSideRadius = 5.f;
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        
        _cameraImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"camera"]];
        _cameraImageView.frame = CGRectMake(0, 0, 30, 30);
//        [self addSubview:_cameraImageView];
        
        
        
        
        _isTouch = NO;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder: aDecoder];
    return self;
}

/**
 检测触摸点是否在slider所在圆圈范围内

 @param point 触摸点
 @return return value YES or NO
 */
- (BOOL)pointInsideHandle:(CGPoint)point{
    CGPoint handleCenter = CGPointMake(_handcenterPoint.x, self.bounds.size.width - _handcenterPoint.y);
    CGFloat handleRadius = _handleOutSideRadius + 30;
    CGRect handleRect = CGRectMake(handleCenter.x - handleRadius, handleCenter.y - handleRadius, handleRadius * 2, handleRadius * 2);
    return CGRectContainsPoint(handleRect, point);
}
- (void)drawWithLocation:(CGPoint)location{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2;
    
    CGFloat startAngle = _startAngle;
    if (startAngle < 0) {
        startAngle = fabs(startAngle);
    }else{
        startAngle = 360.0f - startAngle;
    }
    CGPoint startPoint = CGPointCenterRadiusAngle(center, radius, DegreesToRadians(startAngle));
    
    CGFloat angle = RadiansToDegrees(AngleBetweenPoints(location, startPoint, center));
    if (angle < 0)angle+= 360.f;
    
    self.progress = angle / 360.f;
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"开始");
    self.isTouch = YES;
    
    return YES;
    
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    _location = [touch locationInView:self];
    
//    NSLog(@"%d", [self pointInsideHandle:_location]);
    if ([self pointInsideHandle:_location] == YES) {
        [self drawWithLocation:_location];
        
    }
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"结束了");
    self.isTouch = NO;
    [_delegate endClickDelegate];
}

- (void)setStartAngle:(CGFloat)startAngle{
    _startAngle = startAngle;
    [self setNeedsDisplay];
}
- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}
- (void)setProgress:(CGFloat)progress{
    if (progress > 0.999)
        _progress = 0.999;
    else if(progress < 0)
        _progress = 0;
    else
        _progress = progress;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);//改变画布的位置  颠倒
    CGContextSetLineWidth(context, self.lineWidth);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2 - self.handleOutSideRadius * 2;
    CGFloat arcStartAngle = DegreesToRadians(self.startAngle + 360.0);
//    CGFloat arcEndAngle = DegreesToRadians(self.startAngle);
    CGFloat progressAngle = DegreesToRadians(360.f) * self.progress;
//    
//    [[UIColor whiteColor] set];
//    CGContextAddArc(context, center.x, center.y, radius, arcStartAngle, arcStartAngle - progressAngle, 1);
//    CGContextStrokePath(context);
    [[UIColor clearColor ] set];
    CGContextSetLineWidth(context, self.handleOutSideRadius * 2);
    CGPoint handle = CGPointCenterRadiusAngle(center, radius, arcStartAngle - progressAngle);
    CGContextAddArc(context, handle.x, handle.y, self.handleOutSideRadius, 0, DegreesToRadians(360.f), 1);
    UIImage * image = [UIImage imageNamed:setting_SLIDE_BTNIMG];
    
    _handcenterPoint = handle;
    CGContextDrawImage(context, CGRectMake(handle.x - 10 , handle.y - 10, 20, 20), image.CGImage);
    
//    _cameraImageView.center = CGPointMake(_handcenterPoint.x, _handcenterPoint.y - self.frame.origin.y);
    
    NSLog(@"A = %@", NSStringFromCGPoint(_cameraImageView.center));
    NSLog(@"B = %@", NSStringFromCGPoint(_location));
    CGContextStrokePath(context);

//    NSLog(@"1 = %lf", RadiansToDegrees(progressAngle));
    
    [_delegate changeDirectionWithProgressAngle:RadiansToDegrees(progressAngle)];
    
}
























@end
