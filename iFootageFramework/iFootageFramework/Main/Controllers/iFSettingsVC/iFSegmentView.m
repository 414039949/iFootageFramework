//
//  iFSegmentView.m
//  iFootage
//
//  Created by 黄品源 on 2017/7/27.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFSegmentView.h"

@implementation iFSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrameTarget:(CGRect)frame andfirstTitle:(NSString *)firstTitle andSecondTitle:(NSString *)secondTitle andSelectedIndex:(NSInteger)selectedIndex{
    if (self = [super initWithFrame:frame]) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        imageView.layer.cornerRadius = frame.size.height / 2;
        imageView.image = [UIImage imageNamed:@"target_bg"];
        imageView.layer.masksToBounds = YES;
        
        [self addSubview:imageView];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 5, frame.size.height - 5)];
        view.layer.cornerRadius = (frame.size.height - 5) / 2;
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:view];
        
        self.firstBtn = [self getNewBtn:firstTitle];
        self.firstBtn.tag = 221;
        self.firstBtn.frame = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
        [self.firstBtn setTitle:firstTitle forState:UIControlStateNormal];
        [view addSubview:self.firstBtn];
        
        self.secondBtn = [self getNewBtn:secondTitle];
        self.secondBtn.tag = 222;
        self.secondBtn.frame = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
        
        [self.secondBtn setTitle:secondTitle forState:UIControlStateNormal];
        [view addSubview:self.secondBtn];
        [self changeStatusWithSelectedIndex:selectedIndex];
    }
    return self;
    
}

- (id)initWithFrameTwoBtns:(CGRect)frame andfirstTitle:(NSString *)firstTitle andSecondTitle:(NSString *)secondTitle andSelectedIndex:(NSInteger)selectedIndex{
    
    if (self = [super initWithFrame:frame]) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        
        imageView.image = [UIImage imageNamed:setting_SEGMENTRINGIMG];
        [self addSubview:imageView];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 10, frame.size.height - 10)];
        view.layer.cornerRadius = (frame.size.height - 10) / 2;
        view.backgroundColor = [UIColor clearColor];
        view.layer.masksToBounds = YES;
        view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:view];
        
        self.firstBtn = [self getNewBtn:firstTitle];
        self.firstBtn.tag = 221;
        self.firstBtn.frame = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
        [self.firstBtn setTitle:firstTitle forState:UIControlStateNormal];
        [view addSubview:self.firstBtn];
        
        self.secondBtn = [self getNewBtn:secondTitle];
        self.secondBtn.tag = 222;
        self.secondBtn.frame = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);

        [self.secondBtn setTitle:secondTitle forState:UIControlStateNormal];
        [view addSubview:self.secondBtn];
        [self changeStatusWithSelectedIndex:selectedIndex];
    }
    return self;
}
- (void)changeStatusWithSelectedIndex:(NSInteger)selectedIndex{
    if (selectedIndex == 0 ) {
        self.firstBtn.selected = YES;
        self.secondBtn.selected = NO;
        self.thirdBtn.selected = NO;
        
    }else if (selectedIndex == 1){
        self.firstBtn.selected = NO;
        self.secondBtn.selected = YES;
        self.thirdBtn.selected = NO;
        
    }else if (selectedIndex == 2){
        self.firstBtn.selected = NO;
        self.secondBtn.selected = NO;
        self.thirdBtn.selected = YES;
    }
}
- (id)initWithFrameThreeBtns:(CGRect)frame andfirstTitle:(NSString *)firstTitle andSecondTitle:(NSString *)secondTitle andThirdTitle:(NSString *)thirdTitle andSelectedIndex:(NSInteger)selectedIndex{
    if (self = [super initWithFrame:frame]) {

        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.image = [UIImage imageNamed:setting_SEGMENTRINGIMG];
        [self addSubview:imageView];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width - 10, frame.size.height - 10)];
        view.layer.cornerRadius = (frame.size.height - 10) / 2;
        view.backgroundColor = [UIColor clearColor];
        view.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self addSubview:view];
        
        
        self.firstBtn = [self getNewBtn:firstTitle];
        self.firstBtn.frame = CGRectMake(0, 0, view.frame.size.width / 3, view.frame.size.height);
        self.firstBtn.tag = 221;
        [view addSubview:self.firstBtn];
        
        
        self.secondBtn = [self getNewBtn:secondTitle];
        self.secondBtn.frame = CGRectMake(view.frame.size.width / 3, 0, view.frame.size.width / 3, view.frame.size.height);
        self.secondBtn.tag = 222;
        [view addSubview:self.secondBtn];
        
        
        self.thirdBtn = [self getNewBtn:thirdTitle];
        self.thirdBtn.frame = CGRectMake(view.frame.size.width / 3 * 2.0f, 0, view.frame.size.width / 3, view.frame.size.height);
        self.thirdBtn.tag = 223;
        [self addSubview:self.thirdBtn];
        
    }
    return self;
}
- (UIButton *)getNewBtn:(NSString *)title{
    
    UIButton * btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:all_RED_BACKIMG] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:all_WHITE_BACKIMG] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15];
//   [UIFont fontWithName:@"Montserrat-Regular" size:15];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}
- (void)changeSelectedIndex{
    
    if (self.firstBtn.selected) {
        self.selectedIndex = 0;
    }else if (self.secondBtn.selected){
        self.selectedIndex = 1;
    }else if (self.thirdBtn.selected){
        self.selectedIndex = 2;
    }
//    NSLog(@"%d %d %d",self.firstBtn.selected, self.secondBtn.selected, self.thirdBtn.selected);
    
}
- (void)btnAction:(UIButton *)btn{

//    NSLog(@"%@", btn);
    if (btn.tag == 221) {
//        NSLog(@"%d", btn.selected);
        self.selectedIndex = 0;
        
    }else if (btn.tag == 222){
//        NSLog(@"%d", btn.selected);
        self.selectedIndex = 1;
        
    }else if (btn.tag == 223){
        
        self.selectedIndex = 2;
    }
    [self changeStatusWithSelectedIndex:self.selectedIndex];
    [_delegate getSelectedIndex:self.selectedIndex withTag:self.tag];
    
    //    [self changeSelectedIndex];
}
@end
