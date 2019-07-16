//
//  iFootageRocker.m
//  手势测试
//
//  Created by 黄品源 on 2017/10/26.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFootageRocker.h"
#define RADIUS ([self bounds].size.width / 2)
#define RULELength (sqrt(2) / 2)

#define BGIMG @"analogue_bg"
#define CENIMG @"analogue_handle"

@implementation iFootageRocker
{
    BOOL isreStart;
    
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
//        UIPanGestureRecognizer * centerPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(createPanGesture:)];
        
        self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
        self.timer.fireDate=[NSDate distantFuture];
        
        _start=NO;
        _isRunning = NO;
        isreStart = YES;
        
        
        self.backGroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backGroundView.image = [UIImage imageNamed:BGIMG];
        self.backGroundView.backgroundColor = [UIColor clearColor];
        self.backGroundView.layer.cornerRadius = frame.size.width * 0.5f;
        self.backGroundView.userInteractionEnabled = YES;
        
        [self addSubview:self.backGroundView];
        
        self.centerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width * 0.5f, frame.size.height * 0.5f)];
        self.centerView.image = [UIImage imageNamed:CENIMG];
        self.centerView.center = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
        self.centerView.layer.cornerRadius = frame.size.width * 0.5 * 0.5;
        self.centerView.backgroundColor = [UIColor clearColor];
        self.centerView.userInteractionEnabled = YES;
        
        [self addSubview:self.centerView];
    }
    return self;
}

- (void)dellocRcoker{
    isreStart = NO;
    
}
- (void)reStartRocker{
    
    isreStart = YES;
}
- (void)delayMethod{
    
//    NSLog(@"在跑");
    if (isreStart) {
    if ([self.delegate respondsToSelector:@selector(analogueStickDidChangeValue:)])
    {
        [self.delegate analogueStickDidChangeValue:self];
    }
    }
    
}
//重置位置
- (void)reset
{
    self.center = CGPointMake(self.superview.frame.size.width / 2, self.superview.frame.size.height / 2);
    self.centerView.center = CGPointMake(self.frame.size.width * 0.5f, self.frame.size.height * 0.5f);
}

- (void)touchesBegan{
    self.timer.fireDate=[NSDate distantPast];
    _isRunning = YES;
}
- (void)touchesEnded{
    _xValue = 0.0f;
    _yValue = 0.0f;
    _isRunning = NO;
    [self performSelector:@selector(delayTimer) withObject:nil afterDelay:0.1f];


}
- (void)touchesCancelled{
    _isRunning = NO;
    _xValue = 0.0f;
    _yValue = 0.0f;
    [self performSelector:@selector(delayTimer) withObject:nil afterDelay:0.1f];

}
- (void)delayTimer{
    
    self.start = NO;
    self.timer.fireDate=[NSDate distantFuture];
}

//根据在最外层视图的位置，计算自己在当前父视图的位置
- (void)autoPoint:(CGPoint)point
{
    CGFloat x, y;
    x = self.frame.size.width * 0.5f + point.x - self.center.x;
    y = self.frame.size.height * 0.5f + point.y - self.center.y;
    
    CGFloat centerX = self.frame.size.width * 0.5f;
    CGFloat centerY = self.frame.size.height * 0.5f;
    CGFloat RealRadius = sqrt(pow((x - centerX), 2) + pow((y - centerY), 2));
    
    CGFloat normalisedX = (x / RADIUS) - 1;
    CGFloat normalisedY = ((y / RADIUS) - 1) * -1;
//
    if (normalisedX > 1.0)
    {
        x = [self bounds].size.width;
        normalisedX = 1.0;
    }
    else if (normalisedX < -1.0)
    {
        x = 0.0;
        normalisedX = -1.0;
    }
//
    if (normalisedY > 1.0)
    {
        y = 0.0;
        normalisedY = 1.0;
    }
    else if (normalisedY < -1.0)
    {
        y = [self bounds].size.height;
        normalisedY = -1.0;
    }
//
//    if (self.invertedYAxis)
//    {
//        normalisedY *= -1;
//    }
    
    if (RealRadius >= self.frame.size.width * 0.5f) {
//        NSLog(@"大于");
        
        CGFloat temp = centerX / centerY;
        CGFloat X = x - centerX;
        CGFloat Y = y - centerY;
        CGFloat total = sqrt(X*X + Y*Y);
        CGFloat small = total - self.frame.size.width * 0.5f;
        CGFloat smallY = sqrt(small * small / (temp * temp + 1));
        CGFloat smallX = smallY * temp;
    
        if (x > centerX && y > centerY) {//第一象限
            self.centerView.center = CGPointMake(x - smallX, y - smallY);
//            NSLog(@"第一象限");
        }else if (x > centerX && y < centerY){//第二象限
            self.centerView.center = CGPointMake(x - smallX, y + smallY);
//            NSLog(@"第二象限");
            
        }else if (x < centerX && y > centerY){//第三象限
            self.centerView.center = CGPointMake(x + smallX, y - smallY);
//            NSLog(@"第三象限");
            
            
        }else if (x < centerX && y < centerY){//第四象限

            self.centerView.center = CGPointMake(x +smallX, y + smallY);
            
//            NSLog(@"第四象限");
        }
    
    }else{
        
        self.centerView.center = CGPointMake(self.frame.size.width * 0.5f + point.x - self.center.x, self.frame.size.height * 0.5f + point.y - self.center.y);
    }
//    NSLog(@"X = %f", normalisedX);
//    NSLog(@"Y = %f", normalisedY);
    _xValue = normalisedX;
    _yValue = normalisedY;
    
    if (_xValue > 0.999) {
        _xValue = 1.0000;
    }
    if (_xValue < -0.9999) {
        _xValue = -1.0000;
    }
    if (_yValue > 0.999) {
        _yValue = 1.0000;
    }
    if (_yValue < -0.999) {
        _yValue = -1.0000;
    }
    
    
}

@end
