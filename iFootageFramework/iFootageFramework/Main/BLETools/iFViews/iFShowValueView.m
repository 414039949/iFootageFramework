//
//  iFShowValueView.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/19.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFShowValueView.h"

@implementation iFShowValueView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDistanceValue:(CGFloat)value{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height * 0.05, self.frame.size.width, self.frame.size.height * 0.2)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:self.frame.size.height * 0.2];
        self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.height * 0.2];
        
        [self addSubview:self.titleLabel];

        
        self.ValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height * 0.2, self.frame.size.width, self.frame.size.height * 0.6)];
        self.ValueLabel.backgroundColor = [UIColor clearColor];
        self.ValueLabel.textColor = [UIColor whiteColor];
        self.ValueLabel.textAlignment = NSTextAlignmentCenter;
        self.ValueLabel.text = [NSString stringWithFormat:@"%.0f", value];
        self.ValueLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:self.frame.size.height * 0.3];
        [self addSubview:self.ValueLabel];
    }
    return self;
}

- (void)changeValueWithTag:(NSInteger)tag andValue:(CGFloat)value
{
    
    if (tag == SlideValueTag) {
        self.ValueLabel.text = [NSString stringWithFormat:@"%.0f", value];
        
    }else if (tag == PanValueTag){
        self.ValueLabel.text = [NSString stringWithFormat:@"%.0f", value];

    
    }else if (tag == TiltValueTag){
        self.ValueLabel.text = [NSString stringWithFormat:@"%.0f", value];
    }
}
@end
