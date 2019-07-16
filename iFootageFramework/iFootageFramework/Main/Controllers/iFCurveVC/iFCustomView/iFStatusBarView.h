//
//  iFStatusBarView.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/14.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFCbperStatusView.h"

@interface iFStatusBarView : UIView

@property (nonatomic, strong)iFCbperStatusView * cbs1perView;
@property (nonatomic, strong)iFCbperStatusView * cbx2perView;
+ (iFStatusBarView *)sharedView;

@end
