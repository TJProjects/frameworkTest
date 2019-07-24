//=============================================================================================================================
//
// EasyAR 3.0.0-beta-read4b2a1
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"

@interface easyar_Buffer : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_Buffer *)create:(int)size;
- (void *)data;
- (int)size;
- (bool)copyFrom:(void *)src srcPos:(int)srcPos destPos:(int)destPos length:(int)length;

@end
