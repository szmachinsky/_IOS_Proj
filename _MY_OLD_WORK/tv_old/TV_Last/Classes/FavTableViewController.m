//
//  TVTableViewController.m
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FavTableViewController.h"
#import "TVListCell.h"
#import "CommonFunctions.h"

//#import "Show.h"
//#import "Channel.h"
#import "TVDataSingelton.h"


#import "MTVShow.h"
#import "MTVChannel.h"
#import "SZAppInfo.h"

#import "WaitView.h"
//#import "UserTool.h"
#import "SSVProgressHUD.h"


@interface FavTableViewController ()
- (void)reloadTableData;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)runTimer; 
- (void)stopTimer;
@end


@implementation FavTableViewController
{
//    UIAlertView *progressAlert_;        
//    WaitView *waitView_;  //zs 
    
    __block BOOL isCalc_;
    uint64_t taccess; 
    
    dispatch_queue_t serialQueue_;    
}
//@synthesize waitView = waitView_;

@synthesize delegate;

@synthesize context = context_;
@synthesize selArrays = selArrays_;
@synthesize tabData = tabData_;
@synthesize nextData = nextData_;
//@synthesize favArrays = favArrays_;


#define HEADER_HEIGHT 45
#define SLIDER_HEIGHT 60

#pragma mark -
#pragma mark View lifecycle


- (id)init
{
    self = [super init];
    if (self) { 
        tabData_ = nil;//[[NSArray alloc] init];
        nextData_ = nil;//[[NSArray alloc] init];
        selArrays_ = nil;//[[NSArray alloc] init];

        serialQueue_ = dispatch_queue_create("com.tvprog1.queue", NULL);        
        
        [self runTimer];
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
    dispatch_release(serialQueue_); 
    self.context = nil;
}

//------------------------------------------------------------------
-(void)checkVisibility
{
    if ([SZAppInfo shared].colSelChannels == 0) 
    {
        if (self.tableView.hidden == NO) {
            self.tableView.hidden = YES;
        }
        [[self.delegate navigationItem] rightBarButtonItem].enabled = NO; 
        [[self.delegate navigationItem] leftBarButtonItem].enabled = NO;         
   } else {
        if (self.tableView.hidden == YES) {
            self.tableView.hidden = NO;
        }
        [[self.delegate navigationItem] rightBarButtonItem].enabled = YES; 
        [[self.delegate navigationItem] leftBarButtonItem].enabled = YES;         
    }    
}

//-------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.context = [[[SZAppInfo shared] coreManager] createContext];
    [self checkVisibility];
    [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.context = nil;
    self.tabData = nil;
    self.nextData = nil;
}

//------------------------------------------------------------------------------
- (NSArray*)requestForData1:(NSDate*)dat
{
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    NSMutableArray *result2 = [[NSMutableArray alloc] init];
    _NSLog(@"--1-->>>");  
    self.selArrays = [SZCoreManager arrayOfFavoriteChannels:self.context];
    _NSLog(@"--2-->>>");  
    for (MTVChannel *chan in self.selArrays) 
    {
        NSSet *shw = chan.rTVShow;
        NSArray *arrShow1 = [shw allObjects];
        NSArray* arrShow2 = [arrShow1 sortedArrayUsingComparator: ^(id obj1, id obj2) { 
            NSDate *d1 = ((MTVShow*)obj1).pStart;
            NSDate *d2 = ((MTVShow*)obj2).pStart;
            return [d1 compare:d2];
        }];            
        int sc = [arrShow2 count];
        BOOL ok = NO;
        for (int idd = 0; idd < sc; idd++) {
            MTVShow *sw = [arrShow2 objectAtIndex:idd];
            NSDate *d1 = sw.pStart;
            NSDate *d2 = sw.pStop;
            if ([dat timeIntervalSinceDate:d1]>=0  && [dat timeIntervalSinceDate:d2]<0 ) 
            {
                [result1 addObject:sw];
                if (idd < (sc-1)) //add next object
                {
                    [result2 addObject:[arrShow2 objectAtIndex:(idd+1)]];
                } else {
                    [result2 addObject:[NSNull null]]; 
                }
                ok = YES;
                break;
            }                
        }
        if (!ok) {
            [result1 addObject:[NSNull null]];
            [result2 addObject:[NSNull null]];
        }
    }
    _NSLog(@"--3--[%d]->>>",[result1 count]);  
    self.tabData = result1;
    self.nextData = result2;
    return result1;
}

/*
- (NSArray*)requestForDates_:(NSDate*)dat1 nextDate:(NSDate*)dat2
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:self.context];
    _NSLog(@"--11--[fav_ch:%d]>>>",[self.selArrays count]); 
    
    //    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    //    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
    NSSortDescriptor *sd3 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];    
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,sd3,nil]];    
    
    NSPredicate *pred;
    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K > %@)&&(%K < %@)", 
            @"rTVChannel.pFavorite",  @"pStop",dat1,   @"pStop",dat2];
    //  pred = [NSPredicate predicateWithFormat:@"(%K <= %@)&&(%K > %@)", @"pStart",dat,   @"pStop",dat];
    //  pred = [NSPredicate predicateWithFormat:@"(%K == YES)", @"rTVChannel.pSelected"];
    [request setPredicate:pred];         
    NSError *err=nil;
    NSArray *res = [self.context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
    _NSLog(@"--22-[%d]->>>",[res count]);
    NSInteger sid = 0, idd = 0, sc = [res count];    
    NSMutableArray *res1 = [[NSMutableArray alloc] initWithCapacity:sc];
    NSMutableArray *res2 = [[NSMutableArray alloc] initWithCapacity:sc];
    for (idd = 0; idd < sc; idd++) {
        MTVShow *sh1 = [res objectAtIndex:idd];
        if (sid != sh1.pId) 
        {
            sid = sh1.pId;
            [res1 addObject:sh1];            
            BOOL ok = NO;
            if (idd < (sc-1)) //add next object
            {
                MTVShow *sh2 = [res objectAtIndex:idd+1];
                if (sid == sh2.pId) 
                {
                    [res2 addObject:sh2];
                    ok = YES;
                }
            }
            if (!ok) {
                [res2 addObject:[NSNull null]]; 
            }
        }
    }
    _NSLog(@"--33 [%d] [%d] [%d]-->>>",[res count],[res1 count], [res2 count]);
    self.tabData = [[NSArray alloc] initWithArray:res1];
    self.nextData =[[NSArray alloc] initWithArray:res2];         
    return res;
}
*/


- (NSArray*)requestForDates:(NSDate*)dat1 nextDate:(NSDate*)dat2
{
//    uint64_t t1 = getTickCount();    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:self.context];
//    _NSLog(@"--11--fav_[sel_ch:%d]>>>",[self.selArrays count]); 
    //    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    //    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];
    NSSortDescriptor *sd3 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];    
    [request setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,sd3,nil]];    
    
    NSPredicate *pred;
    //    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K > %@)&&(%K < %@)", 
    //            @"rTVChannel.pSelected",  @"pStop",dat1,   @"pStop",dat2];
    
    
    pred = [NSPredicate predicateWithFormat:@"(%K == YES) && ( ((%K > %@)&&(%K < %@)) || ((%K <= %@)&&(%K >= %@)) ) ", 
            @"rTVChannel.pFavorite",     @"pStop",dat1, @"pStop",dat2,    @"pStart",dat1, @"pStop",dat2 ];
    
    //  pred = [NSPredicate predicateWithFormat:@"(%K <= %@)&&(%K > %@)", @"pStart",dat,   @"pStop",dat];
    //  pred = [NSPredicate predicateWithFormat:@"(%K == YES)", @"rTVChannel.pSelected"];
    [request setPredicate:pred];         
    NSError *err=nil;
    NSArray *res = [self.context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
///    _NSLog(@"--22-[%d]->>>",[res count]);
    
    NSInteger sc0 = [self.selArrays count];      
    NSInteger sc = [res count];
    NSMutableArray *res1 = [[NSMutableArray alloc] initWithCapacity:sc0];
    NSMutableArray *res2 = [[NSMutableArray alloc] initWithCapacity:sc0];    
    NSInteger pid_old = 0, pid = 0, idd = 0;   
    NSInteger iddd = 0, pidd = 0; 
    MTVChannel *channel = nil;
    MTVShow *shw1 = nil;
    MTVShow *shw2 = nil;
    
    NSDate *dat00 = [[ModelHelper shared] dateBeginHourFromDate:dat1]; //begin of curr hour
    NSDate *dat11 = [dat00 dateByAddingTimeInterval:60*60*1]; //begin of next hour
    //  NSDate *dat22 = [dat00 dateByAddingTimeInterval:60*60*2]; //begin of next hour
    NSDate *start = nil;
    //    _NSLog(@"d1 = %@   d2 = %@",dat1, dat2);
    for (idd = 0; idd < sc; idd++) 
    {
        shw1 = [res objectAtIndex:idd];
        pid = shw1.pId;
        if (pid_old != pid) //new number
        {
            if (iddd < sc0) 
            {
                BOOL comp = NO;
                do {
                    channel = [self.selArrays objectAtIndex:iddd];
                    pidd = channel.pID;
                    ///                    _NSLog(@"?_%d  (%d) == (%d)",iddd,pid,pidd);
                    if (pid == pidd) {
                        comp = YES;
                    } else {
                        [res1 addObject:[NSNull null]]; //empty object!!!
                        [res2 addObject:[NSNull null]];
                        //                       _NSLog(@"!!!!! insert NULL for channel (%d)<>(%d)  (%@) ",pid,pidd,channel.pName);
                    }
                    iddd++; 
                } while ((!comp) && (iddd < sc0));
                
            }
            
            start = shw1.pStart;
            //            _NSLog(@"start = %@  dat11 = %@",start,dat11);
            if ([start timeIntervalSinceDate:dat11] < 0) 
            {
                [res1 addObject:shw1]; 
                BOOL ok = NO;
                if (idd < (sc-1)) //add next object
                {
                    shw2 = [res objectAtIndex:idd+1];
                    //                  if ((pid == shw2.pId) &&  ([shw2.pStart timeIntervalSinceDate:dat22] < 0)) //in in next hour
                    if (pid == shw2.pId)
                    {
                        [res2 addObject:shw2];
                        ok = YES;
                        idd++;
                    }
                }            
                if (!ok) {
                    [res2 addObject:[NSNull null]]; 
                }
            } else {
                [res1 addObject:[NSNull null]];
                [res2 addObject:shw1]; 
            }
            
        }
        pid_old = pid;
    }
    
    NSInteger raz = sc0 - [res1 count];
    for (idd = 0; idd < raz; idd++) {
        [res1 addObject:[NSNull null]]; //add empty objects!!!
        [res2 addObject:[NSNull null]];        
    }
    
//    uint64_t t2 = getTickCount();    
//    _NSLog(@"--33 [%d] [%d] [%d]-- (%llu ms)>>>",[res count],[res1 count], [res2 count], (t2-t1));
    self.tabData = [[NSArray alloc] initWithArray:res1];
    self.nextData =[[NSArray alloc] initWithArray:res2];         
    return res;
}




- (NSArray*)getShows:(NSArray **)tabData nextShow:(NSArray **)nextData  sellArr:(NSArray*)selArrays  initDate:(NSDate*)dat1 nextDate:(NSDate*)dat2 context:(NSManagedObjectContext *)context
{             
    uint64_t t1 = getTickCount();
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:context];
    _NSLog2(@"--11--fav_[sel_ch:%d]>>>",[selArrays count]); 
    //    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    //    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];
    NSSortDescriptor *sd3 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];    
    [request setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,sd3,nil]];    
    
    NSPredicate *pred;
    //    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K > %@)&&(%K < %@)", 
    //            @"rTVChannel.pSelected",  @"pStop",dat1,   @"pStop",dat2];
    
    
    pred = [NSPredicate predicateWithFormat:@"(%K == YES) && ( ((%K > %@)&&(%K < %@)) || ((%K <= %@)&&(%K >= %@)) ) ", 
            @"rTVChannel.pFavorite",     @"pStop",dat1, @"pStop",dat2,    @"pStart",dat1, @"pStop",dat2 ];
    
    //  pred = [NSPredicate predicateWithFormat:@"(%K <= %@)&&(%K > %@)", @"pStart",dat,   @"pStop",dat];
    //  pred = [NSPredicate predicateWithFormat:@"(%K == YES)", @"rTVChannel.pSelected"];
    [request setPredicate:pred];         
    NSError *err=nil;
    NSArray *res = nil;
    NSInteger sc0 = [selArrays count];      
    NSMutableArray *res1 = [[NSMutableArray alloc] initWithCapacity:sc0];
    NSMutableArray *res2 = [[NSMutableArray alloc] initWithCapacity:sc0]; 
    uint64_t t11 = 0;
    @try {
        res = [context executeFetchRequest:request error:&err];
        if (err) {
            _NSLog(@"ERROR"); return nil;
        };
        
        //    _NSLog2(@"--22-[%d items]->>>",[res count]);
        
        NSInteger sc = [res count];
        NSInteger pid_old = 0, pid = 0, idd = 0;   
        NSInteger iddd = 0, pidd = 0; 
        MTVChannel *channel = nil;
        MTVShow *shw1 = nil;
        MTVShow *shw2 = nil;
        
        t11 = getTickCount();    
        NSDate *dat00 = [[ModelHelper shared] dateBeginHourFromDate:dat1]; //begin of curr hour
        NSDate *dat11 = [dat00 dateByAddingTimeInterval:60*60*1]; //begin of next hour
        //  NSDate *dat22 = [dat00 dateByAddingTimeInterval:60*60*2]; //begin of next hour
        NSDate *start = nil;
        //    _NSLog(@"d1 = %@   d2 = %@",dat1, dat2);
        for (idd = 0; idd < sc; idd++) 
        {
            shw1 = [res objectAtIndex:idd];
            pid = shw1.pId;
            if (pid_old != pid) //new number
            {
                if (iddd < sc0) 
                {
                    BOOL comp = NO;
                    do {
                        channel = [selArrays objectAtIndex:iddd];
                        pidd = channel.pID;
                        ///                    _NSLog(@"?_%d  (%d) == (%d)",iddd,pid,pidd);
                        if (pid == pidd) {
                            comp = YES;
                        } else {
                            [res1 addObject:[NSNull null]]; //empty object!!!
                            [res2 addObject:[NSNull null]];
                            //                       _NSLog(@"!!!!! insert NULL for channel (%d)<>(%d)  (%@) ",pid,pidd,channel.pName);
                        }
                        iddd++; 
                    } while ((!comp) && (iddd < sc0));
                    
                }
                
                start = shw1.pStart;
                //            _NSLog(@"start = %@  dat11 = %@",start,dat11);
                if ([start timeIntervalSinceDate:dat11] < 0) 
                {
                    [res1 addObject:shw1]; 
                    BOOL ok = NO;
                    if (idd < (sc-1)) //add next object
                    {
                        shw2 = [res objectAtIndex:idd+1];
                        //                  if ((pid == shw2.pId) &&  ([shw2.pStart timeIntervalSinceDate:dat22] < 0)) //in in next hour
                        if (pid == shw2.pId)
                        {
                            [res2 addObject:shw2];
                            ok = YES;
                            idd++;
                        }
                    }            
                    if (!ok) {
                        [res2 addObject:[NSNull null]]; 
                    }
                    //                idd++;
                } else {
                    [res1 addObject:[NSNull null]];
                    [res2 addObject:shw1]; 
                }
                
            }
            pid_old = pid;
        }
        
        NSInteger raz = sc0 - [res1 count];
        for (idd = 0; idd < raz; idd++) {
            [res1 addObject:[NSNull null]]; //add empty objects!!!
            [res2 addObject:[NSNull null]];        
        }
        
        uint64_t t2 = getTickCount();  
        taccess = t2-t1;

        //    _NSLog2(@"--33 [%d] [%d] [%d]-- (%llu + %llu ms)>>>",[res count],[res1 count], [res2 count], (t11-t1),(t2-t11));
        //    self.tabData = [[NSArray alloc] initWithArray:res1];
        //    self.nextData =[[NSArray alloc] initWithArray:res2]; 
        
        //    *tabData = [[NSArray alloc] initWithArray:res1];
        //    *nextData =[[NSArray alloc] initWithArray:res2]; 
        
    } //try
    @catch (NSException *exception) {
        _NSLog0(@"ERROR_main");
        //        *tabData = nil;
        //        *nextData = nil;
        return nil;
    }
    @finally {
///        uint64_t t2 = getTickCount();
        _NSLog2(@"--33 [%d] [%d] [%d]-- (%llu + %llu ms)>>>",[res count],[res1 count], [res2 count], (t11-t1),(t2-t11));
        NSArray *result = [NSArray arrayWithObjects:res1,res2, nil];
        return result;
    }    
    
}


//-------------------------------------------------------------------
- (void)reloadTableData
{
    @synchronized(self) {
        [self.tableView reloadData];   
    }
}

-(void)showProgress
{
    if (isCalc_) {
        [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//      [waitView_ showWaitScreen];
    }
}


- (void)reallyReloadTable 
{
@synchronized(self) 
{
    if (isCalc_) {
            _NSLog(@"!!!____EXITTTT____!!!");
            return;
    }
    isCalc_ = YES;
    self.context = [[[SZAppInfo shared] coreManager] createContext];
    //  self.tabData = [self requestForData:currDate_];        
 
//    UIAlertView *alert = [ModelHelper showProgressIndicator];
//    [self requestForData1:currDate_]; 
//    [ModelHelper hideProgressIndicator:alert];
    
//    [self performSelector:@selector(showProgress) withObject:nil afterDelay:0.9];

////    self.selArrays = [SZCoreManager arrayOfFavoriteChannels:self.context];//[SZCoreManager arrayOfSelectedChannels:self.context];
    
//    double delayInSeconds = 0.9;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        if (isCalc_) {
//            [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        }
//    });    
        
    [self checkVisibility];
///    self.selArrays = [SZCoreManager arrayOfSelectedChannels:self.context];
    self.selArrays = [SZCoreManager arrayOfFavoriteChannels:self.context];
    if ([self.selArrays count] == 0) {
        isCalc_ = NO;
        [SSVProgressHUD dismiss];
        return;
    };
    
    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{      serialQueue
    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{ 
    //    dispatch_async(serialQueue_, ^{ 
    NSDate *dat1 = currDate_;
    NSDate *dat2 = [NSDate dateWithTimeInterval:60*6*31 sinceDate:currDate_];
    ///        [self requestForDates:dat1 nextDate:dat2]; //request for data        
    NSArray *tabData = nil;
    NSArray *nextData = nil;    
    //NSArray *selArrays = [SZCoreManager arrayOfSelectedChannels:self.context];       
    NSArray *res = [self getShows:&tabData nextShow:&nextData sellArr:self.selArrays initDate:dat1 nextDate:dat2 context:self.context];
    //        sleep(2); 
    //        dispatch_async(dispatch_get_main_queue(), ^{ 
    @try {
        
        //self.tabData = tabData;
        //self.nextData = nextData;
        //self.selArrays = selArrays;
        
        self.tabData = [res objectAtIndex:0];
        self.nextData = [res objectAtIndex:1];
        
        //          [self.tableView reloadTableData];               
        [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];
    }
    @catch (NSException *exception) {
        _NSLog0(@"ERROR_main_async");                
    }
    @finally {
        isCalc_ = NO;
        [SSVProgressHUD dismiss];
    }
//        }); 
//    });
}    
}

- (void)preReloadTable
{
    if ((taccess > 200) && ([SZAppInfo shared].colSelChannels > 0))
        [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear]; 
    //    double delayInSeconds = 0.2;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //        if (isCalc_) {
    //            [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeZSClear];
    //        }
    //    });  
    
    [self performSelector:@selector(reallyReloadTable) withObject:nil afterDelay:0.0];    
}


- (void)reloadTable {
    ///    isCurrDateToday = [[TVDataSingelton sharedTVDataInstance] isDateCorrespondToToday]; //zs
    isCurrDateToday = [[ModelHelper shared] isDateToday:currDate_];
    if (isCalc_) {
        _NSLog(@"!!!_EXIT_fav!!!");
        [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.1];
        return;
    }    
    
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(preReloadTable) object:nil];
    [self performSelector:@selector(preReloadTable) withObject:nil afterDelay:0.05]; 
    
}



//===============================================================================
- (void)loadView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView.separatorColor = [SZUtils color01];
    self.tableView.backgroundColor = [SZUtils color02];
//    [self.tableView reloadData];
//    [self reloadTable]; //zs
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.0];
}


- (void)viewDidLoad {
    [super viewDidLoad];

//    waitView_ = [[WaitView alloc] initWithFrame:CGRectZero]; //zs
//    [self.view addSubview:waitView_];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}


/*
-(void) updateProgramToDate:(NSString *)day
{
    currentDay_ = [[NSString stringWithString:day] copy];
    _NSLog(@"set_f_date currDay=%@",currentDay_);    
    
    currToday_ = [[ModelHelper shared] dateFromDay:currentDay_]; //today    
    currDate_ = [currToday_ dateByAddingTimeInterval:((hour*60)+min)*60];
    
    [self reloadTable]; //zs
}

-(void) setTime:(int)h minutes:(int)m
{
    hour = h;
    min = m;
    
//  currentDay_ = [[ModelHelper shared] dayForToday];
    currToday_ = [[ModelHelper shared] dateFromDay:currentDay_]; //today    
    currDate_ = [currToday_ dateByAddingTimeInterval:((hour*60)+min)*60];
//    _NSLog(@"set_f_time currDate=%@",currDate_);        
    
    [self reloadTable]; //zs
}

*/
//--------------------date time update----------------------------------------------
-(void) updateProgramToDate:(NSString *)day
{
    currentDay_ = [[NSString stringWithString:day] copy];
    
    currToday_ = [[ModelHelper shared] dateFromDay:currentDay_]; //today    
    currDate_ = [currToday_ dateByAddingTimeInterval:((hour*60)+min)*60];
    
    //    _NSLog(@"set_date: currDay_=%@  currToday_=%@ currDate_=%@",currentDay_,currToday_,currDate_);
    
    NSArray *days = [[TVDataSingelton sharedTVDataInstance] getDates];
    NSInteger numOfDays = days.count; // > 7 ? 7 : days.count;
    NSString *dayMin = [days objectAtIndex:0];
    NSString *dayMax = [days objectAtIndex:numOfDays-1];
    //    _NSLog(@" min:%@  ..... max:%@",dayMin,dayMax);
    NSDate *datMin = [[ModelHelper shared] dateFromDay:dayMin];
    NSDate *datMax = [[ModelHelper shared] dateFromDay:dayMax];
    if ( ([currToday_ timeIntervalSinceDate:datMin] >=0) && ([currToday_ timeIntervalSinceDate:datMax] <=0) )
    {    
        //        _NSLog(@"valid day");
    } else {
        //        _NSLog(@"in_valid day");        
    }
    
//    [self reloadTable];
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.0];
}

-(void) setTime:(int)h minutes:(int)m
{
    hour = h;
    min = m;
    //  currentDay_ = [[ModelHelper shared] dayForToday];
    currToday_ = [[ModelHelper shared] dateFromDay:currentDay_]; //today    
    currDate_ = [currToday_ dateByAddingTimeInterval:((hour*60)+min)*60];
    //    _NSLog(@"set_time currDate=%@",currDate_); 
    
    //    _NSLog(@"set_Time: currDay_=%@  currToday_=%@ currDate_=%@",currentDay_,currToday_,currDate_);
    
//    [self reloadTable];
 
    if ((hour != hour_)||(min != min_)) {
        [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.0];
    } else {
        [self checkVisibility];        
    }
    hour_=hour;
    min_=min;
}


-(void) reloadData
{
//    [self reloadTable]; //zs
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.0];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    [self checkVisibility];
    if (self.tabData == nil) {
        return 0;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
//    return [[TVDataSingelton sharedTVDataInstance] getNumberOfFavChannels];    
    if (self.tabData == nil)
        return 0;
    NSInteger res = [tabData_ count];
    return res;    
}


- (void)clearCell:(TVListCell *)cell
{
    cell.currentShowLabel.text = nil;
    cell.nextShowLabel.text = nil;
    cell.channelNameLabel.text = nil;
    [cell setProgressBarVisible:NO];
    [cell setIconImage:nil];            
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    TVListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TVListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    if ((selArrays_ == nil) || (self.tabData == nil) || (isCalc_) ) {
        [self clearCell:cell];
    } else {
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
    
    
}


//================================configureCell==================================================
#pragma mark - 
- (void)configureCell:(TVListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ((selArrays_ == nil) || ([selArrays_ count] <= indexPath.row))
        return;
    
    MTVChannel *channel_ = [selArrays_ objectAtIndex:indexPath.row];     
    MTVShow *show = [self.tabData objectAtIndex:indexPath.row];
    //        MTVChannel *channel = show.rTVChannel;
    if (show == nil) {
        [self clearCell:cell];
        return;
    }
    
    //  [cell setTimeFromBeginning:[current timeFromBeginning:cHour withMin:cMin] durationOfShow:[current getDuration]];
    if (show != (MTVShow *)[NSNull null]) {        
        NSDate *d1 = show.pStart;
        NSDate *d2 = show.pStop;
        NSDate *d3 = [NSDate date];//currDate_;
        NSTimeInterval dur = fabs([d2 timeIntervalSinceDate:d1]/60.0);
        NSTimeInterval cur = [d3 timeIntervalSinceDate:d1]/60.0;
        //            _NSLog(@"dur=%f  cur =%f  name=%@",dur,cur,show.pTitle);        
        [cell setTimeFromBeginning:cur durationOfShow:dur];
        
        cell.currentShowLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %@", [[ModelHelper shared] hourFromDate:show.pStart], 
                                      [[ModelHelper shared] minFromDate:show.pStart], show.pTitle];
        
        cell.nextShowLabel.text = @"";
        MTVShow *nShow = [self.nextData objectAtIndex:indexPath.row];
        if (nShow != (MTVShow *)[NSNull null]) 
        {
            
            cell.nextShowLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %@", [[ModelHelper shared] hourFromDate:nShow.pStart], [[ModelHelper shared] minFromDate:nShow.pStart], nShow.pTitle];
        }        
        
        [cell setProgressBarVisible:isCurrDateToday];
        
        
        MTVChannel *channel = show.rTVChannel;
        if (channel.pID != channel_.pID) {
            _NSLog(@"!!!ERROR CHANNELS!!! (%@) (%@) ",channel.pName,channel_.pName);
            //        abort();
        }
        
        cell.channelNameLabel.text = channel.pName;
        UIImage *im = nil;
        if (channel.pImage != nil)
            im = [UIImage imageWithData:(NSData*)channel.pImage];
        [cell setIconImage:im];
        
        
    } else {
//        _NSLog(@" !! нет прогр для (%@) ",channel_.pName);
        cell.currentShowLabel.text = @"Нет программы";
        cell.nextShowLabel.text = @"";
        [cell setProgressBarVisible:NO]; 
        
        //        [cell setIconImage:nil];
        cell.channelNameLabel.text = channel_.pName;
        UIImage *im = nil;
        if (channel_.pImage != nil)
            im = [UIImage imageWithData:(NSData*)channel_.pImage];
        [cell setIconImage:im];
        
    }
    
    
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//  NSString *chanelName = [[TVDataSingelton sharedTVDataInstance] getFavChannelByIndex:indexPath.row];
//  [[self delegate] channelIsSelected:chanelName];
    
    if ((selArrays_ == nil) || ([selArrays_ count] <= indexPath.row))
        return;
    MTVChannel *channel = [selArrays_ objectAtIndex:indexPath.row];     
    NSString *chanelName = channel.pName;
//  NSInteger chId = channel.pID;    
    if ([delegate respondsToSelector:@selector(channelIsSelected:)])
        [[self delegate] channelIsSelected:chanelName];             
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64; //80
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc. that aren't in use.
    self.selArrays = nil;
    self.tabData = nil;
    self.nextData = nil;
    
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

//---------------timer--------------------------
- (void)timerActivity 
{
    if ([SSVProgressHUD isVisible] || (isCalc_) ) {
//        _NSLog(@"-NO_run fav_timer-");        
    } else {
//      [self reloadTableData]; 
//      NSInteger ind =  self.navigationController.tabBarController.selectedIndex;
        NSInteger ind =  [[[self.delegate navigationController] tabBarController ] selectedIndex];
        
        if (ind == 0) {            
            [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];
//            _NSLog(@"-run fav_timer- %d",ind);
        }    
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
    [myTicker_ invalidate]; myTicker_ = nil;    
}




@end

