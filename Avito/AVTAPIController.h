typedef NS_ENUM(NSUInteger, AVTService) {
	AVTServiceApple = 0,
	AVTServiceGitHub = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface AVTAPIController : NSObject

/*! \return NSDictionary */
- (RACSignal *)GET:(NSString *)method service:(AVTService)service params:(NSDictionary *_Nullable)params;

/*! Image Cache */
- (NSData *_Nullable)cachedDataForKey:(NSString *)key;
- (void)setCachedData:(NSData *)data forKey:(NSString *)key;
- (void)cleanImagesCache;

@end

NS_ASSUME_NONNULL_END
