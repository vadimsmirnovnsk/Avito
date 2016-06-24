@interface AVTBaseVC<ViewModelClass> : UIViewController

- (instancetype)initWithViewModel:(ViewModelClass)viewModel NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (ViewModelClass)viewModel;

@end
