//
//  ARMagicCubeGameViewController.m
//  AR
//
//  Created by YangTengJiao on 2018/11/28.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import "ARMagicCubeGameViewController.h"
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
#import <ARKit/ARKit.h>

#import "ARGameTopView.h"
#import "DownLoadAnimationView.h"
#import "ARGamePromptView.h"
#import "ARGameTips.h"
#import "ARGamesAlertView.h"

#define SERVER_ADDRESS @"https://aroc-cn1.easyar.com/"
#define OCKEY @"13b3f68b87b3da9d118431ea37f7495d"
#define OCSCRET @"9e0ec8e72105bc61072f440f025f8c2b5e0d2fd002c348c24f96bf5e3f3beb16"

#define arid @"861d8ef1-2a7f-4af9-ac1e-11407211e392"//正式
//#define arid @"2dee1605-9bc6-4da3-84dc-6db0636b3f55"//测试

#define kCacheName @"MagicCubeCaches"


@interface ARMagicCubeGameViewController ()
@property (strong, nonatomic) easyar_MessageClient *messageClient;
@property (strong, nonatomic) ARGameTopView *topView;
@property (nonatomic, strong) DownLoadAnimationView *loadingView;
@property (nonatomic, strong) ARGamePromptView *promptView;
@property (nonatomic, strong) UIButton *putButton;
@property (nonatomic, strong) ARGameTips *tipsView;
@property (nonatomic, strong) UIButton *helpButton;
@property (nonatomic, strong) ARGamesAlertView *alertView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger loadedNum;
@property (assign, nonatomic) BOOL isLoadSuccess;
@property (assign, nonatomic) BOOL isFirstOpen;
@property (assign, nonatomic) BOOL isTipsShowFirst;
@property (strong, nonatomic) NSDictionary *currentInfo;
@property (assign, nonatomic) BOOL isShowSuccess;



@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) UIButton *giftButton;

@end

@implementation ARMagicCubeGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[easyar_PlayerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [ARScene(self) setFPS:40];
    UserFileSystem *fileSystem = [[UserFileSystem alloc] init];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageSavePath = [cachePath stringByAppendingPathComponent:kCacheName];
    [fileSystem setUserRootDir:imageSavePath];
    [ARScene(self) setFileSystem:fileSystem];
    
    __weak typeof(self) weakSelf = self;
    self.messageClient = [[easyar_MessageClient alloc] initWithPlayerView:ARScene(self) name:@"Client:Native" destName:@"Client:TS" callback:^(NSString *from, easyar_Message *message) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"from: %@ id: %d",from,message.theId);
            [weakSelf messageClientWithId:message.theId info:message.body];
        });
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
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification  object:app queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf.topView pasueTimer];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification  object:app queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf.topView resumeTimer];
    }];
}
- (void)initSubViews {
    
    __weak typeof(self) weakSelf = self;
    self.loadedNum = 0;
    self.isLoadSuccess = YES;
    self.isFirstOpen = YES;
    self.dataArray = [[NSMutableArray alloc] init];
    self.isTipsShowFirst = YES;
    self.isShowSuccess = NO;
    
    self.topView = [[ARGameTopView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kStatusBarHeight+30)];
    [self.view addSubview:self.topView];
    self.topView.buttonBlock = ^(NSString *type) {
        if ([type isEqualToString:@"back"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"timeOver"]) {
            if (weakSelf.isShowSuccess) {
                return;
            }
            NSLog(@"messageClient send 5112");
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5112 body:nil]];
            [weakSelf postInfoWith:@{@"magicCubeGameBlock":@"fail"}];
        }
    };
    [self.topView showBack];
    
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
    
    self.helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.helpButton.frame = CGRectMake(KScreenWidth-16-34, KScreenHeight-34-16-kTabbarSafeBottomMargin, 34, 34);
    [self.helpButton setImage:[ARImage imageNamed:@"wenhao-2"] forState:UIControlStateNormal];
    [self.helpButton addTarget:self action:@selector(helpAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.helpButton];
    self.helpButton.hidden = YES;
    
    self.promptView = [[ARGamePromptView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.promptView];
    self.promptView.promptBlock = ^(NSString *type) {
        if ([type isEqualToString:@"MagicCube"]) {
            NSLog(@"messageClient send 5110");
            [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5110 body:nil]];
            [weakSelf.topView showdefault];
//            [weakSelf.topView startTimer];
        } else if ([type isEqualToString:@"SpaceStation"]) {
            
        } else if ([type isEqualToString:@"PlantingTrees"]) {
            
        } else if ([type isEqualToString:@"Success"]) {
            if (weakSelf.magicCubeGamePlayNum == 0) {
                [weakSelf.alertView showMagicCubeOver];
            } else {
                [weakSelf.loadingView startAnimation];
                NSLog(@"messageClient send 5111");
                [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5111 body:nil]];
            }
        } else if ([type isEqualToString:@"Error"]) {
            if (weakSelf.magicCubeGamePlayNum == 0) {
                [weakSelf.alertView showMagicCubeOver];
            } else {
                [weakSelf.loadingView startAnimation];
                NSLog(@"messageClient send 5111");
                [weakSelf.messageClient send:[[easyar_Message alloc] initWithId:5111 body:nil]];
            }
        } else if ([type isEqualToString:@"back"]) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    self.giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.giftButton.frame  = self.view.bounds;
    [self.view addSubview:self.giftButton];
    self.giftButton.hidden = YES;
    self.gifImageView.hidden = YES;
    
    
    self.tipsView = [[ARGameTips alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tipsView];
    self.tipsView.tipsBlock = ^(NSString * _Nonnull type) {
        if ([type isEqualToString:@"showCubeView"]) {
            weakSelf.helpButton.hidden = NO;
            [weakSelf palyGif];
            [weakSelf checkImagesTarting];
        } else if ([type isEqualToString:@"showHelpView"]) {
            weakSelf.helpButton.hidden = NO;
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
        } else if ([type isEqualToString:@"showCamareError"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"showMagicCubeOver"]) {
             [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"showUnSupportARkit"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        } else if ([type isEqualToString:@"showHttpErrorViewBack"]) {
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
        }
    };
}
- (void)helpAction {
    self.helpButton.hidden = YES;
    [self.tipsView showHelpView];
}
- (void)putAction {
    self.putButton.hidden = YES;
    NSLog(@"messageClient send 5113");
    [self.messageClient send:[[easyar_Message alloc] initWithId:5113 body:nil]];
}
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] init];
//        for (NSInteger i = 1 ; i <= 101; i++) {
//            UIImage *image = [ARImage imageNamed:[NSString stringWithFormat:@"倒计时%ld",(long)i]];
//            [_imageArray addObject:image];
//        }
        for (NSInteger i = 0; i <= 71; i++) {
            NSString *imageName = [NSString stringWithFormat:@"倒计时_%05ld",(long)i];
            NSLog(@"%@",imageName);
            UIImage *image = [ARImage imageNamed:imageName];
            [_imageArray addObject:image];
        }
    }
    return _imageArray;
}

- (UIImageView *)gifImageView {
    if (_gifImageView == nil) {
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 256, 256)];
        _gifImageView.center = self.view.center;
        _gifImageView.animationImages = self.imageArray;
        _gifImageView.animationDuration = 3.0; //每次动画时长
        _gifImageView.animationRepeatCount = 1.0;
//        [gifImageView startAnimating]; //开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
        [self.view addSubview:_gifImageView];
    }
    return _gifImageView;
}

- (void)palyGif {
    self.gifImageView.hidden = NO;
    self.giftButton.hidden = NO;
    [self.gifImageView startAnimating];
}

- (void)setMagicCubeGameRewardString:(NSString *)magicCubeGameRewardString {
    _magicCubeGameRewardString = magicCubeGameRewardString;
    if (self.magicCubeGameRewardString.length > 0) {
        if ([_magicCubeGameRewardString isEqualToString:@"网络请求失败"]) {
            [self.alertView showHttpErrorView];
        } else {
            [self.topView showDefaultImage];
            [self.promptView showSuccessWith:_magicCubeGameRewardString];
        }
        
    } else {
        [self.topView showFailImage];
        [self.promptView showGameOver];
    }
}

- (void)setMagicCubeGamePlayNum:(NSInteger )magicCubeGamePlayNum {
    _magicCubeGamePlayNum = magicCubeGamePlayNum;
    self.promptView.currentNum = _magicCubeGamePlayNum;
}
- (void)postInfoWith:(NSDictionary *)info {
    self.currentInfo = info;
    if (self.magicCubeGameBlock) {
        self.magicCubeGameBlock(info[@"magicCubeGameBlock"]);
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
        case 7778:
        {
            if (self.isTipsShowFirst) {
                [self.tipsView showCubeView];
                self.isTipsShowFirst = NO;
            } else {
                [self palyGif];
                [self checkImagesTarting];
            }
        }
            break;
        case 7777:
        {
            self.topView.currentCount = [NSString stringWithFormat:@"%d",[info getInt32ForKey:@"Count"]];
            [self.topView redyStartTimer];
            [self.dataArray removeAllObjects];
            self.loadedNum = 0;
            for (NSInteger i=0; i < 6; i++) {
                NSString *path = [NSString stringWithFormat:@"path%ld",(long)i];
                NSString *uipath = [NSString stringWithFormat:@"ui_path%ld",(long)i];
                [self.dataArray addObject:[info getStringForKey:path]];
                [self.dataArray addObject:[info getStringForKey:uipath]];
            }
            [self delMagicCubeCache];
            NSLog(@"load array %@",self.dataArray);
            [self startLoadImages];
        }
            break;
        case 7776:
        {
            if ([info getFloatForKey:@"result"] == 0) {
                self.isShowSuccess = YES;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSLog(@"7776  %f",[info getFloatForKey:@"result"]);
                [self.topView showPointSelectNum:[info getFloatForKey:@"result"]];
                if ([info getFloatForKey:@"result"] == 0) {
                    self.isShowSuccess = NO;
                    NSLog(@"messageClient send 5112");
                    [self.messageClient send:[[easyar_Message alloc] initWithId:5112 body:nil]];
                    [self.topView stopTimer];
                    [self postInfoWith:@{@"magicCubeGameBlock":@"success"}];
                }
            });
        }
            break;
            
        default:
            break;
    }
}

- (void)checkImagesTarting {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.gifImageView.isAnimating) {
            [self checkImagesTarting];
        } else {
            [self.topView startTimer];
            self.giftButton.hidden = YES;
        }
    });
}

- (void)startLoadImages {
    self.isLoadSuccess = YES;
    for (NSString *path in self.dataArray) {
        [self downloadimageFilesWithUrl:path];
    }
}

- (void)downloadimageFilesWithUrl:(NSString *)urlStr{
    __weak typeof(self) weakSelf = self;
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSArray *array = [urlStr componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!weakSelf) {
            return;
        }
        if(!error) {
            NSError *saveError;
            NSURL *saveUrl = [NSURL fileURLWithPath:[weakSelf getSavePatchWith:[array lastObject]]];
            [[NSFileManager defaultManager] copyItemAtURL:location toURL:saveUrl error:&saveError];
            [weakSelf downLoadOverCheck:!saveError];
        }else{
            [weakSelf downLoadOverCheck:NO];
        }
    }];
    [downloadTask resume];
}
- (void)downLoadOverCheck:(BOOL)isSuccess {
    self.loadedNum += 1;
    if (!isSuccess) {
        self.isLoadSuccess = NO;
    }
    if (self.loadedNum == 12) {
        if (self.isLoadSuccess) {
            NSLog(@"load Success");
            [self.loadingView stopAnimation];
            if (self.isFirstOpen) {
                [self.promptView showMagicCubePromptView];
            } else {
                NSLog(@"messageClient send 5110");
                [self.messageClient send:[[easyar_Message alloc] initWithId:5110 body:nil]];
//                [self.topView startTimer];
            }
            self.isFirstOpen = NO;
        } else {
            [self.loadingView stopAnimation];
            [self.alertView showHttpErrorViewBack];
        }
    }
}

- (void)delMagicCubeCache {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageSavePath = [cachePath stringByAppendingPathComponent:kCacheName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isdelSuccess = [fileManager removeItemAtPath:imageSavePath error:nil];
    if (!isdelSuccess) {
        NSLog(@"删除目录失败");
    } else {
        NSLog(@"删除目录成功");
    }
}
- (NSString *)getSavePatchWith:(NSString *)name {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageSavePath = [cachePath stringByAppendingPathComponent:kCacheName];
    BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:imageSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    if (!bo) {
        NSLog(@"创建目录失败");
    } else {
        NSLog(@"创建目录成功");
    }
    NSString *savePath = [imageSavePath stringByAppendingPathComponent:name];
    return savePath;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ARGameInfoBack" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
