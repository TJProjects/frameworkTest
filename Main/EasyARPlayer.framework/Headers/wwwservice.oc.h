#import <Foundation/Foundation.h>

@class easyar_PlayerView;

/**
 * EasyAR IWWW 接口
 */
@protocol easyar_IWWW

/**
 * 从URL下载文件
 * @param url URL
 * @param options 选项
 * @param completed 完成时的回调
 * @param progress 进度回调
 */
- (void)downloadFileAtURL:(NSString*)url options:(NSDictionary*)options completed:(void(^)(bool isOk, NSString*localAbsolutePath))completed progress:(void(^)(int current, int total))progress;

/**
 * 发送URL Request
 * @param url URL
 * @param options 选项
 * @param response 收到Response时的回调
 * @param progress 进度回调
 */
- (void)requestWithURL:(NSString*)url options:(NSDictionary*)options response:(void(^)(bool isOk, NSString*content))response;

/**
 * 取消之前的请求
 * @param url URL
 * @param options 选项
 */
- (void)cancelForURL:(NSString*)url options:(NSDictionary*)options;

@end
