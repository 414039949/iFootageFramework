//
//  iFCbperStatusView.m
//  iFootage
//
//  Created by 黄品源 on 2017/6/14.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import "iFCbperStatusView.h"
#import "AppDelegate.h"

@implementation iFCbperStatusView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame WithCBperipheral:(CBPeripheral *)peripheral andBatteryPercent:(CGFloat)percent andCBImgName:(NSString *)CBimgName{
    
    if (self = [super initWithFrame:frame]) {
        
        self.isConnectBlueToothImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 7, 12)];
        self.isConnectBlueToothImg.image = [UIImage imageNamed:@"BLEStatusred"];
        [self addSubview:self.isConnectBlueToothImg];
        
        self.equipmentIconImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 23, 12)];
        self.equipmentIconImg.image = [UIImage imageNamed:CBimgName];
        [self addSubview:self.equipmentIconImg];
        
        self.batterySqaure = [[UIImageView alloc]initWithFrame:CGRectMake(40, 0, 27, 12)];
        self.batterySqaure.image = [UIImage imageNamed:@"batteryBox"];
        self.batterySqaure.alpha = 0;
        
        [self addSubview:self.batterySqaure];
        
        
        self.processLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 1, 0, 9.5)];
        self.processLabel.backgroundColor = [UIColor redColor];
        [self.batterySqaure addSubview:self.processLabel];
        
        self.percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 30, 12)];
        self.percentLabel.backgroundColor = [UIColor clearColor];
        self.percentLabel.textColor = [UIColor whiteColor];
        self.percentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:10];
        self.percentLabel.alpha = 0;
        self.percentLabel.text = @"100%";
        [self addSubview:self.percentLabel];
        
        
        self.isConnect2_4GImg = [[UIImageView alloc]initWithFrame:CGRectMake(-15, 0, 12, 12)];
        self.isConnect2_4GImg.image = [UIImage imageNamed:@"Wi-Fi"];
        self.isConnect2_4GImg.alpha = 0;
        
        [self addSubview:self.isConnect2_4GImg];
        
        self.usbLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 27, 12)];
        self.usbLabel.text = @"USB";
        self.usbLabel.alpha = 0;
        
        self.usbLabel.textColor = [UIColor whiteColor];
        self.usbLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12];
        [self addSubview:self.usbLabel];
        
        self.usbImg = [[UIImageView alloc]initWithFrame:CGRectMake(70, 0, 30, 12)];
        self.usbImg.image = [UIImage imageNamed:@"usb"];
        self.usbImg.alpha = 0;
        
        [self addSubview:self.usbImg];
        
        
    }
    
    
    return self;
}


- (void)changeBatteryPercent:(CGFloat)percent andisConnected:(BOOL)isConnected andisConnected5V:(BOOL)isconnected5V andisConnected2_4G:(BOOL)isConnected2_4G{
    
    
    
    if (!isConnected) {
        
        self.processLabel.frame = CGRectMake(2, 1, 0, 9.5);
        self.processLabel.backgroundColor = [UIColor clearColor];
        self.percentLabel.text = @"0%";
        self.isConnectBlueToothImg.image = [UIImage imageNamed:@"BLEStatusred"];
        self.batterySqaure.alpha = 0;
        self.usbLabel.alpha = 0;
        self.usbImg.alpha = 0;
        self.isConnect2_4GImg.alpha = 0;
//
//        if (isConnected2_4G) {
//            self.isConnect2_4GImg.alpha = 1;
//        }else{
//            self.isConnect2_4GImg.alpha = 0;
//        }
    }else{
        self.isConnectBlueToothImg.image = [UIImage imageNamed:@"BLEStatusgreen"];

        if (isConnected2_4G) {
            self.isConnect2_4GImg.alpha = 1;
        }else{
            self.isConnect2_4GImg.alpha = 0;
        }
        if (isconnected5V) {
            self.batterySqaure.alpha = 0;
            self.percentLabel.alpha = 0;
            
            self.usbLabel.alpha = 1;
            self.usbImg.alpha = 1;
            
        }else{
            self.batterySqaure.alpha = 1;
            self.percentLabel.alpha = 1;
            
            self.usbLabel.alpha = 0;
            self.usbImg.alpha = 0;
            
            
    self.processLabel.frame = CGRectMake(2, 1, percent / 100.0f * 22.5, 9.5);
    if (percent < 20.0f) {
        self.processLabel.backgroundColor = [UIColor redColor];
    }else{
        self.processLabel.backgroundColor = [UIColor greenColor];
    }
        
        self.percentLabel.text = [NSString stringWithFormat:@"%.0lf%%", percent];
        }
    }

}

@end
