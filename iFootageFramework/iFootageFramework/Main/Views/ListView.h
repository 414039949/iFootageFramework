//
//  ListView.h
//  BLECollection
//
//  Created by rfstar on 14-1-7.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "iFPeripheralCell.h"
#import "AppDelegate.h"
#import "TIBLECBStandand.h"


enum MODEl_STATE
{
    MODEL_NORMAL = 0,
    MODEL_CONNECTING = 1,
    MODEL_SCAN = 2,
    MODEL_CONECTED = 3,
};
@protocol ListViewDelegate <NSObject>

-(void)listViewRefreshStateStart;
-(void)listViewRefreshStateEnd;
-(void)freeConnectDelegate;
-(void)listViewConnectSucessful:(CBPeripheral *)peripheral;
- (void)disconnectDelegate:(CBPeripheral *)cb;

-(void)modifiyNewNameWithCb:(CBPeripheral *)cb andTableView:(UITableView *)tableview andIndexPath:(NSIndexPath *)indexPath;

@end
@interface ListView : UIView  <UITableViewDataSource,UITableViewDelegate, showStateDelegate>


{
    AppDelegate     *appDelegate;
    enum MODEl_STATE MODEL;
}
@property (nonatomic ,strong) UITableView           *listView;
@property (nonatomic , weak) id<ListViewDelegate> listDelegate;
@property (nonatomic, copy) NSString * passwordStr;


-(void) startScan;
-(void) stopScan;
- (void)ReSetPeripheral;
- (void)reciveInitNotification;

- (void)ScanPeripheral;

@end
