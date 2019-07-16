//
//  iFTargetModel.h
//  iFootage
//
//  Created by 黄品源 on 2017/11/22.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iFTargetModel : NSObject


@property (nonatomic, strong)NSString * fileName;
@property (nonatomic, strong)NSString * SaveDataTime;

@property (nonatomic, assign)NSInteger slide_A_pointValue;
@property (nonatomic, assign)NSInteger slide_B_pointValue;
@property (nonatomic, assign)NSInteger X2_A_panValue;
@property (nonatomic, assign)NSInteger X2_B_panValue;
@property (nonatomic, assign)NSInteger X2_A_tiltValue;
@property (nonatomic, assign)NSInteger X2_B_tiltValue;
@property (nonatomic, assign)NSInteger smoothnessLevel;

- (NSArray *) allPropertyNames;

@end
