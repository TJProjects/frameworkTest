//
//  ARHowToPlayCodeView.m
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARHowToPlayCodeView.h"
#import "ARDefine.h"

@implementation ARHowToPlayCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor clearColor];
//    self.effectview = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    [self addSubview:self.effectview];
//    [self.effectview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.mas_centerX);
//        make.centerY.equalTo(weakSelf.mas_centerY);
//        make.width.equalTo(weakSelf.mas_width);
//        make.height.equalTo(weakSelf.mas_height);
//    }];
    self.bgImageView = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"game_pop_window"]];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@308);
        make.height.equalTo(@469);
    }];
    
    self.textImageView = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"game_play_words"]];
    [self addSubview:self.textImageView];
    [self.textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgImageView.mas_centerY);
        make.width.equalTo(@239);
        make.height.equalTo(@128);
    }];
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[ARImage imageNamed:@"begin_btn"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-36);
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.width.height.equalTo(@85);
    }];
    
}
- (void)playButton:(UIButton *)button {
    if (self.buttonBlock) {
        self.buttonBlock(@"play");
    }
}

- (void)hiddenView {
    self.hidden = YES;
}

@end
