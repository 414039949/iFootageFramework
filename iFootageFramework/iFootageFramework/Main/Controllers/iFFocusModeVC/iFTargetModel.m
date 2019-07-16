//
//  iFTargetModel.m
//  iFootage
//
//  Created by 黄品源 on 2017/11/22.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFTargetModel.h"
#import <objc/runtime.h>


@implementation iFTargetModel

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
@end
