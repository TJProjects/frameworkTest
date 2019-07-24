//
//  ARMagicCubeGameViewController.h
//  AR
//
//  Created by YangTengJiao on 2018/11/28.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyARPlayer/player_controller.oc.h>
typedef void(^MagicCubeGameBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARMagicCubeGameViewController : easyar_PlayerController

@property (strong, nonatomic) NSString *magicCubeGameRewardString;//魔方奖励文案
@property (assign, nonatomic) NSInteger magicCubeGamePlayNum;//魔方游戏次数
@property (copy, nonatomic) MagicCubeGameBlock magicCubeGameBlock;//魔方回调

@end

NS_ASSUME_NONNULL_END
