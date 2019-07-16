//
//  iFS1A3_MainViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_MainViewController.h"
#import "iFS1A3_ManualViewController.h"
#import "iFS1A3_TargetViewController.h"
#import "iFS1A3_SettingsViewController.h"
#import "iFS1A3_TimelineViewController.h"
#import "iFS1A3_CommunityViewController.h"
#import "iFS1A3_SavePathViewController.h"
#import "iFS1A3_StitchingViewController.h"
#import "iFScanViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "iFAlertController.h"
#import "ReceiveView.h"
#import "AppDelegate.h"
#import "iFMainView.h"
#import "iFLabel.h"
#import "iFButton.h"
#import "iFStatusBarView.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "SVProgressHUD.h"
#import "ListView.h"
#import "iFCirleViewController.h"
#import "iFGetDataTool.h"
#import "AppDelegate.h"

#import <Masonry/Masonry.h>
@interface iFS1A3_MainViewController ()
@property (nonatomic, strong)UIButton * TimelineBtn;
@property (nonatomic, strong)UIButton * ManualBtn;
@property (nonatomic, strong)UIButton * TargetBtn;
@property (nonatomic, strong)UIButton * StitchingBtn;
@property (nonatomic, strong)UIButton * SettingsBtn;
@property (nonatomic, strong)UIButton * CommunityBtn;
@property (nonatomic, strong)ReceiveView * receiveView;
@property (nonatomic, strong)SendDataView * sendDataView;

@end

@implementation iFS1A3_MainViewController
{
    UIImageView * iconView;
    UIImageView * titleView;
    NSTimer * S1A3_receiveTimer;
    NSTimer * S1A3_24Gtimer;
    AppDelegate * appDelegate;
    NSInteger Encode;
    UInt64 recordTime;
    iFButton * MenuBtn;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootbackBtn.alpha = 0;
    
    _receiveView = [ReceiveView sharedInstance];
    _sendDataView = [[SendDataView alloc]init];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.titleLabel.text = @"S1A3 Main";
    [self createUI];
}

- (void)createUI{
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(69), iFSize(69))];
    iconView.image = [UIImage imageNamed:@"ifootage_icon@3x"];
    [self.view addSubview:iconView];
    
    titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(93), iFSize(14))];
    titleView.image = [UIImage imageNamed:@"IFOOTAGE1@3x"];
    [self.view addSubview:titleView];
    
    /**
     创建左侧按钮 待开发
     */
    MenuBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24) andnormalImage:@"Menu" andSelectedImage:@"Menu"];
    //还未添加相应事件
    [MenuBtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:MenuBtn];

    
    NSArray * array = @[main_TIMELINEIMG, main_MANUALCTLIMG, main_TARGETCTLIMG, main_STITCHINGIMG, main_SETTINGSIMG, main_COMMUNITY];
    NSArray * titleArray =  @[NSLocalizedString(@"Timeline Control", nil), NSLocalizedString(@"Manual Control", nil), NSLocalizedString(@"Target Control", nil), NSLocalizedString(@"Stitching", nil), NSLocalizedString(@"Settings", nil), NSLocalizedString(@"Community", nil)];
    self.TimelineBtn = [self getFatherButtonWithTitle:titleArray[0] andImageName:array[0] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(timelineBtnAction:)];
    self.ManualBtn = [self getFatherButtonWithTitle:titleArray[1] andImageName:array[1] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(manualBtnAction:)];
    self.TargetBtn = [self getFatherButtonWithTitle:titleArray[2] andImageName:array[2] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(targetBtnAction:)];
    self.StitchingBtn = [self getFatherButtonWithTitle:titleArray[3] andImageName:array[3] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(stitchingBtnAction:)];
    self.SettingsBtn = [self getFatherButtonWithTitle:titleArray[4] andImageName:array[4] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(settingsBtnAction:)];
    self.CommunityBtn = [self getFatherButtonWithTitle:titleArray[5] andImageName:array[5] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(commnityBtnAction:)];
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
//iFS1A3_TimelineViewController 上一级界面 ——> iFS1A3_SavePathViewController
- (void)timelineBtnAction:(UIButton *)btn{
    iFS1A3_SavePathViewController * savepath = [[iFS1A3_SavePathViewController alloc]init];
    [self.navigationController pushViewController:savepath animated:YES];
}
- (void)manualBtnAction:(UIButton *)btn{
    iFS1A3_ManualViewController * timelineVC = [[iFS1A3_ManualViewController alloc]init];
    [self.navigationController pushViewController:timelineVC animated:YES];
}
- (void)targetBtnAction:(UIButton *)btn{
    iFS1A3_TargetViewController * targetVC = [[iFS1A3_TargetViewController alloc]init];
    [self.navigationController pushViewController:targetVC animated:YES];
}
- (void)stitchingBtnAction:(UIButton *)btn{
    iFS1A3_StitchingViewController * stitchingVC = [[iFS1A3_StitchingViewController alloc]init];
    [self.navigationController pushViewController:stitchingVC animated:YES];
}
- (void)settingsBtnAction:(UIButton *)btn{
    iFS1A3_SettingsViewController * settingsVC = [[iFS1A3_SettingsViewController alloc]init];
    [self.navigationController pushViewController:settingsVC animated:YES];
}
- (void)commnityBtnAction:(UIButton *)btn{
    iFS1A3_CommunityViewController * commnityVC = [[iFS1A3_CommunityViewController alloc]init];
    [self.navigationController pushViewController:commnityVC animated:YES];
}
- (void)VerticalscreenUI{
    [MenuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([iFStatusBarView sharedView].mas_top).offset(20);
        
        make.left.equalTo(@24);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    
    
    CGFloat width = AutoKscreenWidth * 0.3;
    CGFloat limitDistance;
    if (kDevice_Is_iPhoneX) {
        limitDistance = 20;
    }else{
        limitDistance = 12;
    }
    [iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(69);
        iconView.alpha = 1;
        
    }];
    [titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(93, 14));
        titleView.alpha = 1;
        
    }];
    
    [self.TimelineBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(titleView.mas_bottom).offset(limitDistance);
        make.size.mas_equalTo(width);
    }];
    [self.ManualBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(self.TimelineBtn);
        make.size.mas_equalTo(width);
    }];
    
    [self.TargetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.TimelineBtn.mas_bottom).offset(limitDistance);
        make.centerX.equalTo(self.TimelineBtn);
        make.size.mas_equalTo(width);
    }];
    
    [self.StitchingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.TargetBtn);
        make.centerX.equalTo(self.ManualBtn);
        make.size.mas_equalTo(width);
    }];
    [self.SettingsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.TargetBtn.mas_bottom).offset(limitDistance);
        make.centerX.equalTo(self.TimelineBtn);
        make.size.mas_equalTo(width);

    }];
    [self.CommunityBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.SettingsBtn);
        make.centerX.equalTo(self.ManualBtn);
        make.size.mas_equalTo(width);
    }];
    
    
    
}
- (void)LandscapescreenUI{
    [MenuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([iFStatusBarView sharedView].mas_top).offset(20);
        
        make.left.equalTo(@24);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    
    
    CGFloat width = AutoKscreenWidth * 0.3;
    [iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(AutoKscreenWidth * 0.5);
        make.centerY.mas_equalTo(AutoKScreenHeight * 0.2);
        make.size.mas_equalTo(69);
        iconView.alpha = 0;
        
    }];
    [titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(AutoKscreenWidth * 0.5);
        make.centerY.mas_equalTo(AutoKScreenHeight * 0.26);
        make.size.mas_equalTo(CGSizeMake(93, 14));
        titleView.alpha = 0;
        
    }];
    [self.TimelineBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(50);
        make.size.mas_equalTo(width);
    }];
    [self.ManualBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.TimelineBtn);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(width);
    }];
    [self.TargetBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(self.TimelineBtn);
        make.size.mas_equalTo(width);
    }];
    
    [self.StitchingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-50);
        make.centerX.equalTo(self.TimelineBtn);
        make.size.mas_equalTo(width);
    }];
    [self.SettingsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.StitchingBtn);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(width);
        
    }];
    [self.CommunityBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.StitchingBtn);
        make.centerX.equalTo(self.TargetBtn);
        make.size.mas_equalTo(width);
    }];
    
    
}

- (UIButton *)getFatherButtonWithTitle:(NSString *)title andImageName:(NSString *)imageName andRect:(CGRect)rect selector:(SEL)selector{
    CGFloat width = AutoKscreenWidth * 0.3;
    UIButton * btn = [[UIButton alloc]initWithFrame:rect];
    btn.layer.cornerRadius = AutoKscreenWidth * 0.3f * 0.5f;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    CGFloat rectheight = 0.0;
    
    if (kDevice_Is_iPad) {
        rectheight = rect.size.height + 60;
        if (AutoKscreenWidth > 1000.0f) {
            rectheight = rect.size.height + 100;
        }
    }else{
        rectheight = rect.size.height;

    }
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-20, rectheight, width + 40, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15];
    titleLabel.text = title;
    [btn addSubview:titleLabel];
    return btn;
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self VerticalscreenUI];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        [self LandscapescreenUI];
        
    }
}
- (void)S1A3_receiveRealData{

//    NSLog(@"S1A3_S1MODE%d S1A3_X2MODE %d",[ReceiveView sharedInstance].S1A3_S1MODE, [ReceiveView sharedInstance].S1A3_X2MODE);
//    NSLog(@"S1A3_S1MODE%d S1A3_X2MODE %d",[ReceiveView sharedInstance].S1A3_S1_Timeline_ReceiveMode, [ReceiveView sharedInstance].S1A3_X2_Timeline_ReceiveMode);
    NSLog(@"%d %d", [ReceiveView sharedInstance].S1A3_S1_Target_Task_Mode, [ReceiveView sharedInstance].S1A3_X2_Target_Task_Mode);
           
    [self judgeIsRunningOrIsConnectedAndSlideMode:[ReceiveView sharedInstance].S1A3_S1MODE andX2Mode:[ReceiveView sharedInstance].S1A3_X2MODE];
    
}

- (void)S1A3_sendCorrectTime{
    

    
    recordTime = [[NSDate date]timeIntervalSince1970];
    
    dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
    
    [_sendDataView send24Gx2AddresssWithCB:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x0b andTimeStamp:recordTime WithStr:SendStr];
    [_sendDataView send24GAddressWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x0b andTimeStamp:recordTime WithStr:SendStr];
    });
  
    
}
- (void)reveiveData{
    
    [[ReceiveView sharedInstance] receiveEnable:YES];

}

- (NSInteger)getConntionStatus{
    
    if (CBS1A3_S1.state == CBPeripheralStateConnected && CBS1A3_X2.state == CBPeripheralStateConnected) {
        
        return StatusSLIDEandX2AllConnected;
        
    }else if (CBS1A3_S1.state == CBPeripheralStateConnected && ((CBS1A3_X2 == nil) || (CBS1A3_X2.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting))){
        
        
        return StatusSLIDEOnlyConnected;
    }else if (((CBS1A3_S1 == nil) || (CBS1A3_S1.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting)) && CBS1A3_X2.state == CBPeripheralStateConnected){
        
        return StatusX2OnlyConnected;
    }else{
        
        return StatusSLIDEandX2AllDisConnected;
    }
}


- (void)judgeIsRunningOrIsConnectedAndSlideMode:(UInt8)SlideMODE andX2Mode:(UInt8)X2MODE{
    
    switch ([self getConntionStatus]) {
            
        case StatusSLIDEandX2AllConnected:
            
            [self showStatusWithMode:SlideMODE];
            [self showStatusWithMode:X2MODE];
            
            break;
            
        case StatusSLIDEOnlyConnected:
            
            [self showStatusWithMode:SlideMODE];
            
            break;
            
        case StatusX2OnlyConnected:
            
            [self showStatusWithMode:X2MODE];
            
            break;
        case StatusSLIDEandX2AllDisConnected:
            break;
            
        default:
            break;
    }
    
}
- (void)showStatusWithMode:(UInt8)mode{
    
    if (appDelegate.bleManager.S1A3_S1CB.state != CBPeripheralStateConnected) {
        [ReceiveView sharedInstance].S1A3_S1_Timeline_TaskMode = 0x00;
        [ReceiveView sharedInstance].S1A3_S1_Target_Task_Mode = 0x00;
    }
    if (appDelegate.bleManager.S1A3_X2CB.state != CBPeripheralStateConnected) {
        [ReceiveView sharedInstance].S1A3_X2_Timeline_TaskMode = 0x00;
        [ReceiveView sharedInstance].S1A3_X2_Pano_Mode = 0x00;
        [ReceiveView sharedInstance].S1A3_X2_Target_Task_Mode = 0x00;
    }
    switch (mode) {
        case 0x00:
            //            NSLog(@"无任务");
            break;
        case 0x01:
            //            NSLog(@"ManMode");
            break;
        case 0x02:
            //            NSLog(@"TimeLine 0x02");
            
            if ( [ReceiveView sharedInstance].S1A3_S1_Timeline_TaskMode == 0x02 ||  [ReceiveView sharedInstance].S1A3_X2_Timeline_TaskMode == 0x02) {
                
                if (self.isAutoPush == NO) {
                    self.isAutoPush = YES;
                    UIAlertController * alertView = [iFAlertController showAlertControllerWith:@"notice" Message:NSLocalizedString(Main_isRunningTimeline, nil) SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
                        [self jumpMethod:0x02];
                    }];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                }
            }
            break;
        case 0x03:
            NSLog(@"TimeLine 0x03");
            break;
        case 0x04:
            NSLog(@"VideoSet 0x04");
            break;
        case 0x05:
            NSLog(@"StopMotion 0x05");
            break;
        case 0x06:
            NSLog(@"Bezier Preview 0x06");
            break;
        case 0x07:
            
            if ( [ReceiveView sharedInstance].S1A3_X2_Pano_Mode == 0x02) {
                [SVProgressHUD dismiss];
                
                if (self.isAutoPush == NO) {
                    self.isAutoPush = YES;
                    
                    UIAlertController * alertView = [iFAlertController showAlertControllerWith:@"notice" Message:NSLocalizedString(Main_isRunningPanorama, nil) SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
                        [self jumpMethod:0x07];
                    }];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                }
                
            }
            break;
        case 0x08:
            if ( [ReceiveView sharedInstance].S1A3_X2_Grid_Mode == 0x02) {
                if (self.isAutoPush == NO) {
                    self.isAutoPush = YES;
                    UIAlertController * alertView = [iFAlertController showAlertControllerWith:@"notice" Message:NSLocalizedString(Main_isRunningGigaplexl, nil) SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
                        [self jumpMethod:0x08];
                    }];
                    [self presentViewController:alertView animated:YES completion:nil];
                    
                }
            }
            break;
        case 0x09:
            NSLog(@"FocusMode 0x09");
            
            
            break;
        case 0x0a:
            NSLog(@"FocusMode 0x0a");
            
            if ( [ReceiveView sharedInstance].S1A3_S1_Target_Task_Mode == 0x02 &&  [ReceiveView sharedInstance].S1A3_X2_Target_Task_Mode == 0x02) {
                
                if (self.isAutoPush == NO) {
                    self.isAutoPush = YES;
                    UIAlertController * alertView = [iFAlertController showAlertControllerWith:@"notice" Message:NSLocalizedString(Main_isRunningTargetControl, nil) SureButtonTitle:@"OK" SureAction:^(UIAlertAction * action) {
                        [self jumpMethod:0x0a];
                    }];
                    [self presentViewController:alertView animated:YES completion:nil];
                }
            }
            
            break;
        default:
            break;
    }
}


- (void)jumpMethod:(UInt8)mode{
    if (mode == 0x07) {
            iFS1A3_StitchingViewController * stitchingVC = [[iFS1A3_StitchingViewController alloc]init];
            [self.navigationController pushViewController:stitchingVC animated:YES];
    }else if (mode == 0x08){
            iFS1A3_StitchingViewController * stitchingVC = [[iFS1A3_StitchingViewController alloc]init];
            [self.navigationController pushViewController:stitchingVC animated:YES];
    }else if (mode == 0x02){
        
            iFS1A3_SavePathViewController * savepath = [[iFS1A3_SavePathViewController alloc]init];
            [self.navigationController pushViewController:savepath animated:YES];
        
    }
    else if(mode == 0x0a){
            iFS1A3_TargetViewController * targetVC = [[iFS1A3_TargetViewController alloc]init];
            [self.navigationController pushViewController:targetVC animated:YES];
        
    }
    
}


- (void)viewWillAppear:(BOOL)animated{

    [self reveiveData];
    
    S1A3_receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(S1A3_receiveRealData) userInfo:nil repeats:YES];
    

    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setRightDrawerViewController:nil];
    }];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
}
- (void)viewWillDisappear:(BOOL)animated{

    S1A3_24Gtimer.fireDate = [NSDate distantFuture];
    S1A3_receiveTimer.fireDate = [NSDate distantFuture];
    [S1A3_24Gtimer invalidate];
    [S1A3_receiveTimer invalidate];
    S1A3_24Gtimer = nil;
    S1A3_receiveTimer = nil;
    [SVProgressHUD dismiss];
    
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    
    
}
- (NSString *)stringToHex:(NSString *)string
{
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    return hexStr;
}
- (void)viewDidLayoutSubviews{
    
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
