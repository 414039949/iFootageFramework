//
//  iFCustomView.h
//  iFootage
//
//  Created by 黄品源 on 16/8/10.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFButton.h"

@protocol chooseIndexValueDelegate <NSObject>

- (void)getIndexWithView:(NSInteger)index;

@end

@interface iFCustomView : UIView

@property (nonatomic, strong) iFButton  * firstBtn;
@property (nonatomic, strong) iFButton  * secondBtn;
@property (nonatomic, strong) iFButton  * thirdBtn;
@property (nonatomic, weak)id<chooseIndexValueDelegate>delegate;


//@property (copy, nonatomic) void (^actionWithPapameterBlock)(NSInteger papameter);


@property NSInteger index;

-(id)initWithFrame:(CGRect)frame firstTitleBtn:(NSString *)firstTitle SecondTitleBtn:(NSString *)secondTitle ThirdTitleBtn:(NSString *)thirdTitle;

-(id)initWithFrame:(CGRect)frame firstTitleBtn:(NSString *)firstTitle SecondTitleBtn:(NSString *)secondTitle;

- (id)initWithFrame:(CGRect)frame changeModeWithFirstBtn:(NSString *)firstTilte SecondTitleBtn:(NSString *)secondTitle;

@end
