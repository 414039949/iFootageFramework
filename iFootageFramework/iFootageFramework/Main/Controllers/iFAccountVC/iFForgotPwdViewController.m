//
//  iFForgotPwdViewController.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/20.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFForgotPwdViewController.h"
#import "iFLabel.h"
#import "iFNetWorking.h"
#import "iFErrorCode.h"
#import "SVProgressHUD.h"

@interface iFForgotPwdViewController ()<UITextFieldDelegate>

{
    int startsecond;

}
@end

@implementation iFForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.IconImgView.alpha = 0;
    
    [self createUI];
}
- (void)createUI{
    
    iFLabel * titleLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(133), iFSize(268), iFSize(40)) WithTitle:NSLocalizedString(ForgotPwdVC_ForgotPassword, nil) andFont:iFSize(30)];
    titleLabel.center = CGPointMake(kScreenWidth * 0.5, iFSize(133));
    [self.view addSubview:titleLabel];
    
    self.usernameTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(244.5), iFSize(268), iFSize(25)) WithPlaceholderString:NSLocalizedString(ForgotPwdVC_EmailAddress, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:NO];
    self.usernameTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.view addSubview:self.usernameTF];
    
    self.verCodeTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(299.5), iFSize(145), iFSize(25)) WithPlaceholderString:NSLocalizedString(ForgotPwdVC_Verification, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:NO];
    self.verCodeTF.delegate = self;
    self.verCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.verCodeTF];
    
    self.getCodeBtn = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(228), iFSize(299), iFSize(120), iFSize(25)) andFounctionTitle:NSLocalizedString(ForgotPwdVC_GetCode, nil) WithNormalColor:[UIColor whiteColor] andHighlightedColor:COLOR(163, 163, 163, 1)];
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        self.getCodeBtn.frame = CGRectMake(iFSize(200), iFSize(299), iFSize(120), iFSize(25));
        
    }
    [self.getCodeBtn addTarget:self action:@selector(getCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.getCodeBtn.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:iFSize(18)];
    [self.view addSubview:self.getCodeBtn];
    
    self.passwordTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(355), iFSize(268), iFSize(25)) WithPlaceholderString:NSLocalizedString(ForgotPwdVC_Password, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:YES];
    self.passwordTF.delegate = self;
    self.passwordTF.keyboardType = UIKeyboardTypeAlphabet;
    [self.view addSubview:self.passwordTF];
    
    self.nextBtn = [[iFButton alloc]initWithAccountVCFrame:CGRectMake(iFSize(25), iFSize(514.5), kScreenWidth * 0.8, iFSize(45)) andFoundtionTitle:NSLocalizedString(ForgotPwdVC_Next, nil)];
    self.nextBtn.center = CGPointMake(kScreenWidth * 0.5, iFSize(514.5));
    
    [self.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    iFButton * cancelBtn = [[iFButton alloc]initWithAttentionFrame:CGRectMake(0, 0, iFSize(56.5), iFSize(18.5)) andFounctionTitle:NSLocalizedString(ForgotPwdVC_Cancel, nil) WithNormalColor:[UIColor whiteColor] andHighlightedColor:COLOR(163, 163, 163, 1)];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cancelBtn.center = CGPointMake(kScreenWidth * 0.5, iFSize(600));
    [self.view addSubview:cancelBtn];
    
    
    

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.verCodeTF resignFirstResponder];
    
}
- (void)cancelBtnAction:(iFButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getCodeBtnAction:(iFButton *)btn{
    
    
//    NSLog(@"dict = %@", dict);
//    
//    if (self.usernameTF.text.length <= 0) {
//        
//        [SVProgressHUD showErrorWithStatus:@"Email cannot be empty"];
//        btn.userInteractionEnabled = YES;
//        
//        return;
//    }
//    NSTimer * countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(count60sRegetCode:) userInfo:nil repeats:YES];
//    countTimer.fireDate = [NSDate distantPast];
//    
//    [iFNetWorking post:iFootageNumberPath params:dict success:^(id responseObj) {
//        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
//        NSLog(@"===============%@",dictData);
//        
//        [iFErrorCode showWithCode:[dictData[@"code"] integerValue] andInfo:dictData[@"msg"]];
//        if ([dictData[@"code"] integerValue] == 100000) {
//            
//            
//        }
//        
//    } failure:^(NSError *error) {
//        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
//        [SVProgressHUD showInfoWithStatus:@"error"];
//        btn.userInteractionEnabled = YES;
//        NSLog(@"error == %@", error);
//    }];
    btn.userInteractionEnabled = NO;
    startsecond = [[NSDate date] timeIntervalSince1970];
    
    if (self.usernameTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(ForgotPwdVC_EmailNULL, nil)];
        return;
    }
    
    NSDictionary * dict =@{@"email":self.usernameTF.text};
    NSLog(@"dict = %@", dict);
    
    NSTimer * countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(count60sRegetCode:) userInfo:nil repeats:YES];
    countTimer.fireDate = [NSDate distantPast];
    
    [iFNetWorking post:iFootageNumberPath params:dict success:^(id responseObj) {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
        NSLog(@"===============%@",dictData);
        [iFErrorCode showWithCode:[dictData[@"code"] integerValue] andInfo:dictData[@"msg"]];
        if ([dictData[@"code"] integerValue] == 100000) {
           
        }

        
    } failure:^(NSError *error) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showInfoWithStatus:@"error"];
        btn.userInteractionEnabled = YES;
        NSLog(@"error == %@", error);
    }];
}
- (void)count60sRegetCode:(NSTimer *)timer{
    int msecond = [[NSDate date] timeIntervalSince1970];
    NSLog(@"%d", msecond - startsecond);
    int a = msecond - startsecond;
    
    [self.getCodeBtn setTitleColor:[UIColor groupTableViewBackgroundColor] forState:UIControlStateNormal];
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds %@", 60 - a, NSLocalizedString(ForgotPwdVC_resend, nil)] forState:UIControlStateNormal];
    
    if (a >= 60) {
        [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.getCodeBtn setTitle:NSLocalizedString(ForgotPwdVC_GetCode, nil) forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = YES;
        timer.fireDate = [NSDate distantFuture];
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)nextBtnAction:(iFButton *)btn{
    
    
    NSDictionary * dict = @{@"email":self.usernameTF.text , @"validcode":self.verCodeTF.text, @"passwordnew":self.passwordTF.text};
    NSLog(@"dict = %@", dict);
    
        [iFNetWorking post:iFootageResetPasswordPath params:dict success:^(id responseObj) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
            NSLog(@"===============%@",dictData);
            [iFErrorCode showWithCode:[dictData[@"code"] integerValue] andInfo:dictData[@"msg"]];
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
