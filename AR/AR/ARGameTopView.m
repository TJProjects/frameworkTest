//
//  ARGameTopView.m
//  AR
//
//  Created by YangTengJiao on 2018/11/29.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARGameTopView.h"
#import "ARDefine.h"

#define timeNum 80.0

@implementation ARGameTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews {
    self.isStart = NO;
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
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeButton.userInteractionEnabled = NO;
    [self.timeButton setBackgroundImage:[ARImage imageNamed:@"倒计时蓝色"] forState:UIControlStateNormal];
    [self addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.backButton.mas_centerY);
        make.trailing.equalTo(weakSelf.mas_trailing).offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    self.progressBGImageView = [[UIImageView alloc] init];
    [self.progressBGImageView setImage:[ARImage imageNamed:@"红色BG"]];
    [self addSubview:self.progressBGImageView];
    [self.progressBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.backButton.mas_centerY);
        make.width.equalTo(@225);
        make.height.equalTo(@15);
    }];
    
    self.progressImageView = [[UIImageView alloc] init];
    UIImage *image = [ARImage imageNamed:@"蓝色"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15, 0, 15);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.progressImageView setImage:image];
    [self addSubview:self.progressImageView];
    [self.progressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.backButton.mas_centerY);
        make.leading.equalTo(weakSelf.progressBGImageView.mas_leading);
        make.width.equalTo(@0);
        make.height.equalTo(@15);
    }];
    //226
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = [NSString stringWithFormat:@"%.0lfs",timeNum];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.progressBGImageView.mas_top);
        make.bottom.equalTo(weakSelf.progressBGImageView.mas_bottom);
        make.trailing.equalTo(weakSelf.progressBGImageView.mas_trailing);
        make.width.equalTo(@35);
    }];
    
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerActions) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.timerNum = timeNum;
    [self.timer setFireDate:[NSDate distantFuture]];
}


- (void)showFailImage {
    [self.timeButton setBackgroundImage:[ARImage imageNamed:@"倒计时红色"] forState:UIControlStateNormal];
    [self.progressBGImageView setImage:[ARImage imageNamed:@"红色"]];
    UIImage *image = [ARImage imageNamed:@"红色"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15, 0, 15);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.progressImageView setImage:image];
    self.timeLabel.text = [NSString stringWithFormat:@"%.0lfs",timeNum];
}
- (void)showDefaultImage {
    [self.timeButton setBackgroundImage:[ARImage imageNamed:@"倒计时蓝色"] forState:UIControlStateNormal];
    [self.progressBGImageView setImage:[ARImage imageNamed:@"红色BG"]];
    UIImage *image = [ARImage imageNamed:@"蓝色"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 15, 0, 15);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    [self.progressImageView setImage:image];
}

- (void)showPointSelectNum:(NSInteger)num {
    self.currentCount = [NSString stringWithFormat:@"%ld",(long)num];
    [self.timeButton setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
}

- (void)showProgressWith:(float)progress {
    self.progressImageView.frame = CGRectMake(self.progressImageView.frame.origin.x, self.progressImageView.frame.origin.y, 225.0*progress, self.progressImageView.frame.size.height);
}

- (void)timerActions {
    //    NSLog(@"timerActions %ld",(long)self.timerNum);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timerNum --;
        if (self.timerNum == 0) {
            if (self.buttonBlock) {
                self.buttonBlock(@"timeOver");
            }
            [self stopTimer];
        }
        self.timeLabel.text = [NSString stringWithFormat:@"%lds",self.timerNum];
        [self showProgressWith:(self.timerNum/timeNum)];
    });
}

- (void)redyStartTimer {
    NSLog(@"redyStartTimer");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showDefaultImage];
        self.timerNum = timeNum;
        [self.timeButton setTitle:self.currentCount forState:UIControlStateNormal];
        self.timeLabel.text = [NSString stringWithFormat:@"%.0lfs",timeNum];
        [self showProgressWith:0.0];
    });
}

- (void)startTimer {
    NSLog(@"startTimer");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isStart = YES;
        self.timerNum = timeNum;
        [self.timeButton setTitle:self.currentCount forState:UIControlStateNormal];
        self.timeLabel.text = [NSString stringWithFormat:@"%.0lfs",timeNum];
        [self showProgressWith:0.0];
        [self.timer setFireDate:[NSDate distantPast]];
    });
}
- (void)stopTimer {
    self.isStart = NO;
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)pasueTimer {
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)resumeTimer {
    if (self.isStart == YES) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)showBack {
    self.progressBGImageView.hidden = YES;
    self.progressImageView.hidden = YES;
    self.timeLabel.hidden = YES;
    self.timeButton.hidden = YES;
}
- (void)showdefault {
    self.progressBGImageView.hidden = NO;
    self.progressImageView.hidden = NO;
    self.timeLabel.hidden = NO;
    self.timeButton.hidden = NO;
}

- (void)backButton:(NSString *)button {
    if (self.buttonBlock) {
        self.buttonBlock(@"back");
    }
}

- (void)dealloc {
    [self.timer invalidate];
}

@end
