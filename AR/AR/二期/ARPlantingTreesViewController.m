//
//  ARPlantingTreesViewController.m
//  AR
//
//  Created by YangTengJiao on 2018/12/5.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARPlantingTreesViewController.h"
#import <EasyARPlayer/player_view.oc.h>
#import <EasyARPlayer/message.oc.h>
#import <EasyARPlayer/messageclient.oc.h>
#import <EasyARPlayer/dictionary.oc.h>
#import "UserFileSystem.h"
#import "OCClient.h"
#import "OCUtil.h"
#import "ARDefine.h"
#import <ARKit/ARKit.h>
#define ARScene(self) ((easyar_PlayerView *)[self view])
#import <AVFoundation/AVFoundation.h>

#import "ARTreesGameTopView.h"
#import "DownLoadAnimationView.h"
#import "ARGamePromptView.h"
#import "MBProgressHUD.h"
//#import "ARTressGameRewardView.h"
#import "ARGamesAlertView.h"


#define SERVER_ADDRESS @"https://aroc-cn1.easyar.com/"
#define OCKEY @"13b3f68b87b3da9d118431ea37f7495d"
#define OCSCRET @"9e0ec8e72105bc61072f440f025f8c2b5e0d2fd002c348c24f96bf5e3f3beb16"



@interface ARPlantingTreesViewController ()
@property (strong, nonatomic) easyar_MessageClient *messageClient;
@property (strong, nonatomic) ARTreesGameTopView *topView;
@property (nonatomic, strong) DownLoadAnimationView *loadingView;
@property (nonatomic, strong) ARGamePromptView *promptView;
@property (nonatomic, strong) UIButton *takePhotoButton;
//@property (nonatomic, strong) ARTressGameRewardView *rewardView;
@property (nonatomic, strong) UIButton *putButton;
@property (nonatomic, strong) ARGamesAlertView *alertView;
@property (strong, nonatomic) NSDictionary *currentInfo;
@property (assign, nonatomic) BOOL isPostReset;


@end

@implementation ARPlantingTreesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[easyar_PlayerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [ARScene(self) setFPS:40];
    UserFileSystem *fileSystem = [[UserFileSystem alloc] init];
    [fileSystem setUserRootDir:[NSString stringWithFormat:@"%@/",[NSBundle mainBundle].bundlePath]];
    [ARScene(self) setFileSystem:fileSystem];
    
    __weak typeof(self) weakSelf = self;
    self.messageClient = [[easyar_MessageClient alloc] initWithPlayerView:ARScene(self) name:@"Client:Native" destName:@"Client:TS" callback:^(NSString *from, easyar_Message *message) {
        NSLog(@"from: %@ id: %d",from,message.theId);
        [weakSelf messageClientWithId:message.theId info:message.body];
    }];
    
    [self initSubViews];
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    AVAuthorizationStatusNotDetermined = 0,判断是否启用相册权限
    //    AVAuthorizationStatusRestricted    = 1,受限制
    //    AVAuthorizationStatusDenied        = 2,不允许
    //    AVAuthorizationStatusAuthorized    = 3,允许
    NSLog(@"authStatus %ld",(long)authStatus);
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //第一次成功的操作
                    [weakSelf loadEzp];
                });
            }else{
                //第一次不允许的操作
                [weakSelf.loadingView stopAnimation];
                [weakSelf.alertView showCamareError];
            }
        }];
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [weakSelf.loadingView stopAnimation];
        [weakSelf.alertView showCamareError];
    } else if (authStatus == AVAuthorizationStatusAuthorized) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //第一次成功的操作
            [weakSelf loadEzp];
        });
    }
}
- (void)loadEzp {
    __weak typeof(self) weakSelf = self;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"environment" ofType:@"ezp"];
    if (@available(iOS 11.0, *)) {
        if ([ARWorldTrackingConfiguration isSupported]) {
            NSString *path = [ARImage getEzpPath:@"arkit_Scence2"];
            NSLog(@"arkit path: %@", path);
            [ARScene(self) loadPackage:path onFinish:^{
                [weakSelf loadmArID];
            }];
            return;
        }
    }
    [self.loadingView stopAnimation];
    [self.alertView showUnSupportARkit];
}
- (void)loadmArID {
    __weak typeof(self) weakSelf = self;
    OCClient*occ = [OCClient sharedClient];
    [occ setServerAddress:SERVER_ADDRESS];
    [occ setServerAccessKey:OCKEY secret:OCSCRET];
//#define arid @"0fc85963-1305-453c-8b81-586bd796aa56"//正式
//#define arid @"34789dc1-8d40-4e7a-87ae-d720cbc1b7e7"//测试
    NSString *loadId = @"0fc85963-1305-453c-8b81-586bd796aa56";
    if ([self.plantingTreesGameTreeID isEqualToString:@"T0001"]) {
        loadId = @"0fc85963-1305-453c-8b81-586bd796aa56";
    } else if ([self.plantingTreesGameTreeID isEqualToString:@"T0002"]) {
        loadId = @"6d77cfa9-bb1b-4f03-8a18-ccfd41d75444";
    } else if ([self.plantingTreesGameTreeID isEqualToString:@"T0003"]) {
        loadId = @"c0260c89-fdf2-4c01-b81b-6b16c2147121";
    } else if ([self.plantingTreesGameTreeID isEqualToString:@"T0004"]) {
        loadId = @"2eec5a40-d4af-45ae-a2b1-de7eee2036ea";
    } else if ([self.plantingTreesGameTreeID isEqualToString:@"T0005"]) {
        loadId = @"adbacbd6-e9d3-435a-823b-27d83d46ae55";
    }
    [occ loadARAsset:loadId completionHandler:^(OCARAsset *asset, NSError *error) {
        NSString*assetLocalAbsolutePath = [asset localAbsolutePath];
        if (assetLocalAbsolutePath) {
            [ARScene(weakSelf) loadPackage:assetLocalAbsolutePath onFinish:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"loadARAsset Successfully!");
                    [weakSelf.loadingView stopAnimation];
                    [weakSelf.promptView showPlantingTreesPromptView];
                });
            }];
        } else {
            NSLog(@"下载失败 %@",loadId);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.loadingView stopAnimation];
                [weakSelf.alertView showHttpErrorViewBack];
            });
        }
    } progressHandler:^(NSString *taskName, float progress) {
        
    }];
}
- (void)initSubViews {
    self.isPostReset = NO;
    
    __weak typeof(self) weakSelf = self;
    self.topView = [[ARTreesGameTopView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kStatusBarHeight+30)];
    [self.view addSubview:self.topView];
    self.topView.buttonBlock = ^(NSString *type) {
        if ([type isEqualToString:@"back"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"trees"]) {
            NSLog(@"messageClient send 101");
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:101 body:nil]];
            [weakSelf.topView showWaterButton];
        } else if ([type isEqualToString:@"water"]) {
            NSLog(@"messageClient send 102");
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:102 body:nil]];
        }
    };
    [self.topView showBack];
    
    self.putButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.putButton setBackgroundImage:[ARImage imageNamed:@"btn_put"] forState:UIControlStateNormal];
    self.putButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [self.putButton setTitle:@"投  放" forState:UIControlStateNormal];
    [self.putButton addTarget:self action:@selector(putAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.putButton];
    [self.putButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30-kTabbarSafeBottomMargin);
        make.width.equalTo(@258);
        make.height.equalTo(@80);
    }];
    self.putButton.hidden = YES;
    
    self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.takePhotoButton setBackgroundImage:[ARImage imageNamed:@"拍照"] forState:UIControlStateNormal];
    [self.takePhotoButton addTarget:self action:@selector(takePhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.takePhotoButton];
    [self.takePhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-30-kTabbarSafeBottomMargin);
        make.width.equalTo(@74);
        make.height.equalTo(@74);
    }];
    self.takePhotoButton.hidden = YES;
    
    self.loadingView = [[DownLoadAnimationView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
//    self.rewardView = [[ARTressGameRewardView alloc] initWithFrame:CGRectMake(KScreenWidth/2.0, KScreenHeight/2.0, 114, 38)];
//    [self.view addSubview:self.rewardView];
    
    self.promptView = [[ARGamePromptView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.promptView];
    self.promptView.promptBlock = ^(NSString *type) {
        if ([type isEqualToString:@"PlantingTrees"]) {
            [weakSelf.topView showUnButton];
            NSLog(@"messageClient send 5114");
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5114 body:nil]];
        } else if ([type isEqualToString:@"TreesOver"]) {
            if (weakSelf.plantingTreesGamePlayNum == 0) {
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
            }
//            else {
//                [weakSelf.topView showTreeButton];
//                NSLog(@"messageClient send 103");
//                [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:103 body:nil]];
//            }
        }
    };
    
    self.alertView = [[ARGamesAlertView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.alertView];
    self.alertView.alertBlock = ^(NSString * _Nonnull type) {
        if ([type isEqualToString:@"showPutErrorView"]) {
            
        } else if ([type isEqualToString:@"showHttpErrorViewRetry"]) {
            [weakSelf postInfoWith:weakSelf.currentInfo];
        } else if ([type isEqualToString:@"showHttpErrorViewClose"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }  else if ([type isEqualToString:@"showPickingFruitViewWithRetry"]) {
            if (weakSelf.plantingTreesGamePlayNum == 0) {
                [weakSelf.alertView showPickingOverView];
            }
            if (weakSelf.isPostReset) {
                NSLog(@"messageClient send 103");
                [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:103 body:nil]];
                weakSelf.isPostReset = NO;
            }
        } else if ([type isEqualToString:@"showPickingFruitViewWithClose"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"showPickingOverView"]) {
            
        } else if ([type isEqualToString:@"showCamareError"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"showUnSupportARkit"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"showHttpErrorViewBack"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    };
}
- (void)putAction {
    self.putButton.hidden = YES;
    [self.topView showTreeButton];
    easyar_Dictionary *body = [easyar_Dictionary new];
    [body setString:self.plantingTreesGameFruitID forKey:@"kind"];
    NSLog(@"messageClient send 5113 %@",self.plantingTreesGameFruitID);
    [self.messageClient send:[[easyar_Message alloc] initWithId:5113 body:body]];
}
- (void)takePhotoButton:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    [ARScene(self) snapshot:^(UIImage *image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    } failed:^(NSString *msg) {
        NSLog(@"msg %@",msg);
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"save to System photo album error %@",error);
        [self showToast:@"图片保存失败，请打开相册权限"];
    } else {
        [self showToast:@"图片保存成功"];
        NSLog(@"save to System photo album Success");
    }
}

#pragma mark - showToast
- (void)showToast:(NSString*)content
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = content;
    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    [hud hideAnimated:YES afterDelay:1.0];
}
- (void)messageClientWithId:(NSInteger )MID info:(easyar_Dictionary *)info {
    switch (MID) {
        case 7779://显示投放按钮
        {
            if ([info getInt32ForKey:@"state"] == 0) {
                self.putButton.hidden = NO;
            } else {
                [self.topView showUnButton];
                [self.alertView showPutErrorView];
            }
        }
            break;
        case 110://收取果实
        {
            if (self.plantingTreesGamePlayNum == 0) {
//                self.promptView.currentNum = self.plantingTreesGamePlayNum;
//                [self.promptView showPlantingTreesOverView];
                [self.alertView showPickingOverView];
            } else {
                [self postInfoWith:@{@"plantingTreesGameBlock":@"reward",@"appleId":[info getStringForKey:@"appleId"]}];
            }
        }
            break;
        case 111://果实摘完
        {
            self.isPostReset = YES;
//            [self postInfoWith:@{@"plantingTreesGameBlock":@"gameOver",@"appleId":@"0"}];
        }
        case 112:
        {
            self.takePhotoButton.hidden = NO;
            [self.topView showUnButton];
        }
            
        default:
            break;
    }
}

- (void)setPlantingTreesGameRewardString:(NSString *)plantingTreesGameRewardString {
    _plantingTreesGameRewardString = plantingTreesGameRewardString;
    if (_plantingTreesGameRewardString.length > 0) {
        if ([_plantingTreesGameRewardString isEqualToString:@"网络请求失败"]) {
            [self.alertView showHttpErrorView];
        } else {
//            [self.rewardView showRewardWith:_plantingTreesGameRewardString];
            [self.alertView showPickingFruitViewWith:_plantingTreesGameRewardString num:_plantingTreesGamePlayNum];
        }
    }
}

- (void)setPlantingTreesGamePlayNum:(NSInteger)plantingTreesGamePlayNum {
    _plantingTreesGamePlayNum = plantingTreesGamePlayNum;
}

- (void)postInfoWith:(NSDictionary *)info {
    self.currentInfo = info;
    if (self.plantingTreesGameBlock) {
        self.plantingTreesGameBlock(info[@"plantingTreesGameBlock"],info[@"appleId"]);
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
