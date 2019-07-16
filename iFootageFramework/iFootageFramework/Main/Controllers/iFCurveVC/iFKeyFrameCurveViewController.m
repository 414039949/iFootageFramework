//
//  iFKeyFrameCurveViewController.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/24.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFKeyFrameCurveViewController.h"
#import "iFKeyframeCurveTableViewCell.h"
#import "iFTimelapseViewController.h"
#import <Masonry/Masonry.h>


#import "ReceiveView.h"



#define IFKEYFRAMECELLID @"iFKeyframeCurveTableViewCell"

@interface iFKeyFrameCurveViewController ()<UITableViewDelegate, UITableViewDataSource>


@property(nonatomic, strong)UITableView * tableView;
@property(nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation iFKeyFrameCurveViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = NSLocalizedString(KeyFrame_Savedpath, nil);
    iFButton * newBtn = [[iFButton alloc]initWithFrame:CGRectMake(0, 0, 24, 24) andTitle:NSLocalizedString(KeyFrame_new, nil)];
    newBtn.backgroundColor = [UIColor clearColor];
    
    [newBtn addTarget:self action:@selector(newKeyFrame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newBtn];
    
    self.connectBtn.alpha = 0;
    
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo([NSNumber numberWithInteger:(-20 + [UIApplication sharedApplication].statusBarFrame.size.height)]);
        make.right.equalTo([NSNumber numberWithInt:-5]);
        make.width.equalTo(@96);
        make.height.equalTo(@96);
    }];
    
    
    [self createUI];
    
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.f];
    [self.view bringSubviewToFront:self.rootbackBtn];
    [self.view bringSubviewToFront:newBtn];
    
    


}

- (void)delayMethod{

    
    if ([ReceiveView sharedInstance].slideModeID == 0x02 || [ReceiveView sharedInstance].x2ModeID == 0x02) {
        iFTimelapseViewController * iftimelapseVC = [[iFTimelapseViewController alloc]init];
            iftimelapseVC.isSaveData = NO;
//            iftimelapseVC.indexRow = 0;
        [self.navigationController pushViewController:iftimelapseVC animated:NO];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArray  = [NSMutableArray new];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:ProperKeyFrameList];
    
    NSArray * array = [NSArray arrayWithContentsOfFile:plistPath];
    NSArray * array1 = @[NSLocalizedString(KeyFrame_PreviousPath, nil)];
    
    
    //
    
    [self.dataArray addObject:array1];
    if (array) {
        [self.dataArray addObject:array];
    }
    
    [self.tableView reloadData];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    NSLog(@"%@", self.tableView);
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
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(64);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
        }];
        
    }
}
/**
 创建UI 
 */
- (void)createUI{
//    [self.dataArray removeAllObjects];
//    [self.tableView removeFromSuperview];
    
    

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[iFKeyframeCurveTableViewCell class] forCellReuseIdentifier:IFKEYFRAMECELLID];
    [self.view addSubview:self.tableView];
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
            
            cell.titleLabel.text = self.dataArray[indexPath.section][indexPath.row][@"nameStr"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}
#pragma mark -----删除操作---------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];
    NSString *plistPath = [filePath stringByAppendingPathComponent:ProperKeyFrameList];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    iFTimelapseViewController * iftimelapseVC = [[iFTimelapseViewController alloc]init];
    
    if (indexPath.section == 0) {
        iftimelapseVC.isSaveData = NO;
    }else{
        iftimelapseVC.isSaveData = YES;
        iftimelapseVC.indexRow = indexPath.row;
    }
    [self.navigationController pushViewController:iftimelapseVC animated:NO];
}
- (void)newKeyFrame{
    [self clearAllUserDefaultsData];
    iFTimelapseViewController * iftimelapseVC = [[iFTimelapseViewController alloc]init];
    iftimelapseVC.isSaveData = NO;
    
    [self.navigationController pushViewController:iftimelapseVC animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///**
// *  清除所有的存储本地的数据
// */
- (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    
    for (id  key in dic) {
#warning - 避免删除矩阵模式数据 -
        if ([self getBoolWithKey:key andKeyStr:PANOCAMERAINDEX] || [self getBoolWithKey:key andKeyStr:PANOFOCALINDEX] ||[self getBoolWithKey:key andKeyStr:SLIDECOUNT] || [self getBoolWithKey:key andKeyStr:PANOASPECTINDEX]|| [self getBoolWithKey:key andKeyStr:PANOINTERVALINDEX] || [self getBoolWithKey:key andKeyStr:STARTANGLE] || [self getBoolWithKey:key andKeyStr:ENDANGLE] || [self getBoolWithKey:key andKeyStr:@"username"] || [self getBoolWithKey:key andKeyStr:LoginStauts] || [self getBoolWithKey:key andKeyStr:DISPLAYUNIT] || [self getBoolWithKey:key andKeyStr:SHOOTINGMODE]) {
            
            NSLog(@"RRRRRRRRR%@", key);
        }else{
            
            [userDefaults removeObjectForKey:key];
        }
    }
    [userDefaults synchronize];
}
- (BOOL)getBoolWithKey:(id)key andKeyStr:(NSString *)keystr{
    return [key isEqualToString:keystr];
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
