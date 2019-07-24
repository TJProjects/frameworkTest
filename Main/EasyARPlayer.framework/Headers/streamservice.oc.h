#import <Foundation/Foundation.h>
#import "service.oc.h"

@interface easyar_StreamService : easyar_Service

/** 开始 */
- (void)start;

/** 结束 */
- (void)stop;

/**
 * 更新帧数据到引擎里
 * @param data 帧数据
 * @param foramt 像素的格式
 * @param width 宽
 * @param height 高
 */
- (void)updateFrame:(NSData *)data pixelFormat:(int)format width:(int)width height:(int)height;

/**
 * 获取相机类型（前置、后置）
 * @return
 * 默认 Default = 0;
 * 后置相机 Back = 1;
 * 前置相机 Front = 2;
 */
- (int)getCameraType;

/**
 * 设置相机类型（前置、后置）
 * @param type
 * 默认 Default = 0;
 * 后置相机 Back = 1;
 * 前置相机 Front = 2;
 * 
 * @see easyar_CameraDeviceType
 */
- (void)setCameraType:(int)cameraType;

/**
 * 获取设备横竖屏（角度）
 * @return 横竖屏的角度
 * 0 横屏
 * 90 竖屏
 * 180 横屏（翻转）
 * 270 竖屏（翻转）
 */
- (int)getOrientation;

/**
 * 设置设备横竖屏（角度）
 * @param orientation 横竖屏的角度
 * 0 横屏
 * 90 竖屏
 * 180 横屏（翻转）
 * 270 竖屏（翻转）
 */
- (void)setOrientation:(int)orientation;

@end

