//
//  ARTreesGameTopView.h
//  AR
//
//  Created by YangTengJiao on 2018/12/5.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonSelectBlock)(NSString *type);
NS_ASSUME_NONNULL_BEGIN

@interface ARTreesGameTopView : UIView
@property (nonatomic, copy) ButtonSelectBlock buttonBlock;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *treesButton;
@property (strong, nonatomic) UIButton *waterButton;
//@property (strong, nonatomic) UILabel *treesLabel;
//@property (strong, nonatomic) UILabel *waterLabel;

- (void)showTreeButton;
- (void)showWaterButton;
- (void)showUnButton;
- (void)showSpaceStationView;

- (void)showBack;
- (void)showdefault;

@end

NS_ASSUME_NONNULL_END
