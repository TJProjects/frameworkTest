//
//  ARSpaceStationViewController.m
//  AR
//
//  Created by YangTengJiao on 2018/12/5.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARSpaceStationViewController.h"
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
#import "ARLoadIdVideoView.h"
#import "ARGamesAlertView.h"

#define SERVER_ADDRESS @"https://aroc-cn1.easyar.com/"
#define OCKEY @"13b3f68b87b3da9d118431ea37f7495d"
#define OCSCRET @"9e0ec8e72105bc61072f440f025f8c2b5e0d2fd002c348c24f96bf5e3f3beb16"

#define arid @"e830068e-2e7b-4f95-80eb-c52bd4b0d448"//正式
//#define arid @"34789dc1-8d40-4e7a-87ae-d720cbc1b7e7"//测试

@interface ARSpaceStationViewController ()
@property (strong, nonatomic) easyar_MessageClient *messageClient;
@property (strong, nonatomic) ARTreesGameTopView *topView;
@property (nonatomic, strong) DownLoadAnimationView *loadingView;
@property (nonatomic, strong) ARGamePromptView *promptView;
@property (strong, nonatomic) ARLoadIdVideoView *videoView;
@property (nonatomic, strong) UIButton *putButton;
@property (nonatomic, strong) ARGamesAlertView *alertView;

@end

@implementation ARSpaceStationViewController

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
    NSString *loadId;
    loadId = arid;
    [occ loadARAsset:loadId completionHandler:^(OCARAsset *asset, NSError *error) {
        NSString*assetLocalAbsolutePath = [asset localAbsolutePath];
        if (assetLocalAbsolutePath) {
            [ARScene(weakSelf) loadPackage:assetLocalAbsolutePath onFinish:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"loadARAsset Successfully!");
                    [weakSelf.loadingView stopAnimation];
                    [weakSelf.promptView showSpaceStationPromptView];
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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameInfoBack:) name:@"ARGameInfoBack" object:nil];
    
    __weak typeof(self) weakSelf = self;
    self.topView = [[ARTreesGameTopView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kStatusBarHeight+30)];
    [self.topView showSpaceStationView];
    [self.view addSubview:self.topView];
    self.topView.buttonBlock = ^(NSString *type) {
        if ([type isEqualToString:@"back"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    };
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.topView.hidden = YES;
//    });
    self.loadingView = [[DownLoadAnimationView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.loadingView];
    [self.loadingView startAnimation];
    
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
    
    self.promptView = [[ARGamePromptView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.promptView];
    self.promptView.promptBlock = ^(NSString *type) {
        if ([type isEqualToString:@"SpaceStation"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.topView.hidden = NO;
//            });
            NSLog(@"messageClient send 5114");
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5114 body:nil]];
        } else if ([type isEqualToString:@"TreesOver"]) {

        }
    };
    
    self.alertView = [[ARGamesAlertView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.alertView];
    self.alertView.alertBlock = ^(NSString * _Nonnull type) {
        if ([type isEqualToString:@"showPutErrorView"]) {
            
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
    NSLog(@"messageClient send 5113");
    [self.messageClient send:[[easyar_Message alloc] initWithId:5113 body:nil]];
}

- (void)messageClientWithId:(NSInteger )MID info:(easyar_Dictionary *)info {
    switch (MID) {
        case 7779:
        {
            if ([info getInt32ForKey:@"state"] == 0) {
                self.putButton.hidden = NO;
            } else {
                [self.alertView showPutErrorView];
            }
        }
            break;
        case 1110:
        {
            [self.videoView playVideoWith:[info getStringForKey:@"video"]];
        }
            break;

        default:
            break;
    }
}

- (void)postInfoWith:(NSDictionary *)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ARGameInfoChange" object:nil userInfo:info];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark 视频初始化
- (ARLoadIdVideoView *)videoView {
    if (!_videoView) {
//        _videoView = [[ARLoadIdVideoView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _videoView = [[ARLoadIdVideoView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
        _videoView.center = self.view.center;
        _videoView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.view addSubview:_videoView];
    }
    return _videoView;
}

- (void)dealloc {
    [_videoView removeSelf];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"---------------------- ARInstructionsScanViewController dealloc ----------------------");
}

@end
