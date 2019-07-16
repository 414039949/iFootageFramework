//
//  iFShowValueView.h
//  iFootage
//
//  Created by 黄品源 on 2016/10/19.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFShowValueView : UIView

@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * ValueLabel;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title andDistanceValue:(CGFloat)value;
- (void)changeValueWithTag:(NSInteger)tag andValue:(CGFloat)value;


@end
