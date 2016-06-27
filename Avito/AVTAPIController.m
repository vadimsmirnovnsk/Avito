#import "AVTAPIController.h"

#import "AVTAppleItem.h"
#import "AVTGitHubItem.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kAVTBaseURLStringApple = @"http://itunes.apple.com/";
static NSString *const kAVTBaseURLStringGitHub = @"https://api.github.com/";

@interface AVTAPIController ()

@property (nonatomic, strong, readonly) AFHTTPRequestOperationManager *requestManagerApple;
@property (nonatomic, strong, readonly) AFHTTPRequestOperationManager *requestManagerGitHub;
@property (nonatomic, strong, readonly) NSCache *imageCache;
@property (nonatomic, strong, readonly) RACSubject *didOccurNetworkErrorSubject;

@end

@implementation AVTAPIController

- (instancetype)init
{
	self = [super init];
	if (self == nil) return nil;

	_requestManagerApple = [AVTAPIController requestManagerWithURLString:kAVTBaseURLStringApple];
	_requestManagerGitHub = [AVTAPIController requestManagerWithURLString:kAVTBaseURLStringGitHub];
	
	_imageCache = [[NSCache alloc] init];

	_didOccurNetworkErrorSubject = [RACSubject subject];
	_didOccurNetworkErrorSignal = _didOccurNetworkErrorSubject;

	return self;
}

- (void)dealloc
{
	[self.didOccurNetworkErrorSubject sendCompleted];
}

+ (AFHTTPRequestOperationManager *)requestManagerWithURLString:(NSString *)urlString
{
	AFHTTPRequestOperationManager *manager =
		[[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlString]];

	manager.requestSerializer = [AFJSONRequestSerializer serializer];
	manager.requestSerializer.timeoutInterval = 30.0;
	manager.responseSerializer = [AFJSONResponseSerializer serializer];

	NSSet *typesSet = [NSSet setWithArray:@[@"text/plain", @"application/json", @"text/javascript"]];
	[manager.responseSerializer setAcceptableContentTypes:typesSet];

	return manager;
}

- (RACSignal *)GET:(NSString *)method service:(AVTService)service params:(NSDictionary *)params
{
	@weakify(self);
	
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self);

		id successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
			NSLog(@"<TKSAPIController> Request did successfully complete: %@", operation.request);

			[subscriber sendNext:responseObject];
			[subscriber sendCompleted];
		};

		id failBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"<TKSAPIController> REQUEST ERROR: %@", error);
			[subscriber sendError:error];
		};

		AFHTTPRequestOperationManager *requestManager = [self requestManagerForService:service];
		AFHTTPRequestOperation *operation = [requestManager GET:method parameters:params success:successBlock failure:failBlock];

		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}]
	doError:^(NSError *error) {
		@strongify(self);

		[self.didOccurNetworkErrorSubject sendNext:error];
	}];
}

- (NSData *_Nullable)cachedDataForKey:(NSString *)key
{
	NSCParameterAssert(key);

	NSData *data = nil;

	if (key.length > 0)
	{
		data = [self.imageCache objectForKey:key];
	}

	return data;
}

- (void)setCachedData:(NSData *)data forKey:(NSString *)key
{
	NSCParameterAssert(data);
	NSCParameterAssert(key);

	if (data.length > 0 && key.length > 0)
	{
		[self.imageCache setObject:data forKey:key];
	}
}

- (void)cleanImagesCache
{
	[self.imageCache removeAllObjects];
}

- (AFHTTPRequestOperationManager *)requestManagerForService:(AVTService)service
{
	switch (service)
	{
		case AVTServiceApple	: return self.requestManagerApple;
		case AVTServiceGitHub	: return self.requestManagerGitHub;
	}

	return nil;
}

// MARK: AVTDataProviderProtocol

// https://itunes.apple.com/search?term=Check&country=us&entity=software&genreId=6001
// itunes.apple.com/search?term=jack+johnson
- (RACSignal *)fetchAppleItemsForQuery:(NSString *)query
{
	@weakify(self);

	if (query.length == 0) return [RACSignal return:@[]];

	NSString *queryWithoutSpaces = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
	NSDictionary *params = @{
		@"term" : queryWithoutSpaces,
	};
	return [[[[self GET:@"search" service:AVTServiceApple params:params]
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
		flattenMap:^RACStream *(NSArray *results) {
			@strongify(self);

			return [self checkedForEmptyResultsSignal:results];
		}]
		catchTo:[RACSignal return:nil]];
}

// api.github.com/search/users?q=tom
- (RACSignal *)fetchGitHubItemsForQuery:(NSString *)query
{
	@weakify(self);

	if (query.length == 0) return [RACSignal return:@[]];

	NSDictionary *params = @{
		@"q" : query,
	};
	return [[[[self GET:@"search/users" service:AVTServiceGitHub params:params]
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
		flattenMap:^RACStream *(NSArray *results) {
			@strongify(self);

			return [self checkedForEmptyResultsSignal:results];
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

// MARK: Helper Signals

- (RACSignal *)checkedForEmptyResultsSignal:(NSArray *)results
{
	if (results.count == 0)
	{
		[self.didOccurNetworkErrorSubject sendNext:[self errorWithMessage:@"Ничего не нашлось ='("]];
	}

	return [RACSignal return:results];
}

- (NSError *)errorWithMessage:(NSString *)message
{
	return [[NSError alloc] initWithDomain:@"avt.avt" code:0 userInfo:@{
		NSLocalizedDescriptionKey : message,
	}];
}

@end
