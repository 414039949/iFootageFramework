//
//  iFErrorCode.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/20.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface iFErrorCode : NSObject

+ (void)checkErrorCode:(NSNumber *)code;


+ (void)showWithCode:(NSInteger)code andInfo:(NSString *)info;

@end
