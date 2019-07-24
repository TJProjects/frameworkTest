//=============================================================================================================================
//
// EasyAR 3.0.0-beta-read4b2a1
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#import "easyar/types.oc.h"
#import "easyar/target.oc.h"

@interface easyar_ObjectTarget : easyar_Target

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

+ (easyar_ObjectTarget *) create;
- (bool)setup:(NSString *)path storageType:(int)storageType name:(NSString *)name;
+ (NSArray<easyar_ObjectTarget *> *)setupAll:(NSString *)path storageType:(int)storageType;
- (float)scale;
- (NSArray<easyar_Vec3F *> *)boundingBox;
- (NSArray<easyar_Vec3F *> *)boundingBoxGL;
- (bool)setScale:(float)scale;
- (int)runtimeID;
- (NSString *)uid;
- (NSString *)name;
- (NSString *)meta;
- (void)setMeta:(NSString *)data;

@end
