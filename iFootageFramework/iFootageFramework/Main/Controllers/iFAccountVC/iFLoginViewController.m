//
//  iFLoginViewController.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/19.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFLoginViewController.h"
#import "iFMainViewController.h"
#import "iFSignUpViewController.h"
#import "NSString+MD5.h"
#import "iFNetWorking.h"
#import "iFForgotPwdViewController.h"
#import "SVProgressHUD.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "AppDelegate.h"
#import "iFNetWorkHeader.h"
#import "iFLeftViewController.h"
#import "iFErrorCode.h"
#import "iFAll_MainViewController.h"


@interface iFLoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation iFLoginViewController
{
    NSUserDefaults * ud;
        
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
}

- (void)createUI{
    ud = [NSUserDefaults standardUserDefaults];

    self.loginBtn = [[iFButton alloc]initWithAccountVCFrame:CGRectMake(iFSize(25), iFSize(424.5), AutoKscreenWidth * 0.8, iFSize(45)) andFoundtionTitle:NSLocalizedString(LoginVC_SignIn, nil)];
    [self.loginBtn setTitle:NSLocalizedString(LoginVC_SignIn, nil) forState:UIControlStateNormal];
    self.loginBtn.center = CGPointMake(AutoKscreenWidth * 0.5, iFSize(424.5));
    
    [self.loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    
    self.usernameTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(83.5), iFSize(340), iFSize(210), iFSize(25)) WithPlaceholderString:NSLocalizedString(LoginVC_EmailAddress, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:NO];
    self.usernameTF.center = CGPointMake(AutoKscreenWidth * 0.5, iFSize(340));
    
    
    self.usernameTF.delegate = self;
    self.usernameTF.text = [ud objectForKey:@"username"];
    [self.view addSubview:self.usernameTF];
    
    self.passwordTF = [[iFTextField alloc]initWithFrame:CGRectMake(iFSize(83.5), iFSize(383), iFSize(210), iFSize(25)) WithPlaceholderString:NSLocalizedString(LoginVC_Password, nil) WithTitleImg:nil WithBackgroundImg:nil setSecurtEntry:YES];
    self.passwordTF.center = CGPointMake(AutoKscreenWidth * 0.5, iFSize(383));
    
    [self.view addSubview:self.passwordTF];
    
    self.forgotBtn = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(120), iFSize(480), iFSize(133), iFSize(23.5)) andFounctionTitle:NSLocalizedString(LoginVC_ForgotPassword, nil) WithNormalColor:COLOR(163, 163, 163, 1) andHighlightedColor:[UIColor whiteColor]];
    self.forgotBtn.center = CGPointMake(AutoKscreenWidth * 0.5, iFSize(480));
    [self.forgotBtn addTarget:self action:@selector(forgotPwdBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.forgotBtn];
    //    "NoAcountLogin"         = "Offline login";
    
    self.noPasswordLogin = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(120), iFSize(520), iFSize(133), iFSize(23.5)) andFounctionTitle:NSLocalizedString(@"NoAcountLogin", nil) WithNormalColor:COLOR(163, 163, 163, 1) andHighlightedColor:[UIColor whiteColor]];
    self.noPasswordLogin.center = CGPointMake(AutoKscreenWidth * 0.5, iFSize(520));
    [self.noPasswordLogin addTarget:self action:@selector(gotoMainVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.noPasswordLogin];
    
    
    self.signUpBtn = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(240), iFSize(622.5), iFSize(56.5), iFSize(18.5)) andFounctionTitle:NSLocalizedString(LoginVC_SignUp, nil) WithNormalColor:[UIColor whiteColor] andHighlightedColor:[UIColor grayColor]];
    [self.signUpBtn addTarget:self action:@selector(signUpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.signUpBtn];
    
    
    iFButton * showSignlabel = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(75), iFSize(622.5), iFSize(163), iFSize(18.5)) andFounctionTitle:NSLocalizedString(LoginVC_NOaccount, nil)  WithNormalColor:COLOR(163, 163, 163, 1) andHighlightedColor:COLOR(163, 163, 163, 1)];
    [self.view addSubview:showSignlabel];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];

    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        NSLog(@"viewWillLayoutSubviews1");

        [self VerticalscreenUI];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        NSLog(@"viewWillLayoutSubviews2");

        [self LandscapescreenUI];
    }
}
- (void)VerticalscreenUI{
 
    
    
}
- (void)LandscapescreenUI{
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == self.usernameTF) {
        NSLog(@"嗯哼");
        [ud setObject:self.usernameTF.text forKey:@"username"];
    }
    return YES;
}

- (void)forgotPwdBtnAction:(iFButton *)btn{
    iFForgotPwdViewController * forgotVC = [[iFForgotPwdViewController alloc]init];
    [self.navigationController pushViewController:forgotVC animated:YES];
    
}
- (void)signUpBtnAction:(iFButton *)btn{
    iFSignUpViewController * ifsignVC = [[iFSignUpViewController alloc]init];
    [self.navigationController pushViewController:ifsignVC animated:YES];
    
}
- (void)loginBtnAction:(iFButton *)btn{
    
    if (self.usernameTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(LoginVC_EmailNull, nil)];
        return;
    }
    if (self.passwordTF.text.length <= 0) {
        NSLog(@"密码不能为空");
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(LoginVC_PasswordNull, nil)];
        
        return;
    }
    
    
    [SVProgressHUD showWithStatus:NSLocalizedString(LoginVC_waiting, nil)];
    
    NSDictionary * dict = @{@"username":self.usernameTF.text , @"password":[self.passwordTF.text md5:self.passwordTF.text], @"type":@"1"};
    NSLog(@"dict = %@", dict);
    NSLog(@"password = %@", dict[@"password"]);
    
    [iFNetWorking post:iFootageLoginPath params:dict success:^(id responseObj) {
        
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
        NSLog(@"===============%@",dictData[@"msg"]);
        if ([dictData[@"code"] integerValue] == 100000) {
            [self gotoMainVC];
        }
        [iFErrorCode showWithCode:[dictData[@"code"] integerValue] andInfo:dictData[@"msg"]];
        
    } failure:^(NSError *error) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(LoginVC_LoginFailed, nil)];
        
        NSLog(@"%@", error);
    }];
}
- (void)gotoMainVC{
    [ud setBool:YES forKey:LoginStauts];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    iFLeftViewController * leftVC = [[iFLeftViewController alloc]init];
    
    if (IS_Mini) {
        iFMainViewController * ifMVC = [[iFMainViewController alloc]init];
        iFNavgationController * navifMVC = [[iFNavgationController alloc]initWithRootViewController:ifMVC];
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:navifMVC leftDrawerViewController:leftVC];


    }else{
        iFAll_MainViewController * ifMVC = [[iFAll_MainViewController alloc]init];
        iFNavgationController * navifMVC = [[iFNavgationController alloc]initWithRootViewController:ifMVC];
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:navifMVC leftDrawerViewController:leftVC];
    }
    [self.drawerController setShowsShadow:YES];
    CGFloat leftDrawerWidth = 0.0f;
    if (kDevice_Is_iPad) {
        leftDrawerWidth = AutoKscreenWidth / 2;
    }else{
        leftDrawerWidth = AutoKscreenWidth - 100;
    }
    [self.drawerController setMaximumLeftDrawerWidth:leftDrawerWidth];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningCenterView];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];//侧滑效果
    
    app.window.rootViewController = self.drawerController;
    

}

- (void)dealloc{
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"StatusBarFrameisHiddenMethod" object:nil];
}
#pragma mark -----横竖屏切换 ------------
#pragma  mark 横屏设置
//强制横屏
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

- (void)viewWillAppear:(BOOL)animated{
    
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    
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
