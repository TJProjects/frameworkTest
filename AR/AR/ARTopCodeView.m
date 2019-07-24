//
//  ARTopCodeView.m
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARTopCodeView.h"
#import "ARDefine.h"

@implementation ARTopCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor clearColor];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.backButton.imageEdgeInsets =UIEdgeInsetsMake(10, 10, 10, 10);
    [self.backButton setImage:[ARImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.leading.equalTo(weakSelf.mas_leading).offset(+17);
        make.width.height.equalTo(@36);
    }];
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.giftButton setImage:[ARImage imageNamed:@"gift_icon"] forState:UIControlStateNormal];
    [self.giftButton addTarget:self action:@selector(giftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.giftButton];
    [self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.trailing.equalTo(weakSelf.mas_trailing).offset(-17);
        make.width.height.equalTo(@36);
    }];
    
    self.centerImageView = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"times_icon"]];
    [self addSubview:self.centerImageView];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.backButton.mas_centerY);
        make.width.equalTo(@90);
        make.height.equalTo(@32);
    }];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.text = @"次数+0";
    self.centerLabel.font = [UIFont systemFontOfSize:14];
    self.centerLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.centerLabel];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerImageView.mas_top).offset(9);
        make.trailing.equalTo(weakSelf.centerImageView.mas_trailing).offset(-8);
    }];
    
}

- (void)backButton:(UIButton *)button {
    if (self.buttonBlock) {
        self.buttonBlock(@"back");
    }
}

- (void)giftButton:(UIButton *)button {
    if (self.buttonBlock) {
        self.buttonBlock(@"gift");
    }
}


@end
