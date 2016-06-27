#import "AVTBaseVM.h"

#import "AVTDataProviderProtocol.h"

typedef NS_ENUM(NSInteger, AVTCellAlignment) {
	AVTCellAlignmentLeft = 0,
	AVTCellAlignmentRight = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface AVTResultCellVM : AVTBaseVM

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, strong, readonly, nullable) UIImage *image;
@property (nonatomic, assign, readonly) AVTCellAlignment alignment;

- (instancetype)initWithTitle:(NSString *)title
					 subtitle:(NSString *)subtitle
			   imageURLString:(NSString *)imageURLString
					alignment:(AVTCellAlignment)alignment
				 dataProvider:(id<AVTDataProviderProtocol>)dataProvider NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface AVTResultCellVM (AVTFabric)

+ (instancetype)cellVMForModel:(id)model index:(NSInteger)index dataProvider:(id<AVTDataProviderProtocol>)dataProvider;

@end

NS_ASSUME_NONNULL_END
