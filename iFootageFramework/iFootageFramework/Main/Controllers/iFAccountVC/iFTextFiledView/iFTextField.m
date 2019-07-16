//
//  iFTextField.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/19.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFTextField.h"

@implementation iFTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//setSecurtEntry:(BOOL)isEntry
- (id)initWithFrame:(CGRect)frame WithPlaceholderString:(NSString *)placeholderStr WithTitleImg:(NSString *)titleimageName WithBackgroundImg:(NSString *)backimageName setSecurtEntry:(BOOL)isEntry{
    

    if (self = [super initWithFrame:frame]) {
        self.placeholder = placeholderStr;
        self.font = [UIFont fontWithName:@"Montserrat-Regular" size:iFSize(14)];
        self.textColor = [UIColor whiteColor];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.keyboardType = UIKeyboardTypeAlphabet;

        UIColor *color = COLOR(163, 163, 163, 1);
        
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName: color}];
        
        [self setSecureTextEntry:isEntry];
        self.backgroundColor = [UIColor clearColor];
        self.background = [UIImage imageNamed:backimageName];
        self.leftView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:titleimageName]];
        
        UIBezierPath * c1 = [UIBezierPath bezierPath];
        [c1 moveToPoint:CGPointMake(0, frame.size.height)];
        [c1 addLineToPoint:CGPointMake(frame.size.width, frame.size.height)];
        
        CAShapeLayer * s1 = [CAShapeLayer layer];
        s1.strokeColor = COLOR(160, 160, 160, 1).CGColor;
        s1.fillColor = [UIColor clearColor].CGColor;
        s1.lineWidth = 0.5;
        s1.path = c1.CGPath;
        s1.lineCap = kCALineCapSquare;
        [self.layer addSublayer:s1];

//        bezierpath moveToPoint:CGPointMake(, fr)
    }
    
    return self;
}
@end
