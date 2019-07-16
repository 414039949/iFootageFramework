//
//  iFTitle_ValueView.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/9.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFTitle_ValueView : UIView

@property (nonatomic, strong)UILabel * titleLabel;
@property (nonatomic, strong)UILabel * valueLabel;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andObject:(NSString *)object;

@end
