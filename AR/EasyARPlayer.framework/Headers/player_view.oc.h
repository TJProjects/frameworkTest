/**
* Copyright (c) 2015-2016 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#import <GLKit/GLKView.h>

//@class easyar_IDevice;
@protocol easyar_IFileSystem;
//@class easyar_IWWWService;
//@class easyar_PlayerRecorder;
//@class easyar_PlayerRecorderConfiguration;
@protocol easyar_IWWW;
@class easyar_Service;


typedef enum
{
    FrontCamera = 0,
    BackCamera = 1,
} SystemDeviceTypes;

@interface easyar_PlayerView : GLKView

//- (void)registerDevice:(easyar_IDevice*)device;
//- (void)registerSystemDevice:(SystemDeviceTypes)deviceType device:(easyar_IDevice*)device;
//- (void)broadcastDeviceEvent:(int)deviceIndex eventId:(int)eventId parameterListId:(int)parameterListId;
- (void)setFPS:(int)fps;
//- (void)loadJavaScript:(NSString *)uriPath;
//- (BOOL)loadJavaScript:(NSString *)uriPath content : (NSString *)content;
- (BOOL)loadPackage:(NSString *)localPath onFinish:(void(^)())onFinish;
- (BOOL)unloadPackage:(NSString *)localPath;
- (void)registerService:(easyar_Service *)service;
- (void)unregisterService:(easyar_Service *)service;
//- (void)loadManifest:(NSString *)uriPath;
//- (void)loadManifest:(NSString *)uriPath content:(NSString *)content;
//- (void)preLoadTarget:(NSString *)targetDesc onLoadHandler:(void (^)(bool status)) onLoadHandler
//  onFoundHandler:(void (^)()) onFoundHandler onLostHandler:(void (^)()) onLostHandler;
//- (void)sendMessage:(NSString *)name params:(NSArray<NSString *> *)params;
//- (void)setMessageReceiver:(void (^)(NSString * name, NSArray<NSString *> * params))receiver;
- (void)snapshot:(void(^)(UIImage *image))onSuccess failed:(void(^)(NSString *msg))onFailed;
//- (void)setupCloud:(NSString *)server key:(NSString *)key secret:(NSString *)secret;
//-(void) onDownloadSucceed:(int)downloadId localPath:(NSString*) localPath;
//-(void) onDownloadFailed:(int) downloadId failReason:(NSString*) failReason;
//-(void) onDownloadProgress:(int) downloadId bytesCurrent:(long) bytesCurrent bytesTotal:(long) bytesTotal;
-(void) setFileSystem:(id<easyar_IFileSystem>)fileSystem;

//-(void) dispatchParameterList:(int)parameterListId;
//-(void) setParameterListReceiveCallback:(void(^)(int parameterListId))cb;

//-(void)onWWWResponse:(int)requestId response : (NSString*)response;
-(void)setIWWW:(id<easyar_IWWW>)www;

-(int)addPostRenderCallback:(void(^)(int textureId, unsigned int width, unsigned int height))funcCallback;
-(void)removePostRenderCallback:(int)callbackId;
//-(void)setupOperationCenter:(NSString *)operationCenterBaseUrl operationCenterKey:(NSString*)operationCenterKey appSecret:(NSString*)appSecret;

//- (easyar_PlayerRecorder *)createRecorder:(easyar_PlayerRecorderConfiguration *)conf;
//-(void)destroyRecorder:(easyar_PlayerRecorder*)recorder;

@end
