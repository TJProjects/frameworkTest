//
//  ARLoadIdVideoView.m
//  OcclientForCMBC
//
//  Created by YangTengJiao on 2018/11/26.
//  Copyright © 2018年 刘高升. All rights reserved.
//

#import "ARLoadIdVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import "ARDefine.h"

#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

@interface ARLoadIdVideoView()
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIView *bgVideoView;
/**播放器*/
@property (nonatomic, strong) AVPlayer *player;
/**playerLayer*/
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic ,strong)  id timeObser;

@property (strong, nonatomic) UIButton *videoPlayButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) UILabel *errorLabel;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (assign, nonatomic) BOOL isStateChecked;
@property (strong, nonatomic) UIView *lineBgView;
@property (strong, nonatomic) UIView *lineView;
@property (strong, nonatomic) UILabel *linelabel;



@end

@implementation ARLoadIdVideoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self playVideoWith:@""];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    __weak typeof(self) weakSelf = self;
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    self.isPlaying = NO;
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.frame = CGRectMake(0, 0, 598, 326);
    [self.bgImageView setImage:[ARImage imageNamed:@"bg"]];
    self.bgImageView.center = self.center;
    [self addSubview:self.bgImageView];
    self.bgImageView.userInteractionEnabled = YES;
    
    self.bgVideoView = [[UIView alloc] init];
    self.bgVideoView.frame = CGRectMake(54, 50, 491, 241);
    self.bgVideoView.backgroundColor = [UIColor clearColor];
    [self.bgImageView addSubview:self.bgVideoView];
    self.playerLayer.frame = CGRectMake(0, 0, self.bgVideoView.frame.size.width, self.bgVideoView.frame.size.height);
    [self.bgVideoView.layer addSublayer:self.playerLayer];
    
    self.playerLayer.frame = CGRectMake(0, 0, self.bgVideoView.frame.size.width, self.bgVideoView.frame.size.height);
    [self.bgVideoView.layer addSublayer:self.playerLayer];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    //设置小菊花的frame
    self.activityIndicator.frame = CGRectMake(200, 60, 100, 100);
    [self.bgVideoView addSubview:self.activityIndicator];
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor whiteColor]; //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    
    self.lineBgView = [[UIView alloc] init];
    self.lineBgView.backgroundColor = [UIColor colorWithWhite:125.0/255.0 alpha:1.0];
    self.lineBgView.layer.masksToBounds = YES;
    self.lineBgView.layer.cornerRadius = 2;
    [self.bgVideoView addSubview:self.lineBgView];
    [self.lineBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.bgVideoView.mas_leading).offset(83);
        make.trailing.equalTo(weakSelf.bgVideoView.mas_trailing).offset(-138);
        make.height.equalTo(@4);
        make.bottom.equalTo(weakSelf.bgVideoView.mas_bottom).offset(-11);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithRed:11.0/255.0 green:187.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.lineView.layer.masksToBounds = YES;
    self.lineView.layer.cornerRadius = 2;
    self.lineView.frame = CGRectMake(0, 0, 0, 4);
    [self.lineBgView addSubview:self.lineView];
    
    self.linelabel = [[UILabel alloc] init];
    self.linelabel.text = @"00:00/00:00";
    self.linelabel.font = [UIFont systemFontOfSize:8];
    self.linelabel.textColor = [UIColor whiteColor];
    [self.bgVideoView addSubview:self.linelabel];
    [self.linelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.lineBgView.mas_trailing).offset(5);
        make.centerY.equalTo(weakSelf.lineBgView.mas_centerY);
    }];
    
    
    AVAudioSession *session =[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
    self.videoPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoPlayButton.frame =CGRectMake(210, 76, 73, 73);
    [self.videoPlayButton setImage:[ARImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.bgVideoView addSubview:self.videoPlayButton];
    [self.videoPlayButton addTarget:self action:@selector(videoPlayAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.errorLabel = [[UILabel alloc] init];
    self.errorLabel.textColor = [UIColor whiteColor];
    self.errorLabel.font = [UIFont systemFontOfSize:15];
    self.errorLabel.text = @"网络异常，暂时无法播放";
    self.errorLabel.textAlignment = NSTextAlignmentCenter;
    self.errorLabel.frame = CGRectMake(0, 0, self.bgImageView.bounds.size.width, 30);
    self.errorLabel.center = CGPointMake(self.bgVideoView.center.x, self.bgVideoView.center.y);
    [self.bgVideoView addSubview:self.errorLabel];
    self.errorLabel.hidden = YES;
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton.frame =CGRectMake(553, 13, 36, 36);
    [self.closeButton setImage:[ARImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.bgImageView addSubview:self.closeButton];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification  object:app queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        weakSelf.errorLabel.hidden = YES;
        weakSelf.isPlaying = NO;
        [weakSelf pausePlay];
    }];
}

- (void)closeAction {
    [self stopPlay];
    if (self.videoCloseBlock) {
        self.videoCloseBlock(@"close");
    }
}

- (void)videoPlayAction {
    if (self.errorLabel.hidden == NO) {
        return;
    }
    if (self.isPlaying == NO) {
        [self playVideo];
    } else {
        [self pausePlay];
    }
    self.isPlaying = !self.isPlaying;
}

- (void)playVideoWith:(NSString *)url {
    self.hidden = NO;
    self.errorLabel.hidden = YES;
    self.isStateChecked = NO;
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:url]];
    NSLog(@"playerItem %f %f",playerItem.presentationSize.height,playerItem.presentationSize.width);
    if (self.player.currentItem) {
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
    } else {
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    if (@available(iOS 10.0, *)) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    } else {
        // Fallback on earlier versions
    }
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemPlaybackStalledNotification object:_player.currentItem];
    
    [self playVideo];
    [self.activityIndicator startAnimating];
    
    __weak typeof(self)WeakSelf = self;
    _timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, NSEC_PER_SEC)
                                                queue:NULL
                                           usingBlock:^(CMTime time) {
                                               //进度 当前时间/总时间
                                               CGFloat progress = CMTimeGetSeconds(WeakSelf.player.currentItem.currentTime) / CMTimeGetSeconds(WeakSelf.player.currentItem.duration);
                                               NSLog(@"eriodicTime %f %f %f",CMTimeGetSeconds(WeakSelf.player.currentItem.duration),CMTimeGetSeconds(WeakSelf.player.currentItem.currentTime),progress);
                                               if (progress > 0) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       WeakSelf.lineView.frame = CGRectMake(0, 0, WeakSelf.lineBgView.frame.size.width*progress, 4);
                                                       WeakSelf.linelabel.text = [NSString stringWithFormat:@"%@/%@",[WeakSelf getMMSSFromSS:CMTimeGetSeconds(WeakSelf.player.currentItem.currentTime)],[WeakSelf getMMSSFromSS:CMTimeGetSeconds(WeakSelf.player.currentItem.duration)]];
                                                   });
                                               }
                                           }];
    

}

//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(float )totalTime{
    NSInteger seconds = totalTime;
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = @"00:00";
    if ([str_hour integerValue] > 0) {
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    } else {
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }
    return format_time;
}

- (void)checkReadyToPlay {
    if (self.player.status == AVPlayerStatusReadyToPlay)
    {
        self.isStateChecked = YES;
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.asset.duration);
        NSLog(@"duration %lf",duration);
        if (duration == 0) {
            self.isStateChecked = NO;
            self.errorLabel.hidden = NO;
            [self.activityIndicator stopAnimating];
        } else {
            self.errorLabel.hidden = YES;
            [self checkPlayerTimers];
        }
    }
}

- (void)checkPlayerTimers {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (CMTimeGetSeconds(self.player.currentTime) > 0) {
            [self.activityIndicator stopAnimating];
            self.isStateChecked = NO;
        } else {
            [self checkPlayerTimers];
        }
    });
}

- (void)checkPlayerStatus {
    if (self.hidden == YES) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            if (self.isStateChecked == YES) {
                return;
            }
            [self checkReadyToPlay];
        } else if (self.player.status == AVPlayerStatusFailed) {
            self.errorLabel.hidden = NO;
            [self.activityIndicator stopAnimating];
        } else if (self.player.status == AVPlayerItemStatusUnknown) {
            [self checkPlayerStatus];
        }
    });
}

#pragma mark - 播放
- (void)playVideo
{
    NSLog(@"%lf %lf",CMTimeGetSeconds(_player.currentItem.asset.duration),CMTimeGetSeconds(_player.currentTime));
    if (CMTimeGetSeconds(_player.currentItem.asset.duration) == CMTimeGetSeconds(_player.currentTime) && CMTimeGetSeconds(_player.currentTime)>0) {
        [_player seekToTime:CMTimeMake(0, 1)];
    }
    [_player play];
    [self.videoPlayButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self checkPlayerStatus];
}
#pragma mark - 播放完成
- (void)moviePlayDidEnd:(NSNotification *)notification
{
    self.isPlaying = NO;
    [self pausePlay];
}
#pragma mark - 暂停播放
- (void)pausePlay
{
    [_player pause];
    [self.videoPlayButton setImage:[ARImage imageNamed:@"play"] forState:UIControlStateNormal];
}
#pragma mark - 停止播放
- (void)stopPlay {
    self.hidden = YES;
    self.isPlaying = NO;
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:_player.currentItem];
    if (_timeObser) {
        [self.player removeTimeObserver:_timeObser];
        _timeObser = nil;
    }
}
- (void)removeSelf {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemPlaybackStalledNotification object:_player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopPlay];
    [self.player setRate:0];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    [self removeFromSuperview];
    NSLog(@"<<<<<<<<<<<<<<<视频 播放 removeSelf>>>>>>>>>>>>>>>>>>>");
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"<<<<<<<<<<<<<<<视频 播放 delloc>>>>>>>>>>>>>>>>>>>");
}

@end
