//
//  iFLabelView.m
//  iFootage
//
//  Created by 黄品源 on 2017/8/24.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFLabelView.h"

@implementation iFLabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)titleStr andInitValueStr:(NSString *)ValueStr{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
        
        self.ValueLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.6) WithTitle:ValueStr andFont:self.frame.size.height * 0.4];
        self.ValueLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.ValueLabel];
        
        
        self.titleLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height * 0.6, self.frame.size.width, self.frame.size.height * 0.4) WithTitle:titleStr andFont:self.frame.size.height * 0.3];
        self.titleLabel.textColor = COLOR(77, 77, 77, 1);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
    }
    return self;
}

@end
