//
//  ARGamePromptView.m
//  AR
//
//  Created by YangTengJiao on 2018/11/30.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARGamePromptView.h"
#import "ARDefine.h"

@implementation ARGamePromptView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor clearColor];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 6;
    self.attributes = [[NSMutableDictionary alloc] init];
    [self.attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    UIButton *bg  = [UIButton buttonWithType:UIButtonTypeSystem];
    bg.frame = self.bounds;
    [self addSubview:bg];
    
    self.bgImageView = [[UIImageView alloc] init];
    [self.bgImageView setImage:[ARImage imageNamed:@"pop_blue"]];
    self.bgImageView.userInteractionEnabled = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@330);
        make.height.equalTo(@391);
    }];
    
    UIButton *bgImageBG  = [UIButton buttonWithType:UIButtonTypeSystem];
    bgImageBG.frame = self.bgImageView.bounds;
    [self.bgImageView addSubview:bgImageBG];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"很遗憾，任务失败！";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    [self.bgImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageView.mas_top).offset(+35);
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.width.equalTo(weakSelf.bgImageView.mas_width);
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setBackgroundImage:[ARImage imageNamed:@"开启btn"] forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.sureButton setTitle:@"种树去喽" forState:UIControlStateNormal];
    [self.bgImageView addSubview:self.sureButton];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-40);
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.width.equalTo(@136);
        make.height.equalTo(@63);
    }];
    [self.sureButton addTarget:self action:@selector(sureButtonSelect) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setBackgroundImage:[ARImage imageNamed:@"开启btn"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.leftButton setTitle:@"继续游戏" forState:UIControlStateNormal];
    [self.bgImageView addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-60);
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX).offset(-136*0.8*0.5-5);
        make.width.equalTo(@(136*0.8));
        make.height.equalTo(@(63*0.8));
    }];
    [self.leftButton addTarget:self action:@selector(leftButtonSelect) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.hidden = YES;
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setBackgroundImage:[ARImage imageNamed:@"开启btn"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.rightButton setTitle:@"退出游戏" forState:UIControlStateNormal];
    [self.bgImageView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-60);
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX).offset(+136*0.8*0.5+5);
        make.width.equalTo(@(136*0.8));
        make.height.equalTo(@(63*0.8));
    }];
    [self.rightButton addTarget:self action:@selector(rightButtonSelect) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.hidden = YES;
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.font = [UIFont systemFontOfSize:13];
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.text = @"（剩余次数2次）";
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.sureButton.mas_bottom).offset(+7);
        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
        make.width.equalTo(weakSelf.bgImageView.mas_width);
        make.height.equalTo(@12);
    }];
    
    self.promptLabel = [[UILabel alloc] init];
    self.promptLabel.font = [UIFont systemFontOfSize:16];
    self.promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.numberOfLines = 0;
    self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:@"请保持手机视野在开阔空间内，尽量避免视野中有大量的移动物体。\n您可以选择一种树苗（或系统根据当前时间推荐树苗），您在领取树苗后，通过“辛勤劳作”（浇水~），即可看着树苗长成并结果，采摘果实会有系统奖励。\n温馨提示：待您的发财树长成并结果后，您可 以通过AR相机拍摄各种场景下的“照骗”以作 分享和收藏呦~~~" attributes:self.attributes];;
    [self.bgImageView addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageView.mas_top).offset(+70);
        make.leading.equalTo(weakSelf.bgImageView.mas_leading).offset(+30);
        make.trailing.equalTo(weakSelf.bgImageView.mas_trailing).offset(-30);
    }];
    
    self.hidden = YES;
}

- (void)sureButtonSelect {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
    if (self.promptBlock) {
        self.promptBlock(self.type);
    }
}
- (void)leftButtonSelect {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
    if (self.promptBlock) {
        self.promptBlock(self.type);
    }
}
- (void)rightButtonSelect {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
    if (self.promptBlock) {
        self.promptBlock(@"back");
    }
}


- (void)showMagicCubePromptView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeFrameBig];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.bgImageView setImage:[ARImage imageNamed:@"pop_blue"]];
        self.hidden = NO;
        self.type = @"MagicCube";
        self.titleLabel.text = @"游戏玩法";
        self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:@"1、进入AR游戏后，请将相机视野保持在开阔的空间，避免空间内有大量的移动物体\n2、请在规定的时间内完成所有“找茬任务”，即可获得精美的奖励\n3、操作方法：可用双指上下拖动原图，单指滑动魔方\n祝火眼金睛的你，找茬任务挑战成功！" attributes:self.attributes];
        [self.sureButton setTitle:@"开始找茬" forState:UIControlStateNormal];
        self.bottomLabel.text = @"";
    });
}
- (void)showSpaceStationPromptView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeFrameBig];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.bgImageView setImage:[ARImage imageNamed:@"pop_blue"]];
        self.type = @"SpaceStation";
        self.hidden = NO;
        self.titleLabel.text = @"游戏玩法";
        self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:@"1、开始AR游戏后，请将相机视野保持在开阔的空间内，尽量避免视野中有大量的移动物体。\n2、进入空间站后，可转动手机或点击空间站内的屏幕，查看感兴趣的信息。" attributes:self.attributes];
        [self.sureButton setTitle:@"进入空间站" forState:UIControlStateNormal];
        self.bottomLabel.text = @"";
    });
}
- (void)showPlantingTreesPromptView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeFrameBig];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        [self.bgImageView setImage:[ARImage imageNamed:@"pop_blue"]];
        self.type = @"PlantingTrees";
        self.hidden = NO;
        self.titleLabel.text = @"游戏玩法";
        self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:@"1、请在开阔的空间内参与游戏，避免相机视野中有大量的移动物体。\n2、投放草坪后，通过辛勤的劳动种下小树苗并给树苗浇水。\n3、树苗变成参天大树后，会结出若干果子，采摘果子即可得到加速卡券。\n4、您还可以点击屏幕下方的按钮将劳动成果保存在手机相册中。" attributes:self.attributes];
        [self.sureButton setTitle:@"种树去喽" forState:UIControlStateNormal];
        self.bottomLabel.text = @"";
    });
}

- (void)showSuccessWith:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeFrameBig];
        self.titleLabel.font = [UIFont systemFontOfSize:23];
        [self.bgImageView setImage:[ARImage imageNamed:@"pop_green"]];
        self.type = @"Success";
        self.hidden = NO;
        self.titleLabel.text = @"恭喜您，顺利完成任务！";
        NSString *string = [NSString stringWithFormat:@"本次任务获得奖励：%@",str];
        self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:string attributes:self.attributes];
        [self.sureButton setTitle:@"继续参与" forState:UIControlStateNormal];
        self.bottomLabel.text = [NSString stringWithFormat: @"（剩余次数%ld次）",(long)self.currentNum];
    });
}
- (void)showGameOver {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeFrameSmall];
        self.titleLabel.font = [UIFont systemFontOfSize:23];
        [self.bgImageView setImage:[ARImage imageNamed:@"pop_red"]];
        self.type = @"Error";
        self.hidden = NO;
        self.titleLabel.text = @"很遗憾，游戏失败！";
        [self.sureButton setTitle:@"继续游戏" forState:UIControlStateNormal];
        self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:@"下次游戏要加油哦" attributes:self.attributes];;
        self.bottomLabel.text = [NSString stringWithFormat: @"（剩余次数%ld次）",(long)self.currentNum];
    });
}

- (void)showPlantingTreesOverView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self changeFrameSmall];
        self.titleLabel.font = [UIFont systemFontOfSize:23];
        [self.bgImageView setImage:[ARImage imageNamed:@"pop_green"]];
        self.type = @"TreesOver";
        self.hidden = NO;
        self.titleLabel.text = @"";
        self.promptLabel.attributedText = [[NSAttributedString alloc] initWithString:@"今天次数已用完，请明天再来。" attributes:self.attributes];
        [self.sureButton setTitle:@"游戏结束" forState:UIControlStateNormal];
        self.bottomLabel.text = [NSString stringWithFormat: @"（剩余次数%ld次）",(long)self.currentNum];
    });
}

- (void)changeFrameSmall {
    self.leftButton.hidden = NO;
    self.rightButton.hidden = NO;
    self.sureButton.hidden = YES;
    if (self.bgImageView.frame.size.width != (330.0*0.8) || self.bgImageView.frame.size.height != (391.0*0.8)) {
        __weak typeof(self) weakSelf = self;
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.width.equalTo(@(330.0*0.8));
            make.height.equalTo(@(391.0*0.8));
        }];
        [self layoutIfNeeded];
    }
}
- (void)changeFrameBig {
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.sureButton.hidden = NO;
    if (self.bgImageView.frame.size.width != 330 || self.bgImageView.frame.size.height != 391) {
        __weak typeof(self) weakSelf = self;
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.mas_centerX);
            make.centerY.equalTo(weakSelf.mas_centerY);
            make.width.equalTo(@330);
            make.height.equalTo(@391);
        }];
        [self layoutIfNeeded];
    }
}

@end
