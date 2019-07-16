//
//  iFupdateView.h
//  iFootage
//
//  Created by 黄品源 on 2018/6/25.
//  Copyright © 2018 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iF3DButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface iFupdateView : UIView
@property (nonatomic, strong)iF3DButton * actionBtn;

- (id)initWithFrame:(CGRect)frame WithTitle:(NSString *)str WithContent:(NSString *)contentStr;


@end

NS_ASSUME_NONNULL_END
