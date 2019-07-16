//
//  iFScanViewCell.h
//  iFootage
//
//  Created by 黄品源 on 16/9/13.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFLabel.h"

@interface iFScanViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView * TilteimageView;
@property (nonatomic, strong)iFLabel * tiltLabel;
@property (nonatomic, strong)UILabel * stateLabel;
@property (nonatomic, strong)UISwitch * iFSwitch;


@end
