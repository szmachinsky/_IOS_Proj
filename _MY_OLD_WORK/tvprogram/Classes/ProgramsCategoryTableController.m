//
//  ProgramsCategoryTableController.m
//  TVProgram
//
//  Created by User1 on 26.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgramsCategoryTableController.h"
#import "ProgramByCategoryCell.h"
#import "CommonFunctions.h"

#import "ShowDescriptionWithNameCell.h"

#import "TVDataSingelton.h"
//#import "Show.h"

#import "MTVShow.h"
#import "MTVChannel.h"

#import "WaitView.h"
//#import "UserTool.h"
#import "SSVProgressHUD.h"


//#define HEADER_HEIGHT 90
#define HEADER_HEIGHT 45
#define FOOTER_HEIGHT 50


@implementation ProgramsCategoryTableController
{
//    UIAlertView *progressAlert_;        
    WaitView *waitView_;  //zs 
    __block BOOL isCalc_;
}
@synthesize waitView = waitView_;

@synthesize selectionDelegate;
@synthesize currentDate = currentDate_;

@synthesize context = context_;
//@synthesize selArrays = selArrays_;
@synthesize tabData = tabData_;
@synthesize catID = catID_;
@synthesize searching;


- (id)init
{
    self = [super init];
    if (self) {
        sortByChannel_ = YES;
        catID_ = 0;
    }
    return self;
}

-(void)dealloc
{
    self.context = nil; //alw
    self.tabData = nil;
}

//-------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.context = [[[SZAppInfo shared] coreManager] createContext]; //alw
    if (self.waitView == nil) {
        self.waitView = [[WaitView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; //zs
        [self.view.superview addSubview:self.waitView];                
    }    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; //nalw
//    self.context = nil; //alw
//    self.tabData = nil;
}
//==============================================================================
- (NSArray*)requestForData:(NSDate*)minD dateMax:(NSDate*)maxD;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:self.context];
    
    if (sortByChannel_) {   //channel name - first!
        NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];    
        NSSortDescriptor *sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];    
        NSSortDescriptor *sortDesc3 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObjects:sortDesc1,sortDesc2,sortDesc3,nil]];
    } else {                //date - first!
        NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];
        NSSortDescriptor *sortDesc2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];    
        NSSortDescriptor *sortDesc3 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];    
        [request setSortDescriptors:[NSArray arrayWithObjects:sortDesc1,sortDesc2,sortDesc3,nil]];        
    }
    
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K == %d)&&(%K >= %@)&&(%K < %@)", 
            @"rTVChannel.pSelected",  @"pCategory", catID_,  @"pStart",minD, @"pStart",maxD];
    [request setPredicate:pred];     
    
    NSError *err=nil;
    NSArray *res = [self.context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
    return res;
}


//==============================================================================

-(void)showProgress
{
    if (isCalc_) {
        //        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeNone];
//      [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [waitView_ showWaitScreen];
    }
}



- (void)reallyReloadTable
{
    self.context = [[[SZAppInfo shared] coreManager] createContext];
    
    NSDate *dat1 = [[ModelHelper shared] dateFromDay:currentDate_];
    NSDate *dat2 = [dat1 dateByAddingTimeInterval:24*60*60];
//    _NSLog(@"%@ %@ %@",currentDate_,dat1,dat2),
 
    [self performSelector:@selector(showProgress) withObject:nil afterDelay:1.0];    
    isCalc_ = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{     
        self.tabData = [self requestForData:dat1 dateMax:dat2]; 
        listOfItems = self.tabData;
//        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{ 
            isCalc_ = NO;
            [self.tableView reloadData];               
            [SSVProgressHUD dismiss];
            [waitView_ hideWaitScreen];
        }); 
    });         
    
//    isCalc_ = NO;    
//    [waitView_ hideWaitScreen];        
//    [self.tableView reloadData];
}

- (void)reloadTable 
{
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reallyReloadTable) object:nil];
    [self performSelector:@selector(reallyReloadTable) withObject:nil afterDelay:0.05]; 
//    [waitView_ showWaitScreen];
}

//-------------------------------------------------------------------
- (void)loadView
{
    copyListOfItems = [[NSMutableArray alloc] init];
    listOfItems = [[NSArray alloc] init];
//  programs = [[NSMutableArray alloc] init];
    
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                               style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mytableView.separatorColor = [UIColor grayColor];
    
//    [mytableView reloadData];
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    mytableView.frame = CGRectMake(0, HEADER_HEIGHT, rect.size.width, rect.size.height - HEADER_HEIGHT - FOOTER_HEIGHT);
///    mytableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height - FOOTER_HEIGHT);
	
	
    self.view = mytableView;
    self.view.backgroundColor = [SZUtils color02];
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,35,320,44)];
    searchBar.delegate = self;
    searchBar.tintColor =  [SZUtils color08];
    searching = NO;
    letUserSelectRow = YES;
///    searchBar.showsCancelButton = YES;
//    mytableView.tableHeaderView = searchBar;
    self.tableView.tableHeaderView = searchBar;

//    waitView_ = [[WaitView alloc] initWithFrame:rect]; //zs
//    [self.view addSubview:waitView_];            
//    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    waitView_ = [[WaitView alloc] initWithFrame:CGRectZero]; //zs
//    [self.view addSubview:waitView_];            
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) sortChannelsByChannel:(BOOL)isByChannel
{
//    if (isByChannel) {
//        [listOfItems sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"channelName" ascending:YES]]];
//    }
//    else {
//        [listOfItems sortUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"startHour" ascending:YES], 
//                                           [NSSortDescriptor sortDescriptorWithKey:@"startMin" ascending:YES] , nil]];
//    }
    
    sortByChannel_ =  isByChannel; 
/// [mytableView reloadData];
    [self reloadTable]; //zs
}


//------------------------------------------------------------------------------
-(void)setData:(NSMutableArray *)data
{
//    programs = [[NSMutableArray alloc] initWithArray:data];
//    listOfItems = [NSMutableArray arrayWithArray:programs];
    
    [self sortChannelsByChannel:YES];
///    [mytableView reloadData];
//    [self reloadTable]; //zs   
}

-(void)update
{
    [self sortChannelsByChannel:YES];    
//    [self reloadTable]; //zs       
}

//------------------------------------------------------------------------------
#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (searching) {
        if (copyListOfItems == nil)
            return 0;
        return [copyListOfItems count];
    } else {
        if (listOfItems == nil)
            return 0;
        return [listOfItems count];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64; //80
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    MTVShow *show;
    if (searching) {
        show = [copyListOfItems objectAtIndex:indexPath.row]; 
    } else {
        show = [listOfItems objectAtIndex:indexPath.row];        
    }
    MTVChannel *channel = show.rTVChannel;
    
    static NSString *CellIdentifier = @"ShowDescriptionWithNameCell";
    [self.tableView registerNib:[UINib nibWithNibName:@"ShowDescriptionWithNameCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    ShowDescriptionWithNameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //no selected!
    
    cell.descriptionText.text = show.pTitle;
    
    NSData *imadeData = channel.pImage;
    UIImage *image = [UIImage imageWithData:imadeData];
    cell.channelImage.image = image;
    
    NSDate *showDate = show.pStart; 
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm  d MMMM',' EEEE"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [formatter setLocale:usLocale];
    NSString *timeStr = [formatter stringFromDate:showDate];
    NSString *time = [NSString stringWithFormat:@"%@",timeStr];
    cell.timeLabel.text = time;
    
    cell.channelNameLabel.text = channel.pName;

    if ([show descript] != nil) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    
/*    
    
   static NSString *CellIdentifier = @"Cell";    
    ProgramByCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProgramByCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.primaryLabel.text = show.pTitle;
    NSDate *dat = show.pStart;
    NSString *day = [[ModelHelper shared] dayFromDate:dat];
    cell.secondaryLabel.text = [NSString stringWithFormat:@"%@  %.2d:%.2d", convertDateToUserView2(day), [[ModelHelper shared] hourFromDate:show.pStart], 
                              [[ModelHelper shared] minFromDate:show.pStart] ];        
    cell.thirdLabel.text = channel.pName;    
    UIImage *im = nil;;
    if (channel.pImage != nil)
        im = [UIImage imageWithData:(NSData*)channel.pImage];
    [cell setIconImage:im];
    
    if ([show descript] != nil) {
        cell.forthLabel.text = @">";        
        cell.forthLabel.textColor = [UIColor brownColor];
        cell.forthLabel.hidden = NO;
    } else {
        cell.forthLabel.hidden = YES;  
    }
    
    
    return cell;
*/ 
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (letUserSelectRow) 
    {
//        Show *show = searching ? [copyListOfItems objectAtIndex:indexPath.row] : [listOfItems objectAtIndex:indexPath.row];
//        [self.selectionDelegate programIsSelected:show];        
        
        MTVShow *show;
        if (searching) {
            if (copyListOfItems == nil) return;
            show = [copyListOfItems objectAtIndex:indexPath.row];              
        } else {
            if (listOfItems == nil) return;
            show = [listOfItems objectAtIndex:indexPath.row];        
        }
        
//        _NSLog(@"(%@)",show);    
//        _NSLog(@"%@  %@  %@",show.pTitle,[show name],show.pStart);
        if ([self.selectionDelegate respondsToSelector:@selector(programIsSelectedMTV:)])
            [self.selectionDelegate programIsSelectedMTV:show];        
    }
}

//------------------------------------------------------------------------------
#pragma mark - Search Bar delegate
//- (void)setCancelButtonDisabled:(BOOL)isDisabled {
//    for (UIView *possibleButton in searchBar.subviews) {
//        if ([possibleButton isKindOfClass:[UIButton class]]) {
//            UIButton *cancelButton = (UIButton*)possibleButton;
//            cancelButton.enabled = !isDisabled;
//            break;
//        }
//    }
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

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar 
{
    searching = YES;
    copyListOfItems = [NSMutableArray arrayWithArray:listOfItems];
    letUserSelectRow = YES;
    
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
    [copyListOfItems removeAllObjects];
    if (searchText.length > 0) {
        for (MTVShow *show in listOfItems) {
            NSString *name = show.pTitle;
            NSRange searchResultsRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (searchResultsRange.length > 0) {
                [copyListOfItems addObject:show];
            }
        }
    }
    else {
        copyListOfItems = [NSMutableArray arrayWithArray:listOfItems];
    }    
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText 
{
    //    CGRect tableFrame = mytableView.frame;
    //    tableFrame.size.height = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]) - HEADER_HEIGHT - 216.0f;
    //    mytableView.frame = tableFrame;
    
//    [self searchInTableView];        
//    [mytableView reloadData];   
//    letUserSelectRow = YES;
     
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


- (void)searchBarCancelButtonClicked:(UISearchBar *)bar
{
    //    CGRect tableFrame = mytableView.frame;
    //    tableFrame.size.height = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]) - HEADER_HEIGHT - FOOTER_HEIGHT;
    //    mytableView.frame = tableFrame;
    
//    [searchBar resignFirstResponder];        
//    searching = NO;
//    searchBar.text = @"";
//    [self reloadTable]; //zs       
//    letUserSelectRow = YES;
    
    if ([searchBar.text length] == 0) {
        [searchBar setShowsCancelButton:NO animated:YES];
        [searchBar resignFirstResponder];
        
        searchBar.text = @"";
        letUserSelectRow = YES;
        searching = NO;
        self.tableView.scrollEnabled = YES;        
        [self.tableView reloadData];
//        [self reloadData];
    } else {
        [searchBar resignFirstResponder];        
        [searchBar setShowsCancelButton:NO animated:YES];
    }
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar 
{
    //    [sBar resignFirstResponder];
    //    CGRect tableFrame = mytableView.frame;
    //    tableFrame.size.height = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]) - HEADER_HEIGHT - FOOTER_HEIGHT;
    //    mytableView.frame = tableFrame;
    //    letUserSelectRow = YES;
    ////    [self setCancelButtonDisabled:NO];
    
//    [self searchInTableView]; 
    
    [self searchBarCancelButtonClicked:sBar];
}




@end
