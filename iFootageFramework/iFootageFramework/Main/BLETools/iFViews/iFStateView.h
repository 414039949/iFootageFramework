//
//  iFStateView.h
//  iFootage
//
//  Created by 黄品源 on 16/9/1.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFStateView : UIView

@property(nonatomic, strong)UILabel * stateLabel;
- (void)changeColor:(UIColor *)color;
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)str ;

@end
