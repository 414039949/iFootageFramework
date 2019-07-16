//
//  iFSignUpViewController.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/19.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFAccountRootViewController.h"
#import "iFTextField.h"
#import "iFButton.h"
#import "iFLabel.h"


@interface iFSignUpViewController : iFAccountRootViewController



@property (nonatomic, strong)iFTextField * usernameTF;
@property (nonatomic, strong)iFTextField * passwordTF;
@property (nonatomic, strong)iFTextField * verCodeTF;
@property (nonatomic, strong)iFTextField * checkPasswordTF;
@property (nonatomic, strong)iFButton * nextBtn;
@property (nonatomic, strong)iFButton * getCodeBtn;
@property (nonatomic, strong)iFButton * signInBtn;

@end
