//
//  iFS1A3_StitchingViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_StitchingViewController.h"
#import "iFS1A3_GridViewController.h"
#import "iFS1A3_PanoViewController.h"
#import "iFS1A3_Model.h"
#import "AppDelegate.h"
#import "iFPickView.h"
#import "iFStatusBarView.h"
#import "ReceiveView.h"
#import "UIButton+ImageTitleSpacing.h"

#import <Masonry/Masonry.h>

@interface iFS1A3_StitchingViewController ()<getIndexDelegate>

@property (nonatomic, strong)UIButton * GridBtn;
@property (nonatomic, strong)UIButton * PanoBtn;
@property (nonatomic, strong)iFLabel * CameraSensorLabel;
@property (nonatomic, strong)iFLabel * AspectRationLabel;
@property (nonatomic, strong)iFLabel * FocalLengthLabel;
@property (nonatomic, strong)iFLabel * IntervalLabel;
@property (nonatomic, strong)iFButton * CameraSensorBtn;
@property (nonatomic, strong)iFButton * AspectRationBtn;
@property (nonatomic, strong)iFButton * FocalLengthBtn;
@property (nonatomic, strong)iFButton * IntervalBtn;
@property (nonatomic, strong)NSMutableArray * CameraSensorArray;
@property (nonatomic, strong)NSMutableArray * FocalLengthArray;
@property (nonatomic, strong)NSMutableArray * AspectRatioArray;
@property (nonatomic, strong)NSMutableArray * intervalArray;
@property (nonatomic, assign)NSInteger identifier;
@property (nonatomic, assign)NSInteger index;




@end

@implementation iFS1A3_StitchingViewController
{
    UIButton * _GridBtn;
    UIButton * _PanoBtn;
    iFS1A3_Model * S1A3_Model;
}
- (id)init{
    S1A3_Model = [iFS1A3_Model new];
    self.CameraSensorArray = [NSMutableArray new];
    self.FocalLengthArray = [NSMutableArray new];
    self.AspectRatioArray = [NSMutableArray new];
    self.intervalArray = [NSMutableArray new];
    self.CameraSensorArray = [NSMutableArray arrayWithArray:@[@"Full frame", @"APS-C", @"M4/3"]];
    for (int i = 0; i <= 192; i++) {
        [self.FocalLengthArray addObject:[NSString stringWithFormat:@"%dmm", i + 8]];
    }
    self.AspectRatioArray = [NSMutableArray arrayWithArray:@[@"3x2", @"16x9"]];
    for (int i = 0; i < 60; i++) {
        [self.intervalArray addObject:[NSString stringWithFormat:@"%ds", i+1]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"Stitching";
//    self.statusView
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
    [self createUI];
    
}
- (void)createUI{
    self.CameraSensorLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(20)) WithTitle:NSLocalizedString(Stiching_CameraSensor, nil) andFont:iFSize(15)];
    self.CameraSensorLabel.textColor = COLOR(168, 168, 168, 1);
    self.CameraSensorLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.CameraSensorLabel];
    
    self.AspectRationLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(20)) WithTitle:NSLocalizedString(Stiching_AspectRation, nil) andFont:iFSize(15)];
    self.AspectRationLabel.textColor = COLOR(168, 168, 168, 1);
    self.AspectRationLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.AspectRationLabel];
    
    self.FocalLengthLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(20)) WithTitle:NSLocalizedString(Stiching_FocalLength, nil) andFont:iFSize(15)];
    self.FocalLengthLabel.textColor = COLOR(168, 168, 168, 1);
    self.FocalLengthLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.FocalLengthLabel];
    
    
    self.IntervalLabel = [[iFLabel alloc]initWithFrame:CGRectMake(0, 0, iFSize(200), iFSize(20)) WithTitle:NSLocalizedString(Stiching_Interval, nil) andFont:iFSize(15)];
    self.IntervalLabel.textColor = COLOR(168, 168, 168, 1);
    self.IntervalLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.IntervalLabel];
    
    self.CameraSensorBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(133), iFSize(175), iFSize(25)) andTitle:self.CameraSensorArray[S1A3_Model.S1A3_CameraIndex]];
    self.CameraSensorBtn.tag = 100;
    [self.CameraSensorBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    self.CameraSensorBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.CameraSensorBtn];
    
    
    self.AspectRationBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(241) - 64, iFSize(175), iFSize(25)) andTitle:self.AspectRatioArray[S1A3_Model.S1A3_AspectIndex]];
    [self.AspectRationBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    self.AspectRationBtn.tag = 102;
    [self.view addSubview:self.AspectRationBtn];
    
    
    self.FocalLengthBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(187), iFSize(175), iFSize(25)) andTitle:self.FocalLengthArray[S1A3_Model.S1A3_FocalIndex]];
    self.FocalLengthBtn.tag = 101;
    [self.FocalLengthBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.FocalLengthBtn];
    
    self.IntervalBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(103), iFSize(295) - 64, iFSize(175), iFSize(25)) andTitle:self.intervalArray[S1A3_Model.S1A3_PanIntervalIndex]];
    [self.IntervalBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    self.IntervalBtn.tag = 103;
    [self.view addSubview:self.IntervalBtn];
    
    
    _GridBtn = [self getFatherButtonWithTitle:NSLocalizedString(Stiching_Grid, nil) andImageName:@"Gird" andRect:CGRectMake(iFSize(72), iFSize(507), iFSize(89), iFSize(89)) selector:@selector(gotoS1A3_GridVCAction:)];
    
    _PanoBtn = [self getFatherButtonWithTitle:NSLocalizedString(Stiching_Pano, nil) andImageName:@"pano" andRect:CGRectMake(iFSize(212), iFSize(507), iFSize(120), iFSize(89)) selector:@selector(gotoS1A3_PanoVCAction:)];
    
}
- (UIButton *)getFatherButtonWithTitle:(NSString *)title andImageName:(NSString *)imageName andRect:(CGRect)rect selector:(SEL)selector{
//    CGFloat width = AutoKscreenWidth * 0.3;
//    UIButton * btn = [[UIButton alloc]initWithFrame:rect];
//    btn.layer.cornerRadius = AutoKscreenWidth * 0.3f * 0.5f;
//    btn.backgroundColor = [UIColor clearColor];
//    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//    [self.view addSubview:btn];
//
//    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-20, rect.size.height, width + 40, 20)];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15];
//    titleLabel.text = title;
//    [btn addSubview:titleLabel];
//    return btn;
    UIButton * btn = [[UIButton alloc]initWithFrame:rect];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

    [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:iFSize(20)];
    [self.view addSubview:btn];
    return btn;
}
#pragma mark --------gotoS1A3_GridVCAction----
- (void)gotoS1A3_GridVCAction:(UIButton *)btn{
    iFS1A3_GridViewController * gridVC = [[iFS1A3_GridViewController alloc]init];
    
    CGFloat height = 0 , width = 0, focalLength = 0;
    
    focalLength = [self.FocalLengthArray[S1A3_Model.S1A3_FocalIndex] floatValue];
    if (S1A3_Model.S1A3_CameraIndex == 0) {
        height = 24.00f; width = 36.00f;
    }else if (S1A3_Model.S1A3_CameraIndex == 1){
        height = 15.80f; width = 23.60f;
    }else if (S1A3_Model.S1A3_CameraIndex == 2){
        height = 13.00f; width = 17.30f;
    }else{
        
    }
    NSLog(@"height = %f, width = %f, focalLength = %f", height, width, focalLength);
    
    gridVC.TiltAngle = atan(height / 2.00f / focalLength) * 2 * 0.7 * 180.00f / M_PI;
    gridVC.PanAngle = atan(width / 2.00f / focalLength) * 2 * 0.7 * 180.00f / M_PI;
    gridVC.interval = self.intervalArray[S1A3_Model.S1A3_PanIntervalIndex];
    
    CGFloat maxAngle = gridVC.TiltAngle > gridVC.PanAngle ? gridVC.TiltAngle : gridVC.PanAngle;
    
    NSInteger maxInterval = [self.intervalArray[S1A3_Model.S1A3_PanIntervalIndex] integerValue] > [self countThelowestTimeWithAngle:maxAngle] ? [self.intervalArray[S1A3_Model.S1A3_PanIntervalIndex] integerValue] : [self countThelowestTimeWithAngle:maxAngle];
    
    gridVC.interval = [NSString stringWithFormat:@"%lds", maxInterval];
    
    [self.navigationController pushViewController:gridVC animated:YES];
    
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

#pragma mark --------gotoS1A3_PanoVCAction----
- (void)gotoS1A3_PanoVCAction:(UIButton *)btn{
    iFS1A3_PanoViewController * panoVC = [[iFS1A3_PanoViewController alloc]init];
    
    CGFloat height = 0 , width = 0, focalLength = 0;
    
    focalLength = [self.FocalLengthArray[S1A3_Model.S1A3_FocalIndex] floatValue];
    if (S1A3_Model.S1A3_CameraIndex == 0) {
        height = 24.00f; width = 36.00f;
    }else if (S1A3_Model.S1A3_CameraIndex == 1){
        height = 15.80f; width = 23.60f;
    }else if (S1A3_Model.S1A3_CameraIndex == 2){
        height = 13.00f; width = 17.30f;
    }else{
        
    }
    panoVC.aOneAngle = atan(width / 2.00f / focalLength) * 2 * 0.7 * 180.00f / M_PI;
    [self countThelowestTimeWithAngle:panoVC.aOneAngle];
    
    NSInteger maxInterval = [self.intervalArray[S1A3_Model.S1A3_PanIntervalIndex] integerValue] > [self countThelowestTimeWithAngle:panoVC.aOneAngle] ? [self.intervalArray[S1A3_Model.S1A3_PanIntervalIndex] integerValue] : [self countThelowestTimeWithAngle:panoVC.aOneAngle];
    panoVC.interval = [NSString stringWithFormat:@"%lds", maxInterval];
    [self.navigationController pushViewController:panoVC animated:YES];
}
#pragma --------showActionSheet----------
- (void)showActionSheet:(UIButton *)btn{
    NSString * str;
    NSMutableArray * array = [NSMutableArray new];
    self.identifier = btn.tag;
    NSUInteger indexInit = 0;
    
    if (btn.tag == 100) {
        str = self.CameraSensorLabel.text;
        array = self.CameraSensorArray;
        indexInit = S1A3_Model.S1A3_CameraIndex;
        
        
    }else if (btn.tag == 101){
        
        str = self.FocalLengthLabel.text;
        array = self.FocalLengthArray;
        indexInit = S1A3_Model.S1A3_FocalIndex;
        
    }else if (btn.tag == 102){
        
        str = self.AspectRationLabel.text;
        array = self.AspectRatioArray;
        indexInit = S1A3_Model.S1A3_AspectIndex;
        
    }else if (btn.tag == 103){
        
        str = self.IntervalLabel.text;
        array = self.intervalArray;
        indexInit = S1A3_Model.S1A3_PanIntervalIndex;
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
#pragma mark ----getIndexDelegate ------

- (void)getIndex:(NSUInteger)idex{
    
    if (self.identifier == 100) {
        S1A3_Model.S1A3_CameraIndex = idex;
        
    }else if (self.identifier == 101){
        S1A3_Model.S1A3_FocalIndex = idex;
        
        
    }else if (self.identifier == 102){
        S1A3_Model.S1A3_AspectIndex = idex;
        
        
    }else if (self.identifier == 103){
        S1A3_Model.S1A3_PanIntervalIndex = idex;
    }
    self.index = idex;
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
    
    [self.AspectRationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(220);
        make.centerX.equalTo(self.view);
    }];
    [self.AspectRationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.AspectRationLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    [self.FocalLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(320);
        make.centerX.equalTo(self.view);
    }];
    [self.FocalLengthBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.FocalLengthLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    [self.IntervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(420);
        make.centerX.equalTo(self.view);
    }];
    [self.IntervalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.IntervalLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [_GridBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.bottom.mas_equalTo(-50);
        make.size.mas_equalTo(width);
    }];
    [_PanoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(_GridBtn);
        make.size.mas_equalTo(width);
    }];
    
    
    
}
//横屏
- (void)LandscapescreenUI{
    CGFloat width = AutoKscreenWidth * 0.3;
    
    [self.CameraSensorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(iFSize(80));
    }];
    [self.CameraSensorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.CameraSensorLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.CameraSensorLabel.mas_centerX);
    }];
    [self.AspectRationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(300);
        make.centerY.equalTo(self.CameraSensorLabel);
    }];
    [self.AspectRationBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.AspectRationLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.AspectRationLabel.mas_centerX);
    }];
    
    [self.FocalLengthLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.mas_equalTo(220);
    }];
    [self.FocalLengthBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.FocalLengthLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.FocalLengthLabel.mas_centerX);
    }];
    [self.IntervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(300);
        make.centerY.equalTo(self.FocalLengthLabel);
    }];
    [self.IntervalBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.IntervalLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.IntervalLabel.mas_centerX);
    }];
    
    [_GridBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(self.AspectRationBtn.mas_centerY).offset(-10);
        make.size.mas_equalTo(width);
    }];
    [_PanoBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50);
        make.centerY.equalTo(self.IntervalBtn.mas_centerY).offset(-10);
        make.size.mas_equalTo(width);
    }];
    
    
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    UIDeviceOrientation interfaceOrientation = (UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
    
    if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        //翻转为竖屏时
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
