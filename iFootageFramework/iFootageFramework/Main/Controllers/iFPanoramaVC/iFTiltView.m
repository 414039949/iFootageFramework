//
//  iFTiltView.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/10.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFTiltView.h"

@implementation iFTiltView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    UIView * centerView;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(4), frame.size.height)];
        label.backgroundColor = [UIColor whiteColor];
        
        label.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        
        [self addSubview:label];
        
        centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iFSize(30), iFSize(30))];
        centerView.layer.cornerRadius = iFSize(15);
        
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        
        [self addSubview:centerView];
        
        
        UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lalalala:)];
        [centerView addGestureRecognizer:panGes];
        

        
        _sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.04f target:self selector:@selector(changeTiltValue) userInfo:nil repeats:YES];
        _sendTimer.fireDate = [NSDate distantFuture];
        
        
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height + centerView.frame.size.height * 0.5, self.frame.size.width, self.frame.size.height * 0.2)];
        titleLabel.font = [UIFont systemFontOfSize:self.frame.size.height * 0.1];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Tilt";
        titleLabel.textColor = [UIColor grayColor];
        [self addSubview:titleLabel];
        
    }
    return self;
    
}
- (void)changeTiltValue{
    NSLog(@"self.value = %lf", self.value);
    
    
    [_delegate changeTiltVolocAction:self.value];
    
}

- (void)lalalala:(UIPanGestureRecognizer *)pan{
    CGPoint po = [pan translationInView:self];
    
    
    static CGPoint center;

    if (pan.state == UIGestureRecognizerStateBegan) {
        center = pan.view.center;
        NSLog(@"开始");
        
        _sendTimer.fireDate = [NSDate distantPast];
        
        
    }
    
//    NSLog(@"%@", NSStringFromCGPoint(pan.view.center));
    if (center.y+po.y <= 0) {
        pan.view.center = CGPointMake(center.x, 0);
    }else if (center.y+po.y >= self.frame.size.height){
        pan.view.center = CGPointMake(center.x, self.frame.size.height);
    }else{
        pan.view.center = CGPointMake(center.x, center.y+po.y);
    }
    
    self.value = pan.view.center.y / (self.frame.size.height / 2.0f) - 1.0f;
        
    if (pan.state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束");
        self.value = 0.0f;

        centerView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        NSLog(@"%@", NSStringFromCGPoint(centerView.center));
        //        pan.view.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        
        [self performSelector:@selector(delayTimer) withObject:nil afterDelay:0.1f];

    }
}

- (void)delayTimer{
    _sendTimer.fireDate = [NSDate distantFuture];

}
@end
