#import "AVTBaseVM.h"

@class AVTSelectVM;
@class AVTHomeVM;

@interface AVTRootVM : AVTBaseVM

@property (nonatomic, strong, readonly) AVTSelectVM *selectVM;
@property (nonatomic, strong, readonly) AVTHomeVM *homeVM;

- (void)cleanCache;

@end
