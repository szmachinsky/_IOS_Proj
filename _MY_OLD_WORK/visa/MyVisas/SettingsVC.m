//
//  SettingsVC.m
//  MyVisas
//
//  Created by Nnn on 12.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertCell.h"
#import "AlertSettingsVC.h"
#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "PassportVC.h"
#import "RepeatsTVC.h"
#import "SettingsVC.h"
#import "TimeVC.h"
#import "Utils.h"

@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRect:(CGRect)rect {
	UIImage *img = [UIImage imageNamed: @"top.png"];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawImage(context, CGRectMake(0, 0, 320, self.frame.size.height), img.CGImage);
    
}
@end

enum {
  PASSPORT,
  ALERTS,
  REPEATS,
};

@interface SettingsVC() 
@property (nonatomic, retain) NSArray *cellTexts;
@property (nonatomic, retain) NSArray *sectionTitles;
@property (nonatomic, retain) IBOutlet AlertCell *alertCell;
@end

@implementation SettingsVC
@synthesize cellTexts, sectionTitles, alertCell;

static const int SWITHER_TAG = 4;

- (void)dealloc {
    self.cellTexts = nil;
    self.sectionTitles = nil;
    self.alertCell = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)getCellTexts {
    NSArray *alertsSectionArr = !([[[AppData sharedAppData].passportInfo objectForKey:@"expiryDate"] isEqual:[NSNull null]]) 
    ? [NSArray arrayWithObjects:NSLocalizedString(@"visas expiration", @"visas expiration"), NSLocalizedString(@"end of the period of stay", @"end of the period of stay"), NSLocalizedString(@"Passport", @"passport information"), nil] : [NSArray arrayWithObjects:NSLocalizedString(@"visas expiration", @"visas expiration"), NSLocalizedString(@"end of the period of stay", @"end of the period of stay"), nil];
 
    self.cellTexts = [NSArray arrayWithObjects:[NSArray arrayWithObject:NSLocalizedString(@"validity", @"validity")], alertsSectionArr, nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Settings", @"settings");
    if (isSystemVersionMoreThen(5.0)) {
        for (UIView *v in self.navigationController.navigationBar.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UINavigationBarBackground")]) {
                UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]] autorelease];
                [v insertSubview:imageView atIndex:1];
                 
            }
        }
    }
    // titles
    self.sectionTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Passport", @"passport information"), NSLocalizedString(@"Alerts", @"alert about"), nil];
    [self getCellTexts];
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_back.png"]] autorelease];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getCellTexts];
    self.navigationItem.title = NSLocalizedString(@"Settings", @"settings");
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[AppData sharedAppData] save];
}

- (void)cancelPressed {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[cellTexts objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sectionTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    if (indexPath.section == 0) {
        height = 55.0f;
    }
    else {
        BOOL switchOn = [[[AppData sharedAppData].showAlerts objectAtIndex:indexPath.row] boolValue];
        height = switchOn ? 70.0f : 44.0f;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    NSArray *sectionTexts = (NSArray *)[cellTexts objectAtIndex:indexPath.section];
    
    AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AlertCell" owner:self options:nil];
        cell = alertCell;
    }
    
    cell.descriptionLabel.text = nil;
    cell.settingsLabel.text = nil;
    cell.repeatsLabel.text = nil;
    cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
        
    if (indexPath.section == PASSPORT) {
        cell.titleLabel.text = [sectionTexts objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        NSDictionary *info = [AppData sharedAppData].passportInfo;
        NSDate *issueDate = [info objectForKey:@"issueDate"];
        NSDate *expiryDate = [info objectForKey:@"expiryDate"];
        
        cell.descriptionLabel.text = (checkForNotNull(issueDate) || checkForNotNull(expiryDate))
        ? configureDatesStrFromDates(issueDate, expiryDate) : NSLocalizedString(@"Passport Not entered", @"Passport Not entered");
    }
    else {
        cell.titleLabel.text = [sectionTexts objectAtIndex:indexPath.row];
        
        BOOL switchOn = [[[AppData sharedAppData].showAlerts objectAtIndex:indexPath.row] boolValue];
        if (switchOn) {
            NSString *beforeStr = getTextForAlertDays([[[AppData sharedAppData].alertsBeginDays objectAtIndex:indexPath.row] intValue]);
            NSString *timeStr = [[AppData sharedAppData].alertsTime objectAtIndex:indexPath.row];
            NSString *settingsStr = [NSString stringWithFormat:NSLocalizedString(@"Alert %@ at %@", @"Alert summary string"), beforeStr, timeStr];
            cell.settingsLabel.text = settingsStr;
            
            NSInteger repeatInterval = [[[AppData sharedAppData].repeatDays objectAtIndex:indexPath.row] intValue];
            NSString *str = nil;
            switch (repeatInterval) {
                case 0:
                    str = NSLocalizedString(@"once", @"once");
                    break;
                case 1:
                    str = NSLocalizedString(@"every day", @"every day");
                    break;
                case 2:
                    str = NSLocalizedString(@"every week", @"every week");
                    break;
                case 3:
                    str = NSLocalizedString(@"every month", @"every month");
                    break;
                default:
                    break;
            }
            cell.repeatsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Repeat: %@", @"repeat string"), str];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case PASSPORT:
        {
            PassportVC *passportVC = [[[PassportVC alloc] init] autorelease];
            [self.navigationController pushViewController:passportVC animated:YES];
        }
            break;
        case ALERTS:
        {
            AlertSettingsVC *alertSettings = [[[AlertSettingsVC alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            alertSettings.index = indexPath.row;
            [self.navigationController pushViewController:alertSettings animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
