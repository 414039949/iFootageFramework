//
//  iF3DButton.h
//  iFootage
//
//  Created by 黄品源 on 2017/8/5.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iF3DButton : UIView

@property (nonatomic, strong)UIButton * actionBtn;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)title selectedIMG:(NSString *)selectedImg normalIMG:(NSString *)normalImg;

@end
