//
//  iFProgressView.h
//  iFootage
//
//  Created by 黄品源 on 16/8/8.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFProgressView : UIView

@property(nonatomic, strong)UILabel * ProgressLabel;
@property(nonatomic, strong)UILabel * AxaiLabel;
@property(nonatomic, strong)UILabel * AxaiValueLabel;
- (void)changeValueWithProgresslabel:(CGFloat)x uint:(CGFloat)uint;

- (id)initWithFrame:(CGRect)frame andProgressValue:(CGFloat)x title:(NSString *)title;
- (id)initShowRealVelocViewWithFrame:(CGRect)frame WithTitle:(NSString *)title;


@end
