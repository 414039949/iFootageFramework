//
//  iFButton.h
//  iFootage
//
//  Created by 黄品源 on 16/8/5.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFButton : UIButton
/**
 *  Description
 *
 *  @param frame             frame description
 *  @param normalImageName   normalImageName description
 *  @param SelectedImageName SelectedImageName description
 *
 *  @return return value description
 */
-(id)initWithFrame:(CGRect)frame  andnormalImage:(NSString * )normalImageName andSelectedImage:(NSString *)SelectedImageName;
/**
 *  Description
 *
 *  @param frame frame description
 *  @param title title description
 *
 *  @return return value description
 */
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
/**
 *  Description
 *
 *  @param frame      frame description
 *  @param title      title description
 *  @param isSelceted isSelceted description
 *
 *  @return return value description
 */
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andiSSelceted:(BOOL)isSelceted;

- (id)initWithFrameCenter:(CGRect)frame andTitle:(NSString *)title;

/**
 Description

 @param frame frame description
 @param title title description
 @param cornerRadius cornerRadius description
 @return return value description
 */
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius;

/**
 微调的按钮

 @param frame frame description
 @param titleStr titleStr description
 @return return value description
 */
- (id)initWithFrame:(CGRect)frame WithFineTitle:(NSString *)titleStr;
- (id)initWithAccountVCFrame:(CGRect)frame andFoundtionTitle:(NSString *)title;
- (id)initWithAttentionFrame:(CGRect)frame andFounctionTitle:(NSString *)title WithNormalColor:(UIColor *)color andHighlightedColor:(UIColor *)Highlightedcolor;


- (id)initWithTargetBtnFrame:(CGRect)frame andTitle:(NSString *)titleStr;

@end
