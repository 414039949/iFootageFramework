//
//  iFTimePickerView.h
//  iFootage
//
//  Created by 黄品源 on 2016/11/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimePickDelegate <NSObject>

- (void)getTime:(NSInteger)totalSecond;

@end

@protocol TimeLapseTimePickDelegate <NSObject>

- (void)getTimelapseTime:(CGFloat)totalTime;

@end

@interface iFTimePickerView : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong)NSMutableArray * minuteArray;
@property (nonatomic, strong)NSMutableArray * secondArray;
@property (nonatomic, strong)NSMutableArray * fpsArray;
@property (nonatomic, assign)NSInteger fpsValue;

@property (nonatomic, strong)id<TimePickDelegate>timeDelegate;
@property (nonatomic, strong)id<TimeLapseTimePickDelegate>timelapseDelegate;
@property int minValue;

- (id)initWithFrame:(CGRect)frame withMinValue:(int)minV;
- (id)initWithFrame:(CGRect)frame WithFPS:(NSInteger)fps;

- (void)setInitValue:(CGFloat)a;



@end
