//
//  iFAlertController.m
//  iFootage
//
//  Created by 黄品源 on 2016/12/21.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFAlertController.h"

@implementation iFAlertController

+ (UIAlertController *)showAlertControllerWithTitle:(NSString *)title Message:(NSString *)message CancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle cancelAction:(void (^)(UIAlertAction *))cancelAction otherAction:(void (^)(UIAlertAction *))otherAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        cancelAction(action);
    }];
    UIAlertAction * other = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        otherAction(action);
        
    }];
    //     Add the actions.
    [alertController addAction:cancel];
    [alertController addAction:other];
    //
    return alertController;
}
+ (UIAlertController *)showAlertControllerWith:(NSString *)title Message:(NSString *)message SureButtonTitle:(NSString *)sureButtonTitle SureAction:(void (^)(UIAlertAction *))sureAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:sureButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureAction(action);
        
    }];
    [alertController addAction:sure];
    
    return alertController;
    
    
}


@end
