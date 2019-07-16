//
//  iFLeftViewController.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/20.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFLeftViewController.h"
#import "AppDelegate.h"
#import "iFLoginViewController.h"
#import "AppDelegate.h"
#import "iFNavgationController.h"
#import "iFNetWorking.h"

@interface iFLeftViewController ()

@end

@implementation iFLeftViewController
{
    NSUserDefaults * ud;
    iFLabel * versionLabel;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ud = [NSUserDefaults standardUserDefaults];

    self.IconImgView.alpha = 0;
    self.logoutBtn = [[iFButton alloc]initWithAccountVCFrame:CGRectMake(iFSize(25), iFSize(514.5), 225, 45) andFoundtionTitle:NSLocalizedString(LeftVC_logout, nil)];
    
    [self.logoutBtn addTarget:self action:@selector(logoutBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.logoutBtn];
    
    
    self.userIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iFSize(107.5), iFSize(75), 60, 60)];
    self.userIconImageView.image = [UIImage imageNamed:@"userIcon"];
    [self.view addSubview:self.userIconImageView];
    
    self.usernameBtn = [[iFButton alloc]initWithAttentionFrame:CGRectMake(iFSize(100), iFSize(150), 75, 19) andFounctionTitle:@"iFootage" WithNormalColor:COLOR(120, 120, 120, 1) andHighlightedColor:COLOR(120, 120, 120, 1)];
    [self.view addSubview:self.usernameBtn];
    
    
    NSBundle * bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(183), iFSize(638), 78, 15) WithTitle:[NSString stringWithFormat:@"Version:%@", bundle] andFont:12];
    [self.view addSubview:versionLabel];

}

- (void)viewWillLayoutSubviews{
    CGFloat kWidth = 0.0f;
    if (kDevice_Is_iPad) {
        kWidth = AutoKscreenWidth / 2;
    }else{
        kWidth = AutoKscreenWidth - 100;
    }
//    [self.logoutBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(200, 45));
//        
//    }];
    [versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(80, 15));
    }];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
   
    [iFNetWorking post:iFootageGetUserInfoPath params:nil success:^(id responseObj) {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
        NSLog(@"===============%@",dictData);

    } failure:^(NSError *error) {
        
    }];
}

- (void)logoutBtnAction:(iFButton *)btn{
   
#warning  ----写入磁盘延迟 -------
    NSDictionary * dict;
    
    if ([ud objectForKey:@"username"]) {
        dict = @{@"username":[ud objectForKey:@"username"]};
    }
    [iFNetWorking post:iFootageLogoutPath params:dict success:^(id responseObj) {
        NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
        NSLog(@"===============%@",dictData);
    } failure:^(NSError *error) {
        
    }];
    
    [ud setBool:NO forKey:LoginStauts];
    [ud synchronize];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
 
    iFLoginViewController * ifMVC = [[iFLoginViewController alloc]init];
    iFNavgationController * navifMVC = [[iFNavgationController alloc]initWithRootViewController:ifMVC];
    app.window.rootViewController = navifMVC;
    app.isForcePortrait = YES;
    app.isForceLandscape = NO;
    

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
