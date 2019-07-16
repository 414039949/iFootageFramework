//
//  iFForgotPwdViewController.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/20.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFAccountRootViewController.h"
#import "iFTextField.h"
#import "iFButton.h"

@interface iFForgotPwdViewController : iFAccountRootViewController



@property (nonatomic, strong)iFTextField * usernameTF;
@property (nonatomic, strong)iFTextField * verCodeTF;
@property (nonatomic, strong)iFTextField * passwordTF;
@property (nonatomic, strong)iFButton * nextBtn;
@property (nonatomic, strong)iFButton * getCodeBtn;



@end

