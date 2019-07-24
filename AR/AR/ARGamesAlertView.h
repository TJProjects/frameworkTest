//
//  ARGamesAlertView.h
//  AR
//
//  Created by YangTengJiao on 2019/1/11.
//  Copyright © 2019年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ARGamesAlertViewBlock)(NSString *type);

@interface ARGamesAlertView : UIView
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UILabel *centerLabel;
@property (strong, nonatomic) UIButton *centerButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (copy, nonatomic) ARGamesAlertViewBlock alertBlock;
@property (strong, nonatomic) NSString *showType;

- (void)showPutErrorView;
- (void)showHttpErrorView;
- (void)showPickingFruitViewWith:(NSString *)title num:(NSInteger)num;
- (void)showPickingOverView;
- (void)showCamareError;
- (void)showMagicCubeOver;
- (void)showUnSupportARkit;
- (void)showHttpErrorViewBack;

@end

NS_ASSUME_NONNULL_END
