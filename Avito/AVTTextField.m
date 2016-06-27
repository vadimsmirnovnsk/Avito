#import "AVTTextField.h"

#import "AVTSearchVM.h"
#import "UIColor+DGSCustomColor.h"

@implementation TKSTextField

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	self.backgroundColor = [UIColor whiteColor];
	self.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.autocorrectionType = UITextAutocorrectionTypeNo;

	[self setupReactiveStuff];

	return self;
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[self.rac_textSignal
		subscribeNext:^(NSString *text) {
			@strongify(self);

			self.searchVM.text = text;
		}];

	RAC(self, text) = [RACObserve(self, searchVM.text) distinctUntilChanged];

	[RACObserve(self, searchVM.active) subscribeNext:^(NSNumber *active) {
		@strongify(self);

		if (active.boolValue)
		{
			[self becomeFirstResponder];
		}
		else
		{
			[self resignFirstResponder];
		}
	}];
}

@end
