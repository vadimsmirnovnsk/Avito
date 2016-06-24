#import "AVTBaseVC.h"

@interface AVTBaseVC ()

@property (nonatomic, strong, readonly) id viewModel;

@end

@implementation AVTBaseVC

@synthesize viewModel = _viewModel;

- (instancetype)initWithViewModel:(id)viewModel
{
	self = [super initWithNibName:nil bundle:nil];
	if (self == nil) return nil;

	_viewModel = viewModel;

	return self;
}

- (id)viewModel
{
	return _viewModel;
}

@end
