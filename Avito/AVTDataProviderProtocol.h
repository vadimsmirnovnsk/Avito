@protocol AVTDataProviderProtocol <NSObject>

/*! iTunes items
 *	\sendNext @[AVTAppleItem]
 **/
- (RACSignal *)fetchAppleItems;

/*! iTunes items
 *	\sendNext @[AVTGitHubItem]
 **/
- (RACSignal *)fetchGitHubItems;

@end
