#import "AVTRootVC.h"

#import "AVTHomeVC.h"
#import "AVTRootVM.h"
#import "AVTSelectView.h"
#import "DGSErrorBannerView.h"
#import "DGSErrorBannerVM.h"
#import "UIViewController+DGSAdditions.h"
#import "AVTAPIController.h"

@interface AVTRootVC ()

@property (nonatomic, strong, readonly) AVTHomeVC *homeVC;
@property (nonatomic, strong, readonly) DGSErrorBannerView *errorBannerView;
@property (nonatomic, strong, readonly) DGSErrorBannerVM *errorBannerVM;

@end

@implementation AVTRootVC

- (instancetype)initWithViewModel:(id)viewModel
{
	self = [super initWithViewModel:viewModel];
	if (self == nil) return nil;

	_homeVC = [[AVTHomeVC alloc] initWithViewModel:self.viewModel.homeVM];
	_errorBannerVM = [[DGSErrorBannerVM alloc] initWithAutohideMode:DGSErrorBannerAutohideModeByTouch];
	_errorBannerView = [[DGSErrorBannerView alloc] initWithViewModel:_errorBannerVM];

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[[self.viewModel.apiController didOccurNetworkErrorSignal]
		subscribeNext:^(NSError *error) {
			@strongify(self);

			NSString *message = @"Ошибка: ";
			[self.errorBannerVM showMessage:[message stringByAppendingString:error.localizedDescription]];
		}];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];

	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.homeVC];
	[self dgs_showViewController:nc inView:self.view];
}

@end
