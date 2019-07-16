//
//  iFBackImageView.h
//  iFootage
//
//  Created by 黄品源 on 16/10/14.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFBackImageView : UIView

- (void)createUIWithFrames:(NSInteger)total orWithTimes:(NSInteger)times;
- (void)chageLabel:(NSInteger)total;
- (void)changeLableWithTime:(NSInteger)total;
- (void)changeLabelWithTimeLapseTime:(NSInteger)total andFPS:(NSInteger)fps;

@end
