//
//  ARScanViewController.m
//  TaiXin
//
//  Created by YangTengJiao on 2018/10/23.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARScanViewController.h"
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

#import "ARTopCodeView.h"
#import "ARHowToPlayCodeView.h"
#import "ARAlertCodeView.h"
#import "giftCodeView.h"
#import "DownLoadAnimationView.h"
#import "ARFirstShowView.h"
#import "ARDefine.h"
#import <AudioToolbox/AudioToolbox.h>

#define SERVER_ADDRESS @"https://aroc-cn1.easyar.com/"
#define OCKEY @"13b3f68b87b3da9d118431ea37f7495d"
#define OCSCRET @"9e0ec8e72105bc61072f440f025f8c2b5e0d2fd002c348c24f96bf5e3f3beb16"

#define mArKitID @"3cba5c87-05ab-4b09-9935-024d9773a55f"//正式
#define mArSlamID @"3bfa5c3d-c64f-4223-8aff-6fcde67e996e"//正式

//#define mArKitID @"86e8cc8f-d9a9-40eb-a0b2-a49ab5870d1a"//测试
//#define mArSlamID @"faceb756-e97a-4a1e-9da5-6eaf7441517c"


@interface ARScanViewController ()
@property (strong, nonatomic) easyar_MessageClient *messageClient;
@property (nonatomic, strong) DownLoadAnimationView *loadingView;
@property (strong, nonatomic) ARTopCodeView *topView;
@property (strong, nonatomic) ARHowToPlayCodeView *howToPlayView;
@property (strong, nonatomic) ARAlertCodeView *alertView;
@property (strong, nonatomic) giftCodeView *giftView;
@property (assign, nonatomic) BOOL isLoadedEzp;
@property (strong, nonatomic) ARFirstShowView *firstView;

@end

@implementation ARScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.giftArray = [[NSMutableArray alloc] init];
    self.view = [[easyar_PlayerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [ARScene(self) setFPS:40];
    UserFileSystem *fileSystem = [[UserFileSystem alloc] init];
    [fileSystem setUserRootDir:[NSString stringWithFormat:@"%@/",[NSBundle mainBundle].bundlePath]];
    [ARScene(self) setFileSystem:fileSystem];

    __weak typeof(self) weakSelf = self;
    self.messageClient = [[easyar_MessageClient alloc] initWithPlayerView:ARScene(self) name:@"Client:Native" destName:@"Client:TS" callback:^(NSString *from, easyar_Message *message) {
        NSLog(@"from: %@ \n id: %d %d",from,message.theId,[message.body getInt32ForKey:@"taggerID"]);
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
    NSString *path = [ARImage getEzpPath:@"slam_Scence"];
    if (@available(iOS 11.0, *)) {
        if ([ARWorldTrackingConfiguration isSupported]) {
            path = [ARImage getEzpPath:@"arkit_Scence"];
            NSLog(@"arkit path: %@", path);
            [ARScene(self) loadPackage:path onFinish:^{
                [weakSelf loadmArID];
            }];
            return;
        }
    }
    NSLog(@"path: %@", path);
    [ARScene(self) loadPackage:path onFinish:^{
        [weakSelf.loadingView stopAnimation];
        [weakSelf.alertView showUnSupportARkit];
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setCurrentGiftString:(NSString *)currentGiftString {
    _currentGiftString = currentGiftString;
    self.giftView.hidden = YES;
    if (_currentGiftString.length > 0) {
        if ([_currentGiftString isEqualToString:@"网络请求失败"]) {
            [self.alertView showHttpError];
        } else {
            [self.alertView showContureAndGiftGameWith:[NSString stringWithFormat:@"恭喜您！ \n获得%@！",_currentGiftString]];
            [self.giftArray addObject:_currentGiftString];
        }
    } else {
        [self.alertView showContureGame];
    }
}

- (void)setGameCountsInfo:(NSDictionary *)gameCountsInfo {
    _gameCountsInfo = gameCountsInfo;
}

- (void)setGamePlayNum:(NSInteger)gamePlayNum {
    _gamePlayNum = gamePlayNum;
    self.topView.centerLabel.text = [NSString stringWithFormat:@"次数+%ld",(long)_gamePlayNum];
}

- (void)initSubViews {
    __weak typeof(self) weakSelf = self;
    self.topView = [[ARTopCodeView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kStatusBarHeight-5 + 36)];
    self.topView.centerLabel.text = [NSString stringWithFormat:@"次数+%ld",(long)self.gamePlayNum];
    [self.view addSubview:self.topView];
    self.topView.buttonBlock = ^(NSString *type) {
        if ([type isEqualToString:@"back"]) {
            [weakSelf.alertView showSureOutGame];
        } else if ([type isEqualToString:@"gift"]) {
            if (weakSelf.alertView.hidden == YES) {
                [weakSelf.giftView showViewWithInfo:weakSelf.giftArray];
                NSLog(@"messageClient send 5114");
                easyar_Dictionary*body = [easyar_Dictionary new];
                [body setString:@"false" forKey:@"collor"];
                [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5114 body:body]];
            }
        }
    };
    self.topView.hidden = YES;
    
    self.loadingView = [[DownLoadAnimationView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
    self.howToPlayView = [[ARHowToPlayCodeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.howToPlayView];
    self.howToPlayView.buttonBlock = ^(NSString *type) {
        [weakSelf.howToPlayView hiddenView];
        [weakSelf sendGameALLCounts];
    };
    self.howToPlayView.hidden = YES;
    
    self.firstView = [[ARFirstShowView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.firstView];
    self.firstView.hiddenBlock = ^(NSString *type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.howToPlayView.hidden = NO;
        });
    };
    
    self.alertView = [[ARAlertCodeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.alertView];
    self.alertView.buttonBlock = ^(NSString *type) {
        if ([type isEqualToString:@"cancle"]) {

        } else if ([type isEqualToString:@"sure"]) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else if ([type isEqualToString:@"gift"]) {
            NSLog(@"messageClient send 5112");
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5112 body:nil]];
            [weakSelf.giftView showViewWithInfo:weakSelf.giftArray];
            NSLog(@"messageClient send 5114");
            easyar_Dictionary*body = [easyar_Dictionary new];
            [body setString:@"false" forKey:@"collor"];
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5114 body:body]];
        } else if ([type isEqualToString:@"conture"]) {
            [weakSelf checkAndBackGame];
        } else if ([type isEqualToString:@"back"]) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        } else if ([type isEqualToString:@"scan"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf sendGameALLCounts];
            });
        }
    };
    
    self.giftView = [[giftCodeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.giftView];
    self.giftView.buttonBlock = ^(NSString *type) {
        if (weakSelf.gamePlayNum <= 0) {
            NSLog(@"messageClient send 5113");
            easyar_Dictionary*body = [easyar_Dictionary new];
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5113 body:body]];
        } else {
            NSLog(@"messageClient send 5114");
            easyar_Dictionary*body = [easyar_Dictionary new];
            [body setString:@"true" forKey:@"collor"];
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5114 body:body]];
        }
    };
}

- (void)sendGameALLCounts {
    if (self.isLoadedEzp) {
        self.topView.hidden = NO;
        NSLog(@"messageClient send 5110");
        easyar_Dictionary*body = [easyar_Dictionary new];
        [body setString:self.GiftBagCount forKey:@"GiftBag"];
        [body setString:self.bombCount forKey:@"bomb"];
        [body setString:self.treasureChestCount forKey:@"treasureChest"];
        [self.messageClient send:[[easyar_Message alloc] initWithId:5110 body:body]];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendGameALLCounts];
        });
    }
}
- (void)checkAndBackGame {
    NSLog(@"checkAndBackGame %ld",(long)self.gamePlayNum);
    if (self.gamePlayNum > 0) {
        NSLog(@"messageClient send 5112");
        easyar_Dictionary*body = [easyar_Dictionary new];
        [self.messageClient send:[[easyar_Message alloc] initWithId:5112 body:body]];
    } else {
        NSLog(@"messageClient send 5113");
        easyar_Dictionary*body = [easyar_Dictionary new];
        [self.messageClient send:[[easyar_Message alloc] initWithId:5113 body:body]];
    }
}

- (void)messageClientWithId:(NSInteger )MID info:(easyar_Dictionary *)info {
    __weak typeof(self) weakSelf = self;
    switch (MID) {
        case 7240:
        {
            switch ([info getInt32ForKey:@"taggerID"]) {
                case 0://炸弹
                {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动
                    if (self.goodsBlock) {
                        self.goodsBlock(@"bomb");
                    }
                }
                    break;
                case 1://红包
                {
                    if (self.goodsBlock) {
                        self.goodsBlock(@"GiftBag");
                    }                }
                    break;
                case 2://宝箱
                {
                    if (self.goodsBlock) {
                        self.goodsBlock(@"treasureChest");
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 7241:
        {
            [self.alertView showBackVC];
        }
            break;
        case 7242:
        {
            [self.alertView showRecognitionPlanError];
        }
            break;
            case 7243:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"first");
                UIImageView *first = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"toast1"]];
                [weakSelf.view addSubview:first];
                [first mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(weakSelf.view.mas_centerX);
                    make.centerY.equalTo(weakSelf.view.mas_centerY);
                    make.width.equalTo(@262);
                    make.height.equalTo(@63);
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSLog(@"second");
                    if (!weakSelf) {
                        return;
                    }
                    [first removeFromSuperview];
                    UIImageView *second = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"toast2"]];
                    [weakSelf.view addSubview:second];
                    [second mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerX.equalTo(weakSelf.view.mas_centerX);
                        make.centerY.equalTo(weakSelf.view.mas_centerY);
                        make.width.equalTo(@262);
                        make.height.equalTo(@63);
                    }];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!weakSelf) {
                            return;
                        }
                        [second removeFromSuperview];
                    });
                });
            });
        }
            break;
            
        default:
            break;
    }
}

- (void)loadmArID {
    __weak typeof(self) weakSelf = self;
    OCClient*occ = [OCClient sharedClient];
    [occ setServerAddress:SERVER_ADDRESS];
    [occ setServerAccessKey:OCKEY secret:OCSCRET];
    NSString *loadId;
    if (@available(iOS 11.0, *)) {
        if ([ARWorldTrackingConfiguration isSupported]) {
            loadId = mArKitID;
        } else {
            loadId = mArSlamID;
        }
    } else {
        loadId = mArSlamID;
    }
    [occ loadARAsset:loadId completionHandler:^(OCARAsset *asset, NSError *error) {
        NSString*assetLocalAbsolutePath = [asset localAbsolutePath];
        if (assetLocalAbsolutePath) {
            [ARScene(weakSelf) loadPackage:assetLocalAbsolutePath onFinish:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"loadARAsset Successfully!");
                    weakSelf.isLoadedEzp = YES;
                    [weakSelf.loadingView stopAnimation];
//                    weakSelf.howToPlayView.hidden = NO;
                    [weakSelf.firstView startAnimation];
                });
            }];
        } else {
            NSLog(@"下载失败 %@",mArKitID);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.loadingView stopAnimation];
                [weakSelf.alertView showHttpError];
            });
        }
    } progressHandler:^(NSString *taskName, float progress) {

    }];
}

@end
