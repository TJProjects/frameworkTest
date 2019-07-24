//
//  giftCodeView.h
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^EnterButtonBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface giftCodeView : UIView
//@property (strong, nonatomic) UIVisualEffectView *effectview;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIButton *giftButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UITextView *titleView;

@property (copy, nonatomic) EnterButtonBlock buttonBlock;

- (void)showViewWithInfo:(NSArray *)info;

@end

NS_ASSUME_NONNULL_END
