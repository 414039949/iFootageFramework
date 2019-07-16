//
//  iFGetDataTool.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/17.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFGetDataTool.h"

@implementation iFGetDataTool

+ (NSString *)getTimeWith:(NSInteger)totalsecond{
    
//    NSLog(@"totalSecond%d", totalsecond);
    
    NSString * str;
    NSInteger a = totalsecond / 60;
    NSInteger b = totalsecond % 60;
    
    str = [NSString stringWithFormat:@"%.2ld:%.2ld", (long)a, (long)b];
    return str;
}
+ (NSString *)get_HMS_TimeWith:(NSInteger)totalsecond{
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02d",totalsecond/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(totalsecond%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02d",totalsecond%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}
+ (NSString *)getTimelapseTimeWith:(CGFloat)totalsecond andFPS:(NSInteger)fps{
    NSInteger intNumber = (NSInteger)totalsecond;
    CGFloat  decNumber = totalsecond - (NSInteger)totalsecond;
    NSLog(@"decNumber================");
    NSLog(@"decNumber%f", decNumber);
    NSLog(@"decNumber%lf", decNumber * fps);
    
    NSString * str;
    NSInteger a = intNumber / 60;
    NSInteger b = intNumber % 60;
    str = [NSString stringWithFormat:@"%.2ld:%.2ld.%.2ldf", (long)a, (long)b,(long)ceilf(decNumber * fps)];
    
    return str;
    
}

+ (NSString *)getTimelapseFrameWith:(NSInteger)frameNum andFPS:(NSInteger)fps{
    
    NSInteger intNumber = frameNum;
    NSString * str;
    
    NSInteger a = intNumber % fps;
    NSInteger b = intNumber / fps % 60;
    NSInteger c = intNumber / fps / 60;
    str = [NSString stringWithFormat:@"%.2ld:%.2lds.%.2ldf", (long)c, (long)b, (long)a];
    return str;
}
+ (NSInteger)getTotalFrameWith:(CGFloat)totalsecond andFPS:(NSInteger)fps{
    NSInteger intNumber;
    intNumber = totalsecond * fps;
    return intNumber;
}
+ (CGFloat)getTotalTimeWith:(NSInteger)totalFrame andFPS:(NSInteger)fps{
    CGFloat floatNumber;
    floatNumber = (CGFloat)totalFrame / (CGFloat)fps;
    return floatNumber;
}

@end
