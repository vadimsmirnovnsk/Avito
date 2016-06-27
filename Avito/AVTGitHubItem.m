#import "AVTGitHubItem.h"

@implementation AVTGitHubItem

/*!
	{
		"login": "tom",
		"id": 748,
		"avatar_url": "https://avatars.githubusercontent.com/u/748?v=3",
		"gravatar_id": "",
		"url": "https://api.github.com/users/tom",
		"html_url": "https://github.com/tom",
		"followers_url": "https://api.github.com/users/tom/followers",
		"following_url": "https://api.github.com/users/tom/following{/other_user}",
		"gists_url": "https://api.github.com/users/tom/gists{/gist_id}",
		"starred_url": "https://api.github.com/users/tom/starred{/owner}{/repo}",
		"subscriptions_url": "https://api.github.com/users/tom/subscriptions",
		"organizations_url": "https://api.github.com/users/tom/orgs",
		"repos_url": "https://api.github.com/users/tom/repos",
		"events_url": "https://api.github.com/users/tom/events{/privacy}",
		"received_events_url": "https://api.github.com/users/tom/received_events",
		"type": "User",
		"site_admin": false,
		"score": 64.36648
	},
*/
- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self == nil) return nil;

	_login = dictionary[@"login"];
	_accountURLString = dictionary[@"html_url"];
	_imageURLString = dictionary[@"avatar_url"];

	return self;
}

@end
