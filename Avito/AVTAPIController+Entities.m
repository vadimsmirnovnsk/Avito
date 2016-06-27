#import "AVTAPIController+Entities.h"

#import "AVTAppleItem.h"
#import "AVTGitHubItem.h"

@implementation AVTAPIController (Entities)

// https://itunes.apple.com/search?term=Check&country=us&entity=software&genreId=6001
// itunes.apple.com/search?term=jack+johnson
- (RACSignal *)fetchAppleItemsForQuery:(NSString *)query
{
	NSString *queryWithoutSpaces = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSDictionary *params = @{
		@"term" : queryWithoutSpaces,
	};
	return [[self GET:@"search" service:AVTServiceApple params:params]
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
		}];
}

// api.github.com/search/users?q=tom
- (RACSignal *)fetchGitHubItemsForQuery:(NSString *)query
{
	NSDictionary *params = @{
		@"q" : query,
	};
	return [[self GET:@"search/users" service:AVTServiceGitHub params:params]
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
		}];
}

@end
