//
//  iFAll_MainViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFAll_MainViewController.h"
#import "iFS1A3_MainViewController.h"
#import "iFMainViewController.h"
#import "iFLeftViewController.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "iFS1A3_TimelineViewController.h"
#import "iF3DButton.h"



@interface iFAll_MainViewController ()
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation iFAll_MainViewController
{
    AppDelegate * app;
    UIImageView * backimgaeView;
    iF3DButton * S1A3Btn;
    iF3DButton * SharkMiniBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    backimgaeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rootBackground"]];
    backimgaeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backimgaeView];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [backimgaeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(self.view);
        
    }];
    
    S1A3Btn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100) WithTitle:nil selectedIMG:@"S1A3" normalIMG:@"S1A3"];
    S1A3Btn.backgroundColor = [UIColor clearColor];
    
    S1A3Btn.actionBtn.tag = 100;
    
    [S1A3Btn.actionBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:S1A3Btn];
    
    SharkMiniBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100) WithTitle:nil selectedIMG:@"SharkMini" normalIMG:@"SharkMini"];
    SharkMiniBtn.actionBtn.tag = 101;

    [SharkMiniBtn.actionBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SharkMiniBtn];
    
    [S1A3Btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [SharkMiniBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
//    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    btn1.backgroundColor = [UIColor redColor];
//    [btn1 setTitle:@"S1A3" forState:UIControlStateNormal];
//    btn1.tag = 100;
//
//    [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];
//
//
//    UIButton * btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 250, 100, 100)];
//    btn2.backgroundColor = [UIColor blueColor];
//    [btn2 setTitle:@"Shark Mini" forState:UIControlStateNormal];
//    btn2.tag = 101;
//
//    [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn2];
//
    
    
}
- (void)btnAction:(UIButton *)btn{
    if (btn.tag == 100) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginStauts];
        [[NSUserDefaults standardUserDefaults] setObject:@"S1A3" forKey:S1A3orMiniID];
        
        
        iFLeftViewController * leftVC = [[iFLeftViewController alloc]init];
        
        iFS1A3_MainViewController * ifMVC = [[iFS1A3_MainViewController alloc]init];
        iFNavgationController * navifMVC = [[iFNavgationController alloc]initWithRootViewController:ifMVC];
        
        
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:navifMVC leftDrawerViewController:leftVC];
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
        
        
    }else if (btn.tag == 101){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LoginStauts];
        [[NSUserDefaults standardUserDefaults] setObject:@"SharkMini" forKey:S1A3orMiniID];

        
        iFLeftViewController * leftVC = [[iFLeftViewController alloc]init];
        
        iFMainViewController * ifMVC = [[iFMainViewController alloc]init];
        iFNavgationController * navifMVC = [[iFNavgationController alloc]initWithRootViewController:ifMVC];
        
        
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:navifMVC leftDrawerViewController:leftVC];
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
//    [self setConnectBtn];

}

- (void)setConnectBtn{
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(200, 0, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [app.window addSubview:btn];
    
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
