//
//  ARFirstShowView.m
//  AR
//
//  Created by YangTengJiao on 2018/11/16.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARFirstShowView.h"
#import "ARDefine.h"

@implementation ARFirstShowView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithWhite:42.0/255.0 alpha:0.54];
    self.bgImageView = [[UIImageView alloc] init];
    [self.bgImageView setImage:[ARImage imageNamed:@"frame"]];
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(-56);
        make.width.equalTo(@295);
        make.height.equalTo(@106);
    }];
    
    self.bgTopImageView = [[UIImageView alloc] init];
    [self.bgTopImageView setImage:[ARImage imageNamed:@"light_spot"]];
    [self addSubview:self.bgTopImageView];
    [self.bgTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageView.mas_top).offset(+16);
        make.leading.equalTo(weakSelf.bgImageView.mas_leading).offset(+31);
        make.trailing.equalTo(weakSelf.bgImageView.mas_trailing).offset(-29);
        make.bottom.equalTo(weakSelf.bgImageView.mas_bottom).offset(-15);
    }];
    
    self.phoneImageView = [[UIImageView alloc] init];
    [self.phoneImageView setImage:[ARImage imageNamed:@"phone"]];
    [self addSubview:self.phoneImageView];
    [self.phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bgImageView.mas_bottom).offset(-43);
        make.leading.equalTo(weakSelf.bgImageView.mas_leading).offset(+50);
        make.width.equalTo(@41);
        make.height.equalTo(@81);
    }];
    
//    self.phonebgImageView = [[UIImageView alloc] init];
//    [self.phonebgImageView setImage:[ARImage imageNamed:@"scanlight_right"]];
//    [self insertSubview:self.phonebgImageView belowSubview:self.phoneImageView];
//    [self.phonebgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.phoneImageView.mas_top).offset(-10);
//        make.leading.equalTo(weakSelf.phoneImageView.mas_leading).offset(-22);
//        make.width.equalTo(@112);
//        make.height.equalTo(@51);
//    }];
    
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.textColor = [UIColor whiteColor];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.text = @"请将手机对准空旷的地面开始扫描！";
    self.bottomLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.phoneImageView.mas_bottom).offset(+28);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.leading.equalTo(weakSelf.mas_leading);
        make.trailing.equalTo(weakSelf.mas_trailing);
    }];
    
    self.hidden = YES;
}

- (void)startAnimation {
    __weak typeof(self) weakSelf = self;
    NSInteger changeX = 295-50-100;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.hidden = NO;
        [weakSelf.phoneImageView.layer removeAllAnimations];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    rotationAnimation.fromValue = @(weakSelf.phoneImageView.layer.position.x);
    rotationAnimation.toValue = @(weakSelf.phoneImageView.layer.position.x+changeX);
        rotationAnimation.duration = 3.0;
//        rotationAnimation.cumulative = NO;
//        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.repeatCount = 2;
        rotationAnimation.autoreverses = YES;
        [weakSelf.phoneImageView.layer addAnimation:rotationAnimation forKey:@"phoneImageView_position"];
    
//        [weakSelf.phonebgImageView.layer removeAllAnimations];
//        CABasicAnimation* rotationTwo = [CABasicAnimation animationWithKeyPath:@"position.x"];
//        rotationTwo.fromValue = @(weakSelf.phoneImageView.layer.position.x);
//        rotationTwo.toValue = @(weakSelf.phoneImageView.layer.position.x+changeX);
//        rotationTwo.duration = 3.0f;
////        rotationTwo.cumulative = NO;
////        rotationTwo.removedOnCompletion = NO;
//        rotationTwo.repeatCount = 2;
//        rotationTwo.autoreverses = YES;
//        [weakSelf.phonebgImageView.layer addAnimation:rotationTwo forKey:@"phonebgImageView_position"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf removeAnimation];
        });
    });
}
- (void)removeAnimation {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.hidden = YES;
        [weakSelf.phoneImageView stopAnimating];
        [weakSelf.phoneImageView.layer removeAllAnimations];
//        [weakSelf.phonebgImageView stopAnimating];
//        [weakSelf.phonebgImageView.layer removeAllAnimations];
        if (weakSelf.hiddenBlock) {
            weakSelf.hiddenBlock(@"");
        }
    });
}


@end
