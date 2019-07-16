//
//  iFRootViewController.m
//  iFootage
//
//  Created by 黄品源 on 16/6/7.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "AppDelegate.h"
#import "iFScanViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "iFStatusBarView.h"

#import "Masonry.h"

@interface iFRootViewController ()

@end

@implementation iFRootViewController
//@synthesize connectBtn, rootbackBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    self.navigationController.navigationBar.hidden = YES;
    ;
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ];
    [UIViewController attemptRotationToDeviceOrientation];
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    
    
    UIImage *image = [UIImage imageNamed:@"rootBackground"];  UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [image drawInRect:self.view.bounds];
    UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:lastImage];
    //
    
    
    _connectBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24) andnormalImage:@"Vector smart object" andSelectedImage:@"Vector smart object"];
    [_connectBtn addTarget:self action:@selector(gotoScanViewController) forControlEvents:UIControlEventTouchUpInside];
    _connectBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_connectBtn];
    if (_ispresent == YES) {
        _connectBtn.alpha = 0;
    }
    _rootbackBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24) andnormalImage:@"sigleBack@2x" andSelectedImage:@"sigleBack@2x"];
    [_rootbackBtn addTarget:self action:@selector(backLastVC) forControlEvents:UIControlEventTouchUpInside];
    _rootbackBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_rootbackBtn];
    
    self.titleLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 20) WithTitle:@"" andFont:18];
    self.titleLabel.center = CGPointMake(self.view.frame.size.width / 2, 30);
    //    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.titleLabel];
}


- (void)viewWillLayoutSubviews{
//    [self setNeedsFocusUpdate];

    [super viewWillLayoutSubviews];
//    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
//
//    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
//        //翻转为竖屏时
////        [self VerticalscreenUI];
//        NSLog(@"竖屏isStatusBarHidden%d",[[UIApplication sharedApplication] isStatusBarHidden]);
//
//    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
//        //翻转为横屏时
//        NSLog(@"横屏isStatusBarHidden%d",[[UIApplication sharedApplication] isStatusBarHidden]);
//
////        [self LandscapescreenUI];
//
//    }
    
    
    
    CGFloat statusframeheight = [UIApplication sharedApplication].statusBarFrame.size.height + 20 ;
    CGFloat offsetvalue = 0.0f;
    
    NSNumber * number = [NSNumber numberWithFloat:statusframeheight];
    
    [iFStatusBarView sharedView];
//    NSLog(@"statusframeheight%f", statusframeheight);
    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        offsetvalue = -20;
    }else{
        if (kDevice_Is_iPhoneX) {
        offsetvalue = 30;
        }else{
        offsetvalue = 10;
        }
        
    }
    
    [_connectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([iFStatusBarView sharedView].mas_top).offset(-20);
        make.top.equalTo(number).offset(offsetvalue);
        make.right.equalTo([NSNumber numberWithInt:-5]);
        make.width.equalTo(@96);
        make.height.equalTo(@96);
    }];
    
    [_rootbackBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([iFStatusBarView sharedView].mas_top).offset(-20);
        make.top.equalTo(number).offset(offsetvalue);
        make.left.equalTo([NSNumber numberWithInt:-5]);
        make.width.equalTo(@96);
        make.height.equalTo(@96);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo([iFStatusBarView sharedView].mas_top).offset(10);
        make.top.equalTo(number);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    

    
    
}
- (void)backLastVC{
    if (self.ispresent == YES) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        
    [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)gotoScanViewController{
    iFScanViewController * svc = [[iFScanViewController alloc]init];
    [self presentViewController:svc animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate
{
    // 因为是取反值，所以返回NO的控制器，就可以旋转
    // 因为是取反值，不重写这个方法的控制器，默认就不支持旋转
    return NO;
}
//强制横屏
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

//强制竖屏
- (void)forceOrientationPortrait
{
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
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
