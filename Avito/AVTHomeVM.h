#import "AVTBaseVM.h"

#import "AVTDataProviderProtocol.h"

@class AVTSearchVM;
@class AVTSelectVM;

@interface AVTHomeVM : AVTBaseVM

@property (nonatomic, strong, readonly) AVTSearchVM *searchVM;

- (instancetype)initWithDataProvider:(id<AVTDataProviderProtocol>)dataProvider
				 selectServiceSignal:(RACSignal *)selectServiceSignal;

- (void)registerTableView:(UITableView *)tableView;

@end
