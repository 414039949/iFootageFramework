
//
//  iFPointView.m
//  baiseierTable
//
//  Created by 黄品源 on 16/7/25.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFPointView.h"
#define RUIDS 40
@implementation iFPointView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame WithCenter:(CGPoint)center WithColor:(UIColor *)color {
    
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, iFSize(RUIDS), iFSize(RUIDS));
        self.center = center;
        self.layer.masksToBounds = YES;
        self.backgroundColor=[UIColor clearColor];
        self.layer.cornerRadius = iFSize(RUIDS) / 2;
        
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(iFSize(15), iFSize(15), iFSize(10), iFSize(10))];
        label.layer.masksToBounds = YES;
        label.backgroundColor = color;
        label.layer.cornerRadius = iFSize(5);
        
        [self addSubview:label];
    }
    return self;
}
@end
