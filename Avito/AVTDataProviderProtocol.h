@protocol AVTDataProviderProtocol <NSObject>

/*! iTunes items
 *	\sendNext @[AVTAppleItem]
 **/
- (RACSignal *)fetchAppleItemsForQuery:(NSString *)query;

/*! iTunes items
 *	\sendNext @[AVTGitHubItem]
 **/
- (RACSignal *)fetchGitHubItemsForQuery:(NSString *)query;

/*! Image Data
 *	\sendNext NSData, \sendError nil.
 **/
- (RACSignal *)fetchImageDataForURL:(NSURL *)imageURL;

@end
