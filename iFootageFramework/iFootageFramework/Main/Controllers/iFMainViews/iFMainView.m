//
//  iFMainView.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFMainView.h"

@implementation iFMainView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andImageName:(NSString *)name{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
        imageView.userInteractionEnabled = YES;
        imageView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.4);
        imageView.image = [UIImage imageNamed:name];
        imageView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:imageView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height * 0.8, self.frame.size.width , self.frame.size.height * 0.2)];
        label.text = title;
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        
    }
    return self;
    
}
@end
