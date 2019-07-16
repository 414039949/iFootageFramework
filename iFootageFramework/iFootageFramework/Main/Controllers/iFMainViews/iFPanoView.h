//
//  iFPanoView.h
//  iFootage
//
//  Created by 黄品源 on 2016/11/29.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFPanoView : UIView

- (id)initWithFrame:(CGRect)frame andwCount:(int)wCount andhCount:(int)hCount;
- (void)changeStateWithwCount:(int)wCount andhCount:(int)hCount;
//- (void)changeStateWithwCount:(int)wCount andhCount:(int)hCount AndHight:(CGFloat)realHight AndWidth:(CGFloat)realWidth
- (void)showLabelColorWith:(NSInteger)index;

@end
