//
//  iFSliderView.h
//  iFootage
//
//  Created by 黄品源 on 2018/2/2.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getSlideValueDelegate <NSObject>

- (void)getSlideValueAction:(CGFloat)Value;

@end


@interface iFSliderView : UIView

@property (nonatomic, strong)UIView * tapView;
@property (nonatomic, assign)BOOL iSselected;
@property (nonatomic, assign)CGFloat slideValue;
@property (nonatomic, strong)UIImageView * imageView;
@property (nonatomic, strong) id<getSlideValueDelegate>delegate;

@end
