//
//  iFStateView.m
//  iFootage
//
//  Created by 黄品源 on 16/9/1.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFStateView.h"

@implementation iFStateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)str {
    if (self = [super initWithFrame:frame]) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 10)];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = str;
        label.textColor = [UIColor whiteColor];
        
        label.font = [UIFont systemFontOfSize:8];
        [self addSubview:label];
        self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 10, 10)];
        self.stateLabel.layer.masksToBounds = YES;
        self.stateLabel.layer.cornerRadius = 5;
        self.stateLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.stateLabel];
    }
    return self;
    
}

- (void)changeColor:(UIColor *)color{
    self.stateLabel.backgroundColor = color;
}
@end
