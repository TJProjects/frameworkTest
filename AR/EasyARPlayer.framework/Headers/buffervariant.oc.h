#import <Foundation/Foundation.h>


@interface easyar_BufferVariant : NSObject

-(instancetype)initWithRawBytes:(NSData*)data;
-(instancetype)initWithImageBytes:(NSData*)data;

-(NSInteger)size;

-(BOOL)isRawBytes;
-(BOOL)isImageBytes;

@end
