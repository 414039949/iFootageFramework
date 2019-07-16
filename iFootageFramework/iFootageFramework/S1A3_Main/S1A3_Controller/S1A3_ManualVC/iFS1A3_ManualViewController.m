//
//  iFS1A3_ManualViewController.m
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFS1A3_ManualViewController.h"
#import "iFAdjustVelocView.h"
#import "iFStatusBarView.h"
#import "iFProgressView.h"
#import "iF3DButton.h"
#import "iFS1A3_Model.h"




#define leftRocker_Tag 10000
#define rightRocker_Tag 10001

@interface iFS1A3_ManualViewController ()<JSAnalogueStickDelegate, AdjustVelocCurveDelegate>
@property (nonatomic, strong)iFProgressView * slideVelocView;
@property (nonatomic, strong)iFProgressView * panVelocView;
@property (nonatomic, strong)iFProgressView * TiltVelocView;
@property (nonatomic, strong)iFProgressView * SlideProView;
@property (nonatomic, strong)iFProgressView * PanProView;
@property (nonatomic, strong)iFProgressView * TiltProView;

@end

@implementation iFS1A3_ManualViewController
{
    UIView * leftBackgroundView;
    UIView * rightBackgroundView;
    UIView * leftSecondView;
    UIView * rightSecondView;
    iFAdjustVelocView * slideAdjustView;
    iFAdjustVelocView * panAdjustView;
    iFAdjustVelocView * tiltAdjustView;
//    iFStatusBarView * statusView;

    
    iF3DButton * lockTiltBtn;
    iF3DButton * lockPanBtn;
    AppDelegate * app;
    
    iF3DButton * SliderGetBackBtn;
    iF3DButton * X2GetBackBtn;
    iFS1A3_Model * S1A3_Model;
    
    NSTimer * receiveTimer;//接受的定时器 进入页面开始开启退出页面关闭
    NSUInteger               Encode;//编码模式 ascii or  hex

}



- (void)setReceiveMode{
    
    Encode = Encode_HEX;
    [_receiveView setIsAscii:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"Manual";
    _sendView = [[SendDataView alloc]init];
    _receiveView = [ReceiveView sharedInstance];
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    [self createAdjustVelocView];
    [self createAllButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//初始化数据

- (id)init{
    S1A3_Model = [iFS1A3_Model new];
    return self;
}

#pragma mark --------生成Button-------------------
- (void)createAllButton{
    lockTiltBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2, iFSize(80), iFSize(35)) WithTitle:@"Lock tilt" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    lockTiltBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [lockTiltBtn.actionBtn addTarget:self action:@selector(lockTiltAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lockTiltBtn];
    
    lockPanBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.2 + lockTiltBtn.frame.size.height + 15, iFSize(80), iFSize(35)) WithTitle:@"Lock pan" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    lockPanBtn.actionBtn.titleLabel.font = [UIFont systemFontOfSize:iFSize(10)];
    [lockPanBtn.actionBtn addTarget:self action:@selector(lockPanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lockPanBtn];
    
    SliderGetBackBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.05, AutoKscreenWidth * 0.2, iFSize(120), iFSize(35)) WithTitle:@"Slider get back" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    [SliderGetBackBtn.actionBtn addTarget:self action:@selector(SlidergetBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:SliderGetBackBtn];
    
    X2GetBackBtn = [[iF3DButton alloc]initWithFrame:CGRectMake(AutoKScreenHeight * 0.05, AutoKscreenWidth * 0.2 + lockTiltBtn.frame.size.height + 15, iFSize(120), iFSize(35)) WithTitle:@"X2 get back" selectedIMG:all_RED_BACKIMG normalIMG:all_WHITE_BACKIMG];
    [X2GetBackBtn.actionBtn addTarget:self action:@selector(X2getBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:X2GetBackBtn];
}
- (void)lockTiltAction:(UIButton *)btn{
    NSLog(@"lockTiltAction");
    btn.selected = !btn.selected;
    
}
- (void)lockPanAction:(UIButton *)btn{
    NSLog(@"lockPanAction");
    btn.selected = !btn.selected;

}
- (void)SlidergetBackAction{
    NSLog(@"SlidergetBackAction");
    [_sendView sendSliderBackZeroWith:SendStr WithCB:app.bleManager.S1A3_S1CB];
    
}
- (void)X2getBackAction{
    NSLog(@"X2getBackAction");
    [_sendView sendX2BackZeroWith:SendStr WithCB:app.bleManager.S1A3_X2CB];
}

#pragma mark -----创建所有的定时器集合-------
- (void)createAllTimer{
    receiveTimer = [NSTimer scheduledTimerWithTimeInterval:ReceiveSecond target:self selector:@selector(S1A3_receiveRealTimeData) userInfo:nil repeats:YES];
    receiveTimer.fireDate = [NSDate distantPast];
}
- (void)closeAllTimer{
    receiveTimer.fireDate = [NSDate distantFuture];
    [receiveTimer invalidate];
    receiveTimer = nil;
}
#pragma mark ----S1A3_receiveRealTimeData -----
- (void)S1A3_receiveRealTimeData{
    
    
   
    
    CGFloat S1A3_SlideValue = _receiveView.S1A3_S1_TrackRealPosition / 10.0f;
    CGFloat S1A3_PanValue = ((_receiveView.S1A3_X2_PanRealPosition) - 3600.0f) / 10.0f ;
    CGFloat S1A3_TiltValue = ((_receiveView.S1A3_X2_TiltRealPosition) - 3600.0f) / 10.0f;
    if (_receiveView.S1A3_X2_PanRealPosition == 0) {
        S1A3_PanValue = 0;
        
    }
    if (_receiveView.S1A3_X2_TiltRealPosition == 0) {
        S1A3_TiltValue = 0;
        
    }
    [self.SlideProView changeValueWithProgresslabel:S1A3_SlideValue / S1A3_TrackNumber(1) * 165 uint:S1A3_TrackNumber(1)];
    [self.PanProView changeValueWithProgresslabel:S1A3_PanValue / 360.0f * 165 uint:360.0f];
    [self.TiltProView changeValueWithProgresslabel:S1A3_TiltValue / 360.0f * 165 uint:360.f];

}
#pragma mark --------手动调整加速曲线----------------
- (void)createAdjustVelocView{
    slideAdjustView = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(89), iFSize(89)) WithColor:COLOR(255, 0, 255, 1) WithTitle:nil];
    slideAdjustView.center = CGPointMake(AutoKScreenHeight * 0.3 , AutoKscreenWidth * 0.27);
    slideAdjustView.delegate = self;
    slideAdjustView.tag = 1111;
    [slideAdjustView initCurveWithaValue:S1A3_Model.S1A3_slideAdjustVeloc];
    
    slideAdjustView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:slideAdjustView];
    
    panAdjustView    = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(89), iFSize(89)) WithColor:COLOR(0, 255, 255, 1) WithTitle:nil];
    panAdjustView.center = CGPointMake(AutoKScreenHeight * 0.5, AutoKscreenWidth * 0.27);
    panAdjustView.delegate = self;
    panAdjustView.tag = 2222;
    
    panAdjustView.backgroundColor = [UIColor clearColor];
    [panAdjustView initCurveWithaValue:S1A3_Model.S1A3_panAdjustVeloc];
    
    [self.view addSubview:panAdjustView];
    
    tiltAdjustView = [[iFAdjustVelocView alloc]initWithFrame:CGRectMake(0, 0, iFSize(89), iFSize(89)) WithColor:COLOR(255, 255, 0, 1) WithTitle:nil];
    tiltAdjustView.center = CGPointMake(AutoKScreenHeight * 0.7, AutoKscreenWidth * 0.27);
    tiltAdjustView.backgroundColor = [UIColor clearColor];
    [tiltAdjustView initCurveWithaValue:S1A3_Model.S1A3_tiltAdjustVeloc];
    tiltAdjustView.tag = 3333;
    
    tiltAdjustView.delegate = self;
    [self.view addSubview:tiltAdjustView];
    
    self.slideVelocView = [[iFProgressView alloc]initShowRealVelocViewWithFrame:CGRectMake(iFSize(182.5), iFSize(155), iFSize(71), iFSize(48.5)) WithTitle:@"Slide"];
    self.slideVelocView.center = CGPointMake(slideAdjustView.center.x, AutoKscreenWidth * 0.5);
    self.panVelocView = [[iFProgressView alloc]initShowRealVelocViewWithFrame:CGRectMake(iFSize(297.5), iFSize(155), iFSize(71), iFSize(48.5)) WithTitle:@"Pan"];
    self.panVelocView.center = CGPointMake(panAdjustView.center.x, AutoKscreenWidth * 0.5);
    self.TiltVelocView = [[iFProgressView alloc]initShowRealVelocViewWithFrame:CGRectMake(iFSize(413), iFSize(155), iFSize(71), iFSize(48.5)) WithTitle:@"Tilt"];
    self.TiltVelocView.center = CGPointMake(tiltAdjustView.center.x, AutoKscreenWidth * 0.5);
    [self.view addSubview:self.slideVelocView];
    [self.view addSubview:self.panVelocView];
    [self.view addSubview:self.TiltVelocView];
    
#pragma mark  ----Value-----
    self.SlideProView = [[iFProgressView alloc]initWithFrame:CGRectMake(iFSize(253), iFSize(239), 165, 30) andProgressValue:50 title:@"Slide value"];
    self.SlideProView.center = CGPointMake(AutoKScreenHeight * 0.5, self.slideVelocView.frame.size.height + self.slideVelocView.frame.origin.y + 30);
    [self.view addSubview:self.SlideProView];
    self.PanProView = [[iFProgressView alloc]initWithFrame:CGRectMake(iFSize(253), iFSize(279), 165, 30) andProgressValue:100 title:@"Pan value"];
    self.PanProView.center = CGPointMake(AutoKScreenHeight * 0.5, self.SlideProView.frame.size.height + self.SlideProView.frame.origin.y + 30);
    [self.view addSubview:self.PanProView];
    self.TiltProView = [[iFProgressView alloc]initWithFrame:CGRectMake(iFSize(253), iFSize(315), 165, 30) andProgressValue:150 title:@"Tilt value"];
    self.TiltProView.center = CGPointMake(AutoKScreenHeight * 0.5, self.PanProView.frame.size.height + self.PanProView.frame.origin.y + 30);
    [self.view addSubview:self.TiltProView];
    
}
- (void)AdjustVelocCurveWithpercentValue:(CGFloat)value andView:(UIView *)anyView{
    
    if (anyView.tag == 1111) {
        S1A3_Model.S1A3_slideAdjustVeloc = value;
    }else if (anyView.tag == 2222){
        S1A3_Model.S1A3_panAdjustVeloc = value;
    }else if (anyView.tag == 3333){
        S1A3_Model.S1A3_tiltAdjustVeloc = value;
    }
    
}
#pragma mark --------创建摇杆及其操作区域--------------------
- (void)createRockerAndRockerSquare{
    [leftBackgroundView removeFromSuperview];
    leftBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(30), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    leftBackgroundView.backgroundColor = [UIColor clearColor];
    leftBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.15, AutoKscreenWidth * 0.7);
    [self.view addSubview:leftBackgroundView];
    
    [rightBackgroundView removeFromSuperview];
    rightBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(iFSize(455), AutoKscreenWidth * 0.45, AutoKscreenWidth * 0.5, AutoKscreenWidth * 0.5)];
    rightBackgroundView.backgroundColor = [UIColor clearColor];
    rightBackgroundView.center = CGPointMake(AutoKScreenHeight * 0.85, AutoKscreenWidth * 0.7);
    
    [self.view addSubview:rightBackgroundView];
    
    /**
     右边摇杆
     */
    [self.RightanalogueStick removeFromSuperview];
    
    self.RightanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(455), iFSize(214), 125, 125)];
    self.RightanalogueStick.tag = rightRocker_Tag;
    self.RightanalogueStick.delegate = self;
    self.RightanalogueStick.center = CGPointMake(rightBackgroundView.frame.size.width * 0.5, rightBackgroundView.frame.size.height * 0.5);
    [rightBackgroundView addSubview:self.RightanalogueStick];
    
    /**
     左边摇杆
     */
    [self.LeftanalogueStick removeFromSuperview];
    self.LeftanalogueStick = [[iFootageRocker alloc]initWithFrame:CGRectMake(iFSize(79.5), iFSize(214), 125, 125)];
    self.LeftanalogueStick.center = CGPointMake(leftBackgroundView.frame.size.width * 0.5, leftBackgroundView.frame.size.height * 0.5);
    self.LeftanalogueStick.tag = leftRocker_Tag;
    self.LeftanalogueStick.delegate = self;
    [leftBackgroundView addSubview:self.LeftanalogueStick];
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
#pragma mark -------摇杆代理-------------
- (void)analogueStickDidChangeValue:(iFootageRocker *)analogueStick{
    
    NSString * str = [NSString stringWithFormat:@"AAAF01%.lu", (long)self.RightanalogueStick.xValue * 100];
    NSData * data = [[self stringToHex:str] dataUsingEncoding:NSUTF8StringEncoding];
    
    CGFloat S1A3_S1_realVeloc, S1A3_X2_PanRealVeloc, S1A3_X2_TiltRealVeloc = 0.0f;
    
    
    if (analogueStick.tag == leftRocker_Tag) {
        if (analogueStick.xValue >= 1.0f) {
            S1A3_S1_realVeloc = [slideAdjustView CountSomeThingsAndPointX:1.0f];
        }else{
            S1A3_S1_realVeloc = [slideAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
        }
        UInt16  realVeloc = (UInt16)(analogueStick.xValue * S1A3_SlideVelocMaxValue * 100 + 16000);
        [_sendView sendS1A3_S1VelocWith:app.bleManager.S1A3_S1CB andFrameHead:OXAAAF andFunctionNumber:0x01 andVeloc:realVeloc With:SendStr];
        self.slideVelocView.AxaiValueLabel.text = [NSString stringWithFormat:@"%.1lf", S1A3_S1_realVeloc * S1A3_SlideVelocMaxValue];

    }else if (analogueStick.tag == rightRocker_Tag){
        if (analogueStick.xValue >= 1.0f) {
            S1A3_X2_PanRealVeloc = [panAdjustView CountSomeThingsAndPointX:1.0f];
        }else{
            S1A3_X2_PanRealVeloc = [panAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
        }
        if (analogueStick.yValue >= 1.0f) {
            S1A3_X2_TiltRealVeloc = [tiltAdjustView CountSomeThingsAndPointX:1.0f];
        }else{
            S1A3_X2_TiltRealVeloc = [tiltAdjustView CountSomeThingsAndPointX:analogueStick.xValue];
        }
        self.panVelocView.AxaiValueLabel.text = [NSString stringWithFormat:@"%.1lf", S1A3_X2_PanRealVeloc * S1A3_PanVelocMaxValue];
        self.TiltVelocView.AxaiValueLabel.text = [NSString stringWithFormat:@"%.1lf", S1A3_X2_TiltRealVeloc * S1A3_TiltVelocMaxValue];
        UInt16  panVeloc = (UInt16)(analogueStick.xValue * 10 * S1A3_PanVelocMaxValue * !lockPanBtn.actionBtn.selected + 400);
        UInt16  tiltVeloc = (UInt16)(analogueStick.yValue * 10  * S1A3_TiltVelocMaxValue * !lockTiltBtn.actionBtn.selected + 400);
        [_sendView sendS1A3_X2VelocWith:app.bleManager.S1A3_X2CB andFrameHead:OX555F andFuntionNumber:0x01 andPanVeloc:panVeloc andTiltVeloc:tiltVeloc With:SendStr];
        
    }
}
#pragma mark -------手势响应计算---------
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touchLocation in touches) {
        if ([rightBackgroundView.layer containsPoint:[touchLocation locationInView:rightBackgroundView]]) {
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

#pragma mark --------需要旋转横屏--------退回返回全方位-------
- (void)viewWillDisappear:(BOOL)animated{
    [self forceOrientationPortrait];
    [self closeAllTimer];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self forceOrientationLandscape];
    [self createRockerAndRockerSquare];
    [self createAllTimer];
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
