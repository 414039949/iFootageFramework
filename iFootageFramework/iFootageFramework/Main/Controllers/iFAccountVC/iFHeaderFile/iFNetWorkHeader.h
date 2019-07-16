//
//  iFNetWorkHeader.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/19.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#ifndef iFNetWorkHeader_h
#define iFNetWorkHeader_h

//[NSString stringWithFormat:@"%@%@",str , str1]



/**
 iFootage的NetHeader
https:45.32.52.159:8443/ifootage/account
 https://108.61.127.5:8443/ 日本

 @return return value description
 */

#define iFootageNetworkHeader @"https://108.61.127.5:8443/ifootage/account/"

#define iFootagePath(string) [NSString stringWithFormat:@"%@%@", iFootageNetworkHeader, string]


/**
 登录接口 login
 Error = 100000 成功
 = 100001 用户名不存在 或者 密码不正确
 
 else= 100003 error

 @return return value description
 */
//#define iFootageLoginPath [NSString stringWithFormat:@"%@%@",iFootageNetworkHeader , @"/login"]


#define iFootageLoginPath iFootagePath(@"login")
//http://120.76.163.78:8080/ifootage/account
/**
 发送邮箱验证码 sendVerifyEmail

 @return return value description
 */
#define iFootageNumberPath iFootagePath(@"sendVerifyEmail")

/**
 注册接口 register
 Error = 100000 成功
 = 100001 
 @return return value description
 */
#define iFootageRegisterPath iFootagePath(@"register")
/**
 登出操作 logout
 @return return value description
 */
#define iFootageLogoutPath  iFootagePath(@"logout")

/**
 查用户名 checkValid

 @return return value description
 */
#define iFootageQueryCodePath iFootagePath(@"checkValid")

/**
 获取用户信息 getUserInfo

 @return return value description
 */
#define iFootageGetUserInfoPath iFootagePath(@"getUserInfo")

/**
 重置密码 resetPassword

 @return return value description
 */
#define iFootageResetPasswordPath iFootagePath(@"resetPassword")

/**
 修改密码 modifyPassword

 @return return value description
 */
#define iFootageModifyPasswordPath iFootagePath(@"modifyPassword")



#endif /* iFNetWorkHeader_h */
