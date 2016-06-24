#import "AVTSerializableProtocol.h"

@interface AVTGitHubItem : NSObject <AVTSerializableProtocol>

@property (nonatomic, copy, readonly) NSString *imageURLString;
@property (nonatomic, copy, readonly) NSString *login;
@property (nonatomic, copy, readonly) NSString *accountURLString;

@end
