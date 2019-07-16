//
//  iFScanViewController.m
//  iFootage
//
//  Created by 黄品源 on 16/6/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFScanViewController.h"
#import "MJRefresh.h"

#define S1A1SwitchTag   100
#define X2SwitchTag     101
#define SLIDERINDENTEFIER @"2021"
#define X2INDETEFIER @"2121"
#import "SVProgressHUD.h"
#import "iFAlertController.h"
#import "iFMainSettingsViewController.h"
#import "iFS1A3_SettingsViewController.h"

#import "iFVersionView.h"
@interface iFScanViewController ()<UITextFieldDelegate>

{
    NSUInteger               Encode;//编码模式 ascii or  hex
    NSTimer * receiveTimer;
    UInt64 recordTime;
    
    NSTimer * sendCorrectTimer;
    BOOL isSendMac;
    
    iFVersionView * versionView;
    UIButton * btn1;
    UIButton * btn2;
}




@end

@implementation iFScanViewController

@synthesize S1A1unitLabel;
@synthesize S1A1StateLabel;
@synthesize S1A1unitSwitch;
@synthesize S1A1unitImgView;
@synthesize X2unitLabel;
@synthesize X2StateLabel;
@synthesize X2unitSwitch;
@synthesize X2unitImgView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.titleLabel.text = NSLocalizedString(Scan_BluetoothList, nil);
    
  
    _sendView = [[SendDataView alloc]init];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.connectBtn.alpha = 0;
    [self.view bringSubviewToFront:self.rootbackBtn];
    
    _listView = [[ListView alloc]initWithFrame:CGRectMake(0, 64 + [UIApplication sharedApplication].statusBarFrame.size.height, kScreenWidth, kScreenHeight)];
    _listView.listDelegate = self;
    
    appDelegate.bleManager.showDelegate = self;
    [self.view addSubview:_listView];
    
    [_listView startScan];
    
    [self setupRefresh];
    
    versionView = [[iFVersionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height)];
    versionView.alpha = 0;
    versionView.userInteractionEnabled = YES;
    versionView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:versionView];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (change[NSKeyValueChangeNewKey] != change[NSKeyValueChangeOldKey]){
        
        if ([keyPath isEqualToString:@"slideversion"]) {
            
            if ( [ReceiveView sharedInstance].slideversion < S1VersionNum ) {
                versionView.alpha = 1;
                versionView.S1View.alpha = 1;
                [versionView.S1View.actionBtn.actionBtn addTarget:self action:@selector(btn1Action:) forControlEvents:UIControlEventTouchUpInside];
                NSLog(@"有新的S1");
            }
        }
        if ([keyPath isEqualToString:@"X2version"]) {
                if ( [ReceiveView sharedInstance].X2version < X2VersionNum ) {

                versionView.alpha = 1;
                versionView.X2View.alpha = 1;
                [versionView.X2View.actionBtn.actionBtn addTarget:self action:@selector(btn2Action:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        if ([keyPath isEqualToString:@"S1A3_S1_Version"]) {
            
            if ( [ReceiveView sharedInstance].S1A3_S1_Version < S1A3_S1VersionNum &&  [ReceiveView sharedInstance].S1A3_S1_Version != 0x00) {
                versionView.alpha = 1;
                versionView.S1A3_S1View.alpha = 1;
                [versionView.S1A3_S1View.actionBtn.actionBtn addTarget:self action:@selector(btn3Action:) forControlEvents:UIControlEventTouchUpInside];
                NSLog(@"有新的S1A3_S1");
            }
        }
        if ([keyPath isEqualToString:@"S1A3_X2_Version"]) {
            
            if ( [ReceiveView sharedInstance].S1A3_X2_Version < S1A3_X2VersionNum &&  [ReceiveView sharedInstance].S1A3_X2_Version != 0x00) {
                versionView.alpha = 1;
                versionView.S1A3_X2View.alpha = 1;
                [versionView.S1A3_X2View.actionBtn.actionBtn addTarget:self action:@selector(btn4Action:) forControlEvents:UIControlEventTouchUpInside];
                NSLog(@"有新的S1A3_X2");
            }
        }
        
    }
}

- (void)btn1Action:(UIButton *)btn1{
    
    iFMainSettingsViewController * ifsettingVC = [[iFMainSettingsViewController alloc]init];
    ifsettingVC.isupdateS1 = YES;
    ifsettingVC.ispresent = YES;
    [self presentViewController:ifsettingVC animated:YES completion:nil];
}
- (void)btn2Action:(UIButton *)btn2{
    iFMainSettingsViewController * ifsettingVC = [[iFMainSettingsViewController alloc]init];
    ifsettingVC.isupdateX2 = YES;
    ifsettingVC.ispresent = YES;
    [self presentViewController:ifsettingVC animated:YES completion:nil];
}
- (void)btn3Action:(UIButton *)btn3{
    iFS1A3_SettingsViewController * ifsettingVC = [[iFS1A3_SettingsViewController alloc]init];
    ifsettingVC.isupdateS1 = YES;
    ifsettingVC.ispresent = YES;
    [self presentViewController:ifsettingVC animated:YES completion:nil];

}
- (void)btn4Action:(UIButton *)btn4{
    
    iFS1A3_SettingsViewController * ifsettingVC = [[iFS1A3_SettingsViewController alloc]init];
    ifsettingVC.isupdateX2 = YES;
    ifsettingVC.ispresent = YES;
    [self presentViewController:ifsettingVC animated:YES completion:nil];
}

- (void)gotoSettingsViewController{
    iFMainSettingsViewController * ifsettingVC = [[iFMainSettingsViewController alloc]init];
//    [self.navigationController pushViewController:ifsettingVC animated:YES];
    ifsettingVC.ispresent = YES;
    [self presentViewController:ifsettingVC animated:YES completion:nil];
}
- (void)testMethod{
    [_listView startScan];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSMutableArray * arraytemp = [[NSMutableArray alloc]initWithArray:appDelegate.bleManager.peripherals];
    NSArray * array = [NSArray arrayWithArray:arraytemp];
    for (CBPeripheral * cb in array) {
        
        if (cb.state == CBPeripheralStateConnected) {
            
        }else{
            [arraytemp removeObject:cb];
        }
    }
    appDelegate.bleManager.peripherals = arraytemp;
    [_listView ScanPeripheral];
        // 刷新表格
        [_listView.listView reloadData];
        [_listView.listView headerEndRefreshing];
}


- (void)setupRefresh
{
    
    [_listView.listView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
#warning 自动刷新(一进入程序就下拉刷新)
    [_listView.listView headerBeginRefreshing];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _listView.listView.headerPullToRefreshText = NSLocalizedString(MJRefresh_PULL, nil);
    _listView.listView.headerReleaseToRefreshText = NSLocalizedString(MJRefresh_Refresh, nil);
    _listView.listView.headerRefreshingText = @"iFootage waiting";
    
}
- (void)modifiyNewNameWithCb:(CBPeripheral *)cb andTableView:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    
    [self ModifyCBPeripheralName:cb andTableView:tableview andIndexPath:indexPath];
}
//写入名称
-(void)writeFF91:(CBPeripheral *)cb andNameStr:(NSString *)namestr
{
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];
    
    if ([typeStr containsString:SLIDERINDENTEFIER] == YES) {
//        NSLog(@"s1");
        [appDelegate.bleManager writeValue:0xFF90 characteristicUUID:0xFF91 p:cb data:[[NSString stringWithFormat:@"iFootage%@", namestr] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }else if ([typeStr containsString:X2INDETEFIER] == YES){
        [appDelegate.bleManager writeValue:0xFF90 characteristicUUID:0xFF91 p:cb data:[[NSString stringWithFormat:@"iFootage%@", namestr] dataUsingEncoding:NSUTF8StringEncoding]];
        
//        NSLog(@"x2");
        
    }

}

- (void)disConnectAndConnect{
//    [appDelegate.bleManager readValue:0xFF90 characteristicUUID:0xFF91 p:cb];

}

- (void)ModifyCBPeripheralName:(CBPeripheral *)cb andTableView:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
//    NSLog(@"cb = %@",cb);
    NSString *title = NSLocalizedString(Scan_Rename, nil);
    
    NSString *message = NSLocalizedString(Timeline_EnterPlaceSlogan, nil);

    NSString *cancelButtonTitle = NSLocalizedString(Timeline_Cancel, nil);
    NSString *okButtonTitle = NSLocalizedString(Timeline_OK, nil);
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"please enter new name";
        textField.secureTextEntry = NO;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.delegate = self;
        textField.tag = 100;
        NSString * nameStr = pathDict[[NSString stringWithFormat:@"%@", cb.identifier]][[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];

        textField.text = nameStr;
        
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 读取文本框的值显示出来
        UITextField *newName = alertDialog.textFields.lastObject;
        iFPeripheralCell * cell = [tableview cellForRowAtIndexPath:indexPath];
        cell.tiltLabel.text = [NSString stringWithFormat:@"%@", newName.text];
        
        pathDict[[NSString stringWithFormat:@"%@", cb.identifier]][[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]] = [NSString stringWithFormat:@"%@",  newName.text];
        [pathDict writeToFile:path atomically:YES];
#warning 改回注释就OK
//        [self writeFF91:cb andNameStr:newName.text];
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancel];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [alertDialog.view setNeedsLayout];
    [alertDialog.view layoutIfNeeded];
    [self presentViewController:alertDialog animated:YES completion:^{
        
    }];
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"按");
    int kMaxLength = 16;
    NSInteger strLength = textField.text.length - range.length + string.length;
    //输入内容的长度 - textfield区域字符长度（一般=输入字符长度）+替换的字符长度（一般为0）
    return (strLength <= kMaxLength);
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    NSLog(@"结束");
    
}
- (void)backLastVC{


      
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)disconnectDelegate:(CBPeripheral *)cb{
    
    [ReceiveView sharedInstance].x224GAdress = 0;
    [ReceiveView sharedInstance].slide24GAdress = 0;
    [ReceiveView sharedInstance].X2_2_4GAddress = 0;
    [ReceiveView sharedInstance].slide_2_4GAddress = 0;
    [self headerRereshing];
//    NSLog(@"断开连接======%@", cb);
    if (cb == appDelegate.bleManager.sliderCB) {
        [self loopSendBlock:^{
            [_sendView send2_4GWithCB:appDelegate.bleManager.panCB andFrameHead:OX555F andTimestamp:recordTime];

        }];
    }
    if (cb == appDelegate.bleManager.panCB) {
        [self loopSendBlock:^{
            [_sendView send2_4GWithCB:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andTimestamp:recordTime];
        }];
    }
    if (cb == CBSLIDE) {
        [versionView.S1View removeFromSuperview];
        versionView.S1View.alpha = 0;
    }else if(cb == CBPanTilt){
        [versionView.X2View removeFromSuperview];
        versionView.X2View.alpha = 0;
    }else if (cb == CBS1A3_S1){
        [versionView.S1A3_S1View removeFromSuperview];
        versionView.S1A3_S1View.alpha = 0;
    }else if (cb == CBS1A3_X2){
        [versionView.S1A3_X2View removeFromSuperview];
        versionView.S1A3_X2View.alpha = 0;
    }
}
//循环调用block发送指令
- (void)loopSendBlock:(void(^)(void))block;
{
    dispatch_queue_t queue = dispatch_queue_create("com.iFootage.TimelineQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        int a = 0;
        while (YES) {
            [NSThread sleepForTimeInterval:0.1f];
            a++;
            if (block) {
                block();
            }
            if (a > 4) {
                a = 0;
                break;
            }
        }
    });
}


#pragma mark - 创建视图

- (void)showStateDelegate:(NSArray *)array{
    
    NSLog(@"delegate == %@", array);
    
    NSUserDefaults * userDe = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < array.count; i++) {
        CBPeripheral * cb = array[i];
        if (cb.name == nil) {
            
            
        }else{
        NSString * str = [NSString stringWithFormat:@"%@", [userDe objectForKey:cb.name][cb.name]];
            if ([str isEqualToString:SLIDERINDENTEFIER] == YES) {
                S1A1StateLabel.backgroundColor = [UIColor orangeColor];
            }else{
                X2StateLabel.backgroundColor = [UIColor orangeColor];
            }
        }
    }
}
-(NSString *)getPrefixTypeString:(NSString *)str{
    
    NSRange range = {1, 4};
    NSString * string = [str substringWithRange:range];
    return string;
    
}

- (void)receiveRealData{
    
//    NSLog(@"%d %d", [ReceiveView sharedInstance].S1A3_S1_BatteryNum, [ReceiveView sharedInstance].S1A3_X2_BatteryNum);
//    NSLog(@"%hhu %hhu", [ReceiveView sharedInstance].S1A3_S1_isConnect_24G, [ReceiveView sharedInstance].S1A3_X2_isConnect_24G);
//    NSLog(@"btn1%@", btn1);
//    NSLog(@"btn2%@", btn2);
    if (IS_Mini) {
        
        if (versionView.S1View.alpha == 0 && versionView.X2View.alpha == 0) {
            versionView.alpha = 0;
        }
        
        
    }else{
        
        
        if (versionView.S1A3_S1View.alpha == 0 && versionView.S1A3_X2View.alpha == 0) {
            versionView.alpha = 0;
        }
    }
}

- (void)reveiveData{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
    [[ReceiveView sharedInstance] initReceviceNotification];
    [self setReceiveMode];
    [[ReceiveView sharedInstance] receiveEnable:YES];
}
- (void)setReceiveMode{

    Encode = Encode_HEX;
    [[ReceiveView sharedInstance] setIsAscii:NO];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(receiveRealData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];

    if ( [ReceiveView sharedInstance].slideversion < S1VersionNum) {
        versionView.alpha = 1;
    }
    if ( [ReceiveView sharedInstance].X2version < X2VersionNum) {
        versionView.alpha = 1;
    }
    
    if ( [ReceiveView sharedInstance].S1A3_S1_Version < S1VersionNum) {
        versionView.alpha = 1;
    }
    if ( [ReceiveView sharedInstance].S1A3_X2_Version < X2VersionNum) {
        versionView.alpha = 1;
    }
    
    
    [[ReceiveView sharedInstance] addObserver:self forKeyPath:@"X2version" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[ReceiveView sharedInstance] addObserver:self forKeyPath:@"slideversion" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[ReceiveView sharedInstance] addObserver:self forKeyPath:@"S1A3_S1_Version" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [[ReceiveView sharedInstance] addObserver:self forKeyPath:@"S1A3_X2_Version" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
    [self reveiveData];
    
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[ReceiveView sharedInstance] removeObserver:self forKeyPath:@"slideversion"];
    [[ReceiveView sharedInstance] removeObserver:self forKeyPath:@"X2version"];
    [[ReceiveView sharedInstance] removeObserver:self forKeyPath:@"S1A3_S1_Version"];
    [[ReceiveView sharedInstance] removeObserver:self forKeyPath:@"S1A3_X2_Version"];
    receiveTimer.fireDate = [NSDate distantFuture];
    
    [receiveTimer invalidate];

    receiveTimer = nil;
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
