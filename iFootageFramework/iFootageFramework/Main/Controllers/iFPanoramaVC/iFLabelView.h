//
//  iFLabelView.h
//  iFootage
//
//  Created by 黄品源 on 2017/8/24.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFLabel.h"

@interface iFLabelView : UIView


@property (nonatomic, strong)iFLabel * ValueLabel;
@property (nonatomic, strong)iFLabel * titleLabel;
- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)titleStr andInitValueStr:(NSString *)ValueStr;


@end
