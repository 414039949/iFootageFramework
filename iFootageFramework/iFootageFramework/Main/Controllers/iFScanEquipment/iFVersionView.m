//
//  iFVersionView.m
//  iFootage
//
//  Created by 黄品源 on 2018/6/25.
//  Copyright © 2018 iFootage. All rights reserved.
//

#import "iFVersionView.h"
#import <Masonry/Masonry.h>

@implementation iFVersionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    UIView *centerView;
}


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"layoutSubviews1");
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.layer.masksToBounds = YES;
        
        centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.8, self.frame.size.height * 0.8)];
        centerView.backgroundColor = [UIColor redColor];
        centerView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
        centerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        centerView.layer.cornerRadius = 10;
        centerView.layer.masksToBounds = YES;
        self.userInteractionEnabled = YES;
        centerView.userInteractionEnabled = YES;
        
        [self addSubview:centerView];
    }
    return self;
}

- (void)layoutSubviews{
    
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self.S1View removeFromSuperview];
        [self.X2View removeFromSuperview];
        [self.S1A3_S1View removeFromSuperview];
        [self.S1A3_X2View removeFromSuperview];
        
        
        
       self.S1View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width, centerView.frame.size.height * 0.5) WithTitle:@"S1" WithContent:NSLocalizedString(MainVC_S1updateSlogan, nil)];
        self.S1View.userInteractionEnabled = YES;
        self.S1View.alpha = 0;
        self.S1View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [centerView addSubview:self.S1View];
        self.X2View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width, centerView.frame.size.height * 0.5) WithTitle:@"X2" WithContent:NSLocalizedString(MainVC_X2updateSlogan, nil)];
        self.X2View.userInteractionEnabled = YES;
        self.X2View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.X2View.alpha = 0;
        [centerView addSubview:self.X2View];
        
        self.S1A3_S1View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width, centerView.frame.size.height * 0.5) WithTitle:@"S1A3_S1" WithContent:NSLocalizedString(MainVC_S1updateSlogan, nil)];
        self.S1A3_S1View.userInteractionEnabled = YES;
        self.S1A3_S1View.alpha = 0;
        self.S1A3_S1View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [centerView addSubview:self.S1A3_S1View];
        
        self.S1A3_X2View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width, centerView.frame.size.height * 0.5) WithTitle:@"S1A3_X2" WithContent:NSLocalizedString(MainVC_X2updateSlogan, nil)];
        self.S1A3_X2View.userInteractionEnabled = YES;
        self.S1A3_X2View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.S1A3_X2View.alpha = 0;
        [centerView addSubview:self.S1A3_X2View];
        
        
        [self.S1View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_top);
            make.right.equalTo(centerView.mas_right);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width, centerView.frame.size.height * 0.5));
            
        }];
        [self.X2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(centerView.mas_centerY);
            make.right.equalTo(centerView.mas_right);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width, centerView.frame.size.height * 0.5));
        }];
        
        [self.S1A3_S1View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_top);
            make.right.equalTo(centerView.mas_right);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width, centerView.frame.size.height * 0.5));
            
        }];
        [self.S1A3_X2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_centerY);
            make.right.equalTo(centerView.mas_right);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width, centerView.frame.size.height * 0.5));
        }];
        
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        [self.S1View removeFromSuperview];
        [self.X2View removeFromSuperview];
        [self.S1A3_S1View removeFromSuperview];
        [self.S1A3_X2View removeFromSuperview];
        
        self.S1View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width * 0.5, centerView.frame.size.height) WithTitle:@"S1" WithContent:NSLocalizedString(MainVC_S1updateSlogan, nil)];
        self.S1View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.S1View.alpha = 0;
        
        [centerView addSubview:self.S1View];
        self.X2View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width * 0.5, centerView.frame.size.height) WithTitle:@"X2" WithContent:NSLocalizedString(MainVC_X2updateSlogan, nil)];
        self.X2View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.X2View.alpha = 0;
        
        [centerView addSubview:self.X2View];
        
        [self.S1View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_top);
            make.left.equalTo(centerView.mas_left);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width * 0.5, centerView.frame.size.height));
            
        }];
        [self.X2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_top);
            make.left.equalTo(centerView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width * 0.5, centerView.frame.size.height));
        }];
        
        
     
        
        self.S1A3_S1View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width * 0.5, centerView.frame.size.height) WithTitle:@"S1A3_S1" WithContent:NSLocalizedString(MainVC_S1updateSlogan, nil)];
        self.S1A3_S1View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.S1A3_S1View.alpha = 0;
        
        [centerView addSubview:self.S1A3_S1View];
        
        self.S1A3_X2View = [[iFupdateView alloc]initWithFrame:CGRectMake(0, 0, centerView.frame.size.width * 0.5, centerView.frame.size.height) WithTitle:@"S1A3_X2" WithContent:NSLocalizedString(MainVC_X2updateSlogan, nil)];
        self.S1A3_X2View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.S1A3_X2View.alpha = 0;
        [centerView addSubview:self.S1A3_X2View];
        
        [self.S1A3_S1View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_top);
            make.left.equalTo(centerView.mas_left);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width * 0.5, centerView.frame.size.height));
            
        }];
        [self.S1A3_X2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(centerView.mas_top);
            make.left.equalTo(centerView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(centerView.frame.size.width * 0.5, centerView.frame.size.height));
        }];
        
    }
}

@end
