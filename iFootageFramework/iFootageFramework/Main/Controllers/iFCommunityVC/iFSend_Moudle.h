//
//  iFSend_Moudle.h
//  iFootage
//
//  Created by 黄品源 on 2018/7/12.
//  Copyright © 2018 iFootage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface iFSend_Moudle : NSObject

+(iFSend_Moudle *)sharedInstance;

- (void)sendS1_0x00_TimeStamp:(UInt64)timestamp andVersion:(UInt8)version andisUpdate:(UInt8)isupdate andVersionBytes:(UInt32)bytes andSliderCount:(UInt8)sliderCount andisViolence:(UInt8)isviolence;
- (void)sendS1_0x01_Veloc:(SInt16)veloc andIsBackZero:(UInt8)isbackZero;
- (void)sendS1_0x02_Mode:(UInt8)mode andTimestamp:(UInt64)timestamp andisloop:(UInt8)isloop;
- (void)sendS1_0x03_Interval:(UInt16)interval Expo:(UInt16)expo Frames:(UInt32)frames Mode:(UInt8)mode Numbezier:(UInt8)num buffer:(UInt16)buffer;
- (void)sendS1_0X04_Time:(UInt32)time  NumBezier:(UInt8)NumBezier;
- (void)sendS1_0x05_Mode:(UInt8)mode timeStamp:(UInt64)timestamp Frame_Need:(UInt32)frame OnceTime:(UInt16)oncetim;
- (void)sendS1_0x06_Mode:(UInt8)mode sliderPos:(UInt32)sliderPos;
- (void)sendS1_0X09_Mode:(UInt8)mode slideVeloc:(UInt16)slideVeloc SliderPos_A:(UInt32)sliderPos_A SliderPos_B:(UInt32)SliderPos_B TotalTime:(UInt16)totalTime;
- (void)sendS1_0x0A_Mode:(UInt8)mode direction:(UInt8)direction isloop:(UInt8)isloop totaltime:(UInt16)totaltime smoothness:(UInt16)smoothness timestamp:(UInt64)timestamp;
- (void)sendS1_0x0B_TimeStamp:(UInt64)timestamp;
- (void)sendX2_0x01_PanVeloc:(UInt16)panVeloc TiltVeloc:(UInt16)tiltVeloc islockPan:(UInt8)islockPan islockTilt:(UInt8)islockTilt isbackZero:(UInt8)isbackZero;

@end
