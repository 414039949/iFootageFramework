//
//  iFUpdateBtn.m
//  iFootage
//
//  Created by 黄品源 on 2017/7/27.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFUpdateBtn.h"

@implementation iFUpdateBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title{

    if (self = [super initWithFrame:frame]) {
        UIImageView * backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-4, -4, frame.size.width + 8 , frame.size.height + 8)];
        backImageView.image = [UIImage imageNamed:setting_SLIDE_UPDATE_RINGIMG];
        [self addSubview:backImageView];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:frame.size.height / 2];
        
        [self setTitle:title forState:UIControlStateNormal];
        
        [self setBackgroundImage:[UIImage imageNamed:@"redBackGround@3x.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"blackBackGround@3x"] forState:UIControlStateSelected];
        
        
    }
    return self;
}
@end
