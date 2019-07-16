//
//  iFS1A3_InsertView.m
//  iFootage
//
//  Created by 黄品源 on 2018/2/1.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_InsertView.h"
#define markShaftWidth 2.0f

@implementation iFS1A3_InsertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.markShaft = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, markShaftWidth, frame.size.height)];
        self.markShaft.backgroundColor = [UIColor redColor];
        [self addSubview:self.markShaft];
        
        self.valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.valueLabel.backgroundColor = [UIColor redColor];
        self.valueLabel.textColor = [UIColor whiteColor];
        self.valueLabel.layer.cornerRadius = 25;
        self.valueLabel.layer.masksToBounds = YES;
        
        self.valueLabel.alpha = 0;
        self.valueLabel.font = [UIFont systemFontOfSize:12];
        self.valueLabel.textAlignment = NSTextAlignmentCenter;
        self.valueLabel.center = CGPointMake(self.markShaft.frame.size.width / 2, 30);
        [self.markShaft addSubview:self.valueLabel];
        
    }
    return self;
}


- (void)changeMarkShaftXvalue:(CGFloat)xValue{
    
    self.markShaft.frame = CGRectMake(xValue * self.frame.size.width, 0, markShaftWidth, self.frame.size.height);
}
@end
