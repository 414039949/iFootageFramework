//
//  iFMainSettingsViewController.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/24.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFMainSettingsViewController.h"
#import "iFModel.h"
#import "AppDelegate.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "SVProgressHUD.h"
#import "iFPickView.h"
#import "iFSegmentView.h"
#import "iFSlideProgressView.h"
#import "iFUpdateBtn.h"
#import "iF3DButton.h"

#define sendSecond 0.1f

#define FHzTime 0.06f //频率时间



#define SENDSTR [NSString stringWithFormat:@"%@", dataStr]



@interface iFMainSettingsViewController ()<getIndexDelegate, sendSelectedDelegete>


{
    NSUserDefaults * ud;
    SendDataView * _sendDataView;
    ReceiveView * _receiveView;
    AppDelegate * appDelegate;
    NSTimer * receiveTimer;
    NSUInteger               Encode;//编码模式 ascii or  hex
    NSData * dataStr;
    
    
    
    NSArray * tempArray;
    NSArray * array1;
    BOOL isSending;
    int tempIndex;
    NSDictionary * tempDict;
    iFLabel * S1proNumberLabel;
    iFLabel * X2proNumberLabel;
    
    
    NSTimer * X2preparingTimer;
    NSTimer * X2loopingTimer;
    NSTimer * S1preparingTimer;
    NSTimer * S1loopingTimer;
    
    UIView * backgroundView;
    iFButton * closeUpdateBtn;
    
    iFSegmentView * shootingSegMentView;
    iFSegmentView * DisplayUnitSegMentView;
    iFSlideProgressView * slideprogressView;
    //    iFUpdateBtn * updateBtn;
    iF3DButton * updatebtn;
    
    
}
@property (nonatomic, strong)iFModel * ifmodel;

@property (nonatomic, assign)NSUInteger index;


@end

@implementation iFMainSettingsViewController

@synthesize shootingmodeLabel;
@synthesize displayunitLabel;
@synthesize delayplayLabel;
@synthesize changeModeBtn;
@synthesize changeUnitBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = NSLocalizedString(All_Settings, nil);
    
    tempIndex = 0;
    
    _receiveView = [ReceiveView sharedInstance];
    _sendDataView = [[SendDataView alloc]init];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self createUI];
    [self showBackgroundView];
    
    
}
- (void)updateS1{
    
    [self updateBinFileWithName:SLIDEBINNAME WithMode:1];
    
    receiveTimer.fireDate = [NSDate distantPast];
    S1preparingTimer.fireDate = [NSDate distantPast];
    self.isupdateS1 = NO;
}
- (void)updateX2{
    [self updateBinFileWithName:X2BINNAME WithMode:2];
    receiveTimer.fireDate = [NSDate distantPast];
    X2preparingTimer.fireDate = [NSDate distantPast];
    self.isupdateX2 = NO;

}
- (id)init{
    ud = [NSUserDefaults standardUserDefaults];
    self.ifmodel = [[iFModel alloc]init];
    
    self.ifmodel.shootMode = [[ud objectForKey:SHOOTINGMODE] integerValue];
    self.ifmodel.displayUnit = [[ud objectForKey:DISPLAYUNIT] integerValue];
    self.ifmodel.slideCount = [[ud objectForKey:SLIDECOUNT] integerValue];
    
    if (self.ifmodel.slideCount) {

        if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
            self.ifmodel.slideCount =   [ReceiveView sharedInstance].sectionsNumber;
        }
        
    }else{
        
        self.ifmodel.slideCount = 2;
    }
    
    if (self.ifmodel.shootMode) {
        
    }else{
        self.ifmodel.shootMode = 0;
    }
    
    if (self.ifmodel.displayUnit) {
        
    }else{
        self.ifmodel.displayUnit = 0;
    }
    
    
    return self;
}

- (void)createAllTimer{
    
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(receiveRealData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantFuture];
    
    X2preparingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(X2PrepareingTimer:) userInfo:nil repeats:YES];
    X2preparingTimer.fireDate = [NSDate distantFuture];
    
    X2loopingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(X2loopingTimer:) userInfo:nil repeats:YES];
    X2loopingTimer.fireDate = [NSDate distantFuture];
    
    S1preparingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(SlidePrepareingTimer:) userInfo:nil repeats:YES];
    S1preparingTimer.fireDate = [NSDate distantFuture];
    
    S1loopingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(SlideloopingTimer:) userInfo:nil repeats:YES];
    S1loopingTimer.fireDate = [NSDate distantFuture];
}
- (void)createUI{
    
    //   ====+++++++
  
    
    
    self.slideCountBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.4, kScreenHeight * 0.1) andTitle:[NSString stringWithFormat:@"%ld", (long)self.ifmodel.slideCount]];
    self.slideCountBtn.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.65);
    [self.slideCountBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.slideCountBtn];
#pragma mark -----
    
    shootingmodeLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(100), iFSize(156), 173, 20) WithTitle:NSLocalizedString(Setting_ShootingMode, nil) andFont:18];
    shootingmodeLabel.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.2);
    shootingmodeLabel.textColor = COLOR(168, 168, 168, 1);
    shootingmodeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:shootingmodeLabel];
    
    displayunitLabel  = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(100), iFSize(256), 173, 20) WithTitle:NSLocalizedString(Setting_DisplayUnit, nil) andFont:18];
    displayunitLabel.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.4);
    displayunitLabel.textColor = COLOR(168, 168, 168, 1);
    displayunitLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:displayunitLabel];
    
    self.slideCountLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, iFSize(356),AutoKscreenWidth, 20) WithTitle:NSLocalizedString(Setting_NumberofTrackInstalled, nil) andFont:18];
    self.slideCountLabel.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.6);
    self.slideCountLabel.textColor = COLOR(168, 168, 168, 1);
    self.slideCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.slideCountLabel];
    
    
    shootingSegMentView = [[iFSegmentView alloc]initWithFrameTwoBtns:CGRectMake(iFSize(70), iFSize(185), 234.5, 49) andfirstTitle:@"SMS" andSecondTitle:@"Continuous" andSelectedIndex:self.ifmodel.shootMode];
    shootingSegMentView.tag = 10000;
    shootingSegMentView.delegate = self;
    shootingSegMentView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.3);
    [self.view addSubview:shootingSegMentView];
    
    DisplayUnitSegMentView = [[iFSegmentView alloc]initWithFrameTwoBtns:CGRectMake(iFSize(70), iFSize(285), 234.5f, 49) andfirstTitle:@"Frame" andSecondTitle:@"Time" andSelectedIndex:self.ifmodel.displayUnit];
    DisplayUnitSegMentView.tag = 10001;
    DisplayUnitSegMentView.delegate = self;
    DisplayUnitSegMentView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
    [self.view addSubview:DisplayUnitSegMentView];
    
    slideprogressView = [[iFSlideProgressView alloc]initWithFrame:CGRectMake(iFSize(76), iFSize(384), iFSize(216), iFSize(19)) withPercent:self.ifmodel.slideCount / 10.0f * 100 withLeftValue:1 withRightValue:10];
    //        [self.view addSubview:slideprogressView];
    
    updatebtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(90), iFSize(495), 200, 52) WithTitle:NSLocalizedString(Setting_Updatefirmware, nil) selectedIMG:all_RED_BACKIMG normalIMG:all_RED_BACKIMG];
    [updatebtn.actionBtn addTarget:self action:@selector(updateCb:) forControlEvents:UIControlEventTouchUpInside];
    updatebtn.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.75);
    [updatebtn.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:updatebtn];
    
    
#pragma mark -----
    delayplayLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, kScreenHeight * 0.4, kScreenWidth, kScreenHeight * 0.1) WithTitle:@"Delay play" andFont:30];
    delayplayLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.view addSubview:delayplayLabel];
    
    
    
    
    self.shootModeSC.selectedSegmentIndex = self.ifmodel.shootMode;
    self.displayUnitSC.selectedSegmentIndex = self.ifmodel.displayUnit;
    
    //    self.updateBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(100), iFSize(400), iFSize(100), iFSize(80)) andTitle:@"UPDATE"];
    //    [self.updateBtn addTarget:self action:@selector(updateCb:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:self.updateBtn];
    
    dataStr = [[self stringToHex:self.displayunitLabel.text] dataUsingEncoding:NSUTF8StringEncoding];
    
    self.x2label = [[iFLabel alloc]initWithFrame:CGRectMake(20, iFSize(628), iFSize(120), iFSize(30)) WithTitle:@"X2_V_0.0" andFont:15];
    [self.view addSubview:self.x2label];
    
    self.slidelabel = [[iFLabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.65, iFSize(628), iFSize(120), iFSize(30)) WithTitle:@"S1_V_0.0" andFont:15];
    [self.view addSubview:self.slidelabel];
    
    
    
    
    S1proNumberLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(20), iFSize(584), 200, 30) WithTitle:[NSString stringWithFormat:@"S1SID:%@", _receiveView.S1proStr] andFont:15];
    S1proNumberLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:S1proNumberLabel];
    
    X2proNumberLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(20), iFSize(604), 200, 30) WithTitle:[NSString stringWithFormat:@"X2SID:%@", _receiveView.X2proStr] andFont:15];
    X2proNumberLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:X2proNumberLabel];
    
}

- (void)getSelectedIndex:(NSInteger)selectedIndex withTag:(NSInteger)tag{
    NSLog(@"%ld", tag);
    
    if (tag == 10000) {
        [ud setObject:[NSNumber numberWithInteger:selectedIndex] forKey:SHOOTINGMODE];
        [ud synchronize];
        
    }else{
        
        [ud setObject:[NSNumber numberWithInteger:selectedIndex] forKey:DISPLAYUNIT];
        [ud synchronize];
    }
}

- (void)showActionSheet:(iFButton *)btn{
    
    NSArray * array = @[@"1", @"2",  @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12", @"13",@"14", @"15", @"16",@"17", @"18", @"19", @"20"];
    iFPickView *Picker = [[iFPickView alloc] initWithFrame:CGRectZero andArray:array];
    
    [Picker setInitValue:self.ifmodel.slideCount - 1];
    self.index = self.ifmodel.slideCount - 1;
    Picker.getDelegate = self;
    
    if (kDevice_Is_iPad) {
        Picker.center = CGPointMake(120 , 80);
        
    }else{
        Picker.center = CGPointMake(AutoKscreenWidth / 2 - 10, 80);
        
    }
    UIAlertController * alertActionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n",NSLocalizedString(Setting_NumberofTrackInstalled, nil)] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertActionSheet.view addSubview:Picker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        NSLog(@"什么时候出现");
        UInt8 slideCount = (UInt8)(self.index +1);
        
        [_sendDataView sendVersionWith:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x00 andTimeStamp_ms:0x00 andVersion:0x00 andVersionBytes:0x00 andSlideSections:slideCount andiSmandatoryUpdate:0x00 WithStr:SendStr];
        
        [btn setTitle:array[self.index] forState:UIControlStateNormal];
        
    }];
    [alertActionSheet addAction:ok];
    
        UIPopoverPresentationController *popover =alertActionSheet.popoverPresentationController;
    
        popover.sourceView = btn;
        popover.sourceRect = btn.bounds;
        popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    [self presentViewController:alertActionSheet animated:YES completion:^{ }];

}



- (void)getIndex:(NSUInteger)idex{
    
    self.index = idex;
    
    self.ifmodel.slideCount = idex + 1;
    [ud setObject:[NSNumber numberWithUnsignedInteger:idex + 1] forKey:SLIDECOUNT];
}
//string To十六进制字符串
- (NSString *)stringToHex:(NSString *)string
{
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    return hexStr;
}


- (void)changeShootMode:(UISegmentedControl *)seg{
    NSLog(@"%ld", (long)seg.selectedSegmentIndex);
    
    [ud setObject:[NSNumber numberWithInteger:seg.selectedSegmentIndex] forKey:SHOOTINGMODE];
    [ud synchronize];
    
}
- (void)changeDisplayUnit:(UISegmentedControl *)seg{
    
    [ud setObject:[NSNumber numberWithInteger:seg.selectedSegmentIndex] forKey:DISPLAYUNIT];
    [ud synchronize];
    
}

// 已下载文件大小
- (long long)downloadedFileDataSizeWithSavePath:(NSString *)savePath {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager]; // default is not thread safe
    if ([fileManager fileExistsAtPath:savePath]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:savePath error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}


- (void)updateCb:(iFButton *)btn{
    
    
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"notice" message:NSLocalizedString(Setting_Selectunit, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    UIAlertAction *slideAction = [UIAlertAction actionWithTitle:@"Slide module" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
            if (_receiveView.slideversion >= S1VersionNum) {
                
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(Setting_NoUpdates, nil)];
                
            }else{
                
                [self updateBinFileWithName:SLIDEBINNAME WithMode:1];
                receiveTimer.fireDate = [NSDate distantPast];
                S1preparingTimer.fireDate = [NSDate distantPast];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Setting_S1Disconnected, nil)];
        }
        
        
    }];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"X2 mini" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
            
            
            if (_receiveView.X2version >= X2VersionNum) {
                NSLog(@"不能更新");
                
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(Setting_NoUpdates, nil)];
                
                
            }else{
                
                [self updateBinFileWithName:X2BINNAME WithMode:2];
                receiveTimer.fireDate = [NSDate distantPast];
                X2preparingTimer.fireDate = [NSDate distantPast];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Setting_X2Disconnected, nil)];
            
            
        }
    }];
    
    
    
    [alertController addAction:slideAction];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)receiveRealData{
//    NSLog(@"receiveRealData");
    

    
    //    NSLog(@"receiveRealData");
    //
    //    NSLog(@"X2Version = %d", _receiveView.X2version);
    //
    //    NSLog(@"SlideVersion = %d", _receiveView.slideversion);
    //    NSLog(@"X2battery = %d", _receiveView.X2battery);
    //    NSLog(@"S1battery = %d", _receiveView.slideBattery);
    
    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected || appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        
        if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
            if (_receiveView.slideversion < S1VersionNum || _receiveView.X2version < X2VersionNum){
                
                updatebtn.actionBtn.userInteractionEnabled = YES;
                [updatebtn.actionBtn setBackgroundImage:[UIImage imageNamed:all_RED_BACKIMG] forState:UIControlStateNormal];
            }else{
                
                updatebtn.actionBtn.userInteractionEnabled = NO;
                
                [updatebtn.actionBtn setBackgroundImage:[UIImage imageNamed:all_WHITE_BACKIMG] forState:UIControlStateNormal];
            }
        }
        
        if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
            if (_receiveView.slideversion < S1VersionNum || _receiveView.X2version < X2VersionNum ){
                updatebtn.actionBtn.userInteractionEnabled = YES;
                [updatebtn.actionBtn setBackgroundImage:[UIImage imageNamed:all_RED_BACKIMG] forState:UIControlStateNormal];
            }else{
                
                updatebtn.actionBtn.userInteractionEnabled = NO;
                [updatebtn.actionBtn setBackgroundImage:[UIImage imageNamed:all_WHITE_BACKIMG] forState:UIControlStateNormal];
            }
        }
  
        
        
    }else{
        updatebtn.actionBtn.userInteractionEnabled = NO;
        
        [updatebtn.actionBtn setBackgroundImage:[UIImage imageNamed:all_WHITE_BACKIMG] forState:UIControlStateNormal];
        
    }
    
    

 
    
    
    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
        S1proNumberLabel.text = [NSString stringWithFormat:@"S１SID:%@", _receiveView.S1proStr];
        self.slidelabel.hidden = NO;
        S1proNumberLabel.hidden = NO;
        self.slidelabel.text = [NSString stringWithFormat:@"S1_V_%d.%d", _receiveView.slideversion / 10, _receiveView.slideversion % 10];
        
    }else{
        self.slidelabel.hidden = YES;
        S1proNumberLabel.text = [NSString stringWithFormat:@"S１SID: no obj" ];
        S1proNumberLabel.hidden = YES;
    }
    if (appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        
        X2proNumberLabel.text = [NSString stringWithFormat:@"X２SID:%@", _receiveView.X2proStr];
        self.x2label.text = [NSString stringWithFormat:@"X2_V_%x.%d", _receiveView.X2version / 10 , _receiveView.X2version % 10];
        self.x2label.hidden = NO;
        X2proNumberLabel.hidden = NO;

        
    }else{
        X2proNumberLabel.text = [NSString stringWithFormat:@"X２SID: no obj"];
        self.x2label.hidden = YES;
        X2proNumberLabel.hidden = YES;


        
    }
    
    
    
}


- (void)sendSetWithCB{
    [_sendDataView sendVersionWith:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x00 andTimeStamp_ms:0x00 andVersion:0x00 andVersionBytes:0x00 andSlideSections:0x00 andiSmandatoryUpdate:0x00 WithStr:SENDSTR];
    [_sendDataView sendVersionWith:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x00 andTimeStamp_ms:0x00 andVersion:0x00 andVersionBytes:0x00 andSlideSections:0x00 andiSmandatoryUpdate:0x00 WithStr:SENDSTR];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
//    [_receiveView initReceviceNotification];
    
    
    
    //    [self sendSetWithCB];
    [self createAllTimer];
    
    receiveTimer.fireDate = [NSDate distantPast];
    NSLog(@"sectionsNumber%d", _receiveView.sectionsNumber);
    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
 NSArray * array = @[@"1", @"2",  @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12", @"13",@"14", @"15", @"16",@"17", @"18", @"19", @"20"];
        self.index = _receiveView.sectionsNumber - 1;
        if (self.index <= 0 || self.index > 20) {
            self.index = 0 ;
        }
        [self.slideCountBtn setTitle:array[self.index] forState:UIControlStateNormal];
        [self getIndex:self.index];
    }
    [_receiveView addObserver:self forKeyPath:@"sectionsNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    if (self.isupdateS1) {
        [self performSelector:@selector(updateS1) withObject:nil afterDelay:0.3f];
    }
    if (self.isupdateX2) {
    [self performSelector:@selector(updateX2) withObject:nil afterDelay:0.3f];
    }

}
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    [_receiveView removeObserver:self forKeyPath:@"sectionsNumber"];
    [_receiveView removeObserver:self forKeyPath:@"slideUpdateBytesNumber"];
    [_receiveView removeObserver:self forKeyPath:@"X2UpdateBytesNumber"];
    
}

- (void)dealloc{
    
    [_receiveView removeObserver:self forKeyPath:@"sectionsNumber"];
    [_receiveView removeObserver:self forKeyPath:@"slideUpdateBytesNumber"];
    [_receiveView removeObserver:self forKeyPath:@"X2UpdateBytesNumber"];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
//    NSLog(@"shootMode= %ld", (long)self.ifmodel.shootMode);
    
    [_receiveView removeObserver:self forKeyPath:@"sectionsNumber"];
    
    
    receiveTimer.fireDate = [NSDate distantFuture];
    X2loopingTimer.fireDate = [NSDate distantFuture];
    X2preparingTimer.fireDate = [NSDate distantFuture];
    S1loopingTimer.fireDate = [NSDate distantFuture];
    S1preparingTimer.fireDate = [NSDate distantFuture];
    
    //    [receiveTimer invalidate];
    [X2loopingTimer invalidate];
    [X2preparingTimer invalidate];
    [S1loopingTimer invalidate];
    [S1preparingTimer invalidate];
    
    //    receiveTimer = nil;
    X2loopingTimer  = nil;
    X2preparingTimer = nil;
    S1preparingTimer = nil;
    S1loopingTimer = nil;
    [SVProgressHUD dismiss];
}
#pragma mark ---- New IAP(新的传输协议) -----
/**
 将至多64个元素的数组 按照0-63的顺序封装为字典
 @param reciveData 接收的到数据
 @param array 至多64个元素的数组
 @return 返回根据接受到的UINT64的数据 封装新的字典
 */

- (NSDictionary *)checkWith64Int:(UInt64)reciveData andNSArray:(NSArray *)array PartNum:(NSInteger)partNum{
    
    /*将64个元素的数组 拆分成字典*/
    NSMutableDictionary * dict = [NSMutableDictionary new];
    
    for (int j = 0 ; j < [array count]; j++) {
        [dict setValue:array[j] forKey:[NSString stringWithFormat:@"%ld", j + partNum * 64]];
        
    }
    for (int i = 0 ; i < 64; i++) {
        if (((reciveData >> i ) & 1) == 0) {
            //            NSLog(@"%@", dict[[NSString stringWithFormat:@"%d", i]]);
            
        }else{
            [dict removeObjectForKey:[NSString stringWithFormat:@"%ld", i + partNum * 64]];
        }
    }
    return dict;
}

/**
 准备更新X2
 
 @param timer timer description
 */
- (void)X2PrepareingTimer:(NSTimer *)timer{
    
    if (_receiveView.X2isUpdateMode == 0x01) {
        timer.fireDate = [NSDate distantFuture];
        X2loopingTimer.fireDate = [NSDate distantPast];
        
    }else{
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString* soundPath = [[NSBundle mainBundle] pathForResource:X2BINNAME ofType:@"bin"];
        UInt32  bytes = (UInt32)[self downloadedFileDataSizeWithSavePath:soundPath];
        [_sendDataView sendVersionWith:appDelegate.bleManager.panCB andFrameHead:OX555F andFunctionNumber:0x00 andTimeStamp_ms:recordTime andVersion:X2VersionNum andVersionBytes:bytes andSlideSections:0x00 andiSmandatoryUpdate:0x01 WithStr:[NSString stringWithFormat:@"%@", dataStr]];
    }
}


/**
 发送X2更新包
 
 @param timer timer description
 */
- (void)X2loopingTimer:(NSTimer *)timer{
//    NSLog(@"=======================INDEX = %d = INDEX========================",tempIndex);

    NSInteger indexNum = _receiveView.X2UpdateBytesNumber / 0x40;
    CGFloat progress = (CGFloat)_receiveView.X2UpdateBytesNumber / (CGFloat)array1.count;
    

    
    [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"%.0lf%%", progress * 100]];
    
    
    if (!isSending) {
        [self showBackgroundView];
//        NSLog(@"+++++++++++++++++++++++++++++");
        isSending = YES;
        tempDict = [self checkWith64Int:_receiveView.X2PositionInfo andNSArray:tempArray[indexNum] PartNum:indexNum];
//        NSLog(@"indexNum %ld", indexNum);
        
        
    }
    
    NSArray * numArray = tempDict.allKeys;
    
    if (tempIndex >= tempDict.allKeys.count) {
        
        tempIndex = 0;
        isSending = NO;
        
        int Totalbytes = (int)indexNum * 64 + (int)[self returnBackPositionInfoWith64Int:_receiveView.X2PositionInfo];
        
        if (Totalbytes >= array1.count) {
            [self closeBtnAction:nil];
            
            [SVProgressHUD showSuccessWithStatus:@"OK"];
            _receiveView.X2UpdateBytesNumber = 0;
            _receiveView.X2PositionInfo = 0;
            timer.fireDate = [NSDate distantFuture];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            return;
        }
        
        
        return;
    }
    
//    NSLog(@"dictCount = %ld", (unsigned long)tempDict.count);
//    NSLog(@"int = %d", [numArray[tempIndex] intValue]);
    
    
    UInt16 temp16Index = [numArray[tempIndex] intValue];
    [_sendDataView sendUpdateTheCb:appDelegate.bleManager.panCB andFrameHead:0x65 BytesNumber:temp16Index andDataArray:tempDict[numArray[tempIndex]] WithStr:SendStr];
    tempIndex++;
}

/**
 准备更新Slide
 
 @param timer timer description
 */
- (void)SlidePrepareingTimer:(NSTimer *)timer{
    
//    NSLog(@"isUpdate = %d", _receiveView.slideisUpdateMode);
    
    if (_receiveView.slideisUpdateMode == 0x01) {
        
        timer.fireDate = [NSDate distantFuture];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.f];

    }else{
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString* soundPath = [[NSBundle mainBundle] pathForResource:SLIDEBINNAME ofType:@"bin"];
        
        UInt32  bytes = (UInt32)[self downloadedFileDataSizeWithSavePath:soundPath];
        
        [_sendDataView sendVersionWith:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andFunctionNumber:0x00 andTimeStamp_ms:recordTime andVersion:S1VersionNum andVersionBytes:bytes andSlideSections:0x00 andiSmandatoryUpdate:0x01 WithStr:SendStr];
        
    }
    
    
}
- (void)delayMethod{
    S1loopingTimer.fireDate = [NSDate distantPast];
}


/**
 发送Slide更新包
 
 @param timer timer description
 */
- (void)SlideloopingTimer:(NSTimer *)timer{
//    NSLog(@"=======================INDEX = %d = INDEX========================",tempIndex);
    
//    NSLog(@"S1PositionInfo = %llu", _receiveView.slidePositionInfo);
    
    NSInteger indexNum = _receiveView.slideUpdateBytesNumber / 0x40;
    
    CGFloat progress = (CGFloat)_receiveView.slideUpdateBytesNumber / (CGFloat)array1.count;
    
//    NSLog(@"slideUpdateBytesNumber %hu", _receiveView.slideUpdateBytesNumber);
    
//    NSLog(@"indexNum = %ld", (long)indexNum);
    
    [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"%.0lf%%", progress * 100]];
    
    if (!isSending) {
        [self showBackgroundView];
        isSending = YES;
        tempDict = [self checkWith64Int:_receiveView.slidePositionInfo andNSArray:tempArray[indexNum] PartNum:indexNum];
        
    }
    NSArray * numArray = tempDict.allKeys;
    if (tempIndex >= tempDict.allKeys.count) {
        tempIndex = 0;
        isSending = NO;
        
        int Totalbytes = (int)indexNum * 64 + (int)[self returnBackPositionInfoWith64Int:_receiveView.slidePositionInfo];
        if (Totalbytes >= array1.count) {
            [SVProgressHUD showSuccessWithStatus:@"OK"];
            _receiveView.slidePositionInfo = 0;
            _receiveView.slideUpdateBytesNumber = 0;
            [backgroundView removeFromSuperview];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self closeBtnAction:nil];
            
            timer.fireDate = [NSDate distantFuture];
            return;
        }return;
    }
    UInt16 temp16Index = [numArray[tempIndex] intValue];
//    NSLog(@"temp16Index = %d tempIndex = %d", temp16Index, tempIndex);
    [_sendDataView sendUpdateTheCb:appDelegate.bleManager.sliderCB andFrameHead:0xBA BytesNumber:temp16Index andDataArray:tempDict[numArray[tempIndex]] WithStr:SENDSTR];
    tempIndex++;
}

- (void)showBackgroundView{
    
    [backgroundView removeFromSuperview];
    [closeUpdateBtn removeFromSuperview];
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    backgroundView.layer.masksToBounds = YES;
//    backgroundView.alpha = 0.5;
    
    UILabel * attentionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.2)];
    attentionLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    attentionLabel.text = NSLocalizedString(Settint_Notice, nil);
    attentionLabel.numberOfLines = 0;
    [backgroundView addSubview:attentionLabel];
    [attentionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 0.2));
    }];
    
    closeUpdateBtn = [[iFButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + iFSize(64), iFSize(200), iFSize(100)) andTitle:NSLocalizedString(Setting_Stop, nil)];
    
    closeUpdateBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 + iFSize(100));
    
    [closeUpdateBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view.window addSubview:backgroundView];
    [self.view.window addSubview:closeUpdateBtn];
}
- (void)closeBtnAction:(iFButton *)btn{
    
    [closeUpdateBtn removeFromSuperview];
    [backgroundView removeFromSuperview];
    
    X2loopingTimer.fireDate = [NSDate distantFuture];
    X2preparingTimer.fireDate = [NSDate distantFuture];
    S1loopingTimer.fireDate = [NSDate distantFuture];
    S1preparingTimer.fireDate = [NSDate distantFuture];
    [SVProgressHUD dismiss];
}
- (NSInteger)returnBackPositionInfoWith64Int:(UInt64)int64Number{
    
    NSInteger pnumber = 0;
    
    for (int i = 0 ; i < 64; i++) {
        
        if (((int64Number >> i ) & 1) == 0) {
            
        }else{
            pnumber++;
            
        }
    }
    return pnumber;
}





- (void)updateBinFileWithName:(NSString *)str WithMode:(NSInteger)mode{
    
    
    NSString* soundPath = [[NSBundle mainBundle] pathForResource:str ofType:@"bin"];
    NSData * data = [NSData dataWithContentsOfFile:soundPath];
    
    
    UInt32 len = (UInt32)[data length];
    Byte *byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    
    NSMutableArray * dataArray = [NSMutableArray new];
    for (int i = 0; i<len; i++) {
        [dataArray addObject:[NSNumber numberWithInt:byteData[i]]];
    }
    
    /*get到比len大的16的倍数*/
    int addNumber = [self getInt16Number:(int)dataArray.count withDividendNumber:16] - (int)len;
    /*填充空的数组*/
    for (int i = 0 ; i < addNumber; i++) {
        [dataArray addObject:[NSNumber numberWithInt:0x00]];
    }
    /*生成以16B#为基础的数组*/
    array1 = [self splitArray:dataArray withSubSize:16];
    /*生成以64组#16B元素#的数组*/
    tempArray = [self splitArray:array1 withSubSize:64];
    
    isSending = NO;
    
    if (mode == 1) {
        [_receiveView addObserver:self forKeyPath:@"slideUpdateBytesNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }else{
        
        [_receiveView addObserver:self forKeyPath:@"X2UpdateBytesNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (change[NSKeyValueChangeNewKey] != change[NSKeyValueChangeOldKey]) {
        
        if([keyPath isEqualToString:@"X2UpdateBytesNumber"])
        {
//            NSLog(@"X2UpdateBytesNumberw = %hu", _receiveView.X2UpdateBytesNumber);
            tempIndex = 0;
            isSending = NO;
            X2loopingTimer.fireDate = [NSDate distantPast];
        }
        
        if([keyPath isEqualToString:@"slideUpdateBytesNumber"])
        {
//            NSLog(@"slideUpdateBytesNumber = %hu", _receiveView.slideUpdateBytesNumber);
            tempIndex = 0;
            isSending = NO;
            S1loopingTimer.fireDate = [NSDate distantPast];
        }
        
        if ([keyPath isEqualToString:@"sectionsNumber"]) {
//            NSLog(@"sectionsNumber%d", _receiveView.sectionsNumber);
            NSArray * array = @[@"1", @"2",  @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10",@"11", @"12", @"13",@"14", @"15", @"16",@"17", @"18", @"19", @"20"];
            self.index = _receiveView.sectionsNumber - 1;
            [self.slideCountBtn setTitle:array[self.index] forState:UIControlStateNormal];
            [self getIndex:self.index];
        }
        
    }else{
        
        //        NSLog(@"没有变化");
        
    }
}

/**
 根据被除数求大于改数对应的最小倍数
 @param number 初始数
 @param divNumber 倍数
 @return return value description
 */
- (int)getInt16Number:(int)number withDividendNumber:(int)divNumber{
    
    int a, b;
    b = number % divNumber;
    if (b == 0) {
        a = number;
    }else{
        a = number + (divNumber - b);
    }
    return a;
}
- (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    return [arr copy];
}

- (void)viewDidAppear:(BOOL)animated{
    

}
//竖屏时
- (void)VerticalscreenUI{
    [shootingmodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [shootingSegMentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shootingmodeLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(shootingmodeLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(234, 50));
        
        
    }];
    [displayunitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shootingSegMentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [DisplayUnitSegMentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(displayunitLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(displayunitLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(234, 50));
    }];
    [_slideCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DisplayUnitSegMentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    [_slideCountBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_slideCountLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [updatebtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_slideCountBtn.mas_bottom).offset(50);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 52));
    }];
    [self.slidelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    [self.x2label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [S1proNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [X2proNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}
//横屏时
- (void)LandscapescreenUI{
    [shootingmodeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [shootingSegMentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shootingmodeLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(234, 50));
    }];
    [displayunitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shootingSegMentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [DisplayUnitSegMentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(displayunitLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(234, 50));
    }];
    [_slideCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DisplayUnitSegMentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    [_slideCountBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_slideCountLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [updatebtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-44);
        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(200, 52));
    }];
    
    [self.slidelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    [self.x2label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [S1proNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [X2proNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];

    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [self VerticalscreenUI];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        if (kDevice_Is_iPad) {
            [self VerticalscreenUI];
        }else{
            [self LandscapescreenUI];
        }
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

