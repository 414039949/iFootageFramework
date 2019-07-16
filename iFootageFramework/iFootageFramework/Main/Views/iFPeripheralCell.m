//
//  iFPeripheralCell.m
//  iFootage
//
//  Created by 黄品源 on 16/6/29.
//  Copyright © 2016年 iFootage. All rights reserved.
//

#import "iFPeripheralCell.h"
#import <Masonry/Masonry.h>

@implementation iFPeripheralCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
//    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, 100, 40)];
//    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 60, 100, 15)];
//    self.isConnectedSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(250, 20, 60, 40)];
//    
//    self.nameLabel.textColor = [UIColor blackColor];
//    self.nameLabel.backgroundColor = [UIColor redColor];
    
//    self.stateLabel.textColor = [UIColor blackColor];
//    self.stateLabel.backgroundColor = [UIColor blueColor];
    
//    [self.isConnectedSwitch addTarget:self action:@selector(swicthAction:) forControlEvents:UIControlEventValueChanged];
    
//    [self.contentView addSubview:self.nameLabel];
//    [self.contentView addSubview:self.stateLabel];
//    [self.contentView addSubview:self.isConnectedSwitch];
    
//    [self.contentView setFrame:iFCGRect(0, 0, kScreenWidth, 300)];
//    self.contentView.backgroundColor = COLOR(66, 66, 66, 1);
//    self.TilteimageView = [[UIImageView alloc]initWithFrame:iFCGRect(0, 0, 66, 66)];
//    self.TilteimageView.center = CGPointMake(kScreenWidth / 2, 100);
//    self.TilteimageView.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:self.TilteimageView];
//    
//    self.stateLabel = [[UILabel alloc]initWithFrame:iFCGRect(115, 144, 12, 12)];
//    self.stateLabel.backgroundColor = [UIColor redColor];
//    self.stateLabel.layer.masksToBounds = YES;
//    self.stateLabel.layer.cornerRadius = iFSize(12) / 2;
//    [self.contentView addSubview:self.stateLabel];
//    
//    self.tiltLabel = [[iFLabel alloc]initWithFrame:iFCGRect(0, 0, 200, 18) WithTitle:@"Name"];
//    self.tiltLabel.center = CGPointMake(kScreenWidth / 2, 150);
//    [self.contentView addSubview:self.tiltLabel];
    

//    UIImageView * backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    backView.image = [UIImage imageNamed:@"rootBackground"];
//    backView.backgroundColor = [UIColor redColor];
//    [self.contentView addSubview:backView];
    
    
    
    [self.contentView setFrame:CGRectMake(0, 0, AutoKscreenWidth, 100)];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rootBackground"]];
    
    self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(iFSize(30), iFSize(40), 20, 20)];
    self.stateLabel.layer.masksToBounds = YES;
    self.stateLabel.layer.cornerRadius = 20 * 0.5f;
    [self.contentView addSubview:self.stateLabel];
    
    
    self.TilteimageView = [[UIImageView alloc]initWithFrame:CGRectMake(iFSize(60), iFSize(30), 40, 40)];
    self.TilteimageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview: self.TilteimageView];
    
    self.tiltLabel = [[iFLabel alloc]initWithFrame:CGRectMake(iFSize(120), iFSize(30), 140, 40) WithTitle:@""];
    self.tiltLabel.font = [UIFont systemFontOfSize:15];
    self.tiltLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.tiltLabel];
    
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(iFSize(220), iFSize(60), iFSize(100), iFSize(30))];
    self.typeLabel.text = @"no type";
    self.typeLabel.font = [UIFont systemFontOfSize:iFSize(15)];
    self.typeLabel.textColor = [UIColor grayColor];
    self.typeLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.typeLabel];
    
    self.modefiyBtn = [[iFButton alloc]initWithFrame:CGRectMake(iFSize(260), iFSize(30), iFSize(20), iFSize(20)) andnormalImage:@"editor" andSelectedImage:@"editor"];
    [self.contentView addSubview:self.modefiyBtn];
    
    self.isConnectedSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(iFSize(300), iFSize(40), iFSize(40), iFSize(40))];
    [self.isConnectedSwitch  addTarget:self action:@selector(swicthAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.isConnectedSwitch];
//    [self.SettingsBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.TargetBtn.mas_bottom).offset(limitDistance);
//        make.centerX.equalTo(self.TimelineBtn);
//        make.size.mas_equalTo(width);
//
//    }];
    [self.stateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(30);
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.TilteimageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateLabel.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.tiltLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.TilteimageView.mas_right).offset(60);
        make.top.mas_equalTo(self.contentView.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(140, 60));
        self.tiltLabel.font = [UIFont systemFontOfSize:15];
    }];
//
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        self.typeLabel.font = [UIFont systemFontOfSize:15];
    }];
    [self.modefiyBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-80);
        make.top.mas_equalTo(self.contentView.mas_top).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.isConnectedSwitch mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.top.mas_equalTo(self.contentView.mas_top).offset(40);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
}

- (void)modifyAction:(iFButton *)btn{
    [_delegate modifyCellCbName:btn.tag];
    
}

- (void)swicthAction:(UISwitch *)swi{
    
    if ([self.delegate respondsToSelector:@selector(changePerpheralCellState:)]) {
        [self.delegate changePerpheralCellState:swi.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
