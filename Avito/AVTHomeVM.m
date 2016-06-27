#import "AVTHomeVM.h"

#import "AVTResultsVM.h"
#import "AVTSearchVM.h"
#import "AVTSearchHeaderView.h"
#import "AVTResultCell.h"
#import "AVTResultsVM.h"

@interface AVTHomeVM () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong, readonly) id<AVTDataProviderProtocol> dataProvider;
@property (nonatomic, strong, readonly) AVTResultsVM *resultsVM;
@property (nonatomic, copy, readonly) NSString *searchHeaderIdentifier;
@property (nonatomic, copy, readonly) NSString *resultCellIdentifier;
@property (nonatomic, strong, readonly) RACSignal *selectServiceSignal;

@end

@implementation AVTHomeVM

- (instancetype)initWithDataProvider:(id<AVTDataProviderProtocol>)dataProvider
				 selectServiceSignal:(RACSignal *)selectServiceSignal
{
	self = [super init];
	if (self == nil) return nil;

	_dataProvider = dataProvider;

	_searchVM = [[AVTSearchVM alloc] init];
	_resultsVM = [[AVTResultsVM alloc] initWithDataProvider:dataProvider];
	
	_searchHeaderIdentifier = NSStringFromClass([AVTSearchVM class]);
	_resultCellIdentifier = NSStringFromClass([AVTResultCellVM class]);
	_selectServiceSignal = selectServiceSignal;

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	RACSignal *textSinal = [[RACObserve(self.searchVM, text)
		ignore:nil]
		distinctUntilChanged];

	[[[self.selectServiceSignal combineLatestWith:textSinal]
		flattenMap:^RACStream *(RACTuple *tuple) {
			@strongify(self);

			RACTupleUnpack(NSNumber *serviceNumber, NSString *queryString) = tuple;

			return serviceNumber.integerValue
				? [[self.dataProvider fetchGitHubItemsForQuery:queryString] ignore:nil]
				: [[self.dataProvider fetchAppleItemsForQuery:queryString] ignore:nil];
		}]
		subscribeNext:^(NSArray *results) {
			@strongify(self);

			[self.resultsVM loadResults:results];
		}];
}

- (void)registerTableView:(UITableView *)tableView
{
	[tableView registerClass:[AVTSearchHeaderView class] forHeaderFooterViewReuseIdentifier:self.searchHeaderIdentifier];
	[tableView registerClass:[AVTResultCell class] forCellReuseIdentifier:self.resultCellIdentifier];
	tableView.delegate = self;
	tableView.dataSource = self;

	[[[RACObserve(self.resultsVM, resultVMs)
		ignore:nil]
		deliverOnMainThread]
		subscribeNext:^(id _) {
			[tableView reloadData];
		}];
}

// MARK: UITableView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	AVTTableViewHeaderFooterView *headerView =
		[tableView dequeueReusableHeaderFooterViewWithIdentifier:self.searchHeaderIdentifier];
	headerView.viewModel = self.searchVM;

	return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.resultsVM.resultVMs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	AVTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.resultCellIdentifier];
	cell.viewModel = [self.resultsVM.resultVMs objectAtIndex:indexPath.row];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	self.searchVM.active = NO;
}

@end
