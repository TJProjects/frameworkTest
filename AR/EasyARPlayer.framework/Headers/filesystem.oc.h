#import <Foundation/Foundation.h>
@class easyar_PlayerView;


@protocol easyar_IFileSystem

-(BOOL) fileExist:(NSString*) fileName;
-(NSString*) convertUserToAbsolute:(NSString*) fileName;
@end
