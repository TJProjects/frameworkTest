//
//  ARAlertCodeView.h
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertViewButtonBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARAlertCodeView : UIView
//@property (strong, nonatomic) UIVisualEffectView *effectview;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIButton *cancleButton;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *contureButton;
@property (strong, nonatomic) NSString *type;
@property (copy, nonatomic) AlertViewButtonBlock buttonBlock;

- (void)showSureOutGame;
- (void)showContureGame;
- (void)showContureAndGiftGameWith:(NSString *)giftString;
- (void)showBackVC;
- (void)showHttpError;
- (void)showCamareError;
- (void)showUnSupportARkit;
- (void)showRecognitionPlanError;

@end

NS_ASSUME_NONNULL_END
