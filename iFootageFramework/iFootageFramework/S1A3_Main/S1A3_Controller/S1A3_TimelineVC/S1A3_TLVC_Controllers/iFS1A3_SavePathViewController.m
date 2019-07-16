//
//  iFS1A3_SavePathViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/23.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_SavePathViewController.h"
#import "iFS1A3_TimelineViewController.h"
#import "AppDelegate.h"
#import "iFKeyframeCurveTableViewCell.h"
#import <Masonry/Masonry.h>
#define IFKEYFRAMECELLID @"iFKeyframeCurveTableViewCell"
#import "iFS1A3_Model.h"
#import "iFStateView.h"
#import "iFRootViewController.h"
#import "iFButton.h"
#import "iFLabel.h"
#import "ReceiveView.h"
@interface iFS1A3_SavePathViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)iFS1A3_Model * S1A3_Model;


@end

@implementation iFS1A3_SavePathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"S1A3 Save Path";
    self.connectBtn.alpha = 0;
//    self.rootbackBtn.alpha = 1;

    iFButton * newBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24) andTitle:NSLocalizedString(KeyFrame_new, nil)];
    [newBtn addTarget:self action:@selector(nextNewPathAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn];
    
    
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([NSNumber numberWithInteger:(-20 + [UIApplication sharedApplication].statusBarFrame.size.height)]);
        make.right.equalTo([NSNumber numberWithInt:-5]);
        make.width.equalTo(@96);
        make.height.equalTo(@96);
    }];
    [self createUI];
    [self.view bringSubviewToFront:self.rootbackBtn];
    [self.view bringSubviewToFront:newBtn];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.f];

}
- (void)delayMethod{
    
    if ([ReceiveView sharedInstance].S1A3_S1_Timeline_TaskMode == 0x02 || [ReceiveView sharedInstance].S1A3_X2_Timeline_TaskMode == 0x02) {
        iFS1A3_TimelineViewController * iftimelineVC = [[iFS1A3_TimelineViewController alloc]init];
        iftimelineVC.isSaveData = NO;
        //            iftimelapseVC.indexRow = 0;
        [self.navigationController pushViewController:iftimelineVC animated:NO];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.dataArray  = [NSMutableArray new];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_ProperKeyFrameList];
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray * array1 = @[NSLocalizedString(KeyFrame_PreviousPath, nil)];
    [self.dataArray addObject:array1];
    if (array) {
        [self.dataArray addObject:array];
    }
    [self.tableView reloadData];
    
}
- (void)createUI{
   
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.tableView registerClass:[iFKeyframeCurveTableViewCell class] forCellReuseIdentifier:IFKEYFRAMECELLID];
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [self.tableView reloadData];
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
        }];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        [self.tableView reloadData];

        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
        }];
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;

    }else{

        return 100;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    iFKeyframeCurveTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:IFKEYFRAMECELLID];
    if (cell) {
        if (indexPath.section == 0) {
            cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row];

        }else{

            cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row][@"S1A3_NameStr"];

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)nextNewPathAction:(UIButton *)btn{
    [self clearAllUserDefaults];
    iFS1A3_TimelineViewController * timelineVC = [[iFS1A3_TimelineViewController alloc]init];
    [self.navigationController pushViewController:timelineVC animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        iFS1A3_TimelineViewController * timelineVC = [[iFS1A3_TimelineViewController alloc]init];
        [self.navigationController pushViewController:timelineVC animated:YES];

    }else{
        iFS1A3_TimelineViewController * timelineVC = [[iFS1A3_TimelineViewController alloc]init];
        timelineVC.isSaveData = YES;
        timelineVC.indexRow = indexPath.row;
        [self.navigationController pushViewController:timelineVC animated:YES];
    }
}

#pragma mark -----删除操作---------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:S1A3_ProperKeyFrameList];
    [[self.dataArray objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
    
    /*删除tableView中的一行*/
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.dataArray[1] writeToFile:plistPath atomically:YES];
    
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
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleNone;
    }else{
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)clearAllUserDefaults{
    _S1A3_Model = [[iFS1A3_Model alloc]init];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id key in dic) {
        //删除指定数组里的key在Userdefaults所对应的value
        if ([_S1A3_Model.allPropertyNames containsObject:key] == YES) {
            [userDefaults removeObjectForKey:key];
        }
    }
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
