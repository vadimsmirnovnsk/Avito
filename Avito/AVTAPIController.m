#import "AVTAPIController.h"

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

@end
