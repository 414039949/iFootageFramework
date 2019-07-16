//
//  iFNumberPickerView.m
//  iFootage
//
//  Created by 黄品源 on 16/8/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFNumberPickerView.h"

@implementation iFNumberPickerView
@synthesize pickerView;
@synthesize SureBtn;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.numberArray = [NSMutableArray arrayWithArray:@[@"0",@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
        
        pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8)];
        pickerView.backgroundColor = [UIColor grayColor];
        pickerView.delegate = self;
        pickerView.dataSource = self;
        [self addSubview:pickerView];
        SureBtn = [[iFButton alloc]initWithFrameCenter:CGRectMake(self.frame.size.width / 3, self.frame.size.height * 0.8, self.frame.size.width / 3, self.frame.size.height * 0.2) andTitle:@"OK"];
        [self addSubview:SureBtn];
        
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.numberArray.count * 100;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width / 6.0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.numberArray[row % self.numberArray.count];
}
- (NSInteger)getInteger{
    NSInteger a = [pickerView selectedRowInComponent:0] % 10;
    NSInteger b = [pickerView selectedRowInComponent:1] % 10;
    NSInteger c = [pickerView selectedRowInComponent:2] % 10;
    NSInteger d = [pickerView selectedRowInComponent:3] % 10;
    NSInteger e = [pickerView selectedRowInComponent:4] % 10;
    NSInteger sum = a * 10000 + b * 1000 + c * 100 + d * 10 + e;
    return sum;
}
- (void)setInitValue:(NSArray *)array{
    for (int i = 0; i < array.count; i++) {
        [self.pickerView selectRow:[array[i] integerValue]inComponent:i animated:NO];
    }

}
- (NSArray *)getNsArray{
    NSMutableArray * array = [NSMutableArray new];
    NSInteger a = [pickerView selectedRowInComponent:0] % 10;
    NSInteger b = [pickerView selectedRowInComponent:1] % 10;
    NSInteger c = [pickerView selectedRowInComponent:2] % 10;
    NSInteger d = [pickerView selectedRowInComponent:3] % 10;
    NSInteger e = [pickerView selectedRowInComponent:4] % 10;
    
    [array addObject:[NSNumber numberWithInteger:a]];
    [array addObject:[NSNumber numberWithInteger:b]];
    [array addObject:[NSNumber numberWithInteger:c]];
    [array addObject:[NSNumber numberWithInteger:d]];
    [array addObject:[NSNumber numberWithInteger:e]];
    return array;

}
@end
