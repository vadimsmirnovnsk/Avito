#import "AVTAPIController+Entities.h"

#import "AVTAppleItem.h"
#import "AVTGitHubItem.h"

@implementation AVTAPIController (Entities)

// https://itunes.apple.com/search?term=Check&country=us&entity=software&genreId=6001
// itunes.apple.com/search?term=jack+johnson
- (RACSignal *)fetchAppleItemsForQuery:(NSString *)query
{
	if (query.length == 0) return [RACSignal return:@[]];

	NSString *queryWithoutSpaces = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSDictionary *params = @{
		@"term" : queryWithoutSpaces,
	};
	return [[[self GET:@"search" service:AVTServiceApple params:params]
		map:^NSArray<AVTAppleItem *> *(NSDictionary *responseObject) {
			NSArray<AVTAppleItem *> *returnItems = nil;

			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSArray *itemDictionaries = responseObject[@"results"];

				returnItems = [itemDictionaries.rac_sequence
					map:^AVTAppleItem *(NSDictionary *itemDictionary) {
						return[[AVTAppleItem alloc] initWithDictionary:itemDictionary];
					}].array;
			}

			return returnItems;
		}]
		catchTo:[RACSignal return:nil]];
}

// api.github.com/search/users?q=tom
- (RACSignal *)fetchGitHubItemsForQuery:(NSString *)query
{
	if (query.length == 0) return [RACSignal return:@[]];
	
	NSDictionary *params = @{
		@"q" : query,
	};
	return [[[self GET:@"search/users" service:AVTServiceGitHub params:params]
		map:^NSArray<AVTGitHubItem *> *(NSDictionary *responseObject) {
			NSArray<AVTGitHubItem *> *returnItems = nil;

			if ([responseObject isKindOfClass:[NSDictionary class]])
			{
				NSArray *itemDictionaries = responseObject[@"items"];

				returnItems = [itemDictionaries.rac_sequence
					map:^AVTGitHubItem *(NSDictionary *itemDictionary) {
						return[[AVTGitHubItem alloc] initWithDictionary:itemDictionary];
					}].array;
			}

			return returnItems;
		}]
		catchTo:[RACSignal return:nil]];
}

- (RACSignal *)fetchImageDataForURL:(NSURL *)imageURL
{
	NSCParameterAssert(imageURL);

	@weakify(self);

	NSData *cachedImageData = [self cachedDataForKey:imageURL.absoluteString];

	if (cachedImageData)
	{
		return [RACSignal return:cachedImageData];
	}
	else
	{
		return [[[NSData rac_readContentsOfURL:imageURL
									   options:NSDataReadingMappedIfSafe
									 scheduler:[RACScheduler scheduler]]
			doNext:^(NSData *imageData) {
				@strongify(self);

				if (imageData.length > 0)
				{
					[self setCachedData:imageData forKey:imageURL.absoluteString];
				}
			}]
			flattenMap:^RACStream *(NSData *imageData) {
				return imageData.length > 0
					? [RACSignal return:imageData]
					: [RACSignal error:nil];
			}];
	}
}

@end
