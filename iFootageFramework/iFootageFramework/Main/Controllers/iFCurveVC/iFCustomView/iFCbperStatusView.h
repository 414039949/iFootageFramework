//
//  iFCbperStatusView.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/14.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface iFCbperStatusView : UIView



@property (nonatomic, strong)UIImageView * isConnectBlueToothImg;
@property (nonatomic, strong)UIImageView * equipmentIconImg;
@property (nonatomic, strong)UIImageView * batterySqaure;
@property (nonatomic, strong)UIImageView * usbImg;
@property (nonatomic, strong)UIImageView * isConnect2_4GImg;


@property (nonatomic, strong)UILabel * usbLabel;
@property (nonatomic, strong)UILabel * percentLabel;
@property (nonatomic, strong)UILabel * processLabel;



- (id)initWithFrame:(CGRect)frame WithCBperipheral:(CBPeripheral *)peripheral andBatteryPercent:(CGFloat)percent andCBImgName:(NSString *)CBimgName;

- (void)changeBatteryPercent:(CGFloat)percent andisConnected:(BOOL)isConnected andisConnected5V:(BOOL)isconnected5V andisConnected2_4G:(BOOL)isConnected2_4G;


@end
