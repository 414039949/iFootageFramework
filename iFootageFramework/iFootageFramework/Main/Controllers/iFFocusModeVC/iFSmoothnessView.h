//
//  iFSmoothnessView.h
//  iFootage
//
//  Created by 黄品源 on 2017/11/17.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iF3DButton.h"

@interface iFSmoothnessView : UIView

- (NSInteger)getSmoothnesslevel;
- (void)initSmoothLevelWith:(NSInteger)smoothlevel;

@end
