//
//  iFFunctionPicker.h
//  iFootage
//
//  Created by 黄品源 on 2017/12/29.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GetFunctionIndexDelegate <NSObject>

- (void)getFunctionIndex:(NSInteger)index;

@end

@interface iFFunctionPicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>



@property(nonatomic, strong)NSArray * dataArray;

@property (nonatomic, strong)id<GetFunctionIndexDelegate>FunctionDelegate;

- (void)setInitValue:(NSInteger)a;
@end
