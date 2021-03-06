//
//  URLRssTableViewController.m
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLRssTableViewController.h"
#import "RSSTableViewController.h"



@implementation URLRssTableViewController
@synthesize linkToScan;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [linkToScan release];
    
    [super dealloc];
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
    
    self.title=@"Rss list";
    
    //add nav bar button 
    UIBarButtonItem *bbi = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                                        action:@selector(addUrl:)] autorelease]; 
    [[self navigationItem] setRightBarButtonItem:bbi];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    linkToScan=nil;
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"URLRSSCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //  cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;    
    
    cell.textLabel.text=@"http://tut.by";
    cell.detailTextLabel.text=@"http://news.tut.by/rss/index.rss";
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     RSSTableViewController *detailViewController = [[RSSTableViewController alloc] initWithNibName:@"RSSTableViewController" bundle:nil];
     // ...
     detailViewController.rssFeedLink=@"http://news.tut.by/rss/index.rss";
     detailViewController.rssFeedName=@"Feed Name";
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     
}


//=======================================================================================
- (void)flipsideViewControllerDidFinish:(EditUrlViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void) method{
    sleep(5);
    NSLog(@"--link was set=(%@)",linkToScan);
}
- (void)linkWasChanged:(EditUrlViewController *)controller Link:(NSString*)link 
{
    [self dismissModalViewControllerAnimated:YES];
    //sleep(5);
    NSLog(@"--link was set=(%@)",link);
    self.linkToScan=link;
//    [self method];
}

- (IBAction)showEdit
{    
    EditUrlViewController *controller = [[EditUrlViewController alloc] initWithNibName:@"EditUrlViewController" bundle:nil];
    
    controller.delegate = self;
/*    
    controller.showBar = 1;    
    controller.taskInd=-1;
    controller.taskID=nil;
    controller.taskDat=taskDat;
*/    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    [[controller navigationItem] setTitle:@"Add Url"];
    
    [controller release];
}

//=======================================================================================


-(void) addUrl:(id) object 
{
    NSLog(@"button");
    [self showEdit];
    return;
    
    EditUrlViewController *detailViewController = [[EditUrlViewController alloc] initWithNibName:@"EditUrlViewController" bundle:nil];
    // ...
//    detailViewController.rssFeedLink=@"http://news.tut.by/rss/index.rss";
//    detailViewController.rssFeedName=@"Feed Name";
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

@end
