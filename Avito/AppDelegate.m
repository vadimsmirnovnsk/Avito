#import "AppDelegate.h"

#import "AVTRootVC.h"
#import "AVTRootVM.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self setupUI];

	return YES;
}

- (void)setupUI
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

	AVTRootVM *rootVM = [[AVTRootVM alloc] init];
	AVTRootVC *rootVC = [[AVTRootVC alloc] initWithViewModel:rootVM];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:rootVC];

	self.window.rootViewController = nc;
	[self.window makeKeyAndVisible];
}

@end
