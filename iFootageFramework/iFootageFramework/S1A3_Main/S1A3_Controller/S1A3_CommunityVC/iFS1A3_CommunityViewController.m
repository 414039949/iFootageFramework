//
//  iFS1A3_CommunityViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_CommunityViewController.h"
#import "ReceiveView.h"

@interface iFS1A3_CommunityViewController ()

@end

@implementation iFS1A3_CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"Community";
//    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(lalalala) userInfo:nil repeats:YES];
//    timer.fireDate = [NSDate distantPast];
    
    
}
- (void)lalalala{
    NSLog(@"%d", [ReceiveView sharedInstance].S1A3_S1_Version);
    NSLog(@"%d", [ReceiveView sharedInstance].S1A3_S1_BatteryNum);
    
}
//- (void)viewWillLayoutSubviews{
//    [self.tableView reloadData];
//
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(64);
//        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height));
//    }];

//}

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
