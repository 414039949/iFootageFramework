//
//  iFS1A3_ManualViewController.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iFootageRocker.h"
#import "SendDataView.h"
#import "ReceiveView.h"
#import "AppDelegate.h"




@interface iFS1A3_ManualViewController : iFRootViewController

@property (strong, nonatomic)  iFootageRocker *LeftanalogueStick;
@property (strong, nonatomic)  iFootageRocker *RightanalogueStick;
@property (strong, nonatomic)  SendDataView     * sendView;
@property (strong, nonatomic)  AppDelegate      * appDelegate;
@property(nonatomic , strong)  ReceiveView      * receiveView;
@end
