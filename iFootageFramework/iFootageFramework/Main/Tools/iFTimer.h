//
//  iFTimer.h
//  iFootage
//
//  Created by 黄品源 on 2017/3/2.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iFTimer : NSObject

+ (void)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector WithisOn:(BOOL)isOn;

@end
