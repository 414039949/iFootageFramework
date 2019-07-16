//
//  iFTitle_ValueView.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/9.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFTitle_ValueView.h"

@implementation iFTitle_ValueView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andObject:(NSString *)object{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, frame.size.width * 0.6, frame.size.height)];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:frame.size.height * 0.5];
        [self addSubview:self.titleLabel];
        
        
        self.valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width * 0.6 - 20, 0, frame.size.width * 0.4, frame.size.height)];
        self.valueLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:frame.size.height * 0.5];
        if ([title isEqualToString:@"Current frame:"] == YES) {
            self.valueLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:frame.size.height * 0.85];
        }
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.text = object;
        [self addSubview:self.valueLabel];
    }
    return self;
}
@end
