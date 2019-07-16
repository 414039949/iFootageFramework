//
//  iFGetDataTool.h
//  iFootage
//
//  Created by 黄品源 on 2016/11/17.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iFGetDataTool : NSObject

+ (NSString *)getTimeWith:(NSInteger)totalsecond;
+ (NSString *)getTimelapseTimeWith:(CGFloat)totalsecond andFPS:(NSInteger)fps;
+ (NSString *)getTimelapseFrameWith:(NSInteger)frameNum andFPS:(NSInteger)fps;


+ (NSInteger)getTotalFrameWith:(CGFloat)totalsecond andFPS:(NSInteger)fps;
+ (CGFloat)getTotalTimeWith:(NSInteger)totalFrame andFPS:(NSInteger)fps;

+ (NSString *)get_HMS_TimeWith:(NSInteger)totalsecond;

@end
