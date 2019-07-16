//
//  iFCommuityViewController.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFCommuityViewController.h"
#import "iFLabel.h"
#import "iFButton.h"
#import "ReceiveView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "iFProcessView.h"
#import "LuaContext.h"
#import "iFNavgationController.h"
#import "AppDelegate.h"
#import "SendDataView.h"
#import "iFSend_Moudle.h"
#define Point(x, y) [NSValue valueWithCGPoint:CGPointMake(x, y)]


@interface iFCommuityViewController ()
@property (nonatomic,strong) MPMoviePlayerViewController *moviePlayerViewController;

@end

@implementation iFCommuityViewController
{
    int a;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = NSLocalizedString(All_Community, nil);
    iFLabel * label = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, iFSize(50)) WithTitle:NSLocalizedString(@"toBeContinued", nil) andFont:iFSize(30)];
    label.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.3);
    
    [self.view addSubview:label];
    NSArray * imageNameStr = @[@"google", @"youtube", @"facebook", @"twitter"];
    
    for (int i = 0 ; i < 4; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(iFSize(117) + iFSize(36.5) * i, iFSize(274), iFSize(32.5), iFSize(32.5))];
        imageView.image = [UIImage imageNamed:imageNameStr[i]];
        [self.view addSubview:imageView];
    }
//    [[LuaContext currentContext] loadScript:@"SharkMini.lua"];
    [[LuaContext currentContext] loadScript:@"hpy.lua"];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    [btn addTarget:self action:@selector(btnaction) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
//    [self.view addSubview:btn];
}

- (void)btnaction{
//    NSLog(@"%@", [[LuaContext currentContext] createArray:@"GetArray" args:@[@[Point(123, 123),Point(11, 111)], @[@"21", @"121"]]]);
    a++;
    
    for (int i = 0; i < 1000; i++) {
        NSLog(@"i = %d", i);
//            [[iFSend_Moudle sharedInstance] sendS1_0x01_Veloc:1 andIsBackZero:2];

        [[iFSend_Moudle sharedInstance] sendX2_0x01_PanVeloc:i TiltVeloc:i islockPan:0 islockTilt:0 isbackZero:0];
    }
    
//    [[iFSend_Moudle sharedInstance] sendS1_0x00_TimeStamp:1 andVersion:2 andisUpdate:3 andVersionBytes:4 andSliderCount:5 andisViolence:6];
//    [[iFSend_Moudle sharedInstance] sendS1_0x02_Mode:1 andTimestamp:2 andisloop:3];
//    [[iFSend_Moudle sharedInstance] sendS1_0x03_Interval:1 Expo:2 Frames:3 Mode:4 Numbezier:5 buffer:6];
//    [[iFSend_Moudle sharedInstance] sendS1_0X04_Time:1 NumBezier:2];
//    [[iFSend_Moudle sharedInstance] sendS1_0x05_Mode:1 timeStamp:2 Frame_Need:3 OnceTime:4];
//    [[iFSend_Moudle sharedInstance] sendS1_0x06_Mode:1 sliderPos:2];
//    [[iFSend_Moudle sharedInstance] sendS1_0X09_Mode:1 slideVeloc:2 SliderPos_A:3 SliderPos_B:4 TotalTime:5];
//    [[iFSend_Moudle sharedInstance] sendS1_0x0A_Mode:1 direction:2 isloop:3 totaltime:4 smoothness:5 timestamp:6];
//    [[iFSend_Moudle sharedInstance] sendS1_0x0B_TimeStamp:1];
}
- (NSString *)stringToHex:(NSString *)string
{
    
    NSString * hexStr = [NSString stringWithFormat:@"%@",
                         [NSData dataWithBytes:[string cStringUsingEncoding:NSUTF8StringEncoding]
                                        length:strlen([string cStringUsingEncoding:NSUTF8StringEncoding])]];
    
    for(NSString * toRemove in [NSArray arrayWithObjects:@"<", @">", nil])
        hexStr = [hexStr stringByReplacingOccurrencesOfString:toRemove withString:@""];
    return hexStr;
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
