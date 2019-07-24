//
//  ARTressGameRewardView.m
//  AR
//
//  Created by YangTengJiao on 2018/12/6.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARTressGameRewardView.h"
#import "ARDefine.h"

@implementation ARTressGameRewardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor clearColor];
    
    self.centerImageView = [[UIImageView alloc] init];
    [self.centerImageView setImage:[ARImage imageNamed:@"弹窗"]];
    self.centerImageView.userInteractionEnabled = YES;
    [self addSubview:self.centerImageView];
    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@144);
        make.height.equalTo(@38);
    }];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.text = @"";
    self.centerLabel.textColor = [UIColor whiteColor];
    self.centerLabel.font = [UIFont systemFontOfSize:10];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.centerLabel];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.equalTo(@144);
        make.height.equalTo(@38);
    }];
    
    self.hidden = YES;
}

- (void)showRewardWith:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        NSUInteger r = arc4random_uniform(100)+1;
        self.center = CGPointMake(144.0/2.0+(KScreenWidth-144.0)*(r/100.0), KScreenHeight/2.0-100.0+200.0*(r/100.0));
        self.centerLabel.text = str;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}


@end
