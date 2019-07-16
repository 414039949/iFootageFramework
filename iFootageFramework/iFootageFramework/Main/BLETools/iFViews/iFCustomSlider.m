//
//  iFCustomSlider.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/19.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFCustomSlider.h"

@implementation iFCustomSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame :(UIColor *)cscolor :(CGFloat)total{
#warning slide  pan  tilt 加手势微调 （细节）！！！！预留
    self = [super initWithFrame:frame];
    if (self) {
        self.color = cscolor;
        self.totalValue = total;
        [self createUI:cscolor];
        
    }
    return self;
}
- (void)createUI:(UIColor *)cscolor{
    
    self.uplabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(40), iFSize(20))];
    self.uplabel.center = CGPointMake(iFSize(10), -iFSize(10));
    self.uplabel.backgroundColor = [UIColor clearColor];
    self.uplabel.font = [UIFont systemFontOfSize:iFSize(10)];
    self.uplabel.textColor = [UIColor whiteColor];
    self.uplabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.uplabel];
    
    
    self.downlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(40), iFSize(20))];
    self.downlabel.center = CGPointMake(iFSize(10), self.frame.size.height + iFSize(10));
    self.downlabel.backgroundColor = [UIColor clearColor];
    self.downlabel.font = [UIFont systemFontOfSize:iFSize(10)];
    self.downlabel.textColor = [UIColor whiteColor];
    self.downlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.downlabel];
    
    
    UIBezierPath * mpath = [UIBezierPath bezierPath];
    [mpath moveToPoint:CGPointMake(iFSize(10), iFSize(10))];
    [mpath addLineToPoint:CGPointMake(iFSize(10), self.frame.size.height -iFSize(10))];
    
    CAShapeLayer * shaper = [CAShapeLayer layer];
    shaper.strokeColor = [UIColor grayColor].CGColor;
    shaper.lineWidth = 2;
    shaper.path = mpath.CGPath;
    [self.layer addSublayer:shaper];
    
    self.upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iFSize(20), iFSize(20))];
    self.upView.center = CGPointMake(iFSize(10), iFSize(10));
    self.upView.backgroundColor = cscolor;
    self.upView.layer.cornerRadius = iFSize(10);
    
    UIPanGestureRecognizer *recognizer1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveupView:)];
    [self.upView addGestureRecognizer:recognizer1];
    recognizer1.delegate = self;
    
    [self addSubview:self.upView];
    
    self.downView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iFSize(20), iFSize(20))];
    self.downView.center = CGPointMake(iFSize(10), self.frame.size.height - iFSize(10));
    self.downView.backgroundColor = cscolor;
    self.downView.layer.cornerRadius = iFSize(10);
    UIPanGestureRecognizer *recognizer2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movedownView:)];
    [self.downView addGestureRecognizer:recognizer2];
    recognizer2.delegate = self;
    [self addSubview:self.downView];
    
    self.actPath = [UIBezierPath bezierPath];
    [self.actPath moveToPoint:CGPointMake(self.upView.center.x, self.upView.center.y)];
    [self.actPath addLineToPoint:CGPointMake(self.upView.center.x, self.downView.center.y)];
    
    self.actLayer = [CAShapeLayer layer];
    self.actLayer.strokeColor = cscolor.CGColor;
    self.actLayer.lineWidth = iFSize(2);
    self.actLayer.path = self.actPath.CGPath;
    [self.layer addSublayer:self.actLayer];
    
    NSLog(@"totalValue===================================");
    if ((self.totalValue == (PanMaxValue * 2) || self.totalValue == (TiltMaxValue * 2)) == YES) {
//        NSLog(@"totalValue%f", self.totalValue);
        
        self.downlabel.text = [NSString stringWithFormat:@"%.0f",(1 -  (((self.downView.center.y - iFSize(10.0f))) / (self.frame.size.height  - iFSize(20.0f)))) * self.totalValue - (self.totalValue / 2)];
        self.uplabel.text = [NSString stringWithFormat:@"%.0f", (1- (((self.upView.center.y - iFSize(10)) / (self.frame.size.height  - iFSize(20.0f))))) * self.totalValue - (self.totalValue / 2)];
        
    }else{
//        NSLog(@"totalValue%f", self.totalValue);

    self.downlabel.text = [NSString stringWithFormat:@"%.0f", self.totalValue -  (((self.downView.center.y - iFSize(10.0f))) / (self.frame.size.height  - iFSize(20.0f)) * self.totalValue)];
    self.uplabel.text = [NSString stringWithFormat:@"%.0f", self.totalValue - (((self.upView.center.y - iFSize(10)) / (self.frame.size.height  - iFSize(20.0f))) * self.totalValue)];
    }
}
- (void)movedownView:(UIPanGestureRecognizer *)pan{
    
    [self.actLayer removeFromSuperlayer];

    CGPoint po = [pan translationInView:self];
    static CGPoint center;
    if (pan.state == UIGestureRecognizerStateBegan) {
        center = pan.view.center;
    }
    pan.view.center = CGPointMake(center.x, center.y+po.y);
    
    if (pan.view.center.y > self.frame.size.height - iFSize(10)) {
        pan.view.center = CGPointMake(center.x, self.frame.size.height - iFSize(10));
    }else{
        if (pan.view.center.y - self.upView.center.y < iFSize(20)) {
            pan.view.center = CGPointMake(center.x, self.upView.center.y + iFSize(20));
        }
    }
    self.actPath = [UIBezierPath bezierPath];
    [self.actPath moveToPoint:CGPointMake(self.upView.center.x, self.upView.center.y)];
    [self.actPath addLineToPoint:CGPointMake(self.upView.center.x, self.downView.center.y)];
    
    self.actLayer = [CAShapeLayer layer];
    self.actLayer.strokeColor = self.color.CGColor;
    self.actLayer.lineWidth = iFSize(2);
    self.actLayer.path = self.actPath.CGPath;
    [self.layer addSublayer:self.actLayer];
    
    if ((self.totalValue == (PanMaxValue * 2) || self.totalValue == (TiltMaxValue * 2)) == YES) {
        self.downlabel.text = [NSString stringWithFormat:@"%.0f",(1 -  (((pan.view.center.y - iFSize(10.0f)) / (self.frame.size.height  - iFSize(20.0f))))) * self.totalValue - (self.totalValue / 2)];

    }else{
    
    self.downlabel.text = [NSString stringWithFormat:@"%.0f",self.totalValue -  (((pan.view.center.y - iFSize(10.0f)) / (self.frame.size.height  - iFSize(20.0f))) * self.totalValue)];
    }
//    NSLog(@"%@", [NSString stringWithFormat:@"%.0f", ((pan.view.center.y - iFSize(10.0f)) / (self.frame.size.height - iFSize(10.0f))) * self.totalValue]);
    CGFloat a = (self.downView.center.y - self.upView.center.y) / (self.frame.size.height - iFSize(20));
    [_changeDelegate changeDistanceValue:a];
    
    
}
- (void)moveupView:(UIPanGestureRecognizer *)pan{
    [self.actLayer removeFromSuperlayer];

//    NSLog(@"%@", self);
    CGPoint po = [pan translationInView:self];
    static CGPoint center;
    if (pan.state == UIGestureRecognizerStateBegan) {
        center = pan.view.center;
    }
    
    pan.view.center = CGPointMake(center.x, center.y+po.y);
    
    if (pan.view.center.y < iFSize(10)) {
        pan.view.center = CGPointMake(center.x, iFSize(10));
    }else{
        if (self.downView.center.y - pan.view.center.y < iFSize(20)) {
            pan.view.center = CGPointMake(center.x, self.downView.center.y - iFSize(20));
        }
    }
    
    self.actPath = [UIBezierPath bezierPath];
    [self.actPath moveToPoint:CGPointMake(self.upView.center.x, self.upView.center.y)];
    [self.actPath addLineToPoint:CGPointMake(self.upView.center.x, self.downView.center.y)];
    
    self.actLayer = [CAShapeLayer layer];
    self.actLayer.strokeColor = self.color.CGColor;
    self.actLayer.lineWidth = iFSize(2);
    self.actLayer.path = self.actPath.CGPath;
    [self.layer addSublayer:self.actLayer];

    if ((self.totalValue == (PanMaxValue * 2) || self.totalValue == (TiltMaxValue * 2)) == YES) {
        self.uplabel.text = [NSString stringWithFormat:@"%.0f", (1-  (((pan.view.center.y - iFSize(10.0f)) / (self.frame.size.height  - iFSize(20.0f))))) * self.totalValue - (self.totalValue / 2)];
        
    }else{
        
        self.uplabel.text = [NSString stringWithFormat:@"%.0f", self.totalValue - (((pan.view.center.y - iFSize(10.0f)) / (self.frame.size.height  - iFSize(20.0f))) * self.totalValue)];
    }
    CGFloat a = (self.downView.center.y - self.upView.center.y) / (self.frame.size.height - iFSize(20));
    [_changeDelegate changeDistanceValue:a];
}
- (void)changeWithAllValue:(CGFloat)allValue andUpValue:(CGFloat)upValue andDownValue:(CGFloat)downValue WithModel:(NSInteger)model{
    
//    NSLog(@"mode = %lf", self.totalValue);
    
    
    [self.actLayer removeFromSuperlayer];
    CGFloat allLength = self.frame.size.height - iFSize(20);
    self.uplabel.text =   [NSString stringWithFormat:@"%.0f", upValue ];
    self.downlabel.text = [NSString stringWithFormat:@"%.0f", downValue];
    CGFloat uploction, downloction;
    if (model == 0) {
        uploction = (self.totalValue - upValue) / self.totalValue * allLength + iFSize(10);
        downloction = (self.totalValue - downValue) / self.totalValue * allLength + iFSize(10);
    }else{
        uploction = (self.totalValue / 2 - upValue) / self.totalValue * allLength + iFSize(10);
        downloction = (self.totalValue / 2 - downValue) / self.totalValue * allLength + iFSize(10);
    }

    
    self.upView.center = CGPointMake(iFSize(10), uploction);
    self.downView.center = CGPointMake(iFSize(10), downloction);
    
    self.actPath = [UIBezierPath bezierPath];
    [self.actPath moveToPoint:CGPointMake(self.upView.center.x, self.upView.center.y)];
    [self.actPath addLineToPoint:CGPointMake(self.upView.center.x, self.downView.center.y)];
    
    self.actLayer = [CAShapeLayer layer];
    self.actLayer.strokeColor = self.color.CGColor;
    self.actLayer.lineWidth = iFSize(2);
    self.actLayer.path = self.actPath.CGPath;
    [self.layer addSublayer:self.actLayer];
}


@end
