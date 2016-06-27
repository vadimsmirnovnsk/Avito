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
	self.window.rootViewController = [[AVTRootVC alloc] initWithViewModel:self.rootVM];
	[self.window makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[self.rootVM cleanCache];
}

@end
