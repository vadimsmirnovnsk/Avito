#import "AVTSerializableProtocol.h"

@interface AVTAppleItem : NSObject <AVTSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *imageURLString;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *author;

@end
