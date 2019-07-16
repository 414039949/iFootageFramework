//
//  iFSliderView.m
//  iFootage
//
//  Created by 黄品源 on 2018/2/2.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFSliderView.h"
#import "UIView+SUUFrameAdjust.h"

@implementation iFSliderView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        tapGesture.numberOfTapsRequired = 2;
        
        UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2:)];
        tapGesture2.numberOfTapsRequired = 2;
        
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        [self addGestureRecognizer:tapGesture2];
        
       
        
        
        self.tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.tapView.center = CGPointMake(0, self.frame.size.height / 2);
        self.tapView.backgroundColor = [UIColor clearColor];
//        [self.tapView addGestureRecognizer:tapGesture];
        [self.tapView addGestureRecognizer:panGesture];
        self.iSselected = NO;
        self.userInteractionEnabled = YES;
        self.layer.masksToBounds = NO;
        [self addSubview:self.tapView];
        
       self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
       self.imageView.image = [UIImage imageNamed:@"left_RightSlider"];
        [self.tapView addSubview:self.imageView];
    }
    return self;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"pointInside");
    //    if (.....){
    return YES;
    //    }
    //    return NO;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSLog(@"%@", NSStringFromCGPoint(self.tapView.center));
    self.iSselected = !self.iSselected;
    
    if (self.iSselected) {
        self.tapView.height = 40;
        self.tapView.width = 40;
        tap.view.center = CGPointMake(self.tapView.center.x - 10,self.tapView.center.y  - 10);
    }else{
        self.tapView.height = 20;
        self.tapView.width = 20;
        tap.view.center = CGPointMake(self.tapView.center.x + 10,self.tapView.center.y  + 10);
    }
    [_delegate getSlideValueAction:self.tapView.center.x / self.frame.size.width];
    
}
- (void)tapAction2:(UITapGestureRecognizer *)tap{
    
//    NSLog(@"%@", NSStringFromCGPoint(self.tapView.center));
    self.iSselected = !self.iSselected;
    
    if (self.iSselected) {
        self.tapView.height = 40;
        self.tapView.width = 40;
        self.tapView.center = CGPointMake(self.tapView.center.x - 10,self.tapView.center.y  - 10);
    }else{
        self.tapView.height = 20;
        self.tapView.width = 20;
        self.tapView.center = CGPointMake(self.tapView.center.x + 10,self.tapView.center.y  + 10);
    }
    [_delegate getSlideValueAction:self.tapView.center.x / self.frame.size.width];
    
}
- (void)panAction:(UIPanGestureRecognizer *)pan{
        NSLog(@"panAction");
    CGPoint po = [pan translationInView:self];
    static CGPoint center;
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        center = pan.view.center;
    }
    pan.view.center = CGPointMake(center.x + po.x, center.y);
    if (center.x + po.x <= 0) {
        pan.view.center = CGPointMake(0, center.y);
    }
    if (center.x + po.x >= self.frame.size.width) {
        pan.view.center = CGPointMake(self.frame.size.width, center.y);
    }
    self.slideValue = pan.view.center.x / self.frame.size.width;
    [_delegate getSlideValueAction:self.slideValue];
}


@end
