//
//  ARHowToPlayCodeView.h
//  TaiXin
//
//  Created by YangTengJiao on 2018/11/8.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HowToPlayButtomBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARHowToPlayCodeView : UIView
//@property (strong, nonatomic) UIVisualEffectView *effectview;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *textImageView;
@property (strong, nonatomic) UIButton *playButton;


@property (copy, nonatomic) HowToPlayButtomBlock buttonBlock;

- (void)hiddenView;
@end

NS_ASSUME_NONNULL_END
