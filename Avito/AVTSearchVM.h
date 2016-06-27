#import "AVTBaseVM.h"

@interface AVTSearchVM : AVTBaseVM

@property (nonatomic, assign) BOOL active;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeHolder;

@end
