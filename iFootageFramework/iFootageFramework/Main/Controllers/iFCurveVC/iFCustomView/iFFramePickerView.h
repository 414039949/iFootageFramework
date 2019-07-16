//
//  iFFramePickerView.h
//  iFootage
//
//  Created by 黄品源 on 2016/10/27.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol framePickDelegate <NSObject>

- (void)getFrame:(NSInteger)sum;

@end


@interface iFFramePickerView : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>


@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)id<framePickDelegate>Framedelegate;


- (void)setInitValue:(NSInteger)a;


@end
