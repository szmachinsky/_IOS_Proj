//
//  ProgrammTableViewController.m
//  TVProgram
//
//  Created by User1 on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SZProgrammTableViewController.h"
#import "ProgrammCell.h"
#import "CommonFunctions.h"

#import "TVDataSingelton.h"
//#import "Channel.h"
//#import "Show.h"

#import "MTVShow.h"
#import "SSVProgressHUD.h"

///#define HEADER_HEIGHT 90
#define HEADER_HEIGHT 44

//#define debug(...)   _NSLog(__VA_ARGS__)

//#define _DEBUG_MSG

#ifdef _DEBUG_MSG   
#define _DebMsg(...)  _NSLog(__VA_ARGS__)
#else
#define _DebMsg(...)  
#endif




@interface SZProgrammTableViewController ()
- (void)runTimer; 
- (void)stopTimer;
@end


@implementation SZProgrammTableViewController
@synthesize delegate;

//@synthesize selArrays = selArrays_;
@synthesize tabData = tabData_;
@synthesize context = context_;
@synthesize channelName = channelName_;


//-------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        self.context = [[[SZAppInfo shared] coreManager] createContext];
        tabData_ = [[NSArray alloc] init];
        self.channelName = @""; 
        currentProgramIndex = 0;
        [self runTimer];
        _NSLog(@" ++ init");
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
    self.context = nil;
    self.tabData = nil;
    _NSLog(@" ++ dealloc");
}

- (void)loadView
{
    mytableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]
                                               style:UITableViewStylePlain];
    mytableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    mytableView.delegate = self;
    mytableView.dataSource = self;
    mytableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mytableView.separatorColor = [UIColor grayColor];
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
///    mytableView.frame = CGRectMake(0, HEADER_HEIGHT, rect.size.width, rect.size.height - HEADER_HEIGHT - 65);
//    mytableView.frame = CGRectMake(0, HEADER_HEIGHT, rect.size.width, rect.size.height - HEADER_HEIGHT - 65 - 50);
    mytableView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height - 65 - 50);
    
	
    self.view = mytableView;
    self.view.backgroundColor = [SZUtils color02];
//    [mytableView reloadData];
    /*NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentProgramIndex inSection:0];
     if (indexPath != nil && [mytableView cellForRowAtIndexPath:indexPath] != nil) {
     [mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentProgramIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
     }*/
}

//===================================================================
- (NSArray*)requestForTableData:(NSString*)entity Context:(NSManagedObjectContext*)_context 
                           name:(NSString*)name
                        dateMin:(NSDate*)minD dateMax:(NSDate*)maxD;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:_context];    
    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];    
    NSPredicate *pred;        
    pred = [NSPredicate predicateWithFormat:@"(%K LIKE[cd] %@)&&(%K > %@)&&(%K < %@)", @"rTVChannel.pName",name, 
                                            @"pStop",minD, @"pStart",maxD];
    [request setPredicate:pred];         
    NSError *err=nil;
    NSArray *res = [_context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
//    _NSLog(@" request TabData=%d",[res count]);    
//    NSArray* res2 = [res sortedArrayUsingComparator: ^(id obj1, id obj2) { 
//        NSDate *d1 = ((MTVShow*)obj1).pStart;
//        NSDate *d2 = ((MTVShow*)obj2).pStart;
//        return [d1 compare:d2];
//    }];    
//    //    _NSLog(@" request for entity:(%@) =%d",entity,[res2 count]);    
    return res;
}

-(void)calcCurrentIndex
{
    int sc = [self.tabData count];
    currentProgramIndex = 0;
    NSDate *dat = [NSDate date];
    for (int idd = 0; idd < sc; idd++) {
        MTVShow *sw = [self.tabData objectAtIndex:idd];
        NSDate *d1 = sw.pStart;
        NSDate *d2 = sw.pStop;
        if ([dat timeIntervalSinceDate:d1]>=0  && [dat timeIntervalSinceDate:d2]<0 ) 
        {
            currentProgramIndex = idd;
            break;
        }
    }
//    _NSLog(@"CurrIndex = %d",currentProgramIndex);
}

- (void)scrolTableData
{
    if ([self.tabData count] == 0)
        return;
    if ((currentProgramIndex > 0)&&(currentProgramIndex < [self.tabData count]))
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentProgramIndex inSection:0];
        if (indexPath != nil)
            [mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentProgramIndex inSection:0] 
                           atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }    
}

//-------------------------------------------------------------------
- (void)reloadTableData
{
    @synchronized(self) {
        [self.tableView reloadData];   
    }
}

- (void)reallyReloadTable 
{
    NSDate *d1 = currToday_;
    NSDate *d2 = [currToday_ dateByAddingTimeInterval:24*60*60];
    self.tabData = [self requestForTableData:@"MTVShow" Context:self.context name:self.channelName  dateMin:d1 dateMax:d2];  
    
    [self calcCurrentIndex];
    
//    [mytableView reloadData]; 
    [self reloadTableData];
    
    [self scrolTableData];
}

- (void)reloadTable 
{
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reallyReloadTable) object:nil];
    [self performSelector:@selector(reallyReloadTable) withObject:nil afterDelay:0.05];    
}

//-------------------------------------------------------------------

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated]; //alw
    if ([self.tabData count] == 0) 
        return;
    [self runTimer];
///    [self scrolTableData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; //alw
    [self stopTimer];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning]; 
    self.tabData = nil;
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

//-------------------------------------------------------------------------------
//-(void)setChannel:(Channel*)ch
//{
////    currentChannel = ch;
////    [self reloadTable]; //zs
//}

-(void)setChannelWithName:(NSString*)name
{
    self.channelName = name;
    [self reloadTable]; //zs
}

-(void)setDate:(NSString *) date
{
    currentDate = [NSString stringWithString:date];
    
    currentDay_ = [date copy];    
    NSDictionary *currTime = getCurrentTime();
    int hour = [[currTime objectForKey:@"hour"] intValue];
    int min  = [[currTime objectForKey:@"min"] intValue];
    //  currentDay_ = [[ModelHelper shared] dayForToday];
    currToday_ = [[ModelHelper shared] dateFromDay:currentDay_]; //today    
    currDate_ = [currToday_ dateByAddingTimeInterval:((hour*60)+min)*60];
//    _NSLog(@"> cDay_=%@  cToday_=%@  cDate_=%@",currentDay_,currToday_,currDate_);    
    
    if (![self.channelName isEqualToString:@""])
        [self reloadTable]; //zs    
}

//-------------------------------------------------------------------------------
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
    if (self.tabData == nil)
        return 0;
    return [tabData_ count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (currentProgramIndex == indexPath.row) {
//        if ([[TVDataSingelton sharedTVDataInstance] isDateCorrespondToToday] == YES) 
//        {
//            return 48;//zs 60;
//        }
//    }
    return 44; //zs 50
}
//-------------------------------cellForRowAtIndexPath------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ProgrammCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProgrammCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (currentProgramIndex == indexPath.row) {
        [cell setCurrent:[[TVDataSingelton sharedTVDataInstance] isDateCorrespondToToday]];
    }
    else
        [cell setCurrent:NO];
    cell.accessoryType = UITableViewCellAccessoryNone;
                         
    // Configure the cell...
/*    
    Show * showw = [programByCurrentDate objectAtIndex:indexPath.row];
    cell.primaryLabel.text = [NSString stringWithFormat:@"%.2d:%.2d",[showw getStartHour],[showw getStartMin]]; 
    
    cell.secondaryLabel.text = [showw name];
    
    NSDictionary *currTime = getCurrentTime();
    int cHour = [[currTime objectForKey:@"hour"] intValue];
    int cMin  = [[currTime objectForKey:@"min"] intValue];
    
    [cell setTimeFromBeginning:[showw timeFromBeginning:cHour withMin:cMin] durationOfShow:[showw getDuration]];
*/   

    MTVShow *show = [self.tabData objectAtIndex:indexPath.row];
    NSString *addDescr = @"";
//    if ([show descript] != nil){
//        addDescr = @"...";
//    }
    cell.primaryLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", [[ModelHelper shared] hourFromDate:show.pStart], 
                                  [[ModelHelper shared] minFromDate:show.pStart] ];    
//  cell.secondaryLabel.text = show.pTitle;
    cell.secondaryLabel.text = [NSString stringWithFormat:@"%@ %@",show.pTitle,addDescr];
    
    if ([show descript] != nil) {
//        cell.thirdLabel.text = @">";    
//        cell.thirdLabel.textColor = [UIColor brownColor];
//        cell.thirdLabel.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.thirdLabel.hidden = YES;  
    }
    
    NSDate *d1 = show.pStart;
    NSDate *d2 = show.pStop;
    NSDate *d3 = [NSDate date];//currDate_;
    NSTimeInterval dur = fabs([d2 timeIntervalSinceDate:d1]/60.0);
    NSTimeInterval cur = 0;
    cur = [d3 timeIntervalSinceDate:d1]/60.0;
//     _NSLog(@"dur=%f  cur =%f  name=%@",dur,cur,show.pTitle); 
//    if  (cur <= dur) //zs
        [cell setTimeFromBeginning:cur durationOfShow:dur];
        
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Show *show = [programByCurrentDate objectAtIndex:indexPath.row];
//    [[self delegate] programIsSelected:show];
    if (self.tabData == nil)
        return;
    MTVShow *show = [self.tabData objectAtIndex:indexPath.row];
    if ([[self delegate] respondsToSelector:@selector(programIsSelectedMTV:)])
        [[self delegate] programIsSelectedMTV:show];
}

//---------------timer--------------------------
- (void)timerActivity 
{
//    [self reloadTableData]; 
    //   _NSLog(@"-run timer-");
//    [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];
        
    if ([SSVProgressHUD isVisible]) {
//        _NSLog(@"-NO_run proglist_timer-");        
    } else {
//        NSInteger ind =  [[[self.delegate navigationController] tabBarController ] selectedIndex];         
//        if (ind == 0) {
            [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];
            _NSLog(@"-run proglist_timer-");
//        }
    }
    
}

- (void)runTimer 
{    
    [self stopTimer];
    myTicker_ = [NSTimer scheduledTimerWithTimeInterval: 15.0
                                                 target: self
                                               selector: @selector(timerActivity)
                                               userInfo: nil
                                                repeats: YES];
}

- (void)stopTimer
{
    [myTicker_ invalidate]; 
    myTicker_ = nil;    
}



@end
