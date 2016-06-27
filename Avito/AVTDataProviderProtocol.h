@protocol AVTDataProviderProtocol <NSObject>

/*! iTunes items
 *	\sendNext @[AVTAppleItem]
 **/
- (RACSignal *)fetchAppleItemsForQuery:(NSString *)query;

/*! iTunes items
 *	\sendNext @[AVTGitHubItem]
 **/
- (RACSignal *)fetchGitHubItemsForQuery:(NSString *)query;

@end
