//
//  iFMainViewController.m
//  iFootage
//
//  Created by 黄品源 on 16/6/7.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFMainViewController.h"
#import "iFScanViewController.h"
#import "iFTransmitViewController.h"
#import "iFTimelapseViewController.h"
#import "iFKeyFrameCurveViewController.h"
#import "iFFocusModeViewController.h"
#import "iFMainSettingsViewController.h"
#import "iFCommuityViewController.h"
#import "iFPanoramaViewController.h"
#import "iFTutorialVideoViewController.h"

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
#import <Masonry/Masonry.h>

#import "iFgetAxisY.h"




#define SENDSTR [NSString stringWithFormat:@"%@", dataStr]



@interface iFMainViewController ()<ListViewDelegate>
@property (nonatomic, strong)UIButton * TimelineBtn;
@property (nonatomic, strong)UIButton * ManualBtn;
@property (nonatomic, strong)UIButton * TargetBtn;
@property (nonatomic, strong)UIButton * StitchingBtn;
@property (nonatomic, strong)UIButton * SettingsBtn;
@property (nonatomic, strong)UIButton * CommunityBtn;


@end

@implementation iFMainViewController
{
    AppDelegate * appDelegate;
    ReceiveView * _receiveView;
    SendDataView * _sendDataView;
    ListView * _listView;
    iFButton * MenuBtn;
    
    iFLabel * label1;
    iFLabel * label2;
    iFLabel * contextLabel;
    
    UInt64 recordTime;
    
    iFLabel * S1proNumberLabel;
    iFLabel * X2proNumberLabel;
    
    
    NSInteger Encode;
    
    NSTimer * receiveTimer;
    NSTimer * _24Gtimer;
    
    UIView * backView;
    NSData * dataStr;
    
    BOOL isSendMac;
    BOOL isShowReturnZeroError;
    
    UIImageView * iconView;
    UIImageView * titleView;
}


@synthesize drawBtn;
@synthesize sendBtn;
@synthesize contextTF;
@synthesize equipmentNameLabel;



- (void)viewDidLoad {

    [super viewDidLoad];
  
    
 
    self.navigationController.navigationBarHidden = YES;
    self.isAutoPush = NO;
    
    self.titleLabel.text = NSLocalizedString(All_MainMenu, nil);
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Encode = Encode_ASCII;
    isShowReturnZeroError = NO;
    
    _receiveView = [ReceiveView sharedInstance];
    _sendDataView = [[SendDataView alloc]init];
    _listView = [[ListView alloc]init];
    _listView.listDelegate = self;
    recordTime = [[NSDate date]timeIntervalSince1970];
    
    
    [self createNewUI];
        
    [iFStatusBarView sharedView];
    
    
    /**
     创建右边按钮 跳转连接蓝牙界面
     */
    self.rootbackBtn.alpha = 0;
    
    /**
     创建左侧按钮 待开发
     */
    MenuBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24) andnormalImage:@"Menu" andSelectedImage:@"Menu"];
//还未添加相应事件
    [MenuBtn addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:MenuBtn];
//
//    iFButton * TutorialVideoBtn = [[iFButton alloc]initWithFrame:CGRectMake(kScreenWidth * 0.88, kScreenHeight * 0.90, 30, 30) andTitle:@"?"];
//    [TutorialVideoBtn addTarget:self action:@selector(gotoTutorialVideoVC) forControlEvents:UIControlEventTouchUpInside];
//    [TutorialVideoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    TutorialVideoBtn.layer.cornerRadius = 15;
//    TutorialVideoBtn.layer.borderColor = [UIColor grayColor].CGColor;
//    TutorialVideoBtn.layer.borderWidth = 1;
//    [self.view addSubview:TutorialVideoBtn];
//    
//    [TutorialVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view).offset(-30);
//        make.bottom.equalTo(self.view).offset(-30);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
//    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    NSBundle * bundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    iFLabel * versionLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(240), iFSize(550), iFSize(120), iFSize(30)) WithTitle:[NSString stringWithFormat:@"Version:%@", bundle] andFont:iFSize(18)];
//    [self.view addSubview:versionLabel];
    backView = [self showReturnZeroPointView];
    backView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    backView.alpha = 0;
    
    dataStr = [[self stringToHex:versionLabel.text] dataUsingEncoding:NSUTF8StringEncoding];

    
}

- (void)createNewUI{
    
    iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(69), iFSize(69))];
    iconView.image = [UIImage imageNamed:@"ifootage_icon@3x"];
    [self.view addSubview:iconView];
    
    titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(93), iFSize(14))];
    titleView.image = [UIImage imageNamed:@"IFOOTAGE1@3x"];
    [self.view addSubview:titleView];
    
    NSArray * array = @[main_TIMELINEIMG, main_MANUALCTLIMG, main_TARGETCTLIMG, main_STITCHINGIMG, main_SETTINGSIMG, main_COMMUNITY];
    NSArray * titleArray =  @[NSLocalizedString(@"Timeline Control", nil), NSLocalizedString(@"Manual Control", nil), NSLocalizedString(@"Target Control", nil), NSLocalizedString(@"Stitching", nil), NSLocalizedString(@"Settings", nil), NSLocalizedString(@"Community", nil)];
    
    self.TimelineBtn = [self getFatherButtonWithTitle:titleArray[0] andImageName:array[0] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(gotoTheEveryViewController:)];
    self.ManualBtn = [self getFatherButtonWithTitle:titleArray[1] andImageName:array[1] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(gotoTheEveryViewController:)];
    self.TargetBtn = [self getFatherButtonWithTitle:titleArray[2] andImageName:array[2] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(gotoTheEveryViewController:)];
    self.StitchingBtn = [self getFatherButtonWithTitle:titleArray[3] andImageName:array[3] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(gotoTheEveryViewController:)];
    self.SettingsBtn = [self getFatherButtonWithTitle:titleArray[4] andImageName:array[4] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(gotoTheEveryViewController:)];
    self.CommunityBtn = [self getFatherButtonWithTitle:titleArray[5] andImageName:array[5] andRect:CGRectMake(0, 0, 100, 100) selector:@selector(gotoTheEveryViewController:)];
    self.TimelineBtn.tag = 0;
    self.ManualBtn.tag = 1;
    self.TargetBtn.tag = 2;
    self.StitchingBtn.tag = 3;
    self.SettingsBtn.tag = 4;
    self.CommunityBtn.tag = 5;
    
}
- (void)gotoTutorialVideoVC{

    iFTutorialVideoViewController * iftvc = [[iFTutorialVideoViewController alloc]init];
    [self.navigationController pushViewController:iftvc animated:YES];
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    
//    if (change[NSKeyValueChangeNewKey] != change[NSKeyValueChangeOldKey]){
//        
//        if ([keyPath isEqualToString:@"X2version"]) {
//            
//            if ( [ReceiveView sharedInstance].X2version < X2VersionNum &&  [ReceiveView sharedInstance].X2version != 0x00) {
//                
//                iFAlertController * alertView = [iFAlertController showAlertControllerWithTitle:@"" Message:[NSString stringWithFormat:NSLocalizedString(MainVC_X2updateSlogan, nil)] CancelButtonTitle:NSLocalizedString(Main_UpdateCancel, nil) otherButtonTitle:NSLocalizedString(Main_UpdateOK, nil) cancelAction:^(UIAlertAction *action) {
//                    NSLog(@"");
//                    
//                } otherAction:^(UIAlertAction *action) {
//                    NSLog(@"");
//                    [self gotoSettingsViewController];
//                    
//                }];
//                [self presentViewController:(UIAlertController *)alertView animated:YES completion:nil];
//            }
//        }
//        if ([keyPath isEqualToString:@"slideversion"]) {
//            if ( [ReceiveView sharedInstance].slideversion < S1VersionNum &&  [ReceiveView sharedInstance].slideversion != 0x00) {
//                
//                iFAlertController * alertView = [iFAlertController showAlertControllerWithTitle:@"" Message:[NSString stringWithFormat:NSLocalizedString(MainVC_S1updateSlogan, nil)] CancelButtonTitle:NSLocalizedString(Main_UpdateCancel, nil) otherButtonTitle:NSLocalizedString(Main_UpdateOK, nil) cancelAction:^(UIAlertAction *action) {
//                    NSLog(@"");
//                } otherAction:^(UIAlertAction *action) {
//                    NSLog(@"");
//                    [self gotoSettingsViewController];
//                    
//                }];
//
//                [self presentViewController:(UIAlertController *)alertView animated:YES completion:nil];
//                
//            }
//        }
//
//    }
//    
//}
- (void)sendCorrectTime{
        recordTime = [[NSDate date]timeIntervalSince1970];

        dispatch_queue_t globalQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQueue, ^{
            
            [_sendDataView send24GAddressWithCb:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x0b andTimeStamp:recordTime WithStr:SENDSTR];
            
            [_sendDataView send24Gx2AddresssWithCB:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x0b andTimeStamp:recordTime WithStr:SENDSTR];
        });
}


- (void)listViewConnectSucessful:(CBPeripheral *)peripheral{



}
- (void)delayMethod{


    [_listView startScan];
    
    
    [self performSelector:@selector(freestyleConnected) withObject:nil afterDelay:1.0f];


}
- (void)reveiveData{


    [ [ReceiveView sharedInstance] receiveEnable:YES];
}

- (void)freestyleConnected{
    [self reveiveData];
}


-(void)leftDrawerButtonPress:(id)sender{
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;//隐藏为YES，显示为NO
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

- (UIView *)showReturnZeroPointView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, kScreenHeight / 2)];
    view.backgroundColor = [UIColor blackColor];
    CGFloat hight , width = 0.0;
    hight = view.frame.size.height;
    width = view.frame.size.width;
    
    label1 = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, width / 2, hight * 0.1) WithTitle:@"" andFont:iFSize(12)];
    [view addSubview:label1];
    label2 = [[iFLabel alloc]initWithFrame:CGRectMake(width / 2, 0, width / 2 , hight * 0.1) WithTitle:@"" andFont:iFSize(12)];
    [view addSubview:label2];
    
    contextLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, width , hight * 0.8) WithTitle:@"" andFont:iFSize(12)];
    contextLabel.numberOfLines = 0;
    [view addSubview:contextLabel];
    return view;
}
- (void)showStatusWithMode:(UInt8)mode{
    if (appDelegate.bleManager.sliderCB.state != CBPeripheralStateConnected) {
         [ReceiveView sharedInstance].slideModeID = 0x00;
         [ReceiveView sharedInstance].FMslideMode = 0x00;
        
    }
    if (appDelegate.bleManager.panCB.state != CBPeripheralStateConnected) {
         [ReceiveView sharedInstance].x2ModeID = 0x00;
         [ReceiveView sharedInstance].Pamode = 0x00;
         [ReceiveView sharedInstance].FMx2taskMode = 0x00;
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
            
            if ( [ReceiveView sharedInstance].x2ModeID == 0x02 ||  [ReceiveView sharedInstance].slideModeID == 0x02) {
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
            
            if ( [ReceiveView sharedInstance].Pamode == 0x02) {
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
            NSLog(@"Gigaplexl 0x08 %d",  [ReceiveView sharedInstance].Gimode);
            if ( [ReceiveView sharedInstance].Gimode == 0x02) {
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
            if ( [ReceiveView sharedInstance].FMTaskslideMode == 0x02 &&  [ReceiveView sharedInstance].FMx2taskMode == 0x02) {
                
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
        [self gotoPanoramaViewController];
        
        
    }else if (mode == 0x08){
        [self gotoPanoramaViewController];
        
    }else if (mode == 0x02){
        
        [self gotoKeyframeCurve];
    }
    else if(mode == 0x0a){
        iFFocusModeViewController * iffocusModeVC = [[iFFocusModeViewController alloc]init];
        iffocusModeVC.isRunning = YES;
        [self.navigationController pushViewController:iffocusModeVC animated:YES];
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

- (NSInteger)getConntionStatus{
    
    if (CBSLIDE.state == CBPeripheralStateConnected && CBPanTilt.state == CBPeripheralStateConnected) {
 
        return StatusSLIDEandX2AllConnected;
        
    }else if (CBSLIDE.state == CBPeripheralStateConnected && ((CBPanTilt == nil) || (CBPanTilt.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting))){
        

        return StatusSLIDEOnlyConnected;
    }else if (((CBSLIDE == nil) || (CBSLIDE.state == CBPeripheralStateDisconnected || CBPeripheralStateConnecting)) && CBPanTilt.state == CBPeripheralStateConnected){

        return StatusX2OnlyConnected;
    }else{

        return StatusSLIDEandX2AllDisConnected;
    }
}

- (void)receiveRealData{

//    NSLog(@"slideversion%d", _receiveView.slideversion);
    [self judgeIsRunningOrIsConnectedAndSlideMode:_receiveView.S1MODE andX2Mode:_receiveView.X2MODE];

    

    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected || appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        
        label1.text = [NSString stringWithFormat:@"S1Mode:%hhu", _receiveView.S1checkZeroMode];
        label2.text = [NSString stringWithFormat:@"X2Mode:%hhu", _receiveView.X2checkZeroMode];
        
        contextLabel.text = [NSString stringWithFormat:@"S1RealPosition:%hu \r\n S1RealVeloc:%hu \r\n S1RightSensorStandardValue:%hu \r\n S1LeftSensorStandardValue:%hu \r\n S1RightSensorRealValue：%hu \r\n S1LeftSensorRealValue:%hu", _receiveView.S1checkZeroRealPosition, _receiveView.S1checkZeroRealVeloc, _receiveView.S1checkZeroRightSensorStandardValue, _receiveView.S1checkZeroLeftSensorStandardValue, _receiveView.S1checkZeroRightSensorRealValue, _receiveView.S1checkZeroLeftSensorRealValue];
        

    }
    
    if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        if (_receiveView.X2checkZeroMode == 0x00) {
            isShowReturnZeroError = NO;
        }
        
        if (!isShowReturnZeroError) {
            if (_receiveView.X2checkZeroMode == 0x04) {
//                NSLog(@"回零失败");
                UIAlertController * alertView = [iFAlertController showAlertControllerWith:NSLocalizedString(MainVC_Warning, nil) Message:NSLocalizedString(MainVC_ReturnError, nil) SureButtonTitle:NSLocalizedString(Timeline_OK, nil) SureAction:^(UIAlertAction * action) {
                    
                    [_sendDataView sendReturnX2ZeroWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x0c andFunctionMode:0x00 WithStr:SENDSTR];
                    
                }];
//                云台回零失败 检查Tilt轴是否卡住 或者重心是否不对
                [self presentViewController:alertView animated:YES completion:^{
                    
                    isShowReturnZeroError = YES;

                }];
                
            }else{
                isShowReturnZeroError = NO;
            }
        }
    }
    
 
}

- (void)freeConnect{
//    NSUserDefaults * userDF = [NSUserDefaults standardUserDefaults];
//    NSString * IdStr = [userDF objectForKey:@"ActiveSlide"];
//    NSLog(@"%@", IdStr);
    
    //    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
//    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
//    
//    if (dict) {
//        for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
//            NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];
//            
//            BOOL isSliderBool = [typeStr containsString:SLIDERINDENTEFIER];
//            BOOL isX2Bool = [typeStr containsString:X2INDETEFIER];
//            if (isSliderBool == YES && isX2Bool == NO) {
//                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
//                    [appDelegate.bleManager connectPeripheral: cb];
////                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMothed:) userInfo:cb repeats:NO];
//                }
//                
//            }else if (isSliderBool == NO && isX2Bool == YES){
//                
//                NSLog(@"%@, %@", dict[X2KEY], [NSString stringWithFormat:@"%@", cb.identifier]);
//                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
//                    NSLog(@"%@", dict);
//                    
//                    [appDelegate.bleManager connectPeripheral: cb];
////                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMothed:) userInfo:cb repeats:NO];
//                }
//                
//            }
//            
//        }
//    }
}
-(NSString *)getPrefixTypeString:(NSString *)str{
    
    NSRange range = {1, 4};
    NSString * string = [str substringWithRange:range];
    return string;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    receiveTimer.fireDate = [NSDate distantFuture];
    _24Gtimer.fireDate = [NSDate distantFuture];
    [_24Gtimer invalidate];
    [receiveTimer invalidate];
    _24Gtimer = nil;
    receiveTimer = nil;
    [SVProgressHUD dismiss];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
}



-(void)nslogeverything{

    iFScanViewController * scanVc = [[iFScanViewController alloc]init];
    [self presentViewController:scanVc animated:YES completion:nil];
//    NSLog(@"我草啊");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/**
 *  进入到搜索蓝牙界面
 */
- (void)gotoScanViewController{
    iFScanViewController * ifscanVC = [[iFScanViewController alloc]init];
    [self presentViewController:ifscanVC animated:YES completion:nil];    
}
/**
 *  进入到曲线的界面
 */
- (void)gotoKeyframeCurve{
    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected && appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        if (_receiveView.x224GAdress == _receiveView.slide24GAdress) {
            iFKeyFrameCurveViewController * keyframeCurveVC = [[iFKeyFrameCurveViewController alloc]init];
            [self.navigationController pushViewController:keyframeCurveVC animated:NO];
            
        }else{
            UIAlertController * alertController = [iFAlertController showAlertControllerWith:NSLocalizedString(MainVC_Warning, nil) Message:NSLocalizedString(isSynchronizedWarning, nil) SureButtonTitle:NSLocalizedString(Timeline_OK, nil) SureAction:^(UIAlertAction * action) {
                //                    [self sendCorrectTime];
                _24Gtimer.fireDate = [NSDate distantPast];
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else{
        iFKeyFrameCurveViewController * keyframeCurveVC = [[iFKeyFrameCurveViewController alloc]init];
        [self.navigationController pushViewController:keyframeCurveVC animated:NO];
    }
}
/**
 *  进入到接收 发送数据界面(待开发)
 */
- (void)toTransmitViewcontroller{
    iFTransmitViewController * iftransferVC = [[iFTransmitViewController alloc]init];
    [self.navigationController pushViewController:iftransferVC animated:YES];
}


- (void)gotoFocusModeViewController{
    
    
    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected && appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        if (_receiveView.X2isReturnOnSlide == 0x01) {
            
            
            if (_receiveView.slide24GAdress == _receiveView.x224GAdress) {
                iFFocusModeViewController * iffocusModeVC = [[iFFocusModeViewController alloc]init];
                [self.navigationController pushViewController:iffocusModeVC animated:YES];
                
            }else{
                
                UIAlertController * alertController = [iFAlertController showAlertControllerWith:NSLocalizedString(MainVC_Warning, nil) Message:NSLocalizedString(isSynchronizedWarning, nil) SureButtonTitle:NSLocalizedString(Timeline_OK, nil) SureAction:^(UIAlertAction * action) {
//                    [self sendCorrectTime];
                    _24Gtimer.fireDate = [NSDate distantPast];
                    
                }];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }else{
            UIAlertController * alertController = [iFAlertController showAlertControllerWith:@"" Message:NSLocalizedString(isReturnOnSliderWarning, nil) SureButtonTitle:NSLocalizedString(Timeline_OK, nil) SureAction:^(UIAlertAction * action) {
                  [_sendDataView sendReturnX2ZeroWithCb:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x0c andFunctionMode:0x00 WithStr:SENDSTR];
    
                
            }];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
    }else{
        
        UIAlertController * alertController = [iFAlertController showAlertControllerWith:@"" Message:NSLocalizedString(isAllConnectedWarning, nil) SureButtonTitle:NSLocalizedString(Timeline_OK, nil) SureAction:^(UIAlertAction * action) {
            iFScanViewController * scanVC = [[iFScanViewController alloc]init];
            [self presentViewController:scanVC animated:YES completion:nil];
        }];
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
}
- (void)gotoSettingsViewController{
    iFMainSettingsViewController * ifsettingVC = [[iFMainSettingsViewController alloc]init];
    [self.navigationController pushViewController:ifsettingVC animated:YES];
    
}
- (void)gotoPanoramaViewController{
    iFPanoramaViewController * ifPanoraVC = [[iFPanoramaViewController alloc]init];
    [self.navigationController pushViewController:ifPanoraVC animated:YES];
}
- (void)gotoCommunityViewController{
    iFCommuityViewController * ifCommunity = [[iFCommuityViewController alloc]init];
    [self.navigationController pushViewController:ifCommunity animated:YES];
}
/**
 *创建UI 包括KeyFrame curve(曲线模式)
 *          Manual Control(手动模式)
 *          Fous Mode(对焦模式)
 *          Setting (设置界面)
 */


- (void)createUI{
    
    UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(69), iFSize(69))];
    iconView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.2);
    iconView.image = [UIImage imageNamed:@"ifootage_icon@3x"];
    [self.view addSubview:iconView];
    UIImageView * titleView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iFSize(93), iFSize(14))];
    titleView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.26);
    titleView.image = [UIImage imageNamed:@"IFOOTAGE1@3x"];
    [self.view addSubview:titleView];
    
    NSArray * array = @[main_TIMELINEIMG, main_MANUALCTLIMG, main_TARGETCTLIMG, main_STITCHINGIMG, main_SETTINGSIMG, main_COMMUNITY];
    
    NSArray * titleArray =  @[NSLocalizedString(@"Timeline Control", nil), NSLocalizedString(@"Manual Control", nil), NSLocalizedString(@"Target Control", nil), NSLocalizedString(@"Stitching", nil), NSLocalizedString(@"Settings", nil), NSLocalizedString(@"Community", nil)];
    
    for (int i = 0; i< 6; i++) {
        
        CGRect rect = CGRectMake(0, 0, iFSize(89), iFSize(89));
        CGPoint iConCenter = CGPointMake(kScreenWidth * 0.3 + (i % 2) * kScreenWidth * 0.4, kScreenHeight * 0.4 + kScreenHeight * 0.2 *( i / 2));
        CGPoint titleCenter = CGPointMake(kScreenWidth * 0.3 + (i % 2) * kScreenWidth* 0.4, kScreenHeight * 0.48 + kScreenHeight * 0.2 *( i / 2));
        iFLabel * titleLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(104), iFSize(16)) WithTitle:titleArray[i] andFont:iFSize(12.5)];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ring"]];
        UIButton * btn = [self getFatherButtonWithTitle:titleArray[i] andImageName:array[i] andRect:rect];
        btn.center = iConCenter;
        titleLabel.center = titleCenter;
        imageView.center = btn.center;
        imageView.alpha = 0.2;
        [self.view addSubview:imageView];
        [self.view addSubview:titleLabel];
        btn.tag = i;
        [btn addTarget:self action:@selector(gotoTheEveryViewController:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (UIButton *)getFatherButtonWithTitle:(NSString *)title andImageName:(NSString *)imageName andRect:(CGRect)rect{
    
    UIButton * btn = [[UIButton alloc]initWithFrame:rect];
    btn.layer.cornerRadius = rect.size.width * 0.5f;
    
    btn.backgroundColor = [UIColor clearColor];
    
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:iFSize(16)];
    [self.view addSubview:btn];
    return btn;
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
    NSLog(@"[UIDevice currentDevice].model = %@", [UIDevice currentDevice].model);
    
    if (kDevice_Is_iPad) {
        rectheight = rect.size.height + 60;
        NSLog(@"AutoKscreenWidth%f", AutoKscreenWidth);
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
- (void)gotoTheEveryViewController:(UIButton *)tap{
    
    NSLog(@"%ld", (long)tap.tag);
    
    if (tap.tag == 0) {
        [self gotoKeyframeCurve];
    }else if (tap.tag == 1){
        [self toTransmitViewcontroller];
        
    }else if (tap.tag == 2){
//        [self gotoFocusModeViewController];
        
        iFFocusModeViewController * iffocusModeVC = [[iFFocusModeViewController alloc]init];
        [self.navigationController pushViewController:iffocusModeVC animated:YES];
        
    }else if (tap.tag == 3){
        [self gotoPanoramaViewController];

    }else if (tap.tag == 4){
        [self gotoSettingsViewController];
        
    }else if (tap.tag == 5){
        [self gotoCommunityViewController];
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"StatusBarFrameisHiddenMethod" object:nil];
        
    }
}






- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.isAutoPush = NO;

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
    
//    [_receiveView initReceviceNotification];
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(receiveRealData) userInfo:nil repeats:YES];
    
//    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected && appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
//        
//        _24Gtimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(Adress24GPairing:) userInfo:nil repeats:YES];
//        
//        if (_receiveView.slide24GAdress == _receiveView.x224GAdress && _receiveView.slide24GAdress != 0 && _receiveView.x224GAdress != 0) {
//            
//            _24Gtimer.fireDate = [NSDate distantFuture];
//        }else{
//            _24Gtimer.fireDate = [NSDate distantPast];
//            
//        }
//    }
    receiveTimer.fireDate = [NSDate distantPast];
    
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;

    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setRightDrawerViewController:nil];
    }];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;

    
}
static int anumber = 0;

- (void)Adress24GPairing:(NSTimer *)timer{
    anumber++;
    NSLog(@"%d", anumber);

    if (_receiveView.x2ModeID == 0x02 || _receiveView.slideModeID == 0x02 || _receiveView.slideIsloop == 0x01 || _receiveView.x2Isloop == 0x01 || _receiveView.FMTaskslideMode == 0x02 || _receiveView.FMx2Mode == 0x02 || _receiveView.FMx2taskisloop == 0x01 || _receiveView.FMtaskslideisloop == 0x01 || _receiveView.Gimode == 0x02 || _receiveView.Pamode == 0x02) {
        anumber = 0;
        [SVProgressHUD dismiss];
        
        timer.fireDate = [NSDate distantFuture];
        
        return;
        
    }
    if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected && appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
        if (_receiveView.x224GAdress == _receiveView.slide24GAdress && _receiveView.X2_2_4GAddress != 0 && _receiveView.slide24GAdress != 0) {
                NSLog(@"Address相等");
            timer.fireDate = [NSDate distantFuture];
            anumber = 0;
            [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(MatchingSuccessTips, nil)];
            
                }else{
                    NSLog(@"Address发送了");

                    [SVProgressHUD showWithStatus:NSLocalizedString(MatchingEquipmentTips, nil)];
                    [self sendCorrectTime];
                    
                }
    
            }
    if (anumber > 10) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(MatchingFailureTips, nil)];
        anumber = 0;
        timer.fireDate = [NSDate distantFuture];
    }
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
- (void)VerticalscreenUI{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    [MenuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([iFStatusBarView sharedView].mas_top).offset(20);

        make.left.equalTo(@24);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    
    CGFloat width = AutoKscreenWidth * 0.3;
    CGFloat limitDistance;
    if (kDevice_Is_iPhoneX||IsiPhoneXr||IsiPhoneXSmax) {
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    CGFloat width = AutoKscreenWidth * 0.3;
    
    
    [MenuBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([iFStatusBarView sharedView].mas_top).offset(20);
        make.left.equalTo(@24);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
