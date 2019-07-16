//
//  iFBazierView.m
//  iFootage
//
//  Created by 黄品源 on 16/8/4.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFBazierView.h"
#import "DXPopover.h"
#import "iFButton.h"
#import "iFLabel.h"
#import "iFLoopView.h"
#import "iFAlertController.h"
#import "iFS1A3_Model.h"
#import<objc/runtime.h>


#define Point(x, y) [NSValue valueWithCGPoint:CGPointMake(x, y)]
#define LineWidth 1.0f
#define ControlDistance 40.0f
#define LimitDistance 80.0f
#define LimitControlDistance 30.0f
#define PanTag 300
#define TiltTag 200
#define SliderTag 100
#define LeftControlTag 1001
#define RightControlTag 1000
#define SliderBtnTag  10
#define PanBtnTag     11
#define TiltBtnTag    12

#define SliderStokerColor [UIColor whiteColor]
#define PanStrokeColor [UIColor cyanColor]
#define TiltStrokeColor  [UIColor orangeColor]
#define PointCOLOR [UIColor whiteColor]

@implementation iFBazierView
{
    NSInteger PointTag;
    NSUserDefaults * ud;
    NSInteger frames;
    DXPopover *popover;
    NSTimer * sendTimer;
    CGFloat XmoveValue;
    CGFloat YmoveValue;
    UIBezierPath * controlBezier;
    CAShapeLayer * controlShaper;
    
    BOOL isStart;
    
    
    
    NSInteger All_Frames;
    NSInteger All_FunctionMode;
    CGFloat All_TotalTimes;
    NSInteger All_SlideCount;
    NSInteger All_DisplayUnit;
    CGFloat All_upSliderValue;
    CGFloat All_downSliderValue;
    CGFloat All_upPanValue;
    CGFloat All_downPanValue;
    CGFloat All_upTiltValue;
    CGFloat All_downTiltValue;
    NSInteger All_fpsIndex;
    CGFloat All_TimelaspseTotaltimes;
    CGFloat All_shootMode;
    
}
@synthesize CurvebackGroundView, ControlPointArray, insertView, insertIndex, PointArray,shapeLayer,bezierPath,startPoint, StorkeColor, endPoint,right,left,XValue,r, tana, px, py, topup, topdown, topleft, topright;


-(id)initWithFrame:(CGRect)frame andColor:(UIColor *)color array:(NSArray *)array WithControl:(NSArray *)controlArray{
    
    
    if (self = [super initWithFrame:frame]) {
        ControlPointArray = [[NSMutableArray alloc]init];
        ud = [NSUserDefaults standardUserDefaults];
        self.ifmodel = [[iFModel alloc]init];
        self.S1A3_Model = [[iFS1A3_Model alloc]init];
        right = 0;
        left = 0;
        self.StorkeColor = color;
        [self createRectangularCoordinates];
        [self createBackGround];
        PointArray = [NSMutableArray arrayWithArray:array];
        
        if (controlArray) {
            ControlPointArray = [NSMutableArray arrayWithArray:controlArray];
            
//            NSLog(@"ControlArray = %@", ControlPointArray);

        }else{
            [self createControlPointArray:PointArray];
        }
        
        [self createInitializationCurve:PointArray];
        [self creatPointWithArray:PointArray];
        
        sendTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(loopSendData) userInfo:nil repeats:YES];
        sendTimer.fireDate = [NSDate distantFuture];
        
        
    }
    return self;
}

#warning -----move 加大感应区域操作更顺畅 ----
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    NSLog(@"point = %@", NSStringFromCGPoint(point));
//    NSLog(@"%@", self);
    if ((point.x >= -iFSize(10) && point.x < self.frame.size.width + iFSize(10)) && (point.y >= -iFSize(5) &&  point.y < self.frame.size.height + iFSize(10))) {
        
        return YES;
        
    }else{
        return  NO;
    
    }
}


#pragma mark ---开始生成原点---
-(void)creatPointWithArray:(NSMutableArray *)array{
    for (int i = 0 ; i < array.count; i++) {
        iFPointView * pv1 = (iFPointView *)[self viewWithTag:100 + i];
        if (pv1) {
            [pv1 removeFromSuperview];
        }
        iFPointView *  pv = [[iFPointView alloc]initWithFrame:CGRectZero WithCenter:[array[i] CGPointValue] WithColor:PointCOLOR];
        pv.tag = 100 + i;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lalalala:)];
        tapGesture.numberOfTapsRequired = 2;
        [pv addGestureRecognizer:tapGesture];
        [pv addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(createDragMethod:)]];
        [self addSubview:pv];
    }
}
//- (void)sendValueWith:(UIButton *)btn{
//    objc_setAssociatedObject(btn, @"key",@"需要传的值", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//}
//- (void)getValueWith:(UIButton *)btn{
//    NSString *str =objc_getAssociatedObject(btn, @"key");
//    NSLog(@"%@", str);
//}
- (void)getInitData{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:S1A3orMiniID] isEqualToString:@"S1A3"] == YES) {
        All_Frames = self.S1A3_Model.S1A3_TimelapseTotalFrames;
        All_FunctionMode = self.S1A3_Model.S1A3_FunctionMode;
        All_TotalTimes = self.S1A3_Model.S1A3_VideoTotalTimes;
        All_SlideCount = self.S1A3_Model.S1A3_SlideCount;
        All_DisplayUnit = self.S1A3_Model.S1A3_DisPlayMode;
        All_upSliderValue = self.S1A3_Model.S1A3_SlideUpValue;
        All_downPanValue = self.S1A3_Model.S1A3_SlideDownValue;
        All_upPanValue = self.S1A3_Model.S1A3_PanUpValue;
        All_downPanValue = self.S1A3_Model.S1A3_PanDownValue;
        All_upTiltValue = self.S1A3_Model.S1A3_TiltUpValue;
        All_downTiltValue = self.S1A3_Model.S1A3_TiltDownValue;
        All_TimelaspseTotaltimes = self.S1A3_Model.S1A3_TimelapseTotalTimes;
        All_shootMode = self.S1A3_Model.S1A3_ShootingMode;
        All_fpsIndex = self.S1A3_Model.S1A3_fpsIndex;
    }else{
        if ([ud objectForKey:TOTALFRAMES]) {
            All_Frames  = [[ud objectForKey:TOTALFRAMES] integerValue];
        }else{
            All_Frames = 100;
        }
        if ([ud objectForKey:FUNCTIONMODE]) {
            All_FunctionMode = [[ud objectForKey:FUNCTIONMODE] integerValue];
        }else{
            All_FunctionMode = 0;
            
        }
        if ([ud objectForKey:TOTALTIMES]) {
            All_TotalTimes = [[ud objectForKey:TOTALTIMES] floatValue];
            
        }else{
            All_TotalTimes = 100;
            
        }
        if ([ud objectForKey:SLIDECOUNT]) {
            All_SlideCount = [[ud objectForKey:SLIDECOUNT] integerValue];
            
        }else{
            All_SlideCount = 2;
            
        }
        if ([ud objectForKey:DISPLAYUNIT]) {
            All_DisplayUnit = [[ud objectForKey:DISPLAYUNIT] integerValue];
            
        }else{
            All_DisplayUnit = 0;
        }
        
        if ([ud objectForKey:UpSlideViewValue]) {
            All_upSliderValue = [[ud objectForKey:UpSlideViewValue] floatValue];
        }else{
#warning -----------！！！！！！要改 要改
            All_upSliderValue = SlideConunt(All_SlideCount);
        }
        
        if ([ud objectForKey:DownSlideViewValue]) {
            All_downSliderValue = [[ud objectForKey:DownSlideViewValue] floatValue];
        }else{
            All_downSliderValue = 0.0f;
        }
        
        if ([ud objectForKey:UpPanViewValue]) {
            
            All_upPanValue = [[ud objectForKey:UpPanViewValue] floatValue];
        }else{
            All_upPanValue = 90.0f;
        }
        if ([ud objectForKey:DownPanViewValue]) {
            All_downPanValue = [[ud objectForKey:DownPanViewValue] floatValue];
        }else{
            All_downPanValue = -90.0f;
        }
        
        if ([ud objectForKey:UpTiltViewValue]) {
            All_upTiltValue = [[ud objectForKey:UpTiltViewValue] floatValue];
        }else{
            All_upTiltValue = TiltMaxValue;
        }
        if ([ud objectForKey:DownTiltViewValue]) {
            All_downTiltValue = [[ud objectForKey:DownTiltViewValue] floatValue];
            
        }else{
            All_downTiltValue = TiltMinValue;
        }
        
        
        if ([ud objectForKey:FPSValue]) {
            All_fpsIndex= [[ud objectForKey:FPSValue] floatValue];
            
        }else{
            All_fpsIndex = 0;
            
        }
        if ([ud objectForKey:TIMELAPSETIME]) {
            All_TimelaspseTotaltimes = [[ud objectForKey:TIMELAPSETIME]integerValue];
            
        }else{
            All_TimelaspseTotaltimes = 100 / 24.0f;
        }
        
        if ([ud objectForKey:SHOOTINGMODE]) {
            All_shootMode = [[ud objectForKey:SHOOTINGMODE]integerValue];
            
        }else{
            All_shootMode = 0;
        }
    }
}
#pragma mark 添加双击手势 出来控制点
- (void)lalalala:(UITapGestureRecognizer *)tap{
    
    PointTag = tap.view.tag;
    [self getInitData];
    popover = [DXPopover popover];
    popover.userInteractionEnabled = YES;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(tap.view.frame.origin.x + self.frame.origin.x, tap.view.frame.origin.y + self.frame.origin.y, tap.view.frame.size.width, tap.view.frame.size.height)];
    [popover showAtView:view withContentView:[self createFineTurnView]];
    [self createMovedControlWithTag:tap.view.tag];
#warning  - Ylabel!!!!---
    NSArray * configs = @[@"24fps", @"25fps", @"30fps", @"50fps", @"60fps"];
    NSInteger fpsValue = [configs[All_fpsIndex] integerValue];
    
    UInt32 TotalFrames;
    
    if (All_DisplayUnit == 1) {
        TotalFrames = (UInt32)(fpsValue * All_TimelaspseTotaltimes);
        
    }else{
        TotalFrames = (UInt32)All_Frames;
    }
    
    
    if (All_FunctionMode == 1) {
        TotalFrames = All_TotalTimes;
    }
    
    self.Xlabel.text = [NSString stringWithFormat:@"%.0f", tap.view.center.x / self.frame.size.width * TotalFrames];
    
    if (self.tag == 1) {
        self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - tap.view.center.y) / self.frame.size.height * (All_upSliderValue - All_downSliderValue) + All_downSliderValue];
    }else if (self.tag == 2){
        
        self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - tap.view.center.y) / self.frame.size.height * (All_upPanValue - All_downPanValue) + All_downPanValue];
        
    }else if (self.tag == 3){
        self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - tap.view.center.y) / self.frame.size.height * (All_upTiltValue - All_downTiltValue) + All_downTiltValue];
    }

    
}

#pragma mark - create微调View
- (UIView *)createFineTurnView{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 160)];
    baseView.userInteractionEnabled = YES;
    baseView.backgroundColor = COLOR(66, 66, 66, 1);
    
    self.Xlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 55, 20)];
    self.Ylabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 55, 20)];

    self.Xlabel.backgroundColor = [UIColor clearColor];
    self.Xlabel.textAlignment = NSTextAlignmentCenter;
    self.Xlabel.textColor = [UIColor whiteColor];
    self.Ylabel.backgroundColor = [UIColor clearColor];
    self.Ylabel.textAlignment = NSTextAlignmentCenter;
    
    self.Ylabel.textColor = [UIColor whiteColor];
    
    
    [baseView addSubview:self.Xlabel];
    [baseView addSubview:self.Ylabel];
    
    UILongPressGestureRecognizer * longPressGesture1 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(FineTurnlongPressGuesureAction:)];
    longPressGesture1.minimumPressDuration = 0.5f;
    longPressGesture1.allowableMovement = 1.0f;
    
    UILongPressGestureRecognizer * longPressGesture2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(FineTurnlongPressGuesureAction:)];
    longPressGesture2.minimumPressDuration = 0.5f;
    longPressGesture2.allowableMovement = 1.0f;
    
    UILongPressGestureRecognizer * longPressGesture3 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(FineTurnlongPressGuesureAction:)];
    longPressGesture3.minimumPressDuration = 0.5f;
    longPressGesture3.allowableMovement = 1.0f;
    
    UILongPressGestureRecognizer * longPressGesture4 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(FineTurnlongPressGuesureAction:)];
    longPressGesture4.minimumPressDuration = 0.5f;
    longPressGesture4.allowableMovement = 1.0f;
    
    
    iFButton * TurnLeftBtn = [[iFButton alloc]initWithFrame:CGRectMake(20, 60, 35, 35) WithFineTitle:@"L"];
    
    TurnLeftBtn.tag = 30;
    [TurnLeftBtn addGestureRecognizer:longPressGesture1];
    
    
    iFButton * TurnRightBtn = [[iFButton alloc]initWithFrame:CGRectMake(80, 60, 35, 35) WithFineTitle:@"R"];
    TurnRightBtn.tag = 31;
    [TurnRightBtn addGestureRecognizer:longPressGesture2];
    
    
    iFButton * TurnUpBtn = [[iFButton alloc]initWithFrame:CGRectMake(50, 30, 35, 35) WithFineTitle:@"U"];
    TurnUpBtn.tag = 32;
    [TurnUpBtn addGestureRecognizer:longPressGesture3];
    

    iFButton * TurnDownBtn = [[iFButton alloc]initWithFrame:CGRectMake(50, 90, 35, 35) WithFineTitle:@"D"];
    TurnDownBtn.tag = 33;
    [TurnDownBtn addGestureRecognizer:longPressGesture4];
    
    [TurnLeftBtn addTarget:self action:@selector(FineTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    [TurnRightBtn addTarget:self action:@selector(FineTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    [TurnUpBtn addTarget:self action:@selector(FineTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    [TurnDownBtn addTarget:self action:@selector(FineTurnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    iFButton * deleteBtn = [[iFButton alloc]initWithFrame:CGRectMake(20, 125, 80, 30) andTitle:@"Delete"];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [deleteBtn addTarget:self action:@selector(deleteThePoint) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.backgroundColor = [UIColor clearColor];
    deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    [baseView addSubview:deleteBtn];
    [baseView addSubview:TurnLeftBtn];
    [baseView addSubview:TurnRightBtn];
    [baseView addSubview:TurnUpBtn];
    [baseView addSubview:TurnDownBtn];
    
    return baseView;
    
}

- (void)AddGestureRecognizerWithTimer:(NSTimer *)timer{
    [self getInitData];
    
    UILongPressGestureRecognizer * longsure = timer.userInfo;
    
        iFPointView * pointView = (iFPointView *)[self viewWithTag:PointTag];
        iFPointView * pv1 = (iFPointView *)[self viewWithTag:PointTag - 1];
        iFPointView * pv2 = (iFPointView *)[self viewWithTag:PointTag + 1];
//        NSLog(@"PPP = %ld", PointTag);
        NSLog(@"PVPV = %@ %@", pv1, pv2);
    
    
        static CGPoint center;
        static CGPoint control1;
        static CGPoint control2;
        static CGFloat control1DistanceX;
        static CGFloat control2DistanceX;
        static CGFloat conrtol1DistanceY;
        static CGFloat control2DistanceY;
    
    
        center = pointView.center;
    
        if (pointView.tag - 100 == 0) {
            control1 = [ControlPointArray[pointView.tag - SliderTag][0] CGPointValue];
            control1DistanceX = center.x - control1.x;
            conrtol1DistanceY = center.y - control1.y;
    
        }
        else if (pointView.tag - 100 > 0&& pointView.tag - SliderTag < ControlPointArray.count){
    
            control1 = [ControlPointArray[pointView.tag - SliderTag][0] CGPointValue];
            control2 = [ControlPointArray[pointView.tag - SliderTag - 1][1] CGPointValue];
    
            control1DistanceX = center.x - control1.x;
            control2DistanceX = control2.x - center.x;
            conrtol1DistanceY = center.y - control1.y;
            control2DistanceY = center.y - control2.y;
    
    
        }else{
            control2 = [ControlPointArray[pointView.tag - SliderTag - 1][1] CGPointValue];
            control2DistanceX = control2.x - center.x;
            control2DistanceY = center.y - control2.y;
        }
    
        NSLog(@"%f", self.frame.size.width);
        NSArray * configs = @[@"24fps", @"25fps", @"30fps", @"50fps", @"60fps"];
        NSInteger fpsValue = [configs[All_fpsIndex] integerValue];
        UInt32 TotalFrames;
        if (All_DisplayUnit == 1) {
            TotalFrames = (UInt32)(fpsValue * All_TimelaspseTotaltimes);
        }else{
            TotalFrames = (UInt32)All_Frames;
        }
    
        if (All_FunctionMode == 1) {
            TotalFrames = All_TotalTimes;
    
        }
    
        CGFloat xf = self.frame.size.width / (float)TotalFrames;
    
//        NSLog(@"tag = %ld", (long)self.tag);
        CGFloat yf = 0.0;
        if (self.tag == 1) {
            yf = self.frame.size.height / (float)(All_upSliderValue - All_downSliderValue) / 10.0f;
        }else if (self.tag == 2){
            yf = self.frame.size.height / (float)(All_upPanValue - All_downPanValue) / 10.0f;
        }else if (self.tag == 3){
            yf = self.frame.size.height / (float)(All_upTiltValue - All_downTiltValue) / 10.0f;
        }
    
        switch (longsure.view.tag) {
            case 30:
//                NSLog(@"左 = %f", center.x - xf);
    
                if (pointView.tag - 100 == 0 || pointView.tag - 100 + 1 == PointArray.count) {
                    return;
                }else{
                    if (center.x - xf - LimitDistance <= pv1.center.x) {
                        return;
                    }else{
                        pointView.center = CGPointMake(center.x - xf, center.y);
                    }
                }
                break;
            case 31:
//                NSLog(@"右 = %f", center.x + xf);
                if (pointView.tag - 100 == 0 || pointView.tag - 100 + 1 == PointArray.count) {
                    return;
    
                }else{
                    if (center.x + xf + LimitDistance >= pv2.center.x) {
                        return;
                    }else{
                        pointView.center = CGPointMake(center.x + xf, center.y);
                    }
                }
    
                break;
            case 32:
//                NSLog(@"上 = %f", center.y - yf);
                if (center.y - yf >= 0.0f) {
                    pointView.center = CGPointMake(center.x, center.y - yf);
    
                }else{
                    return;
    
                }
    
                break;
            case 33:
//                NSLog(@"下 = %f", center.y + yf);
    
                if (center.y + yf > self.frame.size.height) {
    
                    return;
                }else{
                    pointView.center = CGPointMake(center.x, center.y + yf);
    
                }
    
                break;
            default:
                break;
        }
    
        [PointArray replaceObjectAtIndex:PointTag - 100 withObject:Point(pointView.center.x, pointView.center.y)];
        [self createBackGround];
    
    
        if (pointView.tag - SliderTag == 0) {
            [ControlPointArray[pointView.tag - SliderTag] replaceObjectAtIndex:0 withObject:Point(pointView.center.x - control1DistanceX, pointView.center.y - conrtol1DistanceY)];
        }
        else if (pointView.tag - SliderTag > 0 && pointView.tag - SliderTag < ControlPointArray.count){
    
            [ControlPointArray[pointView.tag - SliderTag] replaceObjectAtIndex:0 withObject:Point(pointView.center.x - control1DistanceX, pointView.center.y - conrtol1DistanceY)];
            [ControlPointArray[pointView.tag - SliderTag - 1] replaceObjectAtIndex:1 withObject:Point(pointView.center.x + control2DistanceX, pointView.center.y - control2DistanceY)];
    
        }else{
            [ControlPointArray[pointView.tag - SliderTag - 1] replaceObjectAtIndex:1 withObject:Point(pointView.center.x + control2DistanceX, pointView.center.y - control2DistanceY)];
        }
    
        [self createMovedControlWithTag:pointView.tag];
        [self refreshPoint];
        [self createInitializationCurve:PointArray];
    
        self.Xlabel.text = [NSString stringWithFormat:@"%.0f", pointView.center.x / self.frame.size.width * TotalFrames];
        if (self.tag == 1) {
            self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - pointView.center.y) / self.frame.size.height * (All_upSliderValue - All_downSliderValue) + All_downSliderValue];
        }else if (self.tag == 2){
            self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - pointView.center.y) / self.frame.size.height * (All_upPanValue - All_downPanValue) + All_downPanValue];
            
        }else if (self.tag == 3){
            self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - pointView.center.y) / self.frame.size.height * (All_upTiltValue - All_downTiltValue) + All_downTiltValue];
        }
        
        [_delegate moveRealTimePreViewPointY:pointView.center.y andPointX:pointView.center.x andHeight:self.frame.size.height andWidth:self.frame.size.width];
    
    
    
}

- (void)FineTurnlongPressGuesureAction:(UILongPressGestureRecognizer *)longgesure{
    
    if (longgesure.state == UIGestureRecognizerStateBegan) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(AddGestureRecognizerWithTimer:) userInfo:longgesure repeats:YES];
        _countTimer.fireDate = [NSDate distantFuture];

        _countTimer.fireDate = [NSDate distantPast];
        
    }
    if (longgesure.state == UIGestureRecognizerStateEnded) {
        _countTimer.fireDate = [NSDate distantFuture];
        [_countTimer invalidate];
        
        _countTimer = nil;
        
    }
//
//    

}
#pragma mark - FineTurnAction微调-
- (void)FineTurnAction:(iFButton *)sender{
    [self getInitData];
    
    iFPointView * pointView = (iFPointView *)[self viewWithTag:PointTag];
    iFPointView * pv1 = (iFPointView *)[self viewWithTag:PointTag - 1];
    iFPointView * pv2 = (iFPointView *)[self viewWithTag:PointTag + 1];
//    NSLog(@"PPP = %ld", PointTag);
    NSLog(@"PVPV = %@ %@", pv1, pv2);
    
    static CGPoint center;
    static CGPoint control1;
    static CGPoint control2;
    static CGFloat control1DistanceX;
    static CGFloat control2DistanceX;
    static CGFloat conrtol1DistanceY;
    static CGFloat control2DistanceY;
    
    
    center = pointView.center;
    
    if (pointView.tag - 100 == 0) {
        control1 = [ControlPointArray[pointView.tag - SliderTag][0] CGPointValue];
        control1DistanceX = center.x - control1.x;
        conrtol1DistanceY = center.y - control1.y;
        
    }
    else if (pointView.tag - 100 > 0&& pointView.tag - SliderTag < ControlPointArray.count){
        
        control1 = [ControlPointArray[pointView.tag - SliderTag][0] CGPointValue];
        control2 = [ControlPointArray[pointView.tag - SliderTag - 1][1] CGPointValue];
        
        control1DistanceX = center.x - control1.x;
        control2DistanceX = control2.x - center.x;
        conrtol1DistanceY = center.y - control1.y;
        control2DistanceY = center.y - control2.y;

        
    }else{
        control2 = [ControlPointArray[pointView.tag - SliderTag - 1][1] CGPointValue];
        control2DistanceX = control2.x - center.x;
        control2DistanceY = center.y - control2.y;
    }

    NSLog(@"%f", self.frame.size.width);
    NSArray * configs = @[@"24fps", @"25fps", @"30fps", @"50fps", @"60fps"];
    NSInteger fpsValue = [configs[All_fpsIndex] integerValue];
    UInt32 TotalFrames;
    if (All_DisplayUnit == 1) {
        TotalFrames = (UInt32)(fpsValue * All_TimelaspseTotaltimes);
    }else{
        TotalFrames = (UInt32)All_Frames;
    }

    if (All_FunctionMode == 1) {
        TotalFrames = All_TotalTimes;
        
    }
    CGFloat xf = self.frame.size.width / (float)TotalFrames;

    NSLog(@"tag = %ld", (long)self.tag);
    CGFloat yf = 0.0;
    if (self.tag == 1) {
         yf = self.frame.size.height / (float)(All_upSliderValue - All_downSliderValue) / 10.0f;
    }else if (self.tag == 2){
        yf = self.frame.size.height / (float)(All_upPanValue - All_downPanValue) / 10.0f;
    }else if (self.tag == 3){
        yf = self.frame.size.height / (float)(All_upTiltValue - All_downTiltValue) / 10.0f;
    }
    
    switch (sender.tag) {
        case 30:
            NSLog(@"左 = %f", center.x - xf);
            
            if (pointView.tag - 100 == 0 || pointView.tag - 100 + 1 == PointArray.count) {
                return;
            }else{
                if (center.x - xf - LimitDistance <= pv1.center.x) {
                    return;
                }else{
                pointView.center = CGPointMake(center.x - xf, center.y);
                }
            }
            break;
        case 31:
            NSLog(@"右 = %f", center.x + xf);
            if (pointView.tag - 100 == 0 || pointView.tag - 100 + 1 == PointArray.count) {
                return;
                
            }else{
                if (center.x + xf + LimitDistance >= pv2.center.x) {
                    return;
                }else{
                pointView.center = CGPointMake(center.x + xf, center.y);
                }
            }

            break;
        case 32:
            NSLog(@"上 = %f", center.y - yf);
            if (center.y - yf >= 0.0f) {
                pointView.center = CGPointMake(center.x, center.y - yf);
                
            }else{
                return;

            }
            
            break;
        case 33:
            NSLog(@"下 = %f", center.y + yf);
            
            if (center.y + yf > self.frame.size.height) {
                
                return;
            }else{
                pointView.center = CGPointMake(center.x, center.y + yf);
                
            }
            
            break;
        default:
            break;
    }
    
    [PointArray replaceObjectAtIndex:PointTag - 100 withObject:Point(pointView.center.x, pointView.center.y)];
    [self createBackGround];
    
    
    if (pointView.tag - SliderTag == 0) {
        [ControlPointArray[pointView.tag - SliderTag] replaceObjectAtIndex:0 withObject:Point(pointView.center.x - control1DistanceX, pointView.center.y - conrtol1DistanceY)];
    }
    else if (pointView.tag - SliderTag > 0 && pointView.tag - SliderTag < ControlPointArray.count){
        
        [ControlPointArray[pointView.tag - SliderTag] replaceObjectAtIndex:0 withObject:Point(pointView.center.x - control1DistanceX, pointView.center.y - conrtol1DistanceY)];
        [ControlPointArray[pointView.tag - SliderTag - 1] replaceObjectAtIndex:1 withObject:Point(pointView.center.x + control2DistanceX, pointView.center.y - control2DistanceY)];
        
    }else{
        [ControlPointArray[pointView.tag - SliderTag - 1] replaceObjectAtIndex:1 withObject:Point(pointView.center.x + control2DistanceX, pointView.center.y - control2DistanceY)];
    }
    
    [self createMovedControlWithTag:pointView.tag];
    [self refreshPoint];
    [self createInitializationCurve:PointArray];
    
    self.Xlabel.text = [NSString stringWithFormat:@"%.0f", pointView.center.x / self.frame.size.width * TotalFrames];
    if (self.tag == 1) {
        self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - pointView.center.y) / self.frame.size.height * (All_upSliderValue - All_downSliderValue) + All_downSliderValue];
    }else if (self.tag == 2){
        self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - pointView.center.y) / self.frame.size.height * (All_upPanValue - All_downPanValue) + All_downPanValue];
        
    }else if (self.tag == 3){
        self.Ylabel.text = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - pointView.center.y) / self.frame.size.height * (All_upTiltValue - All_downTiltValue) + All_downTiltValue];
    }
    
    
    [_delegate moveRealTimePreViewPointY:pointView.center.y andPointX:pointView.center.x andHeight:self.frame.size.height andWidth:self.frame.size.width];
    
    
}
#pragma mark --- 删除对应点-------
- (void)deleteThePoint{
    
//    NSLog(@"Pointtag = %ld %ld", PointTag, PointArray.count + 100 - 1);
    
    [popover dismiss];
    
    /**
     判断是否为两端是起止点
     如果是不能删除
     @param
     @return
     */
    if (PointTag - (PointArray.count + 100 - 1) == 0 ||(PointArray.count + 100 - 1) - PointTag == PointArray.count - 1) {
        
        [_delegate showAccordingToWarningWithMode:1];
        return;
        
    }else{
        
    [controlShaper removeFromSuperlayer];
    iFPointView * pv1 = (iFPointView *)[self viewWithTag:LeftControlTag];
    iFPointView * pv2 = (iFPointView *)[self viewWithTag:RightControlTag];
    [pv1 removeFromSuperview];
    [pv2 removeFromSuperview];
    iFPointView * pv = (iFPointView *)[self viewWithTag:PointArray.count + 100 - 1];
    [pv removeFromSuperview];

    
    [PointArray removeObjectAtIndex:PointTag - 100];
//    [self replaceControlPointArrayWith:ControlPointArray andIndex:PointTag - 100];
        
    NSArray * array = [NSArray arrayWithArray:ControlPointArray];

    [ControlPointArray removeAllObjects];
    

        [self createBackGround];
//    [self createControlPointArray:PointArray];
    [self replaceControlPointArrayWith:array andIndex:PointTag - 100];
        
    [self createInitializationCurve:PointArray];
    [self creatPointWithArray:PointArray];
        
        
    [_delegate delegateDeletePoint];
    }
}
#pragma mark -------删除相对应的控制点----------
- (void)replaceControlPointArrayWith:(NSArray *)array andIndex:(NSInteger)index{
    NSMutableArray * tempArray = [NSMutableArray new];
    for (NSArray * arr in array) {
        for (NSValue * value in arr) {
            [tempArray addObject:value];
        }
    }
    [tempArray removeObjectsInRange:NSMakeRange(index * 2 - 1, 2)];
    
    
    for (int i = 0; i< tempArray.count; i++) {
        if (i % 2 == 0) {
            NSMutableArray * array1 = [[NSMutableArray alloc]init];
            [array1 addObject:tempArray[i]];
            [array1 addObject:tempArray[i + 1]];
            [ControlPointArray addObject:array1];
        }
    }
    
//    tempArray removeObject
//    NSLog(@"%@", tempArray);
}

#pragma mark ---建立拖动的方法---
- (void)createDragMethod:(UIPanGestureRecognizer *)pan{
    
    [self getInitData];
    
    CGPoint po = [pan translationInView:self];
    
    static CGPoint center;
    static CGPoint control1;
    static CGPoint control2;
    
    static CGFloat control1DistanceX;
    static CGFloat control2DistanceX;
    static CGFloat conrtol1DistanceY;
    static CGFloat control2DistanceY;
    

    if (pan.state == UIGestureRecognizerStateEnded) {

        sendTimer.fireDate = [NSDate distantFuture];
        [self.delegate touchEndChangeTime];
        
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        sendTimer.fireDate = [NSDate distantPast];

        center = pan.view.center;
        if (pan.view.tag - 100 == 0) {
            control1 = [ControlPointArray[pan.view.tag - SliderTag][0] CGPointValue];
            control1DistanceX = center.x - control1.x;
            conrtol1DistanceY = center.y - control1.y;
            
        }
        else if (pan.view.tag - 100 > 0&& pan.view.tag - SliderTag < ControlPointArray.count){
            
            control1 = [ControlPointArray[pan.view.tag - SliderTag][0] CGPointValue];
            control2 = [ControlPointArray[pan.view.tag - SliderTag - 1][1] CGPointValue];
            
            control1DistanceX = center.x - control1.x;
            control2DistanceX = control2.x - center.x;
            conrtol1DistanceY = center.y - control1.y;
            control2DistanceY = center.y - control2.y;
            
        }else{
            control2 = [ControlPointArray[pan.view.tag - SliderTag - 1][1] CGPointValue];
            control2DistanceX = control2.x - center.x;
            control2DistanceY = center.y - control2.y;
        }
        
    }
    pan.view.center = CGPointMake(center.x + po.x, center.y+po.y);


#pragma mark ----限制大条件----
    [self LimitingConditionAction:pan.view andCenter:center andPoCenter:po];
    
    iFPointView * pv1;
    iFPointView * pv2;
    
#pragma mark --限制两点之间的距离--
    if (pan.view.tag == SliderTag) {
        pv2 = (iFPointView *)[self viewWithTag:pan.view.tag + 1];
        
//        if (pan.view.center.x >= pv2.center.x - LimitDistance) {
        
            pan.view.center = CGPointMake(topleft, center.y+po.y);
            
//        }
        
    }else if(pan.view.tag == SliderTag + PointArray.count - 1){
        pv1 = (iFPointView *)[self viewWithTag:pan.view.tag - 1];
//        if (pan.view.center.x <= pv1.center.x + LimitDistance) {
            pan.view.center = CGPointMake(topright, center.y+po.y);
//        }
        
    }else{
        pv1 = (iFPointView *)[self viewWithTag:pan.view.tag - 1];
        pv2 = (iFPointView *)[self viewWithTag:pan.view.tag + 1];
        CGPoint leftControlPoint = [ControlPointArray[pan.view.tag - SliderTag - 1][0] CGPointValue];
        CGPoint rightControlPoint = [ControlPointArray[pan.view.tag - SliderTag][1] CGPointValue];
//                NSLog(@"ControlArray=%@", ControlPointArray);
//                NSLog(@"1 = %@", NSStringFromCGPoint(leftControlPoint));
//                NSLog(@"2 = %@", NSStringFromCGPoint(rightControlPoint));
        if (pan.view.center.x <= pv1.center.x + LimitDistance) {
            pan.view.center = CGPointMake(pv1.center.x + LimitDistance, center.y+po.y);
        }
        
        if (pan.view.center.x >= pv2.center.x - LimitDistance) {
            pan.view.center = CGPointMake(pv2.center.x - LimitDistance, center.y+po.y);
        }
        
        if (pan.view.center.x <= leftControlPoint.x) {
            pan.view.center = CGPointMake(leftControlPoint.x, center.y + po.y);
        }
        if(pan.view.center.x >= rightControlPoint.x){
            pan.view.center = CGPointMake(rightControlPoint.x , center.y + po.y);
        }
        
      
    }
    if (pan.view.center.y >= topdown) {
        pan.view.center = CGPointMake(pan.view.center.x, topdown);
    }
    if (pan.view.center.y <= topup) {
        pan.view.center = CGPointMake(pan.view.center.x, topup);
    }
    
    

#pragma mark -----
    
    [self createBackGround];
    
    
//    NSLog(@"C1X = %f", pan.view.center.x - control1DistanceX);
//    NSLog(@"C1Y = %f", pan.view.center.y - conrtol1DistanceY);
//    NSLog(@"C2X = %f", pan.view.center.x + control2DistanceX);
//    NSLog(@"C2Y = %f", pan.view.center.y - control2DistanceY);
//    
    CGFloat C1X, C1Y, C2X, C2Y;
    C1X = pan.view.center.x - control1DistanceX;
    C1Y = pan.view.center.y - conrtol1DistanceY;
    C2X = pan.view.center.x + control2DistanceX;
    C2Y = pan.view.center.y - control2DistanceY;
    if (C1Y <= topup) {
        C1Y = topup;
    }
    if (C1Y >= topdown) {
        C1Y = topdown;
    }
    
    if (C2Y <= topup) {
        C2Y = topup;
    }
    if (C2Y >= topdown) {
        C2Y = topdown;
    }
    
    
    
    
    
    if (pan.view.tag - SliderTag == 0) {
        
        CGPoint nextPoint = [PointArray[pan.view.tag - SliderTag + 1]CGPointValue];
        
        if (C1X >= nextPoint.x - LimitControlDistance) {
            C1X = nextPoint.x - LimitControlDistance;
        }
        [ControlPointArray[pan.view.tag - SliderTag] replaceObjectAtIndex:0 withObject:Point(C1X, C1Y)];
        
    }
    else if (pan.view.tag - SliderTag > 0&& pan.view.tag - SliderTag < ControlPointArray.count){

        CGPoint nextPoint = [PointArray[pan.view.tag - SliderTag + 1] CGPointValue];
        CGPoint lastPoint = [PointArray[pan.view.tag - SliderTag - 1] CGPointValue];

//
        
        if (C1X >= nextPoint.x - LimitControlDistance) {
            C1X = nextPoint.x - LimitControlDistance;

        }

        if (C2X <= lastPoint.x + LimitControlDistance) {
            C2X = lastPoint.x + LimitControlDistance;
        }
        [ControlPointArray[pan.view.tag - SliderTag] replaceObjectAtIndex:0 withObject:Point(C1X, C1Y)];
        [ControlPointArray[pan.view.tag - SliderTag - 1] replaceObjectAtIndex:1 withObject:Point(C2X, C2Y)];
        
        
    }else{
        CGPoint lastPoint = [PointArray[pan.view.tag - SliderTag - 1] CGPointValue];

        if (C2X <= lastPoint.x + LimitControlDistance) {
            C2X = lastPoint.x + LimitControlDistance;
            
        }
        [ControlPointArray[pan.view.tag - SliderTag - 1] replaceObjectAtIndex:1 withObject:Point(C2X, C2Y)];
    }
    
    YmoveValue = pan.view.center.y;
    XmoveValue = pan.view.center.x;
    
#warning yidongguo
    [PointArray replaceObjectAtIndex:pan.view.tag - 100 withObject:Point(pan.view.center.x, pan.view.center.y)];

    
    [self createMovedControlWithTag:pan.view.tag];
    [self refreshPoint];
    [self createInitializationCurve:PointArray];
    
    NSArray * configs = @[@"24fps", @"25fps", @"30fps", @"50fps", @"60fps"];
    NSInteger fpsValue = [configs[All_fpsIndex] integerValue];
    UInt32 TotalFrames;
    if (self.ifmodel.displayUnit == 1) {
        TotalFrames = (UInt32)(fpsValue * All_TimelaspseTotaltimes);
        
    }else{
        TotalFrames = (UInt32)All_Frames;
    }
    
    if (All_FunctionMode == 1) {
        TotalFrames = All_TotalTimes;
        
    }
    
//    NSLog(@"=====================================");
//    NSLog(@"%@", [NSString stringWithFormat:@"%.0f", XmoveValue / self.frame.size.width * TotalFrames]);
//    NSLog(@"%@", [NSString stringWithFormat:@"%.1f", (self.frame.size.height - YmoveValue) / self.frame.size.height * (self.ifmodel.upSliderValue - self.ifmodel.downSliderValue) + self.ifmodel.downSliderValue]);
//    
//    NSLog(@"%lf", XmoveValue);
//    NSLog(@"%lf", YmoveValue);
    
    NSString * xvalueStr = [NSString stringWithFormat:@"%.0f", XmoveValue / self.frame.size.width * TotalFrames];
    NSString * yvalueStr;
    
    if (self.tag == 1) {
        yvalueStr = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - YmoveValue) / self.frame.size.height * (All_upSliderValue - All_downSliderValue) + All_downSliderValue];
        
    }else if(self.tag == 2){
        yvalueStr = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - YmoveValue) / self.frame.size.height * (All_upPanValue - All_downPanValue) + All_downPanValue];
    }else if(self.tag == 3){
        yvalueStr = [NSString stringWithFormat:@"%.1f", (self.frame.size.height - YmoveValue) / self.frame.size.height * (All_upTiltValue - All_downTiltValue) + All_downTiltValue];
    }
    
    NSLog(@"%@ %@",xvalueStr, yvalueStr);
    
    [_delegate showXvalueStr:xvalueStr andYvalueStr:yvalueStr];
    
//    NSLog(@"=====================================");

    
    
}
#pragma mark - 限制大条件 --
-(void)LimitingConditionAction:(UIView *)view andCenter:(CGPoint)center andPoCenter:(CGPoint)po{
    
//    NSLog(@"L = %f, Up = %f, down = %f, R = %f", topleft, topup, topdown, topright);
    
    if (view.center.x <= topleft) {
        view.center = CGPointMake(topleft, center.y+po.y);
        if (view.center.y <= topup) {
            view.center = CGPointMake(topleft, topup);
        }
        if (view.center.y >= topdown) {
            view.center = CGPointMake(topleft, topdown);
        }

    }
    if (view.center.x >= topright) {
        view.center = CGPointMake(topright, center.y+po.y);
        if (view.center.y <= topup) {
            view.center = CGPointMake(topright, topup);
        }
        if (view.center.y >= topdown) {
            view.center = CGPointMake(topright, topdown);
        }
    }
    if (view.center.y <= topup) {
        view.center = CGPointMake(center.x + po.x, topup);
    }
    if (view.center.y >= topdown) {
        view.center = CGPointMake(center.x + po.x, topdown);
    }
    
    if (view.center.x <= topleft && view.center.y <= topup) {
        view.center = CGPointMake(topleft, topup);
        
    }
    if (view.center.x <= topleft && view.center.y >= topdown) {
        view.center = CGPointMake(topleft, topdown);
    }
    if (view.center.x >= topright && view.center.y <= topup) {
        view.center = CGPointMake(topright, topup);
    }
    if (view.center.x >= topright && view.center.y >= topdown) {
        view.center = CGPointMake(topright, topdown);
    }
}

- (void)loopSendData{
    //NSLog(@"一秒一次");
    [_delegate moveRealTimePreViewPointY:YmoveValue andPointX:XmoveValue andHeight:self.frame.size.height andWidth:self.frame.size.width];
}

#pragma mark ---创建可拖动控制点---
- (void)createMovedControlWithTag:(NSInteger)tag{
    
    
    iFPointView * pvcenter = [self viewWithTag:tag];
    
    [controlShaper removeFromSuperlayer];
    controlBezier = [UIBezierPath bezierPath];

    CGPoint leftControlPoint = {0, 0},rightControlPoint = {0 , 0};
    
    if (tag > SliderTag && tag < PointArray.count - 1 + SliderTag) {
        
        left = (tag-SliderTag)*2+1000;
        right = (tag-SliderTag)*2+1001;
        leftControlPoint = [ControlPointArray[tag - SliderTag - 1][1] CGPointValue];
        rightControlPoint = [ControlPointArray[tag - SliderTag][0] CGPointValue];
        
        /*画线 · ———————————— ·*/
//        [controlBezier moveToPoint:pvcenter.center];
//        [controlBezier addLineToPoint:leftControlPoint];
//        [controlBezier addLineToPoint:rightControlPoint];
        
        /*创建 左右可视控制点*/
        iFPointView * pv1 = [self viewWithTag:LeftControlTag];
        if (!pv1) {
            pv1 = [[iFPointView alloc]initWithFrame:CGRectZero WithCenter:leftControlPoint WithColor:[UIColor redColor]];
            [pv1 addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueControl:)]];
            pv1.tag = LeftControlTag;
            [self addSubview:pv1];
            
        }else{
            pv1.center = leftControlPoint;
        }
        iFPointView * pv2 = [self viewWithTag:RightControlTag];
        if (!pv2) {
            pv2 = [[iFPointView alloc]initWithFrame:CGRectZero WithCenter:rightControlPoint WithColor:[UIColor redColor]];
            [pv2 addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueControl:)]];
            [self addSubview:pv2];
            pv2.tag = RightControlTag;
        }else{
            pv2.center = rightControlPoint;
        }
        
    }else if(tag == SliderTag){
        
        right = (tag - SliderTag) * 2 + 1001;
        rightControlPoint = [ControlPointArray[tag - SliderTag][0] CGPointValue];
        iFPointView * pv2 = [self viewWithTag:1000];
        if (!pv2) {
            pv2 = [[iFPointView alloc]initWithFrame:CGRectZero WithCenter:rightControlPoint WithColor:[UIColor redColor]];
            [pv2 addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueControl:)]];
            [self addSubview:pv2];
            pv2.tag = RightControlTag;
        }else{
            pv2.center = rightControlPoint;
        }
        iFPointView * pv1 = [self viewWithTag:1001];
        if (pv1) {
            [pv1 removeFromSuperview];
            
        }else{
            
        }
        
    }else{
        left = (tag-100)*2+1000;
        leftControlPoint = [ControlPointArray[tag - SliderTag - 1][1] CGPointValue];
        iFPointView * pv1 = [self viewWithTag:LeftControlTag];
        if (!pv1) {
            pv1 = [[iFPointView alloc]initWithFrame:CGRectZero WithCenter:leftControlPoint WithColor:[UIColor redColor]];
            [pv1 addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeValueControl:)]];
            pv1.tag = LeftControlTag;
            [self addSubview:pv1];
        }else{
            pv1.center = leftControlPoint;
        }
        iFPointView * pv2 = [self viewWithTag:RightControlTag];
        if (pv2) {
            [pv2 removeFromSuperview];
            
        }
        else{
        }
    }
    iFPointView * pv1 = [self viewWithTag:LeftControlTag];
    iFPointView * pv2 = [self viewWithTag:RightControlTag];
    
    
//    NSLog(@"PV1 = %@,\r\n PV2 = %@", pv1, pv2);
    
    if (pv1) {
        [controlBezier moveToPoint:pvcenter.center];
        [controlBezier addLineToPoint:leftControlPoint];
    }
    if (pv2) {
        [controlBezier moveToPoint:pvcenter.center];
        [controlBezier addLineToPoint:rightControlPoint];
        
    }
//
    controlShaper = [CAShapeLayer layer];
    controlShaper.strokeColor = [UIColor whiteColor].CGColor;
    controlShaper.fillColor = [UIColor clearColor].CGColor;
    controlShaper.lineWidth = 1;
    controlShaper.path = controlBezier.CGPath;
    [self.layer addSublayer:controlShaper];
}
- (void)hideControlPointAndLine{
    
    [controlShaper removeFromSuperlayer];
    iFPointView * pv1 = [self viewWithTag:LeftControlTag];
    iFPointView * pv2 = [self viewWithTag:RightControlTag];
    [pv1 removeFromSuperview];
    [pv2 removeFromSuperview];
}

- (void)changeValueControl:(UIPanGestureRecognizer *)pan{
    
    NSInteger sum = 0;
    sum = pan.view.tag;
    if (pan.view.tag == RightControlTag) {
        sum = right;
    }else{
        sum = left;
    }
    /**
     *  sum 根据sum确定哪一个controlPoint
     *  index 具体的哪一个下标
     */
    NSInteger a = sum - 1000;
    
    NSInteger index = a / 2;
    iFPointView * pv1 = (iFPointView *)[self viewWithTag:LeftControlTag];
    iFPointView * pv2 = (iFPointView *)[self viewWithTag:RightControlTag];
    iFPointView * pvCenter = (iFPointView *)[self viewWithTag:SliderTag + index];
    static CGPoint p1;
    static CGPoint p2;
    
    
    CGPoint po = [pan translationInView:self];
    static CGPoint center;
    if (pan.state == UIGestureRecognizerStateBegan) {
        center = pan.view.center;
        
        p2 = pv2.center;
        p1 = pv1.center;
    }
#pragma mark ----限制条件
    

    pan.view.center = CGPointMake(center.x + po.x, center.y+po.y);
    [self LimitingConditionAction:pan.view andCenter:center andPoCenter:po];
    
#pragma mark -----
    /**
     *  m
     *  n
     //根据m，n 判断哪一个是操作的控制点
     *  k
     *  p
     //根据k，p 判断哪一个是被动操作的控制点
     */

    
#pragma mark 根据tag 找规律
    NSInteger m, n, k, p;
    if (a % 2 == 0) {
        m  = a / 2 - 1;
        n  = a % 2 + 1;
        
        k = m + 1;
        p = n - 1;
        
        
    }else{
        
        m = a / 2;
        n = a % 2 - 1;
        
        k = m - 1;
        p = n + 1;
    }
    
#pragma mark ---三点一线----
    
    
    CGFloat leftX = 0.0;
    CGFloat centerX = 0.0;
    CGFloat rightX = 0.0;
    centerX = [PointArray[index] CGPointValue].x;
    if (index > 0 && index < PointArray.count - 1) {
        leftX = [PointArray[index - 1] CGPointValue].x;
        rightX = [PointArray [index + 1] CGPointValue].x;
//        NSLog(@"LCR%lf, %lf, %lf", leftX, centerX, rightX);
    }else if (index == 0){
        rightX = [PointArray [index + 1] CGPointValue].x;
        
    }else if (index == PointArray.count - 1){
        leftX = [PointArray[index - 1] CGPointValue].x;
    }
    
    //
    if (pan.view.tag == 1001) {
        /**
         *  限制左边的控制点到中心点的距离, 如果是数组中的最后一个点只能调整x
         */
        
        if (index == PointArray.count - 1) {
            
            pan.view.center = CGPointMake(center.x + po.x, center.y);
            if (pvCenter.center.x - pan.view.center.x <= LimitControlDistance) {
                
//                NSLog(@"centerY  = %f ", center.y);
                pan.view.center = CGPointMake(pvCenter.center.x - LimitControlDistance, center.y);
            }
            if (pan.view.center.x - leftX <= LimitControlDistance) {
                
                pan.view.center = CGPointMake(leftX + LimitControlDistance, center.y);
            }
        }else{
            
            if (pvCenter.center.x - pan.view.center.x <= LimitControlDistance) {
                pan.view.center = CGPointMake(pvCenter.center.x - LimitControlDistance, center.y + po.y);
                if (center.y + po.y < topup) {
                    pan.view.center = CGPointMake(pvCenter.center.x - LimitControlDistance, topup);
                }
                if (center.y + po.y > topdown) {
                    pan.view.center = CGPointMake(pvCenter.center.x - LimitControlDistance, topdown);
                }
            }
            if (pan.view.center.x - leftX <= LimitControlDistance) {
                pan.view.center = CGPointMake(leftX + LimitControlDistance, center.y+po.y);
             
                if (center.y + po.y < topup) {
                    pan.view.center = CGPointMake(leftX + LimitControlDistance, topup);
                }
                if (center.y + po.y > topdown) {
                    pan.view.center = CGPointMake(leftX + LimitControlDistance, topdown);
                }

            }
        }
        
        r =  powf(powf((pvCenter.center.x - pv2.center.x), 2) + powf((pvCenter.center.y - pv2.center.y), 2), 0.5);
        tana = (pan.view.center.y - pvCenter.center.y) / (pan.view.center.x - pvCenter.center.x);
        px = (tana * r) / powf(powf(tana, 2) + 1, 0.5);
        py = r / powf(powf(tana, 2) + 1, 0.5);
        
        if (pan.view.center.x <= pvCenter.center.x) {
            CGFloat xpx, ypy;
            xpx = pvCenter.center.x + py;
            ypy = pvCenter.center.y + px;
            if (ypy <= topup) {
                ypy = topup;
            }
            if (ypy >= topdown) {
                ypy = topdown;
            }
            pv2.center = CGPointMake( xpx, ypy);
//            pv2.center = CGPointMake( pvCenter.center.x + py, pvCenter.center.y + px);
            
        }
        else{
           
            pv2.center = CGPointMake( pvCenter.center.x - py, pvCenter.center.y - px);
            
        }
        
    }else{
        /**
         *  限制右边的控制点到中心点的距离， 如果是数组的第一个点也只能调整x
         */
        if (index == 0) {
            pan.view.center = CGPointMake(center.x + po.x, center.y);

            if ( pan.view.center.x - pvCenter.center.x  <= LimitControlDistance) {
                pan.view.center = CGPointMake(pvCenter.center.x + LimitControlDistance, center.y);
            }
            if (rightX - pan.view.center.x <= LimitControlDistance) {
                pan.view.center = CGPointMake(rightX - LimitControlDistance, center.y);
            }
        }else{
            if (pan.view.center.x - pvCenter.center.x <= LimitControlDistance) {
                pan.view.center = CGPointMake(pvCenter.center.x + LimitControlDistance, center.y + po.y);
                if (center.y + po.y < topup) {
                    pan.view.center = CGPointMake(pvCenter.center.x + LimitControlDistance, topup);
                }
                if (center.y + po.y > topdown) {
                    pan.view.center = CGPointMake(pvCenter.center.x + LimitControlDistance, topdown);
                }
            }
            if (rightX - pan.view.center.x <= LimitControlDistance) {
                pan.view.center = CGPointMake(rightX - LimitControlDistance, center.y + po.y);
                if (center.y + po.y < topup) {
                    pan.view.center = CGPointMake(rightX - LimitControlDistance, topup);
                }
                if (center.y + po.y > topdown) {
                    pan.view.center = CGPointMake(rightX - LimitControlDistance, topdown);
                }

            }
        }
        
        r =  powf(powf((pvCenter.center.x - pv1.center.x), 2) + powf((pvCenter.center.y - pv1.center.y), 2), 0.5);
        tana = (pan.view.center.y - pvCenter.center.y) / (pan.view.center.x - pvCenter.center.x);
        px = (tana * r) / powf(powf(tana, 2) + 1, 0.5);
        py = r / powf(powf(tana, 2) + 1, 0.5);
        
        
        if (pan.view.center.x <= pvCenter.center.x) {
            
            pv2.center = CGPointMake( pvCenter.center.x + py, pvCenter.center.y + px);

        }
        else{
            CGFloat xpx, ypy;
            xpx = pvCenter.center.x - py;
            ypy = pvCenter.center.y - px;
            if (ypy <= topup) {
                ypy = topup;
            }
            if (ypy >= topdown) {
                ypy = topdown;
            }
            pv1.center = CGPointMake( xpx, ypy);
//          pv1.center = CGPointMake( pvCenter.center.x - py, pvCenter.center.y - px);
        }
    }

    
#pragma mark -限制如果在两点之间才能上下旋转控制点 否则只能水平移---
    iFPointView * leftView;
    iFPointView * centerView;
    iFPointView * rightView;
    
    if (index> 0 && index < PointArray.count - 1) {
//        NSLog(@"index ===  %ld", (long)index);
        leftView = (iFPointView *)[self viewWithTag:SliderTag + index - 1];
        centerView = (iFPointView *)[self viewWithTag:SliderTag + index];
        rightView = (iFPointView *)[self viewWithTag:SliderTag + index + 1];
        
        if ((leftView.center.y > centerView.center.y && centerView.center.y > rightView.center.y)|| (leftView.center.y < centerView.center.y && centerView.center.y < rightView.center.y)) {
            
        }else{
            pan.view.center = CGPointMake(pan.view.center.x, centerView.center.y);
            if (pan.view.tag == 1001) {
                pv2.center = CGPointMake(p2.x, p2.y);
            }else{
                pv1.center = CGPointMake(p1.x, p1.y);
            }
        }
    }
    
    
    /*画线 · ———————————— ·*/
    [controlShaper removeFromSuperlayer];
    controlBezier = [UIBezierPath bezierPath];
    
    if (pv1) {
        [controlBezier moveToPoint:pvCenter.center];
        [controlBezier addLineToPoint:pv1.center];
    }
    if (pv2) {
        [controlBezier moveToPoint:pvCenter.center];
        [controlBezier addLineToPoint:pv2.center];
    }

//    NSLog(@"1 = %@,2 =  %@", pv1, pv2);
    
    
//    NSLog(@"%@ %@", NSStringFromCGPoint(pv1.center), NSStringFromCGPoint(pv2.center));
    
    controlShaper = [CAShapeLayer layer];
    controlShaper.strokeColor = [UIColor whiteColor].CGColor;
    controlShaper.fillColor = [UIColor clearColor].CGColor;
    controlShaper.lineWidth = 1;
    controlShaper.path = controlBezier.CGPath;
    [self.layer addSublayer:controlShaper];
#pragma mark ==============
    //    [ControlPointArray[m - 2] replaceObjectAtIndex:1 withObject:Point(pan.view.center.x, pan.view.center.y)];
    
    if (a == 1) {
        
        [ControlPointArray[m] replaceObjectAtIndex:n withObject:Point(pan.view.center.x, pan.view.center.y)];
    }else if (a == ControlPointArray.count * 2){
        
        [ControlPointArray[m] replaceObjectAtIndex:n withObject:Point(pan.view.center.x, pan.view.center.y)];
        
    }else{
        [ControlPointArray[m] replaceObjectAtIndex:n withObject:Point(pan.view.center.x, pan.view.center.y)];
        if (pan.view.tag == 1001) {
            [ControlPointArray[k] replaceObjectAtIndex:p withObject:Point(pv2.center.x, pv2.center.y)];
        }
        else{
            [ControlPointArray[k] replaceObjectAtIndex:p withObject:Point(pv1.center.x, pv1.center.y)];
            
        }
    }
    [self createBackGround];
    [self refreshPoint];
    [self createInitializationCurve:PointArray];
    
}



-(void)refreshPoint{
    for (int i = 0; i < PointArray.count; i++) {
        iFPointView *  pv = [self viewWithTag:i+SliderTag];
        [self bringSubviewToFront:pv];
        
    }
    iFPointView *pv1 = [self viewWithTag:RightControlTag];
    [self bringSubviewToFront:pv1];
    iFPointView *pv2 = [self viewWithTag:LeftControlTag];

    
    [self bringSubviewToFront:pv2];
    [self bringSubviewToFront:insertView];

}


#pragma mark --根据点创建控制点----
- (void)createControlPointArray:(NSArray *)pointArray
{
    
    CGFloat controlx1;
    CGFloat controly1;
    CGFloat controlx2;
    CGFloat controly2;
    for (int i = 0 ; i < pointArray.count; i++) {
        
        if (i > 0) {
            NSMutableArray * array1 = [[NSMutableArray alloc]init];
            
            controlx1 = ([pointArray[i - 1] CGPointValue].x) + ControlDistance;
            controly1 = ([pointArray[i - 1] CGPointValue].y);
            controlx2 = ([pointArray[i] CGPointValue].x) - ControlDistance;
            controly2 = ([pointArray[i] CGPointValue].y);
            [array1 addObject:Point(controlx1, controly1)];
            [array1 addObject:Point(controlx2, controly2)];
            [ControlPointArray addObject:array1];
            
        }
    }
//    NSLog(@"ControlArray = %@", ControlPointArray);
}

#pragma mark ---在数组中插入点---
- (void)insertPoint:(CGFloat)x andInsertIndex:(NSInteger)inIndex andYdistance:(CGFloat)y{
    
    
    
    NSLog(@"%ld", self.insertIndex);
    
    CGPoint lastPoint, nextPoint, lastControlPoint, nextControlPoint;
    if (inIndex == 9999) {
        [_delegate showAccordingToWarningWithMode:0];
        
        return;
    }
    lastControlPoint = [ControlPointArray[inIndex - 1][0] CGPointValue];
    nextControlPoint = [ControlPointArray[inIndex- 1][1] CGPointValue];
    
    lastPoint = [PointArray[inIndex - 1] CGPointValue];
    nextPoint = [PointArray[inIndex] CGPointValue];
    
    if (lastPoint.x + LimitDistance >= x || nextPoint.x - LimitDistance <= x || lastControlPoint.x >= x || nextControlPoint.x <= x) {
        [_delegate showAccordingToWarningWithMode:0];
        
    }else{
    
    [self createBackGround];
    

    
    if (inIndex == 9999) {
        [self addPoint:CGPointMake(x, y)];
        
    }else{

        [self insertPoint:CGPointMake(x, y) andIndex:inIndex];

    }
    /**
     *  插入测试
     *
     *  @param 180 插入点的x值
     *  @param 100 插入点的y值
     *  @param 2   插入点在数组中需要插入的位置
     *
     *  @return nil
     */
    //    [self insertPoint:CGPointMake(180, 100) andIndex:3];
    
    [self refreshPoint];
    [self createInitializationCurve:PointArray];
    }

}
#pragma mark ---在数组中添加点---

/**
 添加关键帧 在前后

 @param point point description
 */
- (void)addPoint:(CGPoint)point {
    
    iFPointView * pv1 = (iFPointView *)[self viewWithTag: PointArray.count + SliderTag - 1];
    CGFloat controlx1;
    CGFloat controly1;
    CGFloat controlx2;
    CGFloat controly2;
    controlx1 = pv1.center.x + ControlDistance;
    controly1 = pv1.center.y;
    controlx2 = point.x + ControlDistance;
    controly2 = point.y;
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [array addObject:Point(controlx1, controly1)];
    [array addObject:Point(controlx2, controly2)];
    
    
    [ControlPointArray addObject:array];
    [ControlPointArray[PointArray.count - 1] replaceObjectAtIndex:1 withObject:Point(point.x - ControlDistance, point.y)];
    [PointArray addObject:Point(point.x, point.y)];
    for (int i = 0; i < PointArray.count; i++) {
//        NSLog(@"%ld", (unsigned long)PointArray.count);
        iFPointView *  pv = [self viewWithTag:i+SliderTag];
        pv.tag = SliderTag+i;
        [self bringSubviewToFront:pv];
    }
    
    iFPointView *  pv = [[iFPointView alloc]initWithFrame:CGRectZero WithCenter:point WithColor:PointCOLOR];
    pv.tag = SliderTag + PointArray.count - 1;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lalalala:)];
    tapGesture.numberOfTapsRequired = 2;
    
    [pv addGestureRecognizer:tapGesture];
    [pv addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(createDragMethod:)]];
    [self addSubview:pv];
    
}

/**
 插入中间关键帧

 @param point point description
 @param m 关键帧所在下标
 */
-(void)insertPoint:(CGPoint)point andIndex:(NSInteger)m{
    
    iFPointView * pv1 = (iFPointView *)[self viewWithTag: 100 + m];
    
    CGFloat controlx1;
    CGFloat controly1;
    CGFloat controlx2;
    CGFloat controly2;
    
    controlx1 = pv1.center.x - ControlDistance;
    controly1 = pv1.center.y;
    
    controlx2 = point.x + ControlDistance;
    controly2 = point.y;
//    NSLog(@" ===  %f", point.x);

    for (int i = 0; i < PointArray.count; i++) {
        if (i >= m) {
            iFPointView *  pv = [self viewWithTag:i+SliderTag];
            pv.tag = SliderTag+i+1;
            [self bringSubviewToFront:pv];
        }
    }
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [array addObject:Point(controlx2, controly2)];
    [array addObject:Point(controlx1, controly1)];
    [PointArray insertObject:Point(point.x, point.y) atIndex:m];
    
    
    [ControlPointArray insertObject:array atIndex:m];
    [ControlPointArray[m - 1] replaceObjectAtIndex:1 withObject:Point(point.x - ControlDistance, point.y)];
    
    iFPointView *  pv = [[iFPointView alloc]initWithFrame:CGRectZero WithCenter:point WithColor:PointCOLOR];
    pv.tag = SliderTag + m;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lalalala:)];
    tapGesture.numberOfTapsRequired = 2;
    
    [pv addGestureRecognizer:tapGesture];
    [pv addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(createDragMethod:)]];
    [self addSubview:pv];
}

#pragma mark ---创建曲线---
- (void)createInitializationCurve:(NSArray *)pointArray{
    
//    [shapeLayer removeFromSuperlayer];
    NSLog(@"++++++++++++++++++++++++++++");
    for (int i = 0; i < pointArray.count; i++) {
        
        if (i > 0 ) {
            bezierPath = [UIBezierPath bezierPath];
            
            [bezierPath moveToPoint:[pointArray[i - 1] CGPointValue]];
            [bezierPath addCurveToPoint:[pointArray[i] CGPointValue] controlPoint1:[ControlPointArray[i - 1][0] CGPointValue ] controlPoint2:[ControlPointArray[i - 1][1] CGPointValue ]];
            
            shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = self.StorkeColor.CGColor;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.lineWidth = LineWidth;
            shapeLayer.path = bezierPath.CGPath;
            shapeLayer.lineCap = kCALineCapSquare;
            [CurvebackGroundView.layer addSublayer:shapeLayer];
        }
    }
}



#pragma mark ---建立直接坐标系---
- (void)createRectangularCoordinates{
    
//    NSLog(@"SB%f %f", self.frame.size.width, self.frame.size.height);
    
    UILabel * xLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 3)];
    xLabel.backgroundColor = [UIColor whiteColor];
    UILabel * yLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 3, self.frame.size.height)];
    yLabel.backgroundColor = [UIColor whiteColor];
    UILabel * Xlabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 3, 0, 3, self.frame.size.height)];
    Xlabel.backgroundColor = [UIColor whiteColor];
    UILabel * Ylabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 3, self.frame.size.width - 3, 3)];
    Ylabel.backgroundColor = [UIColor whiteColor];
//
    topleft = 0;
    topright = self.frame.size.width;
    topdown = self.frame.size.height;
    topup = 0;
    startPoint = CGPointMake(topleft, topdown);
    endPoint = CGPointMake( topright, topdown);
    
}
- (void)createBackGround{
    [CurvebackGroundView removeFromSuperview];
    CurvebackGroundView = [[UIView alloc]initWithFrame:self.bounds];
    CurvebackGroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:CurvebackGroundView];
}

- (void)chooseValue:(UIPanGestureRecognizer *)pan{
    [self refreshPoint];
    CGPoint po = [pan translationInView:self];
    
    static CGPoint center;
    if (pan.state == UIGestureRecognizerStateBegan) {
        center= pan.view.center;
    }
    pan.view.center = CGPointMake(center.x + po.x, center.y);
    if (pan.view.center.x < topleft) {
        pan.view.center = CGPointMake(topleft, center.y);
    }
    if (pan.view.center.x > topright) {
        pan.view.center = CGPointMake(topright, center.y);
    }
    
    CGPoint point1;
    CGPoint point2;
    for (int i = 0 ; i < PointArray.count; i++) {
        if (i < PointArray.count - 1) {
            point1 = [PointArray[i] CGPointValue];
            point2 = [PointArray[i + 1] CGPointValue];
            if (point1.x < pan.view.center.x && point2.x > pan.view.center.x) {
                insertIndex = i + 1;
                XValue = pan.view.center.x;
            }
        }else{
            point1 = [PointArray[i] CGPointValue];
            if (pan.view.center.x > point1.x) {
                insertIndex = 9999;
                XValue = pan.view.center.x;
            }
        }
    }
    
    
    
//    NSLog(@"index====%ld", insertIndex);
    
}


@end
