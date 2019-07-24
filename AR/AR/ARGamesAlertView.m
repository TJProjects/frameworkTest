//
//  ARGamesAlertView.m
//  AR
//
//  Created by YangTengJiao on 2019/1/11.
//  Copyright © 2019年 YangTengJiao. All rights reserved.
//

#import "ARGamesAlertView.h"
#import "ARDefine.h"

@implementation ARGamesAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor clearColor];
    UIButton *bg  = [UIButton buttonWithType:UIButtonTypeSystem];
    bg.frame = self.bounds;
    [self addSubview:bg];
    
    self.centerImageView = [[UIImageView alloc] init];
    [self.centerImageView setImage:[ARImage imageNamed:@"弹框背景"]];
    [self addSubview:self.centerImageView];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@296);
        make.height.equalTo(@225);
    }];
    self.centerImageView.userInteractionEnabled = YES;
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerButton setBackgroundImage:[ARImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    self.centerButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.centerButton.titleLabel.textColor = [UIColor whiteColor];
    [self.centerButton addTarget:self action:@selector(centerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.centerImageView addSubview:self.centerButton];
    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.centerImageView.mas_bottom).offset(-30);
        make.centerX.equalTo(weakSelf.centerImageView.mas_centerX);
        make.width.equalTo(@95);
        make.height.equalTo(@49);
    }];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setBackgroundImage:[ARImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.leftButton.titleLabel.textColor = [UIColor whiteColor];
    [self.leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.centerImageView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.centerImageView.mas_bottom).offset(-30);
        make.leading.equalTo(weakSelf.centerImageView.mas_leading).offset(+28);
        make.width.equalTo(@95);
        make.height.equalTo(@49);
    }];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setBackgroundImage:[ARImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    self.rightButton.titleLabel.textColor = [UIColor whiteColor];
    [self.rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.centerImageView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.centerImageView.mas_bottom).offset(-30);
        make.trailing.equalTo(weakSelf.centerImageView.mas_trailing).offset(-28);
        make.width.equalTo(@95);
        make.height.equalTo(@49);
    }];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.textColor = [UIColor whiteColor];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.font = [UIFont systemFontOfSize:15];
    self.centerLabel.numberOfLines = 0;
    [self.centerImageView addSubview:self.centerLabel];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerImageView.mas_top).offset(+20);
        make.bottom.equalTo(weakSelf.centerButton.mas_top).offset(-20);
        make.leading.equalTo(weakSelf.centerImageView.mas_leading).offset(+20);
        make.trailing.equalTo(weakSelf.centerImageView.mas_trailing).offset(-20);
    }];
    
    self.hidden = YES;
}

- (void)centerAction {
    self.hidden = YES;
    if (self.alertBlock) {
        if ([self.showType isEqualToString:@"showPutErrorView"]) {
            self.alertBlock(@"showPutErrorView");
        } else if ([self.showType isEqualToString:@"showPickingOverView"]) {
            self.alertBlock(@"showPickingOverView");
        } else if ([self.showType isEqualToString:@"showCamareError"]) {
            self.alertBlock(@"showCamareError");
        } else if ([self.showType isEqualToString:@"showMagicCubeOver"]) {
            self.alertBlock(@"showMagicCubeOver");
        } else {
            self.alertBlock(self.showType);
        }
    }
}
- (void)leftAction {
    self.hidden = YES;
    if (self.alertBlock) {
        if ([self.showType isEqualToString:@"showHttpErrorView"]) {
            self.alertBlock(@"showHttpErrorViewRetry");
        } else if ([self.showType isEqualToString:@"showPickingFruitViewWith"]) {
            self.alertBlock(@"showPickingFruitViewWithRetry");
        }
    }
}
- (void)rightAction {
    self.hidden = YES;
    if (self.alertBlock) {
        if ([self.showType isEqualToString:@"showHttpErrorView"]) {
            self.alertBlock(@"showHttpErrorViewClose");
        } else if ([self.showType isEqualToString:@"showPickingFruitViewWith"]) {
            self.alertBlock(@"showPickingFruitViewWithClose");
        }
    }
}

- (void)showPutErrorView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showType = @"showPutErrorView";
        self.centerButton.hidden = NO;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        self.centerLabel.text = @"未检测到可以用平面，请重新投放";
        [self.centerButton setTitle:@"我知道了" forState:UIControlStateNormal];
        self.hidden = NO;
    });
}
- (void)showHttpErrorView {
    dispatch_async(dispatch_get_main_queue(), ^{

    self.showType = @"showHttpErrorView";
    self.centerButton.hidden = YES;
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    self.centerLabel.text = @"网络环境不佳，请检查。";
    [self.leftButton setTitle:@"重试" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    self.hidden = NO;
    });
}
- (void)showPickingFruitViewWith:(NSString *)title num:(NSInteger)num {
    dispatch_async(dispatch_get_main_queue(), ^{

    self.showType = @"showPickingFruitViewWith";
    self.centerButton.hidden = YES;
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    self.centerLabel.text = [NSString stringWithFormat:@"%@\n（剩余次数%ld次）",title,num];
    [self.leftButton setTitle:@"继续游戏" forState:UIControlStateNormal];
    [self.rightButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    self.hidden = NO;
    });
}
- (void)showPickingOverView {
    dispatch_async(dispatch_get_main_queue(), ^{

    self.showType = @"showPickingOverView";
    self.centerButton.hidden = NO;
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.centerLabel.text = @"今日摘果子的次数已用完，请明天再来。";
    [self.centerButton setTitle:@"知道了" forState:UIControlStateNormal];
    self.hidden = NO;
    });
}
- (void)showCamareError {
    dispatch_async(dispatch_get_main_queue(), ^{

    self.showType = @"showCamareError";
    self.centerButton.hidden = NO;
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.centerLabel.text = @"相机权限未打开，\n请检查";
    [self.centerButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    self.hidden = NO;
    });
}
- (void)showMagicCubeOver {
    dispatch_async(dispatch_get_main_queue(), ^{

    self.showType = @"showMagicCubeOver";
    self.centerButton.hidden = NO;
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.centerLabel.text = @"今日找茬的次数已用完，请明天再来。";
    [self.centerButton setTitle:@"知道了" forState:UIControlStateNormal];
    self.hidden = NO;
    });
}
- (void)showUnSupportARkit {
    dispatch_async(dispatch_get_main_queue(), ^{

    self.showType = @"showUnSupportARkit";
    self.centerButton.hidden = NO;
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.centerLabel.text = @"亲，你的手机暂不支持AR游戏，\n换个手机再试试！";
    [self.centerButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    self.hidden = NO;
    });
}

- (void)showHttpErrorViewBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showType = @"showHttpErrorViewBack";
        self.centerButton.hidden = NO;
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
        self.centerLabel.text = @"网络环境不佳，请检查。";
        [self.centerButton setTitle:@"退出游戏" forState:UIControlStateNormal];
        self.hidden = NO;
    });
}

@end
