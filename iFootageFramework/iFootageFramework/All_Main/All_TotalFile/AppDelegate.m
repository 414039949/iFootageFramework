//
//  AppDelegate.m
//  iFootage
//
//  Created by 黄品源 on 16/6/7.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "iVersion.h"
#import "iFLoginViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "iFLeftViewController.h"

#import "iFHPYGetInfo.h"
#import "iFAll_MainViewController.h"

// 引入JPush功能所需头文件
#pragma mark ------jPush -----
//#import "JPUSHService.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#pragma mark ------jPush -----
//@interface AppDelegate ()<JPUSHRegisterDelegate>
@interface AppDelegate ()

@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate
@synthesize bleManager;


#pragma mark- JPUSHRegisterDelegate

+(AppDelegate *)sharedInstance{
    static AppDelegate *sharedInstance = nil;
    
    if (sharedInstance == nil)
    {
        sharedInstance = [[AppDelegate alloc] init];
        
//        bleManager = [[TIBLECBStandand alloc]init];
//        [bleManager controlSetup:1];
    }
    return sharedInstance;
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required

    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
#pragma mark ------jPush -----
//        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
#pragma mark ------jPush -----

        //        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
#pragma mark ------jPush -----

//    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
#pragma mark ------jPush -----

//    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
#pragma mark ------jPush -----

//    [JPUSHService registerDeviceToken:deviceToken];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Required
    
    
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
#pragma mark ------jPush -----

//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
#pragma mark ------jPush -----

//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
#pragma mark ------jPush -----

//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
#pragma mark ------jPush -----

//    [JPUSHService setupWithOption:launchOptions appKey:@"fc993269274d2a716f6023bd"
//                          channel:nil
//                 apsForProduction:YES
//            advertisingIdentifier:advertisingId];
    
    
    
    //设置你程序这个窗口的级别大于状态栏窗口的级别
    [UIApplication sharedApplication].keyWindow.windowLevel = UIWindowLevelStatusBar + 1.f;
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
//    //判断是否由远程消息通知触发应用程序启动
//    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
//        //获取应用程序消息通知标记数（即小红圈中的数字）
//        long int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
//        if (badge>0) {
//            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
//            badge--;
//            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
//            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
//        }
//    }
//    //消息推送注册
//    //    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        // IOS8 新系统需要使用新的代码
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings      settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }
//    else
//    {
//        [[UIApplication sharedApplication]registerForRemoteNotifications];
//
//    }
//
    
    NSLog(@"%lf %lf", kScreenWidth, kScreenHeight);
    
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    BOOL islogin = [ud boolForKey:LoginStauts];
    
//    NSLog(@"BOOL%d",   );
//    NSLog(@"UIApplicationStateRestorationUserInterfaceIdiomKey%lf", [UIScreen mainScreen].bounds.size.height);
//    
//    
//    if( IS_IPHONE )
//    {
//        // iphone处理
//        NSLog(@"iphone");
//    }
//    else
//    {
//        // ipad处理
//        NSLog(@"ipad");
//
//    }
    
#warning ---- 上线前确保isLogin为NO ------
    if (YES) {
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
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        [self.drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
            
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [[MMExampleDrawerVisualStateManager sharedManager]
                     drawerVisualStateBlockForDrawerSide:drawerSide];
            if(block){
                block(drawerController, drawerSide, percentVisible);
            }
        }];//侧滑效果
        self.window.rootViewController = self.drawerController;

   
        
    }else{
        iFLoginViewController * ifMVC = [[iFLoginViewController alloc]init];
        iFNavgationController * navifMVC = [[iFNavgationController alloc]initWithRootViewController:ifMVC];
        self.isForcePortrait = YES;
        self.isForceLandscape = NO;
        
        self.window.rootViewController = navifMVC;
        
    }
    
 
    
    [iVersion sharedInstance].appStoreID = 1214567080;
    
    
    [iVersion sharedInstance].updatePriority = iVersionUpdatePriorityMedium;
    bleManager = [[TIBLECBStandand alloc]init];
    [bleManager controlSetup:1];
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector(ServiceFoundOver:)
               name: @"SERVICEFOUNDOVER"
             object: nil];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StatusBarFrameisHidden:) name:@"StatusBarFrameisHiddenMethod" object:nil];
    return YES;
}
- (void)StatusBarFrameisHidden:(NSNotification *)noti{
    
    //    [self.statusBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //
    //        make.top.mas_equalTo(app.window.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
    //        make.right.mas_equalTo(app.window.mas_right);
    //        make.size.mas_equalTo(CGSizeMake(300, 20));
    //    }];
    
}
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusBarFrameisHiddenMethod" object:nil];
//    NSLog(@"%@", self.statusBarView);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LoginStauts] integerValue] == 1) {

        if (self.isForceLandscape) {

            return UIInterfaceOrientationMaskLandscape;
        }else if (self.isForcePortrait){
            return UIInterfaceOrientationMaskAll;
        }
    return UIInterfaceOrientationMaskAll;
//
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:LoginStauts] integerValue] == 0) {
    
        if (self.isForceLandscape) {
            return UIInterfaceOrientationMaskLandscape;
        }else if (self.isForcePortrait){
            return UIInterfaceOrientationMaskPortrait;
        }
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}
- (void)ServiceFoundOver:(id)sender
{
        [bleManager notification:0xFFC0 characteristicUUID:0xFFC2 p:bleManager.activePeripheral on:true];
//            [bleManager writeValue:0xFFC0 characteristicUUID:0xFFC1 p:bleManager.activePeripheral data:[@"123456123456" dataUsingEncoding:NSUTF8StringEncoding]];
//            [bleManager writeValue:0xFFC0 characteristicUUID:0xFFC1 p:bleManager.activePeripheral data:[@"123456000000" dataUsingEncoding:NSUTF8StringEncoding]];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    UIApplication*   app = [UIApplication sharedApplication];
//    __block    UIBackgroundTaskIdentifier bgTask;
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{            if (bgTask != UIBackgroundTaskInvalid)
//        {
//            bgTask = UIBackgroundTaskInvalid;
//        }
//        });
//    }];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{            if (bgTask != UIBackgroundTaskInvalid)
//        {
//            bgTask = UIBackgroundTaskInvalid;
//        }
//        });
//    });

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)registUILocalNotification:(UIApplication *)application {
    // 创建一个本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    //设置172800秒之后
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:5];
    
    if (notification != nil) {//判断系统是否支持本地通知
        // 设置推送时间
        notification.fireDate = pushDate;
        
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        // 设置重复间隔
        notification.repeatInterval = kCFCalendarUnitDay;
        
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 推送内容
        notification.alertBody = @"哈哈哈";
        
        // 解锁按钮文字
        notification.alertAction = @"挑战一下";
        
        
        // 显示在icon上的红色圈中的数子
        notification.applicationIconBadgeNumber = 0;
        
        // 设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name"forKey:@"key"];
        notification.userInfo = info;
        
        //添加推送到UIApplication
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        //        [notification release];
    }
}


@end
