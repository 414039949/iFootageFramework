//
//  iFFunctionPicker.m
//  iFootage
//
//  Created by 黄品源 on 2017/12/29.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFFunctionPicker.h"

@implementation iFFunctionPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, 200, 200);
        self.dataArray = @[@"Timelapse", @"Video", @"StopMotion"];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width;
}
- (nullable NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    [_FunctionDelegate getFunctionIndex:row];
}

- (void)setInitValue:(NSInteger)a{
    [self selectRow:a inComponent:0 animated:NO];
}


@end
