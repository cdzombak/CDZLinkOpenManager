#import "CDZBrowserSelectorViewController.h"

@interface CDZBrowserSelectorViewController ()

@property (nonatomic, strong) NSIndexPath *previouslySelectedIndexPath;

@end

@implementation CDZBrowserSelectorViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.tableViewCellSelectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contentSizeForViewInPopover = CGSizeMake(320, 44*CDZNumBrowsers + 20);
}

#pragma mark UI Help

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [CDZLinkOpenManager nameForBrowser:indexPath.row];

    if ([CDZLinkOpenManager browserAvailable:indexPath.row]) {
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.selectionStyle = self.tableViewCellSelectionStyle;
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if ([CDZLinkOpenManager selectedBrowser] == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CDZNumBrowsers;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDZBrowser selectedBrowser = indexPath.row;
    [CDZLinkOpenManager setSelectedBrowser:selectedBrowser];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

    if (self.previouslySelectedIndexPath && [indexPath compare:self.previouslySelectedIndexPath] != NSOrderedSame) {
        [self.tableView cellForRowAtIndexPath:self.previouslySelectedIndexPath].accessoryType = UITableViewCellAccessoryNone;
    }

    if (self.browserSelectedBlock) {
        self.browserSelectedBlock(selectedBrowser);
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // hack:
    self.previouslySelectedIndexPath = [NSIndexPath indexPathForRow:[CDZLinkOpenManager selectedBrowser] inSection:0];

    if ([CDZLinkOpenManager browserAvailable:indexPath.row]) return indexPath;
    else return nil;
}

@end
