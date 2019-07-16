//
//  iFupdateView.m
//  iFootage
//
//  Created by 黄品源 on 2018/6/25.
//  Copyright © 2018 iFootage. All rights reserved.
//

#import "iFupdateView.h"

@implementation iFupdateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)str WithContent:(NSString *)contentStr{
    
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.1)];
        label.text = str;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        
        [self addSubview:label];
        
        
        UITextView * contentview= [[UITextView alloc]initWithFrame:CGRectMake(0, self.frame.size.height * 0.1, self.frame.size.width, self.frame.size.height * 0.6)];
        contentview.text = contentStr;
        contentview.userInteractionEnabled = NO;
        contentview.textColor = [UIColor whiteColor];
        contentview.backgroundColor = [UIColor clearColor];
        [self addSubview:contentview];

        self.actionBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.2, self.frame.size.height * 0.7, self.frame.size.width * 0.6, self.frame.size.height * 0.15) WithTitle:NSLocalizedString(Setting_Updatefirmware, nil) selectedIMG:all_RED_BACKIMG normalIMG:all_RED_BACKIMG];
        self.actionBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:_actionBtn];
    }
    return self;
}
- (void)lalalala:(UIButton *)btn{
    NSLog(@"lalalala");
}

@end
