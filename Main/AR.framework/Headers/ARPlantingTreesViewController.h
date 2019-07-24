//
//  ARPlantingTreesViewController.h
//  AR
//
//  Created by YangTengJiao on 2018/12/5.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyARPlayer/player_controller.oc.h>
//appleId 0苹果  1红包
typedef void(^PlantingTreesGameBlock)(NSString *type,NSString *fruitID);

NS_ASSUME_NONNULL_BEGIN

@interface ARPlantingTreesViewController : easyar_PlayerController

@property (assign, nonatomic) NSString *plantingTreesGameTreeID;
@property (assign, nonatomic) NSString *plantingTreesGameFruitID;
@property (strong, nonatomic) NSString *plantingTreesGameRewardString;
@property (assign, nonatomic) NSInteger plantingTreesGamePlayNum;
@property (copy, nonatomic) PlantingTreesGameBlock plantingTreesGameBlock;

@end

NS_ASSUME_NONNULL_END
