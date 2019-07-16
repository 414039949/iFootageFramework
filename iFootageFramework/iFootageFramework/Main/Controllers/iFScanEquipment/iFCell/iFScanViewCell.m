//
//  iFScanViewCell.m
//  iFootage
//
//  Created by 黄品源 on 16/9/13.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFScanViewCell.h"

@implementation iFScanViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    
    [self.contentView setFrame:iFCGRect(0, 0, AutoKscreenWidth, 300)];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
    
    self.TilteimageView = [[UIImageView alloc]initWithFrame:iFCGRect(0, 0, 66, 66)];
    self.TilteimageView.center = CGPointMake(AutoKscreenWidth / 2, 100);
    [self.contentView addSubview:self.TilteimageView];
}

@end
