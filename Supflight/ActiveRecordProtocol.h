
#import <Foundation/Foundation.h>

@protocol ActiveRecordProtocol <NSObject>

@required
-(id)insertObject;
-(NSArray*)load;
@end
