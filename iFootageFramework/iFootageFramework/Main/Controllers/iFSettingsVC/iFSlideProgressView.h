//
//  iFSlideProgressView.h
//  iFootage
//
//  Created by 黄品源 on 2017/7/27.
//  Copyright © 2017年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class iFLabel;


@interface iFSlideProgressView : UIView

@property (nonatomic, strong)UIImageView * controlView;
@property (nonatomic, strong)iFLabel * leftlabel;
@property (nonatomic, strong)iFLabel* rightlabel;
@property (nonatomic, assign)NSInteger minvalue;
@property (nonatomic, assign)NSInteger maxvalue;



- (id)initWithFrame:(CGRect)frame withPercent:(NSInteger)percent withLeftValue:(NSInteger)leftvalue withRightValue:(NSInteger)rightvalue;


@end
