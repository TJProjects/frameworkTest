#import <Foundation/Foundation.h>

/**
 * 存储大块Buffer，用于在原生(iOS)和内容(TypeScript)之间传递
 */
@interface easyar_BufferVariant : NSObject

-(instancetype)initWithRawBytes:(NSData*)data;
-(instancetype)initWithImageBytes:(NSData*)data;

-(NSInteger)size;

-(BOOL)isRawBytes;
-(BOOL)isImageBytes;

@end
