//
//  iFModel.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/27.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFModel.h"
#import <objc/runtime.h>


@implementation iFModel


///通过运行时获取当前对象的所有属性的名称，以数组的形式返回
- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];

    }
    return self;
}
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

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
//        NSLog(@"HPYproperty%@", [NSString stringWithUTF8String:propertyName]);
        if ([[NSString stringWithUTF8String:propertyName] isEqualToString: @"displayUnit"] == YES) {
            
        }else{            
            [allNames addObject:[NSString stringWithUTF8String:propertyName]];
        }
    }
    
    ///释放
    free(propertys);
    
    return allNames;
}
- (NSArray *)sliderArray{
    return _sliderArray;
}
- (NSArray *)panArray{
    return _panArray;
}
- (NSArray *)tiltArray{
    return _tiltArray;
    
}
- (NSArray *)slideControlArray{
    return _slideControlArray;
}
- (NSArray *)panControlArray{
    return _panControlArray;
}
- (NSArray *)tiltControlArray{
    return _tiltControlArray;
}
@end
