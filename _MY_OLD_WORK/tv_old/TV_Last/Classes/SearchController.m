//
//  SearchController.m
//  TVProgram
//
//  Created by Irisha on 22.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchController.h"

#import "ProgrammByChannelController.h"
#import "ProgrammDataViewController.h"
#import "CommonFunctions.h"

//#import "ShowDescriptionCell.h"
#import "ShowDescriptionWithNameCell.h"

//#import "Channel.h"
//#import "Show.h"
#import "TVDataSingelton.h"

#import "MTVShow.h"
#import "MTVChannel.h"

#import "WaitView.h"
//#import "UserTool.h"
#import "SSVProgressHUD.h"


@implementation SearchController
{
    UIAlertView *progressAlert_;        
    WaitView *waitView_;  //zs 
}
@synthesize waitView = waitView_;

@synthesize context = context_;
@synthesize tabData = tabData_;

//-------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
//        tabData_ = [[NSArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    self.context = nil;
}


//--------------------------setChannelNames----------------------------------------------------
//-(void) setChannelNames
//{
//    [listOfItems removeAllObjects]; //zs
//    if (isForFavor == TRUE) {
//        listOfItems = [NSMutableArray arrayWithArray:[[TVDataSingelton sharedTVDataInstance] getFavChannelsName]];
//    }
//    else
//    {
//        listOfItems = [NSMutableArray arrayWithArray:[[TVDataSingelton sharedTVDataInstance] getSelectedChannelsName]];
//    }
//    [self.tableView reloadData];
//}

-(void) setChannelNames
{
    [listOfItems removeAllObjects]; //zs
    [listOfInfo removeAllObjects];
    [copyListOfItems removeAllObjects];
    [copyListOfInfo removeAllObjects];
    [copyIndexes removeAllObjects]; //zs
    if (isForFavor == TRUE) {
        //        listOfItems = [NSMutableArray arrayWithArray:[[TVDataSingelton sharedTVDataInstance] getFavChannelsName]];
    }
    else
    {        
        self.context = [[[SZAppInfo shared] coreManager] createContext];
        self.tabData = [SZCoreManager arrayOfSelectedChannels:self.context];
        for (MTVChannel *chn in self.tabData) {
            NSString *name = chn.pName;
            [listOfItems addObject:name];
            [listOfInfo addObject:[NSNull null]];
        }        
    }
    [self.tableView reloadData];
}



//--------------------------requestForEntity---------------------------------------------------
- (NSArray*)requestForEntity_2:(NSString*)entity Context:(NSManagedObjectContext*)_context 
                       dateMin:(NSDate*)minD dateMax:(NSDate*)maxD;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:_context];
    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES]; 
    NSSortDescriptor *sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];      
    NSSortDescriptor *sortDesc3 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortDesc1,sortDesc2,sortDesc3,nil]];
    
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K >= %@)&&(%K < %@)", 
            @"rTVChannel.pSelected", @"pStart",minD, @"pStart",maxD];
    [request setPredicate:pred];     
    
    NSError *err=nil;
    NSArray *res = [_context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
    //    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:res];
    _NSLog(@" request for entity:(%@) =%d",entity,[res count]);    
//    NSArray* res2 = [res sortedArrayUsingComparator: ^(id obj1, id obj2) { 
//        NSDate *d1 = ((MTVShow*)obj1).pStart;
//        NSDate *d2 = ((MTVShow*)obj2).pStart;
//        return [d1 compare:d2];
//    }];    
    //    _NSLog(@" request for entity:(%@) =%d",entity,[res2 count]);    
    return res;
}


-(void) setPrograms
{
    [listOfItems removeAllObjects];
    [listOfInfo removeAllObjects];
    [copyListOfItems removeAllObjects];
    [copyListOfInfo removeAllObjects];
    [copyIndexes removeAllObjects]; //zs
    if (isForFavor == TRUE)
    {
    }
    else
    {
        NSDate *dat0 = [[ModelHelper shared] dateBeginDaysFromNow:0];
        NSDate *dat2 = [[ModelHelper shared] dateBeginDaysFromNow:1];
        
//      self.tabData = [self requestForData:currDate_]; 
        self.tabData = [self requestForEntity_2:@"MTVShow" Context:self.context dateMin:dat0 dateMax:dat2]; 
        for (MTVShow *show in self.tabData) {
            NSString *name = show.pTitle;
            [listOfItems addObject:name];
            NSString *time = [NSString stringWithFormat:@"%.2d:%.2d", [[ModelHelper shared] hourFromDate:show.pStart], 
                                     [[ModelHelper shared] minFromDate:show.pStart]];
            NSString *info = [NSString stringWithFormat:@" %@  %@",show.rTVChannel.pName,time];
            [listOfInfo addObject:info];
        }
        
    }
    [waitView_ hideWaitScreen];
    [self.tableView reloadData];
}

//------------------------------------------------------------------------------



- (void)segmentAction:(id)sender
{
    if (searching) return;
    
	UIButton * btn = (UIButton *)sender;
    if ([[btn titleLabel].text isEqualToString:@"Канал"])
    {
        currentSelectType = channelNames;
        [self setChannelNames];
        [timeButton setSelected:NO];
        [channelButton setSelected:YES];
    }
    else
    {
        currentSelectType = programName;
        
        [waitView_ showWaitScreen]; //show wait 
        
//        [self setPrograms];
        [self performSelector:@selector(setPrograms) withObject:nil afterDelay:0];
        [timeButton setSelected:YES];
        [channelButton setSelected:NO];
    }
///zs    [self.tableView reloadData];
}

-(void)backClicked:(UIBarButtonItem *)back_of_view2
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadView
{
//    listOfItems = [[NSMutableArray alloc] init];
//    copyListOfItems = [[NSMutableArray alloc] init];
//    listOfInfo = [[NSMutableArray alloc] init];
//    copyListOfInfo = [[NSMutableArray alloc] init];

    UITableView *mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                               style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.backgroundColor = [SZUtils color02];
    //CGRect rect = [[UIScreen mainScreen] applicationFrame];
    //mytableView.frame = CGRectMake(0, 50, rect.size.width, rect.size.height - 50);
    
    [mytableView reloadData];
    self.tableView = mytableView;
    
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,35,320,44)];
    searchBar.delegate = self;
    searchBar.backgroundColor =  [SZUtils color08];
    searchBar.tintColor = [SZUtils color08];
//    [searchBar setShowsCancelButton:YES animated:YES];
    
    searching = NO;
    letUserSelectRow = YES;
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(15, 8, 58, 29);
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok.png"] forState:UIControlStateNormal];
//    [backButton setBackgroundImage:[UIImage imageNamed:@"ok_on.png"] forState:UIControlStateSelected];
//    [backButton addTarget:self action:@selector(backClicked:) forControlEvents:UIControlEventTouchUpInside]; 
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 192, 31)];
    channelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    channelButton.frame = CGRectMake(0, 0, 91, 31);
    [channelButton setBackgroundImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [channelButton setBackgroundImage:[UIImage imageNamed:@"left_on.png"] forState:UIControlStateSelected];
    [channelButton setTitle:@"Канал" forState:UIControlStateNormal];
    [channelButton addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [channelButton setSelected:YES];
    [myView addSubview:channelButton];
    timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(81, 0, 91, 31);
    [timeButton setBackgroundImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [timeButton setBackgroundImage:[UIImage imageNamed:@"right_on.png"] forState:UIControlStateSelected];
    [timeButton setTitle:@"Передача" forState:UIControlStateNormal];
    [timeButton addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:timeButton];
    [timeButton setSelected:NO];
    [channelButton setSelected:YES];
    self.navigationItem.titleView = myView;
}



-(void) setDate:(NSString *)day  forFavor:(BOOL)isFavor
{
    currentDay = [day copy];
    currentSelectType = channelNames;
    isForFavor = isFavor;
    [self setChannelNames];
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
    listOfItems = [[NSMutableArray alloc] init];
    copyListOfItems = [[NSMutableArray alloc] init];
    listOfInfo = [[NSMutableArray alloc] init];
    copyListOfInfo = [[NSMutableArray alloc] init];
    copyIndexes = [[NSMutableArray alloc] init]; //zs
    self.tabData = [[NSArray alloc] init];
    
//    waitView_ = [[WaitView alloc] initWithFrame:CGRectZero]; //zs
//    [self.view addSubview:waitView_];
    
    //----  add wait view to controller ---      
//    self.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; //zs
//    [self.view.superview addSubview:self.waitView];      
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    listOfItems = nil;
    copyListOfItems = nil;
    listOfInfo = nil;
    copyListOfInfo = nil; 
    copyIndexes = nil;
    self.tabData = nil;    
}

- (void)viewWillAppear:(BOOL)animated
{
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            UIView *bg = [[UIView alloc] initWithFrame:subview.frame];
            bg.backgroundColor =  [SZUtils color08];
            [searchBar insertSubview:bg aboveSubview:subview];
            [subview removeFromSuperview];
            break;
        }
    }   
    [super viewWillAppear:animated];
    
//----  add wait view to controller ---
    if (self.waitView == nil) {
        self.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; //zs
        [self.view.superview addSubview:self.waitView]; 
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [listOfItems removeAllObjects];
//    [listOfInfo removeAllObjects];
//    [copyListOfItems removeAllObjects];
//    [copyListOfInfo removeAllObjects]; 
//    self.tabData = nil;        
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

//==============================================================================
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searching) {
        if (copyListOfItems == nil) return 0;
        return [copyListOfItems count];
    }    else  {
        if (listOfItems == nil) return 0;
        return [listOfItems count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentSelectType == programName) 
    {   return 64; //48
    } else {
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentSelectType == programName) 
    {
        NSInteger ind = indexPath.row;
        if (searching) {
            if ([copyIndexes count] > ind) {
                NSNumber *num = [copyIndexes objectAtIndex:ind];
                ind = [num intValue];
            }
        }
        MTVShow *show = [self.tabData objectAtIndex:ind];
        MTVChannel *channel = show.rTVChannel;
//        NSString *name = chan.pName;
//        NSString *title = show.pTitle;
//        _NSLog(@"(%@) (%@)",name,title);
    
        static NSString *CellIdentifier = @"ShowDescriptionWithNameCell";
        [self.tableView registerNib:[UINib nibWithNibName:@"ShowDescriptionWithNameCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        ShowDescriptionWithNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
        
        cell.descriptionText.text = show.pTitle;
        
        NSData *imadeData = channel.pImage;
        UIImage *image = [UIImage imageWithData:imadeData];
        cell.channelImage.image = image;
        
        NSDate *showDate = show.pStart; 
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm  d MMMM',' EEEE"];
        NSString *timeStr = [formatter stringFromDate:showDate];
        NSString *time = [NSString stringWithFormat:@"%@",timeStr];
        cell.timeLabel.text = time;

        cell.channelNameLabel.text = channel.pName;
        
        if ([show descript] != nil) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    
    
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];        
    }
    // Configure the cell...
    if(searching)
    {
        if (copyListOfItems != nil) {
            cell.textLabel.text = [copyListOfItems objectAtIndex:indexPath.row];
            if ([copyListOfInfo objectAtIndex:indexPath.row] == [NSNull null]) {
                cell.detailTextLabel.text = nil;
            }   else {
                cell.detailTextLabel.text = [copyListOfInfo objectAtIndex:indexPath.row];
            }
            
        }
    }
    else {
        if (listOfItems != nil) {
            cell.textLabel.text = [listOfItems objectAtIndex:indexPath.row];
            if ([listOfInfo objectAtIndex:indexPath.row] == [NSNull null]) {
                cell.detailTextLabel.text = nil;
            }   else {
                cell.detailTextLabel.text = [listOfInfo objectAtIndex:indexPath.row];
            }
        }
    }
    
    return cell;
}



- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(letUserSelectRow)
        return indexPath;
    else
        return nil;
}

//------------------------------------------------------------------------------
#pragma mark - search methods

//- (void) doneSearching_Clicked:(id)sender 
//{    
//    searchBar.text = @"";
//    [searchBar resignFirstResponder];
//    
//    letUserSelectRow = YES;
//    searching = NO;
//    self.navigationItem.rightBarButtonItem = nil;
//    self.tableView.scrollEnabled = YES;
//    
//    [self.tableView reloadData];
//}


- (void)renameCancellButtonInBar:(UISearchBar *)theSearchBar newTitle:(NSString*)newTitle
{
    [theSearchBar setShowsCancelButton:YES animated:YES];
    for(UIView *view in [searchBar subviews]) 
    {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) 
        {
            NSString *title = ((UIBarItem*)view).title;
            if ([title isEqualToString:@"Cancel"])
                [(UIBarItem *)view setTitle:newTitle];
        }
    }       
}


- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{
    
//    searching = NO; //YES
//    if ([theSearchBar.text length] == 0) {
        letUserSelectRow = YES; //NO
//    }
    self.tableView.scrollEnabled = YES; //NO
    
    [searchBar setShowsCancelButton:YES animated:YES];
    [self renameCancellButtonInBar:theSearchBar newTitle:@"Готово"];
    
    for (UIView *searchBarSubview in [theSearchBar subviews]) {        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {            
            @try {                
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
                //             [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
            }
            @catch (NSException * e) {                
                // ignore exception
            }
        }
    }      
    
}


- (void)searchInTableView 
{    
    NSString *searchText = searchBar.text;
//zsfor (NSString *sTemp in listOfItems)
    for (int idd = 0; idd < [listOfItems count]; idd++) 
    {
        NSString *sTemp = [listOfItems objectAtIndex:idd];
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length != 0) {
            [copyListOfItems addObject:sTemp];
            [copyListOfInfo addObject:[listOfInfo objectAtIndex:idd]];
            [copyIndexes addObject:[NSNumber numberWithInt:idd]];
        }
    }
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText 
{    
//    NSLog(@"(|%@|)",searchText);
//    if (([searchText length] == 0)&&
//        ([theSearchBar.text length] > 0))
    
    //Remove all objects first
    [copyListOfItems removeAllObjects];
    [copyListOfInfo removeAllObjects];
    [copyIndexes removeAllObjects]; //zs    
    if([searchText length] != 0) {        
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchInTableView];
    }
    else {        
        searching = NO;
        letUserSelectRow = YES; //NO
        self.tableView.scrollEnabled = YES; //NO
    }    
    [self.tableView reloadData];
}



- (void)searchBarCancelButtonClicked:(UISearchBar *) searchB
{
    //    [self doneSearching_Clicked:searchB];
    //    searchB.showsCancelButton = NO;  
    if ([searchBar.text length] == 0) {
        [searchBar setShowsCancelButton:NO animated:YES];
        [searchBar resignFirstResponder];
        
        searchBar.text = @"";
        letUserSelectRow = YES;
        searching = NO;
        self.tableView.scrollEnabled = YES;        
        [self.tableView reloadData];                
    } else {
        [searchBar resignFirstResponder];        
        [searchBar setShowsCancelButton:NO animated:YES];
    }
}


-(void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
//    [self searchInTableView];
    [self searchBarCancelButtonClicked:theSearchBar];    
}

//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSLog(@"(_%@_)",text);
//    return YES;
//}

//------------------------------------------------------------------------------
#pragma mark - Table view delegate

- (void) channelIsSelected:(NSString *)channel
{  
    ProgrammByChannelController *channelController = [[ProgrammByChannelController alloc] init];
    [channelController setChannelName:channel initialDay:[[TVDataSingelton sharedTVDataInstance] getCurrentDate] isFavor:NO];
    
    //    channelController.modalTransitionStyle = kModTranStyle;
    //    //[self.view addSubview:channelController.view];
    //    channelController.titleForBackButton = @"Поиск";
    //    [self presentModalViewController:channelController animated:YES];
    
    channelController.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Канал" style:UIBarButtonItemStyleDone target:nil action:nil];
    backButton.tintColor = [SZUtils color08];
    self.navigationItem.backBarButtonItem = backButton;    
    [self.navigationController pushViewController:channelController animated:YES]; //zs    
    
    channelController = nil;
}

- (void) showIsSelected:(NSString *)showName index:(NSIndexPath *)indexPath
{
    if (self.tabData == nil)
        return;
    ProgrammDataViewController *channelController = [[ProgrammDataViewController alloc] init];
    
//    channelController.modalTransitionStyle = kModTranStyle;    
//    [self presentModalViewController:channelController animated:YES];
    
    channelController.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Передача" style:UIBarButtonItemStyleDone target:nil action:nil];
    backButton.tintColor = [SZUtils color08];
    self.navigationItem.backBarButtonItem = backButton;    
    [self.navigationController pushViewController:channelController animated:YES]; //zs
    
    
    
//    Show * show = [[TVDataSingelton sharedTVDataInstance] getShowByName:showName byDate:currentDay];
//zs    [channelController showProgramData:show channel:[show channelIconName] minutesBefore:[[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder] forChannelName:[show channelName]];
    NSInteger ind = indexPath.row;
    if (searching) {
        if ([copyIndexes count] > ind) {
            NSNumber *num = [copyIndexes objectAtIndex:ind];
            ind = [num intValue];
        }
    }
    MTVShow *show = [self.tabData objectAtIndex:ind];
    MTVChannel *chan = show.rTVChannel;
    NSString *name = chan.pName;
    [channelController showProgramDataMTV:show channel:chan 
                            minutesBefore:[[TVDataSingelton sharedTVDataInstance] getMinBeforeReminder] 
                           forChannelName:name];
    channelController = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (searching) {
        switch (currentSelectType) {
            case channelNames:
                [self channelIsSelected:[copyListOfItems objectAtIndex:indexPath.row]];
                break;
            case programName:
                [self showIsSelected:[copyListOfItems objectAtIndex:indexPath.row] index:indexPath];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (currentSelectType) {
            case channelNames:
                [self channelIsSelected:[listOfItems objectAtIndex:indexPath.row]];
                break;
            case programName:
                [self showIsSelected:[listOfItems objectAtIndex:indexPath.row] index:indexPath];
                break;
            default:
                break;
        }
    }
}

@end
