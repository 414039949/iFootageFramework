//
//  iF3DButton.m
//  iFootage
//
//  Created by 黄品源 on 2017/8/5.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iF3DButton.h"

@implementation iF3DButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title selectedIMG:(NSString *)selectedImg normalIMG:(NSString *)normalImg{
    
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.masksToBounds = YES;
        
        UIImageView * backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backImage.image = [UIImage imageNamed:all_BLACK_BACKIMG];
        
        [self addSubview:backImage];
        
        self.actionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width * 0.94, frame.size.height * 0.9)];
        self.actionBtn.layer.cornerRadius = self.actionBtn.frame.size.height / 2.0f;
        self.actionBtn.layer.masksToBounds = YES;
        
        NSLog(@"action%lf", self.actionBtn.frame.size.height / 2.0f);
        NSLog(@"action%lf", frame.size.height * 0.9);
        
        self.actionBtn.center = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f);
        self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:frame.size.height * 0.4];
        [self.actionBtn setTitle:title forState:UIControlStateNormal];
//        self.actionBtn
        
        [self.actionBtn setBackgroundImage:[UIImage imageNamed:selectedImg] forState:UIControlStateSelected];
        [self.actionBtn setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
        [self addSubview:self.actionBtn];
    }
    return self;
}


@end

///Users/huangpinyuan/Desktop/iFootage(救命版)/iFootage/Main/Tools/iFLibrary/iFootageIMG/blackBackGround@3x.png
