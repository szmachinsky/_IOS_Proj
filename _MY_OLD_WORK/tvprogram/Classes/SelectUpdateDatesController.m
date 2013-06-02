//
//  SelectChannelsController.m
//  TVProgram
//
//  Created by User1 on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectUpdateDatesController.h"
#import "TVDataSingelton.h"

@implementation SelectUpdateDatesController

-(void)close:(id)sender
{
    if ([selectedDays count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Вы должны выбрать хотя бы один день"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else
    {
        [[TVDataSingelton sharedTVDataInstance] setDownloadDays:selectedDays];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame] ;
    UIView *myView = [[UIView alloc] initWithFrame:frame];
    self.view = myView;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(15, 8, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //all days
    days = [[NSMutableArray alloc] initWithObjects: @"Понедельник", @"Вторник", @"Среда", @"Четверг", @"Пятница", @"Суббота", @"Воскресенье", nil];
    //selectedDays = [[NSMutableArray alloc] initWithObjects: @"Понедельник", nil];
    
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                               style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = [SZUtils color02];
    
    [mytableView reloadData];
    mytableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    [self.view addSubview:mytableView];   
    self.tableView = mytableView;
    
    selectedDays = [[[TVDataSingelton sharedTVDataInstance] getDownloadDates] mutableCopy];
}

- (void)dealloc
{
    [days removeAllObjects];
    [selectedDays removeAllObjects];
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
    return [days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSString * day = [days objectAtIndex:indexPath.row];
    cell.textLabel.text = day;
    if ([ selectedDays containsObject:day]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * day = [days objectAtIndex:indexPath.row];
    BOOL isSelected = [selectedDays containsObject:day];
	
    UITableViewCellAccessoryType accessoryType;
    if (isSelected == YES) {
        accessoryType = UITableViewCellAccessoryNone;
        [selectedDays removeObject:day];
    }
    else
    {
        accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedDays addObject:day];
    }
    
    // Set the checkmark accessory for the selected row.
    [[mytableView cellForRowAtIndexPath:indexPath] setAccessoryType:accessoryType];    
    
    // Deselect the row.
    [mytableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
