//
//  iFS1A3_TimelineViewController.h
//  iFootage
//
//  Created by 黄品源 on 2018/1/22.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import "iFRootViewController.h"
#import "iF3DButton.h"

enum MODEl_AXLE {
    MODEL_SLIDER = 0,
    MODEL_PAN,
    MODEL_TILT,
} ;
enum ConnectionS1A3_Status{
    
    StatusSLIDEandX2AllConnected = 0,
    StatusSLIDEOnlyConnected,
    StatusX2OnlyConnected,
    StatusSLIDEandX2AllDisConnected,
};



@interface iFS1A3_TimelineViewController : iFRootViewController

@property     enum ConnectionS1A3_Status status;



@property (nonatomic, strong)iF3DButton * SliderBtn;
@property (nonatomic, strong)iF3DButton * PanBtn;
@property (nonatomic, strong)iF3DButton * TiltBtn;
@property (nonatomic, assign)BOOL isSaveData;
@property (nonatomic, assign)NSInteger indexRow;
@property     enum MODEl_AXLE MODEL;


@end
