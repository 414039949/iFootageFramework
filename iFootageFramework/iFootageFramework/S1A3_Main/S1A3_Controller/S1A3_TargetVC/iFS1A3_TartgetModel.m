//
//  iFS1A3_TartgetModel.m
//  iFootage
//
//  Created by 黄品源 on 2018/3/30.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_TartgetModel.h"
#import <objc/runtime.h>

@implementation iFS1A3_TartgetModel

#pragma Mark --- get方法
//@property (nonatomic, assign)NSInteger S1A3_slide_A_pointValue;
//@property (nonatomic, assign)NSInteger S1A3_slide_B_pointValue;
//@property (nonatomic, assign)NSInteger S1A3_X2_A_panValue;
//@property (nonatomic, assign)NSInteger S1A3_X2_B_panValue;
//@property (nonatomic, assign)NSInteger S1A3_X2_A_tiltValue;
//@property (nonatomic, assign)NSInteger S1A3_X2_B_tiltValue;
//@property (nonatomic, assign)NSInteger S1A3_smoothnessLevel;

- (NSArray *) allPropertyNames{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    
    ///存储属性的个数
    unsigned int propertyCount = 0;
    
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    
    
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        
        objc_property_t property = propertys[i];
        
        
        const char * propertyName = property_getName(property);
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

- (NSString *)S1A3_fileName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_fileName"];
    
}
- (NSString *)S1A3_SaveDataTime{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SaveDataTime"];

    
}
- (NSInteger)S1A3_slide_A_pointValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_slide_A_pointValue"] integerValue];

}
- (NSInteger)S1A3_slide_B_pointValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_slide_B_pointValue"] integerValue];

}
- (NSInteger)S1A3_X2_A_panValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_X2_A_panValue"] integerValue];

}
- (NSInteger)S1A3_X2_B_panValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_X2_B_panValue"] integerValue];

}
- (NSInteger)S1A3_X2_A_tiltValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_X2_A_tiltValue"] integerValue];

}
- (NSInteger)S1A3_X2_B_tiltValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_X2_B_tiltValue"] integerValue];

}
- (NSInteger)S1A3_smoothnessLevel{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_smoothnessLevel"] integerValue];
}
#pragma Mark --- set方法
- (void)setS1A3_fileName:(NSString *)S1A3_fileName{
    [[NSUserDefaults standardUserDefaults] setObject:S1A3_fileName forKey:@"S1A3_fileName"];
    
}
- (void)setS1A3_SaveDataTime:(NSString *)S1A3_SaveDataTime{
    [[NSUserDefaults standardUserDefaults] setObject:S1A3_SaveDataTime forKey:@"S1A3_SaveDataTime"];
}
- (void)setS1A3_slide_A_pointValue:(NSInteger)S1A3_slide_A_pointValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_slide_A_pointValue] forKey:@"S1A3_slide_A_pointValue"];
}
- (void)setS1A3_slide_B_pointValue:(NSInteger)S1A3_slide_B_pointValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_slide_B_pointValue] forKey:@"S1A3_slide_B_pointValue"];
}
- (void)setS1A3_X2_A_panValue:(NSInteger)S1A3_X2_A_panValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_X2_A_panValue] forKey:@"S1A3_X2_A_panValue"];

    
}
- (void)setS1A3_X2_B_panValue:(NSInteger)S1A3_X2_B_panValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_X2_B_panValue] forKey:@"S1A3_X2_B_panValue"];

    
}
- (void)setS1A3_X2_A_tiltValue:(NSInteger)S1A3_X2_A_tiltValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_X2_A_tiltValue] forKey:@"S1A3_X2_A_tiltValue"];

    
}
- (void)setS1A3_X2_B_tiltValue:(NSInteger)S1A3_X2_B_tiltValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_X2_B_tiltValue] forKey:@"S1A3_X2_B_tiltValue"];

    
}
- (void)setS1A3_smoothnessLevel:(NSInteger)S1A3_smoothnessLevel{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_smoothnessLevel] forKey:@"S1A3_smoothnessLevel"];

    
}


@end
