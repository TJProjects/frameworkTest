//
//  ARHomePageViewController.h
//  AR
//
//  Created by YangTengJiao on 2018/11/28.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef void(^MagicCubeGameBlock)(NSString *type);
//typedef void(^PlantingTreesGameBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARHomePageViewController : UIViewController

@property (strong, nonatomic) NSString *magicCubeGameRewardString;//魔方奖励文案
@property (assign, nonatomic) NSInteger magicCubeGamePlayNum;//魔方游戏次数
//@property (copy, nonatomic) MagicCubeGameBlock magicCubeGameBlock;//魔方回调

//种树 奖励文案，游戏次数，回调
@property (strong, nonatomic) NSString *plantingTreesGameRewardString;
@property (assign, nonatomic) NSInteger plantingTreesGamePlayNum;
//@property (copy, nonatomic) PlantingTreesGameBlock plantingTreesGameBlock;

@end

NS_ASSUME_NONNULL_END
