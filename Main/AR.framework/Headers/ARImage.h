//
//  ARImage.h
//  AR
//
//  Created by YangTengJiao on 2018/11/9.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BundleName @"ARResource"

NS_ASSUME_NONNULL_BEGIN

@interface ARImage : NSObject

+ (UIImage *)imageNamed:(NSString *)imgName;
+ (NSString *)getEzpPath:(NSString *)name;
+ (NSString *)getGifPath:(NSString *)name;


@end

NS_ASSUME_NONNULL_END
