//
//  ARLoadIdVideoView.h
//  OcclientForCMBC
//
//  Created by YangTengJiao on 2018/11/26.
//  Copyright © 2018年 刘高升. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoViewCloseBlock)(NSString *type);
NS_ASSUME_NONNULL_BEGIN

@interface ARLoadIdVideoView : UIView

@property (copy, nonatomic) VideoViewCloseBlock videoCloseBlock;

- (void)playVideoWith:(NSString *)url;

- (void)removeSelf;

@end

NS_ASSUME_NONNULL_END
