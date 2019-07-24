//
//  ARGameTips.h
//  AR
//
//  Created by YangTengJiao on 2019/1/11.
//  Copyright © 2019年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ARGameTipsBlock)(NSString *type);

@interface ARGameTips : UIView
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIButton *centerButton;

@property (copy, nonatomic) ARGameTipsBlock tipsBlock;
@property (strong, nonatomic) NSString *showType;

- (void)showCubeView;
- (void)showHelpView;

@end

NS_ASSUME_NONNULL_END
