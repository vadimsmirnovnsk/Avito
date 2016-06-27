#import "AVTRootVM.h"

#import "AVTAPIController+Entities.h"
#import "AVTHomeVM.h"
#import "AVTSelectVM.h"

@interface AVTRootVM ()

@property (nonatomic, strong, readonly) AVTAPIController *apiController;

@end

@implementation AVTRootVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_apiController = [[AVTAPIController alloc] init];
	[self assembleViewModels];

	return self;
}

- (void)assembleViewModels
{
	_selectVM = [[AVTSelectVM alloc] init];

	RACSignal *selectServiceSignal = RACObserve(self.selectVM, selectedIndex);
	_homeVM = [[AVTHomeVM alloc] initWithDataProvider:_apiController selectServiceSignal:selectServiceSignal];
}

@end
