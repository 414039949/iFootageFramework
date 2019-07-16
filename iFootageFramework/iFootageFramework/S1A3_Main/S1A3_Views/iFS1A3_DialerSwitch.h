//
//  iFS1A3_DialerSwitch.h
//  iFootage
//
//  Created by 黄品源 on 2018/5/18.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFS1A3_DialerSwitch : UIView

- (id)initWithFrame:(CGRect)frame WithIsSelected:(BOOL)isSelected;
- (id)initWithSmallFrame:(CGRect)frame WithSelected:(BOOL)isSelected;
- (void)showSwitchStautsWith:(BOOL)selected;
@property (nonatomic, assign)BOOL  isselected;
@end
