//
//  iFSlideProgressView.m
//  iFootage
//
//  Created by 黄品源 on 2017/7/27.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFSlideProgressView.h"
#import "iFLabel.h"
#import <Masonry/Masonry.h>

@implementation iFSlideProgressView

@synthesize leftlabel, rightlabel;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame withPercent:(NSInteger)percent withLeftValue:(NSInteger)leftvalue withRightValue:(NSInteger)rightvalue{
    
    if (self = [super initWithFrame:frame]) {
        self.maxvalue = rightvalue;
        self.minvalue = leftvalue;
        
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        img.image = [UIImage imageNamed:setting_SLIDE_RINGIMG];
        [self addSubview:img];
        
        UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(iFSize(5), iFSize(2), frame.size.width - 10, frame.size.height - 4)];
        img1.image = [UIImage imageNamed:setting_SLIDE_BACKIMG];
        [img addSubview:img1];
        img1.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        leftlabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20) WithTitle:[NSString stringWithFormat:@"%ld", leftvalue]];
        leftlabel.font = [UIFont systemFontOfSize:iFSize(18)];
        leftlabel.textAlignment = NSTextAlignmentCenter;
        leftlabel.backgroundColor = [UIColor clearColor];
        [self addSubview:leftlabel];

//        
//        [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mas_top);
//            make.left.equalTo([NSNumber numberWithInteger:-40]);
//        }];
//        
        
        rightlabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20) WithTitle:[NSString stringWithFormat:@"%ld", rightvalue]];
        rightlabel.font = [UIFont systemFontOfSize:iFSize(18)];
        rightlabel.textAlignment = NSTextAlignmentCenter;
        rightlabel.backgroundColor = [UIColor clearColor];
        [self addSubview:rightlabel];
        
//        [rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.mas_top);
//            make.right.equalTo(@40);
//        }];
//        
        
        for (int i = 0; i < 50; i++) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake( iFSize(5) + i * iFSize(4), iFSize(2), iFSize(3), iFSize(10))];
            label.tag = 100 + i;
            label.layer.masksToBounds = YES;
            
            label.layer.cornerRadius = 1;
            label.backgroundColor = [UIColor redColor];
            
            if (i > percent / 2) {
                label.backgroundColor = [UIColor lightGrayColor];
                
            }
            NSLog(@"%d = %@",i , label);
            
            [img1 addSubview:label];
        }
        img1.backgroundColor = [UIColor clearColor];
        [self addSubview:img1];
        
        self.controlView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(24), iFSize(24))];
        self.controlView.image = [UIImage imageNamed:@"littleCamera"];
        self.controlView.userInteractionEnabled = YES;
        
        self.controlView.center = CGPointMake(iFSize(percent * 2), img1.frame.size.height / 2);
        UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesTureAction:)];
        [self.controlView addGestureRecognizer:panGes];
        [img1 addSubview:self.controlView];
        [self initControlViewCenterWithPercent:percent];
        
    }
    return self;
}

- (void)initControlViewCenterWithPercent:(NSInteger)percent{
    self.controlView.center = CGPointMake(iFSize(percent * 2), self.frame.size.height / 2);
    CGFloat showvalue = (percent) / 100.0f * self.maxvalue;
    if (showvalue < self.minvalue) {
        showvalue = self.minvalue;
    }
    if (showvalue > self.maxvalue) {
        showvalue = self.maxvalue;
    }
    self.rightlabel.text = [NSString stringWithFormat:@"%0.lf", showvalue];
}
- (void)changePercent:(NSInteger)percent{
    for (int i = 0 ; i < 50; i++) {
        UILabel * label = [self viewWithTag:100 + i];
        if (i > percent / 2) {
            label.backgroundColor = [UIColor lightGrayColor];
        }else{
            label.backgroundColor = [UIColor redColor];
            
        }
    }
}
- (void)panGesTureAction:(UIPanGestureRecognizer *)pan{
    
    CGPoint po = [pan translationInView:self];
    static CGPoint center;
    if (pan.state == UIGestureRecognizerStateBegan) {
        center = pan.view.center;
    }
    pan.view.center = CGPointMake(po.x + center.x, center.y);
    if (po.x + center.x < iFSize(5)) {
        pan.view.center = CGPointMake(iFSize(5), center.y);
    }
    if (po.x + center.x > iFSize(206)) {
        pan.view.center = CGPointMake(iFSize(206), center.y);
    }
    NSLog(@"%@", NSStringFromCGPoint(pan.view.center));
    CGFloat percent = (iFSize(pan.view.center.x - 5)) / (iFSize(201) / 100.0f);
    NSLog(@"%lf", iFSize(205));
    NSLog(@"%lf", iFSize(pan.view.center.x - 5));
    NSLog(@"%lf", iFSize(200) / 100.0f);

    CGFloat showvalue = (percent) / 100.0f * self.maxvalue;
    if (showvalue < self.minvalue) {
        showvalue = self.minvalue;
    }
    if (showvalue > self.maxvalue) {
        showvalue = self.maxvalue;
    }
    self.rightlabel.text = [NSString stringWithFormat:@"%0.lf", showvalue];
    
    NSLog(@"percent = %lf", percent);
    NSLog(@"%lf", (percent + 1) / 100.0f);
    
    
    [self changePercent:percent];
    
}
@end
