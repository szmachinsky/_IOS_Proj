//
//  AlertSettingsVC.m
//  MyVisas
//
//  Created by Nnn on 13.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertSettingsVC.h"
#import "AppConfig.h"
#import "AppData.h"
#import "AppDelegate.h"
#import "RepeatsTVC.h"
#import "TimeVC.h"
#import "Utils.h"

@interface AlertSettingsVC() 
@property (nonatomic, retain) NSArray *cellTexts;
@property (nonatomic, retain) NSMutableArray *repeatsValues;
@end;

@implementation AlertSettingsVC
@synthesize index, cellTexts, repeatsValues;

- (void)dealloc {
    self.cellTexts = nil;
    self.repeatsValues = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)getCellTexts {
    NSInteger beginDays = [[[AppData sharedAppData].alertsBeginDays objectAtIndex:index] intValue];
    if (repeatsValues != nil) {
        [repeatsValues removeAllObjects];
    }
    
    // second section
    NSMutableArray *settingsArr = [NSMutableArray arrayWithObjects:NSLocalizedString(@"Day", @"day"), NSLocalizedString(@"Time of alerts", @"time of alerts"), nil];
    
    // third section values
    if (index < 2) {
        // visas expiry and duration settings
        self.repeatsValues = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:1], nil];
        if (index == 0 && beginDays > 6) {
            [repeatsValues addObject:[NSNumber numberWithInt:2]];
        }
    }
    else {
        // passport settings
        self.repeatsValues = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil];
    }
    
    NSMutableArray *repeats = [NSMutableArray arrayWithCapacity:self.repeatsValues.count];
    for (NSNumber *value in self.repeatsValues) {
        NSInteger intVal = [value intValue];
        NSString *str = nil;
        switch (intVal) {
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
        [repeats addObject:str];
    }

    self.cellTexts = isOn ? [NSArray arrayWithObjects:[NSArray arrayWithObject:NSLocalizedString(@"Alert", @"alert")], settingsArr, repeats, nil] 
                                  : [NSArray arrayWithObject:[NSArray arrayWithObject:NSLocalizedString(@"Alert", @"alert")]]; 
}

#pragma mark - View lifecycle

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // back button
    UIButton *btn = createBackNavButton();
    [btn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    NSString *title = NSLocalizedString(@"Visa expiry", @"visa expiry");
    if (index == 1) {
        title = NSLocalizedString(@"Duration of stay", @"duration of stay");
    }
    else if (index == 2) {
        title = NSLocalizedString(@"Passport", @"passport");
    }
    self.navigationItem.title = title;
    
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"all_back.png"]] autorelease];
    [self getCellTexts];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    isOn = [[(NSMutableArray *)[AppData sharedAppData].showAlerts objectAtIndex:index] boolValue];
    [self getCellTexts];
    [self.tableView reloadData];
}

- (void)appResignActive {
    [[AppData sharedAppData].showAlerts replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:isOn]];
    [(AppDelegate *)[UIApplication sharedApplication].delegate recreateNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[AppData sharedAppData].showAlerts replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:isOn]];
    [(AppDelegate *)[UIApplication sharedApplication].delegate recreateNotifications];
}

- (void)switcherValueChanged:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    isOn = switcher.isOn;
    [self getCellTexts];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellTexts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.cellTexts objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    if (section == 1) {
        title = @"";//NSLocalizedString(@"Settings", @"settings");
    }
    else if (section == 2) {
        title = NSLocalizedString(@"Repeat", @"Repeat");
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.backgroundColor = BACK_COLOR;
    cell.accessoryView = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *sectionTexts = [self.cellTexts objectAtIndex:indexPath.section];
    cell.textLabel.text = [sectionTexts objectAtIndex:indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.detailTextLabel.text = nil;
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
        UISwitch *switcher = [[[UISwitch alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)] autorelease];
        [switcher setOn:isOn];
        [switcher addTarget:self action:@selector(switcherValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = switcher;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSInteger beginDays = [[[AppData sharedAppData].alertsBeginDays objectAtIndex:index] intValue];
            cell.detailTextLabel.text = getTextForAlertDays(beginDays);
        }
        else {
            cell.detailTextLabel.text = [[AppData sharedAppData].alertsTime objectAtIndex:index];
        }
        cell.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]] autorelease];
    }
    else {
        NSNumber *repeats = [[AppData sharedAppData].repeatDays objectAtIndex:index];
        cell.accessoryView = [repeats isEqualToNumber:[repeatsValues objectAtIndex:indexPath.row]] ? [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]] autorelease] : nil;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            RepeatsTVC *repeatsVC = [[[RepeatsTVC alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
            repeatsVC.index = index;
            [self.navigationController pushViewController:repeatsVC animated:YES];
        }
        else {
            TimeVC *timeVC = [[[TimeVC alloc] init] autorelease];
            timeVC.index = index;
            [self.navigationController pushViewController:timeVC animated:YES];
        }
    }
    else if (indexPath.section == 2) {
        NSNumber *repeats = [repeatsValues objectAtIndex:indexPath.row];
        [[AppData sharedAppData].repeatDays replaceObjectAtIndex:index withObject:repeats];
        [(AppDelegate *)[UIApplication sharedApplication].delegate recreateNotifications];
        [self.tableView reloadData];
    }
}

@end
