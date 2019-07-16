//
//  iFS1A3_DialerView.m
//  iFootage
//
//  Created by 黄品源 on 2018/5/18.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_DialerView.h"
#import "iFS1A3_DialerSwitch.h"
@implementation iFS1A3_DialerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame Withcode:(UInt8)code{
    
    if (self = [super initWithFrame:frame]) {
     
        
        UILabel * NOlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 65/ 2)];
        NOlabel.text = @"ON";
        NOlabel.textAlignment = NSTextAlignmentCenter;
        NOlabel.textColor = [UIColor grayColor];
        NOlabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:NOlabel];
        UILabel * OFFlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65 / 2, 35, 65 / 2)];
        OFFlabel.text = @"OFF";
        OFFlabel.textAlignment = NSTextAlignmentCenter;
        OFFlabel.textColor = [UIColor grayColor];
        
        OFFlabel.backgroundColor = [UIColor clearColor];
        [self addSubview:OFFlabel];
        
        for (int i = 0; i < 4; i++) {
            
            iFS1A3_DialerSwitch * di = [[iFS1A3_DialerSwitch alloc]initWithFrame:CGRectMake(35 + 65 * i, 0, 35, 65) WithIsSelected:((code >> (3 - i)) & 1)];
            di.tag = 200 + i;
            UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(35 + 65 * i, 65, 35, 30)];
            numLabel.textAlignment = NSTextAlignmentCenter;
            numLabel.textColor = [UIColor grayColor];
            numLabel.backgroundColor = [UIColor clearColor];
            numLabel.text = [NSString stringWithFormat:@"%d", i + 1];
            [self addSubview:numLabel];
            [self addSubview:di];
        }
    }
    return self;
}
- (NSInteger)getDialerRseults{
    NSInteger sum = 0;
    
    for (int i = 0; i < 4; i++) {
        iFS1A3_DialerSwitch * di = [self viewWithTag:200 + i];
        sum = sum + di.isselected * pow(2, 3 - i);
    }
    NSLog(@"%ld", sum);
     self.syncCode = sum;
    return sum;
}
- (id)initWithbackPNGFrame:(CGRect)frame WithCode:(UInt8)code{

    if (self = [super initWithFrame:frame]) {
            CGFloat width , height = 0;
        width = self.frame.size.width / 7;
        height = self.frame.size.height;
    for (int i = 0; i < 4; i++) {
        iFS1A3_DialerSwitch * di = [[iFS1A3_DialerSwitch alloc]initWithSmallFrame:CGRectMake(2 * width * i, 0, width, height) WithSelected:((code >> i) & 1)];
        di.tag = 100 + i;
        [self addSubview:di];
    }
    }
    return self;
}
- (void)getDialerResultsWithCode:(UInt8)code{
    
    self.syncCode = code;
    for (int i = 0; i < 4; i++) {
        iFS1A3_DialerSwitch * di = [self viewWithTag:100 + (3 - i)];
        [di showSwitchStautsWith:((code >> i) & 1)];
    }
    
    
}
@end
