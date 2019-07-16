//
//  iFDatePickerView.h
//  iFootage
//
//  Created by 黄品源 on 16/8/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFButton.h"

@interface iFDatePickerView : UIView<UIPickerViewDelegate , UIPickerViewDataSource>


@property (nonatomic, strong)NSMutableArray * hourArray;
@property (nonatomic, strong)NSMutableArray * mintuesArray;
@property (nonatomic, strong)NSMutableArray * secondArray;
@property (nonatomic, strong)UIPickerView * pickerView;
@property (nonatomic, strong)iFButton * SureBtn;

- (NSString *)getDateString;

@end
