//
//  TIBLECBStandand.h
//  0 BLE Scanner
//
//  Created by rfstar on 12-9-25.
//  Copyright (c) 2012年 rfstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBService.h>
#import "Tools.h"

#pragma mark ---定义满足两个协议的委托类 模型类---

@protocol showStateDelegate <NSObject>

- (void)showStateDelegate:(NSArray *)array;
- (void)disconnectDelegate:(CBPeripheral *)cb;
- (void)freeconnectDelegate;



@end


//实现中心设备管理委托，外围委托事物
@interface TIBLECBStandand : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate> {
    //无字段，无私有变量
    NSTimer *scanKeepTimer;
    Boolean   isScan;
}
#pragma mark -----模型类的属性声明-----
//属性声明

@property (strong, nonatomic) NSMutableArray *peripherals;     //可变长表格阵列，用来保存扫描到的所有 CBPeripheral 对象指针
@property (strong, nonatomic) CBCentralManager *CM;             //BLE中心管理器对象指针
@property (strong, nonatomic) CBPeripheral *activePeripheral;   //当前已进入连接状态的外围设备对象指针
@property (strong, nonatomic) NSMutableArray *activeCharacteristics;   //当前正在操作的特征值缓存
@property (strong, nonatomic) NSMutableArray *activeDescriptors;   //当前正在操作的特征值缓存
@property (strong, nonatomic) NSString *mode;   //当前正在操作的特征值缓存
@property (strong, nonatomic) CBService *activeService;
@property (weak, nonatomic) id<showStateDelegate>showDelegate;


@property(nonatomic , strong) CBPeripheral * panCB;
@property(nonatomic , strong) CBPeripheral  * sliderCB;
@property(nonatomic , strong) CBPeripheral * tiltCB;
@property(nonatomic , strong) CBPeripheral * S1A3_S1CB;
@property(nonatomic , strong) CBPeripheral * S1A3_X2CB;



#pragma mark -------模型类的方法-------//方法声明

-(void) writeValue:(int)serviceUUID
characteristicUUID:(int)characteristicUUID
                 p:(CBPeripheral *)p
              data:(NSData *)data;

-(void)  readValue: (int)serviceUUID
characteristicUUID:(int)characteristicUUID
                 p:(CBPeripheral *)p;

-(void) notification:(int)serviceUUID
  characteristicUUID:(int)characteristicUUID
                   p:(CBPeripheral *)p
                  on:(BOOL)on;


-(UInt16) swap:(UInt16) s;
-(int) controlSetup:(int) s;
-(int) findBLEPeripherals:(int) timeout;
-(void) stopScan;
-(const char *) centralManagerStateToString:(int)state;
-(void) scanTimer:(NSTimer *)timer;
-(void) printKnownPeripherals;
-(void) printPeripheralInfo:(CBPeripheral*)peripheral;
-(void) connectPeripheral:(CBPeripheral *)peripheral;
-(void) DisplayCharacteristicDescriptorMessage:(CBDescriptor *)d;
-(void) DisplayCharacteristicMessage:(CBCharacteristic *)c;
-(id) GetCharcteristicDiscriptorFromActiveDescriptorsArray:(CBCharacteristic *)characteristic;

-(BOOL) isAActiveCharacteristic:(CBCharacteristic *)c;
-(void) getAllServicesFromKeyfob:(CBPeripheral *)p;
-(void) getAllCharacteristicsFromKeyfob:(CBPeripheral *)p;
-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p;
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service;
-(const char *) UUIDToString:(CFUUIDRef) UUID;
-(const char *) CBUUIDToString:(CBUUID *) UUID;
-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2;
-(int) compareCBUUIDToInt:(CBUUID *) UUID1 UUID2:(UInt16)UUID2;
-(UInt16) CBUUIDToInt:(CBUUID *) UUID;
-(int) UUIDSAreEqual:(CFUUIDRef)u1 u2:(CFUUIDRef)u2;


-(NSString *)getUUIDString;

@end
