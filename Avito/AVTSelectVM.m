#import "AVTSelectVM.h"

@interface AVTSelectVM ()

@property (nonatomic, assign, readwrite) NSInteger selectedIndex;

@end

@implementation AVTSelectVM

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_selectorTitles = @[@"iTunes", @"GitHub"];

	return self;
}

- (void)selectTitleWithIndex:(NSInteger)index
{
	self.selectedIndex = index;
}

@end
