//
//  ListView.m
//  BLECollection
//
//  Created by rfstar on 14-1-7.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ListView.h"
#import "ReceiveView.h"
#define BIRTHDAYPASSWORD @"920416920416"
#define INITPASSWORD @"123456123456"
#import "SendDataView.h"

@implementation ListView
{
    SendDataView * sendView;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        CGRect tmpFrame  = CGRectMake(0,0, frame.size.width, frame.size.height);
        _listView = [[UITableView alloc]initWithFrame:tmpFrame style:UITableViewStylePlain];
        _listView.backgroundColor = [UIColor clearColor];
        
        _listView.separatorStyle =NO;
        [_listView setDelegate:self];
        [_listView setDataSource:self];
        sendView  = [[SendDataView alloc]init];
        
#warning 密码修改的地方
        self.passwordStr = BIRTHDAYPASSWORD;
        
        
        [self addSubview:_listView];
        
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.bleManager.showDelegate = self;

    }
    return self;
}
- (void)freeconnectDelegate{
    [self freeConnect];
}
- (void)ScanPeripheral {
#warning 修改BUG    一进界面已经开机的就自动连接
    NSLog(@"BEL=%@", appDelegate.bleManager.peripherals);
    [appDelegate.bleManager findBLEPeripherals:10];//开始扫描1分钟
}
- (void)ReSetPeripheral{
    [self stopScan];
    
    [appDelegate.bleManager.peripherals removeAllObjects];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(ScanPeripheral) userInfo:nil repeats:NO];
    
}
-(void)startScan{
    
    [self initNotification];
    [self ScanPeripheral];
//    [self reciveInitNotification];
    MODEL = MODEL_NORMAL;
    
    
    
}
- (void)stopScan{
    
    [appDelegate.bleManager stopScan];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc  removeObserver:self name:@"DIDCONNECTEDBLEDEVICE" object:nil];
    [nc  removeObserver:self name:@"STOPSCAN" object:nil];
    [nc  removeObserver:self name:@"BLEDEVICEWITHRSSIFOUND" object:nil];
    [nc  removeObserver:self name:@"SERVICEFOUNDOVER" object:nil];
    [nc  removeObserver:self name:@"DOWNLOADSERVICEPROCESSSTEP" object:nil];
    
}

- (void)reciveInitNotification{

}

-(void)initNotification
{
    //设定通知
    //发现BLE外围设备
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    //成功连接到指定外围BLE设备
    [nc addObserver: self
           selector: @selector(didConectedbleDevice:)
               name: @"DIDCONNECTEDBLEDEVICE"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(stopScanBLEDevice:)
               name: @"STOPSCAN"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(bleDeviceWithRSSIFound:)
               name: @"BLEDEVICEWITHRSSIFOUND"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(ServiceFoundOver:)
               name: @"SERVICEFOUNDOVER"
             object: nil];
    
    [nc addObserver: self
           selector: @selector(DownloadCharacteristicOver:)
               name: @"DOWNLOADSERVICEPROCESSSTEP"
             object: nil];

  

}

//更新数据
-(void)ValueChangText:(NSNotification *)notification
{
    NSLog(@"ValueChangText");
    //这里取出刚刚从过来的字符串
    CBCharacteristic *tmpCharacter = (CBCharacteristic*)[notification object];
    NSString *uuidStr = [[tmpCharacter UUID] UUIDString];
    
//    NSLog(@"uuidStr%@", tmpCharacter);
//    NSLog(@"uuidStr%@", uuidStr);
    
    if ([uuidStr isEqualToString:@"FFC1"]) {
        
        
    }else if ([uuidStr isEqualToString:@"FFC2"]) {
        
        NSData *value = tmpCharacter.value;
        NSString *str = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
        NSLog(@"value:%@",[value description]);
        NSLog(@"str:%@",str);
        
        if ([[value description] isEqualToString:@"<00>"]) {
            //提交密码正确
            NSLog(@"密码正确 <00>");
            
        }else if ([[value description] isEqualToString:@"<01>"]) {
            //提交密码错误
            NSLog(@"密码错误 <00>");
            self.passwordStr = INITPASSWORD;
            
            
            
        }else if ([[value description] isEqualToString:@"<02>"]) {
            //
            NSLog(@"密码修改成功 <02>");

        }else if ([[value description] isEqualToString:@"<03>"]) {
            NSLog(@"取消密码 <03>");

            
            }else {

            }
            //将取消密码按钮置灰
        }
        
}


//扫描ble设备
-(void)stopScanBLEDevice:(CBPeripheral *)peripheral {
    NSLog(@" 2BLE外设 列表 被更新 ！\r\n");
    
    
    [_listView reloadData];
    [_listDelegate listViewRefreshStateEnd];
}

//服务发现完成之后的回调方法
-(void)ServiceFoundOver:(CBPeripheral *)peripheral {
    NSLog(@" 4获取所有的服务 ");
    
    MODEL = MODEL_SCAN;  //2
    [_listView reloadData];
}

//成功扫描所有服务特征值
-(void)DownloadCharacteristicOver:(CBPeripheral *)peripheral {
    MODEL = MODEL_CONECTED;  //3
   NSLog(@" 5获取所有的特征值 ! \r\n");
    
    [[ReceiveView sharedInstance]receiveEnable:YES];
    [_listView reloadData];
}

-(void)bleDeviceWithRSSIFound:(NSNotification *) notification{   //此方法刷新次数过多，会导致tableview界面无法刷新的情况发生
    NSLog(@" 1更新RSSI 值 ！\r\n");
    [_listView reloadData];
    
}

//连接成功
-(void)didConectedbleDevice:(CBPeripheral *)peripheral {
     NSLog(@" 3BLE 设备连接成功   ！\r\n");
     MODEL = MODEL_CONNECTING ;  //1
     [_listView reloadData];

    
    [appDelegate.bleManager.activePeripheral discoverServices:nil];
//    NSLog(@"activePeripheral%@", appDelegate.bleManager.activePeripheral);
    
//    [_listDelegate listViewConnectSucessful:peripheral];
}


- (void)Send24GAdressWith{
    
    
}

- (void)disconnectDelegate:(CBPeripheral *)cb{
    
    [ReceiveView sharedInstance].x224GAdress = 0;
    [ReceiveView sharedInstance].slide24GAdress = 0;
    [ReceiveView sharedInstance].X2_2_4GAddress = 0;
    [ReceiveView sharedInstance].slide_2_4GAddress = 0;
    NSLog(@"断开连接");
    
    [_listView reloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
#pragma mark- UITableView
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"........................");
    return appDelegate.bleManager.peripherals.count;             //直接返回，类属性成员t 的peripherals  变长数组的长度
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击");
    
}

- (void)modifyNameAction:(iFButton *)btn{
    NSIndexPath * path = [NSIndexPath indexPathForRow:btn.tag - 1000 inSection:0];
    CBPeripheral * cb = appDelegate.bleManager.peripherals[path.row];
    
        if (cb.state == CBPeripheralStateConnected) {

//    iFPeripheralCell * cell = (iFPeripheralCell *)[self.listView cellForRowAtIndexPath:path];
    [_listDelegate modifiyNewNameWithCb:cb andTableView:self.listView andIndexPath:path];
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"TableCellIdentifier";
    iFPeripheralCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    CBPeripheral *cbPeripheral = [appDelegate.bleManager.peripherals objectAtIndex:[indexPath row]];
    
    if(!cell){
        cell = [[iFPeripheralCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell.modefiyBtn addTarget:self action:@selector(modifyNameAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.isConnectedSwitch.tag = indexPath.row + 100;
    cell.modefiyBtn.tag = indexPath.row + 1000;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.isConnectedSwitch addTarget:self action:@selector(changePerpheralCellState:) forControlEvents:UIControlEventValueChanged];
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
//    NSLog(@"pathDict%@", pathDict[[cbPeripheral.identifier UUIDString]][cbPeripheral.name]);
//    NSLog(@"%@", [pathDict[[cbPeripheral.identifier UUIDString]] allKeys][0]);
#pragma mark  ---待开发连接改名--------
    if(cbPeripheral.name !=nil){
#warning ----修改了 UI 名字 等显示方式-------
        //备注名
        cell.tiltLabel.text = pathDict[[NSString stringWithFormat:@"%@", cbPeripheral.identifier]][[pathDict[[NSString stringWithFormat:@"%@", cbPeripheral.identifier]] allKeys][0]];
        //系统名
//        cell.tiltLabel.text = cbPeripheral.name;
        NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cbPeripheral.identifier]] allKeys][0]];
        if ([typeStr isEqualToString:X2INDETEFIER] == YES) {
            cell.typeLabel.text = @"x2mini";
            cell.TilteimageView.image = [UIImage imageNamed:scan_X2ICONIMG];

        }else if ([typeStr isEqualToString:SLIDERINDENTEFIER] == YES){
            
            cell.typeLabel.text = @"slidermini";
            cell.TilteimageView.image = [UIImage imageNamed:scan_SLIDEICONIMG];
        }else if ([typeStr isEqualToString:S1A3_SLIDERINDENTERFIER] == YES){
            
            cell.typeLabel.text = @"S1A3_S1";
            cell.TilteimageView.image = [UIImage imageNamed:scan_SLIDEICONIMG];

        }else if ([typeStr isEqualToString:S1A3_X2INDETIFER] == YES){
            cell.typeLabel.text = @"S1A3_X2";
            cell.TilteimageView.image = [UIImage imageNamed:scan_X2ICONIMG];

        }
    }
    else{
        cell.tiltLabel.text = @"no name";
        [cell removeFromSuperview];
    }
    
    if (cbPeripheral.state == CBPeripheralStateConnected) {
        cell.stateLabel.backgroundColor = [UIColor greenColor];
        cell.modefiyBtn.alpha = 1;
        cell.isConnectedSwitch.on = YES;
        
    }else if (cbPeripheral.state == CBPeripheralStateConnecting){
        cell.stateLabel.backgroundColor = [UIColor redColor];
        cell.modefiyBtn.alpha = 0;
        
        cell.isConnectedSwitch.on = NO;
        
    }else if (cbPeripheral.state == CBPeripheralStateDisconnected){
        
        cell.stateLabel.backgroundColor = [UIColor redColor];
        cell.modefiyBtn.alpha = 0;
        cell.isConnectedSwitch.on = NO;

    }else if (cbPeripheral.state == CBPeripheralStateDisconnecting) {
        cell.stateLabel.backgroundColor = [UIColor redColor];
        cell.modefiyBtn.alpha = 0;

        cell.isConnectedSwitch.on = NO;

    }else{
        cell.stateLabel.backgroundColor = [UIColor redColor];
        cell.modefiyBtn.alpha = 0;
        cell.isConnectedSwitch.on = NO;
    }
    return  cell;
}

-(NSString *)getPrefixTypeString:(NSString *)str{
    
    NSRange range = {1, 4};
    NSString * string = [str substringWithRange:range];
    return string;
    
}
- (NSString *)getNewString:(NSString *)str{
    
    NSMutableString * newstr = [[NSMutableString alloc]initWithString:str];
    NSRange range = [str rangeOfString:IFootagePreFIX];
//    [newstr insertString:@" " atIndex:range.location];
    [newstr insertString:@"  " atIndex:range.location + 8];
    return newstr;
}
/**
 自动连接
 */
- (void)freeConnect{

    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    
    if (dict) {
        for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
            NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];

            BOOL isSliderBool = [typeStr containsString:SLIDERINDENTEFIER];
            BOOL isX2Bool = [typeStr containsString:X2INDETEFIER];
            if (isSliderBool == YES && isX2Bool == NO) {
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
                    [appDelegate.bleManager connectPeripheral: cb];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMothed:) userInfo:cb repeats:NO];
                }
                
            }else if (isSliderBool == NO && isX2Bool == YES){

                NSLog(@"%@, %@", dict[X2KEY], [NSString stringWithFormat:@"%@", cb.identifier]);
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
                    NSLog(@"%@", dict);

                    [appDelegate.bleManager connectPeripheral: cb];
                    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMothed:) userInfo:cb repeats:NO];
                }

            }

        }
    }
}

#pragma mark -------connect连接CB---------
- (void)changePerpheralCellState:(UISwitch *)swi
{
    //如果第一次连接
    CBPeripheral * cb = appDelegate.bleManager.peripherals[swi.tag - 100];
//    BOOL isbool = [cb.name containsObject: @"Slider"];
   
    NSString * idStr = [NSString stringWithFormat:@"%@", cb.identifier];

    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    
    NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];

    BOOL isSliderBool = [typeStr containsString:SLIDERINDENTEFIER];
    BOOL isX2Bool = [typeStr containsString:X2INDETEFIER];
    
    if (dict == nil) {
        if (isSliderBool == YES && isX2Bool == NO) {
            NSDictionary * newdict = [NSDictionary dictionaryWithObjectsAndKeys:@"123", X2KEY, idStr, S1KEY,  nil];

            [newdict writeToFile:path atomically:YES];
            
        }else if (isSliderBool == NO && isX2Bool == YES){
            NSDictionary * newdict = [NSDictionary dictionaryWithObjectsAndKeys:idStr, X2KEY, @"123", S1KEY,  nil];
            [newdict writeToFile:path atomically:YES];

        }
        
    }else{
        if (isSliderBool == YES && isX2Bool == NO) {
            [dict setObject:idStr forKey:S1KEY];
            

        }else if (isSliderBool == NO && isX2Bool == YES){
            
            [dict setObject:idStr forKey:X2KEY];
        }
        [dict writeToFile:path atomically:YES];
    }
    NSMutableDictionary * dict2 = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"===s1  %d ===x2  %d", isSliderBool, isX2Bool);
    NSLog(@"DICT = %@", dict2);
    

    
//    [appDelegate.bleManager writeValue:0xFFC0 characteristicUUID:0xFFC1 p:cb data:[@"920416000000" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (swi.on == NO) {
        UInt64 recordTime = [[NSDate date]timeIntervalSince1970] * 1000;

        [appDelegate.bleManager.CM cancelPeripheralConnection : [appDelegate.bleManager.peripherals objectAtIndex:swi.tag - 100]]; //取消连接
        if (isSliderBool == YES && isX2Bool == NO) {
            [dict setObject:@"123" forKey:S1KEY];
            
        }else if (isSliderBool == NO && isX2Bool == YES){
            
            [dict setObject:@"123" forKey:X2KEY];
        }
        [dict writeToFile:path atomically:YES];
        NSIndexPath * path = [NSIndexPath indexPathForRow:swi.tag - 100 inSection:0];
        iFPeripheralCell * cell = (iFPeripheralCell *)[self.listView cellForRowAtIndexPath:path];
        cell.stateLabel.backgroundColor = [UIColor redColor];
        
    }else{
        
        [appDelegate.bleManager connectPeripheral:[appDelegate.bleManager.peripherals objectAtIndex:swi.tag - 100]];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayMothed:) userInfo:cb repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(SeconduploadPassword:) userInfo:cb repeats:NO];
        
    }
    
//    [self.listView reloadData];
}

- (void)SeconduploadPassword:(NSTimer *)timer{
    
    [appDelegate.bleManager writeValue:0xFFC0 characteristicUUID:0XFFC1 p:[timer userInfo] data:[self.passwordStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"send2_4GPairingAddressNotificationMethod" object:nil];


}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, iFSize(100))];
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return iFSize(100);
}
//校验密码
- (void)delayMothed:(NSTimer *)timer{
    
    [appDelegate.bleManager notification:0xFFC0 characteristicUUID:0xFFC2 p:[timer userInfo] on:YES];
    [appDelegate.bleManager writeValue:0xFFC0 characteristicUUID:0XFFC1 p:[timer userInfo] data:[self.passwordStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"timer%@", timer.userInfo);
    NSLog(@"timer%@", self.passwordStr);
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    
    if (dict) {
        for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
            NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];

            BOOL isSliderBool = [typeStr containsString:SLIDERINDENTEFIER];
            BOOL isX2Bool = [typeStr containsString:X2INDETEFIER];
            
            
            if (isSliderBool == YES && isX2Bool == NO) {
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
                }else{
                    [appDelegate.bleManager.CM cancelPeripheralConnection:cb];

                }
            }else if (isSliderBool == NO && isX2Bool == YES){
                
                NSLog(@"%@, %@", dict[X2KEY], [NSString stringWithFormat:@"%@", cb.identifier]);
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
                    
                }else{
                    [appDelegate.bleManager.CM cancelPeripheralConnection:cb];

                }
                
            }
            
        }
    }

    
    
}




@end
