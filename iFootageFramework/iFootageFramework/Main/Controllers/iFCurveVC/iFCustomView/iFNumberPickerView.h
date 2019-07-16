//
//  iFNumberPickerView.h
//  iFootage
//
//  Created by 黄品源 on 16/8/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFButton.h"
@interface iFNumberPickerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong)NSMutableArray * numberArray;
@property (nonatomic, strong)UIPickerView * pickerView;
@property (nonatomic, strong)iFButton * SureBtn;

- (NSInteger)getInteger;
- (NSArray *)getNsArray;

- (void)setInitValue:(NSArray *)array;

@end
