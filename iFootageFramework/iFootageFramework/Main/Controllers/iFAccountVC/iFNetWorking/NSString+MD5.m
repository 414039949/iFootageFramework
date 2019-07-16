//
//  NSString+MD5.m
//  iFNetWorkingTest
//
//  Created by 黄品源 on 2017/6/17.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

- (id)MD5
{
        const char *cStr = [self UTF8String];
        unsigned char digest[16];
        unsigned int x=(int)strlen(cStr) ;
    
        CC_MD5( cStr, x, digest );
    
         // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
         for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                 [output appendFormat:@"%02x", digest[i]];
    
    
         return  output;
}
- (NSString *)md5:(NSString *)str
{
    const char *cStrValue = [str UTF8String];
    unsigned char theResult[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStrValue, (unsigned)strlen(cStrValue), theResult);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            theResult[0], theResult[1], theResult[2], theResult[3],
            theResult[4], theResult[5], theResult[6], theResult[7],
            theResult[8], theResult[9], theResult[10], theResult[11],
            theResult[12], theResult[13], theResult[14], theResult[15]];
}

@end
