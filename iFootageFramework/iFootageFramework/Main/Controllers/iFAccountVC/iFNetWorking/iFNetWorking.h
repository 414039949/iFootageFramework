//
//  iFNetWorking.h
//  iFNetWorkingTest
//
//  Created by 黄品源 on 2017/6/16.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iFNetWorking : NSObject
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObj))success failure:(void (^)(NSError * error))failure;
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObj))success failure:(void(^)(NSError * error))failure;

@end
