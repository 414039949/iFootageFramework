//
//  iFSmoothnessView.m
//  iFootage
//
//  Created by 黄品源 on 2017/11/17.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFSmoothnessView.h"

@implementation iFSmoothnessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        for (int i = 0; i < 3; i++) {
            
            iF3DButton * cellBtn = [[iF3DButton alloc]initWithFrame:CGRectMake((i * 3) * self.frame.size.width / 8.0f, 0, self.frame.size.width / 4.0f, frame.size.height * 0.8)WithTitle:nil selectedIMG:all_RED_BACKIMG normalIMG:all_gray_BTNIMG];
            
            cellBtn.layer.borderWidth = 2;
            cellBtn.layer.masksToBounds = YES;
            cellBtn.actionBtn.tag = i + 100;
            [cellBtn.actionBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
            cellBtn.layer.cornerRadius = frame.size.height * 0.4;
            
//            if (i == 0) {
//                cellBtn.actionBtn.selected = YES;
//            }
//            if (i == 2) {
                cellBtn.backgroundColor = COLOR(66, 66, 66, 1);
                
//            }else{
            
//                cellBtn.backgroundColor = [UIColor redColor];
            
//            }
            cellBtn.layer.borderColor = [UIColor blackColor].CGColor;
            
            [self addSubview:cellBtn];
            
        }
        
    }
    return self;
}
- (void)BtnAction:(UIButton *)btn{
    UIButton * btn1 = [self viewWithTag:100];
    UIButton * btn2 = [self viewWithTag:101];
    UIButton * btn3 = [self viewWithTag:102];
    
    if (btn.tag == 100) {
        if (btn1.selected == YES) {
            btn1.selected = NO;
            btn2.selected = NO;
            btn3.selected = NO;
        }else{
            btn.selected = !btn.selected;
        }
    }else if (btn.tag == 101){
        if (btn3.selected == YES) {
            btn3.selected = !btn3.selected;
            btn1.selected = YES;

        }else{
            btn.selected = !btn.selected;
            btn1.selected = YES;
            
        }
    }else if (btn.tag == 102){
        btn.selected = !btn.selected;
        if (btn3.selected == YES) {
            btn1.selected = YES;
            btn2.selected = YES;
        }
    }
    NSLog(@"%ld", [self getSmoothnesslevel]);
    
}
- (void)initSmoothLevelWith:(NSInteger)smoothlevel{
    
    UIButton * btn1 = [self viewWithTag:100];
    UIButton * btn2 = [self viewWithTag:101];
    UIButton * btn3 = [self viewWithTag:102];
    if (smoothlevel == 0) {
        btn1.selected = NO;
        btn2.selected = NO;
        btn3.selected = NO;
    }else if (smoothlevel == 1) {
        btn1.selected = YES;
        btn2.selected = NO;
        btn3.selected = NO;
    }else if (smoothlevel == 2){
        btn1.selected = YES;
        btn2.selected = YES;
        btn3.selected = NO;
    }else if (smoothlevel == 3){
        btn1.selected = YES;
        btn2.selected = YES;
        btn3.selected = YES;
    }
}
- (NSInteger)getSmoothnesslevel{
    NSInteger smoothlevel = 0;
    UIButton * btn1 = [self viewWithTag:100];
    UIButton * btn2 = [self viewWithTag:101];
    UIButton * btn3 = [self viewWithTag:102];
    smoothlevel = btn1.selected + btn2.selected + btn3.selected;
    return smoothlevel;
}
@end
