//
//  ReceiveView.m
//  BLECollection
//
//  Created by rfstar on 14-1-8.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "ReceiveView.h"
#import "Tools.h"
#import <QuartzCore/QuartzCore.h>
#define SLIDEDisConnected appDelegate.bleManager.sliderCB.state == CBPeripheralStateDisconnected
#define X2DisConnected appDelegate.bleManager.panCB.state == CBPeripheralStateDisconnected

@implementation ReceiveView
@synthesize TrackfinalPosition;
@synthesize TrackRealTimePosition;
@synthesize TrackRealTimeVeloc;
@synthesize panRealTimeVeloc;
@synthesize panRealTimePostion;
@synthesize tiltRealTimeVeloc;
@synthesize tiltRealTimePostion;
@synthesize iSGetReady;
@synthesize iSTransfer;
@synthesize SliderRealTimePosition;
@synthesize iSSuccessSet;
@synthesize MissionState;
@synthesize RealTimesFrames;
@synthesize X2MissionState;
@synthesize X2RealTimesFrams;
@synthesize X2panRealTimePosition;
@synthesize X2tiltRealTimePosition;
@synthesize isX2tiltTransfer;
@synthesize iSX2GetReady;
@synthesize iSX2panTransfer;
@synthesize isX2SuccessSet;

+(ReceiveView *)sharedInstance{
    
    static ReceiveView *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[ReceiveView alloc] init];
    }
    return sharedInstance;
}
- (void)getinit{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    IsAscii = YES  ;   //为ascii显示
    receiveByteSize = 0 ;
    isReceive = YES;
    receiveSBString = [NSMutableString new];
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    
    for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
        
        NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];
        
        if ([typeStr isEqualToString:SLIDERINDENTEFIER] == YES) {
            if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
                appDelegate.bleManager.sliderCB = cb;
            }
        }else if([typeStr isEqualToString:X2INDETEFIER] == YES ){
            if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
                appDelegate.bleManager.panCB = cb;
            }
        }else if ([typeStr isEqualToString:S1A3_SLIDERINDENTERFIER] == YES){
//            if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1A3_S1KEY]] == YES) {
                appDelegate.bleManager.S1A3_S1CB = cb;
//            }
        }else if ([typeStr isEqualToString:S1A3_X2INDETIFER] == YES){
//            if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1A3_X2KEY]] == YES) {
                appDelegate.bleManager.S1A3_X2CB = cb;
//            }
        }

    }

}
- (ReceiveView *)init{
    
    if (self = [super init]) {
        
//        [self initView];
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

        IsAscii = YES  ;   //为ascii显示
        receiveByteSize = 0 ;
        isReceive = YES;
        receiveSBString = [NSMutableString new];
        
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
        NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
        
        for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
            
            
            NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];
            
            if ([typeStr isEqualToString:SLIDERINDENTEFIER] == YES) {
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
                    appDelegate.bleManager.sliderCB = cb;
                }
            }else if([typeStr isEqualToString:X2INDETEFIER] == YES ){
                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
                    appDelegate.bleManager.panCB = cb;
                }
            }else if ([typeStr isEqualToString:S1A3_SLIDERINDENTERFIER] == YES){
//                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1A3_S1KEY]] == YES) {
                    appDelegate.bleManager.S1A3_S1CB = cb;
//                }
            }else if ([typeStr isEqualToString:S1A3_X2INDETIFER] == YES){
//                if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1A3_X2KEY]] == YES) {
                    appDelegate.bleManager.S1A3_X2CB = cb;
//                }
            }
        }
        
    }
    return self;
    
}


-(NSString *)getPrefixTypeString:(NSString *)str{
    
    NSRange range = {1, 4};
    NSString * string = [str substringWithRange:range];
    return string;
    
}
//想获取消息传递过来的数据 ，得先注册消息
-(void)initReceviceNotification
{
    [[NSNotificationCenter defaultCenter] addObserver: self
           selector: @selector(ValueChangText:)
               name: @"VALUECHANGUPDATE"
             object: nil];
}
-(void)initView
{
    UIFont  *labelFont =  [UIFont fontWithName:@"Courier" size:15];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UILabel *receiveDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(17,80 , 90, 19)];
    [receiveDataLabel setText:NSLocalizedString(@"SerialChannel_length", @"长度:")];
    [receiveDataLabel setTextAlignment:NSTextAlignmentLeft];
    [receiveDataLabel setBackgroundColor:[UIColor clearColor]];
    [receiveDataLabel setFont:labelFont];
    _bytesSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(receiveDataLabel.frame.origin.x+receiveDataLabel.frame.size.width,receiveDataLabel.frame.origin.y , 83, receiveDataLabel.frame.size.height)];
    [_bytesSizeLabel setText:@"0"];
    [_bytesSizeLabel setBackgroundColor:[UIColor clearColor]];
    [_bytesSizeLabel setFont:labelFont];
    
    UILabel *PKSLabel = [[UILabel alloc]initWithFrame:CGRectMake(_bytesSizeLabel.frame.origin.x+_bytesSizeLabel.frame.size.width,receiveDataLabel.frame.origin.y, 50, receiveDataLabel.frame.size.height)];
    [PKSLabel setText:@"PKS："];
    [PKSLabel setBackgroundColor:[UIColor clearColor]];
    [PKSLabel setFont:labelFont];
    _PKSSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(PKSLabel.frame.origin.x+PKSLabel.frame.size.width,receiveDataLabel.frame.origin.y , 93, receiveDataLabel.frame.size.height)];
    [_PKSSizeLabel setText:@"0"];
    [_PKSSizeLabel setBackgroundColor:[UIColor clearColor]];
    [_PKSSizeLabel setFont:labelFont];
    
    float  height = 285;
        SBLength  =  300;  //最多显示300个
    if([Tools currentResolution] == UIDevice_iPhone5)
    {
        height = 370;
        SBLength = 370;
    }
    _receiveDataTxt = [[UITextView alloc]initWithFrame:CGRectMake(10,receiveDataLabel.frame.origin.y +receiveDataLabel.frame.size.height, 300, height)];
    [_receiveDataTxt setEditable:NO];
    UIFont *font = [UIFont fontWithName:@"Courier-Bold" size:18];

//    NSLog(@" font array %@", [UIFont familyNames]);
    [_receiveDataTxt setFont:font];
    [_receiveDataTxt setReturnKeyType:UIReturnKeyDone];
    
    [self addSubview:receiveDataLabel];
    [self addSubview:_bytesSizeLabel];
    [self addSubview:PKSLabel];
    [self addSubview:_PKSSizeLabel];
    [self addSubview:_receiveDataTxt];
    
    self.receiveDataTxt.layer.cornerRadius = 10;
    self.receiveDataTxt.layer.borderWidth = 1;
    self.receiveDataTxt.layer.borderColor = [Tools colorWithHexString:@"#7D9EC0"].CGColor;
    [self setFrame:CGRectMake(0, 0, self.frame.size.width,_receiveDataTxt.frame.origin.y+_receiveDataTxt.frame.size.height)];

}
//调整receiveDataTxt的高
-(void)setMessageHeightCut:(int)y
{
    [_receiveDataTxt  setFrame:CGRectMake(_receiveDataTxt.frame.origin.x, _receiveDataTxt.frame.origin.y, _receiveDataTxt.frame.size.width, _receiveDataTxt.frame.size.height-y)];
    [self setFrame:CGRectMake(0,-7.5, self.frame.size.width,_receiveDataTxt.frame.origin.y+_receiveDataTxt.frame.size.height)];
    
     SBLength = 185;
}
-(void)clearText
{
    receiveByteSize = 0;
    countPKSSize = 0;
    [_receiveDataTxt setText:@""];
    [_bytesSizeLabel setText:@"0"];
    [_PKSSizeLabel setText:@"0"];
    receiveSBString = nil;
    receiveSBString = [NSMutableString new];
}
-(void)stopeReceive
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"VALUECHANGUPDATE" object:nil];
}
-(void)receiveEnable:(Boolean)boo  //是否接收数据
{

#warning 连个Mode 现在强行不为0  9.27 找到一个更好的方式至为0  就可以解决问题 现在还要加自动跳转提示界面
    
    
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [cachesDir stringByAppendingPathComponent:IFootagePLISTSufFIX];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    NSString *path1 = [cachesDir stringByAppendingPathComponent:IFootageCBLISTSufFIX];
    NSMutableDictionary * pathDict = [[NSMutableDictionary alloc]initWithContentsOfFile:path1];
    
    
    for (CBPeripheral * cb in appDelegate.bleManager.peripherals) {
        
        NSString * typeStr = [self getPrefixTypeString:[pathDict[[NSString stringWithFormat:@"%@", cb.identifier]] allKeys][0]];
        
        if ([typeStr isEqualToString:SLIDERINDENTEFIER] == YES) {
            if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[S1KEY]] == YES) {
                appDelegate.bleManager.sliderCB = cb;
            }
        }else if([typeStr isEqualToString:X2INDETEFIER] == YES ){
            if ([[NSString stringWithFormat:@"%@", cb.identifier] isEqualToString:dict[X2KEY]] == YES) {
                appDelegate.bleManager.panCB = cb;
            }
        }else if ([typeStr isEqualToString:S1A3_SLIDERINDENTERFIER] == YES){
                appDelegate.bleManager.S1A3_S1CB = cb;
        }else if ([typeStr isEqualToString:S1A3_X2INDETIFER] == YES){
                appDelegate.bleManager.S1A3_X2CB = cb;
        }
    }
    
    [appDelegate.bleManager notification:0xFFE0 characteristicUUID:0xFFE4 p:appDelegate.bleManager.sliderCB on:YES];
    [appDelegate.bleManager notification:0xFFE0 characteristicUUID:0xFFE4 p:appDelegate.bleManager.panCB on:YES];
    [appDelegate.bleManager notification:0xFFE0 characteristicUUID:0xFFE4 p:appDelegate.bleManager.S1A3_S1CB on:YES];
    [appDelegate.bleManager notification:0xFFE0 characteristicUUID:0xFFE4 p:appDelegate.bleManager.S1A3_X2CB on:YES];
}


- (void)Shark_MiniTextNotification:(NSNotification *)notification{
#warning 临时加的 为了防止Mode为0x02不变 所做的强制改变

    if(isReceive)  //为真时，才接收数据
    {
        //这里取出刚刚从过来的字符串
        CBCharacteristic *tmpCharacter = (CBCharacteristic*)[notification object];
        //        NSLog(@"%ld", tmpCharacter.value.length);
        if (tmpCharacter.value.length < 20) {
            return;
        }
        CHAR_STRUCT buf1;
        
        //将获取的值传递到buf1中；
        [tmpCharacter.value getBytes:&buf1 length:tmpCharacter.value.length];
        //        NSLog(@"%@", tmpCharacter.value);
        
        receiveByteSize += tmpCharacter.value.length;  //计算收到的所有数据包的长度
        countPKSSize++;
        if(IsAscii) //Ascii
        {
            for(int i =0;i<tmpCharacter.value.length;i++)
            {
                [receiveSBString appendString:[Tools stringFromHexString:[NSString stringWithFormat:@"%02X",buf1.buff[i]&0x000000ff]]];
            }
            
        }else {//十六进制显示
            for(int i =0;i<tmpCharacter.value.length;i++)
            {
#warning --------receiveSBString接收的每条数据-------解析--
                [receiveSBString appendString:[NSString stringWithFormat:@"%02X",buf1.buff[i]&0x000000ff]];
                
                int sum = 0;
                for (int j = 0 ; j < 19; j++) {
                    
                    sum =  sum + buf1.buff[j]&0x0000000ff;
                    if (j == 18) {
                        
                        if (sum == (buf1.buff[19]&0x000000ff)) {
                            
                            if (buf1.buff[0] == 0x56)  {
                                self.updateBytesNumber = buf1.buff[1] * 256 + buf1.buff[2];
                                self.updateMode = buf1.buff[3];
                                
                                
                                self.X2UpdateBytesNumber = buf1.buff[1] * 256 + buf1.buff[2];
                                
                                
                                self.X2PositionInfo = (UInt64)buf1.buff[3] << 56 | (UInt64)buf1.buff[4] << 48| (UInt64)buf1.buff[5] << 40| (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                
                            }
                            if (buf1.buff[0] == 0xAB) {
                                
                                self.slideUpdateBytesNumber = buf1.buff[1] * 256 + buf1.buff[2];
                                
                                self.slideUpdateMode = buf1.buff[3];
                                self.slidePositionInfo = (UInt64)buf1.buff[3] << 56 | (UInt64)buf1.buff[4] << 48| (UInt64)buf1.buff[5] << 40| (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                
                                
                            }
                            
                            
                            if (buf1.buff[0] == 0x55) {
                                
                                _X2MODE = buf1.buff[2];
                                
                                if (buf1.buff[2] == 0x01) {
                                    panRealTimePostion = buf1.buff[3] * 256 + buf1.buff[4];
                                    tiltRealTimePostion = buf1.buff[5] * 256 + buf1.buff[6];
                                    panRealTimeVeloc = buf1.buff[7] * 256 + buf1.buff[8];
                                    tiltRealTimeVeloc = buf1.buff[9] * 256 + buf1.buff[10];
                                    
                                }else if (buf1.buff[2] == 0x02) {
                                    
//                                    NSLog(@"%@", notification);
                                    
                                    self.x2ModeID = buf1.buff[3];
                                    if (self.x2ModeID != 0x02) {
                                    
                                    }
                                    
                                    self.x2Timer = (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    
                                    self.x2receiveMode = buf1.buff[8];
                                    self.panbezierPosParam = buf1.buff[9];
                                    self.panbezierTimeParam = buf1.buff[10];
                                    self.tiltbezierPosParam = buf1.buff[11];
                                    self.tiltbezierTimerParam = buf1.buff[12];
                                    self.x2frames = (UInt32)buf1.buff[13] << 24 | (UInt32)buf1.buff[14] << 16 | (UInt32)buf1.buff[15] << 8 | (UInt32)buf1.buff[16];
                                    
                                    self.X2timelineIsVideo = (buf1.buff[17] & 0x80) >> 7;
                                    self.X2timelinePercent = (buf1.buff[17] & 0x7f);
                                    self.x2Isloop = buf1.buff[18];
                                    
                                }else if (buf1.buff[2] == 0x03){
                                    
                                    self.x2TotalFrames = (UInt32)buf1.buff[7] << 24 | (UInt32)buf1.buff[8] << 16 | (UInt32)buf1.buff[9] << 8 | (UInt32)buf1.buff[10];
                                    //                                NSLog(@"%d", self.x2TotalFrames);
                                    
                                }else if (buf1.buff[2] == 0x04){
                                    
                                    
                                    self.x2VideoTime = (UInt32)buf1.buff[3] << 24 | (UInt32)buf1.buff[4] << 16 | (UInt32)buf1.buff[5] << 8 | (UInt32)buf1.buff[6];
                                    
                                }else if (buf1.buff[2] == 0x05){
                                    
                                    self.x2StopMotionTimeMode = buf1.buff[3];
                                    self.x2StopMotionCurruntFrame = (UInt32)buf1.buff[11] << 24 | (UInt32)buf1.buff[12] << 16 | (UInt32)buf1.buff[13] << 8 | (UInt32)buf1.buff[14];
                                }else if (buf1.buff[2] == 0x08){
                                    
                                    self.Gimode = buf1.buff[3];
                                    
                                    
                                    self.GipanRealAngle = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.GitiltRealAngle = buf1.buff[6] * 256 + buf1.buff[7];
                                    self.GipanStartAngle = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.GitiltStartAngle = buf1.buff[10] * 256 + buf1.buff[11];
                                    self.GipanEndAngle = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.GitiltEndAngle = buf1.buff[14] * 256 + buf1.buff[15];
                                    self.GiFrameCurrent = buf1.buff[16] * 256 + buf1.buff[17];
                                    self.GiInterval = buf1.buff[18];
                                    
                                }else if (buf1.buff[2] == 0x07){
                                    self.Pamode = buf1.buff[3];
                                    self.PaAngle = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.PaStartAngle = buf1.buff[6] * 256 + buf1.buff[7];
                                    self.PaEndAngle = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.PaFrameCurrent = buf1.buff[10] * 256 + buf1.buff[11];
                                    self.PaInterval = buf1.buff[18];
                                }else if (buf1.buff[2] == 0x00){
                                    //                                NSLog(@"0000000000000000x2");
                                    //                                NSLog(@"\r\n Notification = %@", notification);
                                    
                                    if (self.X2checkZeroMode == 0x00) {
                                        self.isReturnZero = YES;
                                    }else{
                                        self.isX2ReturnWarning = YES;
                                        self.isReturnZero = NO;
                                    }
                                    
                                    
                                    self.X2ProNumber = (UInt32)buf1.buff[3] << 16 | (UInt32)buf1.buff[4] << 8 | (UInt32)buf1.buff[5];
                                    
                                    self.X2_2_4GAddress  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                    self.X2proStr = [NSString stringWithFormat:@"%.2x%.2x%.2x", buf1.buff[3], buf1.buff[4], buf1.buff[5]];
                                    self.X2version = buf1.buff[11];
                                    self.X2isUpdateMode = buf1.buff[12];
                                    self.X2isReturnOnSlide = buf1.buff[13];
                                    
                                    self.X2battery = buf1.buff[14];
                                    self.X2isConnect_24G = buf1.buff[17];

                                    self.X2isConnect5V = buf1.buff[18];
                                    
                                    NSDictionary * dict = @{@"X2_2_4GAddress":[NSNumber numberWithUnsignedLongLong:self.X2_2_4GAddress], @"slideBattery":[NSNumber numberWithInt:self.X2battery], @"X2isConnect5V":[NSNumber numberWithBool:self.X2isConnect5V]};
                                   
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusViewNotificationMethod" object:dict];
                                    
                                }else if (buf1.buff[2] == 0x09){
                                    
                                    
                                    self.FMx2_AB_Mark = (buf1.buff[3] & 0xf0) >> 4;
                                    self.FMx2Mode = (buf1.buff[3] & 0x0f);
                                    
                                    
                                    self.FMx2PanVeloc = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.FMx2tiltVeloc = buf1.buff[6] * 256 + buf1.buff[7];
                                    
                                    self.FMx2RealPanAngle = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.FMx2RealTiltAngle = buf1.buff[10] * 256 + buf1.buff[11];
                                    
                                    self.FMx2RecordPanAngle = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.FMx2RecordTiltAngle = buf1.buff[14] * 256 + buf1.buff[15];
                                    
                                    self.FMx2Totaltime = buf1.buff[16] * 256 + buf1.buff[17];
                                    
                                    
                                }else if ((buf1.buff[2] == 0x0a) || (buf1.buff[2] == 0x0d)){
                                    self.FMx2taskMode = buf1.buff[3];
                                    self.FMx2taskStarttime =  (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    self.FMx2taskRuntime = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.FMx2taskisloop = buf1.buff[10];
                                    self.FMx2taskdirection = buf1.buff[11];
                                    self.FMx2RealPanAngle = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.FMx2RealTiltAngle = buf1.buff[14] * 256 + buf1.buff[15];
                                    
                                    self.FMx2taskisMarkA_B = buf1.buff[16];
                                    self.FMx2taskPercent = buf1.buff[17];
                                    self.FMx2taskSmoothnessLevel = buf1.buff[18];
                                    
                                    
                                }else if (buf1.buff[2] == 0x0b){
                                    self.x224GAdress  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                    
                                    //                                NSLog(@"x2 = %llx", self.x224GAdress);
                                    
                                }else if (buf1.buff[2] == 0x0c){
                                    
                                    
                                    self.X2checkZeroMode = buf1.buff[3];
                                    if (self.X2checkZeroMode == 0x00) {
                                        self.isX2ReturnWarning = NO;
                                        self.isReturnZero = YES;
                                        
                                    }else if (self.X2checkZeroMode == 0x04){
                                        self.isReturnZero = YES;
                                        
                                        self.isX2ReturnWarning = YES;
                                    }else{
                                        
                                        //                                    if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected) {
                                        if (self.S1checkZeroMode == 0x00) {
                                            break;
                                        }
                                        //                                    }
                                        self.isX2ReturnWarning = YES;
                                        self.isReturnZero = NO;
                                    }
                                    
                                }
                                
                            }
                            
                            
                            if (buf1.buff[0] == 0xaa) {
                                
                                
                                _S1MODE = buf1.buff[2];
                                
                                if (buf1.buff[2] == 0x01) {
                                    
                                    /**
                                     手动
                                     
                                     @param buf1.buff buf1.buff description
                                     @return return value description
                                     */
                                    TrackRealTimePosition = (buf1.buff[3]) * 256 + buf1.buff[4];
                                    TrackfinalPosition = (buf1.buff[5]) * 256 + buf1.buff[6];
                                    TrackRealTimeVeloc = (buf1.buff[7]) * 256 + buf1.buff[8];
                                    
                                }else if(buf1.buff[2] == 0x02){
                                    
//                                    NSLog(@"%@", notification);

                                    self.slideModeID = buf1.buff[3];
                                    
                                    if (self.slideModeID != 0x02) {
                                        
                                        
                                        //                                    NSLog(@"notification%@", [notification object]);
                                        
                                    }
                                    self.slideTimer = (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    
                                    
                                    self.slidereceiveMode = buf1.buff[8];
                                    self.slidebezierPosParam = buf1.buff[9];
                                    self.slidebezierTimeParam = buf1.buff[10];
                                    self.slideframes = (UInt32)buf1.buff[11] << 24 | (UInt32)buf1.buff[12] << 16 | (UInt32)buf1.buff[13] << 8 | (UInt32)buf1.buff[14];
                                    self.S1timelineIsVideo = (buf1.buff[17] & 0x80) >> 7;
                                    self.S1timelinePercent = (buf1.buff[17] & 0x7f);
                                    self.slideIsloop = buf1.buff[18];
                                    
                                    
                                }else if (buf1.buff[2] == 0x03){
                                    
                                    self.slideTotalFrames = (UInt32)buf1.buff[7] << 24 | (UInt32)buf1.buff[8] << 16 | (UInt32)buf1.buff[9] << 8 | (UInt32)buf1.buff[10];
                                    
                                    
                                }else if (buf1.buff[2] == 0x04){
                                    
                                    self.slideVideoTime = (UInt32)buf1.buff[3] << 24 | (UInt32)buf1.buff[4] << 16 | (UInt32)buf1.buff[5] << 8 | (UInt32)buf1.buff[6];
                                }else if (buf1.buff[2] == 0x05){
                                    
                                    self.slideStopMotionMode = buf1.buff[3];
                                    
                                    self.slideStopMotionCurruntFrame = (UInt32)buf1.buff[11] << 24 | (UInt32)buf1.buff[12] << 16 | (UInt32)buf1.buff[13] << 8 | (UInt32)buf1.buff[14];
                                }else if (buf1.buff[2] == 0x00){
                                    
                              
                                    
                                    self.isReturnZero = NO;
                                    
                                    self.slideProNumber =(UInt32)buf1.buff[3] << 16 | (UInt32)buf1.buff[4] << 8|(UInt32)buf1.buff[5];
                                    
                                    self.S1proStr = [NSString stringWithFormat:@"%.2x%.2x%.2x", buf1.buff[3], buf1.buff[4], buf1.buff[5]];

                                    self.slide_2_4GAddress  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                    self.slideisUpdateMode = buf1.buff[12];
                                    self.slideversion = buf1.buff[11];
                                    self.sectionsNumber = buf1.buff[13];
                                    self.slideBattery = buf1.buff[14];
                                    self.slideisConnect_24G = buf1.buff[17];
                                    self.slideisConnect5V = buf1.buff[18];
    
                                    NSDictionary * dict = @{@"slide_2_4GAddress":[NSNumber numberWithUnsignedLongLong:self.slide_2_4GAddress], @"slideBattery":[NSNumber numberWithInt:self.slideBattery], @"slideisConnect5V":[NSNumber numberWithBool:self.slideisConnect5V]};
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusViewNotificationMethod" object:dict];
                                    
                                }else if (buf1.buff[2] == 0x09){
                                    
                                    self.FMslide_AB_Mark = (buf1.buff[3] & 0xf0) >> 4;
                                    self.FMslideMode = (buf1.buff[3] & 0x0f);
                                    
                                    
                                    
                                    self.FMslideVeloc = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.FMslideRealPosition = (UInt32)buf1.buff[6] << 24 | (UInt32)buf1.buff[7] << 16 | (UInt32)buf1.buff[8] << 8 | (UInt32)buf1.buff[9];
                                    
                                    if (self.FMslide_AB_Mark == 5) {
                                        
                                        self.FMslideApointPosition = (UInt32)buf1.buff[12] << 24 | (UInt32)buf1.buff[13] << 16 | (UInt32)buf1.buff[14] << 8 | (UInt32)buf1.buff[15];
                                        
                                    }else if (self.FMslide_AB_Mark == 6){
                                        self.FMslideBpointPosition = (UInt32)buf1.buff[12] << 24 | (UInt32)buf1.buff[13] << 16 | (UInt32)buf1.buff[14] << 8 | (UInt32)buf1.buff[15];

                                    }else if (buf1.buff[3] == 7){
                                        self.FMslideApointPosition = 0;
                                        self.FMslideBpointPosition = 0 ;
                                    }
                                    
                           
                                    self.FMslideTotalTime = buf1.buff[17] * 256 + buf1.buff[18];
                                    
                                    
                                }else if ((buf1.buff[2] == 0x0a) || (buf1.buff[2] == 0x0d)){
                                    
                                    self.FMTaskslideMode = buf1.buff[3];
                                    self.FMtaskslideStarttime =  (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    self.FMtaskslideRuntime = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.FMtaskslideisloop = buf1.buff[10];
                                    self.FMtaskslidedirection = buf1.buff[11];
                                    
                                    self.FMslideRealPosition = (UInt32)buf1.buff[12] << 24 | (UInt32)buf1.buff[13] << 16 | (UInt32)buf1.buff[14] << 8 | (UInt32)buf1.buff[15];
                                    self.FMtaskSlideisMarkA_B = buf1.buff[16];
                                    self.FMtaskSlidePercent = buf1.buff[17];
                                    self.FMtaskSlideSmoothnessLevel = buf1.buff[18];
                                    
                                }else if (buf1.buff[2] == 0x0b){
                                    self.slide24GAdress  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                    //                                NSLog(@"s1 = %llx", self.slide24GAdress);
                                    
                                }
                                else if (buf1.buff[2] == 0x0c){
                                    self.isReturnZero = YES;
                                    
                                    self.S1checkZeroMode = buf1.buff[3];
                                    self.S1checkZeroRealPosition = buf1.buff[5] * 256 + buf1.buff[6];
                                    self.S1checkZeroRealVeloc = buf1.buff[7] * 256 + buf1.buff[8];
                                    self.S1checkZeroLeftSensorStandardValue = buf1.buff[9] * 256 + buf1.buff[10];
                                    self.S1checkZeroRightSensorStandardValue = buf1.buff[11] * 256 + buf1.buff[12];
                                    self.S1checkZeroLeftSensorRealValue = buf1.buff[13] * 256 + buf1.buff[14];
                                    self.S1checkZeroRightSensorRealValue = buf1.buff[15] * 256 + buf1.buff[16];
                                    
                                }else{
                                    self.isReturnZero = NO;
                                    
                                }
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
        if(receiveSBString.length<=SBLength)  //处理返回的数据，让界面上显示最新的数据，为receiveSBString的后300个
        {
            [_receiveDataTxt setText:receiveSBString];
        }else{
            NSInteger index = receiveSBString.length - SBLength;
            //            NSLog(@" 截取数据 的长度 %d" ,(int)index);
            NSString *tmpStr = [receiveSBString substringFromIndex:index];
            [_receiveDataTxt setText:tmpStr];
        }
        _bytesSizeLabel.text =  [NSString stringWithFormat:@"%ld",receiveByteSize];
        _PKSSizeLabel.text = [NSString stringWithFormat:@"%d",countPKSSize];
    }
   
}

- (void)Shark_S1A3TextNotification:(NSNotification *)notification{
    
    if(isReceive)  //为真时，才接收数据
    {
        //这里取出刚刚从过来的字符串
        CBCharacteristic *tmpCharacter = (CBCharacteristic*)[notification object];
        //        NSLog(@"%ld", tmpCharacter.value.length);
        if (tmpCharacter.value.length < 20) {
            return;
        }
        CHAR_STRUCT buf1;
        
        //将获取的值传递到buf1中；
        [tmpCharacter.value getBytes:&buf1 length:tmpCharacter.value.length];
        //        NSLog(@"%@", tmpCharacter.value);
        
        receiveByteSize += tmpCharacter.value.length;  //计算收到的所有数据包的长度
        countPKSSize++;
        if(IsAscii) //Ascii
        {
            for(int i =0;i<tmpCharacter.value.length;i++)
            {
                [receiveSBString appendString:[Tools stringFromHexString:[NSString stringWithFormat:@"%02X",buf1.buff[i]&0x000000ff]]];
            }
            
        }else {//十六进制显示
            for(int i =0;i<tmpCharacter.value.length;i++)
            {
#warning --------receiveSBString接收的每条数据-------解析--
                [receiveSBString appendString:[NSString stringWithFormat:@"%02X",buf1.buff[i]&0x000000ff]];

                int sum = 0;
                for (int j = 0 ; j < 19; j++) {
                    
                    sum =  sum + buf1.buff[j]&0x0000000ff;
                    if (j == 18) {
                        
                        if (sum == (buf1.buff[19]&0x000000ff)) {
                            
                            if (buf1.buff[0] == 0x56)  {
                                self.S1A3_X2_UpdateBytesNumber = buf1.buff[1] * 256 + buf1.buff[2];
                                self.S1A3_X2_PositionInfo = (UInt64)buf1.buff[3] << 56 | (UInt64)buf1.buff[4] << 48| (UInt64)buf1.buff[5] << 40| (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                            }
                            if (buf1.buff[0] == 0xAB) {
                                

                                self.S1A3_S1_UpdateBytesNumber = buf1.buff[1] * 256 + buf1.buff[2];
                                self.S1A3_S1_PositionInfo = (UInt64)buf1.buff[3] << 56 | (UInt64)buf1.buff[4] << 48| (UInt64)buf1.buff[5] << 40| (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                
                                
                            }
                            
                            if (buf1.buff[0] == 0x55) {
                                _S1A3_X2MODE = buf1.buff[2];

                                
                                if (buf1.buff[2] == 0x01) {
                                    
                                    self.S1A3_X2_PanRealPosition = buf1.buff[3] * 256 + buf1.buff[4];
                                    self.S1A3_X2_TiltRealPosition = buf1.buff[5] * 256 + buf1.buff[6];
                                    self.S1A3_X2_PanRealVeloc= buf1.buff[7] * 256 + buf1.buff[8];
                                    self.S1A3_X2_TiltRealVeloc = buf1.buff[9] * 256 + buf1.buff[10];
                                    
                                }else if (buf1.buff[2] == 0x02) {

                                    self.S1A3_X2_Timeline_TaskMode = buf1.buff[3];
                                    
                                    self.S1A3_X2_Timeline_StartTimer = (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    
                                    self.S1A3_X2_Timeline_ReceiveMode = buf1.buff[8];
                                    self.S1A3_X2_Timeline_Pan_BezierPosParam = buf1.buff[9];
                                    self.S1A3_X2_Timeline_Pan_BezierTimeParam = buf1.buff[10];
                                    self.S1A3_X2_Timeline_Tilt_BezierPosParam = buf1.buff[11];
                                    self.S1A3_X2_Timeline_Tilt_BezierTimeParam = buf1.buff[12];
                                    self.S1A3_X2_Timeline_Frames = (UInt32)buf1.buff[13] << 24 | (UInt32)buf1.buff[14] << 16 | (UInt32)buf1.buff[15] << 8 | (UInt32)buf1.buff[16];
                                    self.S1A3_X2_Timeline_TimelineIsVideo = (buf1.buff[17] & 0x80) >> 7;
                                    self.S1A3_X2_Timeline_TimelinePercent = (buf1.buff[17] & 0x7f);
                                    self.S1A3_X2_Timeline_Isloop = buf1.buff[18];
                                    
                                    
                                }else if (buf1.buff[2] == 0x03){

                                    self.S1A3_X2_Timelapse_Interval = buf1.buff[3] * 256 + buf1.buff[4];
                                    self.S1A3_X2_Timelapse_Exposure = buf1.buff[5] * 256 + buf1.buff[6];
                                    self.S1A3_X2_Timelapse_TotalFrames = (UInt32)buf1.buff[7] << 24 | (UInt32)buf1.buff[8] << 16 | (UInt32)buf1.buff[9] << 8 | (UInt32)buf1.buff[10];
                                    self.S1A3_X2_Timelapse_FunctionMode = buf1.buff[11];
                                    self.S1A3_X2_Timelapse_NumBezier = buf1.buff[12];
                                    self.S1A3_X2_Timelapse_Buffer_second = buf1.buff[13] * 256 + buf1.buff[14];
                                    
                                    
                                    
                                    
                                }else if (buf1.buff[2] == 0x04){
                                    
                                    
                                    self.S1A3_X2_Video_TotalTime = (UInt32)buf1.buff[3] << 24 | (UInt32)buf1.buff[4] << 16 | (UInt32)buf1.buff[5] << 8 | (UInt32)buf1.buff[6];
                                    self.S1A3_X2_Video_Pan_TiltNumBezier = buf1.buff[12];
                                    
                                    
                                }else if (buf1.buff[2] == 0x05){
                                    self.S1A3_X2_StopMotion_Mode = buf1.buff[3];
                                    self.S1A3_X2_StopMotion_CurrentFrame = (UInt32)buf1.buff[11] << 24 | (UInt32)buf1.buff[12] << 16 | (UInt32)buf1.buff[13] << 8 | (UInt32)buf1.buff[14];
                                }else if (buf1.buff[2] == 0x08){

                                    self.S1A3_X2_Grid_Mode = buf1.buff[3];
                                    self.S1A3_X2_Grid_PanAngle = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.S1A3_X2_Grid_TiltAngle = buf1.buff[6] * 256 + buf1.buff[7];
                                    self.S1A3_X2_Grid_StartPanAngle = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.S1A3_X2_Grid_StartTiltAngle = buf1.buff[10] * 256 + buf1.buff[11];
                                    self.S1A3_X2_Grid_EndPanAngle = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.S1A3_X2_Grid_EndTiltAngle = buf1.buff[14] * 256 + buf1.buff[15];
                                    self.S1A3_X2_Grid_FrameNow = buf1.buff[16] * 256 + buf1.buff[17];
                                    self.S1A3_X2_Grid_Interval = buf1.buff[18];
                                    
                                    
                                    
                                }else if (buf1.buff[2] == 0x07){

                                    self.S1A3_X2_Pano_Mode = buf1.buff[3];
                                    self.S1A3_X2_Pano_Angle = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.S1A3_X2_Pano_StartAngle = buf1.buff[6] * 256 + buf1.buff[7];
                                    self.S1A3_X2_Pano_EndAngle = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.S1A3_X2_Pano_CurrentFrame = buf1.buff[10] * 256 + buf1.buff[11];
                                    self.S1A3_X2_Pano_Tilt_RealVeloc = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.S1A3_X2_Pano_Interval = buf1.buff[18];
                                   
                                }else if (buf1.buff[2] == 0x00){
                                    self.S1A3_X2_ProNumber = (UInt32)buf1.buff[3] << 16 | (UInt32)buf1.buff[4] << 8|(UInt32)buf1.buff[5];
                                    self.S1A3_X2_proStr = [NSString stringWithFormat:@"%.2x%.2x%.2x", buf1.buff[3], buf1.buff[4], buf1.buff[5]];
                                    self.S1A3_X2_UpdateMode = buf1.buff[12];
                                    self.S1A3_X2_2_4GAddress  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                    self.S1A3_X2_Version = buf1.buff[11];
                                    self.S1A3_X2_BatteryNum = buf1.buff[14];
                                    self.S1A3_X2_isConnect_24G = buf1.buff[18];
                                    NSDictionary * dict = @{@"S1A3_X2_2_4GAddress":[NSNumber numberWithUnsignedLongLong:self.S1A3_X2_2_4GAddress], @"S1A3_X2_BatteryNum":[NSNumber numberWithInt:self.S1A3_X2_BatteryNum], @"S1A3_X2_isConnect5V":[NSNumber numberWithBool:NO]};
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusViewNotificationMethod" object:dict];
                                    
                                }else if (buf1.buff[2] == 0x09){
                                
                                    self.S1A3_X2_Target_Mode = (buf1.buff[3] & 0x0f);
                                    self.S1A3_X2_Target_AB_Mark = (buf1.buff[3] & 0xf0) >> 4;
                                    self.S1A3_X2_Target_Pan_Veloc = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.S1A3_X2_Target_Tilt_Veloc = buf1.buff[6] * 256 + buf1.buff[7];
                                    self.S1A3_X2_Target_Pan_RealAngle = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.S1A3_X2_Target_Tilt_RealAngle = buf1.buff[10] * 256 + buf1.buff[11];
                                    self.S1A3_X2_Target_Pan_RecordAngle = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.S1A3_X2_Target_Tilt_RecordAngle = buf1.buff[14] * 256 + buf1.buff[15];
                                    self.S1A3_X2_Target_totalTime = buf1.buff[17] * 256 + buf1.buff[18];
                                }else if (buf1.buff[2] == 0x0a){
                                    
        
                                    self.S1A3_X2_Target_Task_Mode = buf1.buff[3];
                                    self.S1A3_X2_Target_Task_StartTime = (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    self.S1A3_X2_Target_Task_RunTime = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.S1A3_X2_Target_Task_Isloop = buf1.buff[10];
                                    self.S1A3_X2_Target_Task_Direction = buf1.buff[11];
                                    self.S1A3_X2_Target_Task_PanRealAngle = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.S1A3_X2_Target_Task_TiltRealAngle = buf1.buff[14] * 256 + buf1.buff[15];
                                    self.S1A3_X2_Target_Task_IsMark_A_B = buf1.buff[16];
                                    self.S1A3_X2_Target_Task_Percent = buf1.buff[17];
                                    self.S1A3_X2_Target_Task_smoothlevel = buf1.buff[18];
                                    
                                }else if (buf1.buff[2] == 0x0b){
                                    
                                    self.S1A3_X2_2_4GAddress_TimeStamp  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                          
                                }else if (buf1.buff[2] == 0x0c){
                                    
                                }
                                    
                                }
                                
                            }
                            if (buf1.buff[0] == 0xaa) {
                            
                                _S1A3_S1MODE = buf1.buff[2];

                                if (buf1.buff[2] == 0x01) {
                                    self.S1A3_S1_TrackRealPosition = buf1.buff[3] * 256 + buf1.buff[4];
                                    self.S1A3_S1_TrackLength = buf1.buff[5] * 256 + buf1.buff[6];
                                    self.S1A3_S1_TrackRealVeloc = buf1.buff[7] * 256 + buf1.buff[8];
                                    

                                }else if(buf1.buff[2] == 0x02){

                                    self.S1A3_S1_Timeline_TaskMode = buf1.buff[3];
                                    self.S1A3_S1_Timeline_StartTimer = (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    self.S1A3_S1_Timeline_ReceiveMode = buf1.buff[8];
                                    self.S1A3_S1_Timeline_BezierPosParam = buf1.buff[9];
                                    self.S1A3_S1_Timeline_BezierTimeParam = buf1.buff[10];
                                    self.S1A3_S1_Timeline_Frames = (UInt32)buf1.buff[11] << 24 | (UInt32)buf1.buff[12] << 16 | (UInt32)buf1.buff[13] << 8 | (UInt32)buf1.buff[14];
                                    self.S1A3_S1_Timeline_TimelineIsVideo = (buf1.buff[17] & 0x80) >> 7;
                                    self.S1A3_S1_Timeline_TimelinePercent = (buf1.buff[17] & 0x7f);
                                    self.S1A3_S1_Timeline_Isloop = buf1.buff[18];
                                    
                                }else if (buf1.buff[2] == 0x03){
                                    self.S1A3_S1_Timelapse_Interval = buf1.buff[3] * 256 + buf1.buff[4];
                                    self.S1A3_S1_Timelapse_Exposure = buf1.buff[5] * 256 + buf1.buff[6];
                                    self.S1A3_S1_Timelapse_TotalFrames = (UInt32)buf1.buff[7] << 24 | (UInt32)buf1.buff[8] << 16 | (UInt32)buf1.buff[9] << 8 | (UInt32)buf1.buff[10];
                                    self.S1A3_S1_Timelapse_FunctionMode = buf1.buff[11];
                                    self.S1A3_S1_Timelapse_NumBezier = buf1.buff[12];
                                    self.S1A3_S1_Timelapse_Buffer_second = buf1.buff[13] * 256 + buf1.buff[14];
                                  
                        
                                }else if (buf1.buff[2] == 0x04){
                                    
                                    self.S1A3_S1_Video_TotalTime = (UInt32)buf1.buff[3] << 24 | (UInt32)buf1.buff[4] << 16 | (UInt32)buf1.buff[5] << 8 | (UInt32)buf1.buff[6];
                                    self.S1A3_S1_Video_NumBezier = buf1.buff[12];
                                    
                                }else if (buf1.buff[2] == 0x05){
                                    self.S1A3_S1_StopMotion_Mode = buf1.buff[3];
                                    self.S1A3_S1_StopMotion_CurrentFrame = (UInt32)buf1.buff[11] << 24 | (UInt32)buf1.buff[12] << 16 | (UInt32)buf1.buff[13] << 8 | (UInt32)buf1.buff[14];
                                    
                                }else if (buf1.buff[2] == 0x00){
//                                    NSLog(@"notification%@", notification);
                                    
                                    self.S1A3_S1_ProNumber =(UInt32)buf1.buff[3] << 16 | (UInt32)buf1.buff[4] << 8|(UInt32)buf1.buff[5];
                                    self.S1A3_S1_proStr = [NSString stringWithFormat:@"%.2x%.2x%.2x", buf1.buff[3], buf1.buff[4], buf1.buff[5]];

                                    self.S1A3_S1_2_4GAddress  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                    self.S1A3_S1_Version = buf1.buff[11];
                                    self.S1A3_S1_UpdateMode = buf1.buff[12];
                                    self.S1A3_S1_TrackNumber = buf1.buff[13];
                                    self.S1A3_S1_BatteryNum = buf1.buff[14];
                                    self.S1A3_S1_isConnect_24G = buf1.buff[18];
                                    if (self.S1A3_S1_isConnect_24G != 0x05) {
                                        NSLog(@"%d", self.S1A3_S1_isConnect_24G);
                                    }
                                    NSDictionary * dict = @{@"S1A3_S1_2_4GAddress":[NSNumber numberWithUnsignedLongLong:self.S1A3_S1_2_4GAddress], @"S1A3_S1_BatteryNum":[NSNumber numberWithInt:self.S1A3_S1_BatteryNum], @"S1A3_S1_isConnect5V":[NSNumber numberWithBool:NO]};
                                    
                                    
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"StatusViewNotificationMethod" object:dict];
                                    
                                    
                                }else if (buf1.buff[2] == 0x09){
                
                                    self.S1A3_S1_Target_Mode = buf1.buff[3];
                                    self.S1A3_S1_Target_Veloc = buf1.buff[4] * 256 + buf1.buff[5];
                                    self.S1A3_S1_Target_RealPosition = (UInt32)buf1.buff[6] << 24 | (UInt32)buf1.buff[7] << 16 | (UInt32)buf1.buff[8] << 8 | (UInt32)buf1.buff[9];
                                    
                                    self.S1A3_S1_Target_A_Position = buf1.buff[12] * 256 + buf1.buff[13];
                                    self.S1A3_S1_Target_B_Position = buf1.buff[14] * 256 + buf1.buff[15];
                                    self.S1A3_S1_Target_totaltime = buf1.buff[17] * 256 + buf1.buff[18];
                                
                                    
                                }else if (buf1.buff[2] == 0x0a){
                                    self.S1A3_S1_Target_Task_Mode = buf1.buff[3];
                                    self.S1A3_S1_Target_Task_StartTime =  (UInt32)buf1.buff[4] << 24 | (UInt32)buf1.buff[5] << 16 | (UInt32)buf1.buff[6] << 8 | (UInt32)buf1.buff[7];
                                    self.S1A3_S1_Target_Task_RunTime = buf1.buff[8] * 256 + buf1.buff[9];
                                    self.S1A3_S1_Target_Task_Isloop = buf1.buff[10];
                                    self.S1A3_S1_Target_Task_Direction = buf1.buff[11];
                                    
                                    self.S1A3_S1_Target_Task_RealPosition = (UInt32)buf1.buff[12] << 24 | (UInt32)buf1.buff[13] << 16 | (UInt32)buf1.buff[14] << 8 | (UInt32)buf1.buff[15];
                                    self.S1A3_S1_Target_Task_IsMark_A_B = buf1.buff[16];
                                    self.S1A3_S1_Target_Task_Percent = buf1.buff[17];
                                    self.S1A3_S1_Target_Task_SmoothLevel = buf1.buff[18];
                                    
                                    
                                    
                                }
                                else if (buf1.buff[2] == 0x0b){
                                    
                                 self.S1A3_S1_2_4GAddress_TimeStamp  = (UInt64)buf1.buff[6] << 32| (UInt64)buf1.buff[7] << 24| (UInt64)buf1.buff[8] << 16| (UInt64)buf1.buff[9] << 8 | (UInt64)buf1.buff[10];
                                }
                                else if (buf1.buff[2] == 0x0c){
                                  
                                    
                                }else{
                                    
                                }
                            }
                            }
                            
                        }
                    }
                }
        
        }
        
}
//更新数据
#warning - receiveData 接收数据位置-
-(void)ValueChangText:(NSNotification *)notification
{
    
    if (appDelegate.bleManager.sliderCB.state ==  CBPeripheralStateConnected || appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
        [self Shark_MiniTextNotification:notification];
       
    }
    if (appDelegate.bleManager.S1A3_S1CB.state == CBPeripheralStateConnected || appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
        [self Shark_S1A3TextNotification:notification];
        
        
    }
}

-(UInt64)S1A3_S1_2_4GAddress{
    if (appDelegate.bleManager.S1A3_S1CB.state == CBPeripheralStateConnected) {
        _S1A3_S1_2_4GAddress = 0;
    }
    return _S1A3_S1_2_4GAddress;
}
-(UInt64)S1A3_X2_2_4GAddress
{
    if (appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
        _S1A3_X2_2_4GAddress = 0;
        
    }
    return _S1A3_X2_2_4GAddress;
}
- (UInt8)x2ModeID{
    
    if (X2DisConnected) {
        _x2ModeID = 0;
    }
    return _x2ModeID;
}
- (UInt8)slideModeID{
    if (SLIDEDisConnected) {
        _slideModeID = 0;
    }
    return _slideModeID;
}
- (UInt8)slideversion{
    if (SLIDEDisConnected) {
        _slideversion = 0xff;
    }
    return _slideversion;
}
- (UInt8)X2version{
    if (X2DisConnected) {
        _X2version = 0xff;
    }
    return _X2version;
}
- (UInt8)slideisConnect_24G{
    if (SLIDEDisConnected) {
        _slideisConnect_24G = 0;
    }
    return _slideisConnect_24G;
}
- (UInt8)X2isConnect_24G{
    
    if (X2DisConnected) {
        
        _X2isConnect_24G = 0;
        
    }
    return _X2isConnect_24G;
}
- (UInt8)S1A3_X2_Version{
    if (appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
        return _S1A3_X2_Version;
    }
    return 0;
}
- (UInt8)S1A3_S1_Version{
    if (appDelegate.bleManager.S1A3_S1CB.state == CBPeripheralStateConnected) {
        return _S1A3_S1_Version;
    }
    return 0;
}
-(void)setIsAscii:(BOOL)boo //为假时显示 hex
{
    IsAscii = boo;
    [self clearText];
}
@end
