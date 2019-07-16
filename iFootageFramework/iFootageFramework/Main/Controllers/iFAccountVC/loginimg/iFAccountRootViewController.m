//
//  iFAccountRootViewController.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/19.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFAccountRootViewController.h"
#import "iFNavgationController.h"
@interface iFAccountRootViewController ()

@end

@implementation iFAccountRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loginBackGround@2x"]];
    UIImageView * backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginBackGround"]];
    backView.userInteractionEnabled = YES;
    backView.frame = CGRectMake(0, 0, AutoKscreenWidth, AutoKScreenHeight);
    self.view = backView;
    
    self.IconImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginIcon"]];
    self.IconImgView.frame = CGRectMake(0, 0, 120, 120);
    self.IconImgView.layer.masksToBounds = YES;
    
    self.IconImgView.backgroundColor = [UIColor clearColor];
    self.IconImgView.layer.cornerRadius = 60;
    self.IconImgView.center = CGPointMake(AutoKscreenWidth * 0.5, AutoKScreenHeight * 0.2);
    [self.view addSubview:self.IconImgView];
}
- (BOOL)shouldAutorotate{
    return YES;
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
