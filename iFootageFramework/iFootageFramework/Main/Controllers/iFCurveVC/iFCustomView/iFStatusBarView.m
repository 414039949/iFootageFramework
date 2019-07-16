//
//  iFStatusBarView.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/14.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFStatusBarView.h"
#import "iFCbperStatusView.h"
#import "ReceiveView.h"
#import "AppDelegate.h"

#import "SendDataView.h"

@implementation iFStatusBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
{
    AppDelegate * appDelegate;
    SendDataView * sendView;
    UInt64 recordTime;
    
    BOOL Mini_S1_isConnected, Mini_X2_isConnected, S1A3_S1_isConnected , S1A3_X2_isConnected;

}
@synthesize cbs1perView, cbx2perView;


static iFStatusBarView *sharedView;
+ (iFStatusBarView *)sharedView {
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];});
    sharedView.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication].keyWindow addSubview:sharedView];
    
    [sharedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo( [UIApplication sharedApplication].keyWindow.mas_top).offset([UIApplication sharedApplication].statusBarFrame.size.height);
        make.right.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.size.mas_equalTo(CGSizeMake(300, 20));
        
    }];
    
    return sharedView;
}


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        sendView = [[SendDataView alloc]init];
        recordTime = [[NSDate date]timeIntervalSince1970] * 1000;
        cbs1perView = [[iFCbperStatusView alloc]initWithFrame:CGRectMake(frame.size.width - 245, 0, 80, 20) WithCBperipheral:nil andBatteryPercent:100 andCBImgName:@"Statusslidermini"];
        
        cbx2perView = [[iFCbperStatusView alloc]initWithFrame:CGRectMake(frame.size.width - 125, 0, 80, 20) WithCBperipheral:nil andBatteryPercent:100 andCBImgName:@"Statusx2mini"];
        
        [self addSubview:cbx2perView];
        [self addSubview:cbs1perView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StatusViewNotificationMethod:) name:@"StatusViewNotificationMethod" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(send2_4GPairingAddressNotificationMethod) name:@"send2_4GPairingAddressNotificationMethod" object:nil];
        

        
    }
    return self;
}

- (void)send2_4GPairingAddressNotificationMethod{
    NSLog(@"send2_4GPairingAddressNotificationMethod");
    
//    NSLog(@"X2version%hhu",[ReceiveView sharedInstance].X2version);
//    NSLog(@"slideversion%hhu",[ReceiveView sharedInstance].slideversion);
    if (([ReceiveView sharedInstance].X2version < 16 && [ReceiveView sharedInstance].X2version != 0) || ([ReceiveView sharedInstance].slideversion < 16 && [ReceiveView sharedInstance].slideversion != 0)){
        NSLog(@"版本低");
    }else{
        
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(send2_4Gtimer:) userInfo:nil repeats:YES];
    timer.fireDate = [NSDate distantPast];
        
    }

}

- (void)send2_4Gtimer:(NSTimer *)timer{
    NSLog(@"send2_4Gtimer");
    
    if (([ReceiveView sharedInstance].X2version < 16 && [ReceiveView sharedInstance].X2version != 0) ||([ReceiveView sharedInstance].slideversion < 16 && [ReceiveView sharedInstance].slideversion != 0) ) {
        timer.fireDate = [NSDate distantFuture];
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:S1A3orMiniID] isEqualToString:@"S1A3"] == YES) {
    if (appDelegate.bleManager.S1A3_S1CB.state == CBPeripheralStateConnected && appDelegate.bleManager.S1A3_X2CB.state == CBPeripheralStateConnected) {
        
        if ([ReceiveView sharedInstance].S1A3_S1_isConnect_24G == 5 && [ReceiveView sharedInstance].S1A3_X2_isConnect_24G == 5) {
            

            timer.fireDate = [NSDate distantFuture];
        }else{
            
            [sendView send2_4GWithCB:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andTimestamp:recordTime];
            [sendView send2_4GWithCB:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andTimestamp:recordTime];
        }
    }else{
        
        timer.fireDate = [NSDate distantFuture];
    }
    }else{
        
        if (appDelegate.bleManager.sliderCB.state == CBPeripheralStateConnected && appDelegate.bleManager.panCB.state == CBPeripheralStateConnected) {
            if ([ReceiveView sharedInstance].slideisConnect_24G == 5 && [ReceiveView sharedInstance].X2isConnect_24G == 5) {
                
                timer.fireDate = [NSDate distantFuture];
            }else{
                [sendView send2_4GWithCB:appDelegate.bleManager.sliderCB andFrameHead:OXAAAF andTimestamp:recordTime];
                [sendView send2_4GWithCB:appDelegate.bleManager.panCB andFrameHead:OX555F andTimestamp:recordTime];
            }
        }else{
            
            timer.fireDate = [NSDate distantFuture];
        }
        
    }
}

- (void)StatusViewNotificationMethod:(NSNotification *)nofi{
    
//    NSLog(@"isConnect_24G%llu %llu", [ReceiveView sharedInstance].slideisConnect_24G, [ReceiveView sharedInstance].X2isConnect_24G);
//    NSLog(@"S1A3_S1_isConnected %d  S1A3_X2_isConnected %d", S1A3_S1_isConnected, S1A3_X2_isConnected);
//    NSLog(@"+++++++++++++++++++++++++++++");
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:S1A3orMiniID] isEqualToString:@"S1A3"] == YES) {

//    NSLog(@"appDelegate.bleManager.panCB%@", appDelegate.bleManager.panCB.services);
    
        if ([ReceiveView sharedInstance].S1A3_S1_isConnect_24G >= 0x04) {
            S1A3_S1_isConnected = YES;
            
            
        }else{
            
            S1A3_S1_isConnected = NO;
            
            
            
        }
        if ([ReceiveView sharedInstance].S1A3_X2_isConnect_24G >= 0x04) {
            S1A3_X2_isConnected = YES;
            
        }else{
            S1A3_X2_isConnected = NO;
            
        }
//    }else{
    
    
    if ([ReceiveView sharedInstance].slideisConnect_24G >= 0x04) {
        Mini_S1_isConnected = YES;
        
    }else{
        Mini_S1_isConnected = NO;
        
    }
    if ([ReceiveView sharedInstance].X2isConnect_24G >= 0x04) {
        Mini_X2_isConnected = YES;

    }else{
        Mini_X2_isConnected = NO;
    }
//    }
//    NSLog(@"S1A3_S1_isConnected %d  S1A3_X2_isConnected %d", S1A3_S1_isConnected, S1A3_X2_isConnected);
//    NSLog(@"[ReceiveView sharedInstance].S1A3_X2_isConnect_24G%d",[ReceiveView sharedInstance].S1A3_X2_isConnect_24G );
//    NSLog(@"[ReceiveView sharedInstance].S1A3_S1_isConnect_24G%d", [ReceiveView sharedInstance].S1A3_S1_isConnect_24G);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:S1A3orMiniID] isEqualToString:@"S1A3"] == YES) {
        [cbs1perView changeBatteryPercent:[ReceiveView sharedInstance].S1A3_S1_BatteryNum andisConnected:appDelegate.bleManager.S1A3_S1CB.state andisConnected5V:NO andisConnected2_4G:S1A3_S1_isConnected];
        
        [cbx2perView changeBatteryPercent:[ReceiveView sharedInstance].S1A3_X2_BatteryNum andisConnected:appDelegate.bleManager.S1A3_X2CB.state andisConnected5V:NO andisConnected2_4G:S1A3_X2_isConnected];
        
    }else{
        
        [cbs1perView changeBatteryPercent:[ReceiveView sharedInstance].slideBattery andisConnected:appDelegate.bleManager.sliderCB.state andisConnected5V:[ReceiveView sharedInstance].slideisConnect5V andisConnected2_4G:Mini_S1_isConnected];
        [cbx2perView changeBatteryPercent:[ReceiveView sharedInstance].X2battery andisConnected:appDelegate.bleManager.panCB.state andisConnected5V:[ReceiveView sharedInstance].X2isConnect5V andisConnected2_4G:Mini_X2_isConnected];
    }
    
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:@"StatusViewNotificationMethod" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"send2_4GPairingAddressNotificationMethod" object:nil];
    
}

@end
