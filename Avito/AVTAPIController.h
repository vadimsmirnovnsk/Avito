typedef NS_ENUM(NSUInteger, AVTService) {
	AVTServiceApple = 0,
	AVTServiceGitHub = 1,
};

@interface AVTAPIController : NSObject

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method service:(AVTService)service params:(NSDictionary *)params;

@end
