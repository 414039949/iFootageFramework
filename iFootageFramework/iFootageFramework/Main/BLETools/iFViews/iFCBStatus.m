//
//  iFCBStatus.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/14.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFCBStatus.h"

@implementation iFCBStatus

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
    
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height * 0.5)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.titleLabel.text = title;
        self.titleLabel.font = [UIFont systemFontOfSize:frame.size.height * 0.4];
        [self addSubview:self.titleLabel];
        
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width * 0.25, frame.size.height * 0.5, frame.size.width * 0.5, frame.size.width * 0.5)];
        self.statusLabel.backgroundColor = [UIColor redColor];
        self.statusLabel.layer.masksToBounds = YES;
        
        self.statusLabel.layer.cornerRadius = frame.size.height * 0.25;
        [self addSubview:self.statusLabel];
        
    }
    return self;
    
}
- (void)changeStatusWithCBState:(NSInteger)status{
    
    self.statusLabel.backgroundColor = [UIColor greenColor];
    
}
@end
