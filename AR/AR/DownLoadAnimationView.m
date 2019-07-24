//
//  DownLoadAnimationView.m
//  sightpDemo
//
//  Created by YangTengJiao on 16/9/14.
//  Copyright © 2016年 YangTengJiao. All rights reserved.
//

#import "DownLoadAnimationView.h"
#import "ARDefine.h"

@implementation DownLoadAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatView];
    }
    return self;
}

- (void)creatView{
    self.userInteractionEnabled = NO;
    self.scrollImageView = [[UIImageView alloc] initWithImage:[ARImage imageNamed:@"scroll_image"]];
    self.scrollImageView.frame = CGRectMake(0, 0, 79, 79);
    self.scrollImageView.center = self.center;
    [self addSubview:self.scrollImageView];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.text = @"loading";
    [self.centerLabel sizeToFit];
    self.centerLabel.center = self.center;
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.font = [UIFont systemFontOfSize:10];
    self.centerLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.centerLabel];
    self.hidden = YES;
}
- (void)startAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = NO;
        [self.scrollImageView.layer removeAllAnimations];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1.2f;
        rotationAnimation.cumulative = NO;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.repeatCount = FLT_MAX;
        [self.scrollImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [self.scrollImageView startAnimating];
    });
}

- (void)stopAnimation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self.scrollImageView stopAnimating];
        [self.scrollImageView.layer removeAllAnimations];
    });
}

@end
