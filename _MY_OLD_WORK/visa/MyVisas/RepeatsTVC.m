//
//  RepeatsTVC.m
//  MyVisas
//
//  Created by Nnn on 25.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "RepeatsTVC.h"
#import "Utils.h"

@interface RepeatsTVC() 
@property (nonatomic, retain) NSMutableArray *cellValues;
@end

@implementation RepeatsTVC
@synthesize index, cellValues;

- (void)dealloc {
    self.cellValues = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    switch (index) {
        case 0:
        {
            self.cellValues = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3],
                               [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6],
                               [NSNumber numberWithInt:7], [NSNumber numberWithInt:14], [NSNumber numberWithInt:30], nil];
            break;
        }  
        case 1:
        {
            self.cellValues = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3],
                               [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], [NSNumber numberWithInt:7], nil];
            break;
        } 
        case 2:
        {
            self.cellValues = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:7], [NSNumber numberWithInt:14], [NSNumber numberWithInt:30], [NSNumber numberWithInt:180], nil];
            break;
        } 
        default:
            break;
    }
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_back.png"]] autorelease];
    UIButton *btn = createBackNavButton();
    [btn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];

}

- (void)viewDidAppear:(BOOL)animated {
    NSInteger row = [cellValues indexOfObject:[[AppData sharedAppData].alertsBeginDays objectAtIndex:index]];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)saveNewSettings {
    // if repeats interval was week, and new value of before days num < 7, change repeats interval to every day
    if (index == 0 && [[[AppData sharedAppData].alertsBeginDays objectAtIndex:index] intValue] < 7) {
        if ([[[AppData sharedAppData].repeatDays objectAtIndex:index] intValue] > 1) {
            [[AppData sharedAppData].repeatDays replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:1]];
        }
    }
}

- (void)appResignActive {
    [self saveNewSettings];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveNewSettings];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.cellValues = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return self.cellValues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSNumber *daysValue = [cellValues objectAtIndex:indexPath.row];
    BOOL selectedDate = [daysValue isEqualToNumber:[[AppData sharedAppData].alertsBeginDays objectAtIndex:index]];
    
    cell.backgroundColor = BACK_COLOR;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = getTextForAlertDays([daysValue intValue]);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.accessoryView = selectedDate ? [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]] autorelease] : nil;
    cell.accessoryType = selectedDate ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[AppData sharedAppData].alertsBeginDays replaceObjectAtIndex:index withObject:[cellValues objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0f];
    [(AppDelegate *)[UIApplication sharedApplication].delegate recreateNotifications];
}

@end
