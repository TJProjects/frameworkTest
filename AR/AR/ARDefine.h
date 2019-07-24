//
//  ARDefine.h
//  Pentium
//
//  Created by YangTengJiao on 2018/10/19.
//  Copyright © 2018年 YangTengJiao. All rights reserved.
//

#ifndef ARDefine_h
#define ARDefine_h

#import "Masonry.h"
#import "ARImage.h"


#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#ifndef IS_IPHONE_X
#define IS_IPHONE_X ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.width == 812 || [UIScreen mainScreen].bounds.size.height == 896 || [UIScreen mainScreen].bounds.size.width == 896)
#endif

#define kStatusBarHeight    (IS_IPHONE_X ? 44.f : 20.f)

#define kNavigationBarHeight 44.f

#define kTabbarHeight       (IS_IPHONE_X ? (49.f + 34.f) : 49.f)

#define kTabbarSafeBottomMargin (IS_IPHONE_X ? 34.f : 0.f)

#define kStatusBarAndNavigationBarHeight (IS_IPHONE_X ? 88.f : 64.f)


#endif /* ARDefine_h */
