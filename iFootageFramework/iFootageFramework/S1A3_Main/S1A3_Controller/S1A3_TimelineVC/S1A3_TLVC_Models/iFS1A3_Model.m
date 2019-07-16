//
//  iFS1A3_Model.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/29.
//  Copyright © 2018年 iFootage. All rights reserved.
//
#import <objc/runtime.h>
#import "iFS1A3_Model.h"

@implementation iFS1A3_Model
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
        
        if ([self returnIscontainRefertoKeyWithKey:[NSString stringWithUTF8String:propertyName]]) {
            
        }else{
            [allNames addObject:[NSString stringWithUTF8String:propertyName]];
        }
        
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}

- (BOOL)returnIscontainRefertoKeyWithKey:(NSString *)keyStr{
    NSArray * keyArray = @[@"S1A3_ShootingMode", @"S1A3_DisPlayMode", @"S1A3_SlideCount", @"S1A3_CameraIndex", @"S1A3_FocalIndex", @"S1A3_AspectIndex", @"S1A3_PanIntervalIndex", @"S1A3_slideAdjustVeloc", @"S1A3_panAdjustVeloc", @"S1A3_tiltAdjustVeloc"];
    for (NSString * str in keyArray) {
        if ([str isEqualToString:keyStr] == YES) {
            return YES;
        }
    }
    return NO;
}
#pragma mark ---- set方法集合 -------
- (void)setS1A3_SlideArray:(NSArray *)S1A3_SlideArray{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:S1A3_SlideArray] forKey:@"S1A3_SlideArray"];
}
- (void)setS1A3_PanArray:(NSArray *)S1A3_PanArray{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:S1A3_PanArray] forKey:@"S1A3_PanArray"];
}
- (void)setS1A3_TiltArray:(NSArray *)S1A3_TiltArray{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:S1A3_TiltArray] forKey:@"S1A3_TiltArray"];
}
- (void)setS1A3_SlideControlArray:(NSArray *)S1A3_SlideControlArray{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:S1A3_SlideControlArray] forKey:@"S1A3_SlideControlArray"];
}
- (void)setS1A3_PanControlArray:(NSArray *)S1A3_PanControlArray{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:S1A3_PanControlArray] forKey:@"S1A3_PanControlArray"];
}
- (void)setS1A3_TiltControlArray:(NSArray *)S1A3_TiltControlArray{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:S1A3_TiltControlArray] forKey:@"S1A3_TiltControlArray"];
}
- (void)setS1A3_FunctionMode:(NSInteger)S1A3_FunctionMode{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_FunctionMode] forKey:@"S1A3_FunctionMode"];
}
- (void)setS1A3_ExpoSecond:(NSInteger)S1A3_ExpoSecond{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_ExpoSecond] forKey:@"S1A3_ExpoSecond"];
}
- (void)setS1A3_BufferSecond:(NSInteger)S1A3_BufferSecond{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_BufferSecond] forKey:@"S1A3_BufferSecond"];
}
- (void)setS1A3_TimelapseTotalFrames:(NSInteger)S1A3_TimelapseTotalFrames{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_TimelapseTotalFrames] forKey:@"S1A3_TimelapseTotalFrames"];
}
- (void)setS1A3_TimelapseTotalTimes:(CGFloat)S1A3_TimelapseTotalTimes{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_TimelapseTotalTimes] forKey:@"S1A3_TimelapseTotalTimes"];
}
- (void)setS1A3_fpsIndex:(NSInteger)S1A3_fpsIndex{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_fpsIndex] forKey:@"S1A3_fpsIndex"];
}
- (void)setS1A3_VideoTotalTimes:(CGFloat)S1A3_VideoTotalTimes{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_VideoTotalTimes] forKey:@"S1A3_VideoTotalTimes"];
}
- (void)setS1A3_SlideUpValue:(CGFloat)S1A3_SlideUpValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_SlideUpValue] forKey:@"S1A3_SlideUpValue"];

}
- (void)setS1A3_SlideDownValue:(CGFloat)S1A3_SlideDownValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_SlideDownValue] forKey:@"S1A3_SlideDownValue"];

}
- (void)setS1A3_PanUpValue:(CGFloat)S1A3_PanUpValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_PanUpValue] forKey:@"S1A3_PanUpValue"];

}
- (void)setS1A3_PanDownValue:(CGFloat)S1A3_PanDownValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_PanDownValue] forKey:@"S1A3_PanDownValue"];

}
- (void)setS1A3_TiltUpValue:(CGFloat)S1A3_TiltUpValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_TiltUpValue] forKey:@"S1A3_TiltUpValue"];

}
- (void)setS1A3_TiltDownValue:(CGFloat)S1A3_TiltDownValue{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_TiltDownValue] forKey:@"S1A3_TiltDownValue"];
}
- (void)setS1A3_ShootingMode:(NSInteger)S1A3_ShootingMode{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_ShootingMode] forKey:@"S1A3_ShootingMode"];

}
- (void)setS1A3_DisPlayMode:(NSInteger)S1A3_DisPlayMode{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_DisPlayMode] forKey:@"S1A3_DisPlayMode"];

}
- (void)setS1A3_SlideCount:(NSInteger)S1A3_SlideCount{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_SlideCount] forKey:@"S1A3_SlideCount"];
   
    
}
- (void)setS1A3_CameraIndex:(NSInteger)S1A3_CameraIndex{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_CameraIndex] forKey:@"S1A3_CameraIndex"];
    
}
- (void)setS1A3_FocalIndex:(NSInteger)S1A3_FocalIndex{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_FocalIndex] forKey:@"S1A3_FocalIndex"];
    

}
- (void)setS1A3_AspectIndex:(NSInteger)S1A3_AspectIndex{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_AspectIndex] forKey:@"S1A3_AspectIndex"];
    
}
- (void)setS1A3_PanIntervalIndex:(NSInteger)S1A3_PanIntervalIndex{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_PanIntervalIndex] forKey:@"S1A3_PanIntervalIndex"];
    
}
- (void)setS1A3_slideAdjustVeloc:(CGFloat)S1A3_slideAdjustVeloc{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_slideAdjustVeloc] forKey:@"S1A3_slideAdjustVeloc"];
   
}
- (void)setS1A3_panAdjustVeloc:(CGFloat)S1A3_panAdjustVeloc{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_panAdjustVeloc] forKey:@"S1A3_panAdjustVeloc"];
    
}
- (void)setS1A3_tiltAdjustVeloc:(CGFloat)S1A3_tiltAdjustVeloc{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_tiltAdjustVeloc] forKey:@"S1A3_tiltAdjustVeloc"];
   
}
- (void)setS1A3_Pano_StartAngle:(CGFloat)S1A3_Pano_StartAngle{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_Pano_StartAngle] forKey:@"S1A3_Pano_StartAngle"];

}
- (void)setS1A3_Pano_EndAngle:(CGFloat)S1A3_Pano_EndAngle{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:S1A3_Pano_EndAngle] forKey:@"S1A3_Pano_EndAngle"];
}
- (void)setS1A3_Target_totaltime:(NSInteger)S1A3_Target_totaltime{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:S1A3_Target_totaltime] forKey:@"S1A3_Target_totaltime"];

}
- (void)setS1A3_NameStr:(NSString *)S1A3_NameStr{
    [[NSUserDefaults standardUserDefaults] setObject:S1A3_NameStr forKey:@"S1A3_NameStr"];
}
#pragma mark ---- get方法集合 -----
- (NSArray *)S1A3_SlideControlArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideControlArray"]];
}
- (NSArray *)S1A3_PanControlArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_PanControlArray"]];
}
- (NSArray *)S1A3_TiltControlArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TiltControlArray"]];
}
- (NSArray *)S1A3_SlideArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideArray"]];
}
- (NSArray *)S1A3_PanArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_PanArray"]];
}
- (NSArray *)S1A3_TiltArray{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TiltArray"]];
}
- (NSInteger)S1A3_FunctionMode{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_FunctionMode"] integerValue];
}
- (NSInteger)S1A3_ExpoSecond{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_ExpoSecond"] integerValue];
}
- (NSInteger)S1A3_BufferSecond{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_BufferSecond"] integerValue];
}
- (NSInteger)S1A3_TimelapseTotalFrames{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TimelapseTotalFrames"] integerValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TimelapseTotalFrames"] integerValue] : 100;
}

- (NSInteger)S1A3_fpsIndex{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_fpsIndex"] integerValue];
}
- (CGFloat)S1A3_TimelapseTotalTimes{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TimelapseTotalTimes"] floatValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TimelapseTotalTimes"] floatValue] : 100.0f / 24.0f;
    
}
- (CGFloat)S1A3_VideoTotalTimes{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_VideoTotalTimes"] floatValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_VideoTotalTimes"] floatValue] : 100;
    
}
- (CGFloat)S1A3_SlideUpValue{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideUpValue"] floatValue] < S1A3_TrackNumber(self.S1A3_SlideCount)? ([[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideUpValue"] floatValue] != 0 ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideUpValue"] floatValue] : S1A3_TrackNumber(self.S1A3_SlideCount)) : S1A3_TrackNumber(self.S1A3_SlideCount);
    
}
- (CGFloat)S1A3_SlideDownValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideDownValue"] floatValue] > 0 ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideDownValue"] floatValue] : 0;

}
- (CGFloat)S1A3_PanUpValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_PanUpValue"] floatValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_PanUpValue"] floatValue] : S1A3_PanMaxValue;

}
- (CGFloat)S1A3_PanDownValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_PanDownValue"] floatValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_PanDownValue"] floatValue] : S1A3_PanMinValue;

}
- (CGFloat)S1A3_TiltUpValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TiltUpValue"] floatValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TiltUpValue"] floatValue] : S1A3_TiltMaxValue;

}
- (CGFloat)S1A3_TiltDownValue{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TiltDownValue"] floatValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_TiltDownValue"] floatValue] : S1A3_TiltMinValue;
    
}
- (NSInteger)S1A3_ShootingMode{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_ShootingMode"] integerValue];

}
- (NSInteger)S1A3_DisPlayMode{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_DisPlayMode"] integerValue];
}
- (NSInteger)S1A3_SlideCount{
    
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideCount"] integerValue]?[[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_SlideCount"] integerValue] : 2 ;
}


- (NSInteger)S1A3_CameraIndex{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_CameraIndex"] integerValue];
}
- (NSInteger)S1A3_FocalIndex{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_FocalIndex"] integerValue];
}
- (NSInteger)S1A3_AspectIndex{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_AspectIndex"] integerValue];
}
- (NSInteger)S1A3_PanIntervalIndex{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_PanIntervalIndex"] integerValue];
}
- (CGFloat)S1A3_slideAdjustVeloc{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_slideAdjustVeloc"] floatValue] ?  [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_slideAdjustVeloc"] floatValue] : 0.75;
}
- (CGFloat)S1A3_panAdjustVeloc{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_panAdjustVeloc"] floatValue] ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_panAdjustVeloc"] floatValue] : 0.75;
}
- (CGFloat)S1A3_tiltAdjustVeloc{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_tiltAdjustVeloc"] floatValue]? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_tiltAdjustVeloc"] floatValue] : 0.75;
}
- (CGFloat)S1A3_Pano_StartAngle{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_Pano_StartAngle"] floatValue]? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_Pano_StartAngle"] floatValue] : 0;
}
- (CGFloat)S1A3_Pano_EndAngle{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_Pano_EndAngle"] floatValue]? [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_Pano_EndAngle"] floatValue] : 0;
}
- (NSInteger)S1A3_Target_totaltime{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_Target_totaltime"] integerValue]?[[[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_Target_totaltime"] integerValue] : 12;
}
- (NSString *)S1A3_NameStr{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"S1A3_NameStr"];

}


@end
