#import "AppDelegate.h"

#import "AVTRootVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.rootViewController = [[AVTRootVC alloc] init];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
