//
//  iFScanViewController.h
//  iFootage
//
//  Created by 黄品源 on 16/6/11.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "ListView.h"
#import "iFLabel.h"
#import "SendDataView.h"
#import "ReceiveView.h"



@interface iFScanViewController : iFRootViewController<ListViewDelegate, showStateDelegate>


{
  enum MODEl_STATE MODEL;
  AppDelegate * appDelegate;
}
//@property (strong, nonatomic) NSTimer * timer;


@property (strong, nonatomic)UIImageView * S1A1unitImgView;
@property (strong, nonatomic)UIImageView * X2unitImgView;
@property (strong, nonatomic)iFLabel * S1A1unitLabel;
@property (strong, nonatomic)iFLabel * X2unitLabel;
@property (strong, nonatomic)UILabel * S1A1StateLabel;
@property (strong, nonatomic)UILabel * X2StateLabel;
@property (strong, nonatomic)UISwitch * S1A1unitSwitch;
@property (strong, nonatomic)UISwitch * X2unitSwitch;

@property (strong, nonatomic)  SendDataView     * sendView;
@property(nonatomic , strong)  ReceiveView      * receiveView;

@property(strong, nonatomic)ListView * listView;


@end
