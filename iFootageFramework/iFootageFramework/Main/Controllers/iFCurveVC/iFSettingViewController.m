//
//  iFSettingViewController.m
//  iFootage
//
//  Created by 黄品源 on 16/8/6.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFSettingViewController.h"
#import "iFNumberPickerView.h"
#import "iFDatePickerView.h"
#import "iFNavgationController.h"
#import "AppDelegate.h"


#define  RotaSizeWidth kScreenWidth
#define  RotaSizeHeight kScreenHeight
#define iFRotaHeight(x) x / 375.0f * RotaSizeHeight
#define CGRect(a, b, c, d) CGRectMake(iFRotaWidth(a), iFRotaHeight(b), iFRotaWidth(c), iFRotaHeight(d))



@interface iFSettingViewController ()
{
    NSUserDefaults * userDefaults;
    
    UIView * backView;
    iFNumberPickerView * iFnumberView;
    iFDatePickerView * iFDateView;
    
}
@end

@implementation iFSettingViewController
@synthesize ShootingModeLabel;
@synthesize DisplayUnitLabel;
@synthesize FrameRateLabel;
@synthesize TotalFramesORTotalTimesLabel;
@synthesize ExposureLabel;
@synthesize IntervalLabel;
@synthesize ActualIntervalLabel;
@synthesize FinalOutPutLabel;
@synthesize SaveBtn;
@synthesize cancelBtn;
@synthesize shootingModelBtn;
@synthesize displayUnitBtn;
@synthesize frameRateBtn;
@synthesize TotalFramesBtnORTotalTimesBtn;
@synthesize ExposureBtn;
@synthesize IntervalBtn;
@synthesize ActualIntervalValueLabel;

@synthesize FilmingTimeLabel;
@synthesize FinalOutputValueLabel;
@synthesize FilmingTimeValueLabel;

@synthesize setModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTitle];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self forceOrientationLandscape];
    
    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //    navi.preferredInterfaceOrientationForPresentation;
    
    navi.interfaceOrientation =   UIInterfaceOrientationLandscapeRight;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    
    self.navigationController.navigationBarHidden = YES;

    
    setModel = [[iFTPSettingModel alloc]init];
    [self recordDataWithModel];
    [self readDataWithModel];
    [self createUI];
}

- (void)recordDataWithModel{
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSNumber numberWithInteger:shootingModelBtn.index] forKey:SHOOTINGMODE];
    [userDefaults setObject:[NSNumber numberWithInteger:displayUnitBtn.index] forKey:DISPLAYUNIT];
    [userDefaults setObject:[NSNumber numberWithInteger:frameRateBtn.index] forKey:FRAMERATE];
    [userDefaults setObject:TotalFramesBtnORTotalTimesBtn.titleLabel.text forKey:TOTALFRAMES];
    [userDefaults setObject:setModel.Exposure forKey:EXPOSURE];
    [userDefaults setObject:setModel.Interval forKey:INTERVAL];
    [userDefaults setObject:setModel.ActualInterval forKey:ACTUALINTERVAL];
    
    
    
    
}
- (void)readDataWithModel{
    
    if (!setModel.ShootingMode) {
        setModel.ShootingMode = 0;
    }else{
        setModel.ShootingMode = [[userDefaults objectForKey:SHOOTINGMODE] integerValue];
    }
    
    if (!setModel.DisplayUnit) {
        setModel.DisplayUnit = 0;
    }else{
        setModel.DisplayUnit = [[userDefaults objectForKey:DISPLAYUNIT] integerValue];
    }
    
    if (!setModel.FramRate) {
        setModel.FramRate = 0;
    }else{
        setModel.FramRate = [[userDefaults objectForKey:FRAMERATE] integerValue];
    }
    if (!setModel.TotalFrames) {
        setModel.TotalFrames = @"00000";
    }else{
        setModel.TotalFrames = [userDefaults objectForKey:TOTALFRAMES];
    }
    if (!setModel.TotalTimes) {
        setModel.TotalTimes = @"0000:00:00";
    }else{
        setModel.TotalTimes = [userDefaults objectForKey:TOTALTIMES];
    }
    
    if (!setModel.Exposure) {
        setModel.Exposure = @"00000";
    }else{
        setModel.Exposure = [userDefaults objectForKey:EXPOSURE];
    }
    
    if (!setModel.Interval) {
        setModel.Interval = @"00000";
    }else{
        setModel.Interval = [userDefaults objectForKey:INTERVAL];
    }
    
    if (!setModel.ActualInterval) {
        setModel.ActualInterval = @"00000";
    }else{
        setModel.ActualInterval = [userDefaults objectForKey:ACTUALINTERVAL];
    }
    
    if (!setModel.Filmingtime) {
        setModel.Filmingtime = @"00:00:00";
    }else{
        setModel.Filmingtime = [userDefaults objectForKey:FILMINGTIME];
    }
    if (!setModel.Finaloutput) {
        setModel.Finaloutput = @"00:00:00";
        setModel.Finaloutput = [userDefaults objectForKey:FINALOUTPUT];
        
    }
    
    
    NSLog(@"%@, %@, %@ ,%@", [userDefaults objectForKey:SHOOTINGMODE],
                             [userDefaults objectForKey:DISPLAYUNIT],
                             [userDefaults objectForKey:FRAMERATE],
                             [userDefaults objectForKey:TOTALFRAMES]);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createUI{
    NSLog(@"%@", setModel.TotalFrames);
    
    CGFloat font = iFRotaHeight(24);
    
    ShootingModeLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 73, 178.5, 24) WithTitle:@"Shooting Mode" andFont:font] ;
    [self.view addSubview:ShootingModeLabel];
    DisplayUnitLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 99, 178.5, 24) WithTitle:@"Display unit" andFont:font];
    [self.view addSubview:DisplayUnitLabel];
    FrameRateLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 125, 178.5, 24) WithTitle:@"Frame rate" andFont:font];
    [self.view addSubview:FrameRateLabel];
    
    TotalFramesORTotalTimesLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 151, 178.5, 24) WithTitle:@"Total frames" andFont:font];
    [self.view addSubview:TotalFramesORTotalTimesLabel];
    
    ExposureLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 179, 178.5, 24) WithTitle:@"Exposure" andFont:font];
    [self.view addSubview:ExposureLabel];
    
    IntervalLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 205, 178.5, 24) WithTitle:@"Interval" andFont:font];
    [self.view addSubview:IntervalLabel];
    
    ActualIntervalLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 231, 178.5, 24) WithTitle:@"Actual Interval" andFont:font];
    [self.view addSubview:ActualIntervalLabel];
    
    FilmingTimeLabel = [[iFLabel alloc]initWithFrame:CGRect(20,258,178.5,24) WithTitle:@"Filming time" andFont:font];
    [self.view addSubview:FilmingTimeLabel];
    
    FinalOutPutLabel = [[iFLabel alloc]initWithFrame:CGRect(20, 284, 178.5, 24) WithTitle:@"Final Output" andFont:font];
    [self.view addSubview:FinalOutPutLabel];
    
    cancelBtn = [[iFButton alloc]initWithFrame:CGRect(462.5, 329.5, 90, 24) andTitle:@"Cancel"];
    [cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelBtn];
    
    SaveBtn = [[iFButton alloc]initWithFrame:CGRect(571.5, 329.5, 55, 24) andTitle:@"Save"];
    [SaveBtn addTarget:self action:@selector(saveTheData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:SaveBtn];
    
    shootingModelBtn = [[iFCustomView alloc]initWithFrame:CGRect(252, 77, 300, 24) firstTitleBtn:@"SMS" SecondTitleBtn:@"Continuous"];
    shootingModelBtn.delegate = self;
    [self.view addSubview:shootingModelBtn];
    
    displayUnitBtn = [[iFCustomView alloc]initWithFrame:CGRect(252, 103, 300, 24) firstTitleBtn:@"Frame" SecondTitleBtn:@"Time" ];
    displayUnitBtn.delegate = self;
    [self.view addSubview:displayUnitBtn];
    
    frameRateBtn = [[iFCustomView alloc]initWithFrame:CGRect(252, 129, 300, 24) firstTitleBtn:@"24" SecondTitleBtn:@"25" ThirdTitleBtn:@"30"];
    frameRateBtn.delegate = self;
    [self.view addSubview:frameRateBtn];
    NSLog(@"%d, %d, %d", frameRateBtn.firstBtn.selected, frameRateBtn.secondBtn.selected, frameRateBtn.thirdBtn.selected);
    TotalFramesBtnORTotalTimesBtn = [[iFButton alloc]initWithFrame:CGRect(252, 155, 120, 24) andTitle:setModel.TotalFrames];
    TotalFramesBtnORTotalTimesBtn.tag = 100;
    
    [TotalFramesBtnORTotalTimesBtn addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:TotalFramesBtnORTotalTimesBtn];
    
    ExposureBtn = [[iFButton alloc]initWithFrame:CGRect(252, 183, 100, 24) andTitle:[NSString stringWithFormat:@"%@s", setModel.Exposure]];
    ExposureBtn.tag = 101;
    
    [ExposureBtn addTarget:self action:@selector(showNumberView:) forControlEvents:UIControlEventTouchUpInside];
    ExposureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:ExposureBtn];
    
    IntervalBtn = [[iFButton alloc]initWithFrame:CGRect(252, 209, 100, 24) andTitle:[NSString stringWithFormat:@"%@s", setModel.Interval]];
    IntervalBtn.tag = 102;
    
    [IntervalBtn addTarget:self action:@selector(showNumberView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:IntervalBtn];
    
    ActualIntervalValueLabel = [[iFLabel alloc]initWithFrame:CGRect(262, 235, 100, 24) WithTitle:[NSString stringWithFormat:@"%@s", setModel.ActualInterval] andFont:18];
    ActualIntervalValueLabel.textAlignment = NSTextAlignmentNatural;
    [self.view addSubview:ActualIntervalValueLabel];
    

    
    FilmingTimeValueLabel = [[iFLabel alloc]initWithFrame:CGRect(262, 262, 300, 20) WithTitle:@"00:00:00" andFont:18];
    FilmingTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:FilmingTimeValueLabel];
    
    
    FinalOutputValueLabel = [[iFLabel alloc]initWithFrame:CGRect(262, 288, 300, 20) WithTitle:@"00:00:00.0" andFont:18];
    FinalOutputValueLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:FinalOutputValueLabel];
    
    
}


- (void)getIndexWithView:(NSInteger)index{
    
    if (displayUnitBtn.index == 0) {
        TotalFramesORTotalTimesLabel.text = @"Total frames";
        [TotalFramesBtnORTotalTimesBtn setTitle:setModel.TotalFrames forState:UIControlStateNormal];
    }
    else if(displayUnitBtn.index == 1){
        TotalFramesORTotalTimesLabel.text = @"Total times";
        [TotalFramesBtnORTotalTimesBtn setTitle:setModel.TotalTimes forState:UIControlStateNormal];
        
    }
//    iFButton * btn = (iFButton *)[self.view viewWithTag:200];

//    [self closeThebackView:btn];
    
}

- (void)showNumberView:(iFButton* )btn{
    
    backView = [[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor = COLOR(0, 0, 0, 0.5);
    iFnumberView = [[iFNumberPickerView alloc]initWithFrame:CGRect(0, 0, 300, 200)];
    iFnumberView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    iFnumberView.backgroundColor = [UIColor grayColor];
    iFnumberView.SureBtn.tag = btn.tag + 100;
    NSLog(@"%ld", (long)iFnumberView.SureBtn.tag);
    [iFnumberView.SureBtn addTarget:self action:@selector(closeThebackView:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:iFnumberView];
    [self.view addSubview:backView];
}
- (void)showDateView{
    backView = [[UIView alloc]initWithFrame:self.view.frame];
    backView.backgroundColor = COLOR(0, 0, 0, 0.5);
    iFDateView = [[iFDatePickerView alloc]initWithFrame:CGRect(0, 0, 300, 200)];
    iFDateView.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    iFDateView.backgroundColor = [UIColor grayColor];
    [iFDateView.SureBtn addTarget:self action:@selector(closeThebackView:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:iFDateView];
    [self.view addSubview:backView];
}
- (void)startAnimation:(iFButton *)btn{
    
    
    if (displayUnitBtn.index == 0) {
        [self showNumberView:btn];
    }else if(displayUnitBtn.index == 1) {
        [self showDateView];
    }
}
#warning - 传输到piker的值还没有解决-

#pragma mark 获取传输到picker的值
- (NSArray *)getTransforValueWithNumber:(NSInteger)Number{
    
    NSMutableArray * array = [NSMutableArray new];
    NSInteger sum = Number;
    NSInteger   a = sum / 10000;
    NSInteger   b = sum / 1000 % 10;
    NSInteger   c = sum / 100 % 10;
    NSInteger   d = sum / 10 % 10;
    NSInteger   e = sum / 1 % 10;
    [array addObject:[NSNumber numberWithInteger:a]];
    [array addObject:[NSNumber numberWithInteger:b]];
    [array addObject:[NSNumber numberWithInteger:c]];
    [array addObject:[NSNumber numberWithInteger:d]];
    [array addObject:[NSNumber numberWithInteger:e]];
    return array;
}
/**
 *  关闭选择器的时候
 *
 *  @param btn
 */
- (void)closeThebackView:(iFButton *)btn{
    
    
    if (btn.tag == 200) {
        if (displayUnitBtn.index == 0) {
            setModel.TotalFrames = [NSString stringWithFormat:@"%.5ld",(long)[iFnumberView getInteger]];
            [TotalFramesBtnORTotalTimesBtn setTitle:[NSString stringWithFormat:@"%.5ld",(long)[iFnumberView getInteger]] forState:UIControlStateNormal];
        }else{
          
        }
    }else if (btn.tag == 201){
        
        setModel.Exposure = [NSString stringWithFormat:@"%.5lds", (long)[iFnumberView getInteger]];
        [ExposureBtn setTitle:setModel.Exposure forState:UIControlStateNormal];
    }else if (btn.tag == 202){
       
        setModel.Interval = [NSString stringWithFormat:@"%.5lds", (long)[iFnumberView getInteger]];
        [IntervalBtn setTitle:setModel.Interval forState:UIControlStateNormal];
    }else{
        setModel.TotalTimes = [iFDateView getDateString];
        [TotalFramesBtnORTotalTimesBtn setTitle:setModel.TotalTimes forState:UIControlStateNormal];
        NSLog(@"%@", setModel.TotalTimes);
    }
    
    
    
    /**
     *  计算ActualInerval AND  filming time
     */
    NSInteger a = [setModel.Exposure integerValue];
    NSInteger b = [setModel.Interval integerValue];
    long long seconds = a + b;
    NSInteger frame = [setModel.TotalFrames integerValue];
    setModel.ActualInterval = [NSString stringWithFormat:@"%.5lds", a + b + 1];
    
    NSLog(@"%@", setModel.ActualInterval);
    
    ActualIntervalValueLabel.text = setModel.ActualInterval;
    if (displayUnitBtn.index == 0) {
        FilmingTimeValueLabel.text = [self getDateString:seconds * frame];
        
        
    }else{
        FilmingTimeValueLabel.text = [self getDateString:seconds * frame];
        
    }
    /**
     *  计算Finaltime
     */
    NSString * finalStr = [self getFinalTimeWithFrames:[setModel.TotalFrames integerValue] andFrameRateIndex:frameRateBtn.index];
    NSLog(@"%@", finalStr);
    FinalOutputValueLabel.text = [self getFinalTimeWithFrames:[setModel.TotalFrames integerValue] andFrameRateIndex:frameRateBtn.index];
    [backView removeFromSuperview];
}
/**
 *  获取时间戳（时分秒）
 *
 *  @return string
 */
- (NSString *)getDateString:(long long)seconds{
    
    NSString *str_hour = [NSString stringWithFormat:@"%02lld",(seconds)/3600];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02lld",(seconds%3600)/60];
    
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02lld",seconds%60];
    
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

- (NSString *)getFinalTimeWithFrames:(NSInteger)frames andFrameRateIndex:(NSInteger)index{
    NSString *format_time ;
    NSInteger framerate = [self getFrameRateWithIndex:index];
    NSInteger seconds, sum;
    seconds = frames / framerate;
    sum = frames % framerate;
    NSLog(@"%ld, %ld", (long)seconds, (long)sum);
    format_time = [NSString stringWithFormat:@"%@.%ld", [self getDateString:seconds], (long)sum];
    return format_time;
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%04d:%02d:%02d",hours, minutes, seconds];
}
/**
 *  <#Description#>
 *
 *  @return 
 NSInteger totalf, extime, intime, actime;
 totalf = 300;
 extime = 1;
 intime = 4;
 actime = 6;
 


 *  回调字典
 */
//NSMutableDictionary * dict = [NSMutableDictionary new];
//[dict setObject:[NSNumber numberWithInteger:shootingModelBtn.index ]forKey:SHOOTINGMODE];
//[dict setObject:[NSNumber numberWithInteger:totalf] forKey:TOTALFRAMES];
//[dict setObject:[NSNumber numberWithInteger:extime] forKey:EXPOSURE];
//[dict setObject:[NSNumber numberWithInteger:intime] forKey:INTERVAL];
//[dict setObject:[NSNumber numberWithInteger:actime] forKey:ACTUALINTERVAL];
//[dict setObject:[NSNumber numberWithInteger:[self getFrameRateWithIndex:frameRateBtn.index]] forKey:FRAMERATE];
//
//**/

#warning 测试!!!
- (void)saveTheData{
    [self recordDataWithModel];
    [self readDataWithModel];
    
    
//    NSLog(@" 22= %ld", shootingModelBtn.index);
//    NSLog(@" 33= %ld", displayUnitBtn.index);
//    NSLog(@" 44= %ld", frameRateBtn.index);
//    
//    NSLog(@"framerate = %ld", setModel.FramRate);
//    NSLog(@"frames = %@", setModel.TotalFrames);
//    NSLog(@"exposur = %ld", [setModel.Exposure integerValue]);
//    NSLog(@"inter = %@", setModel.Interval);
//    NSLog(@"ac = %@", setModel.ActualInterval);
//    NSLog(@"mode =%ld", setModel.ShootingMode);
    
    
//    
//    NSInteger totalf, extime, intime, actime;
//    totalf = 300;
//    extime = 1;
//    intime = 4;
//    actime = 6;
//    
    
    /*
    *  回调字典
    */
    NSMutableDictionary * dict = [NSMutableDictionary new];
    [dict setObject:[NSNumber numberWithInteger:shootingModelBtn.index ]forKey:SHOOTINGMODE];
    [dict setObject:[NSNumber numberWithInteger:[setModel.TotalFrames integerValue]] forKey:TOTALFRAMES];
    [dict setObject:[NSNumber numberWithInteger:[setModel.Exposure integerValue]] forKey:EXPOSURE];
    [dict setObject:[NSNumber numberWithInteger:[setModel.Interval integerValue]] forKey:INTERVAL];
    [dict setObject:[NSNumber numberWithInteger:[setModel.ActualInterval integerValue]] forKey:ACTUALINTERVAL];
    [dict setObject:[NSNumber numberWithInteger:[self getFrameRateWithIndex:frameRateBtn.index]] forKey:FRAMERATE];
    
    NSLog(@"dict = %@", dict);
    
    [_delegate getTimelapseSettingData:dict];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (NSInteger)getFrameRateWithIndex:(NSInteger)index{
    NSInteger frameRate;
    if (index == 0) {
        frameRate = 24;
    }else if(index == 1){
        frameRate = 25;
    }else{
        frameRate = 30;
    }
    return frameRate;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    
}
-  (void)createTitle{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text = @"Timelapse Settings";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.center = CGPointMake(kScreenWidth / 2, 40);
    [self.view addSubview:titleLabel];

}

/**
 *  获取时间戳
 *
 *  @param seconds 传入的时间单位s
 *
 *  @return 返回时间戳
 */
-(NSString *)timeformatFromSeconds:(long long)seconds{
    
    //format of day
    NSString *str_day = [NSString stringWithFormat:@"%02lld",seconds/(86400)];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%0lld",(seconds%86400)/3600];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02lld",(seconds%3600)/60];
    
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02lld",seconds%60];
    
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@天%@小时%@分%@秒",str_day,str_hour,str_minute,str_second];
    return format_time;
}
//- (void)viewWillDisappear:(BOOL)animated{
//    //强制旋转竖屏
//    [self forceOrientationPortrait];
//    iFNavgationController *navi = (iFNavgationController *)self.navigationController;
//    
//    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
//    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
//    
//    //设置屏幕的转向为竖屏
//    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
//    //刷新
//    [UIViewController attemptRotationToDeviceOrientation];
//    self.navigationController.navigationBarHidden = NO;
//    
//    
//}
//

#pragma mark -----横竖屏切换 ------------
#pragma  mark 横屏设置
//强制横屏
- (void)forceOrientationLandscape
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


//#pragma mark - 在你需要横屏的controller中重写下面三个方法
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
