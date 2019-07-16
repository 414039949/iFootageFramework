//
//  iFDatePickerView.m
//  iFootage
//
//  Created by 黄品源 on 16/8/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFDatePickerView.h"

@implementation iFDatePickerView
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
        self.hourArray = [[NSMutableArray alloc]init];
    
        self.mintuesArray = [[NSMutableArray alloc]init];
        self.secondArray = [[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < 10000; i++) {
            [self.hourArray addObject:[NSString stringWithFormat:@"%.4d", i]];
        }
        for (int i = 0; i <60 ; i++) {
            [self.mintuesArray  addObject:[NSString stringWithFormat:@"%.2d", i]];
            [self.secondArray  addObject:[NSString stringWithFormat:@"%.2d", i]];
        }
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
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.hourArray.count;
    }else{
        return self.mintuesArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return self.frame.size.width/4;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED {
    
    return 40;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.hourArray[row];
    }else{
        return self.mintuesArray[row];
    }
}
- (NSString *)getDateString{
    NSInteger a = [pickerView selectedRowInComponent:0];
    NSInteger b = [pickerView selectedRowInComponent:1];
    NSInteger c = [pickerView selectedRowInComponent:2];
    NSString * string = [NSString stringWithFormat:@"%.4ld:%.2ld:%.2ld", (long)a, b, c];
    return string;
}

@end
