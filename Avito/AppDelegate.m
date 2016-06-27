#import "AppDelegate.h"

#import "AVTRootVC.h"
#import "AVTRootVM.h"

@interface AppDelegate ()

@property (nonatomic, strong) AVTRootVM *rootVM;

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

	self.rootVM = [[AVTRootVM alloc] init];
	AVTRootVC *rootVC = [[AVTRootVC alloc] initWithViewModel:self.rootVM];
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:rootVC];

	self.window.rootViewController = nc;
	[self.window makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[self.rootVM cleanCache];
}

@end
