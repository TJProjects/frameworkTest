//
//  ARTreesGameTopView.m
//  AR
//
//  Created by YangTengJiao on 2018/12/5.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARTreesGameTopView.h"
#import "ARDefine.h"

@implementation ARTreesGameTopView

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
    [self.backButton setBackgroundImage:[ARImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(+kStatusBarHeight-20+7);
        make.leading.equalTo(weakSelf.mas_leading).offset(+7);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    [self.backButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.treesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.treesButton setBackgroundImage:[ARImage imageNamed:@"树苗单色"] forState:UIControlStateNormal];
    [self addSubview:self.treesButton];
    [self.treesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.mas_top).offset(+kStatusBarHeight-20+6);
        make.width.equalTo(@45);
        make.height.equalTo(@51);
    }];
    [self.treesButton addTarget:self action:@selector(treesButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.waterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.waterButton setBackgroundImage:[ARImage imageNamed:@"浇水单色"] forState:UIControlStateNormal];
    [self addSubview:self.waterButton];
    [self.waterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.mas_trailing).offset(-8);
        make.top.equalTo(weakSelf.mas_top).offset(+kStatusBarHeight-20+6);
        make.width.equalTo(@45);
        make.height.equalTo(@51);
    }];
    
    [self.waterButton addTarget:self action:@selector(waterButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backButton:(NSString *)button {
    if (self.buttonBlock) {
        self.buttonBlock(@"back");
    }
}
- (void)treesButton:(NSString *)button {
    if (self.buttonBlock) {
        self.buttonBlock(@"trees");
    }
}
- (void)waterButton:(NSString *)button {
    if (self.buttonBlock) {
        self.buttonBlock(@"water");
    }
}

- (void)showTreeButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.treesButton.hidden = NO;
        self.waterButton.hidden = NO;
        self.treesButton.userInteractionEnabled = YES;
        self.waterButton.userInteractionEnabled = NO;
        [self.treesButton setBackgroundImage:[ARImage imageNamed:@"树苗"] forState:UIControlStateNormal];
        [self.waterButton setBackgroundImage:[ARImage imageNamed:@"浇水单色"] forState:UIControlStateNormal];
    });
}
- (void)showWaterButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.treesButton.hidden = NO;
        self.waterButton.hidden = NO;
        self.treesButton.userInteractionEnabled = NO;
        self.waterButton.userInteractionEnabled = YES;
        [self.treesButton setBackgroundImage:[ARImage imageNamed:@"树苗单色"] forState:UIControlStateNormal];
        [self.waterButton setBackgroundImage:[ARImage imageNamed:@"浇水"] forState:UIControlStateNormal];
    });
}
- (void)showUnButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.treesButton.hidden = NO;
        self.waterButton.hidden = NO;
        self.treesButton.userInteractionEnabled = NO;
        self.waterButton.userInteractionEnabled = NO;
        [self.treesButton setBackgroundImage:[ARImage imageNamed:@"树苗单色"] forState:UIControlStateNormal];
        [self.waterButton setBackgroundImage:[ARImage imageNamed:@"浇水单色"] forState:UIControlStateNormal];
    });
}

- (void)showSpaceStationView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        self.treesButton.hidden = YES;
        self.waterButton.hidden = YES;
    });
}

- (void)showBack {
    self.treesButton.hidden = YES;
    self.waterButton.hidden = YES;
}
- (void)showdefault {
    self.treesButton.hidden = NO;
    self.waterButton.hidden = NO;
}

@end
