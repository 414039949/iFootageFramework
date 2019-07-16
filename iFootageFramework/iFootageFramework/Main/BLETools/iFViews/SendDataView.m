//
//  SendDataView.m
//  BLECollection
//
//  Created by rfstar on 14-1-3.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import "SendDataView.h"
#define BYTE0(dwTemp)       ( *( (char *)(&dwTemp)		) )
#define BYTE1(dwTemp)       ( *( (char *)(&dwTemp)   + 1) )
#define BYTE2(dwTemp)       ( *( (char *)(&dwTemp)   + 2) )
#define BYTE3(dwTemp)       ( *( (char *)(&dwTemp)   + 3) )
#define BYTE4(dwTemp)       ( *( (char *)(&dwTemp)   + 4) )
#define BYTE5(dwTemp)       ( *( (char *)(&dwTemp)   + 5) )
#define BYTE6(dwTemp)       ( *( (char *)(&dwTemp)   + 6) )
#define BYTE7(dwTemp)       ( *( (char *)(&dwTemp)   + 7) )



#define SLIDERID @"Ifootage_Slider"


@implementation SendDataView
{
    UIFont *labelfont;
}
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//        [self initView];
//        NSLog(@"PERIPHERALS=====%@", appDelegate.bleManager.peripherals);
        
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
        NSLog(@"%@", appDelegate.bleManager.S1A3_S1CB);
        
        IsAscii = YES;
    }
    return self;
}
-(NSString *)getPrefixTypeString:(NSString *)str{
    
    NSRange range = {1, 4};
    NSString * string = [str substringWithRange:range];
    return string;
    
}
-(void)initView{
    
    labelfont = [UIFont fontWithName:@"Courier" size:15];
    
    _lengthLabel = [[UILabel alloc]initWithFrame:CGRectMake(17,15 , 60, 19)];
    [_lengthLabel setText:NSLocalizedString(@"BleChannel_lenght", @"长度")];
    [_lengthLabel setBackgroundColor:[UIColor clearColor]];
    [_lengthLabel setFont:labelfont];
    _lengthTxt = [[UILabel alloc]initWithFrame:CGRectMake(_lengthLabel.frame.origin.x+_lengthLabel.frame.size.width,_lengthLabel.frame.origin.y, 83, _lengthLabel.frame.size.height)];
    [_lengthTxt setText:@"0"];
    [_lengthTxt setBackgroundColor:[UIColor clearColor]];
    [_lengthTxt setFont:labelfont];
    
     _byteLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lengthTxt.frame.size.width+_lengthTxt.frame.origin.x,_lengthLabel.frame.origin.y, 60, _lengthLabel.frame.size.height)];
    [_byteLabel setBackgroundColor:[UIColor clearColor]];
    [_byteLabel setText:NSLocalizedString(@"BleChannel_sent", @"发送")];
    [_byteLabel setFont:labelfont];
    _sendBytesSizeTxt = [[UILabel alloc]initWithFrame:CGRectMake(_byteLabel.frame.size.width+_byteLabel.frame.origin.x,_lengthLabel.frame.origin.y, 83, _lengthLabel.frame.size.height)];
    [_sendBytesSizeTxt setBackgroundColor:[UIColor clearColor]];
    [_sendBytesSizeTxt setText:@"0"];
    [_sendBytesSizeTxt setFont:labelfont];
    
    _messageTxt = [[UITextView alloc]initWithFrame:CGRectMake(10,_byteLabel.frame.origin.y +_byteLabel.frame.size.height, 300, 90)];
     UIFont *font = [UIFont fontWithName:@"Courier-Bold" size:18];
    [_messageTxt setFont:font];
    [_messageTxt setDelegate:self];
    [_messageTxt setReturnKeyType:UIReturnKeyDone];
    [_messageTxt setText:@"Hello"];
    _messageTxt.layer.cornerRadius = 7;
    _messageTxt.layer.borderWidth = 1;
    _messageTxt.layer.borderColor = [Tools colorWithHexString:@"#7D9EC0"].CGColor;

    [_lengthTxt setText:[NSString stringWithFormat:@"%d",(int)[_messageTxt.text length]]];
//    [self addSubview:_byteLabel];
//    [self addSubview:_lengthLabel];
//    [self addSubview:_lengthTxt];
//    [self addSubview:_sendBytesSizeTxt];
//    [self addSubview:_messageTxt];
//    
    [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width,_messageTxt.frame.origin.y+_messageTxt.frame.size.height)];
    
    
}
-(void)textViewBecomeFirstResponder
{
    [self.messageTxt becomeFirstResponder];
}
#pragma mark- UITextView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    NSString *length = [NSString stringWithFormat:@"%d",(int)textView.text.length];
    [_lengthTxt setText:length];
    [_messageTxt setAccessibilityIdentifier:textView.text];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if(_delegate != nil)
        return  [_delegate sendDataTextViewShouldBeginEditing:textView];
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if(_delegate != nil)
        return  [_delegate sendDataTextViewShouldEndEditing:textView];
    return YES;
}
#pragma mark- button click
-(void)clearText
{
    sendByteSize = 0;
    [_lengthTxt setText:@"0"];
    [_sendBytesSizeTxt setText:@"0"];
    [_messageTxt setText:@""];
}
-(void)resetText
{
    if(IsAscii)
    {
        [_messageTxt setText:@"Hello"];
    }else{
        [_messageTxt setText:[Tools stringToHex:@"Hello"]];
    }
    [self textViewDidChange:_messageTxt];
}
#pragma mark --------pan/tilt----------

-(void)sendData:(NSString *)str andXVeloc:(SInt16)velocX andYVeloc:(SInt16)velocY{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
#pragma mark ============================
    unsigned char send[20];
    send[0] = 0x55;//帧头
    send[1] = 0x5F;//帧头
    
    
    send[2] = 0x01;//功能字
    
    send[3] = BYTE1(velocX);//slider 速度
    send[4] = BYTE0(velocX);//低8位
    
    
    send[5] = BYTE1(velocY);
    send[6] = BYTE0(velocY);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 6) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
        
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }

    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:appDelegate.bleManager.panCB
                                  data:data];
    
    
//    NSLog(@"slider%@", appDelegate.bleManager.sliderCB);
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}

#pragma mark ---------Y方向传值-----------------
- (void)sendYDate:(NSString *)str andYVeloc:(SInt16)velocY{
    NSString  *message =nil;
    message = str;
    
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
        //          NSLog(@" message tmpString  : %@  end",tmpString);
    }
    //    NSLog(@" message   : %@  end",message);
    char lengthChar = 0 ;
    int  p = 0 ;
    //    while (length>0) {   //蓝牙数据通道 可写入的数据为20个字节
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20];
    send[0] = 0x55;//帧头
    send[1] = 0x5F;//帧头
    send[2] = 0x01;//功能字
    send[3] = BYTE1(velocY);//slider 速度
    send[4] = BYTE0(velocY);//低8位
    //        NSLog(@"SINT        =        %d", velocX);
    //        a++;
    //        NSLog(@"%d, %d", a, a);
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 4) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
        
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:appDelegate.bleManager.panCB
                                  data:data];
//    NSLog(@"pan%@", appDelegate.bleManager.panCB);
    
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}
-(void)sendSliderValue:(NSString *)str andSliderValue:(SInt16)velocSlider{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
#pragma mark ============================
    unsigned char send[20];
    send[0] = 0xAA;//帧头
    send[1] = 0xAF;//帧头
    send[2] = 0x01;//功能字
    
    send[3] = BYTE1(velocSlider);//slider 速度
    send[4] = BYTE0(velocSlider);//低8位
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 4) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
        
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:appDelegate.bleManager.sliderCB
                                  data:data];

    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}
- (void)sendX2BackZeroWith:(NSString *)str WithCB:(CBPeripheral *)cb{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
#pragma mark ============================
    unsigned char send[20];
    send[0] = 0x55;//帧头
    send[1] = 0x5F;//帧头
    send[2] = 0x01;//功能字
    send[10] = 0x01;
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 11) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
        
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
    
//        NSLog(@"data %@", data);
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}
- (void)sendSliderBackZeroWith:(NSString *)str WithCB:(CBPeripheral *)cb{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
#pragma mark ============================
    unsigned char send[20];
    send[0] = 0xAA;//帧头
    send[1] = 0xAF;//帧头
    send[2] = 0x01;//功能字
    send[10] = 0x01;
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 11) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
        
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
//        NSLog(@"data = %@", data);
    
    //    NSLog(@"slider%@", appDelegate.bleManager.sliderCB);
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    
}
-(void)setIsAscii:(BOOL)boo //为假时显示 hex
{
    IsAscii = boo;

//    [self clearText];
}

- (void)sendData:(NSString *)str andShootingMode:(UInt8)Mode andBaizerCount:(UInt8)count andFrames:(UInt32)frames andExposureTimes:(UInt16)Exposuretimes andIntervalTimes:(UInt16)Intervaltimes andStartTimes:(UInt64)startTimes{

    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
#pragma mark ============================
    unsigned char send[20];
    send[0] = 0xAA;//帧头
    send[1] = 0xAF;//帧头
    send[2] = 0x02;//功能字
    
    
    send[3] = BYTE0(Mode);//功能选择
    send[4] = BYTE0(count);//三阶贝塞尔曲线的数量
    send[5] = BYTE3(frames);//******
    send[6] = BYTE2(frames);// *    拍摄        *
    send[7] = BYTE1(frames);// *    总张数      *
    send[8] = BYTE0(frames);//******
    send[9] = BYTE1(Exposuretimes);//曝光时间
    send[10] = BYTE0(Exposuretimes);
    send[11] = BYTE1(Intervaltimes);//间隔时间
    send[12] = BYTE0(Intervaltimes);
    
    send[13] = BYTE5(startTimes);//传入的校验时间(ms)
    send[14] = BYTE4(startTimes);
    send[15] = BYTE3(startTimes);
    send[16] = BYTE2(startTimes);
    send[17] = BYTE1(startTimes);
    send[18] = BYTE0(startTimes);//传入的基准时间(ms)
    
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 18) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:appDelegate.bleManager.sliderCB
                                  data:data];
    
    
    //    NSLog(@"slider%@", appDelegate.bleManager.sliderCB);
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}
#pragma mark - AAAF（02） Mode Set 发送曲线数量，判断是否是new曲线 选择功能，拍摄模式，传入校验时间
/**
 * AAAF（02） Mode Set 发送曲线数量，判断是否是new曲线 选择功能，拍摄模式，传入校验时间
 *
 *  @param str          str description
 *  @param functionMode 功能选择
 *  @param mode         拍摄模式
 *  @param count        三阶贝塞尔曲线数量
 *  @param isNewBaizer  是否是新的贝塞尔曲线
 *  @param startTime    校验时间
 */
- (void)sendData:(NSString *)str FunctionSEL:(UInt8)functionMode  andShootingMode:(UInt8)mode andBaizerCount:(UInt8)count andIsNewBaizer:(UInt8)isNewBaizer andStartTimes:(UInt64)startTime WithCBper:(CBPeripheral *)cbPeripheral andSettingIsClear:(UInt8)isclear{
    
    
    
//    NSLog(@"发送消息%@", cbPeripheral);
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = 0xAA;//帧头
    send[1] = 0xAF;//帧头
    send[2] = 0x02;//功能字
    
    send[3] = functionMode;
    send[4] = mode;
//    NSLog(@"mode = %x", mode);
    
    send[5] = count;
    send[6] = isNewBaizer;
    
    send[7] = BYTE7(startTime);
    send[8] = BYTE6(startTime);
    send[9] = BYTE5(startTime);
    send[10] = BYTE4(startTime);
    send[11] = BYTE3(startTime);
    send[12] = BYTE2(startTime);
    send[13] = BYTE1(startTime);
    send[14] = BYTE0(startTime);
    
    send[15] = isclear;
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
//        if (i > 15) {
//            send[i] = 0x00;
//        }
        sum = sum + send[i];
        
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cbPeripheral
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    


}
#pragma mark - AAAF (03) Bezier Parameter 发送总帧数 曝光时间 间隔时间 实际间隔时间
/**
 * AAAF (03) Bezier Parameter 发送总帧数 曝光时间 间隔时间 实际间隔时间
 *
 *  @param str            str description
 *  @param totalframes    totalframes description
 *  @param exposure       exposure description
 *  @param interval       interval description
 *  @param actualInterval actualInterval description
 */
- (void)sendData:(NSString *)str TotalFrames:(UInt32)totalframes Exposure:(UInt16)exposure Interval:(UInt16)interval ActualInterval:(UInt16)actualInterval WithCBper:(CBPeripheral *)cbPeripheral{
//    NSLog(@"发送消息2%@", cbPeripheral);
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    unsigned char send[20];
    send[0] = 0xAA;//帧头
    send[1] = 0xAF;//帧头
    send[2] = 0x03;//功能字
    send[3] = BYTE3(totalframes);
    send[4] = BYTE2(totalframes);
    send[5] = BYTE1(totalframes);
    send[6] = BYTE0(totalframes);
    send[7] = BYTE1(exposure);
    send[8] = BYTE0(exposure);
    send[9] = BYTE1(interval);
    send[10] = BYTE0(interval);
    send[11] = BYTE1(actualInterval);
    send[12] = BYTE0(actualInterval);
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 12) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cbPeripheral
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;


}

#pragma mark - AAAF (05， 06 ， 07, 08, 09, 10)发送贝塞尔曲线的每一个点的细节
/**
 *  (05， 06 ， 07, 08, 09, 10)发送贝塞尔曲线的每一个点的细节
 *
 *  @param str   str description
 *  @param array array description
 */
- (void)sendData:(NSString *)str WithFunctionNumber:(UInt8)functionNumber andUint16PointsNsArray:(NSArray *)Pointarray WithCBper:(CBPeripheral *)cbPeripheral{
//    NSLog(@"发送贝塞尔%@", cbPeripheral);
//    NSLog(@"%x, %@",functionNumber,  Pointarray);

    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20];
    send[0] = 0xAA;//帧头
    send[1] = 0xAF;//帧头
    send[2] = functionNumber;//功能字
    
    
    UInt16 p0 = (UInt16)[Pointarray[0]integerValue];
    
    send[3] = BYTE1(p0);
    send[4] = BYTE0(p0);
    
    UInt16 p1 = (UInt16)[Pointarray[1]integerValue];
    send[5] = BYTE1(p1);
    send[6] = BYTE0(p1);
    
    UInt16 p2 = (UInt16)[Pointarray[2]integerValue];
    send[7] = BYTE1(p2);
    send[8] = BYTE0(p2);
    
    UInt16 p3 = (UInt16)[Pointarray[3]integerValue];
    send[9] = BYTE1(p3);
    send[10] = BYTE0(p3);
    
    UInt16 p4 = (UInt16)[Pointarray[4]integerValue];
    send[11] = BYTE1(p4);
    send[12] = BYTE0(p4);
    
    UInt16 p5 = (UInt16)[Pointarray[5]integerValue];
    send[13] = BYTE1(p5);
    send[14] = BYTE0(p5);
    
    UInt16 p6 = (UInt16)[Pointarray[6]integerValue];
    send[15] = BYTE1(p6);
    send[16] = BYTE0(p6);
    
    UInt16 p7 = (UInt16)[Pointarray[7]integerValue];
    send[17] = BYTE1(p7);
    send[18] = BYTE0(p7);
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 18) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cbPeripheral
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}

- (void)sendDataX2:(NSString *)str WithFunctionNumber:(UInt8)functionNumber andUint16PointsNsArray:(NSArray *)Pointarray WithCBper:(CBPeripheral *)cbPeripheral{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20];
    send[0] = 0x55;//帧头
    send[1] = 0x5F;//帧头
    send[2] = functionNumber;//功能字
    
    
    UInt16 p0 = (UInt16)[Pointarray[0]integerValue];
    
    send[3] = BYTE1(p0);
    send[4] = BYTE0(p0);
    
    UInt16 p1 = (UInt16)[Pointarray[1]integerValue];
    send[5] = BYTE1(p1);
    send[6] = BYTE0(p1);
    
    UInt16 p2 = (UInt16)[Pointarray[2]integerValue];
    send[7] = BYTE1(p2);
    send[8] = BYTE0(p2);
    
    UInt16 p3 = (UInt16)[Pointarray[3]integerValue];
    send[9] = BYTE1(p3);
    send[10] = BYTE0(p3);
    
    UInt16 p4 = (UInt16)[Pointarray[4]integerValue];
    send[11] = BYTE1(p4);
    send[12] = BYTE0(p4);
    
    UInt16 p5 = (UInt16)[Pointarray[5]integerValue];
    send[13] = BYTE1(p5);
    send[14] = BYTE0(p5);
    
    UInt16 p6 = (UInt16)[Pointarray[6]integerValue];
    send[15] = BYTE1(p6);
    send[16] = BYTE0(p6);
    
    UInt16 p7 = (UInt16)[Pointarray[7]integerValue];
    send[17] = BYTE1(p7);
    send[18] = BYTE0(p7);
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 18) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cbPeripheral
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}

- (void)sendDataX2:(NSString *)str TotalFrames:(UInt32)totalframes Exposure:(UInt16)exposure Interval:(UInt16)interval ActualInterval:(UInt16)actualInterval WithCBper:(CBPeripheral *)cbPeripheral{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    unsigned char send[20];
    send[0] = 0x55;//帧头
    send[1] = 0x5F;//帧头
    send[2] = 0x03;//功能字
    send[3] = BYTE3(totalframes);
    send[4] = BYTE2(totalframes);
    send[5] = BYTE1(totalframes);
    send[6] = BYTE0(totalframes);
    send[7] = BYTE1(exposure);
    send[8] = BYTE0(exposure);
    send[9] = BYTE1(interval);
    send[10] = BYTE0(interval);
    send[11] = BYTE1(actualInterval);
    send[12] = BYTE0(actualInterval);
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        if (i > 12) {
            send[i] = 0x00;
        }
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cbPeripheral
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}
- (void)sendDataX2:(NSString *)str WithFunctionNumber:(UInt8)functionMode andShootingMode:(UInt8)mode andBeizerCount:(UInt8)count andIsClearBezier:(UInt8)isClearBezier andStartTimes:(UInt64)startTime WithCBper:(CBPeripheral *)cbPeripheral andSettingIsClear:(UInt8)isclear{
    
//    NSLog(@"发送消息%@", cbPeripheral);
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = 0x55;//帧头
    send[1] = 0x5F;//帧头
    send[2] = 0x02;//功能字
    
    send[3] = functionMode;
    send[4] = mode;
    NSLog(@"mode = %x", mode);
    
    send[5] = count;
    send[6] = isClearBezier;
    
    send[7] = BYTE7(startTime);
    send[8] = BYTE6(startTime);
    send[9] = BYTE5(startTime);
    send[10] = BYTE4(startTime);
    send[11] = BYTE3(startTime);
    send[12] = BYTE2(startTime);
    send[13] = BYTE1(startTime);
    send[14] = BYTE0(startTime);
    
    send[15] = isclear;
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        //        if (i > 15) {
        //            send[i] = 0x00;
        //        }
        sum = sum + send[i];
        
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cbPeripheral
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}

#pragma mark - Slide 和 pan/tilt 兼容发送数据方法
- (void)sendDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andShootingMode:(UInt8)shootingMode andBeizerCount:(UInt8)beizerCount andIsClearBeizer:(UInt8)isClearBezier andcheckTime:(UInt64)checktime andIsSettingClear:(UInt8)isClearSetting str:(NSString *)str{
    
//    NSLog(@"发送代理数据");
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    send[4] = shootingMode;
    send[5] = beizerCount;
    send[6] = isClearBezier;
    
    send[7] = BYTE7(checktime);
    send[8] = BYTE6(checktime);
    send[9] = BYTE5(checktime);
    send[10] = BYTE4(checktime);
    send[11] = BYTE3(checktime);
    send[12] = BYTE2(checktime);
    send[13] = BYTE1(checktime);
    send[14] = BYTE0(checktime);
    
    send[15] = isClearSetting;
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        //        if (i > 15) {
        //            send[i] = 0x00;
        //        }
        sum = sum + send[i];
        
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    
}
- (void)sendDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andTotalFrames:(UInt32)totalframes Exposure:(UInt16)exposure Interval:(UInt16)interval ActualInterval:(UInt16)actualInterval str:(NSString *)str{
    NSLog(@"X2发信息");
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = 0x03;//功能字
    send[3] = BYTE3(totalframes);
    send[4] = BYTE2(totalframes);
    send[5] = BYTE1(totalframes);
    send[6] = BYTE0(totalframes);
    send[7] = BYTE1(exposure);
    send[8] = BYTE0(exposure);
    send[9] = BYTE1(interval);
    send[10] = BYTE0(interval);
    send[11] = BYTE1(actualInterval);
    send[12] = BYTE0(actualInterval);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
      
        sum = sum + send[i];
        
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}
- (void)sendDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andUint16PointNsArray:(NSArray *)Pointarray str:(NSString *)str{
//    NSLog(@"%x, %@", functionNumber, cb);
    
    
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20];
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    
    UInt16 p0 = (UInt16)[Pointarray[0]integerValue];
    
    send[3] = BYTE1(p0);
    send[4] = BYTE0(p0);
    
    UInt16 p1 = (UInt16)[Pointarray[1]integerValue];
    send[5] = BYTE1(p1);
    send[6] = BYTE0(p1);
    
    UInt16 p2 = (UInt16)[Pointarray[2]integerValue];
    send[7] = BYTE1(p2);
    send[8] = BYTE0(p2);
    
    UInt16 p3 = (UInt16)[Pointarray[3]integerValue];
    send[9] = BYTE1(p3);
    send[10] = BYTE0(p3);
    
    UInt16 p4 = (UInt16)[Pointarray[4]integerValue];
    send[11] = BYTE1(p4);
    send[12] = BYTE0(p4);
    
    UInt16 p5 = (UInt16)[Pointarray[5]integerValue];
    send[13] = BYTE1(p5);
    send[14] = BYTE0(p5);
    
    UInt16 p6 = (UInt16)[Pointarray[6]integerValue];
    send[15] = BYTE1(p6);
    send[16] = BYTE0(p6);
    
    UInt16 p7 = (UInt16)[Pointarray[7]integerValue];
    send[17] = BYTE1(p7);
    send[18] = BYTE0(p7);
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
       
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}

- (void)sendRealTimeSlideYWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andMode:(UInt8)mode andSlideY:(UInt16)slideY str:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = mode;
    send[4] = BYTE1(slideY);
    send[5] = BYTE0(slideY);

    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        //        if (i > 15) {
        //            send[i] = 0x00;
        //        }
        sum = sum + send[i];
        
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}


- (void)sendStartCancelPauseDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFiveFunctionMode:(UInt8)mode andTimestamp:(UInt64)timestamp WithStr:(NSString *)str andisLoop:(UInt8)isloop{
    
//    NSLog(@"发送%d", frameHead);
//    timestamp = 1525313823000;
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = mode;
    
    send[4] = BYTE7(timestamp);
    send[5] = BYTE6(timestamp);
    send[6] = BYTE5(timestamp);
    send[7] = BYTE4(timestamp);
    send[8] = BYTE3(timestamp);
    send[9] = BYTE2(timestamp);
    send[10] = BYTE1(timestamp);
    send[11] = BYTE0(timestamp);
    send[18] = isloop;
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        //        if (i > 15) {
        //            send[i] = 0x00;
        //        }
        sum = sum + send[i];
        
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}

- (void)sendTimelapseSetDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andInterval:(UInt16)interval andExposure:(UInt16)exposure andFrames:(UInt32)frames andMode:(UInt8)mode andBezierCount:(UInt8)count WithStr:(NSString *)str andBuffer_second:(UInt16)Buffer_second{
    
    NSLog(@"发送参数");
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = BYTE1(interval);
    send[4] = BYTE0(interval);
    send[5] = BYTE1(exposure);
    send[6] = BYTE0(exposure);
    send[7] = BYTE3(frames);
    send[8] = BYTE2(frames);
    send[9] = BYTE1(frames);
    send[10] = BYTE0(frames);
    send[11] = mode;
    send[12] = count;
    send[13] = BYTE1(Buffer_second);
    send[14] = BYTE0(Buffer_second);
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}
- (void)sendTimelapseSetDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andInterval:(UInt16)interval andExposure:(UInt16)exposure andFrames:(UInt32)frames  andMode:(UInt8)mode andPanBezierCount:(UInt8)pancount andTiltBezierCount:(UInt8)tiltcount WithStr:(NSString *)str andBuffer_second:(UInt16)Buffer_second{
    NSLog(@"发送给x2%d", mode);
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = BYTE1(interval);
    send[4] = BYTE0(interval);
    send[5] = BYTE1(exposure);
    send[6] = BYTE0(exposure);
    send[7] = BYTE3(frames);
    send[8] = BYTE2(frames);
    send[9] = BYTE1(frames);
    send[10] = BYTE0(frames);
    send[11] = mode;
    send[12] = pancount;
    send[13] = tiltcount;
    send[14] = BYTE1(Buffer_second);
    send[15] = BYTE0(Buffer_second);
    
    
    
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;


}
- (void)sendVedioTimeDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andVideoTime:(UInt32)videoTime andBezierCount:(UInt8)count WithStr:(NSString *)str{
    NSLog(@"发送参数");
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = BYTE3(videoTime);
    send[4] = BYTE2(videoTime);
    send[5] = BYTE1(videoTime);
    send[6] = BYTE0(videoTime);
    /***********************/
    send[12] = count;
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}

- (void)sendVedioTimeDataWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andVideoTime:(UInt32)videoTime andPanBezierCount:(UInt8)pancount andTiltBezierCount:(UInt8)tiltcount WithStr:(NSString *)str{
    NSLog(@"发送参数");
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = BYTE3(videoTime);
    send[4] = BYTE2(videoTime);
    send[5] = BYTE1(videoTime);
    send[6] = BYTE0(videoTime);
    /***********************/
    send[12] = pancount;
    send[13] = tiltcount;
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;


}
- (void)sendBezierPreviewWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode sliderPostion:(Float32)postion WithStr:(NSString *)str{
    
//    NSLog(@"1212121212%@", cb);
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = mode;
    send[4] = BYTE3(postion);
    send[5] = BYTE2(postion);
    send[6] = BYTE1(postion);
    send[7] = BYTE0(postion);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    UInt8 sum = 0;
    
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    
    send[19] = sum;
    
//    NSLog(@"sum = %x", sum);
    
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
//    NSLog(@"data = %@", data);
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    
}
- (void)sendBezierPreviewWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFuntionMode:(UInt8)mode panPostion:(Float32)panPostion tiltPostion:(Float32)tiltPostion WithStr:(NSString *)str
{
//    NSLog(@"1212121212%@", cb);
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = mode;
    send[4] = BYTE3(panPostion);
    send[5] = BYTE2(panPostion);
    send[6] = BYTE1(panPostion);
    send[7] = BYTE0(panPostion);
    send[8] = BYTE3(tiltPostion);
    send[9] = BYTE2(tiltPostion);
    send[10] = BYTE1(tiltPostion);
    send[11]  = BYTE0(tiltPostion);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;


}
- (void)sendBezierShiftingWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andPostionArray:(NSArray *)postionarr WithStr:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    
    
    Float32 p0 = (Float32)[postionarr[0] floatValue];
    send[3] = BYTE3(p0);
    send[4] = BYTE2(p0);
    send[5] = BYTE1(p0);
    send[6] = BYTE0(p0);
    Float32 p1 = (Float32)[postionarr[1] floatValue];
    send[7] = BYTE3(p1);
    send[8] = BYTE2(p1);
    send[9] = BYTE1(p1);
    send[10] = BYTE0(p1);
    Float32 p2 = (Float32)[postionarr[2] floatValue];
    send[11] = BYTE3(p2);
    send[12] = BYTE2(p2);
    send[13] = BYTE1(p2);
    send[14] = BYTE0(p2);
    Float32 p3 = (Float32)[postionarr[3] floatValue];
    send[15] = BYTE3(p3);
    send[16] = BYTE2(p3);
    send[17] = BYTE1(p3);
    send[18] = BYTE0(p3);

    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}


- (void)sendBezierTimeWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andTimeArray:(NSArray *)timearr WithStr:(NSString *)str{
    
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    
    Float32 p0 = (Float32)[timearr[0] floatValue];
    send[3] = BYTE3(p0);
    send[4] = BYTE2(p0);
    send[5] = BYTE1(p0);
    send[6] = BYTE0(p0);
    Float32 p1 = (Float32)[timearr[1] floatValue];
    send[7] = BYTE3(p1);
    send[8] = BYTE2(p1);
    send[9] = BYTE1(p1);
    send[10] = BYTE0(p1);
    Float32 p2 = (Float32)[timearr[2] floatValue];
    send[11] = BYTE3(p2);
    send[12] = BYTE2(p2);
    send[13] = BYTE1(p2);
    send[14] = BYTE0(p2);
    Float32 p3 = (Float32)[timearr[3] floatValue];
    send[15] = BYTE3(p3);
    send[16] = BYTE2(p3);
    send[17] = BYTE1(p3);
    send[18] = BYTE0(p3);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
//    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
//    NSLog(@"data%@", data);
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}

- (void)sendStopMotionSetWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode andTimestamp:(UInt64)timestamp CurrentFrame:(UInt32)currentFrame andlongestTime:(UInt16)longestTime WithStr:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = mode;
    send[4] = BYTE7(timestamp);
    send[5] = BYTE6(timestamp);
    send[6] = BYTE5(timestamp);
    send[7] = BYTE4(timestamp);
    send[8] = BYTE3(timestamp);
    send[9] = BYTE2(timestamp);
    send[10] = BYTE1(timestamp);
    send[11] = BYTE0(timestamp);
    send[12] = BYTE3(currentFrame);
    send[13] = BYTE2(currentFrame);
    send[14] = BYTE1(currentFrame);
    send[15] = BYTE0(currentFrame);
    send[16] = BYTE1(longestTime);
    send[17] = BYTE0(longestTime);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
        NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}


- (void)sendPanoramaWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode andAngle:(UInt16)angle andStartAngle:(UInt16)startAngle andEndAngle:(UInt16)endAngle andInterVal:(UInt8)interval  WithStr:(NSString *)str andTiltVeloc:(UInt16)tiltVoloc{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = mode;
    
    send[4] = BYTE1(angle);
    send[5] = BYTE0(angle);
    
    send[6] = BYTE1(startAngle);
    send[7] = BYTE0(startAngle);
    
    send[8] = BYTE1(endAngle);
    send[9] = BYTE0(endAngle);
    
    send[12] = BYTE1(tiltVoloc);
    send[13] = BYTE0(tiltVoloc);
    
    send[18] = interval;
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}
- (void)sendGigaplexlWithCb:(CBPeripheral *)cb andFameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)mode andWidthAngle:(UInt16)widthAngle andHeightAngle:(UInt16)heightAngle andPanSpeed:(UInt16)panSpeed andTiltSpeed:(UInt16)tiltSpeed andInterVal:(UInt8)interval andStr:(NSString *)str{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = mode;
    
    send[4] = BYTE1(widthAngle);
    send[5] = BYTE0(widthAngle);
    
    send[6] = BYTE1(heightAngle);
    send[7] = BYTE0(heightAngle);
    
    send[8] = BYTE1(panSpeed);
    send[9] = BYTE0(panSpeed);
    
    send[10] = BYTE1(tiltSpeed);
    send[11] = BYTE0(tiltSpeed);

    send[18] = interval;
    

    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//    NSLog(@"data = %@", data);
    

}

- (void)sendUpdateTheCb:(CBPeripheral *)cb andFrameHead:(UInt8)frameHead BytesNumber:(UInt16)bytesNumber andDataArray:(NSArray *)dataArray WithStr:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = frameHead;//帧头
    
    send[1] = BYTE1(bytesNumber);
    send[2] = BYTE0(bytesNumber);
    
    UInt8 d1 = (UInt8)[dataArray[0] intValue];
    send[3] = d1;
    UInt8 d2 = (UInt8)[dataArray[1] intValue];
    send[4] = d2;
    UInt8 d3 = (UInt8)[dataArray[2] intValue];
    send[5]  =d3;
    UInt8 d4 = (UInt8)[dataArray[3] intValue];
    send[6] = d4;
    UInt8 d5 = (UInt8)[dataArray[4] intValue];
    send[7] = d5;
    UInt8 d6 = (UInt8)[dataArray[5] intValue];
    send[8] = d6;
    UInt8 d7 = (UInt8)[dataArray[6] intValue];
    send[9]  =d7;
    UInt8 d8 = (UInt8)[dataArray[7] intValue];
    send[10] = d8;
    UInt8 d9 = (UInt8)[dataArray[8] intValue];
    send[11] = d9;
    UInt8 d10 = (UInt8)[dataArray[9] intValue];
    send[12] = d10;
    UInt8 d11 = (UInt8)[dataArray[10] intValue];
    send[13]  =d11;
    UInt8 d12 = (UInt8)[dataArray[11] intValue];
    send[14] = d12;
    UInt8 d13 = (UInt8)[dataArray[12] intValue];
    send[15] = d13;
    UInt8 d14 = (UInt8)[dataArray[13] intValue];
    send[16] = d14;
    UInt8 d15 = (UInt8)[dataArray[14] intValue];
    send[17]  =d15;
    UInt8 d16 = (UInt8)[dataArray[15] intValue];
    send[18] = d16;

    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
//    NSLog(@"%@ = data = %@",cb.name, data);
    
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
}

- (void)sendVersionWith:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andTimeStamp_ms:(UInt64)timeStamp andVersion:(UInt16)version andVersionBytes:(UInt32)versionBytes andSlideSections:(UInt8)slideSection andiSmandatoryUpdate:(UInt8)isUpdate WithStr:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字

    send[3] = BYTE7(timeStamp);
    send[4] = BYTE6(timeStamp);
    send[5] = BYTE5(timeStamp);
    send[6] = BYTE4(timeStamp);
    send[7] = BYTE3(timeStamp);
    send[8] = BYTE2(timeStamp);
    send[9] = BYTE1(timeStamp);
    send[10] = BYTE0(timeStamp);
    send[11] = version;
    send[12] = isUpdate;
    send[13] = BYTE3(versionBytes);
    send[14] = BYTE2(versionBytes);
    send[15] = BYTE1(versionBytes);
    send[16] = BYTE0(versionBytes);
    send[17] = slideSection;
//    send[18] = isUpdate;
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//    NSLog(@"data = %@", data);
    

}

- (void)sendX2FoucsModeTwoPointWith:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andMode:(UInt8)functionMode PanVeloc:(UInt16)panVeloc tiltVeloc:(UInt16)tiltVeloc andisLockTilt:(UInt8)islocktilt andTotalTime:(UInt16)totaltime WithStr:(NSString *)str{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    send[4] = BYTE1(panVeloc);
    send[5] = BYTE0(panVeloc);
    send[6] = BYTE1(tiltVeloc);
    send[7] = BYTE0(tiltVeloc);
    send[8] = islocktilt;
    
    send[10] = BYTE1(totaltime);
    send[11] = BYTE0(totaltime);
  
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//    NSLog(@"data = %@", data);
}
- (void)sendSlideFocusModeTwoPointWith:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andMode:(UInt8)funtionMode SlideVeloc:(UInt16)slideveloc andTotalTime:(UInt16)totaltime withStr:(NSString *)str{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = funtionMode;
    
    send[4] = BYTE1(slideveloc);
    send[5] = BYTE0(slideveloc);
    
    send[10] = BYTE1(totaltime);
    send[11] = BYTE0(totaltime);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//    NSLog(@"data = %@", data);
}

- (void)sendFocusModeWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andDirction:(UInt8)dirction andIsloop:(UInt8)isloop andTimeStamp_ms:(UInt64)timeStamp WithStr:(NSString *)str andAllTime:(UInt16)totaltime{
    
    
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    
    send[4] = dirction;
    send[5] = isloop;
    send[6] = BYTE1(totaltime);
    send[7] = BYTE0(totaltime);
    
    
    send[11] = BYTE7(timeStamp);
    send[12] = BYTE6(timeStamp);
    send[13] = BYTE5(timeStamp);
    send[14] = BYTE4(timeStamp);
    send[15] = BYTE3(timeStamp);
    send[16] = BYTE2(timeStamp);
    send[17] = BYTE1(timeStamp);
    send[18] = BYTE0(timeStamp);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//    NSLog(@"data = %@", data);


}
- (void)sendSetFocusModeWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)frameHead andFuntionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andSlideOrPanVeloc:(UInt16)slideOrPanVeloc andTiltVeloc:(UInt16)tiltVeloc andIsLockTilt:(UInt8)islockTilt andTotalTime:(UInt16)totaltime WithStr:(NSString *)str{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(frameHead);//帧头
    send[1] = BYTE0(frameHead);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    send[4] = BYTE1(slideOrPanVeloc);
    send[5] = BYTE0(slideOrPanVeloc);
    send[6] = BYTE1(tiltVeloc);
    send[7] = BYTE0(tiltVeloc);
    send[8] = islockTilt;
    
    send[10] = BYTE1(totaltime);
    send[11] = BYTE0(totaltime);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//    NSLog(@"data = %@", data);

}

- (void)send24GAddressWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andTimeStamp:(UInt64)timeStamp WithStr:(NSString *)str{
    
//    NSLog(@"24G  = %@", cb);
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    
    send[3] = BYTE7(timeStamp);
    send[4] = BYTE6(timeStamp);
    send[5] = BYTE5(timeStamp);
    send[6] = BYTE4(timeStamp);
    send[7] = BYTE3(timeStamp);
    send[8] = BYTE2(timeStamp);
    send[9] = BYTE1(timeStamp);
    send[10] = BYTE0(timeStamp);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    //    NSLog(@"data = %@", data);
    
}

- (void)send24Gx2AddresssWithCB:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andTimeStamp:(UInt64)timeStamp WithStr:(NSString *)str{
//    NSLog(@" = %@", cb);
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    
    send[3] = BYTE7(timeStamp);
    send[4] = BYTE6(timeStamp);
    send[5] = BYTE5(timeStamp);
    send[6] = BYTE4(timeStamp);
    send[7] = BYTE3(timeStamp);
    send[8] = BYTE2(timeStamp);
    send[9] = BYTE1(timeStamp);
    send[10] = BYTE0(timeStamp);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;

}

- (void)sendReturnX2ZeroWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode WithStr:(NSString *)str{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;


}

- (void)sendTarget_prepare_SliderWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andVeloc:(UInt16)veloc andSlider_A_point:(UInt32)slider_A_point andSlider_B_point:(UInt32)slider_B_point andTotalTime:(UInt16)totaltime WithStr:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    
    send[4] = BYTE1(veloc);
    send[5] = BYTE0(veloc);
    
    send[6] = BYTE3(slider_A_point);
    send[7] = BYTE2(slider_A_point);
    send[8] = BYTE1(slider_A_point);
    send[9] = BYTE0(slider_A_point);
    
    
    send[10] = BYTE3(slider_B_point);
    send[11] = BYTE2(slider_B_point);
    send[12] = BYTE1(slider_B_point);
    send[13] = BYTE0(slider_B_point);


    send[17] = BYTE1(totaltime);
    send[18] = BYTE0(totaltime);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//        NSLog(@"data = %@", data);
}
- (void)sendTarget_play_SliderWithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andDirection:(UInt8)direction andIsloop:(UInt8)isloop andTotaltime:(UInt16)totaltime andsmoothnessLevel:(UInt8)smoothnesslevel andTimeStamp:(UInt64)timestamp WithStr:(NSString *)str{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    
    send[4] = direction;
    send[5] = isloop;
    
    send[6] = BYTE1(totaltime);
    send[7] = BYTE0(totaltime);
    
    send[8] = smoothnesslevel;
    
    
    send[11] = BYTE7(timestamp);
    send[12] = BYTE6(timestamp);
    send[13] = BYTE5(timestamp);
    send[14] = BYTE4(timestamp);
    send[15] = BYTE3(timestamp);
    send[16] = BYTE2(timestamp);
    send[17] = BYTE1(timestamp);
    send[18] = BYTE0(timestamp);

    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//        NSLog(@"data = %@", data);
}
- (void)sendTarget_prepare_X2WithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctionMode:(UInt8)functionMode andpanVeloc:(UInt16)panveloc andtiltVeloc:(UInt16)tiltveloc andPan_A_point:(UInt16)pan_A_point andTilt_A_Point:(UInt16)tilt_A_point andPan_B_point:(UInt16)pan_B_point andTilt_B_Point:(UInt16)tilt_B_point andTotalTime:(UInt16)totaltime WithStr:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    
    send[4] = BYTE1(panveloc);
    send[5] = BYTE0(panveloc);
    send[6] = BYTE1(tiltveloc);
    send[7] = BYTE0(tiltveloc);
    
    
   
    send[8] = BYTE1(pan_A_point);
    send[9] = BYTE0(pan_A_point);
    
    
    send[10] = BYTE1(tilt_A_point);
    send[11] = BYTE0(tilt_A_point);
    
    send[12] = BYTE1(pan_B_point);
    send[13] = BYTE0(pan_B_point);
    
    send[14] = BYTE1(tilt_B_point);
    send[15] = BYTE0(tilt_B_point);
    
    
    
    send[17] = BYTE1(totaltime);
    send[18] = BYTE0(totaltime);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//        NSLog(@"data = %@", data);
}
- (void)sendTarget_play_X2WithCb:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andFunctinMode:(UInt8)functionMode andDirection:(UInt8)direction andIsloop:(UInt8)isloop andTotaltime:(UInt16)totaltime andsmoothnessLevel:(UInt8)smoothnesslevel andTimeStamp:(UInt64)timestamp WithStr:(NSString *)str andSingleorMulti:(UInt8)isSingleorMulti{
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    send[3] = functionMode;
    
    send[4] = direction;
    send[5] = isloop;
    send[6] = BYTE1(totaltime);
    send[7] = BYTE0(totaltime);
    send[8] = smoothnesslevel;
    send[9] = isSingleorMulti;
    
    send[11] = BYTE7(timestamp);
    send[12] = BYTE6(timestamp);
    send[13] = BYTE5(timestamp);
    send[14] = BYTE4(timestamp);
    send[15] = BYTE3(timestamp);
    send[16] = BYTE2(timestamp);
    send[17] = BYTE1(timestamp);
    send[18] = BYTE0(timestamp);
    
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
//        NSLog(@"data = %@", data);
}

#pragma mark ------------S1A3发送数据协议----------
- (void)sendS1A3_S1VelocWith:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFunctionNumber:(UInt8)functionNumber andVeloc:(UInt16)realVeloc With:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    send[3] = BYTE1(realVeloc);
    send[4] = BYTE0(realVeloc);
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    //        NSLog(@"data = %@", data);
    
    
}
- (void)sendS1A3_X2VelocWith:(CBPeripheral *)cb andFrameHead:(UInt16)framed andFuntionNumber:(UInt8)functionNumber andPanVeloc:(UInt16)realPanVeloc andTiltVeloc:(UInt16)realTiltVeloc With:(NSString *)str{
    
    NSString  *message =nil;
    message = str;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = functionNumber;//功能字
    send[3] = BYTE1(realPanVeloc);
    send[4] = BYTE0(realPanVeloc);
    send[5] = BYTE1(realTiltVeloc);
    send[6] = BYTE0(realTiltVeloc);
    
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
    //    NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    //        NSLog(@"data = %@", data);
    
}
- (void)send2_4GWithCB:(CBPeripheral *)cb andFrameHead:(UInt16)framed andTimestamp:(UInt64)timestamp{
    
//    NSLog(@"%@");
    NSString  *message =nil;
    message = SendStr;
    int        length = (int)message.length;
    Byte       messageByte[length];
    for (int index = 0; index < length; index++) {   //生成和字符串长度相同的字节数据
        messageByte[index] = 0x00;
    }
    
    
    NSString   *tmpString;                           //转化为ascii码
    for(int index = 0; index<length ; index++)
    {
        tmpString = [message substringWithRange:NSMakeRange(index, 1)];
        if([tmpString isEqualToString:@" "])
        {
            messageByte[index] = 0x20;
        }else{
            sscanf([tmpString cStringUsingEncoding:NSUTF8StringEncoding],"%s",&messageByte[index]);
        }
    }
    char lengthChar = 0 ;
    int  p = 0 ;
    if (length>20) {
        lengthChar = 20 ;
    }else if (length>0){
        lengthChar = length;
    }else
        return;
    
    unsigned char send[20] = {0};
    
    
    send[0] = BYTE1(framed);//帧头
    send[1] = BYTE0(framed);//帧头
    send[2] = 0x24;//功能字
    send[3] = BYTE7(timestamp);
    send[4] = BYTE6(timestamp);
    send[5] = BYTE5(timestamp);
    send[6] = BYTE4(timestamp);
    send[7] = BYTE3(timestamp);
    send[8] = BYTE2(timestamp);
    send[9] = BYTE1(timestamp);
    send[10] = BYTE0(timestamp);
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    int sum = 0;
    for (int i = 0; i < 19 ; i ++) {
        sum = sum + send[i];
        NSNumber * sendNumber = [NSNumber numberWithChar:send[i]];
        [array addObject:sendNumber];
    }
    send[19] = sum;
    NSNumber * number = [NSNumber numberWithChar:send[19]];
    [array addObject:number];
    
    unsigned char send1[20];
    for (int i = 0; i < 20; i++) {
        send1[i] = [array[i] unsignedCharValue];
    }
    
    NSData *data = [[NSData alloc]initWithBytes:send1 length:lengthChar];
//        NSLog(@"data = %@", data);
    
    
    [appDelegate.bleManager writeValue:0xFFE5
                    characteristicUUID:0xFFE9
                                     p:cb
                                  data:data];
    
    length -= lengthChar ;
    p += lengthChar;
    sendByteSize += lengthChar;
    NSString *cs = [NSString stringWithFormat:@"%ld",sendByteSize];
    _sendBytesSizeTxt.text = cs;
    //        NSLog(@"data = %@", data);
    
    
    
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
@end
