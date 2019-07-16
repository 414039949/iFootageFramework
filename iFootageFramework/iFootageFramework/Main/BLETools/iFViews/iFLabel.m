//
//  iFLabel.m
//  iFootage
//
//  Created by 黄品源 on 16/8/6.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFLabel.h"

@implementation iFLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame WithTitle:(NSString * )title {
    if (self = [super initWithFrame:frame]) {
        
        self.text = title;
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:iFSize(20)];
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString * )title andFont:(CGFloat)font{
    
    if (self = [super initWithFrame:frame]) {
        self.text = title;
        self.textColor = [UIColor whiteColor];
//        self.font = [UIFont systemFontOfSize:font];
//        self.backgroundColor = [UIColor redColor];
        
        self.font = [UIFont fontWithName:@"Montserrat-Regular" size:font];

        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}




@end
