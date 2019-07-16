//
//  iFAlertController.h
//  iFootage
//
//  Created by 黄品源 on 2016/12/21.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iFAlertController : NSObject


+ (UIAlertController *)showAlertControllerWithTitle:(NSString *)title Message:(NSString *)message CancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle cancelAction:(void(^)(UIAlertAction *action))cancelAction otherAction:(void(^)(UIAlertAction *action))otherAction;

+ (UIAlertController *)showAlertControllerWith:(NSString *)title Message:(NSString *)message SureButtonTitle:(NSString *)sureButtonTitle SureAction:(void (^)(UIAlertAction *))sureAction;


@end
