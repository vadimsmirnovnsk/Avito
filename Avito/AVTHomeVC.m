#import "AVTHomeVC.h"

#import "AVTHomeVM.h"

@interface AVTHomeVC ()

@property (nonatomic, strong, readonly) UITableView *tableView;

@end

@implementation AVTHomeVC

- (void)loadView
{
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
}

@end
