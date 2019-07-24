//
//  ARAlertCodeView.m
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARAlertCodeView.h"
#import "ARDefine.h"

@implementation ARAlertCodeView

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
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"left_pop_window"]];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(+3);
        make.width.equalTo(@289);
        make.height.equalTo(@186);
    }];
    
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    if (@available(iOS 8.2, *)) {
        self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:18];
    };
    [self.cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancleButton setBackgroundImage:[ARImage imageNamed:@"pressed1"] forState:UIControlStateHighlighted];
    [self.cancleButton addTarget:self action:@selector(cancleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancleButton];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-2);
        make.leading.equalTo(weakSelf.bgImageView.mas_leading).offset(+2);
        make.width.equalTo(@144);
        make.height.equalTo(@55);
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    if (@available(iOS 8.2, *)) {
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        self.sureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    };
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureButton setBackgroundImage:[ARImage imageNamed:@"pressed2"] forState:UIControlStateHighlighted];
    [self.sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-2);
        make.trailing.equalTo(weakSelf.bgImageView.mas_trailing).offset(-2);
        make.width.equalTo(@144);
        make.height.equalTo(@55);
    }];
    
    self.contureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contureButton setTitle:@"继续游戏" forState:UIControlStateNormal];
    if (@available(iOS 8.2, *)) {
        self.contureButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        self.contureButton.titleLabel.font = [UIFont systemFontOfSize:18];
    };
    [self.contureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contureButton setBackgroundImage:[ARImage imageNamed:@"pressed "] forState:UIControlStateHighlighted];
    [self.contureButton addTarget:self action:@selector(contureButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contureButton];
    [self.contureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.bgImageView.mas_leading).offset(+2);
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-2);
        make.trailing.equalTo(weakSelf.bgImageView.mas_trailing).offset(-2);
        make.height.equalTo(@55);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"啊哦~\n很不幸您碰到了炸弹，\n下次再努力哦～";
    self.titleLabel.numberOfLines = 0;
    if (@available(iOS 8.2, *)) {
        self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:18];
    };
    self.titleLabel.textColor = [UIColor colorWithRed:189.0/255.0 green:228.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.centerY.equalTo(weakSelf.bgImageView.mas_centerY).offset(-10);
    }];
    
    self.hidden = YES;
    self.type = @"";
}


- (void)cancleButton:(UIButton *)sender {
    NSString *type = @"cancle";
    if ([self.type isEqualToString:@"sure"]) {
        type = @"cancle";
    } else if ([self.type isEqualToString:@"contureAndGift"]) {
        type = @"conture";
    } else if ([self.type isEqualToString:@"RecognitionPlan"]) {
        type = @"scan";
    }
    if (self.buttonBlock) {
        self.buttonBlock(type);
    }
    self.hidden = YES;
}
- (void)sureButton:(UIButton *)sender {
    NSString *type = @"sure";
    if ([self.type isEqualToString:@"sure"]) {
        type = @"sure";
    } else if ([self.type isEqualToString:@"contureAndGift"]) {
        type = @"gift";
    } else if ([self.type isEqualToString:@"RecognitionPlan"]) {
        type = @"back";
    }
    self.hidden = YES;
    if (self.buttonBlock) {
        self.buttonBlock(type);
    }
}
- (void)contureButton:(UIButton *)sender {
    NSString *type = @"conture";
    if ([self.type isEqualToString:@"conture"]) {
        type = @"conture";
    } else if ([self.type isEqualToString:@"back"]) {
        type = @"back";
    }
    self.hidden = YES;
    if (self.buttonBlock) {
        self.buttonBlock(type);
    }
}

- (void)showSureOutGame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"sure";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"left_pop_window"]];
        self.contureButton.hidden = YES;
        self.cancleButton.hidden = NO;
        self.sureButton.hidden = NO;
        self.titleLabel.text = @"您确认要离开游戏吗？";
        [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    });
}
- (void)showContureGame {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"conture";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"back_pop_window"]];
        self.contureButton.hidden = NO;
        self.cancleButton.hidden = YES;
        self.sureButton.hidden = YES;
        self.titleLabel.text = @"啊哦~ \n很不幸您碰到了炸弹， \n下次再努力哦～";
        [self.contureButton setTitle:@"继续游戏" forState:UIControlStateNormal];
    });
}
- (void)showContureAndGiftGameWith:(NSString *)giftString {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"contureAndGift";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"left_pop_window"]];
        self.contureButton.hidden = YES;
        self.cancleButton.hidden = NO;
        self.sureButton.hidden = NO;
        self.titleLabel.text = giftString;
        [self.cancleButton setTitle:@"继续游戏" forState:UIControlStateNormal];
        [self.sureButton setTitle:@"查看奖励" forState:UIControlStateNormal];
    });
}
- (void)showBackVC {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"back";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"back_pop_window"]];
        self.contureButton.hidden = NO;
        self.cancleButton.hidden = YES;
        self.sureButton.hidden = YES;
        self.titleLabel.text = @"您的游戏次数已用尽， \n下次再来玩吧～";
        [self.contureButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    });
}
- (void)showHttpError {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"back";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"back_pop_window"]];
        self.contureButton.hidden = NO;
        self.cancleButton.hidden = YES;
        self.sureButton.hidden = YES;
        self.titleLabel.text = @"网络环境不佳，\n请检查";
        [self.contureButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    });
}
- (void)showCamareError {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"back";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"back_pop_window"]];
        self.contureButton.hidden = NO;
        self.cancleButton.hidden = YES;
        self.sureButton.hidden = YES;
        self.titleLabel.text = @"相机权限未打开，\n请检查";
        [self.contureButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    });
}
- (void)showUnSupportARkit {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"back";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"back_pop_window"]];
        self.contureButton.hidden = NO;
        self.cancleButton.hidden = YES;
        self.sureButton.hidden = YES;
        self.titleLabel.text = @"亲，你的手机暂不支持AR游戏，\n换个手机再试试！";
        [self.contureButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    });
}
- (void)showRecognitionPlanError {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.type = @"RecognitionPlan";
        self.hidden = NO;
        [self.bgImageView setImage:[ARImage imageNamed:@"left_pop_window"]];
        self.contureButton.hidden = YES;
        self.cancleButton.hidden = NO;
        self.sureButton.hidden = NO;
        self.titleLabel.text = @"很抱歉,未检测到平面,\n请到空旷的地面继续扫描!";
        [self.cancleButton setTitle:@"继续扫描" forState:UIControlStateNormal];
        [self.sureButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    });
}
@end
