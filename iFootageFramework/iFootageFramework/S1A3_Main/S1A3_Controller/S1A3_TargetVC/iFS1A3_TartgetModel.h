//
//  iFS1A3_TartgetModel.h
//  iFootage
//
//  Created by 黄品源 on 2018/3/30.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iFS1A3_TartgetModel : NSObject


@property (nonatomic, strong)NSArray * allPropertyNames;

@property (nonatomic, strong)NSString * S1A3_fileName;
@property (nonatomic, strong)NSString * S1A3_SaveDataTime;

@property (nonatomic, assign)NSInteger S1A3_slide_A_pointValue;
@property (nonatomic, assign)NSInteger S1A3_slide_B_pointValue;
@property (nonatomic, assign)NSInteger S1A3_X2_A_panValue;
@property (nonatomic, assign)NSInteger S1A3_X2_B_panValue;
@property (nonatomic, assign)NSInteger S1A3_X2_A_tiltValue;
@property (nonatomic, assign)NSInteger S1A3_X2_B_tiltValue;
@property (nonatomic, assign)NSInteger S1A3_smoothnessLevel;

@end
