//
//  iFTimePickerView.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFTimePickerView.h"

@implementation iFTimePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame WithFPS:(NSInteger)fps{
    if (self = [super initWithFrame:frame]) {
        
        self.minuteArray = [NSMutableArray new];
        self.secondArray = [NSMutableArray new];
        self.fpsArray = [NSMutableArray new];
        self.fpsValue = fps;
        
        
        for (int i = self.minValue; i <60 ; i++) {
            [self.secondArray  addObject:[NSString stringWithFormat:@"%.2ds", i]];
        }
        for (int i = 0; i <60 ; i++) {
            [self.minuteArray  addObject:[NSString stringWithFormat:@"%.2dm", i]];
        }
        for (int i = 0; i < fps; i++) {
            [self.fpsArray addObject:[NSString stringWithFormat:@"%.2d", i]];
        }
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withMinValue:(int)minV{
    if (self = [super initWithFrame:frame]) {
        
        self.minuteArray = [NSMutableArray new];
        self.secondArray = [NSMutableArray new];
        

        for (int i = minV; i <60 ; i++) {
            [self.secondArray  addObject:[NSString stringWithFormat:@"%.2ds", i]];
        }
        for (int i = 0; i <60 ; i++) {
            [self.minuteArray  addObject:[NSString stringWithFormat:@"%.2dm", i]];
        }
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.fpsValue) {
        return 3;
    }else{
        return 2;
    }
}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
//
//    
//}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED // attributed title is favored if both methods are implemented
{
    NSAttributedString * attrString;
    
    
    
    if (component == 2) {
        NSDictionary * attrDic =@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Regular" size:17]};
        attrString = [[NSAttributedString alloc] initWithString:self.fpsArray[row] attributes:attrDic];
    }else if(component == 1){
        NSDictionary * attrDic =@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Regular" size:17]};
        attrString = [[NSAttributedString alloc] initWithString:self.secondArray[row] attributes:attrDic];
    }else{
        NSDictionary * attrDic =@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Regular" size:17]};
        attrString = [[NSAttributedString alloc] initWithString:self.minuteArray[row] attributes:attrDic];
    }

    
    return attrString;
    
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
//        pickerView
        return self.minuteArray.count;
    }else if(component == 1){
        return  self.secondArray.count;
    }else{
        return self.fpsArray.count;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.frame.size.width / 3;
}
- (nullable NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        return self.minuteArray[row];
    }else if(component == 1){
        return self.secondArray[row];
    }else{
        return self.fpsArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED{
    NSLog(@"%@, %ld", self.secondArray[row], (long)component);
    NSLog(@"%@", self.minuteArray[row]);

    NSInteger a = [self selectedRowInComponent:0];
    NSInteger b = [self selectedRowInComponent:1];
    NSLog(@"%ld %ld", a, b);
    NSLog(@"min= %d", self.minValue);
    if (self.fpsValue) {
        NSInteger c = [self selectedRowInComponent:2];
        [_timelapseDelegate getTimelapseTime:(CGFloat)a * 60 + (CGFloat)b + (CGFloat)c / self.fpsValue];
    }else{
        [_timelapseDelegate getTimelapseTime:(CGFloat)a * 60 + (CGFloat)b];

    }
    [_timeDelegate getTime:a * 60 + b];
}


- (void)setInitValue:(CGFloat)a{
    
    NSInteger min = (NSInteger)a / 60;
    NSInteger sec = (NSInteger)a % 60;
    if (self.fpsValue) {
        CGFloat floatFps = a - (NSInteger)a;
        NSInteger fps = floatFps * self.fpsValue;
        [self selectRow:fps inComponent:2 animated:NO];        
    }
    [self selectRow:min inComponent:0 animated:NO];
    [self selectRow:sec inComponent:1 animated:NO];
}

- (NSInteger)getTimeSecond{
    
    NSInteger a = [self selectedRowInComponent:0];
    NSInteger b = [self selectedRowInComponent:1];
    return a * 60 + b;

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
