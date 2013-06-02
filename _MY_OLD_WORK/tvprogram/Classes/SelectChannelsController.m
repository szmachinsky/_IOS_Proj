//
//  SelectChannelsController.m
//  TVProgram
//
//  Created by User1 on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectChannelsController.h"
//#import "TVDataSingelton.h"
//#import "Channel.h"

#import "MTVChannel.h"

@implementation SelectChannelsController
@synthesize context = context_;
@synthesize tabData = tabData_;


- (id)init
{
    self = [super init];
    if (self) {
        tabData_ = [[NSArray alloc] init];
    }
    return self;
}


- (void)dealloc
{
    self.context = nil;
}



-(void)close:(id)sender
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChannelsViewSwitcherooNotification" object:self];
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
//    self.context = nil;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateChannelsViewSwitcherooNotification" object:self];
}



- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame] ;
    UIView *myView = [[UIView alloc] initWithFrame:frame];
    self.view = myView;
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];    
//    backButton.frame = CGRectMake(0, 0, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
   
    
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                               style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = [SZUtils color02];
    
///zs    [mytableView reloadData];
    mytableView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self.view addSubview:mytableView];
}


//-------------------------------------------------------------------
- (void)reallyReloadTable 
{
//    self.context = [[[SZAppInfo shared] coreManager] createContext];
//    [self requestForData1:currDate_];  
    self.tabData = [SZCoreManager arrayOfSelectedChannels:self.context];
    [mytableView reloadData];    
}

- (void)reloadTable {
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reallyReloadTable) object:nil];
    [self performSelector:@selector(reallyReloadTable) withObject:nil afterDelay:0.05];    
}

//-------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.context = [[[SZAppInfo shared] coreManager] createContext];
    [self reloadTable];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.context = nil;
//}
//-------------------------------------------------------------------


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
//    return [[TVDataSingelton sharedTVDataInstance] getNumberOfSelectedChannels];
    if (tabData_ == nil)
        return 0;    
    NSInteger res = [tabData_ count];
    return res;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
//    NSMutableArray *selectedChannels = [[TVDataSingelton sharedTVDataInstance] getSelectedChannelsName];    
//    NSString *channelName = [selectedChannels objectAtIndex:indexPath.row];    
//    cell.textLabel.text = channelName;
    MTVChannel *channel = [self.tabData objectAtIndex:indexPath.row]; 
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 10;
    cell.textLabel.text = channel.pName;
        
    BOOL isSelected = channel.pFavorite; ///[[TVDataSingelton sharedTVDataInstance] isChannelFavor:channelName];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check_g.png"]];
    
    cell.accessoryView = isSelected ? imageView : nil;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *selectedChannels = [[TVDataSingelton sharedTVDataInstance] getSelectedChannelsName];
//    NSString *channelName = [selectedChannels objectAtIndex:indexPath.row];
//    BOOL isFav = [[TVDataSingelton sharedTVDataInstance] isChannelFavor:channelName];    
//    if (isFav) {
//        [[TVDataSingelton sharedTVDataInstance] removeChannelFromFavor:channelName];
//    }
//    else {
//        [[TVDataSingelton sharedTVDataInstance] addChannelToFavor:channelName];
//    }
    
    MTVChannel *channel = [self.tabData objectAtIndex:indexPath.row];     
    channel.pFavorite = !channel.pFavorite;
    [SZCoreManager saveForContext:self.context];    
    
    [self reloadTable];
}

@end
