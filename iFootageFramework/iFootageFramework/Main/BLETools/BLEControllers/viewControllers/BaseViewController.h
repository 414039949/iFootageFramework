//
//  BaseViewController.h
//  BLECollection
//
//  Created by rfstar on 14-1-2.
//  Copyright (c) 2014年 rfstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarItem.h"
//#import "TransmitViewController.h"
#import "iFRootViewController.h"
@interface BaseViewController : iFRootViewController
{
    Boolean                 keyboardVisible;
}
@property (nonatomic, assign) BarItem *barItem;

//@property (nonatomic, strong)TransmitViewController * topVC;


-(id)initWithNib;
-(void)keyboardShowOrHide:(Boolean)boo;
@end
