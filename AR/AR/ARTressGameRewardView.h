//
//  ARTressGameRewardView.h
//  AR
//
//  Created by YangTengJiao on 2018/12/6.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARTressGameRewardView : UIView

@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UILabel *centerLabel;

- (void)showRewardWith:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
