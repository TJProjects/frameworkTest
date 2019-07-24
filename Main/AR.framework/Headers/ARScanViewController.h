//
//  ARScanViewController.h
//  TaiXin
//
//  Created by YangTengJiao on 2018/10/23.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EasyARPlayer/player_controller.oc.h>

typedef void(^SelectGoodsBlock)(NSString *type);

NS_ASSUME_NONNULL_BEGIN

@interface ARScanViewController : easyar_PlayerController

@property (nonatomic, copy) SelectGoodsBlock goodsBlock;//碰撞回调
@property (nonatomic, strong) NSString *bombCount;//炸弹个数
@property (nonatomic, strong) NSString *GiftBagCount;//红包个数
@property (nonatomic, strong) NSString *treasureChestCount;//宝箱个数
@property (nonatomic, strong) NSDictionary *gameCountsInfo;//初始化信息
@property (nonatomic, assign) NSInteger gamePlayNum;//生命值
@property (nonatomic, strong) NSString *currentGiftString;//当前获取奖励
@property (nonatomic, strong) NSMutableArray *giftArray;//奖励列表



@end

NS_ASSUME_NONNULL_END
