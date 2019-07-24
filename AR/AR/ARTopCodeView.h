//
//  ARTopCodeView.h
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TopViewButtonBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARTopCodeView : UIView
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *giftButton;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UILabel *centerLabel;
@property (copy, nonatomic) TopViewButtonBlock buttonBlock;

@end

NS_ASSUME_NONNULL_END
