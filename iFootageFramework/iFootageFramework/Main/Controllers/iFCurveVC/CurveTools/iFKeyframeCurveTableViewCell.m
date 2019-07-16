//
//  iFKeyframeCurveTableViewCell.m
//  iFootage
//
//  Created by 黄品源 on 2016/10/25.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFKeyframeCurveTableViewCell.h"
#import <Masonry/Masonry.h>
#import "AppDelegate.h"

@implementation iFKeyframeCurveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
        
    }
    return self;
}
- (void)layoutSubviews{

    UIImage* image = [UIImage imageNamed:@"rootBackground"];
    CGSize itemSize = CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width,100);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
//            make.size.mas_equalTo(CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, 100));
            self.contentView.backgroundColor = [UIColor colorWithPatternImage:image];
//
//    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        make.size.mas_equalTo(CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, 100));
    }];

}

- (void)createUI{
 
    
    [self.contentView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, 100)];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width * 0.6, 50)];
    self.titleLabel.center = CGPointMake([[UIScreen mainScreen] applicationFrame].size.width / 2, 50);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:30];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
}
@end
