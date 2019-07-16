//
//  iFTimer.m
//  iFootage
//
//  Created by 黄品源 on 2017/3/2.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFTimer.h"

@implementation iFTimer


+ (void)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector WithisOn:(BOOL)isOn{
    
    if (!isOn) {
        [NSTimer scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:nil repeats:YES];
    }
}

@end
