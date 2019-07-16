//
//  iFProgressView.m
//  iFootage
//
//  Created by 黄品源 on 16/8/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFProgressView.h"

@implementation iFProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame andProgressValue:(CGFloat)x title:(NSString *)title{
    
    
    if (self = [super initWithFrame:frame]) {
        
        self.ProgressLabel = [[UILabel alloc]initWithFrame:CGRectMake(iFSize(3), iFSize(3.5), iFSize(x), iFSize(9))];
        self.ProgressLabel.backgroundColor = COLOR(255, 45, 85, 1);
        [self addSubview:self.ProgressLabel];
        
        
        self.AxaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(iFSize(3), iFSize(15.5), iFSize(80), iFSize(14.5))];
        self.AxaiLabel.textColor = COLOR(167, 167, 167, 1);
        self.AxaiLabel.font = [UIFont systemFontOfSize:iFSize(14.5)];
        self.AxaiLabel.text = title;
        [self addSubview:self.AxaiLabel];
        
        self.AxaiValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(iFSize(83), iFSize(5), iFSize(200), iFSize(30))];
        self.AxaiValueLabel.textColor = [UIColor whiteColor];
        self.AxaiValueLabel.font = [UIFont systemFontOfSize:iFSize(24)];
        self.AxaiValueLabel.text = [NSString stringWithFormat:@"%04.1lf", x];
        [self addSubview:self.AxaiValueLabel];
    }
    return self;
}

- (id)initShowRealVelocViewWithFrame:(CGRect)frame WithTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.AxaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height / 3 * 2, self.frame.size.width, self.frame.size.height / 3)];
        self.AxaiLabel.textColor = COLOR(167, 167, 167, 1);
        self.AxaiLabel.font = [UIFont systemFontOfSize:iFSize(14.5)];
        self.AxaiLabel.text = title;
        [self addSubview:self.AxaiLabel];
        
        self.AxaiValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width + 20, self.frame.size.height / 3 * 2)];
        self.AxaiValueLabel.textColor = [UIColor whiteColor];
        self.AxaiValueLabel.font = [UIFont systemFontOfSize:iFSize(24)];
        self.AxaiValueLabel.text = @"0";
        [self addSubview:self.AxaiValueLabel];
        
        
        
    }
    return self;
    
    
    
}

- (void)changeValueWithProgresslabel:(CGFloat)x uint:(CGFloat)uint{
    
    
//    NSLog(@"%f", x);
    if (uint == 70.0f || uint == 360.0f) {
    self.ProgressLabel.frame = CGRectMake(iFSize(80), 0, iFSize(x), iFSize(9));
    }else{
    self.ProgressLabel.frame = CGRectMake(0, 0, iFSize(x), iFSize(9));
    }
    self.AxaiValueLabel.text = [NSString stringWithFormat:@"%04.1lf", iFSize(x) / iFSize(165) * uint];
    
}


@end
