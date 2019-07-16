//
//  iFS1A3_TargetViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_TargetViewController.h"
#import "AppDelegate.h"
#import "iFFocusSlideView.h"
#import "DXPopover.h"
#import "iFTimePickerView.h"
#import "iFModel.h"
#import "iFGetDataTool.h"
#import "SVProgressHUD.h"
#import "iFAdjustVelocView.h"
#import "iFUpdateBtn.h"
#import "iF3DButton.h"
#import "iFAlertController.h"
#import "iFSmoothnessView.h"
#import "iFTargetModel.h"
#import "iFgetAxisY.h"
#import "ReceiveView.h"
#import "SendDataView.h"
#import "iFS1A3_Model.h"
#import "iFS1A3_TartgetModel.h"
#import "iFTimePickerView.h"
#import "iFTarget_PointValueView.h"
#define leftRocker_Tag 10000
#define rightRocker_Tag 10001
#define LimitSecond 0.1f


@interface iFS1A3_TargetViewController ()<JSAnalogueStickDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TimeLapseTimePickDelegate, sendSelectedDelegete>


/**
 *  发送视图
 */
@property (nonatomic, strong)SendDataView * sendDataView;
/**
 *  接收视图
 */
@property (nonatomic, strong)ReceiveView * receiveView;

@property (nonatomic, strong) DXPopover *popover;//弹出视图 download的第三方



@end

@implementation iFS1A3_TargetViewController
{
    UIView * leftBackgroundView;
    UIView * rightBackgroundView;
    UIView * leftSecondView;
    UIView * rightSecondView;
    iFFocusSlideView * slideView;
    iFSmoothnessView * smoothView;
    iFTarget_PointValueView * B_pointValueView;
    iFTarget_PointValueView * A_pointValueView;
    iFS1A3_TartgetModel * S1A3_TargetModel;
    
    CGFloat slideDistance, panDistance;

    NSInteger     Encode;
    
    UInt16 alltime;
    UInt8 islockPan;
    UInt8 islockTilt;
    UInt8 isloop;
    UInt8 direction;
    UInt64 starttime;
    
    NSInteger S1A3_record_A_panAngle;
    NSInteger S1A3_record_B_panAngle;
    NSInteger S1A3_record_A_TiltAngle;
    NSInteger S1A3_record_B_TiltAngle;
    NSInteger S1A3_record_A_SliderPosition;
    NSInteger S1A3_record_B_SliderPosition;
    
    NSTimer * S1A3_receiveTimer;
    NSTimer * S1A3_returnZeroTimer;
    NSTimer * S1A3_runTimer;
    NSTimer * S1A3_StopTimer;
    NSTimer * S1A3_LeftPointTimer;
    NSTimer * S1A3_RightPointTimer;
    NSTimer * S1A3_timeCorrectTimer;// 校准开始时间定时器
    NSTimer * S1A3_setAandBpointTimer;
    NSTimer * S1A3_freeReturnZeroTimer;
    AppDelegate * appDelegate;
    iFS1A3_Model * S1A3Model;
    UITableView * fileTableView;
    UIView * fileview;
    NSMutableArray * fileDataArray;

    BOOL isRunning;
    BOOL     issingleormulti;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _receiveView = [ReceiveView sharedInstance];
    _sendDataView = [[SendDataView alloc]init];
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    S1A3Model = [[iFS1A3_Model alloc]init];
    islockTilt = 0x01;
    islockPan = 0x01;
    
    S1A3_TargetModel = [[iFS1A3_TartgetModel alloc]init];
    fileDataArray = [NSMutableArray new];
    
    self.connectBtn.alpha = 0;
    alltime = S1A3Model.S1A3_Target_totaltime;
    self.titleLabel.text = @"Target";
    isRunning = NO;
    
    

}
- (void)closeFileAction:(iFButton *)btn{
    [UIView animateWithDuration:0.3 animations:^{
        fileview.frame = CGRectMake(0, -AutoKscreenWidth, AutoKScreenHeight * 0.4, AutoKscreenWidth);
    }];
    [fileTableView reloadData];
    
}
- (NSString *)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
- (void)saveWithName:(NSString *)nameStr{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_TargetModelList];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    fileDataArray = [NSMutableArray arrayWithArray:array];
    
    
    S1A3_TargetModel.S1A3_fileName = nameStr;
    S1A3_TargetModel.S1A3_slide_A_pointValue = S1A3_record_A_SliderPosition;
    S1A3_TargetModel.S1A3_slide_B_pointValue = S1A3_record_B_SliderPosition;
    S1A3_TargetModel.S1A3_X2_A_panValue = S1A3_record_A_panAngle;
    S1A3_TargetModel.S1A3_X2_B_panValue = S1A3_record_B_panAngle;
    S1A3_TargetModel.S1A3_X2_A_tiltValue = S1A3_record_A_TiltAngle;
    S1A3_TargetModel.S1A3_X2_B_tiltValue = S1A3_record_B_TiltAngle;
    S1A3_TargetModel.S1A3_smoothnessLevel = [smoothView getSmoothnesslevel];
    S1A3_TargetModel.S1A3_SaveDataTime = [self getCurrentTimes];
    
    NSDictionary * dict = [S1A3_TargetModel dictionaryWithValuesForKeys:[S1A3_TargetModel allPropertyNames]];
    [fileDataArray addObject:dict];
    
    [fm createFileAtPath:plistPath contents:nil attributes:nil];
    NSArray * array1 = [NSArray arrayWithArray:fileDataArray];
    [array1 writeToFile:plistPath atomically:YES];
    [fileTableView reloadData];
    
    NSLog(@"plistPath%@", plistPath);
    
}
- (void)saveAction:(iFButton *)btn{
    
    NSString *title = NSLocalizedString(Timeline_SavedAndNamed, nil);
    
    NSString *message = NSLocalizedString(Timeline_EnterPlaceSlogan, nil);
    
    NSString *cancelButtonTitle = NSLocalizedString(Timeline_Cancel, nil);
    
    NSString *okButtonTitle = NSLocalizedString(Timeline_OK, nil);
    
    
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 创建文本框
    [alertDialog addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = NSLocalizedString(Timeline_EnterNameSlogan, nil);
        textField.secureTextEntry = NO;
        textField.returnKeyType = UIReturnKeyDone;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.delegate = self;
        textField.tag = 100;
        
    }];
    
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //         读取文本框的值显示出来
        UITextField *newName = alertDialog.textFields.lastObject;
        [self saveWithName:newName.text];
        
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:cancel];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [alertDialog.view setNeedsLayout];
    [alertDialog.view layoutIfNeeded];
    [self presentViewController:alertDialog animated:YES completion:^{
        
    }];
}

- (void)fileAction:(iFButton *)btn{
    
    [UIView animateWithDuration:0.3 animations:^{
        fileview.frame = CGRectMake(0, 0, AutoKScreenHeight * 0.4, AutoKscreenWidth);
    }];
    [fileTableView reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fileDataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_TargetModelList];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    fileDataArray = [NSMutableArray arrayWithArray:array];
    [UIView animateWithDuration:0.3 animations:^{
        fileview.frame = CGRectMake(0, -AutoKscreenWidth, AutoKScreenHeight * 0.4, AutoKscreenWidth);
        
    }];
    //    NSDictionary * dict = fileDataArray[0];
//    S1A3_TargetModel.
    S1A3_record_A_SliderPosition = [fileDataArray[indexPath.row][@"S1A3_slide_A_pointValue"] integerValue];
    S1A3_record_B_SliderPosition = [fileDataArray[indexPath.row][@"S1A3_slide_B_pointValue"] integerValue];
    S1A3_record_A_panAngle = [fileDataArray[indexPath.row][@"S1A3_X2_A_panValue"] integerValue];
    S1A3_record_A_TiltAngle = [fileDataArray[indexPath.row][@"S1A3_X2_A_tiltValue"] integerValue];
    S1A3_record_B_panAngle = [fileDataArray[indexPath.row][@"S1A3_X2_B_panValue"] integerValue];
    S1A3_record_B_TiltAngle = [fileDataArray[indexPath.row][@"S1A3_X2_B_tiltValue"] integerValue];
    [smoothView initSmoothLevelWith: [fileDataArray[indexPath.row][@"S1A3_smoothnessLevel"] integerValue]];
    
    NSLog(@"%ld", (long)S1A3_record_A_SliderPosition);
    NSLog(@"%ld", S1A3_record_B_SliderPosition);
    NSLog(@"%ld", S1A3_record_A_panAngle);
    NSLog(@"%ld", S1A3_record_A_TiltAngle);
    NSLog(@"%ld", S1A3_record_B_panAngle);
    NSLog(@"%ld", S1A3_record_B_TiltAngle);
    
    self.setStartBtn.actionBtn.selected = YES;
    self.setEndBtn.actionBtn.selected = YES;
    S1A3_setAandBpointTimer.fireDate = [NSDate distantPast];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.text = fileDataArray[indexPath.row][@"S1A3_fileName"];
        cell.textLabel.backgroundColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return cell;
    
}
- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
    //      cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
    //    cell.textLabel.backgroundColor = [UIColor redColor];
    //    cell.detailTextLabel.backgroundColor = [UIColor blueColor];
}
#pragma mark -----删除操作---------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_TargetModelList];
    
    //    [[fileDataArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    //    [fileDataArray objectAtIndex:indexPath.row];
    [fileDataArray removeObjectAtIndex:indexPath.row];
    
    /*删除tableView中的一行*/
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [fileDataArray writeToFile:plistPath atomically:YES];
    
    NSLog(@"%@", plistPath);
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return NSLocalizedString(KeyFrame_delete, nil);
}
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willBeginEditingRowAtIndexPath 删除2");
    
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndEditingRowAtIndexPath 删除3");
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


- (void)creatAllTimer{
    
    S1A3_receiveTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(S1A3_receiveRealData) userInfo:nil repeats:YES];
    S1A3_receiveTimer.fireDate = [NSDate distantPast];
    
    
    S1A3_returnZeroTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(returnZeroActionTimer:) userInfo:nil repeats:YES];
    S1A3_returnZeroTimer.fireDate = [NSDate distantFuture];
    
    S1A3_runTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(runActionTimer:) userInfo:nil repeats:YES];
    S1A3_runTimer.fireDate = [NSDate distantFuture];
    
    S1A3_StopTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(StopActionTimer:) userInfo:nil repeats:YES];
    S1A3_StopTimer.fireDate = [NSDate distantFuture];
    
    S1A3_LeftPointTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(ApointActionTimer:) userInfo:nil repeats:YES];
    S1A3_LeftPointTimer.fireDate = [NSDate distantFuture];
    
    S1A3_RightPointTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(BpointActionTimer:) userInfo:nil repeats:YES];
    S1A3_RightPointTimer.fireDate = [NSDate distantFuture];
    
    S1A3_timeCorrectTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(timeCurrentTimer:) userInfo:nil repeats:YES];
    S1A3_timeCorrectTimer.fireDate = [NSDate distantFuture];
    
    S1A3_setAandBpointTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(AandB_PointActionTimer:) userInfo:nil repeats:YES];
    S1A3_setAandBpointTimer.fireDate = [NSDate distantFuture];
    
    S1A3_freeReturnZeroTimer = [NSTimer scheduledTimerWithTimeInterval:LimitSecond target:self selector:@selector(freeReturnZeroTimer:) userInfo:nil repeats:YES];
    S1A3_freeReturnZeroTimer.fireDate = [NSDate distantFuture];
}
- (void)closeAllTimer{

    [self closeOneTimer:S1A3_returnZeroTimer];
    [self closeOneTimer:S1A3_runTimer];
    [self closeOneTimer:S1A3_StopTimer];
    [self closeOneTimer:S1A3_LeftPointTimer];
    [self closeOneTimer:S1A3_RightPointTimer];
    [self closeOneTimer:S1A3_timeCorrectTimer];
    [self closeOneTimer:S1A3_setAandBpointTimer];
    [self closeOneTimer:S1A3_freeReturnZeroTimer];
    [self closeOneTimer:S1A3_receiveTimer];

}
- (void)stopAlltimer{
    [self stopOneTimer:S1A3_returnZeroTimer];
    [self stopOneTimer:S1A3_runTimer];
    [self stopOneTimer:S1A3_LeftPointTimer];
    [self stopOneTimer:S1A3_RightPointTimer];
    [self stopOneTimer:S1A3_timeCorrectTimer];
    [self stopOneTimer:S1A3_setAandBpointTimer];
    [self stopOneTimer:S1A3_freeReturnZeroTimer];
}
- (void)stopOneTimer:(NSTimer *)timer{
    timer.fireDate = [NSDate distantFuture];
    
    
}
- (void)closeOneTimer:(NSTimer *)timer{
    timer.fireDate = [NSDate distantFuture];
    [timer invalidate];
    timer = nil;
}
static int a = 0;
- (void)returnZeroActionTimer:(NSTimer *)timer{
    NSLog(@"returnZeroActionTimer %d %d",_receiveView.S1A3_S1_Target_Task_Mode, _receiveView.S1A3_X2_Target_Task_Mode);
    a++;
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    [_sendDataView sendTarget_play_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x0a andFunctionMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr];
    [_sendDataView sendTarget_play_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x0a andFunctinMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr andSingleorMulti:issingleormulti];
    
    
    if (a > 10) {
        
        if (_receiveView.S1A3_S1_Target_Task_Mode == 0x01 && _receiveView.S1A3_X2_Target_Task_Mode == 0x01) {
            
            
            NSLog(@"归零了");
            a = 0;
            self.stopBtn.alpha = 0;
            self.playBtn.alpha = 1;
            self.leftPlayBtn.actionBtn.userInteractionEnabled = YES;
            self.rightPlayBtn.actionBtn.userInteractionEnabled = YES;
            [_RightanalogueStick reStartRocker];
            [_LeftanalogueStick reStartRocker];
            
            [SVProgressHUD dismiss];
            
            //        if (record_A_SliderPosition == _receiveView.FMslideRealPosition) {
            timer.fireDate = [NSDate distantFuture];
            //        }
            //        [SVProgressHUD showWithStatus:@"归零了开始run"];
            
        }else{
            
            _receiveView.S1A3_S1_Target_Task_Mode = 0x00;
            _receiveView.S1A3_X2_Target_Task_Mode = 0x00;
            self.stopBtn.alpha = 1;
            self.playBtn.alpha = 0;
        }
    }
}
- (void)runActionTimer:(NSTimer *)timer{
    NSLog(@"runActionTimer");
    
    if (_receiveView.S1A3_S1_Target_Task_Mode== 0x02 && _receiveView.S1A3_X2_Target_Task_Mode == 0x02) {
        timer.fireDate = [NSDate distantFuture];
        isRunning = YES;
        
    }else{
        

        [_sendDataView sendTarget_play_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x0a andFunctionMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr];
        [_sendDataView sendTarget_play_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x0a andFunctinMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr andSingleorMulti:issingleormulti];
        
    }
    
}
static int c = 0;

- (void)StopActionTimer:(NSTimer *)timer{
    NSLog(@"StopActionTimer");
    c++;
    if (c  > 10) {
        c = 0;
        timer.fireDate = [NSDate distantFuture];
        return;
    }
//    self.bannerView.alpha = 0;
    //    self.rootbackBtn.alpha = 1;
    [SVProgressHUD dismiss];
    
    if (_receiveView.S1A3_S1_Target_Task_Mode == 0x04 && _receiveView.S1A3_X2_Target_Task_Mode == 0x04) {
        
        S1A3_returnZeroTimer.fireDate = [NSDate distantFuture];
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        
        [_sendDataView sendTarget_play_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x0a andFunctionMode:0x04 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:0x00 andTimeStamp:0x00 WithStr:SendStr];
        [_sendDataView sendTarget_play_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x0a andFunctinMode:0x04 andDirection:0x00 andIsloop:0x00 andTotaltime:alltime andsmoothnessLevel:0x00 andTimeStamp:0x00 WithStr:SendStr andSingleorMulti:issingleormulti];

    }
    
}
- (void)ApointActionTimer:(NSTimer *)timer{
    NSLog(@"ApointActionTimer");
    
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
    
    
    if (_receiveView.S1A3_X2_Target_AB_Mark == 0x05 && ((_receiveView.S1A3_X2_Target_Mode & 0x0f) >> 1 == 1) && ((_receiveView.S1A3_S1_Target_Mode & 0x0f) >> 1 == 1)) {
        
        S1A3_record_A_SliderPosition = _receiveView.S1A3_S1_Target_A_Position;
        S1A3_record_A_panAngle = _receiveView.S1A3_X2_Target_Pan_RealAngle;
        S1A3_record_A_TiltAngle = _receiveView.S1A3_X2_Target_Tilt_RealAngle;
        
        [SVProgressHUD dismiss];
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        
        
        [_sendDataView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x05 andVeloc:0x00 andSlider_A_point:_receiveView.S1A3_S1_Target_RealPosition andSlider_B_point:_receiveView.S1A3_S1_Target_RealPosition andTotalTime:alltime WithStr:SendStr];
        [_sendDataView sendTarget_prepare_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x05 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.S1A3_X2_Target_Pan_RecordAngle andTilt_A_Point:_receiveView.S1A3_X2_Target_Tilt_RecordAngle andPan_B_point:_receiveView.S1A3_X2_Target_Pan_RecordAngle andTilt_B_Point:_receiveView.S1A3_X2_Target_Tilt_RecordAngle andTotalTime:alltime WithStr:SendStr];
    }
}
- (void)BpointActionTimer:(NSTimer *)timer{
    NSLog(@"BpointActionTimer");
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
    
    if (_receiveView.S1A3_X2_Target_AB_Mark == 0x06 && ((_receiveView.S1A3_X2_Target_Mode & 0x01) == 1) && ((_receiveView.S1A3_S1_Target_Mode & 0x01) == 1)) {
        [SVProgressHUD dismiss];
        S1A3_record_B_SliderPosition = _receiveView.S1A3_S1_Target_B_Position;
        S1A3_record_B_panAngle = _receiveView.S1A3_X2_Target_Pan_RealAngle;
        S1A3_record_B_TiltAngle = _receiveView.S1A3_X2_Target_Tilt_RealAngle;
        timer.fireDate = [NSDate distantFuture];
        
    }else{
        
        [_sendDataView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x06 andVeloc:0x00 andSlider_A_point:_receiveView.S1A3_S1_Target_RealPosition andSlider_B_point:_receiveView.S1A3_S1_Target_RealPosition andTotalTime:alltime WithStr:SendStr];
        
        [_sendDataView sendTarget_prepare_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x06 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.S1A3_X2_Target_Pan_RecordAngle andTilt_A_Point:_receiveView.S1A3_X2_Target_Tilt_RecordAngle andPan_B_point:_receiveView.S1A3_X2_Target_Pan_RecordAngle andTilt_B_Point:_receiveView.S1A3_X2_Target_Tilt_RecordAngle andTotalTime:alltime WithStr:SendStr];
        
    
    }
}
static int lcount = 0;

- (void)timeCurrentTimer:(NSTimer *)timer{
    NSLog(@"timeCurrentTimer");
    
    int a = lcount % 10;
    if (a == 0) {
        starttime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
        
    }
    lcount++;
    
    if (_receiveView.S1A3_S1_Target_Task_StartTime == (UInt32)starttime && _receiveView.S1A3_X2_Target_Task_StartTime == (UInt32)starttime) {
        NSLog(@"时间戳校准了");
        
        isRunning = YES;
        timer.fireDate = [NSDate distantFuture];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Target_Running, nil)];
        
    }else if(_receiveView.S1A3_S1_Target_Task_Mode == 0x02 && _receiveView.S1A3_X2_Target_Task_Mode == 0x02){
        
        isRunning = YES;
        timer.fireDate = [NSDate distantFuture];
        [SVProgressHUD setMinimumDismissTimeInterval:1.0f];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(Target_Running, nil)];
    }
    else{
        
        [_sendDataView sendTarget_play_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x0a andFunctionMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr];
        [_sendDataView sendTarget_play_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x0a andFunctinMode:0x02 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:starttime WithStr:SendStr andSingleorMulti:issingleormulti];
    }
}
static int b = 0;

- (void)AandB_PointActionTimer:(NSTimer *)timer{
    NSLog(@"AandB_PointActionTimer");
    b++;
    if (b > 3) {
        if (_receiveView.S1A3_X2_Target_Mode == 0x03 && _receiveView.S1A3_S1_Target_Mode == 0x03) {
            //
            b = 0;
            timer.fireDate = [NSDate distantFuture];
            
            //
        }else{
            
            [_sendDataView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x07 andVeloc:0x00 andSlider_A_point:(UInt32)(S1A3_record_A_SliderPosition * 100) andSlider_B_point:(UInt32)(S1A3_record_B_SliderPosition * 100) andTotalTime:alltime WithStr:SendStr];
            
            [_sendDataView sendTarget_prepare_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x07 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:S1A3_record_A_panAngle andTilt_A_Point:S1A3_record_A_TiltAngle andPan_B_point:S1A3_record_B_panAngle andTilt_B_Point:S1A3_record_B_TiltAngle andTotalTime:alltime WithStr:SendStr];
        }
    }else{
        [_sendDataView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x04 andVeloc:0x00 andSlider_A_point:(UInt32)(S1A3_record_A_SliderPosition * 100) andSlider_B_point:(UInt32)(S1A3_record_B_SliderPosition * 100) andTotalTime:alltime WithStr:SendStr];
        [_sendDataView sendTarget_prepare_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x04 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:S1A3_record_A_panAngle andTilt_A_Point:S1A3_record_A_TiltAngle andPan_B_point:S1A3_record_B_panAngle andTilt_B_Point:S1A3_record_B_TiltAngle andTotalTime:alltime WithStr:SendStr];
        
    }
    
}
- (void)freeReturnZeroTimer:(NSTimer *)timer{
    NSLog(@"freeReturnZeroTimer");
    
    if (_receiveView.S1A3_S1_Target_Task_Mode == 0x01 && _receiveView.S1A3_X2_Target_Task_Mode == 0x01) {
        
        S1A3_timeCorrectTimer.fireDate = [NSDate distantPast];
//        starttime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
        timer.fireDate = [NSDate distantFuture];
        
    }else if (_receiveView.S1A3_X2_Target_Task_Mode == 0x02 && _receiveView.S1A3_S1_Target_Task_Mode == 0x02){
         timer.fireDate = [NSDate distantFuture];
    }
    else{
        
        UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
        direction = 0x03;
        
        [_sendDataView sendTarget_play_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x0a andFunctionMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr];
        [_sendDataView sendTarget_play_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x0a andFunctinMode:0x00 andDirection:direction andIsloop:isloop andTotaltime:alltime andsmoothnessLevel:[smoothView getSmoothnesslevel] andTimeStamp:recordTime WithStr:SendStr andSingleorMulti:issingleormulti];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------创建摇杆及其操作区域--------------------
- (void)createRockerAndRockerSquare{
    [leftBackgroundView removeFromSuperview];
    leftBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(30), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    leftBackgroundView.backgroundColor = [UIColor clearColor];
    leftBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.15, AutoKscreenWidth * 0.65);
    [self.view addSubview:leftBackgroundView];
    
    [rightBackgroundView removeFromSuperview];
    rightBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(455), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    rightBackgroundView.backgroundColor = [UIColor clearColor];
    rightBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.65);
    
    [self.view addSubview:rightBackgroundView];
    
    /**
     右边摇杆
     */
    [self.RightanalogueStick removeFromSuperview];
    
    self.RightanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(455), iFSize(214), rightBackgroundView.frame.size.width * 0.6, rightBackgroundView.frame.size.width * 0.6)];
    self.RightanalogueStick.tag = rightRocker_Tag;
    self.RightanalogueStick.delegate = self;
    self.RightanalogueStick.center = CGPointMake(rightBackgroundView.frame.size.width * 0.5, rightBackgroundView.frame.size.height * 0.5);
    [rightBackgroundView addSubview:self.RightanalogueStick];
    
    /**
     左边摇杆
     */
    [self.LeftanalogueStick removeFromSuperview];
    self.LeftanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(79.5), iFSize(214), leftBackgroundView.frame.size.width * 0.6, leftBackgroundView.frame.size.width * 0.6)];
    self.LeftanalogueStick.center = CGPointMake(leftBackgroundView.frame.size.width * 0.5, leftBackgroundView.frame.size.height * 0.5);
    self.LeftanalogueStick.tag = leftRocker_Tag;
    self.LeftanalogueStick.delegate = self;
    [leftBackgroundView addSubview:self.LeftanalogueStick];
}
- (void)createTargetSlideView{
    slideView = [[iFFocusSlideView alloc]initWithFrame:CGRectMake(0, 0,  AutoKScreenHeight, AutoKscreenWidth)];
    slideView.progress = 0.0;
    slideView.layer.masksToBounds = YES;
    if (kDevice_Is_iPhoneX) {
        slideView.frame = CGRectMake(0, -40, AutoKScreenHeight, AutoKscreenWidth);
    }
    [self.view addSubview:slideView];
    [self.view sendSubviewToBack:slideView];
//    [self.view sendSubviewToBack:self.backimgaeView];
}
- (void)createBtnsAndLabels{
    
//    self.lockTiltBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2, iFSize(80), iFSize(35)) WithTitle:@"Lock tilt" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
//    self.lockTiltBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
//    [self.lockTiltBtn.actionBtn addTarget:self action:@selector(lockTiltAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.lockTiltBtn];
//
//    self.lockPanBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2 + self.lockTiltBtn.frame.size.height + 15, iFSize(80), iFSize(35)) WithTitle:@"Lock pan" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
//    self.lockPanBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
//    [self.lockPanBtn.actionBtn addTarget:self action:@selector(lockPanAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.lockPanBtn];
    self.single_MultiSegmentView = [[iFSegmentView alloc]initWithFrameTarget:CGRectMake(AutoKScreenHeight * 0.8, AutoKscreenWidth * 0.1, iFSize(120), iFSize(35)) andfirstTitle:@"Single" andSecondTitle:@"Multi" andSelectedIndex:0];
    self.single_MultiSegmentView.selectedIndex = 0;
    self.single_MultiSegmentView.delegate = self;
    
    [self.view addSubview:self.single_MultiSegmentView];
    
    
    
    self.lockTiltBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2, iFSize(80), iFSize(35)) WithTitle:nil selectedIMG:@"locktilt-selected" normalIMG:@"locktilt-normal"];
    self.lockTiltBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [self.lockTiltBtn.actionBtn addTarget:self action:@selector(lockTiltAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockTiltBtn];
    
    self.lockPanBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2 + self.lockTiltBtn.frame.size.height + 15, iFSize(80), iFSize(35)) WithTitle:nil selectedIMG:@"lockpan-selected" normalIMG:@"lockpan-normal"];
    self.lockPanBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [self.lockPanBtn.actionBtn addTarget:self action:@selector(lockPanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lockPanBtn];
    
    [self.single_MultiSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lockPanBtn.mas_right);
        make.top.mas_equalTo(AutoKscreenWidth * 0.08);
        make.size.mas_equalTo(CGSizeMake(iFSize(120), iFSize(30)));
    }];
    UILabel * smoothLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.14, 20)];
    smoothLabel.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth * 0.5);
    smoothLabel.textColor = COLOR(121, 121, 121, 1);
    smoothLabel.backgroundColor = [UIColor clearColor];
    smoothLabel.textAlignment = NSTextAlignmentCenter;
    smoothLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:smoothLabel.frame.size.height * 0.7];
    smoothLabel.text = @"smoothness";
    [self.view addSubview:smoothLabel];
    
    CGFloat smoothwidth, btnWidth;
    if (kDevice_Is_iPhoneX) {
        smoothwidth = AutoKscreenWidth * 0.05;
        
        btnWidth = AutoKscreenWidth * 0.14;
        
    }else if(kDevice_Is_iPad){
        smoothwidth =AutoKscreenWidth * 0.04;
        btnWidth = AutoKscreenWidth * 0.10;
    }else{
        
        smoothwidth =AutoKscreenWidth * 0.04;
        btnWidth = AutoKscreenWidth * 0.14;
        
    }
    smoothView = [[iFSmoothnessView alloc]initWithFrame:CGRectMake(0, 0, AutoKScreenHeight * 0.20,  smoothwidth)];
    smoothView.backgroundColor = [UIColor clearColor];
    smoothView.center = CGPointMake(AutoKScreenHeight * 0.5, [self getYLimitWithAboveView:smoothLabel] + smoothLabel.frame.size.height / 2);
    [self.view addSubview:smoothView];
    
    self.panValueLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(274), [self getYLimitWithAboveView:smoothView], iFSize(130), iFSize(13)) WithTitle:@"Pan value 0.0°" andFont:iFSize(12)];
    [self.view addSubview:self.panValueLabel];
    
    self.tiltValueLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(274), [self getYLimitWithAboveView:self.panValueLabel], iFSize(130), iFSize(13)) WithTitle:@"Tilt value 0.0°" andFont:iFSize(12)];
    [self.view addSubview:self.tiltValueLabel];
    
    self.slideValueLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(274), [self getYLimitWithAboveView:self.tiltValueLabel], iFSize(130), iFSize(13)) WithTitle:@"slide value 000mm" andFont:iFSize(12)];
    [self.view addSubview:self.slideValueLabel];
    
    self.playBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth) WithTitle:nil selectedIMG:all_PALYBTNIMG normalIMG:all_PALYBTNIMG];
    self.playBtn.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth - 10 - AutoKscreenWidth * 0.07);
    [self.playBtn.actionBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn.alpha = 1;
    [self.view addSubview:self.playBtn];
    
    self.stopBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth) WithTitle:nil selectedIMG:all_STOPBTNIMG normalIMG:all_STOPBTNIMG];
    [self.stopBtn.actionBtn addTarget:self action:@selector(StopAction:) forControlEvents:UIControlEventTouchUpInside];
    self.stopBtn.center = self.playBtn.center;
    self.stopBtn.alpha = 0;
    [self.view addSubview:self.stopBtn];
    
    
    self.leftPlayBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(277), iFSize(332), btnWidth, btnWidth) WithTitle:nil selectedIMG:@"target_leftplay@3x" normalIMG:@"target_leftplay@3x"];
    self.leftPlayBtn.center = CGPointMake(self.playBtn.center.x - AutoKscreenWidth * 0.14 - 17,self.playBtn.center.y);
    [self.leftPlayBtn.actionBtn addTarget:self action:@selector(leftStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftPlayBtn];
    
//    self.pauseBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(320), iFSize(332), iFSize(27), iFSize(30)) andnormalImage:@"pause" andSelectedImage:@"pause"];
//    [self.pauseBtn addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:self.pauseBtn];
    
    self.rightPlayBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(365), iFSize(332), btnWidth, btnWidth) WithTitle:nil selectedIMG:@"targer_rightplay@3x" normalIMG:@"targer_rightplay@3x"];
    self.rightPlayBtn.center = CGPointMake(self.playBtn.center.x + 17 + AutoKscreenWidth * 0.14,self.playBtn.center.y);
    [self.rightPlayBtn.actionBtn addTarget:self action:@selector(rightStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightPlayBtn];
    
    self.setStartBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(167), iFSize(335), btnWidth * 1.5, btnWidth * 0.7) WithTitle:@"Set A" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    self.setStartBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(12.5)];
    [self.setStartBtn.actionBtn addTarget:self action:@selector(setStartAction:) forControlEvents:UIControlEventTouchUpInside];
    self.setStartBtn.center = CGPointMake(self.leftPlayBtn.center.x - 30 - AutoKScreenHeight * 0.075, self.leftPlayBtn.center.y);
    [self.view addSubview:self.setStartBtn];
    
    
    self.setEndBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(iFSize(420), iFSize(335), btnWidth * 1.5, btnWidth * 0.7) WithTitle:@"Set B" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    self.setEndBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(12.5)];
    [self.setEndBtn.actionBtn addTarget:self action:@selector(setSetEndAction:) forControlEvents:UIControlEventTouchUpInside];
    self.setEndBtn.center = CGPointMake(self.rightPlayBtn.center.x + 30 + AutoKScreenHeight * 0.075, self.rightPlayBtn.center.y);
    [self.view addSubview:self.setEndBtn];
    
    self.fileBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth) WithTitle:nil selectedIMG:@"target_file@3x" normalIMG:@"target_file@3x"];
    self.fileBtn.center = CGPointMake(AutoKScreenHeight * 0.15,self.playBtn.center.y);
    [self.fileBtn.actionBtn addTarget:self action:@selector(fileAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.fileBtn];
    
    self.saveBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth) WithTitle:nil selectedIMG:@"Timelapse_SaveBtn@3x" normalIMG:@"Timelapse_SaveBtn@3x"];
    self.saveBtn.center = CGPointMake(AutoKScreenHeight * 0.85, self.playBtn.center.y);
    [self.saveBtn.actionBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
    
    A_pointValueView = [[iFTarget_PointValueView alloc]initWithFrame:CGRectMake(0, 0, 100, 80) WithTitle:@"A point"];
    A_pointValueView.center = CGPointMake(AutoKScreenHeight * 0.3, AutoKscreenWidth * 0.25);
    A_pointValueView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:A_pointValueView];
    
    B_pointValueView = [[iFTarget_PointValueView alloc]initWithFrame:CGRectMake(0, 0, 100, 80) WithTitle:@"B point"];
    B_pointValueView.center = CGPointMake(AutoKScreenHeight * 0.7, AutoKscreenWidth * 0.25);
    B_pointValueView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:B_pointValueView];
    
    self.isLoopBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(75), iFSize(105), iFSize(30), iFSize(30)) andnormalImage:target_UNLOOPIMG andSelectedImage:target_LOOPIMG];
    [self.isLoopBtn addTarget:self action:@selector(isloopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.isLoopBtn];

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapChooseTotalTime:)];
    
    NSString * timeStr = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith:S1A3Model.S1A3_Target_totaltime]];
    
    self.timeLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(285), iFSize(67), iFSize(120), iFSize(40)) WithTitle:timeStr andFont:iFSize(35)];
    self.timeLabel.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth * 0.2);
    self.timeLabel.userInteractionEnabled = YES;
    [self.timeLabel addGestureRecognizer:tapGesture];
    [self.view addSubview:self.timeLabel];
    
    fileview = [[UIView alloc]initWithFrame:CGRectMake(0, -AutoKscreenWidth, AutoKScreenHeight * 0.4, AutoKscreenWidth)];
    fileview.backgroundColor = [UIColor blackColor];
    fileview.layer.borderWidth = 2;
    fileview.layer.borderColor = [UIColor whiteColor].CGColor;
    fileview.layer.cornerRadius = 5;
    [self.view addSubview:fileview];
    
    iFButton * closeBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 80, 50) andTitle:@"close"];
    [closeBtn addTarget:self action:@selector(closeFileAction:) forControlEvents:UIControlEventTouchUpInside];
    [fileview addSubview:closeBtn];
    
    fileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, fileview.frame.size.width, fileview.frame.size.height - 50)];
    fileTableView.dataSource = self;
    fileTableView.delegate = self;
    fileTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_TargetModelList];
    fileDataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    [fileview addSubview:fileTableView];
}
- (CGFloat)getYLimitWithAboveView:(UIView *)aboveView{
    
    CGFloat y = 0.0f;
    y = aboveView.frame.size.height + aboveView.frame.origin.y + 5;
    return y;
}
- (CGFloat)getXLeftLimitWithCenterView:(UIView *)centerView{
    CGFloat x = 0.0f;
    x = centerView.frame.origin.x - 8.5 - AutoKscreenWidth * 0.13;
    return x;
}
- (CGFloat)getXRightLimitWithCenterView:(UIView *)centerView{
    CGFloat x = 0.0f;
    x = centerView.frame.origin.x + centerView.frame.size.width + 8.5;
    return x;
}
- (CGFloat)getYLimitWithFollowView:(UIView *)followView{
    
    CGFloat y = 0.0f;
    y = followView.frame.origin.y - 5 - AutoKscreenWidth * 0.07;
    return y;
}
#pragma mark ---- playAction -------
- (void)playAction:(UIButton *)btn{
    if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == NO) {
        NSLog(@"都没有设置");
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ABNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == YES && self.setEndBtn.actionBtn.selected == NO){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_BNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == YES){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ANoSettings, nil)];
        return;
        
    }
    if (S1A3_record_A_panAngle == S1A3_record_B_panAngle) {
        NSLog(@"AB两点相同不够成夹角");
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(Target_AngelError, nil)];
        return;
    }
    if (S1A3_record_A_SliderPosition == S1A3_record_B_SliderPosition) {
        NSLog(@"AB两点相同");
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(Target_AngelError, nil)];
        return;
        
    }
    
//    [self changeTheTimeLabelWithMinTime];
    
    _receiveView.S1A3_S1_Target_Task_Percent = 0;
    _receiveView.S1A3_X2_Target_Task_Percent = 0;
    
    self.stopBtn.alpha = 1;
    self.playBtn.alpha = 0;
    
    
    
    self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
    S1A3_StopTimer.fireDate = [NSDate distantFuture];
    
    [_RightanalogueStick dellocRcoker];
    [_LeftanalogueStick dellocRcoker];
    
    
    if (_receiveView.S1A3_S1_Target_Task_Mode == 0x01 && _receiveView.S1A3_X2_Target_Task_Mode == 0x01) {
        
        S1A3_timeCorrectTimer.fireDate = [NSDate distantPast];
        starttime = ([[NSDate date] timeIntervalSince1970] + 1) * 1000;
        
        
    }else{
        
        S1A3_freeReturnZeroTimer.fireDate = [NSDate distantPast];
    }
}
#pragma mark -----StopAction ------
- (void)StopAction:(UIButton *)btn{
    self.rootbackBtn.alpha = 1;
    _receiveView.S1A3_X2_Target_Task_Percent = 0;
    _receiveView.S1A3_S1_Target_Task_Percent = 0;
    S1A3_returnZeroTimer.fireDate = [NSDate distantFuture];
    [self stopAlltimer];
    
    S1A3_StopTimer.fireDate = [NSDate distantPast];

    
    isRunning = NO;
    self.stopBtn.alpha = 0;
    self.playBtn.alpha = 1;
    self.leftPlayBtn.actionBtn.userInteractionEnabled = YES;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = YES;
    [_RightanalogueStick reStartRocker];
    [_LeftanalogueStick reStartRocker];
}
#pragma mark ----lockTiltAction ------
- (void)lockTiltAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        islockTilt = 0x00;
    }else{
        islockTilt = 0x01;
        
    }
    
}
#pragma mark ----lockPanAction ------
- (void)lockPanAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        islockPan = 0x00;
    }else{
        islockPan = 0x01;
        
    }
}
#pragma mark ----leftStartAction -----
- (void)leftStartAction:(UIButton *)btn{
    _receiveView.S1A3_S1_Target_Task_Mode = 0x00;
    _receiveView.S1A3_X2_Target_Task_Mode = 0x00;
    
    
    if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == NO) {
        NSLog(@"都没有设置");
        
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ABNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == YES && self.setEndBtn.actionBtn.selected == NO){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_BNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == YES){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ANoSettings, nil)];
        return;
    }
    //    self.rootbackBtn.alpha = 0;
    //    self.bannerView.alpha = 1;
    a = 0;
    direction = 0x02;
    slideView.direction = direction;
    
    self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
    self.playBtn.alpha = 0;
    self.stopBtn.alpha = 1;
    
    [_RightanalogueStick dellocRcoker];
    [_LeftanalogueStick dellocRcoker];
    
    S1A3_returnZeroTimer.fireDate = [NSDate distantPast];
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
}
#pragma mark ----rightStartAction ----
- (void)rightStartAction:(UIButton *)btn{
    _receiveView.S1A3_S1_Target_Task_Mode = 0x00;
    _receiveView.S1A3_X2_Target_Task_Mode = 0x00;
    if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == NO) {
        NSLog(@"都没有设置");
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ABNoSettings, nil)];
        
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == YES && self.setEndBtn.actionBtn.selected == NO){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_BNoSettings, nil)];
        return;
        
    }else if (self.setStartBtn.actionBtn.selected == NO && self.setEndBtn.actionBtn.selected == YES){
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(Target_ANoSettings, nil)];
        return;
        
    }
    self.playBtn.alpha = 0;
    self.stopBtn.alpha = 1;
    NSLog(@"Start = %d", self.setStartBtn.actionBtn.selected);
    NSLog(@"End = %d", self.setEndBtn.actionBtn.selected);
    //    self.rootbackBtn.alpha = 0;
    //    self.bannerView.alpha = 1;
    self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
    self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
    [_RightanalogueStick dellocRcoker];
    [_LeftanalogueStick dellocRcoker];
    
    
    a = 0;
    direction = 0x01;
    slideView.direction = direction;
    S1A3_returnZeroTimer.fireDate = [NSDate distantPast];
    [SVProgressHUD showWithStatus:NSLocalizedString(Target_Preparing, nil)];
}
#pragma mark ---A_setStartAction ------
- (void)setStartAction:(UIButton *)btn{
    
    if ([self judgeIsRightSettingWithPanValue]) {
        
        
        if (btn.selected) {
            [_sendDataView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x08 andVeloc:0x00 andSlider_A_point:_receiveView.S1A3_S1_Target_RealPosition andSlider_B_point:_receiveView.S1A3_S1_Target_RealPosition andTotalTime:alltime WithStr:SendStr];
            
            [_sendDataView sendTarget_prepare_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x08 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.S1A3_X2_Target_Pan_RealAngle andTilt_A_Point:_receiveView.S1A3_X2_Target_Tilt_RealAngle andPan_B_point:_receiveView.S1A3_X2_Target_Pan_RealAngle andTilt_B_Point:_receiveView.S1A3_X2_Target_Tilt_RealAngle andTotalTime:alltime WithStr:SendStr];
            
            S1A3_record_A_SliderPosition = 0;
            S1A3_record_A_panAngle = 0;
            S1A3_record_A_TiltAngle = 0;
            S1A3_LeftPointTimer.fireDate = [NSDate distantFuture];
//
        }else{
            direction = 0x01;
//
            S1A3_record_A_SliderPosition = _receiveView.S1A3_S1_Target_RealPosition;
            S1A3_record_A_panAngle = _receiveView.S1A3_X2_Target_Pan_RecordAngle;
            S1A3_record_A_TiltAngle = _receiveView.S1A3_X2_Target_Tilt_RecordAngle;
            
////                        btn.userInteractionEnabled = NO;
            S1A3_LeftPointTimer.fireDate = [NSDate distantPast];
        }
        [self changeBtnSelected:btn];
    }
}
- (BOOL)judgeIsRightSettingWithPanValue{
    
    BOOL isPanAg = NO;
    
    CGFloat panAg;
    CGFloat TiltAg;
    CGFloat slideVa;
    CGFloat slidemin;
    panAg = (_receiveView.S1A3_X2_Target_Pan_RealAngle - 3600.0f) / 10.0f;
    TiltAg = (_receiveView.S1A3_X2_Target_Tilt_RealAngle - 3600.0f) / 10.0f;
    slideVa = _receiveView.S1A3_S1_Target_RealPosition / 100.0f;
    
    slidemin = _receiveView.S1A3_S1_Target_B_Position < _receiveView.S1A3_S1_Target_A_Position ? _receiveView.S1A3_S1_Target_B_Position : _receiveView.S1A3_S1_Target_A_Position;
    
    if (panAg >= -90.0f && panAg <= 90.0f) {
        isPanAg = YES;
        
    }else{
        isPanAg = NO;
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(Target_AngelError, nil)];
        
    }
    NSLog(@"%f", panAg);
    NSLog(@"%f", TiltAg);
    NSLog(@"%f", slideVa);
    NSLog(@"%f", slidemin);
    return isPanAg;
}

#pragma mark ---B_setSetEndAction ------
- (void)setSetEndAction:(UIButton *)btn{
    if ([self judgeIsRightSettingWithPanValue]) {
        if (btn.selected) {
            
            [_sendDataView sendTarget_prepare_SliderWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x09 andFunctionMode:0x09 andVeloc:0x00 andSlider_A_point:_receiveView.S1A3_S1_Target_RealPosition andSlider_B_point:_receiveView.S1A3_S1_Target_RealPosition andTotalTime:alltime WithStr:SendStr];
            
            [_sendDataView sendTarget_prepare_X2WithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x09 andFunctionMode:0x09 andpanVeloc:0x00 andtiltVeloc:0x00 andPan_A_point:_receiveView.S1A3_X2_Target_Pan_RealAngle andTilt_A_Point:_receiveView.S1A3_X2_Target_Tilt_RealAngle andPan_B_point:_receiveView.S1A3_X2_Target_Pan_RealAngle andTilt_B_Point:_receiveView.S1A3_X2_Target_Tilt_RealAngle andTotalTime:alltime WithStr:SendStr];
            
            S1A3_record_B_SliderPosition = 0;
            S1A3_record_B_panAngle = 0;
            S1A3_record_B_TiltAngle = 0;
            
            S1A3_RightPointTimer.fireDate = [NSDate distantFuture];
        }else{
            S1A3_record_B_SliderPosition = _receiveView.S1A3_S1_Target_B_Position;
            S1A3_record_B_panAngle = _receiveView.S1A3_X2_Target_Pan_RecordAngle;
            S1A3_record_B_TiltAngle = _receiveView.S1A3_X2_Target_Tilt_RecordAngle;
            //            btn.userInteractionEnabled = NO;
            direction = 0x02;
            
            S1A3_RightPointTimer.fireDate = [NSDate distantPast];
        }
        
        [self changeBtnSelected:btn];
        
    }
}
- (void)changeBtnSelected:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor grayColor];
    }else{
        btn.backgroundColor = [UIColor clearColor];
        
    }
}


#pragma mark ----isloopAction ---
- (void)isloopAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        NSLog(@"1");
        isloop = 0x01;
        
    }else{
        isloop = 0x00;
        NSLog(@"2");
    }
    [_sendDataView sendFocusModeWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x0A andFunctionMode:0x01 andDirction:direction andIsloop:isloop andTimeStamp_ms:starttime WithStr:SendStr andAllTime:alltime];
    [_sendDataView sendFocusModeWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:OX555F andFunctionNumber:0x0A andFunctionMode:0x01 andDirction:direction andIsloop:isloop andTimeStamp_ms:starttime WithStr:SendStr andAllTime:alltime];
    
}
#pragma mark ---tapChooseTotalTimeGesture----
- (void)tapChooseTotalTime:(UITapGestureRecognizer *)tap{
    self.popover = [DXPopover new];
    iFTimePickerView * view = [[iFTimePickerView alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(200)) withMinValue:0];
    view.timelapseDelegate = self;
    [self.popover showAtView:tap.view withContentView:view];
    [view setInitValue:alltime];
}

- (void)getTimelapseTime:(CGFloat)totalTime{
    
    NSInteger TheTotalTime = totalTime;
    int minTime = (int)ceil([self getMinTimeWithSlideABDistance:slideDistance andPanABDistance:panDistance]);
    alltime = TheTotalTime > minTime ? TheTotalTime : minTime;
    S1A3Model.S1A3_Target_totaltime = alltime;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", [iFGetDataTool getTimeWith:alltime]];
    
}

- (CGFloat)getMinTimeWithSlideABDistance:(CGFloat)slidedistance andPanABDistance:(CGFloat)pandistace{
    CGFloat mintime;
    CGFloat t1, t2;
        if(slidedistance >= 256.0f)
        {
            t1=3.2f+(slidedistance - 256.0f) / 160.0f;
        }
        else
        {
            t1=0.1*sqrtf((float)slidedistance * 2);
        }

        if(pandistace >=20.0f)
        {
            t2=2.0f+( pandistace -20.0f) / 40.0f;
        }
        else
        {
            t2=sqrtf (pandistace / 20.0f);
        }
    mintime = t1 > t2 ? t1 : t2;
    return mintime;
}
#pragma mark -------摇杆代理-------------
- (void)analogueStickDidChangeValue:(iFootageRocker *)analogueStick{
    NSLog(@"%lf", analogueStick.xValue);
    
//    CGFloat panV, tiltV = 0.0;
//    CGFloat sliderV = 0.0;
    UInt16 panVelocityVector;
    UInt16 tiltVelocityVector;
    UInt16 slideVelocityVector;
    
    _receiveView.S1A3_S1_Target_Task_Mode = 0x00;
    _receiveView.S1A3_X2_Target_Task_Mode = 0x00;
    
    //    NSLog(@"%f", analogueStick.xValue);
    //    NSLog(@"%f", analogueStick.yValue);
    if (analogueStick.tag == rightRocker_Tag) {
        
        if (analogueStick.xValue >= 1.0f) {
            //            NSLog(@"P = %lf",         [panAdjustView CountSomeThingsAndPointX:1.0f]);
//            panV =  [panAdjustView CountSomeThingsAndPointX:1.0f];
            
            
        }else{
//            panV = [panAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
            
            
        }
//        NSLog(@"P = %lf", panV);
        
//        NSLog(@"T = %lf", tiltV);
        
        
        
        if (analogueStick.yValue >= 1.0f) {
            //            NSLog(@"P = %lf",         [panAdjustView CountSomeThingsAndPointX:1.0f]);
//            tiltV = [tiltAdjustView CountSomeThingsAndPointX:1.0f];
            
            
        }else{
//            tiltV = [tiltAdjustView CountSomeThingsAndPointX:analogueStick.yValue];
            
        }
//        if (panV < 0.0001 && panV >= 0.0f) {
//            panV = 0.0f;
//        }
//        if (panV > -0.0001 && panV < 0.0f) {
//            panV = 0.0f;
//        }
//        if (tiltV < 0.0001 && tiltV >= 0.0f) {
//            tiltV = 0.0f;
//        }
//        if (tiltV > -0.0001 && tiltV < 0.0f) {
//            tiltV = 0.0f;
//        }
        panVelocityVector = analogueStick.xValue * S1A3_PanVelocMaxValue  * islockPan * 100.0f + 4000;
        tiltVelocityVector = analogueStick.yValue * S1A3_TiltVelocMaxValue  * islockTilt* 100.0f + 4000;
        
//        NSLog(@"%d, %d", panVelocityVector, tiltVelocityVector);
        
        [_sendDataView sendSetFocusModeWithCb:appDelegate.bleManager.S1A3_X2CB andFrameHead:0x555F andFuntionNumber:0X09 andFunctionMode:0X01 andSlideOrPanVeloc:panVelocityVector andTiltVeloc:tiltVelocityVector andIsLockTilt:self.lockTiltBtn.actionBtn.selected andTotalTime:0X00 WithStr:SendStr];
        
        NSLog(@"%d", panVelocityVector);
        
    }else if (analogueStick.tag == leftRocker_Tag) {
//        if (analogueStick.xValue >= 1.0f) {
//
//            sliderV =  [slideAdjustView CountSomeThingsAndPointX:1.0f];
//
//        }else{
//            sliderV = [slideAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
//        }
        slideVelocityVector = analogueStick.xValue * S1A3_SlideVelocMaxValue * 100.0f + 16000;
        
        NSLog(@"%d", slideVelocityVector);
        
        [_sendDataView sendSetFocusModeWithCb:appDelegate.bleManager.S1A3_S1CB andFrameHead:0xAAAF andFuntionNumber:0x09 andFunctionMode:0x01 andSlideOrPanVeloc:slideVelocityVector andTiltVeloc:0x00 andIsLockTilt:self.lockTiltBtn.actionBtn.selected andTotalTime:0x00 WithStr:SendStr];
        
    }

}
#pragma mark -------手势响应计算---------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touchLocation in touches) {
        NSLog(@"begin touch %@",NSStringFromCGPoint([touchLocation locationInView:rightBackgroundView]));
        if ([rightBackgroundView.layer containsPoint:[touchLocation locationInView:rightBackgroundView]]) {
            NSLog(@"right");
            self.RightanalogueStick.center = [touchLocation locationInView:rightBackgroundView];
            [self.RightanalogueStick touchesBegan];
            self.RightanalogueStick.touch = touchLocation;
        }
        
        if ([leftBackgroundView.layer containsPoint:[touchLocation locationInView:leftBackgroundView]]) {
            self.LeftanalogueStick.center = [touchLocation locationInView:leftBackgroundView];
            
            [self.LeftanalogueStick touchesBegan];
            self.LeftanalogueStick.touch = touchLocation;
        }
    }
    
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        if (touch == self.RightanalogueStick.touch) {
            [self.RightanalogueStick reset];
            [self.RightanalogueStick touchesEnded];
            
        }
        if (touch == self.LeftanalogueStick.touch) {
            [self.LeftanalogueStick reset];
            
            [self.LeftanalogueStick touchesEnded];
            
        }
    }
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        if (touch == self.RightanalogueStick.touch) {
            [self.RightanalogueStick autoPoint:[touch locationInView:rightBackgroundView]];
        }
        if (touch == self.LeftanalogueStick.touch) {
            [self.LeftanalogueStick autoPoint:[touch locationInView:leftBackgroundView]];
        }
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    
    
    for (UITouch *touch in touches) {
        if (touch == self.RightanalogueStick.touch) {
            [self.RightanalogueStick reset];
            [self.RightanalogueStick touchesEnded];
            
        }
        if (touch == self.LeftanalogueStick.touch) {
            [self.LeftanalogueStick reset];
            
            [self.LeftanalogueStick touchesEnded];
            
        }
    }
    
}

CGFloat panAg = 0.0;
CGFloat TiltAg = 0.0;
CGFloat slideVa = 0.0;
CGFloat slidemin= 0.0;
- (void)S1A3_receiveRealData{
    
    
//    NSLog(@"S1A3_S1_Target_RealPosition%f", _receiveView.S1A3_S1_Target_RealPosition / 100.0f);
//
//    NSLog(@"S1A3_X2_Target_Pan_RealAngle%f", (_receiveView.S1A3_X2_Target_Pan_RealAngle - 3600.0f) / 10.f );
//    NSLog(@"S1A3_X2_Target_Tilt_RealAngle%f", (_receiveView.S1A3_X2_Target_Tilt_RealAngle - 3600.0f) / 10.0f);
//    [self GetMinTime];
    


    
//    NSLog(@"%d", S1A3_record_A_TiltAngle);
//    NSLog(@"S1A3_record_A_SliderPosition%ld", S1A3_record_A_SliderPosition);
//    NSLog(@"S1A3_record_B_SliderPosition%ld", S1A3_record_B_SliderPosition);
//    NSLog(@"S1A3_S1_Target_Task_RealPosition%d", _receiveView.S1A3_S1_Target_Task_RealPosition);
//    NSLog(@"S1A3_X2_Target_Task_PanRealAngle%d", _receiveView.S1A3_X2_Target_Task_PanRealAngle);
//    NSLog(@"S1A3_X2_Target_Task_TiltRealAngle%d", _receiveView.S1A3_X2_Target_Task_TiltRealAngle);
    NSLog(@"S1A3_X2_Target_Task_Percent%d", _receiveView.S1A3_X2_Target_Task_Percent);
    NSLog(@"S1A3_S1_Target_Task_Percent%d", _receiveView.S1A3_S1_Target_Task_Percent);
//    NSLog(@"S1MODE%d X2MODE%d", _receiveView.S1MODE, _receiveView.X2MODE);

    
    if (isRunning) {
//        NSLog(@"FMTaskslideMode%d", _receiveView.FMTaskslideMode);
//        NSLog(@"FMx2taskMode%d", _receiveView.FMx2taskMode);
//        NSLog(@"FMx2taskPercent%d", _receiveView.FMx2taskPercent);
//        NSLog(@"FMtaskSlidePercent%d", _receiveView.FMtaskSlidePercent);
        self.playBtn.alpha = 0;
        self.stopBtn.alpha = 1;
        
        if (isloop) {
            
            
        }else{
            
            if (_receiveView.S1A3_S1_Target_Task_Percent == 0 && _receiveView.S1A3_X2_Target_Task_Percent == 0 && _receiveView.S1A3_S1_Target_Task_Mode == 0x04 && _receiveView.S1A3_X2_Target_Task_Mode == 0x04) {
                
                [self StopAction:nil];
            }
            
         
        }
        
    }
    slideDistance = fabs((float)(_receiveView.S1A3_S1_Target_B_Position - _receiveView.S1A3_S1_Target_A_Position));
    
    
    
    //    NSLog(@"slidedistance = %f, pandistance = %f", slideDistance, panDistance);
   
    
    if (_receiveView.S1A3_S1MODE == 0x0a) {
        slideVa = _receiveView.S1A3_S1_Target_Task_RealPosition / 100.0f;

    }
    if (_receiveView.S1A3_S1MODE == 0x09) {
        
        slideVa = _receiveView.S1A3_S1_Target_RealPosition / 100.0f;
    }
 
    
    if( _receiveView.S1A3_X2MODE == 0x0a){
            panAg = (_receiveView.S1A3_X2_Target_Task_PanRealAngle - 3600.0f) / 10.0f;
            TiltAg = (_receiveView.S1A3_X2_Target_Task_TiltRealAngle - 3600.0f) / 10.0f;
    }
    else if(_receiveView.S1A3_X2MODE == 0x09){
            panAg = (_receiveView.S1A3_X2_Target_Pan_RealAngle - 3600.0f) / 10.0f;
            TiltAg = (_receiveView.S1A3_X2_Target_Tilt_RealAngle - 3600.0f) / 10.0f;
        }
    
    
//    slidemin = _receiveView.S1A3_S1_Target_B_Position < _receiveView.S1A3_S1_Target_A_Position ? _receiveView.S1A3_S1_Target_B_Position : _receiveView.S1A3_S1_Target_A_Position;
    
    CGFloat Adistance = S1A3_record_A_SliderPosition - slideVa;
    CGFloat Bdistance = S1A3_record_B_SliderPosition - slideVa;
    
    if (direction == 0x01) {
        slideView.progress = (_receiveView.S1A3_S1_Target_Task_Percent/ 99.9 + 1.0f);
    }else if(direction == 0x02){
        
        slideView.progress = _receiveView.S1A3_S1_Target_Task_Percent/ 99.9;
        
    }else{
        
        if (Adistance > Bdistance) {
            
            slideView.direction = 0x01;
            slideView.progress = (_receiveView.S1A3_S1_Target_Task_Percent/ 99.9 + 1.0f);
            
        }else{
            
            slideView.direction = 0x02;
            slideView.progress = -_receiveView.S1A3_S1_Target_Task_Percent/ 99.9;
        }
    }
    //    NSLog(@"slideVa = %lf", slideVa);
    //    NSLog(@"slidemin = %lf", slidemin);
    
    [self isLockAlluserInteractionEnabled];

    self.panValueLabel.text = [NSString stringWithFormat:@"Pan value %.1f°", panAg];
    self.tiltValueLabel.text = [NSString stringWithFormat:@"Tilt value %.1f°", TiltAg];
    self.slideValueLabel.text = [NSString stringWithFormat:@"slide value %.1fmm", slideVa];
    
    //    int minTime = (int)ceil([self getMinTimeWithSlideABDistance:slideDistance andPanABDistance:panDistance]);
//    alltime = [self GetMinTime];
//    [self isLockAlluserInteractionEnabled];
    
    if (self.setStartBtn.actionBtn.selected) {
        A_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (S1A3_record_A_panAngle - 3600.0f) / 10.0f];
        A_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (S1A3_record_A_TiltAngle - 3600.0f) / 10.0f];
        A_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.0fmm", (float)S1A3_record_A_SliderPosition];
        
    }else{
        A_pointValueView.panValueLabel.text = @"no set";
        A_pointValueView.tiltValueLabel.text = @"no set";
        A_pointValueView.slideValueLabel.text = @"no set";
    }
    
    if (self.setEndBtn.actionBtn.selected) {
        B_pointValueView.panValueLabel.text = [NSString stringWithFormat:@"%.1f°", (S1A3_record_B_panAngle - 3600.0f) / 10.0f];
        B_pointValueView.tiltValueLabel.text = [NSString stringWithFormat:@"%.1f°", (S1A3_record_B_TiltAngle - 3600.0f) / 10.0f];
        B_pointValueView.slideValueLabel.text = [NSString stringWithFormat:@"%.0fmm", (float)S1A3_record_B_SliderPosition];
        
    }else{
        
        B_pointValueView.panValueLabel.text = @"no set";
        B_pointValueView.tiltValueLabel.text = @"no set";
        B_pointValueView.slideValueLabel.text = @"no set";
    }
    
}

//string To十六进制字符串
- (NSString *)stringToHex:(NSString *)string
{
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    return hexStr;
}

- (void)isLockAlluserInteractionEnabled{
    if (self.stopBtn.alpha == 1 && self.playBtn.alpha == 0) {
        
        self.leftPlayBtn.actionBtn.userInteractionEnabled = NO;
        self.rightPlayBtn.actionBtn.userInteractionEnabled = NO;
        smoothView.userInteractionEnabled = NO;
        self.rootbackBtn.alpha = 0;

        self.setStartBtn.userInteractionEnabled = NO;
        self.setEndBtn.userInteractionEnabled = NO;
        
        [_RightanalogueStick dellocRcoker];
        [_LeftanalogueStick dellocRcoker];
    }else{
        
        self.leftPlayBtn.actionBtn.userInteractionEnabled = YES;
        self.rightPlayBtn.actionBtn.userInteractionEnabled = YES;
        smoothView.userInteractionEnabled = YES;
        self.rootbackBtn.alpha = 1;

        self.setStartBtn.userInteractionEnabled = YES;
        self.setEndBtn.userInteractionEnabled = YES;
        [_RightanalogueStick reStartRocker];
        [_LeftanalogueStick reStartRocker];
    }
    
}
- (void)getSelectedIndex:(NSInteger)selectedIndex withTag:(NSInteger)tag{
    issingleormulti = selectedIndex;
    NSLog(@"%d", issingleormulti);
}
#pragma mark --------需要旋转横屏--------退回返回全方位-------
- (void)viewWillDisappear:(BOOL)animated{
    [self closeAllTimer];
    [self closeOneTimer:S1A3_StopTimer];
    
    [self forceOrientationPortrait];
}
- (void)viewWillAppear:(BOOL)animated{
    [self creatAllTimer];
    [self forceOrientationLandscape];
    [self createRockerAndRockerSquare];
    [self createTargetSlideView];
    [self createBtnsAndLabels];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
