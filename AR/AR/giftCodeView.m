//
//  giftCodeView.m
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "giftCodeView.h"
#import "ARDefine.h"

@implementation giftCodeView

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
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"gift_pop"]];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(+3);
        make.width.equalTo(@294);
        make.height.equalTo(@358);
    }];
    
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.giftButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.giftButton setBackgroundImage:[ARImage imageNamed:@"gift_pressed"] forState:UIControlStateHighlighted];
    if (@available(iOS 8.2, *)) {
        self.giftButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    } else {
        self.giftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    };
    [self.giftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.giftButton setBackgroundImage:[ARImage imageNamed:@"pressed "] forState:UIControlStateHighlighted];
    [self.giftButton addTarget:self action:@selector(giftButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.giftButton];
    [self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-3);
        make.leading.equalTo(weakSelf.bgImageView.mas_leading).offset(+2);
        make.trailing.equalTo(weakSelf.bgImageView.mas_trailing).offset(-2);
        make.height.equalTo(@62);
    }];
    
    self.titleView = [[UITextView alloc] init];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.textAlignment = NSTextAlignmentCenter;
    [self.titleView setEditable:NO];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = 7;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    self.titleView.attributedText = [[NSAttributedString alloc] initWithString:@"啊哦~\n很不幸您碰到了炸弹，\n下次再努力哦～" attributes:attributes];;
    if (@available(iOS 8.2, *)) {
        self.titleView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
    } else {
        self.titleView.font = [UIFont systemFontOfSize:18];
    };
    self.titleView.textColor = [UIColor colorWithRed:189.0/255.0 green:228.0/255.0 blue:255.0/255.0 alpha:1.0];
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageView.mas_top).offset(+135);
        make.leading.equalTo(weakSelf.bgImageView.mas_leading).offset(+10);
        make.trailing.equalTo(weakSelf.bgImageView.mas_trailing).offset(-10);
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-70);
    }];
    
//    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.titleLabel.numberOfLines = 0;
//    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    paragraphStyle.lineSpacing = 14;
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//    self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"啊哦~\n很不幸您碰到了炸弹，\n下次再努力哦～" attributes:attributes];;
//    if (@available(iOS 8.2, *)) {
//        self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
//    } else {
//        self.titleLabel.font = [UIFont systemFontOfSize:18];
//    };
//    self.titleLabel.textColor = [UIColor colorWithRed:189.0/255.0 green:228.0/255.0 blue:255.0/255.0 alpha:1.0];
//    [self addSubview:self.titleLabel];
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.bgImageView.mas_centerX);
//        make.centerY.equalTo(weakSelf.bgImageView.mas_centerY).offset(-10);
//    }];
    
    self.hidden = YES;
}

- (void)giftButton:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(@"");
    }
    self.hidden = YES;
}

- (void)showViewWithInfo:(NSArray *)info {
    if (info.count > 0) {
        NSString *showString = @"";
        for (NSString *str in info) {
            if (showString.length > 0) {
                showString = [NSString stringWithFormat:@"%@\n%@",showString,str];
            } else {
                showString = str;
            }
        }
        self.hidden = NO;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineSpacing = 7;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//        self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:showString attributes:attributes];
        self.titleView.attributedText = [[NSAttributedString alloc] initWithString:showString attributes:attributes];
        if (@available(iOS 8.2, *)) {
            self.titleView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
        } else {
            self.titleView.font = [UIFont systemFontOfSize:18];
        };
        self.titleView.textColor = [UIColor colorWithRed:189.0/255.0 green:228.0/255.0 blue:255.0/255.0 alpha:1.0];
    } else {
        self.hidden = NO;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineSpacing = 7;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
//        self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"您暂时还没有奖励哦～\n继续加油！" attributes:attributes];
        self.titleView.attributedText = [[NSAttributedString alloc] initWithString:@"您暂时还没有奖励哦～\n继续加油！" attributes:attributes];
        if (@available(iOS 8.2, *)) {
            self.titleView.font = [UIFont systemFontOfSize:18 weight:UIFontWeightLight];
        } else {
            self.titleView.font = [UIFont systemFontOfSize:18];
        };
        self.titleView.textColor = [UIColor colorWithRed:189.0/255.0 green:228.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
}


@end
