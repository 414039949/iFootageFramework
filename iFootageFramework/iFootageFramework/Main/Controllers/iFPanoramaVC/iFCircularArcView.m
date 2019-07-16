//
//  iFCircularArcView.m
//  circularContext
//
//  Created by 黄品源 on 2016/11/24.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFCircularArcView.h"

@implementation iFCircularArcView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self internalInit];
        
    }
    return self;
}
- (void)internalInit{
    self.completedColor = [UIColor grayColor];
    self.incompletedColor = [UIColor blackColor];
    self.sliceDividerColor = [UIColor whiteColor];
    self.thickness = 40;
    self.sliceDividerHidden = NO;
    self.sliceDividerThickness = 2;
    _startNumber = 0;
}

- (void)drawSlices:(NSUInteger)slicesCount completed:(NSUInteger)slicesCompleted radius:(CGFloat)circleRadius center:(CGPoint)center inContext:(CGContextRef)context{
//    if (!self.sliceDividerHidden) {
        float sliceValue = 1.0f / slicesCount;
        for (int i = 0 ; i < slicesCount; i++) {
            CGFloat startValue = sliceValue * (i + _startNumber);
            CGFloat startAngle = startValue * 2 * M_PI - M_PI_2;
            CGFloat endValue = sliceValue * (i + 1 + _startNumber);
            CGFloat endAngle = endValue * 2 * M_PI - M_PI_2;
            
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, circleRadius, startAngle, endAngle, 0);
            CGColorRef color = self.incompletedColor.CGColor;
            if (slicesCompleted - 1 >= i) {
                color = self.completedColor.CGColor;
            }
            CGContextSetFillColorWithColor(context, color);
            CGContextFillPath(context);
        }
//    }
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"点击了");
    return YES;
}
- (void)drawRect:(CGRect)rect{
    
    if (self.progressTotal <= 0) {
        return;
    }
    CGSize viewSize = self.bounds.size;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    CGFloat radius = viewSize.width / 2;
    [self drawSlices:self.progressTotal completed:self.progressCurrent radius:radius center:center inContext:contextRef];
    
    int outerDiameter = viewSize.width;
    int outerRadius = outerDiameter / 2;
    int innerDiameter = outerDiameter - self.thickness;
    float innerRadius = innerDiameter / 2.0f;
    
    if (! self.sliceDividerHidden) {
        int sliceCount = (int)self.progressTotal;
        float sliceAngle = (2 * M_PI) / sliceCount;
        CGContextSetLineWidth(contextRef, self.sliceDividerThickness);
        CGContextSetStrokeColorWithColor(contextRef, self.sliceDividerColor.CGColor);
        for (int i = 0; i < sliceCount; i++) {
            
            double startAngle = sliceAngle * i - M_PI_2;
            double endAngle = sliceAngle * (i + 1) - M_PI_2;
            CGContextBeginPath(contextRef);
            CGContextMoveToPoint(contextRef, center.x, center.y);
            CGContextAddArc(contextRef, center.x, center.y, outerRadius, startAngle, endAngle, 0);
            CGContextAddArc(contextRef, center.x, center.y, innerRadius, endAngle, startAngle, 1);
            CGContextSetStrokeColorWithColor(contextRef, self.sliceDividerColor.CGColor);
            
            
            
            CGContextStrokePath(contextRef);
        
        }
    }
    
    CGContextSetLineWidth(contextRef, self.thickness);
    CGContextSetFillColorWithColor(contextRef, self.backgroundColor.CGColor);
    CGRect circlePoint = CGRectMake(center.x - innerRadius, center.y - innerRadius, innerDiameter, innerDiameter);
    CGContextFillEllipseInRect(contextRef, circlePoint);
    
}

@end
