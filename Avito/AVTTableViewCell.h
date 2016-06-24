// Additional height for the cell separator height
// http://www.raywenderlich.com/73602/dynamic-table-view-cell-height-auto-layout
extern CGFloat const kAVTTableViewCellSeparatorHeight;

@interface AVTTableViewCell<ViewModelClass> : UITableViewCell

@property (nonatomic, strong) ViewModelClass viewModel;
@end