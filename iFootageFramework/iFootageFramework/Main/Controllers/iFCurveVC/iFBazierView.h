//
//  iFBazierView.h
//  iFootage
//
//  Created by 黄品源 on 16/8/4.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFPointView.h"
#import "iFInsertView.h"
#import "iFModel.h"
#import "iFS1A3_Model.h"



@protocol previewMoveDelegate <NSObject, UIGestureRecognizerDelegate>

- (void)moveRealTimePreViewPointY:(CGFloat)Y andPointX:(CGFloat)X andHeight:(CGFloat)Height andWidth:(CGFloat)Width;
- (void)touchEndChangeTime;

- (void)showXvalueStr:(NSString *)xstr andYvalueStr:(NSString *)ystr;

/**
 展示提示

 @param mode 0 -> 添加错误关键帧提示
 @parma mode 1 -> 删除关键帧错误提示
 
 */
- (void)showAccordingToWarningWithMode:(NSInteger)mode;


- (void)delegateDeletePoint;



@end


@interface iFBazierView : UIView


@property CGPoint startPoint;
@property CGPoint endPoint;

@property CGFloat topleft;
@property CGFloat topright;
@property CGFloat topdown;
@property CGFloat topup;

@property (nonatomic, strong)UIColor * StorkeColor;
@property (nonatomic, strong)NSMutableArray * PointArray;//可视点数组
@property (nonatomic, strong)NSMutableArray * ControlPointArray;//控制点数组
@property (nonatomic, strong)CAShapeLayer *  shapeLayer;
@property (nonatomic, strong)UIBezierPath * bezierPath;

@property (nonatomic, strong)UIView * CurvebackGroundView;//背景视图
@property (nonatomic, strong)iFInsertView * insertView;
@property (nonatomic, strong)iFModel * ifmodel;
@property (nonatomic, strong)iFS1A3_Model * S1A3_Model;


@property (nonatomic, strong)NSTimer * countTimer;


@property NSInteger right;
@property NSInteger left;
@property float r, tana, px, py;//r 被动移动之前的半径， tana 实时变化的角度  px 被动改变的x距离 py 被动改变的y距离
@property CGFloat XValue;//选择视图选择的值 初始值与左边topleft对齐
@property NSInteger insertIndex;// 插入的index 如果大于count就9999  视为addPoint
@property id<previewMoveDelegate>delegate;
//@property id<touchEndDelegate>endDelegate;



@property (nonatomic, strong)UILabel * Xlabel;
@property (nonatomic, strong)UILabel * Ylabel;

-(id)initWithFrame:(CGRect)frame andColor:(UIColor *)color array:(NSArray *)array WithControl:(NSArray *)controlArray;
- (void)insertPoint:(CGFloat)x andInsertIndex:(NSInteger)inIndex andYdistance:(CGFloat)y;


- (void)hideControlPointAndLine;

@end
