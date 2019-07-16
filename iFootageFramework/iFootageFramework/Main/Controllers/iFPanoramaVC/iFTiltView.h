//
//  iFTiltView.h
//  iFootage
//
//  Created by 黄品源 on 2017/6/10.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeTiltVelocDelegate <NSObject>

- (void)changeTiltVolocAction:(CGFloat)velocValue;

@end



@interface iFTiltView : UIView

@property CGFloat value;

@property (nonatomic, strong) id<changeTiltVelocDelegate>delegate;
@property (nonatomic, strong) NSTimer * sendTimer;
@end
