//
//  iFTarget_PointValueView.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/19.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFTarget_PointValueView.h"

@implementation iFTarget_PointValueView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title{
    
    if (self = [super initWithFrame:frame]) {
        
        UILabel * titlelabel = [self getTitleLabel];
        titlelabel.text = title;
        titlelabel.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.1);
        
        titlelabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:titlelabel];
        
        UILabel * panlabel = [self getTitleLabel];
        UILabel * tiltlabel = [self getTitleLabel];
        UILabel * slidelabel = [self getTitleLabel];
        self.panValueLabel = [self getValueLabel];
        self.tiltValueLabel = [self getValueLabel];
        self.slideValueLabel = [self getValueLabel];
        
        panlabel.text = @"Pan:";
        tiltlabel.text = @"Tilt:";
        slidelabel.text = @"Slide:";
        self.panValueLabel.text = @"no set";
        self.tiltValueLabel.text = @"no set";
        self.slideValueLabel.text = @"no set";

        panlabel.center = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.3f);
        tiltlabel.center = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.5f);
        slidelabel.center = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.7f);
        self.panValueLabel.center = CGPointMake(self.frame.size.width * 0.9, self.frame.size.height * 0.3f);
        self.tiltValueLabel.center = CGPointMake(self.frame.size.width * 0.9, self.frame.size.height * 0.5f);
        self.slideValueLabel.center = CGPointMake(self.frame.size.width * 0.9, self.frame.size.height * 0.7f);
        
        [self addSubview:panlabel];
        [self addSubview:tiltlabel];
        [self addSubview:slidelabel];
        [self addSubview:self.panValueLabel];
        [self addSubview:self.tiltValueLabel];
        [self addSubview:self.slideValueLabel];
        
    }
    return self;
    
}
- (UILabel *)getTitleLabel{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, -20, self.frame.size.width * 0.3 + 20, self.frame.size.height * (1.0f / 3.0f))];
    label.font = [UIFont fontWithName:@"Montserrat-Regular" size:label.frame.size.height * 0.4];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = COLOR(66, 66, 66, 1);
    
    return label;
}
- (UILabel *)getValueLabel{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.7, self.frame.size.height * (1.0f / 3.0f))];
    label.font = [UIFont fontWithName:@"Montserrat-Regular" size:label.frame.size.height * 0.4];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    return label;
}

@end
