﻿//=============================================================================================================================
//
// EasyAR 3.0.0-beta-r6eeb2091
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/framefilter.oc.h"

@interface easyar_SurfaceTrackerResult : easyar_RefBase

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (easyar_Matrix44F *)transform;
- (easyar_TargetStatus)status;

@end

@interface easyar_SurfaceTracker : easyar_FrameFilter

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_SurfaceTracker *) create;
+ (bool)isAvailable;
- (void)alignTargetToCameraImagePoint:(easyar_Vec2F *)cameraImagePoint;
- (easyar_SurfaceTrackerResult *)getResult:(easyar_Frame *)frame;
- (bool)attachStreamer:(easyar_FrameStreamer *)obj;
- (bool)start;
- (bool)stop;

@end
