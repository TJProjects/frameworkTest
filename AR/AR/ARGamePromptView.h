//
//  ARGamePromptView.h
//  AR
//
//  Created by YangTengJiao on 2018/11/30.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PromptBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARGamePromptView : UIView
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *promptLabel;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) NSMutableDictionary *attributes;
@property (copy, nonatomic) PromptBlock promptBlock;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) NSString *type;
@property (assign, nonatomic) NSInteger currentNum;

- (void)showMagicCubePromptView;
- (void)showSpaceStationPromptView;
- (void)showPlantingTreesPromptView;

- (void)showSuccessWith:(NSString *)str;
- (void)showGameOver;
- (void)showPlantingTreesOverView;





@end

NS_ASSUME_NONNULL_END
