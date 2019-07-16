//
//  iFPickView.h
//  iFootage
//
//  Created by 黄品源 on 2016/12/5.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getIndexDelegate <NSObject>

- (void)getIndex:(NSUInteger)idex;


@end

@interface iFPickView : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>


@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, assign)NSUInteger index;
@property (nonatomic, strong)id<getIndexDelegate>getDelegate;


- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)array;
- (id)initFPSPickWithFrame:(CGRect)frame andArray:(NSArray *)array;

- (void)setInitValue:(NSUInteger)index;

@end
