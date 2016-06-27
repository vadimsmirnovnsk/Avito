#import "AVTSelectView.h"

#import "AVTSelectVM.h"

@interface AVTSelectView ()

@property (nonatomic, strong, readonly) AVTSelectVM *viewModel;

@end

@implementation AVTSelectView

- (instancetype)initWithViewModel:(AVTSelectVM *)viewModel
{
	self = [super initWithItems:viewModel.selectorTitles];
	if (self == nil) return nil;

	[self addTarget:self action:@selector(switch) forControlEvents:UIControlEventValueChanged];
	self.selectedSegmentIndex = self.viewModel.selectedIndex;
	_viewModel = viewModel;

	return self;
}

- (void)switch
{
	[self.viewModel selectTitleWithIndex:self.selectedSegmentIndex];
}

@end
