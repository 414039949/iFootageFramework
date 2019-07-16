//
//  iFErrorCode.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/20.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFErrorCode.h"

@implementation iFErrorCode


//返回码	备注	字段名
//100000	请求成功	SUCCESS
//100001	请求失败	ERROR
//100002	需要登录	NEED_LOGIN
//100003	请求参数错误	ILLEGAL_ARGUMENT
//100004	验证码失效	TOKEN_EXPIRE

+ (void)checkErrorCode:(NSNumber *)code{
    NSLog(@"%@", code);
    
    switch ([code integerValue]) {
        
        case 100000:
            NSLog(@"请求成功	SUCCESS");
            break;
            case 100001:
            NSLog(@"请求失败	ERROR");
            break;
            case 100002:
            NSLog(@"需要登录	NEED_LOGIN");
            break;
            case 100003:
            NSLog(@"请求参数错误	ILLEGAL_ARGUMENT");
            break;
            case 100004:
            NSLog(@"验证码失效	TOKEN_EXPIRE");
            break;
        default:
            break;
    }
}

+(void)showWithCode:(NSInteger)code andInfo:(NSString *)info{
    NSLog(@"code = %ld info= %@", code, info);
    if (code == 100000) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showSuccessWithStatus:info];
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showInfoWithStatus:info];
    }
}

@end
