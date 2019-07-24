//
//  ARGameTips.m
//  AR
//
//  Created by YangTengJiao on 2019/1/11.
//  Copyright © 2019年 YangTengJiao. All rights reserved.
//

#import "ARGameTips.h"
#import "ARDefine.h"

@implementation ARGameTips

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UIButton *bg  = [UIButton buttonWithType:UIButtonTypeSystem];
    bg.frame = self.bounds;
    [self addSubview:bg];
    
    self.centerImageView = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"instructions"]];
    [self addSubview:self.centerImageView];
    self.centerImageView.userInteractionEnabled = YES;
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.equalTo(@309);
        make.height.equalTo(@393);
    }];
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerButton setBackgroundImage:[ARImage imageNamed:@"btn_put"] forState:UIControlStateNormal];
    [self.centerButton setTitle:@"我知道了" forState:UIControlStateNormal];
    self.centerButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.centerButton addTarget:self action:@selector(centerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.centerImageView addSubview:self.centerButton];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.centerImageView.mas_bottom).offset(-43);
        make.centerX.equalTo(weakSelf.centerImageView.mas_centerX);
        make.width.equalTo(@209);
        make.height.equalTo(@62);
    }];
    self.hidden = YES;
}

- (void)centerAction {
    self.hidden = YES;
    if (self.tipsBlock) {
        self.tipsBlock(self.showType);
    }
}

- (void)showCubeView {
    self.showType = @"showCubeView";
    self.hidden = NO;
}
- (void)showHelpView {
    self.showType = @"showHelpView";
    self.hidden = NO;
}

@end
