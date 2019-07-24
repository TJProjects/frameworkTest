//
//  ARGameTopView.h
//  AR
//
//  Created by YangTengJiao on 2018/11/29.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonSelectBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARGameTopView : UIView
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, strong) UIImageView *progressBGImageView;
@property (nonatomic, strong) UIImageView *progressImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) NSInteger timerNum;
@property (nonatomic, strong) NSString *currentCount;

@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, copy) ButtonSelectBlock buttonBlock;

- (void)redyStartTimer;
- (void)startTimer;
- (void)stopTimer;

- (void)pasueTimer;
- (void)resumeTimer;

- (void)showBack;
- (void)showdefault;


- (void)showFailImage;
- (void)showDefaultImage;

- (void)showProgressWith:(float)progress;
- (void)showPointSelectNum:(NSInteger)num;


@end

NS_ASSUME_NONNULL_END
