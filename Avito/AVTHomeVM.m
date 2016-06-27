#import "AVTHomeVM.h"

#import "AVTResultsVM.h"
#import "AVTSearchVM.h"

@interface AVTHomeVM ()

@property (nonatomic, strong, readonly) id<AVTDataProviderProtocol> dataProvider;

@end

@implementation AVTHomeVM

- (instancetype)initWithDataProvider:(id<AVTDataProviderProtocol>)dataProvider
				 selectServiceSignal:(RACSignal *)selectServiceSignal
{
	self = [super init];
	if (self == nil) return nil;

	_searchVM = [[AVTSearchVM alloc] init];

	[selectServiceSignal subscribeNext:^(id x) {
		NSLog(@">>> %@", x);
	}];

	return self;
}

- (void)registerTableView:(UITableView *)tableView
{
	
}

@end
