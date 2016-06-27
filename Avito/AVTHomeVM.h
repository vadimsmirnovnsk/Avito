#import "AVTBaseVM.h"

#import "AVTDataProviderProtocol.h"

@class AVTSearchVM;
@class AVTSelectVM;
@class AVTResultsVM;

@interface AVTHomeVM : AVTBaseVM

@property (nonatomic, strong, readonly) AVTSearchVM *searchVM;
// sendNext @YES
@property (nonatomic, strong, readonly) RACSignal *shouldReloadTableViewSignal;

- (instancetype)initWithDataProvider:(id<AVTDataProviderProtocol>)dataProvider
				 selectServiceSignal:(RACSignal *)selectServiceSignal;

- (void)registerTableView:(UITableView *)tableView;

@end
