//
//  iFSegmentView.h
//  iFootage
//
//  Created by 黄品源 on 2017/7/27.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendSelectedDelegete <NSObject>

- (void)getSelectedIndex:(NSInteger)selectedIndex withTag:(NSInteger)tag;


@end


@interface iFSegmentView : UIView

@property (nonatomic, strong)UIButton * firstBtn;
@property (nonatomic, strong)UIButton * secondBtn;
@property (nonatomic, strong)UIButton * thirdBtn;
@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)id<sendSelectedDelegete>delegate;

- (id)initWithFrameTwoBtns:(CGRect)frame andfirstTitle:(NSString *)firstTitle andSecondTitle:(NSString *)secondTitle andSelectedIndex:(NSInteger)selectedIndex;
- (id)initWithFrameThreeBtns:(CGRect)frame andfirstTitle:(NSString *)firstTitle andSecondTitle:(NSString *)secondTitle andThirdTitle:(NSString *)thirdTitle andSelectedIndex:(NSInteger)selectedIndex;
- (id)initWithFrameTarget:(CGRect)frame andfirstTitle:(NSString *)firstTitle andSecondTitle:(NSString *)secondTitle andSelectedIndex:(NSInteger)selectedIndex;



@end
