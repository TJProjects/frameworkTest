//
//  ARFirstShowView.h
//  AR
//
//  Created by YangTengJiao on 2018/11/16.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ARFirstShowViewHiddenBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARFirstShowView : UIView
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *bgTopImageView;

@property (nonatomic, strong) UIImageView *phoneImageView;
//@property (nonatomic, strong) UIImageView *phonebgImageView;
@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, copy) ARFirstShowViewHiddenBlock hiddenBlock;

- (void)startAnimation;
- (void)removeAnimation;


@end

NS_ASSUME_NONNULL_END
