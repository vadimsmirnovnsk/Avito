#import "AVTBaseVM.h"

@protocol AVTDataProviderProtocol;
@class AVTResultCellVM;

@interface AVTResultsVM : AVTBaseVM

@property (nonatomic, copy, readonly) NSArray<AVTResultCellVM *> *resultVMs;

- (instancetype)initWithDataProvider:(id<AVTDataProviderProtocol>)dataProvider NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)loadResults:(NSArray *)results;

@end
