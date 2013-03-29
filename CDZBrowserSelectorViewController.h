#import <UIKit/UIKit.h>
#import "CDZLinkOpenManager.h"

typedef void (^CDZBrowserSelectedBlock)(CDZBrowser browser);

@interface CDZBrowserSelectorViewController : UITableViewController

/**
 * This block will be called when the user selects a browser.
 *
 * You might take this opportunity to dismiss a popover or pop your
 * navigation controller, for example.
 */
@property (nonatomic, copy) CDZBrowserSelectedBlock browserSelectedBlock;

/**
 * You can customize the UItableView's cell selection style here.
 */
@property (nonatomic, assign) UITableViewCellSelectionStyle tableViewCellSelectionStyle;

/**
 * Designated initializer
 */
- (id)init;

// Override -[ viewDidLoad] to customize appearance, if UIAppearance won't work well enough for you

@end
