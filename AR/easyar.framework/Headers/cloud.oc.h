﻿//=============================================================================================================================
//
// EasyAR 3.0.0-beta-read4b2a1
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/framefilter.oc.h"

@interface easyar_CloudRecognizer : easyar_FrameFilter

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_CloudRecognizer *) create;
+ (bool)isAvailable;
- (void)open:(NSString *)server appKey:(NSString *)appKey appSecret:(NSString *)appSecret callbackScheduler:(easyar_CallbackScheduler *)callbackScheduler callback_open:(void (^)(easyar_CloudStatus status))callback_open callback_recognize:(void (^)(easyar_CloudStatus status, NSArray<easyar_Target *> * targets))callback_recognize;
- (bool)close;
- (bool)attachStreamer:(easyar_FrameStreamer *)obj;
- (bool)start;
- (bool)stop;

@end
