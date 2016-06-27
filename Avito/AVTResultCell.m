#import "AVTResultCell.h"

static CGSize const kImageViewSize = (CGSize) {44.0, 44.0};
static CGFloat const kDefaultInset = 8.0;

@interface AVTResultCell (AVTSubviews)

+ (UILabel *)newLabelOnSuperview:(UIView *)superview;
+ (UIImageView *)newImageViewOnSuperview:(UIView *)superview;

@end

@interface AVTResultCell ()

@property (nonatomic, strong, readonly) UIView *containerViewAlignLeft;
@property (nonatomic, strong, readonly) UILabel *titleLabelLeft;
@property (nonatomic, strong, readonly) UILabel *subtitleLabelLeft;
@property (nonatomic, strong, readonly) UIImageView *imageViewLeft;

@property (nonatomic, strong, readonly) UIView *containerViewAlignRight;
@property (nonatomic, strong, readonly) UILabel *titleLabelRight;
@property (nonatomic, strong, readonly) UILabel *subtitleLabelRight;
@property (nonatomic, strong, readonly) UIImageView *imageViewRight;

@end

@implementation AVTResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self == nil) return nil;

	[self createContainerAlignLeft];
	[self createContainerAlignRight];
	[self setupReactiveStuff];

	return self;
}

- (void)createContainerAlignLeft
{
	_containerViewAlignLeft = [[UIView alloc] init];
	[self.contentView addSubview:_containerViewAlignLeft];

	_imageViewLeft = [AVTResultCell newImageViewOnSuperview:_containerViewAlignLeft];

	_titleLabelLeft = [AVTResultCell newLabelOnSuperview:_containerViewAlignLeft];
	_titleLabelLeft.textAlignment = NSTextAlignmentLeft;

	_subtitleLabelLeft = [AVTResultCell newLabelOnSuperview:_containerViewAlignLeft];
	_subtitleLabelLeft.textAlignment = NSTextAlignmentLeft;

	// Layout
	[_containerViewAlignLeft mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView);
	}];

	[_imageViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_containerViewAlignLeft).with.offset(kDefaultInset);
		make.centerY.equalTo(_containerViewAlignLeft);
	}];

	[_titleLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_imageViewLeft.mas_trailing).with.offset(kDefaultInset);
		make.bottom.equalTo(self.contentView.mas_centerY);
		make.trailing.lessThanOrEqualTo(self.contentView).with.offset(-kDefaultInset);
	}];

	[_subtitleLabelLeft mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(_titleLabelLeft);
		make.top.equalTo(self.contentView.mas_centerY);
		make.trailing.lessThanOrEqualTo(self.contentView).with.offset(-kDefaultInset);
	}];
}

- (void)createContainerAlignRight
{
	_containerViewAlignRight = [[UIView alloc] init];
	[self.contentView addSubview:_containerViewAlignRight];

	_imageViewRight = [AVTResultCell newImageViewOnSuperview:_containerViewAlignRight];

	_titleLabelRight = [AVTResultCell newLabelOnSuperview:_containerViewAlignRight];
	_titleLabelRight.textAlignment = NSTextAlignmentRight;

	_subtitleLabelRight = [AVTResultCell newLabelOnSuperview:_containerViewAlignRight];
	_subtitleLabelRight.textAlignment = NSTextAlignmentRight;

	// Layout
	[_containerViewAlignRight mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.contentView);
	}];

	[_imageViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(_containerViewAlignRight).with.offset(-kDefaultInset);
		make.centerY.equalTo(_containerViewAlignRight);
	}];

	[_titleLabelRight mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(_imageViewRight.mas_leading).with.offset(-kDefaultInset);
		make.bottom.equalTo(self.contentView.mas_centerY);
		make.leading.greaterThanOrEqualTo(self.contentView).with.offset(kDefaultInset);
	}];

	[_subtitleLabelRight mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.equalTo(_titleLabelRight);
		make.top.equalTo(self.contentView.mas_centerY);
		make.leading.greaterThanOrEqualTo(self.contentView).with.offset(kDefaultInset);
	}];
}

- (void)setupReactiveStuff
{
	@weakify(self);

	[[RACObserve(self, viewModel.image)
		deliverOnMainThread]
		subscribeNext:^(UIImage *image) {
			@strongify(self);

			[UIView animateWithDuration:0.3 animations:^{
				self.imageViewLeft.image = image;
				self.imageViewRight.image = image;
			}];
		}];
}

- (void)setViewModel:(id)viewModel
{
	[super setViewModel:viewModel];

	self.titleLabelLeft.text = self.viewModel.title;
	self.titleLabelRight.text = self.viewModel.title;

	self.subtitleLabelLeft.text = self.viewModel.subtitle;
	self.subtitleLabelRight.text = self.viewModel.subtitle;

	BOOL hideAlignLeft = self.viewModel.alignment == AVTCellAlignmentRight;

	self.containerViewAlignLeft.hidden = hideAlignLeft;
	self.containerViewAlignRight.hidden = !hideAlignLeft;
}

@end

@implementation AVTResultCell (AVTSubviews)

+ (UILabel *)newLabelOnSuperview:(UIView *)superview
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	[superview addSubview:label];
	return label;
}

+ (UIImageView *)newImageViewOnSuperview:(UIView *)superview
{
	UIImageView *imageView = [[UIImageView alloc] init];
	imageView.backgroundColor = [UIColor grayColor];
	[superview addSubview:imageView];

	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(kImageViewSize);
	}];

	return imageView;
}

@end
