//
//  iFS1A3_DialerView.h
//  iFootage
//
//  Created by 黄品源 on 2018/5/18.
//  Copyright © 2018年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iFS1A3_DialerView : UIView

- (id)initWithFrame:(CGRect)frame Withcode:(UInt8)code;
- (id)initWithbackPNGFrame:(CGRect)frame WithCode:(UInt8)code;
- (void)getDialerResultsWithCode:(UInt8)code;
- (NSInteger)getDialerRseults;

@property (nonatomic, assign)UInt8 syncCode;

@end
