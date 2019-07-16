//
//  iFCenterInfoView.m
//  iFootage
//
//  Created by 黄品源 on 2017/11/15.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFCenterInfoView.h"

@implementation iFCenterInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.intervalLabel = [self getTitleLabel];
        self.finalOutputLabel = [self getTitleLabel];
        self.fimlingTimeLabel = [self getTitleLabel];
        self.interValueLabel = [self getValueLabel];
        self.finalOutputValueLabel = [self getValueLabel];
        self.fimilingTimeValueLabel = [self getValueLabel];
        
        self.intervalLabel.text = @"Interval:";
        self.finalOutputLabel.text = @"Final output:";
        self.fimlingTimeLabel.text = @"Filming time:";
        self.interValueLabel.text = @"00:00:00S";
        self.finalOutputValueLabel.text = @"00:00:00s";
        self.fimilingTimeValueLabel.text = @"00:00:00F";
        

        self.intervalLabel.center = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * (1.0f / 6.0f));
        self.finalOutputLabel.center = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.5f);
        self.fimlingTimeLabel.center = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * (5.0f / 6.0f));
        self.interValueLabel.center = CGPointMake(self.frame.size.width * 0.9, self.frame.size.height * (1.0f / 6.0f));
        self.finalOutputValueLabel.center = CGPointMake(self.frame.size.width * 0.9, self.frame.size.height * 0.5f);
        self.fimilingTimeValueLabel.center = CGPointMake(self.frame.size.width * 0.9, self.frame.size.height * (5.0f / 6.0f));
        
        [self addSubview:self.interValueLabel];
        [self addSubview:self.finalOutputValueLabel];
        [self addSubview:self.fimilingTimeValueLabel];
        
        [self addSubview:self.intervalLabel];
        [self addSubview:self.finalOutputLabel];
        [self addSubview:self.fimlingTimeLabel];
    }
    return self;
}


- (UILabel *)getTitleLabel{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.6, self.frame.size.height * (1.0f / 3.0f))];
    label.font = [UIFont fontWithName:@"Montserrat-Regular" size:label.frame.size.height * 0.8];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = COLOR(111, 111, 111, 1);
    
    return label;
}
- (UILabel *)getValueLabel{
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.6, self.frame.size.height * (1.0f / 3.0f))];
    label.font = [UIFont fontWithName:@"Montserrat-Regular" size:label.frame.size.height * 0.8];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    return label;
}
@end
