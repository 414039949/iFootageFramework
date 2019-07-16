//
//  iFFramePickerView.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/27.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFFramePickerView.h"

@implementation iFFramePickerView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.dataArray = [NSMutableArray arrayWithArray:@[@"0",@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
    
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 5;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width / 6.0;
}
- (nullable NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    
    NSLog(@"%@, %ld", self.dataArray[row], (long)component);
    [self getInteger];
    [_Framedelegate getFrame:[self getInteger]];
}
- (void)setInitValue:(NSInteger)a{
    
    NSArray * array =  [self getNsArray:a];
    for (int i = 0; i < array.count; i++) {
        [self selectRow:[array[i] integerValue] inComponent:i animated:NO];
    }
}
- (NSInteger)getInteger{
    NSInteger a = [self selectedRowInComponent:0] % 10;
    NSInteger b = [self selectedRowInComponent:1] % 10;
    NSInteger c = [self selectedRowInComponent:2] % 10;
    NSInteger d = [self selectedRowInComponent:3] % 10;
    NSInteger e = [self selectedRowInComponent:4] % 10;
    NSInteger sum = a * 10000 + b * 1000 + c * 100 + d * 10 + e;
    return sum;
}
- (NSArray *)getNsArray:(NSInteger)sum{
    NSMutableArray * array = [NSMutableArray new];
    NSInteger a = sum / 10000 % 10;
    NSInteger b = sum / 1000 % 10;
    NSInteger c = sum / 100 % 10;
    NSInteger d = sum / 10 % 10;
    NSInteger e = sum % 10;
    
    
    [array addObject:[NSNumber numberWithInteger:a]];
    [array addObject:[NSNumber numberWithInteger:b]];
    [array addObject:[NSNumber numberWithInteger:c]];
    [array addObject:[NSNumber numberWithInteger:d]];
    [array addObject:[NSNumber numberWithInteger:e]];
    return array;
    
}
@end
