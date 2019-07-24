#import <Foundation/Foundation.h>
@class easyar_PlayerView;


@protocol easyar_IWWW

- (void)downloadFileAtURL:(NSString*)url options:(NSDictionary*)options completed:(void(^)(bool isOk, NSString*localAbsolutePath))completed progress:(void(^)(int current, int total))progress;
- (void)requestWithURL:(NSString*)url options:(NSDictionary*)options response:(void(^)(bool isOk, NSString*content))response;
- (void)cancelForURL:(NSString*)url options:(NSDictionary*)options;

@end


//@interface easyar_IWWWService : NSObject
//
//- (void)setPlayerView : (easyar_PlayerView *)playerView;
//
//- (void)downloadFileAtURL:(NSString*)url options:(NSString*)options completed:(void(^)(bool isOk, NSString*localAbsolutePath))completed progress:(void(^)(int current, int total))progress;
//- (void)requestWithURL:(NSString*)url options:(NSString*)options response:(void(^)(bool isOk, NSString*content))response;
//- (void)cancelForURL:(NSString*)url;
//
//@end


