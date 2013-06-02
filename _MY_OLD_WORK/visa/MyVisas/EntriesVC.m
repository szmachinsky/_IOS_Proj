//
//  EntriesVC.m
//  MyVisas
//
//  Created by Natalia Tsybulenko on 23.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "AppData.h"
#import "EntriesVC.h"
#import "EntryCell.h"
#import "SeparatorLine.h"
#import "Utils.h"


@implementation EntriesVC
@synthesize country;

static const int NO_ENTRIES_TAG = 7; 

- (void)dealloc {
    [super dealloc];
    [entryCell release];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_back.png"]] autorelease];
 
    UIButton *backButton = createBackNavButton();
    [backButton addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    self.navigationItem.title = NSLocalizedString(@"Entries", @"Entries");
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (isSystemVersionMoreThen(5.0)) {
        for (UIView *v in self.navigationController.navigationBar.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UINavigationBarBackground")]) {
                UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]] autorelease];
                [v insertSubview:imageView atIndex:1];
                
            }
        }
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    NSMutableArray *entries = [[AppData sharedAppData].entries objectForKey:country];
    [[self.tableView viewWithTag:NO_ENTRIES_TAG] removeFromSuperview];
    if (entries.count == 0) {
        UILabel *noEntriesLabel = [[[UILabel alloc] initWithFrame:CGRectMake(40.0f, 120.0f, 240.0f, 100.0f)] autorelease];
        noEntriesLabel.backgroundColor = [UIColor clearColor];
        noEntriesLabel.textColor = [UIColor colorWithRed:59.0f/255.0f green:70.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
        noEntriesLabel.shadowColor = [UIColor clearColor];
        noEntriesLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        noEntriesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"No entries to %@", @"no entries"), getCountryNameByCode(country)];
        noEntriesLabel.textAlignment = UITextAlignmentCenter;
        noEntriesLabel.numberOfLines = 0;
        noEntriesLabel.font = [UIFont boldSystemFontOfSize:24.0f];
        noEntriesLabel.tag = NO_ENTRIES_TAG;
        [self.view addSubview:noEntriesLabel];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *entries = [[AppData sharedAppData].entries objectForKey:country];
    return entries.count > 0 ? entries.count + 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"EntryCell" owner:self options:nil];
        cell = entryCell;
    }
    
    BOOL titleCell = indexPath.row == 0;
    cell.backgroundColor = titleCell ? BACK_COLOR : BACK_COLOR2;
    cell.entryImage.hidden = cell.departureImage.hidden = cell.daysImage.hidden = titleCell;
    cell.countryLabel.text = titleCell ? getCountryNameByCode(country) : nil;
    cell.line.hidden = (indexPath.row == [[[AppData sharedAppData].entries objectForKey:country] count]);
    cell.line.dashed = !titleCell;
    [cell.line setNeedsDisplay];
    
    if (!titleCell) {
        NSMutableArray *entriesToCountry = [[AppData sharedAppData].entries objectForKey:country];
        NSDictionary *entryInfo = [entriesToCountry objectAtIndex:indexPath.row - 1];
        NSDate *departureDate = [entryInfo objectForKey:@"departure"];
        NSDate *entryDate = [entryInfo objectForKey:@"entryDate"];
        cell.entryDateLabel.text = formattedDate(entryDate, NO);
        cell.departureDateLabel.text = !checkForNotNull(departureDate) ? NSLocalizedString(@"Now in country", @"user in country") : formattedDate(departureDate, NO);
        NSInteger numOfDays = checkForNotNull(departureDate) ? daysBetweenDates(entryDate, departureDate) + 1 : daysBetweenDates(entryDate, [NSDate date]) + 1;
        cell.daysLabel.text = [NSString stringWithFormat:@"%d", numOfDays];
        cell.daysTextLabel.text = daysStr(numOfDays);
    }
    else {
        cell.entryDateLabel.text = cell.departureDateLabel.text = cell.daysLabel.text = nil;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
