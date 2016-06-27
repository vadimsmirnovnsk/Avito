#import "AVTResultCellVM.h"

#import "AVTAppleItem.h"
#import "AVTGitHubItem.h"

@interface AVTResultCellVM ()

@property (nonatomic, copy, readonly) NSString *imageURLString;
@property (nonatomic, strong, readwrite, nullable) UIImage *image;
@property (nonatomic, copy, readonly) id<AVTDataProviderProtocol> dataProvider;

@end

@implementation AVTResultCellVM

- (instancetype)initWithTitle:(NSString *)title
					 subtitle:(NSString *)subtitle
			   imageURLString:(NSString *)imageURLString
					alignment:(AVTCellAlignment)alignment
				 dataProvider:(id<AVTDataProviderProtocol>)dataProvider
{
	self = [super init];
	if (self == nil) return nil;

	_title = [title copy];
	_subtitle = [subtitle copy];
	_imageURLString = [imageURLString copy];
	_dataProvider = dataProvider;
	_alignment = alignment;

	[self loadImage];

	return self;
}


- (void)loadImage
{
	@weakify(self);

	NSURL *imageURL = [NSURL URLWithString:self.imageURLString];

	[[self.dataProvider fetchImageDataForURL:imageURL]
		subscribeNext:^(NSData *imageData) {
			@strongify(self);

			UIImage *image = [UIImage imageWithData:imageData];
			self.image = image;
		}];
}

@end

@implementation AVTResultCellVM (AVTFabric)

+ (instancetype)cellVMForModel:(id)model index:(NSInteger)index dataProvider:(id<AVTDataProviderProtocol>)dataProvider
{
	AVTResultCellVM *cellVM = nil;

	if ([model isKindOfClass:[AVTAppleItem class]])
	{
		AVTAppleItem *appleItem = (AVTAppleItem *)model;

		AVTCellAlignment alignment = index % 2
			? AVTCellAlignmentLeft
			: AVTCellAlignmentRight;

		cellVM = [[AVTResultCellVM alloc] initWithTitle:appleItem.title
											   subtitle:appleItem.author
										 imageURLString:appleItem.imageURLString
											  alignment:alignment
										   dataProvider:dataProvider];
	}
	else if ([model isKindOfClass:[AVTGitHubItem class]])
	{
		AVTGitHubItem *gitHubItem = (AVTGitHubItem *)model;

		AVTCellAlignment alignment = index % 2
			? AVTCellAlignmentRight
			: AVTCellAlignmentLeft;

		cellVM = [[AVTResultCellVM alloc] initWithTitle:gitHubItem.login
											   subtitle:gitHubItem.accountURLString
										 imageURLString:gitHubItem.imageURLString
											  alignment:alignment
										   dataProvider:dataProvider];
	}
	else
	{
		NSCAssert(NO, @"Unexpected Model Type");
		cellVM = [[AVTResultCellVM alloc] initWithTitle:@""
											   subtitle:@""
										 imageURLString:@""
											  alignment:0
										   dataProvider:dataProvider];
	}

	return cellVM;
}

@end
