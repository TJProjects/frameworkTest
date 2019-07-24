
#import <Foundation/Foundation.h>
@class easyar_Dictionary;

@interface easyar_Service : NSObject

- (BOOL)command:(int)id withParams:(easyar_Dictionary *)params andResults:(easyar_Dictionary *)results;
- (int)getServiceId;
- (NSString *)getServiceType;
- (void)setServiceType:(NSString *)type;
- (NSString *)getServiceDesc;
- (void)setServiceDesc:(NSString *)desc;

@end


