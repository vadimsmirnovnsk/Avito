#import "AVTHomeVC.h"

#import "AVTHomeVM.h"

typedef NS_ENUM(NSUInteger, AVTHomeMode) {
	AVTHomeModeResults = 0,
	AVTHomeModeLoading,
};

@interface AVTHomeVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *spinner;

@property (nonatomic, assign) AVTHomeMode homeMode;

@end

@implementation AVTHomeVC

- (instancetype)initWithViewModel:(id)viewModel
{
	self = [super initWithViewModel:viewModel];
	if (self == nil) return nil;

	_homeMode = AVTHomeModeResults;

	return self;
}

- (void)loadView
{
	_spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	_tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	_tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	_tableView.alpha = 0.0;
	_tableView.backgroundColor = [UIColor clearColor];

	self.view = [[UIView alloc] init];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor grayColor];
	[self setEdgesForExtendedLayout:UIRectEdgeNone];

	[self.viewModel registerTableView:self.tableView];
	[self.view addSubview:self.tableView];
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];

	[self.spinner startAnimating];
	[self.view addSubview:self.spinner];
	[self.spinner mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
	}];
}

- (void)setHomeMode:(AVTHomeMode)homeMode
{
	_homeMode = homeMode;

	self.tableView.hidden = (homeMode == AVTHomeModeLoading);
	self.spinner.hidden = (homeMode == AVTHomeModeResults);

	switch (homeMode) {
		case AVTHomeModeLoading:
		{
			self.navigationItem.rightBarButtonItem = nil;
			break;
		}
		case AVTHomeModeResults:
		{
			[self.view endEditing:YES];
			break;
		}
	}
}

@end
