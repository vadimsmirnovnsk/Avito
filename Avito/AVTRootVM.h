#import "AVTBaseVM.h"

@class AVTSelectVM;
@class AVTHomeVM;
@class AVTAPIController;

@interface AVTRootVM : AVTBaseVM

@property (nonatomic, strong, readonly) AVTHomeVM *homeVM;
@property (nonatomic, strong, readonly) AVTAPIController *apiController;

- (void)cleanCache;

@end
