//
//  iFPanoView.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/29.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFPanoView.h"
#define BorderWith 0.5
@implementation iFPanoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame andwCount:(int)wCount andhCount:(int)hCount{
    if (self = [super initWithFrame:frame]) {
        NSLog(@"WC = %d HC = %d", wCount, hCount);
        [self changeStateWithwCount:wCount andhCount:hCount AndHight:frame.size.height AndWidth:frame.size.width];
    }
    return self;
}
- (void)changeStateWithwCount:(int)wCount andhCount:(int)hCount{

    CGFloat RealHight = self.frame.size.height;
    CGFloat RealWidth = self.frame.size.width;
    
    CGFloat widthDistance;
    CGFloat heightDistance;
    
    if (wCount == 0 && hCount != 0) {
        NSLog(@"宽为0");
        
        heightDistance = RealHight / hCount;
        widthDistance = heightDistance * 3 / 2.0;
        
        for (int i = hCount - 1 ; i >= 0; i--) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, i * heightDistance, widthDistance, heightDistance)];
            label.backgroundColor = [UIColor clearColor];
            label.layer.borderWidth = BorderWith;
            label.layer.borderColor = [UIColor grayColor].CGColor;
            label.tag = hCount - i;
            NSLog(@"%ld", label.tag);
          
            
            [self addSubview:label];
        }
        
    }else if (wCount != 0 && hCount== 0){
        widthDistance = RealWidth / wCount;
        heightDistance = widthDistance * 2 / 3.0;
        for (int i = wCount - 1; i >= 0; i--) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * widthDistance, RealHight - heightDistance, widthDistance, heightDistance)];
            label.backgroundColor = [UIColor clearColor];
            label.layer.borderWidth = BorderWith;
            label.layer.borderColor = [UIColor grayColor].CGColor;
            label.tag = wCount - i;
            NSLog(@"%ld", label.tag);
           

            [self addSubview:label];
        }
    }else if (wCount != 0 && hCount != 0){
        if (wCount > hCount) {
            widthDistance = RealWidth / wCount;
            heightDistance = widthDistance * 2 / 3.0;
            for (int i = wCount - 1; i >= 0; i --) {
                for (int j = hCount - 1 ; j >= 0; j --) {
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * widthDistance, RealHight - (j+ 1) * heightDistance, widthDistance, heightDistance)];
                    label.backgroundColor = [UIColor clearColor];
                    label.layer.borderWidth = BorderWith;
                    label.layer.borderColor = [UIColor grayColor].CGColor;
                    if (i % 2 == 0) {
                        label.tag = i  * hCount + j + 1;
                    }else{
                        label.tag = i  *  hCount + (hCount - j);
                    }
                    

                    [self addSubview:label];
                    
                }
            }
        }else{
            heightDistance = RealHight / hCount;
            widthDistance = heightDistance * 3 / 2.0;
            for (int i = wCount - 1 ; i >= 0; i--) {
                for (int j = hCount - 1; j >= 0 ; j --) {
                    
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * widthDistance, j * heightDistance, widthDistance, heightDistance)];
                    label.backgroundColor = [UIColor clearColor];
                    label.layer.borderWidth = BorderWith;
                    label.layer.borderColor = [UIColor grayColor].CGColor;
                    if (i % 2 == 1) {
                        
                        label.tag = i  * hCount + j + 1;
                    }else{
                        label.tag = i  *  hCount + (hCount - j);
                    }
                    [self addSubview:label];
                }
            }
            
            
            
        }
        
    }

}
- (void)changeStateWithwCount:(int)wCount andhCount:(int)hCount AndHight:(CGFloat)realHight AndWidth:(CGFloat)realWidth{
    
    CGFloat RealHight = realHight;
    CGFloat RealWidth = realWidth;
    
    CGFloat widthDistance;
    CGFloat heightDistance;
    
    if (wCount == 0 && hCount != 0) {
        NSLog(@"宽为0");
        
        heightDistance = RealHight / hCount;
        widthDistance = heightDistance * 3 / 2.0;
        
        for (int i = hCount - 1 ; i >= 0; i--) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, i * heightDistance, widthDistance, heightDistance)];
            label.backgroundColor = [UIColor clearColor];
            label.layer.borderWidth = BorderWith;
            label.layer.borderColor = [UIColor grayColor].CGColor;
            label.tag = hCount - i;
            NSLog(@"%ld", label.tag);
            
            
            [self addSubview:label];
        }
        
    }else if (wCount != 0 && hCount== 0){
        widthDistance = RealWidth / wCount;
        heightDistance = widthDistance * 2 / 3.0;
        for (int i = wCount - 1; i >= 0; i--) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * widthDistance, RealHight - heightDistance, widthDistance, heightDistance)];
            label.backgroundColor = [UIColor clearColor];
            label.layer.borderWidth = BorderWith;
            label.layer.borderColor = [UIColor grayColor].CGColor;
            label.tag = wCount - i;
            NSLog(@"%ld", label.tag);
            
            
            [self addSubview:label];
        }
    }else if (wCount != 0 && hCount != 0){
        if (wCount > hCount) {
            widthDistance = RealWidth / wCount;
            heightDistance = widthDistance * 2 / 3.0;
            for (int i = wCount - 1; i >= 0; i --) {
                for (int j = hCount - 1 ; j >= 0; j --) {
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * widthDistance, RealHight - (j+ 1) * heightDistance, widthDistance, heightDistance)];
                    label.backgroundColor = [UIColor clearColor];
                    label.layer.borderWidth = BorderWith;
                    label.layer.borderColor = [UIColor grayColor].CGColor;
                    if (i % 2 == 0) {
                        label.tag = i  * hCount + j + 1;
                    }else{
                        label.tag = i  *  hCount + (hCount - j);
                    }
                    
                    
                    [self addSubview:label];
                    
                }
            }
        }else{
            heightDistance = RealHight / hCount;
            widthDistance = heightDistance * 3 / 2.0;
            for (int i = wCount - 1 ; i >= 0; i--) {
                for (int j = hCount - 1; j >= 0 ; j --) {
                    
                    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * widthDistance, j * heightDistance, widthDistance, heightDistance)];
                    label.backgroundColor = [UIColor clearColor];
                    label.layer.borderWidth = BorderWith;
                    label.layer.borderColor = [UIColor grayColor].CGColor;
                    if (i % 2 == 1) {
                        
                        label.tag = i  * hCount + j + 1;
                    }else{
                        label.tag = i  *  hCount + (hCount - j);
                    }
                    [self addSubview:label];
                }
            }
            
            
            
        }
        
    }
    
}
- (void)showLabelColorWith:(NSInteger)index{
    for (int i = 1; i <= index; i++) {
        UILabel * label = [self viewWithTag:i];
        label.backgroundColor=  [UIColor whiteColor];
    }
}
@end
