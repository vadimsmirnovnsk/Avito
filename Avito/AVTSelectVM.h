#import "AVTBaseVM.h"

@interface AVTSelectVM : AVTBaseVM

@property (nonatomic, copy, readonly) NSArray<NSString *> *selectorTitles;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

- (void)selectTitleWithIndex:(NSInteger)index;

@end
