#import "AVTSearchHeaderView.h"

#import "AVTTextField.h"

@interface AVTSearchHeaderView ()

@property (nonatomic, strong, readonly) AVTTextField *textField;

@end

@implementation AVTSearchHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	_textField = [[AVTTextField alloc] init];
	[self.contentView addSubview:_textField];
	[_textField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0));
	}];

	return self;
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	self.textField.searchVM = self.viewModel;
}

@end
