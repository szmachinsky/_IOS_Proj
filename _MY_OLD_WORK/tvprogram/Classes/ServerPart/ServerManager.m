//
//  ServerManager.m
//  TVProgram
//
//  Created by Irina on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerManager.h"
#import "Reachability.h"
#import "ChannelListOperation.h"
#import "DownloadOperation.h"
#import "DownloadChannelDataOperation.h"
#import "DownloadChannelIconOperation.h"
#import "TVDataSingelton.h"
#import "TVProgramAppDelegate.h"
#import "Channel.h"
#import "CommonFunctions.h"

#import "SSVProgressHUD.h"

#import "SZAppInfo.h"
#import "MTVChannel.h"

//#define kUrlChannelListJson @"http://tvprogram.selfip.info/data/index.json.bz2"
NSString * const kUrlChannelListJson = @"http://tvprogram.selfip.info/data/index.json.bz2";


static ServerManager *_sharedServerManager=nil;


@interface ServerManager()
- (void) reachabilityChanged: (NSNotification* )note;
- (void)startDataDownload;
@end



@implementation ServerManager
@synthesize maskForDateLoading = maskForDateLoading_;


//--------------------------- init --------------------------------------------
- (id)init {
    if (self = [super init]) {
        internetReach = [Reachability reachabilityForInternetConnection];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
        [internetReach startNotifier];
        
        prevSelectedChannelNames = [NSMutableArray arrayWithArray:[[TVDataSingelton sharedTVDataInstance] getSelectedChannelsName]];
    }
    return self;
}

//------------------------------------------------------------------------------
+ (ServerManager*)sharedManager
{// static AppInfo *_sharedAppInfo=nil;
    @synchronized(self) {
        if(_sharedServerManager == nil) {
//            _NSLog(@"-initialize_Shared- _sharedServerManager");
            _sharedServerManager = [[ServerManager alloc] init];
        }
    }    
    return _sharedServerManager;    
}

//--------------------------- stopCheckingState --------------------------------------------
- (void)stopCheckingState {
    if (myTicker != nil) {
        [myTicker invalidate];
        myTicker = nil;
    }
}

//--------------------------- checkStates --------------------------------------------
- (void)checkStates
{
    static BOOL refreshUpdate = NO;
    //NSLog(@"State:%d aQueue operationCount %d", [TVDataSingelton sharedTVDataInstance].currentState, [aQueue operationCount]);
    switch ([TVDataSingelton sharedTVDataInstance].currentState) 
    {
        case eIndexDownload:
        {
            // index.json was downloaded
            [[TVDataSingelton sharedTVDataInstance] setIndexDownloadDate];
            
            [aQueue cancelAllOperations];
            ChannelListOperation *anOp = [[ChannelListOperation alloc] init];
            [TVDataSingelton sharedTVDataInstance].currentState = eIndexParsing;
            [anOp start];
        }
            break;
        case eIndexDownloadError: 
        {
            [self stopCheckingState];   
            [TVDataSingelton sharedTVDataInstance].currentState = eNeedsIndexDownload;
        }
            break;
        case eIndexParse:
            // new alert is shown from "downloadAllChannelsData", so need to remove previos alert
/// zs      [(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate stopUpdate:nil];
            [(TVProgramAppDelegate *)[UIApplication sharedApplication].delegate updateComplete:nil];
            [self downloadAllChannelsData:NO];
            break;
        case eChannelsDataDownloading:
        {
            NSInteger operations = [aQueue operationCount];
            if ([SZAppInfo shared].stopLoading) {
                _NSLog1(@"==detect cancel:[%d]",operations);
            }    
            
            if (operations > filesNumber) {
                filesNumber = operations;
                prevFilesNumber = filesNumber;
                initFilesNumber = filesNumber;
                _NSLog1(@"==%d",filesNumber);
                [SSVProgressHUD setProgress:0.0]; //init
                t1 = getTickCount();
            }
            if (operations < filesNumber){
               filesNumber = operations;
                if (filesNumber < prevFilesNumber) { //(prevFilesNumber - 10)) {
                     prevFilesNumber = filesNumber;
                    float delta = initFilesNumber - filesNumber;
                    float progress = delta/initFilesNumber;
                    [SSVProgressHUD setProgress:progress];                    
//                    _NSLog1(@"=%d  %f",filesNumber,progress);
                }                   
            }
                
            if ([aQueue operationCount] == 0) 
            {
                refreshUpdate = NO;
                t2 = getTickCount();
                if ([SZAppInfo shared].stopLoading) {
                    _NSLog1(@"=================================== STOP BY CANCEL (%llu s)=================================================",(t2 - t1)/1000);
                    [SZAppInfo shared].stopLoading = NO;
//                    return;
                } else {
                    _NSLog1(@"===================================PROGRAMM DOWNLOAD COMPLETED (%llu s)======================================",(t2 - t1)/1000);                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CDMEndLoadNewData" object:nil]];    
                [SSVProgressHUD setProgress:1.0];
                
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
                
                [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"DownloadingDataHasCompleted" object:nil]]; //to GuideViewController
                
                [TVDataSingelton sharedTVDataInstance].currentState = eNone;
                
                [self stopCheckingState];
                filesNumber = 0;
                prevFilesNumber = 0; 
             }
            else {
                if ([aQueue isSuspended]) {
                    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
                    if (netStatus != NotReachable) {
                        [aQueue setSuspended:NO];
                        if (!refreshUpdate) {
                            refreshUpdate = YES;
                            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]];
                        }
                        
                    }
                }
            }
        }
            break;
        case eChannelsDownloadError:
        {
            //[self stopCheckingState];
            refreshUpdate = NO;
            [TVDataSingelton sharedTVDataInstance].currentState = eChannelsDataDownloading;
        }
            break;
        default:
            break;
    }
}


//--------------------------- showNoInternetAlert --------------------------------------------
- (void)showNoInternetAlert 
{
    currAlert = [[UIAlertView alloc] initWithTitle: @"Нет интернет соединения"  
                                           message: @"Для корректной работы приложения в данный момент необходимо интернет доступ.  Пожалуйста, проверьте ваше интернет соединение."  
                                          delegate: self  
                                 cancelButtonTitle: @"Ok"  
                                 otherButtonTitles: nil];      
    [currAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    currAlert = nil;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
}

//--------------------------- reachabilityChanged --------------------------------------------
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    StatesEnum currentState = [TVDataSingelton sharedTVDataInstance].currentState;
    _NSLog(@"reachabilityChanged STATE:%d", currentState);
    
    BOOL wifiOnly = [[TVDataSingelton sharedTVDataInstance] getWiFiOnly];
    BOOL isReachable = netStatus != NotReachable && !(wifiOnly && netStatus != ReachableViaWiFi);
    if (currentState == eNeedsIndexDownload && isReachable) {
        // download index.json
        [self startDataDownload];
    }
    else if ((currentState == eChannelsDataDownloading || currentState == eChannelsDownloadError) && isReachable) {
        if ([aQueue isSuspended] || aQueue.operationCount != 0) {
            [aQueue setSuspended:NO];
            
            myTicker = [NSTimer scheduledTimerWithTimeInterval: 0.50 //0.5
                                                        target: self
                                                      selector: @selector(checkStates)
                                                      userInfo: nil
                                                       repeats: YES];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]];
            
        }
    }
    else if (netStatus == NotReachable && (currentState == eChannelsDownloadError || currentState == eIndexDownloading || currentState == eChannelsDataDownloading)) {
        [self showNoInternetAlert];
    }
}

#pragma mark interface methods
//--------------------------- updateChannelsData --------------------------------------------
-(void) updateChannelsData
{
    //TODO
    isFromSettings = YES;
    [self start:[[TVDataSingelton sharedTVDataInstance] getWiFiOnly]];
}

//--------------------------- start --------------------------------------------
-(void) start:(BOOL)wifiOnly
{
    //[Reachability reachabilityWithHostName:@"tvprogram.selfip.info"];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    if (netStatus == NotReachable || (wifiOnly && netStatus != ReachableViaWiFi)) {
        [self showNoInternetAlert];
    }
    else {
        [self startDataDownload];
    }
}

//--------------------------- PrepeareToDownload --------------------------------------------
- (void)PrepeareToDownload
{
    
    aQueue = [[NSOperationQueue alloc] init];
    aQueue.maxConcurrentOperationCount = 8; //8
    myTicker = [NSTimer scheduledTimerWithTimeInterval: 0.2 //0.5
                                                target: self
                                              selector: @selector(checkStates)
                                              userInfo: nil
                                               repeats: YES];
    
    // dismiss alert
    if (currAlert != nil) {
        [currAlert dismissWithClickedButtonIndex:currAlert.cancelButtonIndex animated:NO];
    }
}

//--------------------------- startDataDownload --------------------------------------------
// download index-json file
-(void)startDataDownload
{
    [self PrepeareToDownload];   
    if (isFromSettings == YES)
    {
///zs   [self downloadAllChannelsData:YES];
        [self downloadAllChannelsData:NO];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]];
        
        //get index.json file
        [TVDataSingelton sharedTVDataInstance].currentState = eIndexDownloading;
        DownloadOperation *anOp = [[DownloadOperation alloc] initWithString:kUrlChannelListJson];
        [anOp start];
    }
}

//--------------------------- downloadAllChannelsData ----------------------------------------
-(void) downloadAllChannelsData:(BOOL)afterNewChannelsSelection 
{
    
//    NSMutableArray *channelsToDownload = [NSMutableArray array];
//    NSMutableArray *selectedChannels = [[TVDataSingelton sharedTVDataInstance] getSelectedChannelsName];
//    NSMutableArray *channelsToDelete = [NSMutableArray arrayWithArray:prevSelectedChannelNames];    
//    if (afterNewChannelsSelection) 
//    {
//        for (NSString *channelName in selectedChannels) {
//            if (![prevSelectedChannelNames containsObject:channelName]) {
//                [channelsToDownload addObject:channelName];
////                _NSLog(@" channel to add:(%@)",channelName);            
//            }
//            else {
//                [channelsToDelete removeObject:channelName];
/////                _NSLog(@" channel to delete:(%@)",channelName);            
//            }
//        }
//    }
//    else {
//        [channelsToDelete removeAllObjects];
//        channelsToDownload = selectedChannels;
//        _NSLog(@" load all selected channels[%d]",[channelsToDownload count]);            
//    }    
//    prevSelectedChannelNames = [NSMutableArray arrayWithArray:selectedChannels];
    

    
    NSManagedObjectContext *context = [[[SZAppInfo shared] coreManager] createContext];
    NSArray *selArr = [SZCoreManager arrayOfSelectedChannels:context];
    _NSLog(@"============= selected_array have %d elements =============",[selArr count]);
    
    if ([selArr count] > 0) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"CDMBeginLoadNewData" object:nil]];
    }
    
    BOOL isDownloading = NO;
    NSInteger scProgr = 0, scImages = 0, scChanells = 0;
//    _NSLog(@"******* start_load_channells[%d]********", [channelsToDownload count]);
        
    
//    for (NSString *channelName in channelsToDownload) 
//    {
//        Channel *ch = [[TVDataSingelton sharedTVDataInstance] getChannel:channelName]; 
//        
//        MTVChannel *channel = nil;
//        NSString *ProgramUrlLoaded = nil;
//        NSString *LogoUrlLoaded = nil;
//        NSString *LogoUrl = nil;
//        NSString *name = nil;
//        BOOL toLoad = NO;
//        for (channel in selArr) {
//            if ([channel.pName isEqualToString:channelName])
//            {
//                ProgramUrlLoaded = channel.pProgramUrlLoaded;
//                LogoUrl = channel.pLogoUrl;
//                LogoUrlLoaded = channel.pLogoUrlLoaded;
//                name = channel.pName;
////              _NSLog(@"name found! (%@) (%@) (%@)",channelName,ProgramUrlLoaded,LogoUrl);
//                break;
//            }
//        }
          
        
    MTVChannel *channel = nil;
    NSMutableArray *programToLoad = [[NSMutableArray alloc] init];
    NSMutableArray *logoToLoad =  [[NSMutableArray alloc] init];
    for (channel in selArr) 
    {
//        NSString *name = channel.pName;
        NSString *ProgramUrlLoaded = channel.pProgramUrlLoaded;
        NSString *ProgramUrl = channel.pProgramUrl;
        NSString *LogoUrlLoaded = channel.pLogoUrlLoaded;
        NSString *LogoUrl = channel.pLogoUrl;
        BOOL toLoad = NO;
        
        // programs data
        NSInteger scPr=0;
        
        NSArray *urlss = [UserTool arrayFromString:ProgramUrl separateStr:@"||"];        
//      NSMutableDictionary * urls = [ch getUrlsToData];
//      for(NSString * urll in [urls allValues])
        for(NSString * urll in urlss)
        {
            NSString *url = [urll lowercaseString];
            if ([url length] < 10)
                break;
                        
            NSString *lastPaths = [url lastPathComponent];
            NSRange range = [lastPaths rangeOfString:@"_"];
            if (range.location > 100) 
                break;
            NSRange newRange = NSMakeRange(range.location + 1, 8);
            NSString *start = [lastPaths substringWithRange:newRange];
            [[TVDataSingelton sharedTVDataInstance] addDate:start];
            
            BOOL byMask = YES;
            if (maskForDateLoading_ != nil) {
                byMask = [maskForDateLoading_ containsObject:start];
                if (byMask) {
//                    _NSLog0(@"by_mask:%d  (%@) in (%@)",byMask,start,url);
                }
            }
                    
            BOOL bProg = [UserTool ifStrArr:ProgramUrlLoaded separateStr:@"||" contains:url]; //zs
            if ((!bProg)&&(byMask)) {
                DownloadChannelDataOperation *downloadOp = [[DownloadChannelDataOperation alloc] initWithString:url];
                downloadOp.toLOAD = YES;
                toLoad = YES;
//                [aQueue addOperation:downloadOp];
                [programToLoad addObject:downloadOp];
                isDownloading = YES;
                scProgr++; scPr++;
//                _NSLog(@" will load program (%@)",url);
            } else {
//                _NSLog(@"* don't load program (%@)",url);
            }
        }
        
        //icon for channel
        NSString *url = [LogoUrl lowercaseString]; //[[ch iconName] lowercaseString];
        BOOL bLogo = [LogoUrlLoaded isEqualToString:url];
        if (!bLogo) {
            DownloadChannelIconOperation *downloadIcon = [[DownloadChannelIconOperation alloc] initWithString:url];
            downloadIcon.toLOAD = YES;
            toLoad = YES;
//            [aQueue addOperation:downloadIcon];
            [logoToLoad addObject:downloadIcon];
            isDownloading = YES;
            scImages++;
//            _NSLog(@" will_load_icon for:%@  (%@)", name,url);
        } else {
//            _NSLog(@"** don't load image (%@)",url);            
        }

        if (toLoad) {
            scChanells++;
//            _NSLog(@" start_load_channel:(%@)  toLoad:%d files", channelName,scPr); 
        }
    }
    
    _NSLog(@"============== end_load_channells[%d]** chan=%d (progs=%d img=%d) ==============", [selArr count],scChanells,scProgr,scImages);
    
    if (isDownloading) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]]; //show indicator
        [aQueue addOperations:logoToLoad waitUntilFinished:NO];
        [aQueue addOperations:programToLoad waitUntilFinished:NO];
    } else {
        
    }
    
    self.maskForDateLoading = nil;
        
//    for (NSString *channelName in channelsToDelete) {
//        [[TVDataSingelton sharedTVDataInstance] deleteChannelData:channelName];
//    }
    filesNumber = 0;
    prevFilesNumber = 0;        
    [TVDataSingelton sharedTVDataInstance].currentState = ([TVDataSingelton sharedTVDataInstance].currentState != eChannelsDownloadError && isDownloading == YES)
    ? eChannelsDataDownloading : eNone;
    
    if (!isDownloading) {
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
        [self stopCheckingState];
    }
    
    isFromSettings = NO;
}

//--------------------------- ifDataShouldBeDownloaded --------------------------------------------
-(BOOL) ifDataShouldBeDownloaded
{
    BOOL bRes = NO;
    NSManagedObjectContext *context = [[[SZAppInfo shared] coreManager] createContext];
//  NSArray *selArr = [SZCoreManager arrayOfSelectedChannels:context];
    NSInteger numberOfSelChannels = [SZCoreManager numberOfSelectedChannels:context];
    
    //if this is first time
//  if([[TVDataSingelton sharedTVDataInstance] getNumberOfSelectedChannels] == 0)
    if (numberOfSelChannels == 0)
    {
        bRes = YES;
    }
    else
    {
        // get the day of week when data should be downloaded
        NSMutableArray *days = [[TVDataSingelton sharedTVDataInstance] getDownloadDates];
        NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        
        // check if file was already downloaded today
        NSString *dayStr = [formatter stringFromDate:[NSDate date]];
        NSString *lastDateStr = [[TVDataSingelton sharedTVDataInstance] getLastDateIdexDownload];
        
        NSDate *now = [NSDate date];
        NSDate *lastDate = convertStringToDate(lastDateStr);
        
        if (![dayStr isEqualToString:lastDateStr] || diffWeeks(now, lastDate)) {
            // if not - check if it should be downloaded
            NSString *day = getWeekDay(dayStr);
            NSRange range = [day rangeOfString:@","];
            NSString *weekDay = [day substringToIndex:range.location];
            if ([now timeIntervalSinceDate:lastDate] >= 7*24*60*60 || [days containsObject:weekDay]) {
                bRes = YES;
            }
        }
    }
    return bRes;
}

@end
