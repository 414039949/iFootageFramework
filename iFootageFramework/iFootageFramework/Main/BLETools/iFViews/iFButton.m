//
//  iFButton.m
//  iFootage
//
//  Created by 黄品源 on 16/8/5.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFButton.h"

@implementation iFButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithFineTitle:(NSString *)titleStr{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setTitle:titleStr forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:frame.size.width * 0.6];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
        self.layer.cornerRadius = frame.size.width * 0.5;
    }
    return self;
    
}

- (id)initWithFrameCenter:(CGRect)frame andTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame  andnormalImage:(NSString * )normalImageName andSelectedImage:(NSString *)SelectedImageName{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        self.imageEdgeInsets = UIEdgeInsetsMake(iFSize(36), 0, 0, 0);
        
    //        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];

        [self setImage:[UIImage imageNamed:SelectedImageName] forState:UIControlStateSelected];
    
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
//        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:16];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andiSSelceted:(BOOL)isSelceted{
    
    if (self = [super initWithFrame:frame]) {
        NSLog(@" ==== %d, %d", isSelceted, self.selected);
        self.backgroundColor = [UIColor clearColor];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor cyanColor] forState:UIControlStateSelected];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setTitle:title forState:UIControlStateNormal];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = cornerRadius;
        self.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
    }
    return self;
    
}

- (id)initWithAccountVCFrame:(CGRect)frame andFoundtionTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR(255, 45, 85, 1);
        self.layer.cornerRadius = 22.5;
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];

        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateHighlighted];
    }
    return self;
    
}

- (id)initWithAttentionFrame:(CGRect)frame andFounctionTitle:(NSString *)title WithNormalColor:(UIColor *)color andHighlightedColor:(UIColor *)Highlightedcolor{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:14];
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        [self setTitleColor:Highlightedcolor forState:UIControlStateHighlighted];
    }
    return self;

}

- (id)initWithTargetBtnFrame:(CGRect)frame andTitle:(NSString *)titleStr{
    
    if (self = [super initWithFrame:frame]) {
      
        [self setTitle:titleStr forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:all_WHITE_BACKIMG] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:all_BLACK_BACKIMG] forState:UIControlStateSelected];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/ 2;
        
        
        
    }
    return self;
}

//-(id)initWithFrame:(CGRect)frame  andnormalTitle:(NSString * )normalImageTitle andSelectedImage:(NSString *)SelectedImageName{
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor clearColor];
//        
//        [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:SelectedImageName] forState:UIControlStateSelected];
//        
//    }
//    return self;
//}

@end
