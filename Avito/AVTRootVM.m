#import "AVTRootVM.h"

#import "AVTAPIController.h"
#import "AVTHomeVM.h"
#import "AVTSelectVM.h"

@implementation AVTRootVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_apiController = [[AVTAPIController alloc] init];
	_homeVM = [[AVTHomeVM alloc] initWithDataProvider:_apiController];

	return self;
}

- (void)cleanCache
{
	[self.apiController cleanImagesCache];
}

@end
