//
//  iFNavgationController.m
//  iFootage
//
//  Created by 黄品源 on 16/6/7.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFNavgationController.h"
#import "iFButton.h"
#import "iFScanViewController.h"

@interface iFNavgationController ()

@end

@implementation iFNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Regular" size:17]};
    
    self.navigationBar.tintColor = [UIColor whiteColor];
//
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = COLOR(66, 66, 66, 1);
    
    NSLog(@"navigationBar%@", self.navigationBar);
    
    //设置你程序这个窗口的级别大于状态栏窗口的级别
//    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar + 1.f;
//    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    label.backgroundColor = [UIColor redColor];
//    [self.view addSubview:label];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - - orientation
//设置是否允许自动旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return self.interfaceOrientationMask;
    
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return self.interfaceOrientation;
}

//- (NSUInteger)supportedInterfaceOrientations {
//    return [self.viewControllers.lastObject supportedInterfaceOrientations];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
