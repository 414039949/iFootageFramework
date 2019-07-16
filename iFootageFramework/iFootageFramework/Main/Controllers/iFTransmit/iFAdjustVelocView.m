//
//  iFAdjustVelocView.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/12.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFAdjustVelocView.h"
#import "iFgetAxisY.h"

#define PointValue(x, y) CGPointMake(x, y)
#define PointFloatValue(a) [NSValue valueWithCGPoint:(a)]

@implementation iFAdjustVelocView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

{
    float a, b;
    NSMutableArray * dataArray;
    NSMutableArray * dataArray1;
}
@synthesize curve, shapeLayer;


- (id)initWithFrame:(CGRect)frame WithColor:(UIColor *)color WithTitle:(NSString *)title{
    
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel * TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.3)];
        TitleLabel.center = CGPointMake(frame.size.width / 2.0f, -frame.size.height * 0.15f);
        TitleLabel.backgroundColor = [UIColor clearColor];
        TitleLabel.text = title;
        TitleLabel.textAlignment = NSTextAlignmentCenter;
        TitleLabel.textColor = color;
        
        
        [self addSubview:TitleLabel];
        
        
        
//        self.layer.borderWidth = 2;
//        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        UIImageView * backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.image = [UIImage imageNamed:manual_CURVEIMG];
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        dataArray = [NSMutableArray new];
        self.color = color;
//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, -10, 20, 20)];
//        label.backgroundColor = [UIColor redColor];
//        
//        [self addSubview:label];
        
        CGPoint A, B, C, D, center, controlPoint1, controlPoint2;
        
        a = frame.size.height * 0.75f;
        b = frame.size.height - a;
        
        
        A = PointValue(0, 0);
        B = PointValue(frame.size.width,0);
        C = PointValue(0, frame.size.height);
        D = PointValue(frame.size.width, frame.size.height);
        
        center = PointValue((frame.size.width - 0) / 2.0f, (frame.size.height - 0) / 2.0f);
        controlPoint1 = PointValue(b , b + frame.size.height / 2.0f);
        controlPoint2 = PointValue(a , a - frame.size.height / 2.0f);
        
        //        NSLog(@"%@, %@, %@, %@",NSStringFromCGPoint(A), NSStringFromCGPoint(B), NSStringFromCGPoint(C), NSStringFromCGPoint(D));
        //        dataArray = [NSMutableArray arrayWithObjects:<#(nonnull id), ...#>, nil];
        
        curve = [UIBezierPath bezierPath];
        [curve moveToPoint:C];
        [curve addCurveToPoint:center controlPoint1:controlPoint1 controlPoint2:controlPoint1];
        [curve addCurveToPoint:B controlPoint1:controlPoint2 controlPoint2:controlPoint2];
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = self.color.CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        
        shapeLayer.lineWidth = 2;
        shapeLayer.path = curve.CGPath;
        shapeLayer.lineCap = kCALineCapSquare;
        [self.layer addSublayer:shapeLayer];
        
        
        UIPanGestureRecognizer * swipe = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lalala1:)];
        [self addGestureRecognizer:swipe];
        

        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lalalala:)];
        tap.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
- (void)initCurveWithaValue:(CGFloat)aValue{
    
    CGRect frame = self.frame;
    
    a = frame.size.height * aValue;
    b = frame.size.height - a;
    
    [shapeLayer removeFromSuperlayer];
    
    CGPoint A, B, C, D, center, controlPoint1, controlPoint2;
    
    A = PointValue(0, 0);
    B = PointValue(frame.size.width,0);
    C = PointValue(0, frame.size.height);
    D = PointValue(frame.size.width, frame.size.height);
    center = PointValue((frame.size.width - 0) / 2.0f, (frame.size.height - 0) / 2.0f);
    controlPoint1 = PointValue(b , b + frame.size.height / 2.0f);
    controlPoint2 = PointValue(a , a - frame.size.height / 2.0f);
    //    NSLog(@"%@, %@, %@, %@",NSStringFromCGPoint(A), NSStringFromCGPoint(B), NSStringFromCGPoint(C), NSStringFromCGPoint(D));
    dataArray = [NSMutableArray arrayWithObjects:PointFloatValue(C),PointFloatValue(center), PointFloatValue(B), nil];
    dataArray1 = [NSMutableArray arrayWithObjects:@[PointFloatValue(controlPoint1), PointFloatValue(controlPoint1)] , @[PointFloatValue(controlPoint2), PointFloatValue(controlPoint2)] , nil];
    
    //    NSLog(@"%@", dataArray);
    curve = [UIBezierPath bezierPath];
    [curve moveToPoint:C];
    [curve addCurveToPoint:center controlPoint1:controlPoint1 controlPoint2:controlPoint1];
    [curve addCurveToPoint:B controlPoint1:controlPoint2 controlPoint2:controlPoint2];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = self.color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = 2;
    shapeLayer.path = curve.CGPath;
    shapeLayer.lineCap = kCALineCapSquare;
    [self.layer addSublayer:shapeLayer];
    
    
    [self CountSomeThingsAndPointX:a];
    
    self.initValue = a / self.frame.size.height;
    
    [_delegate AdjustVelocCurveWithpercentValue:self.initValue andView:self];
    


}

- (void)lalalala:(UITapGestureRecognizer *)tap{
    
    CGRect frame = self.frame;
    
    a = frame.size.height * 0.75f;
    b = frame.size.height - a;
    
    [shapeLayer removeFromSuperlayer];
    
    CGPoint A, B, C, D, center, controlPoint1, controlPoint2;
    
    A = PointValue(0, 0);
    B = PointValue(frame.size.width,0);
    C = PointValue(0, frame.size.height);
    D = PointValue(frame.size.width, frame.size.height);
    center = PointValue((frame.size.width - 0) / 2.0f, (frame.size.height - 0) / 2.0f);
    controlPoint1 = PointValue(b , b + frame.size.height / 2.0f);
    controlPoint2 = PointValue(a , a - frame.size.height / 2.0f);
    //    NSLog(@"%@, %@, %@, %@",NSStringFromCGPoint(A), NSStringFromCGPoint(B), NSStringFromCGPoint(C), NSStringFromCGPoint(D));
    dataArray = [NSMutableArray arrayWithObjects:PointFloatValue(C),PointFloatValue(center), PointFloatValue(B), nil];
    dataArray1 = [NSMutableArray arrayWithObjects:@[PointFloatValue(controlPoint1), PointFloatValue(controlPoint1)] , @[PointFloatValue(controlPoint2), PointFloatValue(controlPoint2)] , nil];
    
    //    NSLog(@"%@", dataArray);
    curve = [UIBezierPath bezierPath];
    [curve moveToPoint:C];
    [curve addCurveToPoint:center controlPoint1:controlPoint1 controlPoint2:controlPoint1];
    [curve addCurveToPoint:B controlPoint1:controlPoint2 controlPoint2:controlPoint2];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = self.color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = 2;
    shapeLayer.path = curve.CGPath;
    shapeLayer.lineCap = kCALineCapSquare;
    [self.layer addSublayer:shapeLayer];
    
    
    [self CountSomeThingsAndPointX:a];
    

    self.initValue = a / self.frame.size.height;
    
    [_delegate AdjustVelocCurveWithpercentValue:self.initValue andView:self];
    
    NSLog(@"%lf", self.initValue);
}
- (void)lalala1:(UIPanGestureRecognizer *)pan{
    
    CGPoint po = [pan translationInView:self];
    
    CGRect frame = self.frame;
    
    //    NSLog(@"%@", NSStringFromCGPoint(po));
    
    if (po.x > 0) {
        a = a + 0.5;
        
        if (a >=  frame.size.height * 0.9) {
            a = frame.size.height * 0.9;
        }else if (a <= frame.size.height * 0.6){
            a = frame.size.height * 0.6;
        }
        
        b = frame.size.height - a;
    }else{
        a = a - 0.5;
        if (a >=  frame.size.height * 0.9) {
            a = frame.size.height * 0.9;
        }else if (a <= frame.size.height * 0.6){
            a = frame.size.height * 0.6;
        }
        
        
        b = frame.size.height - a;
    }
    //    NSLog(@"a = %f b = %f", a, b);
    
    
    [shapeLayer removeFromSuperlayer];
    
    CGPoint A, B, C, D, center, controlPoint1, controlPoint2;
    
    A = PointValue(0, 0);
    B = PointValue(frame.size.width,0);
    C = PointValue(0, frame.size.height);
    D = PointValue(frame.size.width, frame.size.height);
    center = PointValue((frame.size.width - 0) / 2.0f, (frame.size.height - 0) / 2.0f);
    controlPoint1 = PointValue(b , b + frame.size.height / 2.0f);
    controlPoint2 = PointValue(a , a - frame.size.height / 2.0f);
    //    NSLog(@"%@, %@, %@, %@",NSStringFromCGPoint(A), NSStringFromCGPoint(B), NSStringFromCGPoint(C), NSStringFromCGPoint(D));
    dataArray = [NSMutableArray arrayWithObjects:PointFloatValue(C),PointFloatValue(center), PointFloatValue(B), nil];
    dataArray1 = [NSMutableArray arrayWithObjects:@[PointFloatValue(controlPoint1), PointFloatValue(controlPoint1)] , @[PointFloatValue(controlPoint2), PointFloatValue(controlPoint2)] , nil];
    
    //    NSLog(@"%@", dataArray);
    curve = [UIBezierPath bezierPath];
    [curve moveToPoint:C];
    [curve addCurveToPoint:center controlPoint1:controlPoint1 controlPoint2:controlPoint1];
    [curve addCurveToPoint:B controlPoint1:controlPoint2 controlPoint2:controlPoint2];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = self.color.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    shapeLayer.lineWidth = 2;
    shapeLayer.path = curve.CGPath;
    shapeLayer.lineCap = kCALineCapSquare;
    [self.layer addSublayer:shapeLayer];
    
    
    [self CountSomeThingsAndPointX:a];
    
    
//    NSLog(@"%lf", a);
    
    self.initValue = a / self.frame.size.height;
    

    [_delegate AdjustVelocCurveWithpercentValue:self.initValue andView:self];
    
    NSLog(@"%lf", self.initValue);
    
    
}

- (CGFloat)CountSomeThingsAndPointX:(CGFloat)X{
    
    CGFloat aaa, realValue;
    realValue = (X + 1.0f) * self.frame.size.height / 2.0f;
    
    NSArray * array = [self getNewArrayWithPointArray:dataArray andControlArray:dataArray1];
    
    float SlidePos[31] = {0.0};
    float SlideT[31] = {0.0};
    
    for (int i = 0 ; i < 2; i++) {
        for (int j = 0 ; j < [array[i] count]; j++) {
            if (i == 0) {
                SlideT[j] = [array[i][j] floatValue];
                
            }else if (i == 1){
                SlidePos[j] =  [array[i][j] floatValue];
            }
        }
    }
    
    aaa = ((self.frame.size.height - GETAXIS_Trace_Calculate(realValue, SlidePos, SlideT)) - (self.frame.size.height / 2.0f)) / self.frame.size.height * 2.0f;
    
    return aaa;
}

- (NSArray *)getNewArrayWithPointArray:(NSArray *)pointArray andControlArray:(NSArray *)controlArray{
    NSMutableArray * array = [NSMutableArray new];
    NSMutableArray * totalArray = [NSMutableArray new];
    
    NSMutableArray * array1 = [NSMutableArray new];
    NSMutableArray * array2 = [NSMutableArray new];
    
    if (!pointArray.count) {
        
    }else{
        
        for (int i = 0 ; i < pointArray.count; i++) {
            [array addObject:pointArray[i]];
            if (i < pointArray.count - 1) {
                [array addObject:controlArray[i][0]];
                [array addObject:controlArray[i][1]];
            }
        }
    }
    
    for ( NSValue * point in array) {
        CGPoint p = point.CGPointValue;
        
        [array1 addObject:[NSNumber numberWithFloat:p.x]];
        [array2 addObject:[NSNumber numberWithFloat:p.y]];
    }
    [totalArray addObject:array1];
    [totalArray addObject:array2];
    
    return totalArray;
}

@end
