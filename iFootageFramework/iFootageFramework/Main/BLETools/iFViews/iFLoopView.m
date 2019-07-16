//
//  iFLoopView.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/26.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFLoopView.h"

@implementation iFLoopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [self  getLabelWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) andTitle:nil];
        [self addSubview:self.titleLabel];
    }
    return self;
}
- (void)loopChangeTitle:(NSInteger)a{

    
    switch (a) {
        case 0:
            self.titleLabel.text = @"Timelapse";
            _MODEL = MODEL_TIMELAPSE;
            
            break;
            case 1:
            self.titleLabel.text = @"Video";
            _MODEL = MODEL_VIDEO;
            
            break;
            case 2:
            self.titleLabel.text = @"Stop Motion";
            _MODEL = MODEL_STOPMOTION;
            break;
            
        default:
            break;
    }
}

- (UILabel *)getLabelWithFrame:(CGRect)frame andTitle:(NSString *)title{
    
    UILabel * label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.05];
    }else if(kDevice_Is_iPad){
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.03];
    }else{
        label.font = [UIFont fontWithName:@"Montserrat-Regular" size:AutoKscreenWidth * 0.04];
    }
    label.userInteractionEnabled = YES;
    
    UILabel * slognLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 10)];
    slognLabel.center = CGPointMake(frame.size.width * 0.5, frame.size.height + 5);
    slognLabel.backgroundColor = [UIColor clearColor];
    slognLabel.textColor =COLOR(97, 97, 97, 1);
    slognLabel.textAlignment = NSTextAlignmentCenter;
    
    slognLabel.text = @"﹀";
    [label addSubview:slognLabel];
    return label;
    
}

@end
