//
//  NSString+MD5.h
//  iFNetWorkingTest
//
//  Created by 黄品源 on 2017/6/17.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

@interface NSString (MD5)
- (id)MD5;
- (NSString *)md5:(NSString *)str;

@end
