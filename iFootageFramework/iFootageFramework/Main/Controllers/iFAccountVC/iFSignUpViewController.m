//
//  iFSignUpViewController.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/19.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFSignUpViewController.h"
#import "iFNetWorking.h"
#import "iFErrorCode.h"
#import "SVProgressHUD.h"

@class iFLabel;

@interface iFSignUpViewController ()<UITextFieldDelegate>

{
    int startsecond;
    
}
@end

@implementation iFSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.IconImgView.alpha = 0;
    [self createUI];
}
- (void)createUI{
    
    iFLabel * signUpLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(122), iFSize(133), iFSize(130), iFSize(40)) WithTitle:NSLocalizedString(SignUpVC_SignUp, nil) andFont:iFSize(30)];
    signUpLabel.center = CGPointMake(kScreenWidth * 0.5, iFSize(133));
    [self.view addSubview:signUpLabel];
    
    
    self.usernameTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(244.5), iFSize(268), iFSize(25)) WithPlaceholderString:NSLocalizedString(SignUpVC_EmailAddress, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:NO];
    self.usernameTF.delegate = self;
    

    [self.view addSubview:self.usernameTF];
    
    self.verCodeTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(299.5), iFSize(145), iFSize(25)) WithPlaceholderString:NSLocalizedString(SignUpVC_VerificationCode, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:NO];
    self.verCodeTF.delegate = self;
    self.verCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.view addSubview:self.verCodeTF];
    
    self.getCodeBtn = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(228), iFSize(299), iFSize(120), iFSize(25)) andFounctionTitle:NSLocalizedString(SignUpVC_GetCode, nil) WithNormalColor:[UIColor whiteColor] andHighlightedColor:COLOR(163, 163, 163, 1)];
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
        self.getCodeBtn.frame = CGRectMake(iFSize(200), iFSize(299), iFSize(120), iFSize(25));
    }
    
    [self.getCodeBtn addTarget:self action:@selector(getCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.getCodeBtn.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:iFSize(18)];
    [self.view addSubview:self.getCodeBtn];
    
    self.passwordTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(355), iFSize(268), iFSize(25)) WithPlaceholderString:NSLocalizedString(SignUpVC_Password, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:YES];
    self.passwordTF.delegate = self;
    
    [self.view addSubview:self.passwordTF];
    
    self.checkPasswordTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(54.5), iFSize(410), iFSize(268), iFSize(25)) WithPlaceholderString:NSLocalizedString(SignUpVC_ConfirmPassword, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:YES];
    self.checkPasswordTF.delegate = self;
    
    [self.view addSubview:self.checkPasswordTF];
    
    self.nextBtn = [[iFButton alloc]initWithAccountVCFrame:CGRectMake(iFSize(25), iFSize(514.5), kScreenWidth * 0.8, iFSize(45)) andFoundtionTitle:NSLocalizedString(ForgotPwdVC_Next, nil)];
    
    [self.nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.nextBtn.center = CGPointMake(kScreenWidth * 0.5, iFSize(514.5));
    [self.view addSubview:self.nextBtn];
    
    iFButton * showsignInLabel = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(70), iFSize(622.5), iFSize(180), iFSize(18.5)) andFounctionTitle:NSLocalizedString(SignUpVC_HaveAccount, nil) WithNormalColor:COLOR(163, 163, 163, 1) andHighlightedColor:COLOR(163, 163, 163, 1)];
    [self.view addSubview:showsignInLabel];
    self.signInBtn = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(252), iFSize(622.5), iFSize(56.5), iFSize(18.5)) andFounctionTitle:NSLocalizedString(SignUpVC_SignIn, nil) WithNormalColor:[UIColor whiteColor] andHighlightedColor:COLOR(163, 163, 163, 1)];
    [self.signInBtn addTarget:self action:@selector(signInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signInBtn];
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.usernameTF resignFirstResponder];
    [self.verCodeTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.checkPasswordTF resignFirstResponder];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == self.usernameTF) {
        NSLog(@"嗯哼");
    }
    return YES;
}
- (void)checkValidiSExist:(NSString *)str{

    NSDictionary * dict = @{@"str":str};
    [iFNetWorking post:iFootageQueryCodePath params:dict success:^(id responseObj) {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
        NSLog(@"%@", dictData);
        [iFErrorCode showWithCode:[dictData[@"code"] integerValue] andInfo:dictData[@"msg"]];

        
    } failure:^(NSError *error) {
       
    }];
}

- (void)signInBtnAction:(iFButton *)btn{
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)getCodeBtnAction:(iFButton *)btn{
    
    
    startsecond = [[NSDate date] timeIntervalSince1970];
    btn.userInteractionEnabled = NO;
    NSDictionary * dict =@{@"email":self.usernameTF.text};
    NSLog(@"dict = %@", dict);

    if (self.usernameTF.text.length <= 0) {
        
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(SignUpVC_EmailNull, nil)];
        btn.userInteractionEnabled = YES;
    
        return;
    }
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
    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds %@", 60 - a, NSLocalizedString(SignUpVC_resend, nil)] forState:UIControlStateNormal];
    
    
    if (a >= 60) {
        [self.getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.getCodeBtn setTitle:NSLocalizedString(SignUpVC_GetCode, nil) forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = YES;
        timer.fireDate = [NSDate distantFuture];
        [timer invalidate];
        timer = nil;
    }
    
}
- (void)nextBtnAction:(iFButton *)btn{
    
    if (self.usernameTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(SignUpVC_EmailNull, nil)];
        return;
    }
    if (self.passwordTF.text.length <= 0) {
        NSLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(LoginVC_PasswordNull, nil)];
        return;
    }
    if (self.verCodeTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(SignUpVC_CodeNULL, nil)];
        
        return;
    }
    
    
    if ([self.passwordTF.text isEqualToString:self.checkPasswordTF.text] == YES) {
        
        NSDictionary * dict = @{@"email":self.usernameTF.text , @"validcode":self.verCodeTF.text, @"password":self.passwordTF.text, @"mobile":@"000000", @"type":@"1"};
        
        NSLog(@"dict = %@", dict);
        NSLog(@"password = %@", dict[@"password"]);
        
        [iFNetWorking post:iFootageRegisterPath params:dict success:^(id responseObj) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
            NSLog(@"===============%@",dictData);
            [iFErrorCode checkErrorCode:dictData[@"code"]];
            if ([dictData[@"code"] integerValue] == 100000) {
                [SVProgressHUD setMinimumDismissTimeInterval:1.2f];
                [SVProgressHUD showSuccessWithStatus:dictData[@"msg"]];
                NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:self.usernameTF.text forKey:@"username"];
                [ud synchronize];
                
                [self performSelector:@selector(signInBtnAction:) withObject:nil afterDelay:1.0f];

            }else{
                [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
                [SVProgressHUD showErrorWithStatus:dictData[@"msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
            [SVProgressHUD showErrorWithStatus:@"error"];
            
        }];

    }else{
        NSLog(@"两次输入的密码不一致");
    }
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
