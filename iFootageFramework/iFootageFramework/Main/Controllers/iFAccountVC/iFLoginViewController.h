//
//  iFLoginViewController.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/19.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFAccountRootViewController.h"
#import "iFTextField.h"
#import "iFButton.h"


@interface iFLoginViewController : iFAccountRootViewController

@property (nonatomic, strong)iFButton * loginBtn;
@property (nonatomic, strong)iFButton * forgotBtn;
@property (nonatomic, strong)iFButton * signUpBtn;


@property (nonatomic, strong)iFTextField * usernameTF;
@property (nonatomic, strong)iFTextField * passwordTF;

@property (nonatomic, strong)iFButton * noPasswordLogin;


@end
