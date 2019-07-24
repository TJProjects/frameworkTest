//
//  ViewController.m
//  Main
//
//  Created by YangTengJiao on 2018/11/9.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ViewController.h"
#import <AR/AR.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonSelect:(id)sender {
    ARScanViewController *arVC = [[ARScanViewController alloc] init];
    arVC.gamePlayNum = 100;//生命值
    arVC.bombCount = @"3_5_5";
    arVC.GiftBagCount = @"3_5_5";
    arVC.treasureChestCount = @"3_5_5";
    __weak ARScanViewController *weakArVC = arVC;
    //    weakArVC.currentGiftString = @"网络请求失败";
    arVC.goodsBlock = ^(NSString *type) {
        if ([type isEqualToString:@"bomb"]) {//炸弹
            weakArVC.gamePlayNum -= 1;
            weakArVC.currentGiftString = @"";
        } else if ([type isEqualToString:@"GiftBag"]) {//红包
            weakArVC.gamePlayNum -= 1;
            weakArVC.currentGiftString = @"现金红包100元";
        } else if ([type isEqualToString:@"treasureChest"]) {//宝箱
            weakArVC.gamePlayNum -= 1;
            //             weakArVC.currentGiftString = @"网络请求失败";
            weakArVC.currentGiftString = @"爱奇艺会员卡";
        }
    };
    [self presentViewController:arVC animated:NO completion:nil];
}


- (IBAction)magicVC:(id)sender {
    ARMagicCubeGameViewController *arVC = [[ARMagicCubeGameViewController alloc] init];
    arVC.magicCubeGamePlayNum = 2;//魔方游戏次数
    __weak ARMagicCubeGameViewController *weakArVC = arVC;
    arVC.magicCubeGameBlock = ^(NSString *type) {//魔方游戏回调
        if ([type isEqualToString:@"success"]) {//魔方游戏成功回调
            weakArVC.magicCubeGamePlayNum -= 1;
            weakArVC.magicCubeGameRewardString = @"100元现金红包奖励可在泰信APP个人中心查收呦~";//奖励显示文案
        } else if ([type isEqualToString:@"fail"]) {//魔方游戏失败回调
//            weakArVC.magicCubeGameRewardString = @"网络请求失败";
            weakArVC.magicCubeGamePlayNum -= 1;
            weakArVC.magicCubeGameRewardString = @"";
        }
    };
    [self presentViewController:arVC animated:NO completion:nil];
}

- (IBAction)treesVC:(id)sender {
    ARPlantingTreesViewController *arVC = [[ARPlantingTreesViewController alloc] init];
    __weak ARPlantingTreesViewController *weakArVC = arVC;
    arVC.plantingTreesGameTreeID = @"T0001";
    arVC.plantingTreesGameFruitID = @"F0001";
    arVC.plantingTreesGamePlayNum = 8;//种树游戏次数
    arVC.plantingTreesGameBlock = ^(NSString *type, NSString *fruitID) {//种树游戏回调
        NSLog(@"plantingTreesGameBlock %@ %@",type,fruitID);
        if ([fruitID isEqualToString:@"F0001"]) {
            weakArVC.plantingTreesGamePlayNum -= 1;
            weakArVC.plantingTreesGameRewardString = @"恭喜您获得100元现金红包";//奖励显示文案
        }
    };
    [self presentViewController:arVC animated:NO completion:nil];
    
//    if ([type isEqualToString:@"reward"]) {//种树游戏摘取果实回调
//        if ([fruitID isEqualToString:@"F0001"]) {
//            weakArVC.plantingTreesGamePlayNum -= 1;
//            weakArVC.plantingTreesGameRewardString = @"恭喜您获得100元现金红包";//奖励显示文案
//        }
//    } else if ([type isEqualToString:@"gameOver"]) {//种树游戏摘完果实回调
//
//    }
}

- (IBAction)spaceVC:(id)sender {
    ARSpaceStationViewController *arVC = [[ARSpaceStationViewController alloc] init];
    [self presentViewController:arVC animated:NO completion:nil];
}







@end
