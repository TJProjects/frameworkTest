#import <Foundation/Foundation.h>
@class easyar_Message;
@class easyar_PlayerView;

@interface easyar_MessageClient : NSObject

- (instancetype)initWithPlayerView:(easyar_PlayerView*)playerView name:(NSString*)name destName:(NSString*)destName callback:(void(^)(NSString*from, easyar_Message*message))callback;

-(void)releaseClient;
-(void)setDest:(NSString*)dst;
-(BOOL)send:(easyar_Message*)msg;
-(int)getuid;

@end
