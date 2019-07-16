//
//  LuaContext.h
//  sharkMiniPro
//
//  Created by Brustar on 2018/7/5.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LuaScriptCore/LuaScriptCore.h>

@interface LuaContext : NSObject

+ (instancetype)currentContext;

/**
 lua上下文
 */
@property(nonatomic, strong) LSCContext *context;

-(void) loadScript:(NSString *)file;

-(NSData *) createHex:(NSString *)func args:(NSArray *)args;

-(NSString *)createJson:(NSString *)func args:(NSArray *)args;
- (float) createFunc:(NSString *)func args:(NSArray *)args;
- (NSArray *)createArray:(NSString *)func args:(NSArray *)args;

@end
