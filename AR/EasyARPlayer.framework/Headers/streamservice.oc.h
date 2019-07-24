#import <Foundation/Foundation.h>
#import "service.oc.h"

@interface easyar_StreamService : easyar_Service

- (void)start;
- (void)stop;
- (void)updateFrame:(NSData *)data pixelFormat:(int)format width:(int)width height:(int)height;
- (int)getCameraType;
- (void)setCameraType:(int)cameraType;
- (int)getOrientation;
- (void)setOrientation:(int)orientation;

@end

