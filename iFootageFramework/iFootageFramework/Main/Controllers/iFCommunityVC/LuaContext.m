//
//  LuaContext.m
//  sharkMiniPro
//
//  Created by Brustar on 2018/7/5.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "LuaContext.h"

@implementation LuaContext

+ (instancetype)currentContext {
    static LuaContext *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void) loadScript:(NSString *)file
{NSLog(@"1111111111111111");
    
    
    self.context = [[LSCContext alloc] init];
    //加载Lua脚本
    [self.context evalScriptFromFile:file];
}

-(LSCValue *) callFunction:(NSString *)func args:(NSArray *)args
{
    NSMutableArray *arguments = [NSMutableArray new];
    for (id arg in args) {
        if ([arg isKindOfClass:[NSNumber class]]) {
            [arguments addObject:[LSCValue numberValue:arg]];
        }else if([arg isKindOfClass:[NSString class]]){
            [arguments addObject:[LSCValue stringValue:arg]];
        }else if([arg isKindOfClass:[NSArray class]]){
            [arguments addObject:[LSCValue arrayValue:arg]];
        }else{
        continue;
        }
    }
    
    LSCValue *value = [self.context callMethodWithName:func
                           arguments:arguments];
    
    return value;
}

- (float) createFunc:(NSString *)func args:(NSArray *)args{
    
    LSCValue *value = [self callFunction:func args:args];
    return [value toDouble];
    
}
- (NSArray *)createArray:(NSString *)func args:(NSArray *)args{
    LSCValue *value = [self callFunction:func args:args];
    return [value toArray];
    
}
-(NSData *) createHex:(NSString *)func args:(NSArray *)args
{
    LSCValue *value = [self callFunction:func args:args];
    return [value toData];
}

-(NSString *) createJson:(NSString *)func args:(NSArray *)args
{
    LSCValue *value = [self callFunction:func args:args];
    return [value toString];
}

@end
