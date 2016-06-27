#import "AVTResultsVM.h"

#import "AVTResultCellVM.h"

@interface AVTResultsVM ()

@property (nonatomic, copy, readwrite) NSArray<AVTResultCellVM *> *resultVMs;
@property (nonatomic, strong, readonly) id<AVTDataProviderProtocol> dataProvider;

@end

@implementation AVTResultsVM

- (instancetype)initWithDataProvider:(id<AVTDataProviderProtocol>)dataProvider
{
	self = [super init];
	if (self == nil) return nil;

	_dataProvider = dataProvider;

	return self;
}

- (void)loadResults:(NSArray *)results
{
	NSMutableArray<AVTResultCellVM *> *mutableCellVMs = [NSMutableArray arrayWithCapacity:results.count];
	
	[results enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL *_) {
		AVTResultCellVM *cellVM = [AVTResultCellVM cellVMForModel:model index:idx dataProvider:self.dataProvider];
		[mutableCellVMs addObject:cellVM];
	}];

	self.resultVMs = [mutableCellVMs copy];
}

@end
