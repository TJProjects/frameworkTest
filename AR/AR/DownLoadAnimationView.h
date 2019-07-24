//
//  DownLoadAnimationView.h
//  sightpDemo
//
//  Created by YangTengJiao on 16/9/14.
//  Copyright © 2016年 YangTengJiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadAnimationView : UIView
@property (strong, nonatomic) UIImageView *scrollImageView;

@property (strong, nonatomic) UILabel *centerLabel;

- (void)startAnimation;

- (void)stopAnimation;


@end
