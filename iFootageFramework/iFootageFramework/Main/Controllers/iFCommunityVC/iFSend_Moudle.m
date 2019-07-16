//
//  iFSend_Moudle.m
//  iFootage
//
//  Created by 黄品源 on 2018/7/12.
//  Copyright © 2018 iFootage. All rights reserved.
//

#import "iFSend_Moudle.h"
#import "LuaContext.h"
#define intNmu(a) [NSNumber numberWithInt:a]
#define shortNum(a)  [NSNumber numberWithShort:a]
#define longlongNum(a)  [NSNumber numberWithUnsignedLongLong:a]



@implementation iFSend_Moudle

static AppDelegate * app = nil;
+(iFSend_Moudle *)sharedInstance{
    static iFSend_Moudle *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        sharedInstance = [[iFSend_Moudle alloc] init];
        [[LuaContext currentContext] loadScript:@"SharkMini.lua"];
    }
    return sharedInstance;
}

- (void)sendX2_0x01_PanVeloc:(UInt16)panVeloc TiltVeloc:(UInt16)tiltVeloc islockPan:(UInt8)islockPan islockTilt:(UInt8)islockTilt isbackZero:(UInt8)isbackZero{
    [self sendMessageWithLuaMethodName:@"send_0x01_X2" andDataArray:@[intNmu(panVeloc), intNmu(tiltVeloc), shortNum(islockPan), shortNum(islockTilt), intNmu(isbackZero)]];
}
- (void)sendMessageWithLuaMethodName:(NSString *)luaName andDataArray:(NSArray *)array{
    NSData *data = [[LuaContext currentContext] createHex:luaName args:array];
    NSLog(@"data = %@", data);
    [app.bleManager writeValue:0xFFE5 characteristicUUID:0xFFE9 p:app.bleManager.sliderCB data:data];
    
}
- (void)sendS1_0x00_TimeStamp:(UInt64)timestamp andVersion:(UInt8)version andisUpdate:(UInt8)isupdate andVersionBytes:(UInt32)bytes andSliderCount:(UInt8)sliderCount andisViolence:(UInt8)isviolence{
    [self sendMessageWithLuaMethodName:@"send_0x00_S1" andDataArray:@[longlongNum(timestamp), shortNum(version), shortNum(isupdate), intNmu(bytes), shortNum(sliderCount), shortNum(isviolence)]];
}
- (void)sendS1_0x01_Veloc:(SInt16)veloc andIsBackZero:(UInt8)isbackZero{
     [self sendMessageWithLuaMethodName:@"send_0x01_S1" andDataArray:@[intNmu(veloc), shortNum(isbackZero)]];
}
- (void)sendS1_0x02_Mode:(UInt8)mode andTimestamp:(UInt64)timestamp andisloop:(UInt8)isloop{
    
      [self sendMessageWithLuaMethodName:@"send_0x02_S1" andDataArray:@[shortNum(mode), longlongNum(timestamp), shortNum(isloop)]];
}
- (void)sendS1_0x03_Interval:(UInt16)interval Expo:(UInt16)expo Frames:(UInt32)frames Mode:(UInt8)mode Numbezier:(UInt8)num buffer:(UInt16)buffer{
      [self sendMessageWithLuaMethodName:@"send_0x03_S1" andDataArray:@[intNmu(interval), intNmu(expo), intNmu(frames), shortNum(mode), shortNum(num), shortNum(buffer)]];
}
- (void)sendS1_0X04_Time:(UInt32)time  NumBezier:(UInt8)NumBezier{
      [self sendMessageWithLuaMethodName:@"send_0x04_S1" andDataArray:@[intNmu(time), shortNum(NumBezier)]];
}
- (void)sendS1_0x05_Mode:(UInt8)mode timeStamp:(UInt64)timestamp Frame_Need:(UInt32)frame OnceTime:(UInt16)oncetime{
    [self sendMessageWithLuaMethodName:@"send_0x05_S1" andDataArray:@[shortNum(mode), longlongNum(timestamp), intNmu(frame), intNmu(oncetime)]];
}
- (void)sendS1_0x06_Mode:(UInt8)mode sliderPos:(UInt32)sliderPos{
    [self sendMessageWithLuaMethodName:@"send_0x06_S1" andDataArray:@[shortNum(mode), intNmu(sliderPos)]];
}
- (void)sendS1_0X09_Mode:(UInt8)mode slideVeloc:(UInt16)slideVeloc SliderPos_A:(UInt32)sliderPos_A SliderPos_B:(UInt32)SliderPos_B TotalTime:(UInt16)totalTime{
    [self sendMessageWithLuaMethodName:@"send_0x09_S1" andDataArray:@[shortNum(mode), intNmu(slideVeloc), intNmu(sliderPos_A), intNmu(SliderPos_B), intNmu(totalTime)]];
}
- (void)sendS1_0x0A_Mode:(UInt8)mode direction:(UInt8)direction isloop:(UInt8)isloop totaltime:(UInt16)totaltime smoothness:(UInt16)smoothness timestamp:(UInt64)timestamp{
    [self sendMessageWithLuaMethodName:@"send_0x0A_S1" andDataArray:@[shortNum(mode), shortNum(direction), shortNum(isloop), intNmu(totaltime), intNmu(smoothness), longlongNum(timestamp)]];
}
- (void)sendS1_0x0B_TimeStamp:(UInt64)timestamp{
    [self sendMessageWithLuaMethodName:@"send_0x0B_S1" andDataArray:@[longlongNum(timestamp)]];
}
@end
