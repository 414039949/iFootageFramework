//
//  iFPanoramaViewController.m
//  iFootage
//
//  Created by 黄品源 on 2016/11/28.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFPanoramaViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "iFSquareViewController.h"
#import "iFCirleViewController.h"
#import "iFPickView.h"
#import "iFModel.h"
#import "ReceiveView.h"




@interface iFPanoramaViewController ()<getIndexDelegate>

@property (nonatomic, strong)iFModel * ifmodel;

@end

@implementation iFPanoramaViewController
{
    NSUserDefaults * ud;
    UIButton * GigapixelBtn;
    UIButton * panoramaBtn;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = NSLocalizedString(All_Stitching, nil);
    

    
    /**
     CameraSensorLabel 摄像传感器
     FocalLengthLabel 焦距
     AspectRatioLabel  纵横比
     intervalLabel 间隔时间
     @param
     */
    self.CameraSensorLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(130), iFSize(113), 200, 20) WithTitle:NSLocalizedString(Stiching_CameraSensor, nil) andFont:15];
    self.CameraSensorLabel.textColor = COLOR(168, 168, 168, 1);
    self.CameraSensorLabel.center = CGPointMake(kScreenWidth / 2, iFSize(120));
    [self.view addSubview:self.CameraSensorLabel];
    
    self.AspectRatioLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(130), iFSize(212), 200, 20) WithTitle:NSLocalizedString(Stiching_AspectRation, nil) andFont:15];
    self.AspectRatioLabel.center = CGPointMake(kScreenWidth / 2, iFSize(220));
    self.AspectRatioLabel.textColor = COLOR(168, 168, 168, 1);
    [self.view addSubview:self.AspectRatioLabel];
    
    self.FocalLengthLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(214), 200, 20) WithTitle:NSLocalizedString(Stiching_FocalLength, nil) andFont:15];
    self.FocalLengthLabel.center = CGPointMake(kScreenWidth / 2, iFSize(320));
    self.FocalLengthLabel.textColor = COLOR(168, 168, 168, 1);
    [self.view addSubview:self.FocalLengthLabel];
    
    self.intervalLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(268), 200, 20) WithTitle:NSLocalizedString(Stiching_Interval, nil) andFont:15];
    self.intervalLabel.center = CGPointMake(kScreenWidth / 2, iFSize(420));
    self.intervalLabel.textColor = COLOR(168, 168, 168, 1);
    [self.view addSubview:self.intervalLabel];
    
    
    self.CameraSensorBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(133), 175, 25) andTitle:self.CameraSensorArray[self.ifmodel.cameraIndex]];
    self.CameraSensorBtn.tag = 100;
    self.CameraSensorBtn.center = CGPointMake(kScreenWidth / 2, iFSize(162));
    [self.CameraSensorBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.CameraSensorBtn];
    
    
    self.AspectRatioBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(241) - 64, 175, 25) andTitle:self.AspectRatioArray[self.ifmodel.aspectIndex]];
    [self.AspectRatioBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    self.AspectRatioBtn.center = CGPointMake(kScreenWidth / 2, iFSize(262));

    self.AspectRatioBtn.tag = 102;
        [self.view addSubview:self.AspectRatioBtn];
    
    
    self.FocalLenthBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(187), 175, 25) andTitle:self.FocalLengthArray[self.ifmodel.focalIndex]];
    self.FocalLenthBtn.tag = 101;
    self.FocalLenthBtn.center = CGPointMake(kScreenWidth / 2, iFSize(362));
    [self.FocalLenthBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.view addSubview:self.FocalLenthBtn];
    
    self.intervalBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(295) - 64, 175, 25) andTitle:self.intervalArray[self.ifmodel.panIntervalIndex]];
    [self.intervalBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    self.intervalBtn.tag = 103;
    self.intervalBtn.center = CGPointMake(kScreenWidth / 2, iFSize(462));
    
    [self.view addSubview:self.intervalBtn];
    
    
     GigapixelBtn = [self getFatherButtonWithTitle:NSLocalizedString(Stiching_Grid, nil) andImageName:@"Gird" andRect:CGRectMake(iFSize(72), iFSize(507), 89, 89)];
    [GigapixelBtn addTarget:self action:@selector(gotoGigapixelViewController) forControlEvents:UIControlEventTouchUpInside];
    
    GigapixelBtn.center = CGPointMake(kScreenWidth * 0.3, kScreenHeight * 0.8);
    
    [self.view addSubview:GigapixelBtn];
    
     panoramaBtn = [self getFatherButtonWithTitle:NSLocalizedString(Stiching_Pano, nil) andImageName:@"pano" andRect:CGRectMake(iFSize(212), iFSize(507), 120, 89)];
    [panoramaBtn addTarget:self action:@selector(gotoPanoramaViewController1) forControlEvents:UIControlEventTouchUpInside];
    panoramaBtn.center = CGPointMake(kScreenWidth * 0.7, kScreenHeight * 0.8);
    [self.view addSubview:panoramaBtn];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.f];
    
}

- (void)delayMethod{
    if ([ReceiveView sharedInstance].X2MODE == 0x08 && [ReceiveView sharedInstance].Gimode == 0x02) {
            [self gotoGigapixelViewController];
    }else if([ReceiveView sharedInstance].X2MODE == 0x07 && [ReceiveView sharedInstance].Pamode == 0x02){
            [self gotoPanoramaViewController1];
    }
    
    
//    }
    
}
- (id)init{
    ud = [NSUserDefaults standardUserDefaults];
    [self initData];
    return self;
}
- (void)initData{
    self.ifmodel = [[iFModel alloc]init];
    self.ifmodel.cameraIndex = [[ud objectForKey:PANOCAMERAINDEX] unsignedIntValue];
    self.ifmodel.focalIndex = [[ud objectForKey:PANOFOCALINDEX] unsignedIntValue];
    self.ifmodel.aspectIndex = [[ud objectForKey:PANOASPECTINDEX] unsignedIntValue];
    self.ifmodel.panIntervalIndex = [[ud objectForKey:PANOINTERVALINDEX] unsignedIntValue];
    
    if (self.ifmodel.cameraIndex) {
    }else{
        self.ifmodel.cameraIndex = 0;
    }
    if (self.ifmodel.focalIndex) {
        
    }else{
        self.ifmodel.focalIndex = 0;
    }
    if (self.ifmodel.aspectIndex) {
        
    }else{
        self.ifmodel.aspectIndex = 0;
    }
    if (self.ifmodel.panIntervalIndex) {
        
    }else{
        self.ifmodel.panIntervalIndex = 0;

    }
    
    [self.CameraSensorArray removeAllObjects];
    [self.FocalLengthArray removeAllObjects];
    [self.AspectRatioArray removeAllObjects];
    [self.intervalArray removeAllObjects];
    
    self.CameraSensorArray = [NSMutableArray new];
    self.FocalLengthArray = [NSMutableArray new];
    self.AspectRatioArray = [NSMutableArray new];
    self.intervalArray = [NSMutableArray new];
    
    /*
     Full Frame
     18 
     3 * 2
     */
    
    self.CameraSensorArray = [NSMutableArray arrayWithArray:@[@"Full frame", @"APS-C", @"M4/3"]];
    for (int i = 0; i <= 192; i++) {
        [self.FocalLengthArray addObject:[NSString stringWithFormat:@"%dmm", i + 8]];
    }
    self.AspectRatioArray = [NSMutableArray arrayWithArray:@[@"3x2", @"16x9"]];
    for (int i = 0; i < 60; i++) {
        [self.intervalArray addObject:[NSString stringWithFormat:@"%ds", i+1]];
    }
}


- (void)showActionSheet:(iFButton *)btn{
   
    NSString * str;
    NSMutableArray * array = [NSMutableArray new];
    self.identifier = btn.tag;
    NSUInteger indexInit = 0;
    
    
    if (btn.tag == 100) {
        
        str = self.CameraSensorLabel.text;
        array = self.CameraSensorArray;
        indexInit = self.ifmodel.cameraIndex;
        
    }else if (btn.tag == 101){
        
        str = self.FocalLengthLabel.text;
        array = self.FocalLengthArray;
        indexInit = self.ifmodel.focalIndex;
        
    }else if (btn.tag == 102){
        
        str = self.AspectRatioLabel.text;
        array = self.AspectRatioArray;
        indexInit = self.ifmodel.aspectIndex;
        
    }else if (btn.tag == 103){
        
        str = self.intervalLabel.text;
        array = self.intervalArray;
        indexInit = self.ifmodel.panIntervalIndex;
    }else{
    
    }
    
    iFPickView *Picker = [[iFPickView alloc] initWithFrame:CGRectZero andArray:array];
    
    [Picker setInitValue:indexInit];
    
    self.index = indexInit;
    Picker.getDelegate = self;
    
    if (kDevice_Is_iPad) {
        Picker.center = CGPointMake(btn.frame.size.width * 1.5 , 80);
        
    }else{
        Picker.center = CGPointMake(AutoKscreenWidth / 2 - 10, 80);
        
    }
    UIAlertController * alertActionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n",str] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertActionSheet.view addSubview:Picker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        [btn setTitle:array[self.index] forState:UIControlStateNormal];
        
    }];
    [alertActionSheet addAction:ok];
    UIPopoverPresentationController *popover =alertActionSheet.popoverPresentationController;
    
    popover.sourceView = btn;
    popover.sourceRect = btn.bounds;
    popover.permittedArrowDirections=UIPopoverArrowDirectionAny;
    [self presentViewController:alertActionSheet animated:YES completion:^{ }];
}
#warning mark - 逻辑有时间再改-
- (void)getIndex:(NSUInteger)idex{
    
    if (self.identifier == 100) {
        self.ifmodel.cameraIndex = idex;
        [ud setObject:[NSNumber numberWithUnsignedInteger:idex] forKey:PANOCAMERAINDEX];
        
    }else if (self.identifier == 101){
        self.ifmodel.focalIndex = idex;
        [ud setObject:[NSNumber numberWithUnsignedInteger:idex] forKey:PANOFOCALINDEX];

        
    }else if (self.identifier == 102){
        self.ifmodel.aspectIndex = idex;
        [ud setObject:[NSNumber numberWithUnsignedInteger:idex] forKey:PANOASPECTINDEX];

        
    }else if (self.identifier == 103){
        self.ifmodel.panIntervalIndex = idex;
        [ud setObject:[NSNumber numberWithUnsignedInteger:idex] forKey:PANOINTERVALINDEX];
    }
    self.index = idex;
}


- (void)gotoGigapixelViewController{
    
    iFSquareViewController * ifsquereVC = [[iFSquareViewController alloc]init];
    CGFloat height = 0 , width = 0, focalLength = 0;
    
    focalLength = [self.FocalLengthArray[self.ifmodel.focalIndex] floatValue];
    if (self.ifmodel.cameraIndex == 0) {
        height = 24.00f; width = 36.00f;
    }else if (self.ifmodel.cameraIndex == 1){
        height = 15.80f; width = 23.60f;
    }else if (self.ifmodel.cameraIndex == 2){
        height = 13.00f; width = 17.30f;
    }else{
    
    }
    NSLog(@"height = %f, width = %f, focalLength = %f", height, width, focalLength);
    
    ifsquereVC.TiltAngle = atan(height / 2.00f / focalLength) * 2 * 0.7 * 180.00f / M_PI;
    ifsquereVC.PanAngle = atan(width / 2.00f / focalLength) * 2 * 0.7 * 180.00f / M_PI;
    
    ifsquereVC.interval = self.intervalArray[self.ifmodel.panIntervalIndex];
    
    CGFloat maxAngle = ifsquereVC.TiltAngle > ifsquereVC.PanAngle ? ifsquereVC.TiltAngle : ifsquereVC.PanAngle;

    NSInteger maxInterval = [self.intervalArray[self.ifmodel.panIntervalIndex] integerValue] > [self countThelowestTimeWithAngle:maxAngle] ? [self.intervalArray[self.ifmodel.panIntervalIndex] integerValue] : [self countThelowestTimeWithAngle:maxAngle];
    ifsquereVC.interval = [NSString stringWithFormat:@"%lds", maxInterval];
    
    [self.navigationController pushViewController:ifsquereVC animated:YES];
    
}
- (NSInteger)countThelowestTimeWithAngle:(CGFloat)angle{
    CGFloat minTime;
    if (angle >= 30.0f) {
        minTime = 3.0f + (angle - 30.0f) / 30.0f;
    }else{
        minTime = 2.0f * sqrtf(angle / 30.0f + 1);
    }
    
    return ceil(minTime) + 1;
    
}

- (void)gotoPanoramaViewController1{
    iFCirleViewController * ifCirleVC = [[iFCirleViewController alloc]init];
    CGFloat height = 0.0, width = 0.0, focalLength = 0.0;
    focalLength = [self.FocalLengthArray[self.ifmodel.focalIndex] floatValue];
    if (self.ifmodel.cameraIndex == 0) {
        height = 24.00f; width = 36.00f;
    }else if (self.ifmodel.cameraIndex == 1){
        height = 15.80f; width = 23.60f;
    }else if (self.ifmodel.cameraIndex == 2){
        height = 13.00f; width = 17.30f;
    }
    NSLog(@"height = %f, width = %f, focalLength = %f", height, width, focalLength);
    ifCirleVC.aOneAngle = atan(width / 2.00f / focalLength) * 2 * 0.7 * 180.00f / M_PI;
    [self countThelowestTimeWithAngle:ifCirleVC.aOneAngle];
    
    NSInteger maxInterval = [self.intervalArray[self.ifmodel.panIntervalIndex] integerValue] > [self countThelowestTimeWithAngle:ifCirleVC.aOneAngle] ? [self.intervalArray[self.ifmodel.panIntervalIndex] integerValue] : [self countThelowestTimeWithAngle:ifCirleVC.aOneAngle];
    ifCirleVC.interval = [NSString stringWithFormat:@"%lds", maxInterval];
    [self.navigationController pushViewController:ifCirleVC animated:YES];
}
- (UIButton *)getFatherButtonWithTitle:(NSString *)title andImageName:(NSString *)imageName andRect:(CGRect)rect{
    
    UIButton * btn = [[UIButton alloc]initWithFrame:rect];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:iFSize(20)];
    [self.view addSubview:btn];
    return btn;
}

//竖屏
- (void)VerticalscreenUI{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    CGFloat width = AutoKscreenWidth * 0.3;
    [self.CameraSensorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(120);
        make.centerX.equalTo(self.view);
    }];
    [self.CameraSensorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.CameraSensorLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.AspectRatioLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.centerX.equalTo(self.view);
    }];
    [self.AspectRatioBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.AspectRatioLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    [self.FocalLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(320);
        make.centerX.equalTo(self.view);
    }];
    [self.FocalLenthBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.FocalLengthLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(420);
        make.centerX.equalTo(self.view);
    }];
    [self.intervalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intervalLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [GigapixelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.bottom.mas_equalTo(-50);
        make.size.mas_equalTo(width);
    }];
    [panoramaBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(GigapixelBtn);
        make.size.mas_equalTo(width);
    }];
    
    
}
//横屏
- (void)LandscapescreenUI{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    CGFloat width = AutoKscreenWidth * 0.3;
    
    [self.CameraSensorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(80);
    }];
    [self.CameraSensorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.CameraSensorLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.CameraSensorLabel.mas_centerX);
    }];
    [self.AspectRatioLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(300);
        make.centerY.equalTo(self.CameraSensorLabel);
    }];
    [self.AspectRatioBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.AspectRatioLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.AspectRatioLabel.mas_centerX);
    }];
    
    [self.FocalLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(220);
    }];
    [self.FocalLenthBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.FocalLengthLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.FocalLengthLabel.mas_centerX);
    }];
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(300);
        make.centerY.equalTo(self.FocalLengthLabel);
    }];
    [self.intervalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intervalLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.intervalLabel.mas_centerX);
    }];
    
    [GigapixelBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(self.AspectRatioBtn.mas_centerY).offset(-10);
        make.size.mas_equalTo(width);
    }];
    [panoramaBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(self.intervalBtn.mas_centerY).offset(-10);
        make.size.mas_equalTo(width);
    }];
    
    
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [self VerticalscreenUI];
    }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
        //翻转为横屏时
        if (kDevice_Is_iPad) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO];

            [self VerticalscreenUI];
            
        }else{
            [[UIApplication sharedApplication] setStatusBarHidden:YES];

        [self LandscapescreenUI];
        }
        
    }
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
