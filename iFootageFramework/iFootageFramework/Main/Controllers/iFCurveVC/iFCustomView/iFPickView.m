//
//  iFPickView.m
//  iFootage
//
//  Created by 黄品源 on 2016/12/5.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFPickView.h"

@implementation iFPickView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame andArray:(NSArray *)array{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (id)initFPSPickWithFrame:(CGRect)frame andArray:(NSArray *)array{
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
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
    return self.frame.size.width / 2;
}
- (nullable NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSLog(@"titleForRow = %ld", (long)row);
    
    
    return self.dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    NSLog(@"didSelectRow = %ld", (long)row);
    [_getDelegate getIndex:row];
}

- (void)setInitValue:(NSUInteger)index{
    [self selectRow:index inComponent:0 animated:NO];
}
@end
