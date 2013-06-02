//
//  SelectChannelsController.m
//  TVProgram
//
//  Created by User1 on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectTimeZoneController.h"
#import "TVDataSingelton.h"

@implementation SelectTimeZoneController

NSInteger zoneSort(id num1, id num2, void *context)
{
    int h1 = [num1 intValue];
    int h2 = [num2 intValue];
    if (h1 < h2)
        return NSOrderedAscending;
    else if (h1 > h2)
        return NSOrderedDescending;
    else
    {
        return NSOrderedSame;
    }
}

-(void) createZones
{
    zones = [[NSMutableArray alloc] init];
    NSArray * zonesNames = [NSTimeZone knownTimeZoneNames];
    for (int i = 0; i < [zonesNames count]; i++) {
        NSTimeZone * zone = [NSTimeZone timeZoneWithName:[zonesNames objectAtIndex:i]];
        int offset = [zone secondsFromGMT] / 3600;
        if (![zones containsObject:[NSNumber numberWithInt: offset]]) {
            [zones addObject:[NSNumber numberWithInt: offset]];
        }
    }
    
    NSArray *sortedArray; 
    sortedArray = [zones sortedArrayUsingFunction:zoneSort context:NULL];
    zones = [NSMutableArray arrayWithArray:sortedArray];
}


-(void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame] ;
    UIView *myView = [[UIView alloc] initWithFrame:frame];
    self.view = myView;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 8, 58, 29);
    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    [self createZones];
    prevTimeZone = [NSTimeZone defaultTimeZone];
    
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                               style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:224/255.0 alpha:1];
    
    [mytableView reloadData];
    mytableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.view addSubview:mytableView];     
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [zones count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSNumber *offset = [zones objectAtIndex:indexPath.row];
    NSString * day = [NSString stringWithFormat:@"GMT %i", [offset intValue]];
    cell.textLabel.text = day;
    NSTimeZone * zone = [NSTimeZone defaultTimeZone];
    NSNumber * def = [NSNumber numberWithInt:([zone secondsFromGMT] / 3600) ];
    if ([def intValue] == [offset intValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the checkmark accessory for the selected row.
    [[mytableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];    
    
    // Deselect the row.
    [mytableView deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber *offset = [zones objectAtIndex:indexPath.row];
    NSTimeZone *zone = [NSTimeZone timeZoneForSecondsFromGMT:[offset intValue] * 3600];
    [NSTimeZone setDefaultTimeZone:zone];
    [mytableView reloadData];
}

@end
