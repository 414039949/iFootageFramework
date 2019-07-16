//
//  iFPeripheralCell.h
//  iFootage
//
//  Created by 黄品源 on 16/6/29.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFLabel.h"
#import "iFButton.h"


@protocol changePerpheralCellStateDelegate <NSObject>

- (void)changePerpheralCellState:(NSInteger)tag;
- (void)modifyCellCbName:(NSInteger)tag;


@end

@interface iFPeripheralCell : UITableViewCell


@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * stateLabel;
@property (nonatomic, strong)UISwitch * isConnectedSwitch;

@property (nonatomic, strong)id<changePerpheralCellStateDelegate>delegate;


@property (nonatomic, strong)UIImageView * TilteimageView;
@property (nonatomic, strong)iFLabel * tiltLabel;
@property (nonatomic, strong)UILabel * typeLabel;
@property (nonatomic, strong)iFButton * modefiyBtn;

//@property (nonatomic, strong)UILabel * stateLabel;
@property (nonatomic, strong)UISwitch * iFSwitch;


@end
