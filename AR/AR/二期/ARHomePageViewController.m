//
//  ARHomePageViewController.m
//  AR
//
//  Created by YangTengJiao on 2018/11/28.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARHomePageViewController.h"
#import "ARDefine.h"

#import "ARMagicCubeGameViewController.h"
#import "ARPlantingTreesViewController.h"
#import "ARSpaceStationViewController.h"

#define kMagicCube @"MagicCube" //    魔方 MagicCube
#define kSpaceStation @"SpaceStation" //    空间站 SpaceStation
#define kPlantingTrees @"PlantingTrees" //    种树 PlantingTrees

#define kAanimationDuration 1


@interface ARHomePageViewController () <CAAnimationDelegate>
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIButton *centerButton;
@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) UIImageView *centerView;
@property (strong, nonatomic) UIImageView *leftView;
@property (strong, nonatomic) UIImageView *RightView;
@property (assign, nonatomic) CGRect centerBounds;
@property (assign, nonatomic) CGRect leftBounds;
@property (assign, nonatomic) CGRect rightBounds;
@property (assign, nonatomic) CGPoint centerPosition;
@property (assign, nonatomic) CGPoint leftPosition;
@property (assign, nonatomic) CGPoint rightPosition;
@property (assign, nonatomic) CGRect centerFrame;
@property (assign, nonatomic) CGRect leftFrame;
@property (assign, nonatomic) CGRect rightFrame;

@property (assign, nonatomic) BOOL isAnimation;


@end

@implementation ARHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSubViews];
}

- (void)initSubViews {
    self.isAnimation = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameInfoChange:) name:@"ARGameInfoChange" object:nil];
    __weak typeof(self) weakSelf = self;
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.type = kMagicCube;
    
    self.bgImageView = [[UIImageView alloc] init];
    [self.bgImageView setImage:[ARImage imageNamed:@"GameBG"]];
    self.bgImageView.frame = self.view.bounds;
    [self.view addSubview:self.bgImageView];
    
//    self.centerImageView = [[UIImageView alloc] init];
//    self.centerImageView.userInteractionEnabled = YES;
//    [self.centerImageView setImage:[ARImage imageNamed:@"找茬中间"]];
//    [self.view addSubview:self.centerImageView];
//    [self.centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.view.mas_centerX);
//        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-56);
//        make.width.equalTo(@344);
//        make.height.equalTo(@231);
//    }];
//
//    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.centerImageView addSubview:self.leftButton];
//    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(weakSelf.centerImageView.mas_leading);
//        make.centerY.equalTo(weakSelf.centerImageView.mas_centerY);
//        make.width.equalTo(@95);
//        make.height.equalTo(weakSelf.centerImageView.mas_height);
//    }];
//    [self.leftButton addTarget:self action:@selector(leftButton:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.centerImageView addSubview:self.rightButton];
//    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(weakSelf.centerImageView.mas_trailing);
//        make.centerY.equalTo(weakSelf.centerImageView.mas_centerY);
//        make.width.equalTo(@95);
//        make.height.equalTo(weakSelf.centerImageView.mas_height);
//    }];
//    [self.rightButton addTarget:self action:@selector(rightButton:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.centerImageView addSubview:self.centerButton];
//    [self.centerButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakSelf.centerImageView.mas_centerX);
//        make.centerY.equalTo(weakSelf.centerImageView.mas_centerY);
//        make.width.equalTo(@154);
//        make.height.equalTo(weakSelf.centerImageView.mas_height);
//    }];
//    [self.centerButton addTarget:self action:@selector(centerButton:) forControlEvents:UIControlEventTouchUpInside];
//
    
    self.leftView = [[UIImageView alloc] init];
    [self.leftView setImage:[ARImage imageNamed:@"card3"]];
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset(-110);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-60);
        make.width.equalTo(@159);
        make.height.equalTo(@241);
    }];

    self.RightView = [[UIImageView alloc] init];
    [self.RightView setImage:[ARImage imageNamed:@"card1"]];
    [self.view addSubview:self.RightView];
    [self.RightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX).offset(+110);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-60);
        make.width.equalTo(@159);
        make.height.equalTo(@241);
    }];

    self.centerView = [[UIImageView alloc] init];
    [self.centerView setImage:[ARImage imageNamed:@"card2"]];
    [self.view addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY).offset(-50);
        make.width.equalTo(@199);
        make.height.equalTo(@302);
    }];
    
    self.centerView.alpha = 1.0;
    self.leftView.alpha = 0.5;
    self.RightView.alpha = 0.5;

    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setBackgroundImage:[ARImage imageNamed:@"开启btn"] forState:UIControlStateNormal];
    [self.playButton setTitle:@"开  启" forState:UIControlStateNormal];
    self.playButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [self.view addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.centerView.mas_bottom).offset(+35);
        make.width.equalTo(@123);
        make.height.equalTo(@63);
    }];
    [self.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];

    UISwipeGestureRecognizer * recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];

    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];

}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    static BOOL isfirst = YES;
    if (isfirst) {
        self.leftPosition = self.leftView.layer.position;
        self.centerPosition = self.centerView.layer.position;
        self.rightPosition = self.RightView.layer.position;
        self.leftBounds = self.leftView.bounds;
        self.centerBounds = self.centerView.bounds;
        self.rightBounds = self.RightView.bounds;
        self.leftFrame = self.leftView.frame;
        self.rightFrame = self.RightView.frame;
        self.centerFrame = self.centerView.frame;
        isfirst = NO;
    }
    
    if (self.isAnimation) {
        return;
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        NSLog(@"swipe down");
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"swipe up");
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        self.isAnimation = YES;
        [self directionLeftAnimation];
    } else if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        self.isAnimation = YES;
        [self directionRightAnimation];
    }
    
}
- (void)directionLeftAnimation {
    if ([self.type isEqualToString:kMagicCube]) {
        self.type = kPlantingTrees;
        [self PlantingTreesCenterAnimation];
    } else if ([self.type isEqualToString:kSpaceStation]) {
        self.type = kMagicCube;
        [self MagicCubeCenterAnimation];
    } else if ([self.type isEqualToString:kPlantingTrees]) {
        self.type = kSpaceStation;
        [self SpaceStationCenterAnimation];
    }
}

- (void)directionRightAnimation {
    if ([self.type isEqualToString:kMagicCube]) {
        self.type = kSpaceStation;
        [self SpaceStationCenterAnimation];
    } else if ([self.type isEqualToString:kSpaceStation]) {
        self.type = kPlantingTrees;
        [self PlantingTreesCenterAnimation];
    } else if ([self.type isEqualToString:kPlantingTrees]) {
        self.type = kMagicCube;
        [self MagicCubeCenterAnimation];
    }
}

- (void)MagicCubeCenterAnimation {
    [self removeAllAnimations];
    [self changePositionWith:self.centerView position:self.centerPosition bounds:self.centerBounds];
    [self changePositionWith:self.leftView position:self.leftPosition bounds:self.leftBounds];
    [self changePositionWith:self.RightView position:self.rightPosition bounds:self.rightBounds];
    [self.view bringSubviewToFront:self.centerView];
    self.centerView.alpha = 1.0;
    self.leftView.alpha = 0.5;
    self.RightView.alpha = 0.5;
}
- (void)SpaceStationCenterAnimation {
    [self removeAllAnimations];
    [self changePositionWith:self.centerView position:self.rightPosition bounds:self.rightBounds];
    [self changePositionWith:self.leftView position:self.centerPosition bounds:self.centerBounds];
    [self changePositionWith:self.RightView position:self.leftPosition bounds:self.leftBounds];
    [self.view bringSubviewToFront:self.leftView];
    self.centerView.alpha = 0.5;
    self.leftView.alpha = 1.0;
    self.RightView.alpha = 0.5;
}
- (void)PlantingTreesCenterAnimation {
    [self removeAllAnimations];
    [self changePositionWith:self.centerView position:self.leftPosition bounds:self.leftBounds];
    [self changePositionWith:self.leftView position:self.rightPosition bounds:self.rightBounds];
    [self changePositionWith:self.RightView position:self.centerPosition bounds:self.centerBounds];
    [self.view bringSubviewToFront:self.RightView];
    self.centerView.alpha = 0.5;
    self.leftView.alpha = 0.5;
    self.RightView.alpha = 1.0;
}
- (void)removeAllAnimations {
    [self.leftView.layer removeAnimationForKey:@"position"];
    [self.centerView.layer removeAnimationForKey:@"position"];
    [self.RightView.layer removeAnimationForKey:@"position"];
    [self.leftView.layer removeAnimationForKey:@"bounds"];
    [self.centerView.layer removeAnimationForKey:@"bounds"];
    [self.RightView.layer removeAnimationForKey:@"bounds"];
    [self.leftView.layer removeAllAnimations];
    [self.RightView.layer removeAllAnimations];
    [self.centerView.layer removeAllAnimations];
}

- (void)changePositionWith:(UIView *)view position:(CGPoint )position bounds:(CGRect)bounds {
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = kAanimationDuration;
    animation.fromValue = [NSValue valueWithCGPoint:view.layer.position];
    animation.toValue = [NSValue valueWithCGPoint:position];
    animation.autoreverses = NO;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.delegate = self;
    [view.layer addAnimation:animation forKey:@"position"];
    [self changeBoundsWith:view bounds:bounds];
}
- (void)changeBoundsWith:(UIView *)view bounds:(CGRect)bounds {
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.duration = kAanimationDuration;
    animation.fromValue = [NSValue valueWithCGRect:view.layer.bounds];;
    animation.toValue = [NSValue valueWithCGRect:bounds];;
    animation.autoreverses = NO;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:@"bounds"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"animationDidStop");
    static NSInteger aNum = 0;
    aNum += 1;
    if (aNum == 3) {
        aNum = 0;
        [self changeFrame];
        self.isAnimation = NO;
    }
}

- (void)changeFrame {
    if ([self.type isEqualToString:kMagicCube]) {
        self.leftView.frame = self.leftFrame;
        self.centerView.frame = self.centerFrame;
        self.RightView.frame = self.rightFrame;
    } else if ([self.type isEqualToString:kSpaceStation]) {
        self.leftView.frame = self.centerFrame;
        self.centerView.frame = self.rightFrame;
        self.RightView.frame = self.leftFrame;
    } else if ([self.type isEqualToString:kPlantingTrees]) {
        self.leftView.frame = self.rightFrame;
        self.centerView.frame = self.leftFrame;
        self.RightView.frame = self.centerFrame;
    }
}

- (void)playButtonAction:(UIButton *)button {
    if ([self.type isEqualToString:kMagicCube]) {
        ARMagicCubeGameViewController *arVC = [[ARMagicCubeGameViewController alloc] init];
        arVC.magicCubeGamePlayNum = self.magicCubeGamePlayNum;
        [self presentViewController:arVC animated:NO completion:nil];
    } else if ([self.type isEqualToString:kPlantingTrees]) {
        ARPlantingTreesViewController *arVC = [[ARPlantingTreesViewController alloc] init];
        arVC.plantingTreesGamePlayNum = self.plantingTreesGamePlayNum;
        [self presentViewController:arVC animated:NO completion:nil];
    } else if ([self.type isEqualToString:kSpaceStation]) {
        ARSpaceStationViewController *arVC = [[ARSpaceStationViewController alloc] init];
        [self presentViewController:arVC animated:NO completion:nil];
    }
}

//- (void)gameInfoChange:(NSNotification *)notif {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSDictionary *dict = notif.userInfo;
//        if ([[dict allKeys] containsObject:@"magicCubeGameBlock"]) {
//            if (self.magicCubeGameBlock) {
//                self.magicCubeGameBlock(dict[@"magicCubeGameBlock"]);
//            }
//        } else if ([[dict allKeys] containsObject:@"plantingTreesGameBlock"]) {
//            if (self.plantingTreesGameBlock) {
//                self.plantingTreesGameBlock(dict[@"plantingTreesGameBlock"]);
//            }
//        }
//    });
//}

- (void)setMagicCubeGameRewardString:(NSString *)magicCubeGameRewardString {
    _magicCubeGameRewardString = magicCubeGameRewardString;
    [self postInfoWith:@{@"magicCubeGameRewardString":_magicCubeGameRewardString}];
}

- (void)setMagicCubeGamePlayNum:(NSInteger )magicCubeGamePlayNum {
    _magicCubeGamePlayNum = magicCubeGamePlayNum;
    [self postInfoWith:@{@"magicCubeGamePlayNum":[NSString stringWithFormat:@"%ld",(long)_magicCubeGamePlayNum]}];
}
;

- (void)postInfoWith:(NSDictionary *)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ARGameInfoBack" object:nil userInfo:info];
}


//- (void)leftButton:(UIButton *)button {
//    if ([self.type isEqualToString:kMagicCube]) {
//        self.type = kSpaceStation;
//    } else if ([self.type isEqualToString:kSpaceStation]) {
//        self.type = kPlantingTrees;
//    } else if ([self.type isEqualToString:kPlantingTrees]) {
//        self.type = kMagicCube;
//    }
//    [self startAnimationWith:self.type];
//}
//- (void)rightButton:(UIButton *)button {
//    if ([self.type isEqualToString:kMagicCube]) {
//        self.type = kPlantingTrees;
//    } else if ([self.type isEqualToString:kSpaceStation]) {
//        self.type = kMagicCube;
//    } else if ([self.type isEqualToString:kPlantingTrees]) {
//        self.type = kSpaceStation;
//    }
//    [self startAnimationWith:self.type];
//}
//- (void)centerButton:(UIButton *)button {
//    if ([self.type isEqualToString:kMagicCube]) {
//        self.type = kMagicCube;
//    } else if ([self.type isEqualToString:kSpaceStation]) {
//        self.type = kSpaceStation;
//    } else if ([self.type isEqualToString:kPlantingTrees]) {
//        self.type = kPlantingTrees;
//    }
//}
//
//- (void)startAnimationWith:(NSString *)type {
//    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    animation.fromValue=[NSNumber numberWithFloat:1.0];
//    animation.toValue=[NSNumber numberWithFloat:0.2];
//    animation.duration = 0.2;
//    animation.autoreverses = YES;
//    animation.repeatCount=0;
//    animation.removedOnCompletion=NO;
//    animation.fillMode=kCAFillModeForwards;
//    [self.centerImageView.layer addAnimation:animation forKey:@"zoom"];
//    __weak typeof(self) weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSString *imageName = @"找茬中间";
//        if ([weakSelf.type isEqualToString:kMagicCube]) {
//            imageName = @"找茬中间";
//        } else if ([weakSelf.type isEqualToString:kSpaceStation]) {
//            imageName = @"空间站在中间";
//        } else if ([weakSelf.type isEqualToString:kPlantingTrees]) {
//            imageName = @"树在中间";
//        }
//        [weakSelf.centerImageView setImage:[ARImage imageNamed:imageName]];
//    });
//}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ARGameInfoChange" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
