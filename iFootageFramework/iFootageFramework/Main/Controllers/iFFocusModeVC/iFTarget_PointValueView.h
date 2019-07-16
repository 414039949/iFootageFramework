//
//  iFTarget_PointValueView.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/19.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFTarget_PointValueView : UIView


@property (nonatomic, strong)UILabel *panValueLabel;
@property (nonatomic, strong)UILabel *tiltValueLabel;
@property (nonatomic, strong)UILabel *slideValueLabel;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title;

@end
