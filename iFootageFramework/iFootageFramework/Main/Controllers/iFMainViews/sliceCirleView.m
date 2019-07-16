//
//  sliceCirleView.m
//  FinalCirleView
//
//  Created by 黄品源 on 2016/12/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "sliceCirleView.h"
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


@interface sliceCirleView ()

@property (assign, nonatomic)CGPoint handcenterPoint;
@property (assign, nonatomic)CGPoint location;


@end


@implementation sliceCirleView

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
        _startAngle = 0.f;
        _lineWidth = 20.f;
        _progress = 0.0f;
        _totalNumber = 10;
        _currentNumber = 2;
        _handleOutSideRadius = 5.f;
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
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    _location = [touch locationInView:self];
    
    //    NSLog(@"%d", [self pointInsideHandle:_location]);
    if ([self pointInsideHandle:_location] == YES) {
        [self drawWithLocation:_location];
    }
    return YES;
}

- (void)setLightSliceNumber:(NSUInteger)lightSliceNumber{
    _lightSliceNumber = lightSliceNumber;
    [self setNeedsDisplay];
//    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
- (void)drawSlices:(NSUInteger)slicesCount completed:(NSUInteger)slicesCompleted radius:(CGFloat)circleRadius center:(CGPoint)center inContext:(CGContextRef)context{
    
//    NSLog(@"slice = %lu", slicesCompleted);
    
        float sliceValue = 1.0f / slicesCount;
        for (int i = 0 ; i < slicesCount; i++) {
            
            CGFloat startValue = sliceValue * i;
            CGFloat startAngle =  startValue * 2 * M_PI + M_PI_2;
            
            CGFloat endValue = sliceValue * (i + 1);
            CGFloat endAngle = endValue * 2 * M_PI + M_PI_2;
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, endAngle, 0);
            
            CGColorRef color = [UIColor whiteColor].CGColor;
            
            if (slicesCompleted > i) {
                color = COLOR(66, 66, 66, 1).CGColor;
            }else{
                if (i >= (slicesCount - _lightSliceNumber) && i < slicesCount) {
                    color = [UIColor redColor].CGColor;
                }else{
                color = [UIColor whiteColor].CGColor;
                }
            }
            
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
        }
    int sliceCount = (int)slicesCount;
    float sliceAngle = (2 * M_PI) / sliceCount;
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGFloat radius = CGRectGetMidX(self.bounds);

    for (int i = 0; i < sliceCount; i++) {
        
        double startAngle = sliceAngle * i + M_PI_2;
        double endAngle = sliceAngle * (i + 1) + M_PI_2;
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, center.x, center.y);
        CGContextAddArc(context, center.x, center.y, radius - self.lineWidth, startAngle, endAngle, 0);
        CGContextAddArc(context, center.x, center.y, radius, endAngle, startAngle, 1);
        CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
        CGContextStrokePath(context);
    }
    
    CGContextSetRGBFillColor (context,  66 / 255.f ,66 / 255.f, 66 / 255.f, 1.0);//设置填充颜色
    //填充圆，无边框
    CGContextAddArc(context, center.x, center.y, radius - self.lineWidth, 0, 2* M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
}


- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);//改变画布的位置  颠倒
    CGContextSetLineWidth(context, self.lineWidth);
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = CGRectGetMidX(self.bounds) - self.lineWidth / 2;
    CGFloat arcStartAngle = DegreesToRadians(self.startAngle + 360.0);
    CGFloat progressAngle = DegreesToRadians(360.f) * self.progress;
    
    CGFloat sliceAngle = 360.0f / self.totalNumber;
    self.currentNumber = ceil(RadiansToDegrees(progressAngle) / sliceAngle);
    NSUInteger realNumber = self.totalNumber - self.currentNumber;
    
    [self drawSlices:self.totalNumber completed:realNumber radius:radius + self.lineWidth + self.handleOutSideRadius center:center inContext:context];
    
//    NSLog(@" 2 = %lf", progressAngle);
    [[UIColor clearColor ] set];
    CGContextSetLineWidth(context, self.handleOutSideRadius * 2);
    CGPoint handle = CGPointCenterRadiusAngle(center, radius , arcStartAngle - progressAngle);
    CGContextAddArc(context, handle.x, handle.y, self.handleOutSideRadius, 0, DegreesToRadians(360.f), 1);
    UIImage * image = [UIImage imageNamed:@"littleCamera"];
    CGContextDrawImage(context, CGRectMake(handle.x - 10, handle.y - 10 , 20, 20), image.CGImage);
    
    _handcenterPoint = handle;
    CGContextStrokePath(context);
//    NSLog(@"g = %lf", progressAngle);
    
    [_delegate getProgressAngle:(RadiansToDegrees(progressAngle))];
}

@end
