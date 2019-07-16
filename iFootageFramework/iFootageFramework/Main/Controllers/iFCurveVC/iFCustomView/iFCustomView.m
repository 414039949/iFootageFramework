//
//  iFCustomView.m
//  iFootage
//
//  Created by 黄品源 on 16/8/10.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFCustomView.h"

@implementation iFCustomView
@synthesize firstBtn;
@synthesize secondBtn;
@synthesize thirdBtn;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame firstTitleBtn:(NSString *)firstTitle SecondTitleBtn:(NSString *)secondTitle ThirdTitleBtn:(NSString *)thirdTitle {
   
    
    if (self = [super initWithFrame:frame]) {
            firstBtn = [[iFButton alloc]initWithFrame:CGRect(0,0,50,24) andTitle:firstTitle andiSSelceted:firstBtn.selected];
            firstBtn.selected = YES;
    
            [firstBtn addTarget:self action:@selector(changeSelectedValue:) forControlEvents:UIControlEventTouchUpInside];

            firstBtn.tag = 1;

            [self addSubview:firstBtn];
        
            secondBtn = [[iFButton alloc]initWithFrame:CGRect(44, 0, 50, 24) andTitle:secondTitle andiSSelceted:secondBtn.selected];
            secondBtn.tag = 2;
            [secondBtn addTarget:self action:@selector(changeSelectedValue:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:secondBtn];
            thirdBtn = [[iFButton alloc]initWithFrame:CGRect(94, 0, 50, 24) andTitle:thirdTitle andiSSelceted:thirdBtn.selected];
            [thirdBtn addTarget:self action:@selector(changeSelectedValue:) forControlEvents:UIControlEventTouchUpInside];
    
            thirdBtn.tag = 3;
        
            [self addSubview:thirdBtn];

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame firstTitleBtn:(NSString *)firstTitle SecondTitleBtn:(NSString *)secondTitle{
    firstBtn.selected = YES;
    secondBtn.selected = NO;

    if (self = [super initWithFrame:frame]) {
        
            firstBtn = [[iFButton alloc]initWithFrame:CGRect(0,0,80,24) andTitle:firstTitle andiSSelceted:firstBtn.selected];
            firstBtn.selected = YES;
    
            firstBtn.tag = 1;
            [firstBtn addTarget:self action:@selector(changeSelectedValue:) forControlEvents:UIControlEventTouchUpInside];
        
            [self addSubview:firstBtn];
            secondBtn = [[iFButton alloc]initWithFrame:CGRect(90, 0, 170, 24) andTitle:secondTitle andiSSelceted:secondBtn.selected];
            secondBtn.tag = 2;
            [secondBtn addTarget:self action:@selector(changeSelectedValue:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:secondBtn];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame changeModeWithFirstBtn:(NSString *)firstTilte SecondTitleBtn:(NSString *)secondTitle{
    self = [super initWithFrame:frame];
    if (self) {
        firstBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height) andTitle:firstTilte andiSSelceted:firstBtn.selected];
        firstBtn.selected = YES;
        firstBtn.tag = 1;
        [firstBtn addTarget:self action:@selector(changeSelectedValue:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:firstBtn];
        
        
    }
    return self;
    
}


- (void)changeSelectedValue:(iFButton *)btn{
    if (btn.tag == 1) {
        if (btn.selected == YES) {
            
        }else{
            self.index = 0;
            firstBtn.selected = YES;
            secondBtn.selected = NO;
            thirdBtn.selected = NO;
        }
    }else if(btn.tag == 2){
        if (btn.selected == YES) {
        }else{
            self.index = 1;
            secondBtn.selected = YES;
            firstBtn.selected = NO;
            thirdBtn.selected = NO;
        }
    }else{
        if (btn.selected == YES) {
        }else{
            self.index = 2;
            thirdBtn.selected = YES;
            firstBtn.selected = NO;
            secondBtn.selected = NO;
        }
    }
    
    if ([_delegate respondsToSelector:@selector(getIndexWithView:)]) { // 如果协议响应了sendValue:方法
        [_delegate getIndexWithView:self.index];
    }
    
    
}


@end
