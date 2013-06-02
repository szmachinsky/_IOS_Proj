//
//  ChannelsSortConfigController.m
//  TVProgram
//
//  Created by User1 on 20.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SZChannelsSortConfigController.h"
//#import "TVDataSingelton.h"
//#import "Channel.h"

#import "SZCoreManager.h"
#import "MTVChannel.h"

@interface SZChannelsSortConfigController ()
@end


@implementation SZChannelsSortConfigController
{
    NSMutableArray *selChannels_; 
    NSArray *channels_;
}
@synthesize managedObjectContext = managedObjectContext;


- (NSArray*)arrayOfSelectedChannels 
{
//   NSInteger sc=0;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"pName" ascending:YES];
     [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,nil]];        
    NSError *error;    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"%K == YES", @"pSelected"];
    //  NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"]; //is always TRUE
    [fetchRequest setPredicate:pred1];     
    NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    for (MTVChannel *managedObject in items) {
//        sc++;
//         _NSLog(@" selected objects_%d id=%d name=%@ order=%f",sc,managedObject.pID,managedObject.pName,managedObject.pOrderValue); 
//    }    
    return items;
}


- (void)enumerateChannels
{
    float num = 1.0;
    for (MTVChannel *chn in selChannels_) {
        chn.pOrderValue = num + 100000.0;
        num+=1.0;
    }
}

-(void)pressOK:(id)sender
{
//    [mytableView reloadData];
    [self enumerateChannels];
    
    [SZCoreManager saveForContext:self.managedObjectContext]; //save selected array!!!
    
//    NSArray *arr = [SZCoreManager arrayOfSelectedChannels:self.managedObjectContext];  //[self arrayOfSelectedChannels]; 
//    [SZAppInfo shared].selChannels = arr; //set Global Selected Channels
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self enumerateChannels];
    
    [SZCoreManager saveForContext:self.managedObjectContext]; //save selected array!!!
    
    //    NSArray *arr = [SZCoreManager arrayOfSelectedChannels:self.managedObjectContext];  //[self arrayOfSelectedChannels]; 
    //    [SZAppInfo shared].selChannels = arr; //set Global Selected Channels
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



//-------------------------------- init ------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = [[[SZAppInfo shared] coreManager] createContext];
        channels_=[self arrayOfSelectedChannels];
        selChannels_ = [[NSMutableArray alloc] initWithArray:channels_];
    }
    return self;
}

- (void) dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.managedObjectContext = nil;
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
//    [backButton addTarget:self action:@selector(pressOK:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                               style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.editing = YES; //edit mode!!!
    mytableView.backgroundColor = [SZUtils color02];
    
    [mytableView reloadData];
    mytableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    [self.view addSubview:mytableView];
    self.tableView = mytableView;
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

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//}

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
//--------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return [[TVDataSingelton sharedTVDataInstance] getNumberOfSelectedChannels];
    if (selChannels_) {
        return [selChannels_ count];
    } else {
        return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//-----------------------------------cellForRow------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //no selected!
    }
    
    // Configure the cell...
    MTVChannel *chn = [selChannels_ objectAtIndex:indexPath.row];
    cell.textLabel.text = chn.pName;
    
    if (chn.pImage != nil) 
    {        
        UIImage *im = [UIImage imageWithData:(NSData*)chn.pImage];
        UIImage *i = [SZUtils thumbnailFromImage:im forSize:37 Radius:7.0];
        cell.imageView.image = i;
        if (chn.pFavorite) {
            cell.imageView.alpha = 1.0; 
//            cell.imageView.backgroundColor = [UIColor greenColor];
        } else {
            cell.imageView.alpha = 1.0;
//            cell.imageView.backgroundColor = [UIColor clearColor];
        }
        
    } else {
        cell.imageView.image = nil;
    }
//    CGRect fr = cell.imageView.frame;
//    fr.origin.x -=10;
//    cell.imageView.frame.origin.x=10;
    
//    if (chn.pOrderValue == 0)
//    chn.pOrderValue = indexPath.row + 1.0 + 100000.0;
    
    return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{ 
//    NSString * chName = [[TVDataSingelton sharedTVDataInstance] getSelectedChanelNameByIndex:fromIndexPath.row];
//    Channel *ch = [[TVDataSingelton sharedTVDataInstance] getChannel:chName];
//    [[TVDataSingelton sharedTVDataInstance] removeChannelFromSelected:chName];
//    [[TVDataSingelton sharedTVDataInstance] insertChannelToSelected:ch atIndex:toIndexPath.row];
//    [[TVDataSingelton sharedTVDataInstance] changeChannelOrder:fromIndexPath.row toIndexPath:toIndexPath.row];
    MTVChannel *ch = [selChannels_ objectAtIndex:fromIndexPath.row];
    [selChannels_ removeObjectAtIndex:fromIndexPath.row];
    [selChannels_ insertObject:ch atIndex:toIndexPath.row];
    [mytableView reloadData];
                        
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------


@end
