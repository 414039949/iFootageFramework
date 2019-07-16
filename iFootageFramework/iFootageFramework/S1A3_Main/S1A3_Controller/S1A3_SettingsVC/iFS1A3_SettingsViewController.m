//
//  iFS1A3_SettingsViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_SettingsViewController.h"
#import "iFSegmentView.h"
#import "iF3DButton.h"
#import "iFS1A3_Model.h"
#import "iFPickView.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "SVProgressHUD.h"
#import "iFS1A3_DialerView.h"

#define FHzTime 0.1f //频率时间




@interface iFS1A3_SettingsViewController ()<sendSelectedDelegete, getIndexDelegate>

@property (nonatomic, strong)iFLabel * S1A3_ShootingModeLabel;
@property (nonatomic, strong)iFLabel * S1A3_DisplayModeLabel;
@property (nonatomic, strong)iFLabel * S1A3_SlideCountLabel;
@property (nonatomic, strong)iFLabel * S1A3_ShootingSyncLabel;
@property (nonatomic, strong)iFS1A3_DialerView * S1A3_DialerView;


@property (nonatomic, strong)iFSegmentView * S1A3_ShootingModeSegmentView;
@property (nonatomic, strong)iFSegmentView * S1A3_DisplayModeSegmentView;

@property (nonatomic, strong)iFButton * S1A3_SlideCountBtn;
@property (nonatomic, strong)iF3DButton * S1A3_UpdateBtn;
@property (nonatomic, strong)iFS1A3_Model * S1A3_Model;
@property (nonatomic, strong)SendDataView * sendDataView;
@property (nonatomic, strong)ReceiveView * receiveView;

@property (nonatomic, strong)iFLabel * S1A3_S1_Versionlabel;
@property (nonatomic, strong)iFLabel * S1A3_X2_Versionlabel;
@property (nonatomic, strong)iFLabel * S1A3_S1_ProNumlabel;
@property (nonatomic, strong)iFLabel * S1A3_X2_ProNumlabel;


@end

@implementation iFS1A3_SettingsViewController
{
    AppDelegate * appDelegate;
    NSUInteger               Encode;//编码模式 ascii or  hex
    NSTimer * receiveTimer;//接受的定时器 进入页面开始开启退出页面关闭

    NSArray * tempArray;
    NSArray * array1;
    BOOL isSending;
    int tempIndex;
    NSDictionary * tempDict;
    
    NSTimer * X2preparingTimer;
    NSTimer * X2loopingTimer;
    NSTimer * S1preparingTimer;
    NSTimer * S1loopingTimer;
    
    UIView * backgroundView;
    iFButton * closeUpdateBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _receiveView = [ReceiveView sharedInstance];
    
    self.titleLabel.text = @"Settings";
    _S1A3_Model = [[iFS1A3_Model alloc]init];
    _sendDataView = [[SendDataView alloc]init];
    
    [self createUI];
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
- (void)createUI{
    _S1A3_ShootingModeLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20) WithTitle:NSLocalizedString(Setting_ShootingMode, nil) andFont:18];
    _S1A3_ShootingModeLabel.textColor = COLOR(168, 168, 168, 1);
    _S1A3_ShootingModeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_S1A3_ShootingModeLabel];
    
    _S1A3_DisplayModeLabel  = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20) WithTitle:NSLocalizedString(Setting_DisplayUnit, nil) andFont:18];
    _S1A3_DisplayModeLabel.textColor = COLOR(168, 168, 168, 1);
    _S1A3_DisplayModeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_S1A3_DisplayModeLabel];
    
    _S1A3_SlideCountLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0,AutoKscreenWidth, 20) WithTitle:NSLocalizedString(Setting_NumberofTrackInstalled, nil) andFont:18];
    _S1A3_SlideCountLabel.textColor = COLOR(168, 168, 168, 1);
    _S1A3_SlideCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_S1A3_SlideCountLabel];
    
    _S1A3_ShootingModeSegmentView = [[iFSegmentView alloc]initWithFrameTwoBtns:CGRectMake(0, 0, 234, 50) andfirstTitle:@"SMS" andSecondTitle:@"Continuous" andSelectedIndex:_S1A3_Model.S1A3_ShootingMode];
    _S1A3_ShootingModeSegmentView.tag = 10000;
    _S1A3_ShootingModeSegmentView.delegate = self;
    [self.view addSubview:_S1A3_ShootingModeSegmentView];
    
    _S1A3_DisplayModeSegmentView = [[iFSegmentView alloc]initWithFrameTwoBtns:CGRectMake(0, 0, 234, 50) andfirstTitle:@"Frame" andSecondTitle:@"Time" andSelectedIndex:_S1A3_Model.S1A3_DisPlayMode];
    _S1A3_DisplayModeSegmentView.tag = 10001;
    _S1A3_DisplayModeSegmentView.delegate = self;
    [self.view addSubview:_S1A3_DisplayModeSegmentView];
    
    _S1A3_SlideCountBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.4, kScreenHeight * 0.1) andTitle:[NSString stringWithFormat:@"%ld", _S1A3_Model.S1A3_SlideCount]];
    [_S1A3_SlideCountBtn addTarget:self action:@selector(S1A3_SlideCountBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_S1A3_SlideCountBtn];
    
    _S1A3_ShootingSyncLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20) WithTitle:@"Shooting sync" andFont:18];
    _S1A3_ShootingSyncLabel.textColor = COLOR(168, 168, 168, 1);
    _S1A3_ShootingSyncLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_S1A3_ShootingSyncLabel];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shootingSyncTapAction:)];
    
    
    _S1A3_DialerView = [[iFS1A3_DialerView alloc]initWithbackPNGFrame:CGRectMake(0, 0, 166 / 2, 55 / 2) WithCode:0x00];
    [_S1A3_DialerView addGestureRecognizer:tap];
    [self.view addSubview:_S1A3_DialerView];
    
    
    
    _S1A3_UpdateBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0,0, 200, 52) WithTitle:NSLocalizedString(Setting_Updatefirmware, nil) selectedIMG:all_RED_BACKIMG normalIMG:all_RED_BACKIMG];
    [_S1A3_UpdateBtn.actionBtn addTarget:self action:@selector(S1A3_UpdateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_S1A3_UpdateBtn.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_S1A3_UpdateBtn];
    _S1A3_S1_Versionlabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30) WithTitle:@"S1_V_0.0" andFont:15];
    [self.view addSubview:_S1A3_S1_Versionlabel];
    _S1A3_X2_Versionlabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30) WithTitle:@"X2_V_0.0" andFont:15];
    [self.view addSubview:_S1A3_X2_Versionlabel];
    
    _S1A3_S1_ProNumlabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(20), iFSize(584), iFSize(200), iFSize(30)) WithTitle:[NSString stringWithFormat:@"S1SID:%@", _receiveView.S1A3_S1_proStr] andFont:15];
    _S1A3_S1_ProNumlabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:_S1A3_S1_ProNumlabel];
    
    _S1A3_X2_ProNumlabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(20), iFSize(604), iFSize(200), iFSize(30)) WithTitle:[NSString stringWithFormat:@"X2SID:%@", _receiveView.S1A3_X2_proStr] andFont:15];
    _S1A3_X2_ProNumlabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:_S1A3_X2_ProNumlabel];
}


- (void)shootingSyncTapAction:(UITapGestureRecognizer *)tap{
    
    iFS1A3_DialerView * dialerview = [[iFS1A3_DialerView alloc]initWithFrame:CGRectMake(30, 30, 300, 100) Withcode:_S1A3_DialerView.syncCode];
    dialerview.backgroundColor = [UIColor clearColor];
    dialerview.userInteractionEnabled = YES;
    //    [self.view addSubview:dialerview];
    
    UIAlertController * alertActionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n", @"Shooting sync"] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertActionSheet.view addSubview:dialerview];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [_S1A3_DialerView getDialerResultsWithCode:[dialerview getDialerRseults]];
        
    }];
    [alertActionSheet addAction:ok];
    
    UIPopoverPresentationController *popover =alertActionSheet.popoverPresentationController;
        popover.sourceView = tap.view;
        popover.sourceRect = tap.view.bounds;
    popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    
    [self presentViewController:alertActionSheet animated:YES completion:^{ }];

}
#pragma mark ---- sendSelectedDelegete --------
- (void)getSelectedIndex:(NSInteger)selectedIndex withTag:(NSInteger)tag{
    
    if (tag == 10000) {
        _S1A3_Model.S1A3_ShootingMode = selectedIndex;
    }else if (tag == 10001){
        _S1A3_Model.S1A3_DisPlayMode = selectedIndex;
    }
}
#pragma mark ---- S1A3_SlideCountBtnAction: ------
- (void)S1A3_SlideCountBtnAction:(UIButton *)btn{
    NSArray * array = @[@"1", @"2",  @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
    
    iFPickView *Picker = [[iFPickView alloc] initWithFrame:CGRectZero andArray:array];
    
    [Picker setInitValue:_S1A3_Model.S1A3_SlideCount - 1];
    Picker.getDelegate = self;
    
    
    if (kDevice_Is_iPad) {
        Picker.center = CGPointMake(btn.frame.size.width * 1.5 , 80);

    }else{
        Picker.center = CGPointMake(AutoKscreenWidth / 2 - 10, 80);
    }
    UIAlertController * alertActionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n",NSLocalizedString(Setting_NumberofTrackInstalled, nil)] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertActionSheet.view addSubview:Picker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        [btn setTitle:array[_S1A3_Model.S1A3_SlideCount - 1] forState:UIControlStateNormal];
    }];
    [alertActionSheet addAction:ok];
    
    UIPopoverPresentationController *popover =alertActionSheet.popoverPresentationController;

    popover.sourceView = btn;
    popover.sourceRect = btn.bounds;
    popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    
    [self presentViewController:alertActionSheet animated:YES completion:^{ }];

    

}
- (void)getIndex:(NSUInteger)idex{
    
    _S1A3_Model.S1A3_SlideCount = idex + 1;
    [_sendDataView sendVersionWith:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x00 andTimeStamp_ms:0x00 andVersion:0x00 andVersionBytes:0x00 andSlideSections:(UInt8)(idex + 1) andiSmandatoryUpdate:0x00 WithStr:SendStr];
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


#pragma mark ---- _S1A3_UpdateBtnAction: -----
- (void)S1A3_UpdateBtnAction:(UIButton *)btn{
    
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"notice" message:NSLocalizedString(Setting_Selectunit, nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    
    UIAlertAction *slideAction = [UIAlertAction actionWithTitle:@"S1A3_S1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (appDelegate.bleManager.S1A3_S1CB.state == CBPeripheralStateConnected) {
            
            if ([ReceiveView sharedInstance].S1A3_S1_Version >= S1A3_S1VersionNum) {
                
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(Setting_NoUpdates, nil)];
                
                
            }else{
                
                [self updateBinFileWithName:S1A3_S1_BINNAME WithMode:1];
                receiveTimer.fireDate = [NSDate distantPast];
                S1preparingTimer.fireDate = [NSDate distantPast];
            }
        }else{
//
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(Setting_S1Disconnected, nil)];
        }
        
        
    }];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"S1A3_X2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
            
            
            if (_receiveView.X2version >= X2VersionNum) {
                NSLog(@"不能更新");
                
                [SVProgressHUD showInfoWithStatus:NSLocalizedString(Setting_NoUpdates, nil)];
                
                
            }else{
                
                [self updateBinFileWithName:S1A3_X2_BINNAME WithMode:2];
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
        [_receiveView addObserver:self forKeyPath:@"S1A3_S1_UpdateBytesNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        
        
    }else{
        
        [_receiveView addObserver:self forKeyPath:@"S1A3_X2_UpdateBytesNumber" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
}

- (void)updateS1{
    
    [self updateBinFileWithName:S1A3_S1_BINNAME WithMode:1];
    receiveTimer.fireDate = [NSDate distantPast];
    S1preparingTimer.fireDate = [NSDate distantPast];
    self.isupdateS1 = NO;
}
- (void)updateX2{
    [self updateBinFileWithName:S1A3_X2_BINNAME WithMode:2];
    receiveTimer.fireDate = [NSDate distantPast];
    X2preparingTimer.fireDate = [NSDate distantPast];
    self.isupdateX2 = NO;
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

//竖屏时
- (void)VerticalscreenUI{
    [_S1A3_ShootingModeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [_S1A3_ShootingModeSegmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_ShootingModeLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_S1A3_ShootingModeLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(234, 50));
        
        NSLog(@"_S1A3_DisplayModeSegmentView = %@", NSStringFromCGPoint(_S1A3_DisplayModeSegmentView.center));
        NSLog(@"center =%@", NSStringFromCGPoint(self.view.center));

    }];
    [_S1A3_DisplayModeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_ShootingModeSegmentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [_S1A3_DisplayModeSegmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_DisplayModeLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_S1A3_DisplayModeLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(234, 50));
    }];
    [_S1A3_SlideCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_DisplayModeSegmentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    [_S1A3_SlideCountBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_SlideCountLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [_S1A3_ShootingSyncLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_SlideCountBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [_S1A3_DialerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_ShootingSyncLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(166 / 2, 55 / 2));
    }];
    
    [_S1A3_UpdateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_DialerView.mas_bottom).offset(50);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 52));
        
    }];
    [_S1A3_S1_Versionlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    [_S1A3_X2_Versionlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [_S1A3_S1_ProNumlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [_S1A3_X2_ProNumlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}
//横屏时
- (void)LandscapescreenUI{
    [_S1A3_ShootingModeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [_S1A3_ShootingModeSegmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_ShootingModeLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(234, 50));
    }];
    [_S1A3_DisplayModeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_ShootingModeSegmentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [_S1A3_DisplayModeSegmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_DisplayModeLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(234, 50));
    }];
    [_S1A3_SlideCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_DisplayModeSegmentView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(300, 20));
    }];
    [_S1A3_SlideCountBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_SlideCountLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [_S1A3_ShootingSyncLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-44);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    [_S1A3_DialerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_ShootingSyncLabel.mas_bottom).offset(20);
        make.centerX.equalTo(_S1A3_ShootingSyncLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(166 / 2, 55 / 2));
    }];
    [_S1A3_UpdateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_S1A3_DialerView.mas_bottom).offset(50);
        make.centerX.equalTo(_S1A3_ShootingSyncLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 52));
    }];
    [_S1A3_S1_Versionlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    [_S1A3_X2_Versionlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [_S1A3_S1_ProNumlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [_S1A3_X2_ProNumlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
}
#pragma mark -----创建所有的定时器集合-------
- (void)createAllTimer{
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:ReceiveSecond target:self selector:@selector(S1A3_receiveRealTimeData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];
    
    X2preparingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(X2PrepareingTimer:) userInfo:nil repeats:YES];
    X2preparingTimer.fireDate = [NSDate distantFuture];
    
    X2loopingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(X2loopingTimer:) userInfo:nil repeats:YES];
    X2loopingTimer.fireDate = [NSDate distantFuture];
    
    S1preparingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(SlidePrepareingTimer:) userInfo:nil repeats:YES];
    S1preparingTimer.fireDate = [NSDate distantFuture];
    
    S1loopingTimer = [NSTimer scheduledTimerWithTimeInterval:FHzTime target:self selector:@selector(SlideloopingTimer:) userInfo:nil repeats:YES];
    S1loopingTimer.fireDate = [NSDate distantFuture];
}
- (void)X2PrepareingTimer:(NSTimer *)timer{
    if (_receiveView.S1A3_X2_UpdateMode == 0x01) {
        timer.fireDate = [NSDate distantFuture];
        X2loopingTimer.fireDate = [NSDate distantPast];
    }else{
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString* soundPath = [[NSBundle mainBundle] pathForResource:S1A3_X2_BINNAME ofType:@"bin"];
        UInt32  bytes = (UInt32)[self downloadedFileDataSizeWithSavePath:soundPath];
        [_sendDataView sendVersionWith:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x00 andTimeStamp_ms:recordTime andVersion:S1A3_X2VersionNum andVersionBytes:bytes andSlideSections:0x00 andiSmandatoryUpdate:0x01 WithStr:SendStr];
    }
}
- (void)X2loopingTimer:(NSTimer *)timer{
//    NSLog(@"=======================INDEX = %d = INDEX========================",tempIndex);
    
//    NSLog(@"X2PositionInfo = %llu", _receiveView.X2PositionInfo);
    
    NSInteger indexNum = _receiveView.S1A3_X2_UpdateBytesNumber / 0x40;
    
    CGFloat progress = (CGFloat)_receiveView.S1A3_X2_UpdateBytesNumber / (CGFloat)array1.count;
    
    NSLog(@"progress = %f", progress);
    
    
    NSLog(@"indexNum = %ld", (long)indexNum);
    
    [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"%.0lf%%", progress * 100]];
    
    NSLog(@"Str = %@", _receiveView.notiStr);
    
    if (!isSending) {
        [self showBackgroundView];
        
        NSLog(@"+++++++++++++++++++++++++++++");
        isSending = YES;
        tempDict = [self checkWith64Int:_receiveView.S1A3_X2_PositionInfo andNSArray:tempArray[indexNum] PartNum:indexNum];
    }
    
    NSArray * numArray = tempDict.allKeys;
    
    if (tempIndex >= tempDict.allKeys.count) {
        
        tempIndex = 0;
        isSending = NO;
        
        int Totalbytes = (int)indexNum * 64 + (int)[self returnBackPositionInfoWith64Int:_receiveView.S1A3_X2_PositionInfo];
        if (Totalbytes >= array1.count) {
            
            [SVProgressHUD showSuccessWithStatus:@"OK"];
            _receiveView.S1A3_X2_UpdateBytesNumber = 0;
            _receiveView.S1A3_X2_PositionInfo = 0;
            [self closeBtnAction:nil];
            [backgroundView removeFromSuperview];
            
            
            timer.fireDate = [NSDate distantFuture];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            return;
        }
        
        
        return;
    }
    
    NSLog(@"dictCount = %ld", (unsigned long)tempDict.count);
    NSLog(@"int = %d", [numArray[tempIndex] intValue]);
    
    
    UInt16 temp16Index = [numArray[tempIndex] intValue];
    [_sendDataView sendUpdateTheCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:0x65 BytesNumber:temp16Index andDataArray:tempDict[numArray[tempIndex]] WithStr:SendStr];
    tempIndex++;
}
- (void)SlidePrepareingTimer:(NSTimer *)timer{
    NSLog(@"isUpdate = %d", _receiveView.S1A3_S1_UpdateMode);
    
    if (_receiveView.S1A3_S1_UpdateMode == 0x01) {
        timer.fireDate = [NSDate distantFuture];
        S1loopingTimer.fireDate = [NSDate distantPast];
        
    }else{
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString* soundPath = [[NSBundle mainBundle] pathForResource:S1A3_S1_BINNAME ofType:@"bin"];
        
        UInt32  bytes = (UInt32)[self downloadedFileDataSizeWithSavePath:soundPath];

        [_sendDataView sendVersionWith:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x00 andTimeStamp_ms:recordTime andVersion:S1A3_S1VersionNum andVersionBytes:bytes andSlideSections:0x00 andiSmandatoryUpdate:0x01 WithStr:SendStr];
    }
    
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

- (void)SlideloopingTimer:(NSTimer *)timer{
    NSLog(@"=======================INDEX = %d = INDEX========================",tempIndex);
    
    NSLog(@"S1PositionInfo = %llu", _receiveView.S1A3_S1_PositionInfo);
    
    NSInteger indexNum = _receiveView.S1A3_S1_UpdateBytesNumber / 0x40;
    
    CGFloat progress = (CGFloat)_receiveView.S1A3_S1_UpdateBytesNumber / (CGFloat)array1.count;
    
    NSLog(@"progress = %f", progress);
    
    
    NSLog(@"indexNum = %ld", (long)indexNum);
    
    [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"%.0lf%%", progress * 100]];
    
    if (!isSending) {
        [self showBackgroundView];
        isSending = YES;
        tempDict = [self checkWith64Int:_receiveView.S1A3_S1_PositionInfo andNSArray:tempArray[indexNum] PartNum:indexNum];
        
    }
    NSArray * numArray = tempDict.allKeys;
    
    if (tempIndex >= tempDict.allKeys.count) {
        
        tempIndex = 0;
        isSending = NO;
        
        int Totalbytes = (int)indexNum * 64 + (int)[self returnBackPositionInfoWith64Int:_receiveView.S1A3_S1_PositionInfo];
        
        if (Totalbytes >= array1.count) {
            
            [SVProgressHUD showSuccessWithStatus:@"OK"];
            _receiveView.S1A3_S1_PositionInfo = 0;
            _receiveView.S1A3_S1_UpdateBytesNumber = 0;
            [backgroundView removeFromSuperview];
            
            [self closeBtnAction:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            timer.fireDate = [NSDate distantFuture];
            return;
        }return;
    }
    UInt16 temp16Index = [numArray[tempIndex] intValue];
    
    [_sendDataView sendUpdateTheCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:0xBA BytesNumber:temp16Index andDataArray:tempDict[numArray[tempIndex]] WithStr:SendStr];
    tempIndex++;
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
- (void)closeAllTimer{
    receiveTimer.fireDate = [NSDate distantFuture];
    [receiveTimer invalidate];
    receiveTimer = nil;
}
#pragma mark ----S1A3_receiveRealTimeData -----
- (void)S1A3_receiveRealTimeData{

    
    _S1A3_X2_Versionlabel.text = [NSString stringWithFormat:@"X2_V_%x.%d", _receiveView.S1A3_X2_Version / 10 , _receiveView.S1A3_X2_Version % 10];
    _S1A3_S1_Versionlabel.text = [NSString stringWithFormat:@"S1_V_%d.%d", _receiveView.S1A3_S1_Version / 10, _receiveView.S1A3_S1_Version% 10];
    if (appDelegate.bleManager.S1A3_S1CB.state == CBPeripheralStateConnected) {
        _S1A3_S1_ProNumlabel.text = [NSString stringWithFormat:@"S１SID:%@", _receiveView.S1A3_S1_proStr];
        
    }else{
        _S1A3_S1_ProNumlabel.text = [NSString stringWithFormat:@"S１SID: no obj" ];
        
    }
    if (appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
        
        _S1A3_X2_ProNumlabel.text = [NSString stringWithFormat:@"X２SID:%@", _receiveView.S1A3_X2_proStr];
    }else{
        _S1A3_X2_ProNumlabel.text = [NSString stringWithFormat:@"X２SID: no obj"];
        
    }
    
}
- (void)showBackgroundView{
    
    [backgroundView removeFromSuperview];
    [closeUpdateBtn removeFromSuperview];
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 100)];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.layer.masksToBounds = YES;
    
    backgroundView.alpha = 0.5;
    
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
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
//    [_receiveView removeObserver:self forKeyPath:@"sectionsNumber"];
    [_receiveView removeObserver:self forKeyPath:@"S1A3_S1_UpdateBytesNumber"];
    [_receiveView removeObserver:self forKeyPath:@"S1A3_X2_UpdateBytesNumber"];
    
}

- (void)dealloc{
    
//    [_receiveView removeObserver:self forKeyPath:@"sectionsNumber"];
    [_receiveView removeObserver:self forKeyPath:@"S1A3_S1_UpdateBytesNumber"];
    [_receiveView removeObserver:self forKeyPath:@"S1A3_X2_UpdateBytesNumber"];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (change[NSKeyValueChangeNewKey] != change[NSKeyValueChangeOldKey]) {

        if([keyPath isEqualToString:@"S1A3_X2_UpdateBytesNumber"])
        {
            NSLog(@"S1A3_X2_UpdateBytesNumber = %hu", _receiveView.S1A3_X2_UpdateBytesNumber);
            tempIndex = 0;
            isSending = NO;

            X2loopingTimer.fireDate = [NSDate distantPast];
        }
        
        if([keyPath isEqualToString:@"S1A3_S1_UpdateBytesNumber"])
        {
            NSLog(@"S1A3_S1_UpdateBytesNumber = %hu", _receiveView.S1A3_S1_UpdateBytesNumber);
            tempIndex = 0;
            isSending = NO;
            
            S1loopingTimer.fireDate = [NSDate distantPast];
        }
        
//        if ([keyPath isEqualToString:@"sectionsNumber"]) {
//            NSLog(@"sectionsNumber%d", _receiveView.sectionsNumber);
//
//            NSArray * array = @[@"1", @"2",  @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10"];
//
//            self.index = _receiveView.sectionsNumber - 1;
//            [self.slideCountBtn setTitle:array[self.index] forState:UIControlStateNormal];
//            [self getIndex:self.index];
//        }
//
    }else{
        
        //        NSLog(@"没有变化");
        
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    [self createAllTimer];
    
    if (self.isupdateS1) {
        [self performSelector:@selector(updateS1) withObject:nil afterDelay:0.3f];
    }
    if (self.isupdateX2) {
        [self performSelector:@selector(updateX2) withObject:nil afterDelay:0.3f];
    }

}
- (void)viewWillDisappear:(BOOL)animated{
    [self closeAllTimer];
    if (self.isupdateS1) {
        [self performSelector:@selector(updateS1) withObject:nil afterDelay:0.3f];
    }
    if (self.isupdateX2) {
        [self performSelector:@selector(updateX2) withObject:nil afterDelay:0.3f];
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
