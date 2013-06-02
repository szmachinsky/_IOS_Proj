//
//  NavigationController.m
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NavigationController.h"
#import "DetailsViewController.h"
#import "DataSource.h"
#import "Task.h"
//#import "EditViewController.h"

@implementation NavigationController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init:(UITableViewStyle)style
{
//    self = [super initWithStyle:style];
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)dealloc
{   
//  [cells dealloc];
    [taskDat dealloc];
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
//    [[self tabBarItem] setTitle:@"title"];

    [super viewDidLoad];
    self.title = @"Task Manager";
/*    
    cellDat = [[DataSource alloc] initWithGeneratedData:3];
    [cellDat loadTaskListFromFile:[cellDat nameOfFile]]; //load task list from file 
*/    
    taskDat = [[DataSource alloc] initFromFile];
//  [taskDat setDateStatus];
    
//  [self setTableView:[[UITableView alloc] initWithFrame:[[self view]frame] style:UITableViewStyleGrouped]];
    
//  [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]]; //set Edit button
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
    modeView=mList;
    
    self.tableView.allowsSelectionDuringEditing=YES;
    //self.tableView.allowsSelection=NO;
    

    //self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLineEtched;
    //self.tableView.style=UITableViewStyleGrouped;
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

- (void)viewWillAppear:(BOOL)animated //zs
{
    NSLog(@"--will Main Appear--");
    [super viewWillAppear:animated];
    [[self tableView] reloadData]; //zs
    
    if ([taskDat count]) {
        self.title = @"Task manager";       
    } else {
        self.title = @"No tasks";
    }
    
    
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
//===============================================================================================
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *ss=nil;
    int rows=[taskDat numberOfRowsinSection:section Mode:modeView];
    if (rows==0) return ss;
    switch (modeView) {
        case mList:
            ss=@"Not completed tasks";
            break;
        case mDate:
            switch (section) {
                case 0:
                    ss=@"Overdue";
                    break;
                case 1:
                    ss=@"Today";
                    break;
                case 2:
                    ss=@"Tomorrow";
                    break;
                case 3:
                    ss=@"This Week";
                    break;
                case 4:
                    ss=@"Later";
                    break;
                default:
                    break;
            }
            break;
        case mDone:
            ss=@"Completed tasks";
            break;            
        default:
            ss=@"";
            break;
    }
    return ss;
    
}

-(NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView {
//  NSArray *res = [[[NSArray alloc] initWithObjects:@"Ov",@"To",@"Tm",@"Th",@"Lt",nil] autorelease];
    NSArray *res;
    if (modeView == mDate) {
        res = [NSArray arrayWithObjects:@"Over",@"Today",@"Tomorr",@"Week",@"Later", nil];
    } else {
        res = [NSArray array];
    }
    
    return res;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
   // Return the number of sections. 
    int sec=[taskDat numberOfSectionsinMode:modeView];
    return sec;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    int rows=[taskDat numberOfRowsinSection:section Mode:modeView];
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //Task *task = [taskDat taskByIndex:indexPath];
    Task *task = [taskDat taskForMode:modeView Index:indexPath];    
    if (task==nil) {        
        cell.textLabel.text=@"...";
    } else { 
        cell.textLabel.text=task.taskName;
    };
    cell.textLabel.textColor=[UIColor blackColor];
    if (task.taskStatus == Overdue)
        cell.textLabel.textColor=[UIColor redColor];
    if (task.taskStatus == Today)
        cell.textLabel.textColor=[UIColor greenColor];
    if (task.taskCompleted)
        cell.textLabel.textColor=[UIColor grayColor];
    NSMutableString *ss = [NSMutableString stringWithFormat:@""];//task.taskComment,
                       //  [taskDat stringDueDate:task.dateDueTo FormStyle:NSDateFormatterMediumStyle], 
                       //  task.dueDescription];
    
//   if (modeView != mDate) {
        [ss appendString:[NSString stringWithFormat:@" %@",task.dueDescription]];            
//  }
    if ([task.taskComment length])
        [ss appendString:[NSString stringWithFormat:@" :%@",task.taskComment]];        
    if (task.taskCompleted)
        [ss appendString:@" - Completed"];
    //cell.detailTextLabel.numberOfLines=2;
    //cell.detailTextLabel.font.
    cell.detailTextLabel.text=ss;
    //cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    
    UIImage *im= [UIImage imageNamed:@"28-star.png"];
    if (task.taskCompleted)
        cell.imageView.image=im;
    
    return cell;
}

/*
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
//        int id=[indexPath row];
//        int sec=[indexPath section];
        Task *task = [taskDat taskForMode:modeView Index:indexPath];           
        [taskDat removeByIndex:task.index]; //zs
        
//      [tableView :[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [taskDat saveReloadtaskList];
        [[self tableView] reloadData]; //zs    

    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
//   DetailsViewController *detailViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
  
    if ([self isEditing]) {
        EditViewController *controller = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
        
        controller.delegate = self;
        controller.showBar = 1;
        
        Task *task = [taskDat taskForMode:modeView Index:indexPath];           
        controller.taskInd=task.index;

        controller.taskID=indexPath;
        controller.taskDat=taskDat;
        
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        [[controller navigationItem] setTitle:@"Edit-task"];
        
        [controller release]; 
    } else {
  //    return;
        [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
  
}

/*
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellAccessoryDetailDisclosureButton;  
    
}
*/ 

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath 
{   NSLog(@"--Shevron pressed");
    //UITableViewCellAccessoryType t = [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        
    DetailsViewController *detailViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];

    Task *task = [taskDat taskForMode:modeView Index:indexPath];           
    detailViewController.taskInd=task.index;
    
    detailViewController.taskID=indexPath;
    detailViewController.taskDat=taskDat;
  //  UIBarButtonItem *someButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:detailViewController action:<#(SEL)#>
    //detailViewController.navigationItem setRightBarButtonItem:<#(UIBarButtonItem *)#> animated:////<#(BOOL)#>
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
        
}


//=======================================================================================
- (void)flipsideViewControllerDidFinish:(EditViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showEdit
{    
    EditViewController *controller = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    
    controller.delegate = self;
    controller.showBar = 1;
    
    controller.taskInd=-1;
    controller.taskID=nil;
    controller.taskDat=taskDat;

    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    [[controller navigationItem] setTitle:@"Add task"];
    
    [controller release];
}

//=======================================================================================



//=======================================================================================

- (IBAction)rightButtonPressed:(id)sender {
//    NSLog(@"--pressed");
    [self showEdit];
/*    
    [cellDat saveTaskListToFile:@"TaskList1.plist"];
    [cellDat loadTaskListFromFile:@"TaskList1.plist"];   
    [[self tableView] reloadData]; //zs
*/
}

- (IBAction)selectorButtonPressed:(id)sender {
    int res = [(UISegmentedControl*)sender  selectedSegmentIndex];
//    NSString*str = [(UISegmentedControl*)sender titleForSegmentAtIndex:res];
//    NSLog(@"Npress=%@=%d",str,res);
    modeView=res;
    if (res==3) {
//      [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]]; //set Edit button
    } else {
//      [[self navigationItem] setLeftBarButtonItem:nil]; //delete Edit button        
    }

   [[self tableView] reloadData]; //zs    
}


@end
