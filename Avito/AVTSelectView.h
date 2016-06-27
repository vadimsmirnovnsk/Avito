@class AVTSelectVM;

@interface AVTSelectView : UISegmentedControl

- (instancetype)initWithViewModel:(AVTSelectVM *)viewModel NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithItems:(NSArray *)items NS_UNAVAILABLE;

@end
