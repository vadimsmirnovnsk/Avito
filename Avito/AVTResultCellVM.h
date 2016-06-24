#import "AVTBaseVM.h"

@interface AVTResultCellVM : AVTBaseVM

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, strong, readonly) UIImage *image;

- (instancetype)initWithTitle:(NSString *)title
					 subtitle:(NSString *)subtitle
			   imageURLString:(NSString *)imageURLString NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end
