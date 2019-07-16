//
//  iFS1A3_InsertView.h
//  iFootage
//
//  Created by 黄品源 on 2018/2/1.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFS1A3_InsertView : UIView

@property (nonatomic, strong)UILabel * markShaft;//滚动轴
@property (nonatomic, strong)UILabel * valueLabel;

- (void)changeMarkShaftXvalue:(CGFloat)xValue;

@end
