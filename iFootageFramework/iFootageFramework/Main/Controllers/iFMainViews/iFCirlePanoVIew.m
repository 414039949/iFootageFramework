//
//  iFCirlePanoVIew.m
//  iFootage
//
//  Created by 黄品源 on 2016/12/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFCirlePanoVIew.h"

static inline double DegreesToRadians(double angle) { return M_PI * angle / 180.0; }


@implementation iFCirlePanoVIew


@synthesize sliceView;
@synthesize cir;


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        cir = [[CirleSlide alloc]init];
        cir.startAngle = 90;
        cir.delegate = self;
        cir.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        cir.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        cir.backgroundColor = [UIColor clearColor];
        [self addSubview:cir];
        
        sliceView = [[sliceCirleView alloc]init];
        sliceView.totalNumber = 20;
        sliceView.currentNumber = 1;
        sliceView.frame = CGRectMake(0, 0, self.frame.size.width - 60, self.frame.size.width - 60);
        sliceView.startAngle = 90;
        sliceView.delegate = self;
        
        sliceView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        sliceView.layer.masksToBounds = YES;
        sliceView.layer.cornerRadius = (self.frame.size.width - 60) / 2.0f;
        sliceView.backgroundColor = [UIColor clearColor];
        [self addSubview:sliceView];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(delayMethodTimer:) userInfo:nil repeats:YES];
        _timer.fireDate = [NSDate distantFuture];
        _isStart = YES;
        
    }
    return self;
}
- (void)getProgressAngle:(CGFloat)angle{
    
    if (cir.isTouch) {
        
    }else{
        
        [_delegate getStartAngle:cir.progress EndAngle:sliceView.progress + cir.progress ];
    }
}
- (void)changeDirectionWithProgressAngle:(CGFloat)angle{
    
    sliceView.transform = CGAffineTransformMakeRotation(DegreesToRadians(angle));
    
    if (cir.isTouch) {
        if (_isStart) {
            _timer.fireDate = [NSDate distantPast];
            _isStart = NO;
        }
    }
}
- (void)delayMethodTimer:(NSTimer *)timer{
    
    [_delegate getStartAngle:cir.progress EndAngle:sliceView.progress + cir.progress];
}
- (void)endClickDelegate{
    _timer.fireDate = [NSDate distantFuture];
    _isStart = YES;
}
@end
