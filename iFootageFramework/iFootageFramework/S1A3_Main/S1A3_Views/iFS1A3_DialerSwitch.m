//
//  iFS1A3_DialerSwitch.m
//  iFootage
//
//  Created by 黄品源 on 2018/5/18.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_DialerSwitch.h"

@implementation iFS1A3_DialerSwitch
{
    UIView * switchView;
    UIView * backImgView;
    
}
@synthesize isselected;

- (id)initWithFrame:(CGRect)frame WithIsSelected:(BOOL)isSelected{
    if (self = [super initWithFrame:frame]) {
        isselected = isSelected;
        backImgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 65)];
        backImgView.layer.cornerRadius = 6;
        backImgView.backgroundColor = [UIColor blackColor];
        backImgView.userInteractionEnabled = YES;
        [self addSubview:backImgView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGusure:)];
        switchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        switchView.layer.cornerRadius = 6;
        
        if (isselected) {
            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_red"]];
            switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height / 4);
        }else{
            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_white"]];
            switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height * 3 / 4);
        }
        [backImgView addGestureRecognizer:tap];
        [backImgView addSubview:switchView];
    }
    return self;
}
- (id)initWithSmallFrame:(CGRect)frame WithSelected:(BOOL)isSelected{
    
    if (self = [super initWithFrame:frame]) {
        CGFloat width , height = 0;;
        width = self.frame.size.width;
        height = self.frame.size.width * 65 / 35;
        isselected = isSelected;
        backImgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        backImgView.layer.cornerRadius = width / 6;
        
        backImgView.backgroundColor = [UIColor blackColor];
        backImgView.userInteractionEnabled = YES;
        [self addSubview:backImgView];
        CGFloat squareA = self.frame.size.width * 25 / 35;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGusure:)];
        switchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, squareA, squareA)];
        switchView.layer.cornerRadius = width / 6;
        
        if (isselected) {
//            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_white"]];
            switchView.backgroundColor = [UIColor redColor];

            switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height / 4);
        }else{
//            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_red"]];
            switchView.backgroundColor = [UIColor whiteColor];
            switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height * 3 / 4);
           
        }
//        [backImgView addGestureRecognizer:tap];
        [backImgView addSubview:switchView];
    }
    return self;
}

- (void)tapGusure:(UITapGestureRecognizer *)tap{
    isselected = !isselected;
    if (isselected) {
        switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_red"]];
        switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height / 4);
    }else{
        switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_white"]];
        switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height * 3 / 4);
    }
}
- (void)showSwitchStautsWith:(BOOL)selected{
    if (selected) {
        //            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_red"]];
        switchView.backgroundColor = [UIColor redColor];
        switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height / 4);
   
    }else{
        //            switchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"S1A3_DialerView_white"]];
        switchView.backgroundColor = [UIColor whiteColor];
        switchView.center = CGPointMake(backImgView.frame.size.width / 2, backImgView.frame.size.height * 3 / 4);
     
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
