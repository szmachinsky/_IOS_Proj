//
//  TVTableViewController.m
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SZTVTableViewController.h"
#import "TVListCell.h"
#import "Show.h"
#import "Channel.h"
#import "CommonFunctions.h"

#import "TVDataSingelton.h" //zs - to delete!


#import "MTVShow.h"
#import "MTVChannel.h"
#import "SZAppInfo.h"

#import "WaitView.h"
//#import "UserTool.h"
#import "SSVProgressHUD.h"
//#import "MBProgressHUD.h"

#import "TVCell.h"
//#import "ProgramsByCattegoryViewController.h"


@interface SZTVTableViewController ()
- (void)reloadTableData;
- (void)_configureCell:(TVCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)runTimer; 
- (void)stopTimer;

- (void)pressChannel:(id)sender;
- (void)pressCategory:(id)sender;
- (void)pressShow1:(id)sender;
- (void)pressShow2:(id)sender;

//@property (atomic,assign) BOOL isCalculating;
@end


@implementation SZTVTableViewController
{
//    UIAlertView *progressAlert_;        
//    WaitView *waitView_;  //zs 
    ADBannerView *bannerView_;
     
    __block BOOL isCalc_;
//    BOOL isCalc_;  
    uint64_t taccess; 
    
    dispatch_queue_t serialQueue_;
}
//@synthesize waitView = waitView_;
@synthesize slider;

@synthesize delegate;

@synthesize context = context_;
@synthesize tabData = tabData_;
@synthesize nextData = nextData_;
@synthesize selArrays = selArrays_;

@synthesize isFavorite;
@synthesize tabNumber;


#define SLIDER_HEIGHT 80

//-------------------------------------------------------------------
- (id)init
{
    self = [super init];
    if (self) {
        currentDay_ = [[ModelHelper shared] dayForToday];
        currToday_ = [[ModelHelper shared] dateFromDay:currentDay_]; //today    
        currDate_ = [currToday_ dateByAddingTimeInterval:0];  
        tabData_ = nil;//[[NSArray alloc] init];
        nextData_ = nil;//[[NSArray alloc] init];
        selArrays_ = nil;//[[NSArray alloc] init];
        
        serialQueue_ = dispatch_queue_create("com.tvprog1.queue", NULL);
        
        [self runTimer];
    }
    return self;
}

-(void)dealloc
{
    [self stopTimer]; 
//    dispatch_release(serialQueue_);
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
    self.context = [[[SZAppInfo shared] coreManager] createContext]; //nalw
    [self checkVisibility];
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
//    _NSLog(@"-main_will_appier");
    [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    self.context = nil; //alw
    self.tabData = nil;
    self.nextData = nil;
//    _NSLog(@"-main_dissappier");
}

//==============================================================================
//- (NSArray*)requestForData:(NSDate*)dat
//{
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
//    request.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:self.context];
//    _NSLog(@"--11-->>>"); 
//    //    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
//    //    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
//    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];
//    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
//    [request setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,nil]];    
//    
//    NSPredicate *pred;
//    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K <= %@)&&(%K > %@)", 
//            @"rTVChannel.pSelected",  @"pStart",dat,   @"pStop",dat];
//    //  pred = [NSPredicate predicateWithFormat:@"(%K <= %@)&&(%K > %@)", @"pStart",dat,   @"pStop",dat];
//    //  pred = [NSPredicate predicateWithFormat:@"(%K == YES)", @"rTVChannel.pSelected"];
//    [request setPredicate:pred];         
//    NSError *err=nil;
//    NSArray *res1 = [self.context executeFetchRequest:request error:&err];
//    if (err) {
//        _NSLog(@"ERROR"); return nil;
//    };
//    _NSLog(@"--22-->>>");     
//    _NSLog(@" request_10 = %d programms",[res1 count]);    
//    return res1;
//}


- (NSArray*)requestForData1:(NSDate*)dat
{
    NSMutableArray *result1 = [[NSMutableArray alloc] init];
    NSMutableArray *result2 = [[NSMutableArray alloc] init];
    //  NSArray *selArr = [[NSArray alloc] initWithArray:[SZAppInfo shared].selChannels];
    //  for (MTVChannel *chan in selArr) {
    //    [SZAppInfo shared].selChannels = [[SZAppInfo shared] arrayOfSelectedChannels:nil];    
    //    for (MTVChannel *chan in [SZAppInfo shared].selChannels) 
    
    //  selArrays_ = [self arrayOfSelectedChannels];  
    _NSLog(@"--1-->>>");  
    if (self.isFavorite) {
        self.selArrays = [SZCoreManager arrayOfFavoriteChannels:self.context];        
    }   else {    
        self.selArrays = [SZCoreManager arrayOfSelectedChannels:self.context];
    }

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



- (NSArray*)requestForDates:(NSDate*)dat1 nextDate:(NSDate*)dat2
{             
///    uint64_t t1 = getTickCount();
        
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:self.context];
    _NSLog2(@"--11--main_[sel_ch:%d]>>>",[self.selArrays count]); 
    //    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    //    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];
    NSSortDescriptor *sd3 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];    
      [request setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,sd3,nil]];    
    
    NSPredicate *pred;
//    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K > %@)&&(%K < %@)", 
//            @"rTVChannel.pSelected",  @"pStop",dat1,   @"pStop",dat2];

    if (self.isFavorite) {
        pred = [NSPredicate predicateWithFormat:@"(%K == YES) && ( ((%K > %@)&&(%K < %@)) || ((%K <= %@)&&(%K >= %@)) ) ", 
                @"rTVChannel.pFavorite",     @"pStop",dat1, @"pStop",dat2,    @"pStart",dat1, @"pStop",dat2 ];
    } else {
    
        pred = [NSPredicate predicateWithFormat:@"(%K == YES) && ( ((%K > %@)&&(%K < %@)) || ((%K <= %@)&&(%K >= %@)) ) ", 
                @"rTVChannel.pSelected",     @"pStop",dat1, @"pStop",dat2,    @"pStart",dat1, @"pStop",dat2 ];
    }
    
    //  pred = [NSPredicate predicateWithFormat:@"(%K <= %@)&&(%K > %@)", @"pStart",dat,   @"pStop",dat];
    //  pred = [NSPredicate predicateWithFormat:@"(%K == YES)", @"rTVChannel.pSelected"];
    [request setPredicate:pred];         
    NSError *err=nil;
    NSArray *res = [self.context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
//    _NSLog2(@"--22-[%d items]->>>",[res count]);
    
    NSInteger sc0 = [self.selArrays count];      
    NSInteger sc = [res count];
    NSMutableArray *res1 = [[NSMutableArray alloc] initWithCapacity:sc0];
    NSMutableArray *res2 = [[NSMutableArray alloc] initWithCapacity:sc0];    
    NSInteger pid_old = 0, pid = 0, idd = 0;   
    NSInteger iddd = 0, pidd = 0; 
    MTVChannel *channel = nil;
    MTVShow *shw1 = nil;
    MTVShow *shw2 = nil;
    
///    uint64_t t11 = getTickCount();    
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
    
///    uint64_t t2 = getTickCount(); 
    _NSLog2(@"--33 [%d] [%d] [%d]-- (%llu + %llu ms)>>>",[res count],[res1 count], [res2 count], (t11-t1),(t2-t11));
//    self.tabData = [[NSArray alloc] initWithArray:res1];
//    self.nextData =[[NSArray alloc] initWithArray:res2]; 
//    tabData__ = [[NSArray alloc] initWithArray:res1];
//    nextData__ =[[NSArray alloc] initWithArray:res2];         
    return res;
}


- (NSArray*)getShows:(NSArray **)tabData nextShow:(NSArray **)nextData  sellArr:(NSArray*)selArrays  initDate:(NSDate*)dat1 nextDate:(NSDate*)dat2 context:(NSManagedObjectContext *)context
{             
    uint64_t t1 = getTickCount();
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];    
    request.entity = [NSEntityDescription entityForName:@"MTVShow" inManagedObjectContext:context];
    _NSLog2(@"--11--main_[sel_ch:%d]>>>",[selArrays count]); 
    //    NSSortDescriptor *sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    //    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc1]];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"rTVChannel.pName" ascending:YES];
    NSSortDescriptor *sd3 = [NSSortDescriptor sortDescriptorWithKey:@"pStart" ascending:YES];    
    [request setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,sd3,nil]];    
    
    NSPredicate *pred;
    //    pred = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K > %@)&&(%K < %@)", 
    //            @"rTVChannel.pSelected",  @"pStop",dat1,   @"pStop",dat2];
    
    if (self.isFavorite) {
        pred = [NSPredicate predicateWithFormat:@"(%K == YES) && ( ((%K > %@)&&(%K < %@)) || ((%K <= %@)&&(%K >= %@)) ) ", 
                @"rTVChannel.pFavorite",     @"pStop",dat1, @"pStop",dat2,    @"pStart",dat1, @"pStop",dat2 ];
    } else {
        
        pred = [NSPredicate predicateWithFormat:@"(%K == YES) && ( ((%K > %@)&&(%K < %@)) || ((%K <= %@)&&(%K >= %@)) ) ", 
                @"rTVChannel.pSelected",     @"pStop",dat1, @"pStop",dat2,    @"pStart",dat1, @"pStop",dat2 ];
    }
    
//        pred = [NSPredicate predicateWithFormat:@"(%K == YES) && ( ((%K > %@)&&(%K < %@)) || ((%K <= %@)&&(%K >= %@)) ) ", 
//                @"rTVChannel.pSelected",     @"pStop",dat1, @"pStop",dat2,    @"pStart",dat1, @"pStop",dat2 ];
    
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
//        _NSLog0(@"+reloadTableData-");
    }
}

-(void) reloadDataTable
{
    //    [self reloadTable]; //zs
//    _NSLog0(@"-reload data table-");
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.0];
//    [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];    
}

-(void)showProgress
{
    if (isCalc_) {
        [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//      [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//      [SVProgressHUD show];
//      [waitView_ showWaitScreen];
//      _NSLog(@">>>BOOL=%d ",isCalc_);
    }
//    _NSLog(@">>>BOOL=%d ",isCalc_);
}


- (void)reallyReloadTable
{
@synchronized(self) 
{
    if (isCalc_) {
        _NSLog2(@"!!!____EXITTTT111____!!!");
        return;
    }
    
    isCalc_ = YES;
    self.context = [[[SZAppInfo shared] coreManager] createContext];

////    self.selArrays = [SZCoreManager arrayOfSelectedChannels:self.context];
    
//    double delayInSeconds = 0.2;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        if (isCalc_) {
//            [SSVProgressHUD showWithMaskType:SVProgressHUDMaskTypeZSClear];
//        }
//    });    
    
//  isCalc_ = YES;
    [self checkVisibility];
    if (self.isFavorite) {
        self.selArrays = [SZCoreManager arrayOfFavoriteChannels:self.context];        
    }   else {    
        self.selArrays = [SZCoreManager arrayOfSelectedChannels:self.context];
    }
    if ([self.selArrays count] == 0) {
        isCalc_ = NO;
        [SSVProgressHUD dismiss];
        [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];
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
        _NSLog2(@"!!!_EXIT_main!!!");
//        [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadTable) object:nil];   
          [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.1]; //repeat call
        return;
    }         
    [UIApplication cancelPreviousPerformRequestsWithTarget:self selector:@selector(preReloadTable) object:nil];   
    [self performSelector:@selector(preReloadTable) withObject:nil afterDelay:0.05];
}

//--------------------------------------------------------------------

- (void)loadView
{
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor whiteColor];//[SZUtils color01];
    self.tableView.backgroundColor = [UIColor whiteColor];//[SZUtils color02];
    
    self.tableView.allowsSelection = NO;

    
    
//    SZBannerManager *bm = [SZAppInfo shared].bannerManager; //zs
//    [bm addAdBannerToTableView:self.tableView markedByNumber:1];            
            
    ///    [self reloadTable];
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(150, 100, 100, 100)];
//    view1.backgroundColor = [SZUtils color001]; //001,002, 01(l) 04 05 08 
//    view1.alpha = 0.5;
//    [self.view addSubview:view1];
//
//    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
//    view2.backgroundColor = [SZUtils color002]; //001,002, 01(l) 04 08 
//    view2.alpha = 0.5;
//    [self.view addSubview:view2];
//    
//    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 210, 100, 100)];
//    view3.backgroundColor = [SZUtils color08]; //001,002, 01(l) 04 08 
//    view3.alpha = 0.5;
//    [self.view addSubview:view3];
//    

//    SZBannerManager *bm = [SZAppInfo shared].bannerManager;
//    bannerView_ = [bm aDbannerView];  
    
//    SZBannerManager *bm = [SZAppInfo shared].bannerManager;
//    ADBannerView *bannerView = [bm aDbannerView]; 
//    self.tableView.tableHeaderView = bannerView;
    
    
}

//----------------------
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 22.0f)];
//    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    headerView.backgroundColor = [UIColor redColor];
//    return headerView;
    return bannerView_;
//    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}
 */
//----------------------



-(void) setHeight:(int)h fromBottom:(int)dif
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    UIInterfaceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(deviceOrientation))
    {
        self.tableView.frame = CGRectMake(0, h, rect.size.width, 170.0f);
    }
    else
    {
        self.tableView.frame = CGRectMake(0, h, rect.size.height, 320.0f);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
//    view.alpha = 0.5;
//    [self.view addSubview:view];

//    waitView_ = [[WaitView alloc] initWithFrame:CGRectZero]; //zs
//    [self.view addSubview:waitView_];
        
//    SZBannerManager *bm = [SZAppInfo shared].bannerManager; //zs
//    [bm addAdBannerToTableView:self.tableView markedByNumber:1];            
}



- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
}

//TODO: ooioioio

//--------------------date time update----------------------------------------------
-(void)update
{
    //[storage updateToTimeZone];
///    [self reloadTable];
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.0];
}

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
        
///    [self reloadTable];
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
    ///    return [[TVDataSingelton sharedTVDataInstance] getNumberOfSelectedChannels];
    if (self.tabData == nil)
        return 0;
//    return 2;
    NSInteger res = [tabData_ count];
    return res;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row <= 5) {
//        return 120;
//    } else {
//        return 120;//64
//    }
    MTVShow *nShow = [self.nextData objectAtIndex:indexPath.row];
    if (nShow == nil) return  84;
    if (nShow != (MTVShow *)[NSNull null]) 
    {
        return 123;
    }   else {
        return  84;
    }
    
}

- (void)clearCell:(TVListCell *)cell
{
    cell.currentShowLabel.text = nil;
    cell.nextShowLabel.text = nil;
    cell.channelNameLabel.text = nil;
    [cell setProgressBarVisible:NO];
    [cell setIconImage:nil];            
}

- (void)_clearCell:(TVCell *)cell
{
    cell.channelNameLabel.text = nil;
    cell.currentShowLabel.text = nil;
    cell.nextShowLabel.text = nil;
    cell.currentTimeLabel.text = nil;
    cell.nextTimeLabel.text = nil;
    [cell setProgressBarVisible:NO];
    [cell setIconImage:nil];  
    [cell.currentCategoryButton setImage:nil forState:UIControlStateNormal];
    [cell.nextCategoryButton setImage:nil forState:UIControlStateNormal];   
    cell.nextTimeLabel.hidden = YES;
    cell.nextShowLabel.hidden = YES;
    cell.nextCategoryButton.hidden = YES;
    cell.nextShowButton.hidden = YES;
    cell.currentCategoryButton.tag = -1;
    cell.nextCategoryButton.tag = -1;
    cell.channelButton.tag = -1;
    cell.currentShowButton.tag = -1;
    cell.nextShowButton.tag = -1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.row >= 0) {
        [self.tableView registerNib:[UINib nibWithNibName:@"TVCell" bundle:nil] forCellReuseIdentifier:@"TVCell"];
        TVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVCell"];         
        [self _configureCell:cell atIndexPath:indexPath];
//        [cell initProgressBar];
        return cell;
    } 
    
    
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


//===============================configureCell===================================================
#pragma mark -

- (void)_configureCell:(TVCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ((selArrays_ == nil) || ([selArrays_ count] <= indexPath.row))
        return;
    
    
    MTVChannel *channel_ = [selArrays_ objectAtIndex:indexPath.row];     
    MTVShow *show = [self.tabData objectAtIndex:indexPath.row];
    //        MTVChannel *channel = show.rTVChannel;
    
    if (show == nil) {
        [self _clearCell:cell];
        return;
    }
    
    //  [cell setTimeFromBeginning:[current timeFromBeginning:cHour withMin:cMin] durationOfShow:[current getDuration]];
    [self _clearCell:cell];
    [cell.currentShowButton setImage:nil forState:UIControlStateNormal];
    [cell.nextShowButton setImage:nil forState:UIControlStateNormal];        
    if (show != (MTVShow *)[NSNull null]) {        
        NSDate *d1 = show.pStart;
        NSDate *d2 = show.pStop;
        NSDate *d3 = [NSDate date];//currDate_;
        NSTimeInterval dur = fabs([d2 timeIntervalSinceDate:d1]/60.0);
        NSTimeInterval cur = [d3 timeIntervalSinceDate:d1]/60.0;
        //            _NSLog(@"dur=%f  cur =%f  name=%@",dur,cur,show.pTitle);        
        [cell setTimeFromBeginning:cur durationOfShow:dur];
        
        cell.currentTimeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", [[ModelHelper shared] hourFromDate:show.pStart], 
                                      [[ModelHelper shared] minFromDate:show.pStart]];
        cell.currentShowLabel.text = [NSString stringWithFormat:@"%@", show.pTitle];
        
        cell.nextShowLabel.text = @"";
        MTVShow *nShow = [self.nextData objectAtIndex:indexPath.row];
        if (nShow != (MTVShow *)[NSNull null]) 
        {
            
            cell.nextTimeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", [[ModelHelper shared] hourFromDate:nShow.pStart], [[ModelHelper shared] minFromDate:nShow.pStart]];            
            cell.nextShowLabel.text = [NSString stringWithFormat:@"%@", nShow.pTitle];
            
            [cell.nextCategoryButton setImage:[ModelHelper categoryImage:nShow.pCategory] forState:UIControlStateNormal]; 
            [cell.nextCategoryButton addTarget:self action:@selector(pressCategory:) forControlEvents:UIControlEventTouchUpInside];
            cell.nextCategoryButton.tag = nShow.pCategory;
            
            cell.nextTimeLabel.hidden = NO;
            cell.nextShowLabel.hidden = NO;
            cell.nextCategoryButton.hidden = NO;
            cell.nextShowButton.hidden = NO;
            
            [cell.nextShowButton addTarget:self action:@selector(pressShow2:) forControlEvents:UIControlEventTouchUpInside];
            cell.nextShowButton.tag = indexPath.row; 
       }        
        
        [cell setProgressBarVisible:isCurrDateToday];
        
        
        MTVChannel *channel = show.rTVChannel;
        if (channel.pID != channel_.pID) {
            _NSLog(@"!!!ERROR CHANNELS!!! (%@) (%@) ",channel.pName,channel_.pName);
            //        abort();
        }
        
        cell.channelNameLabel.text = channel.pName;
        UIImage *im = nil;
        if (channel_.pImage != nil) {
            UIImage *i = [UIImage imageWithData:(NSData*)channel_.pImage];
            im = [SZUtils thumbnailFromImage:i forSize:29 Radius:3];
        }
        [cell setIconImage:im];
        
        [cell.currentCategoryButton setImage:[ModelHelper categoryImage:show.pCategory] forState:UIControlStateNormal];          
        [cell.currentCategoryButton addTarget:self action:@selector(pressCategory:) forControlEvents:UIControlEventTouchUpInside];
        cell.currentCategoryButton.tag = show.pCategory;
        
        [cell.currentShowButton addTarget:self action:@selector(pressShow1:) forControlEvents:UIControlEventTouchUpInside];
        cell.currentShowButton.tag = indexPath.row; 

        
        
        UIButton *but = cell.currentShowButton;
        but.highlighted = NO;
//        but.showsTouchWhenHighlighted = YES;
//        but.reversesTitleShadowWhenHighlighted = YES;
//        but.tintColor = [UIColor redColor];
        
    } else {
        //        _NSLog(@" !! нет прогр для (%@) ",channel_.pName);
        cell.currentShowLabel.text = @"Нет программы";
        
        cell.nextShowLabel.text = @"";
        MTVShow *nShow = [self.nextData objectAtIndex:indexPath.row];
        if (nShow != (MTVShow *)[NSNull null]) 
        {
            
            cell.nextTimeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", [[ModelHelper shared] hourFromDate:nShow.pStart], [[ModelHelper shared] minFromDate:nShow.pStart]];            
            cell.nextShowLabel.text = [NSString stringWithFormat:@"%@", nShow.pTitle];
            
            [cell.nextCategoryButton setImage:[ModelHelper categoryImage:nShow.pCategory] forState:UIControlStateNormal]; 
            [cell.nextCategoryButton addTarget:self action:@selector(pressCategory:) forControlEvents:UIControlEventTouchUpInside];
            cell.nextCategoryButton.tag = nShow.pCategory;

            cell.nextTimeLabel.hidden = NO;
            cell.nextShowLabel.hidden = NO;
            cell.nextCategoryButton.hidden = NO;
            cell.nextShowButton.hidden = NO;
            
            [cell.nextShowButton addTarget:self action:@selector(pressShow2:) forControlEvents:UIControlEventTouchUpInside];
            cell.nextShowButton.tag = indexPath.row;       
        }                
        
        
        [cell setProgressBarVisible:NO]; 
        
        //        [cell setIconImage:nil];
        cell.channelNameLabel.text = channel_.pName;
        UIImage *im = nil;
        if (channel_.pImage != nil) {
            UIImage *i = [UIImage imageWithData:(NSData*)channel_.pImage];
            im = [SZUtils thumbnailFromImage:i forSize:29 Radius:3];
        }
        [cell setIconImage:im];
    }
 
    [cell.channelButton addTarget:self action:@selector(pressChannel:) forControlEvents:UIControlEventTouchUpInside];
    cell.channelButton.tag = indexPath.row;
    
}


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
        MTVShow *nShow = [self.nextData objectAtIndex:indexPath.row];
        if (nShow != (MTVShow *)[NSNull null]) 
        {
            
            cell.nextShowLabel.text = [NSString stringWithFormat:@"%.2d:%.2d %@", [[ModelHelper shared] hourFromDate:nShow.pStart], [[ModelHelper shared] minFromDate:nShow.pStart], nShow.pTitle];
        }                
        
        
        [cell setProgressBarVisible:NO]; 
        
//        [cell setIconImage:nil];
        cell.channelNameLabel.text = channel_.pName;
        UIImage *im = nil;
        if (channel_.pImage != nil) {
            im = [UIImage imageWithData:(NSData*)channel_.pImage];
//          im = [SZUtils thumbnailFromImage:i forSize:37 Radius:5.0];
        }
        [cell setIconImage:im];

    }
    
    
}


#pragma mark -
#pragma mark Table view delegate


- (void)pressChannel:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    if (tag < 0) {
        NSLog(@"EXIT!!!"); 
        return;
    }
//    NSLog(@"press Channel button with tag:%d",tag);
    if (tag < 0) return;
    
    if ([SSVProgressHUD isVisible] || (isCalc_) ) {
        return;
    }
    /// NSString * chanelName = [[TVDataSingelton sharedTVDataInstance] getSelectedChanelNameByIndex:indexPath.row];    
    if ((selArrays_ == nil) || ([selArrays_ count] <= tag))
        return;
    MTVChannel *channel = [selArrays_ objectAtIndex:tag];     
    NSString *chanelName = channel.pName;
    //    NSInteger chId = channel.pID;
    
    if ([delegate respondsToSelector:@selector(channelIsSelected:)])
        [[self delegate] channelIsSelected:chanelName];     
    
}

- (void)pressCategory:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    if (tag < 0) {
        NSLog(@"EXIT!!!"); 
        return;
    }
//    NSLog(@"press Category button with tag:%d",tag);
    
    if ([delegate respondsToSelector:@selector(categorySelected:)])
        [[self delegate] categorySelected:tag];     
    return;
    
}

- (void)pressShow1:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    if (tag < 0) {
        NSLog(@"EXIT!!!"); 
        return;
    }
    if (self.tabData == nil)
        return;
    MTVShow *show = [self.tabData objectAtIndex:tag];
//    NSLog(@"press Show1 button with tag:%d (%@)",tag,show.pTitle);
        
    if ([[self delegate] respondsToSelector:@selector(programIsSelectedMTV:)])
        [[self delegate] programIsSelectedMTV:show]; 
    return;
}

- (void)pressShow2:(id)sender
{
    int tag = ((UIButton*)sender).tag;
    if (tag < 0) {
        NSLog(@"EXIT!!!"); 
        return;
    }
    MTVShow *show = [self.nextData objectAtIndex:tag];
//    NSLog(@"press Show2 button with tag:%d (%@)",tag,show.pTitle);
    
    if ([[self delegate] respondsToSelector:@selector(programIsSelectedMTV:)])
        [[self delegate] programIsSelectedMTV:show]; 
    return;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([SSVProgressHUD isVisible] || (isCalc_) ) {
        return;
    }
    /// NSString * chanelName = [[TVDataSingelton sharedTVDataInstance] getSelectedChanelNameByIndex:indexPath.row];    
    if ((selArrays_ == nil) || ([selArrays_ count] <= indexPath.row))
        return;
    MTVChannel *channel = [selArrays_ objectAtIndex:indexPath.row];     
    NSString *chanelName = channel.pName;
    //    NSInteger chId = channel.pID;
    
    if ([delegate respondsToSelector:@selector(channelIsSelected:)])
        [[self delegate] channelIsSelected:chanelName]; 
    
    //    if ([delegate respondsToSelector:@selector(channelIsSelected:chID:)])    
    //        [[self delegate] channelIsSelected:chanelName chID:chId]; 
    
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
    self.selArrays = nil;
    self.tabData = nil;
    self.nextData = nil;
}

//---------------timer--------------------------
- (void)timerActivity 
{
    if ([SSVProgressHUD isVisible] || (isCalc_) ) {
//        _NSLog(@"-NO_run main_timer-");        
    } else {
//      [self reloadTableData]; 
        
        NSInteger ind =  [[[self.delegate navigationController] tabBarController ] selectedIndex];         
        if (ind == 2) {
            [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];
//            _NSLog0(@"-run main_timer- %d",ind);
            self.slider.currentValue = KHDaySliderValueWithDate([NSDate date]);
        }
        if (ind == 0) {
            [self performSelector:@selector(reloadTableData) withObject:nil afterDelay:0.0];
//            _NSLog0(@"-run favorite_timer- %d",ind);
            self.slider.currentValue = KHDaySliderValueWithDate([NSDate date]);
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

