#import "AVTRootVC.h"

#import "AVTHomeVC.h"
#import "AVTRootVM.h"
#import "AVTSelectView.h"
#import "UIViewController+DGSAdditions.h"

@interface AVTRootVC ()

@property (nonatomic, strong, readonly) AVTHomeVC *homeVC;
@property (nonatomic, strong) AVTSelectView *selectView;

@end

@implementation AVTRootVC

- (instancetype)initWithViewModel:(id)viewModel
{
	self = [super initWithViewModel:viewModel];
	if (self == nil) return nil;

	_homeVC = [[AVTHomeVC alloc] initWithViewModel:self.viewModel.homeVM];

	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];

	self.selectView = [[AVTSelectView alloc] initWithViewModel:self.viewModel.selectVM];
	self.navigationItem.titleView = self.selectView;

	[self dgs_showViewController:self.homeVC inView:self.view];
}

@end
