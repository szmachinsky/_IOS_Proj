//
//  CoreManager.m
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZCoreManager.h"
#import "MTVShow.h"
#import "MTVChannel.h"
#import "SZAppInfo.h"

#import "DownloadChannelDataOperation.h"
#import "DownloadChannelIconOperation.h"

static NSInteger scFiles = 0;

@implementation SZCoreManager
{
    NSManagedObjectContext  *__managedObjectContext;
    NSManagedObjectModel    *__managedObjectModel;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
}


@synthesize file = file_;
@synthesize model = model_;
//@synthesize selChannels = selChannels_;

//@synthesize managedObjectContext = __managedObjectContext;
//@synthesize managedObjectModel = __managedObjectModel;
//@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//---------------------------------------------------------------------------------------
-(MTVChannel*)mtvChannel:(NSManagedObjectContext*)context chanID:(NSInteger)cId 
{
    MTVChannel *channel = nil;
    for (MTVChannel *chan in arrChannels) 
    {
        if (chan.pID == cId) {
            channel = chan;
            break;
        }
    }
    if (!channel) {
        _NSLog(@"!!!ERR channel not found!!! ID=%d",cId);
        return nil; //channel not found!!!
    };

    return channel;
}

-(void)insertImageToChannel:(NSManagedObjectContext*)context chanID:(NSInteger)cId  
                       data:(NSData*)dat  url:(NSString*)url  save:(BOOL)save
{    
    MTVChannel *channel = [self mtvChannel:context chanID:cId];
    if (channel == nil) return;
    
    NSString *str = channel.pLogoUrlLoaded;
    if ([str isEqualToString:url]) 
    {
        if ([dat length] == [channel.pImage length] ) {
            _NSLog(@"!!! LOGO EXIST in (%@)!!!",channel.pName);
            return;
        }
    }
    channel.pLoadImage = [NSDate date];
    channel.pLogoUrlLoaded = url;
//    _NSLog(@"set loaded pict_url (%@)",url);
    channel.pImage = dat;
    if (save) {
        NSError *error=nil;    
        if (![context_ save:&error]) {        
            _NSLog(@"Error saving image - (%@)",[error userInfo]);
        };
    };
}

-(NSInteger)convertCategories:(NSInteger)category
{
    NSInteger res = 0;
    switch (category) {
        case 0:
            res = 0;
            break;
        case 1:
            res = 1;
            break;
        case 2:
            res = 1;
            break;
        case 3:
            res = 2;
            break;
        case 4:
            res = 2;
            break;
        case 5:
            res =3;
            break;
        case 6:
            res = 4;
            break;
        case 7:
            res = 5;
            break;
        case 8:
            res = 6;
            break;
        case 9:
            res = 7;
            break;
            
        default:
            res = 10;
            break;
    }
   return res;
}


-(void)insertShowToChannel:(NSManagedObjectContext*)context chanID:(NSInteger)cId  
                   arrData:(NSArray*)arr  url:(NSString*)url  save:(BOOL)save
{   
    MTVChannel *channel = [self mtvChannel:context chanID:cId];
    if (channel == nil) return;
    
    NSString *sss;
    NSInteger sec;
    
    NSString *str = channel.pProgramUrlLoaded;
    if ([UserTool ifStrArr:str separateStr:@"||" contains:url]) {
//        _NSLog(@"%@  - present in (%@)",url,str);
//        _NSLog(@"!!! %@  - url present ",url);        
        if (channel.pLoaded) {
            if ([[NSDate date] timeIntervalSinceDate:channel.pLoadShow] < 60*6*24*71) {
                _NSLog(@"!!! SHOW EXIST in (%@)!!!",channel.pName);
                return;
            }            
        }                
    } else {
        NSArray *arrSt = [UserTool arrayFromString:str separateStr:@"||"];
        NSMutableArray *arrStr = [NSMutableArray arrayWithArray:arrSt];
        [arrStr addObject:url];
        NSString *strr = [UserTool stringFromArray:arrStr separateStr:@"||"];
        channel.pProgramUrlLoaded = strr;
//        _NSLog(@" (%@) -> (%@) ",str,strr);        
//        _NSLog(@"!?? %@  - new url added ",url);
   }
    
    NSInteger category = channel.pCategories; 
    NSInteger mask = 0x00000001, res = category;
//    int sc=0;
    NSMutableArray *marr = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSDictionary *dict in arr) {
        MTVShow *show = [NSEntityDescription insertNewObjectForEntityForName:@"MTVShow"  
                                                                  inManagedObjectContext:context];            
        sss = [dict objectForKey:@"title"];
        show.pTitle = sss;           
        sss = [dict objectForKey:@"desc"];
        show.pDescription = sss;
        sss = [dict objectForKey:@"category"];
        
        NSInteger cat = [sss intValue];
        if (cat == 5)
            cat = 5;
        NSInteger newCat = [self convertCategories:cat]; //join some categories
        show.pCategory = newCat;  
//        [[SZAppInfo shared] addToCategory:cat]; //add category
        res |= (mask << (newCat % 32));
        
        sss = [dict objectForKey:@"start"];  
        sec = [sss intValue];
        NSDate *dat1 = [NSDate dateWithTimeIntervalSince1970:sec];
        show.pStart = dat1;  
        
        sss = [dict objectForKey:@"stop"];  
        sec = [sss intValue];
        NSDate *dat2 = [NSDate dateWithTimeIntervalSince1970:sec];        
        show.pStop = dat2;  
        
        show.pId = cId;
        show.rTVChannel = channel;        
        [marr addObject:show];
//        if (++sc >= 2)
//            break;
    }    
    channel.pCategories = res;
    
    NSSet *set = [[NSSet alloc] initWithArray:marr]; 
    if (channel.pLoaded) {
        if (fabs([[NSDate date] timeIntervalSinceDate:channel.pLoadShow]) > 60*60*24 * 7) {
            [channel removeRTVShow:channel.rTVShow]; //remove old list of show!!!!
            _NSLog(@"!!! REMOVE OLD SHOW in (%@)!!!",channel.pName);
        }            
    }        
    [channel addRTVShow:set];  
    
    channel.pLoaded = YES;  
    channel.pLoadShow = [NSDate date];
    if (save) {
        NSError *error=nil;    
        if (![context_ save:&error]) {        
            _NSLog(@"Error saving data - (%@)",[error userInfo]);
            _NSLog(@"(%@)",set);
        };
    };
//    _NSLog(@" insert %d programms to channel %d All = %d",[set count],cId,[channel.rTVShow count]);
}

//------------------------beginLoadNewData-------------------------------------------
-(void) _beginLoadNewData:(NSNotification *)note
{
    _NSLog(@">CM_beginLoadNewData! ");
    if (context_) 
        context_=nil;
    context_ = [self createContext];
    scDat = 0; scImg = 0; arrChannels=nil;
    scFiles = 0;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"MTVChannel" inManagedObjectContext:context_];
    [fetchRequest setEntity:ent];    
    NSError *error;
    arrChannels = [context_ executeFetchRequest:fetchRequest error:&error];   
    
//    [[SZAppInfo shared] clearCategories]; //clear all categories
}

-(void) beginLoadNewData:(NSNotification *)note
{ 
  [self performSelectorOnMainThread:@selector(_beginLoadNewData:) withObject:note waitUntilDone:NO];          
}

//------------------------gotNewData-------------------------------------------------
-(void) _gotNewData:(DownloadChannelDataOperation*)op
{ 
    scDat++;  
    NSInteger chId = op.chId;
    NSArray *resData = [op.resData copy]; 
    NSString *url = op.requestUrl;
    BOOL SAVE = NO;
    if ((++scFiles % 100) == 1) {
        SAVE = YES;
//        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateStart" object:nil]]; //show indicator
    }
//    NSString *chDay = op.chDay;
//    _NSLog(@">CM_gotNewData:%d ID=%d Day=%@   %d records url=%@",scDat,chId,chDay,[resData count],url); 
    [self insertShowToChannel:context_ chanID:chId arrData:resData url:url save:SAVE]; //insert show list to channel
}

-(void) gotNewData:(NSNotification *)note
{ 
    [self performSelectorOnMainThread:@selector(_gotNewData:) withObject:[note object] waitUntilDone:NO];          
}

//------------------------gotNewImage-------------------------------------------------
-(void) _gotNewImage:(DownloadChannelIconOperation*)op
{ 
    scImg++;
    NSInteger chId = op.chId;
    imData = [op.imData copy]; 
    NSString *url = op.requestUrl;
//    _NSLog(@">CM_gotNewImage:%d ID=%d ",scImg,chId); 
    BOOL SAVE = NO;
//    if ((++scFiles % 10) == 0)
//        SAVE = YES;
    [self insertImageToChannel:context_ chanID:chId data:imData  url:url save:SAVE]; //insert logo image to channel
}

-(void) gotNewImage:(NSNotification *)note
{ 
    [self performSelectorOnMainThread:@selector(_gotNewImage:) withObject:[note object] waitUntilDone:NO];          
}

//------------------------endLoadNewData-------------------------------------------
-(void) _endLoadNewData
{
    NSError *error;
    if ([context_ hasChanges] && ![context_ save:&error])
    {
        _NSLog(@"Error model saving - error:%@",[error userInfo]);
    } else {
        _NSLog(@">CM_endLoadNewData - SAVE ALL ");
//        MTVChannel *channel = [self mtvChannel:context_ chanID:cId];
//        if (channel == nil) return;        
//        channel.pLoaded = YES;  
//        channel.pDateLoad = [NSDate date];        
    }
    arrChannels=nil; context_ = nil; scDat = 0; scImg = 0; arrChannels=nil;
    scFiles = 0;
}

-(void) endLoadNewData:(NSNotification *)note
{ 
    [self performSelectorOnMainThread:@selector(_endLoadNewData) withObject:nil waitUntilDone:NO];          
}
//---------------------------------------------------------------------------------



- (id)initWithFile:(NSString*)file Model:(NSString*)model
{
    self = [super init];
    if (self) {
        self.file = file;
        self.model = model;
        fileURL_ = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.file];  
        modelURL_ = [[NSBundle mainBundle] URLForResource:self.model withExtension:@"momd"];
        _NSLog(@"init Core manager for: (%@)  (%@)",self.file,self.model);
        _NSLog(@"init Core file for:(%@)  model file:(%@)",fileURL_,modelURL_);
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginLoadNewData:) name:@"CDMBeginLoadNewData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNewData:)  name:@"CDMNewData" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotNewImage:) name:@"CDMNewImage" object:nil];        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endLoadNewData:) name:@"CDMEndLoadNewData" object:nil];        
    }
    return self;
}


#pragma mark - Core Data stack
//==============================================================================
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (__managedObjectContext != nil)
//    {
//        return __managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil)
//    {
//        __managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return __managedObjectContext;
//}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.model withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    if (!__managedObjectModel) {
        _NSLog0(@"Error with  managedObjectModel creation!!!");
//     abort();
    }        
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.file];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        _NSLog0(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSManagedObjectContext *)createContext
{
    NSManagedObjectContext  *_managedObjectContext = nil;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}



//- (void)saveContextWith:(NSManagedObjectContext *)managedObjectContext
//{
//    _NSLog(@"+++SAVE CONTEXT WITH:");    
//    NSError *error = nil;
////  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil)
//    {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
//        {
//           _NSLog(@"Save context error: %@, %@", error, [error userInfo]);
//            abort();
//        } 
//    }
//}


-(MTVChannel*)selChannelByName:(NSString*)name context:(NSManagedObjectContext*)context
{
    if (context == nil)
        context = [self createContext];    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%K LIKE[cd] %@)&&(%K == YES)", 
                         @"pName",name,@"pSelected"];
    [fetchRequest setPredicate:pred];         
    NSError *error;   
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];    
    if (items == nil) {
        _NSLog(@"  error for chn_name %@",name); 
        return nil;
    }
    if ([items count] != 1) {
        _NSLog(@"  error for chn_name %@  count=%d",name,[items count]); 
        return nil;
    }
    return [items objectAtIndex:0];    
}


//========================= arrayOfSelectedChannels ==================================
+ (NSArray*)arrayOfSelectedChannels:(NSManagedObjectContext*)_context_; 
{   
@synchronized(self) {
//    NSManagedObjectContext *context__ = context;
//    if (context__ == nil)
//        context__ = [self createContext];    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];    
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"pName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,nil]];    
    NSError *error;    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"%K == YES", @"pSelected"];
    [fetchRequest setPredicate:pred1];         
    NSArray *items = [_context_ executeFetchRequest:fetchRequest error:&error];    
    //    int sc = 0;
    //    for (MTVChannel *managedObject in items) {
    //        sc++;
    //        NSSet *shw = managedObject.rTVShow;
    //        _NSLog(@" sel_obj_%d id=%d name=%@ order=%f sh=%d",sc,managedObject.pID,managedObject.pName,
    //              managedObject.pOrderValue,[shw count]); 
    //    }        
    return items;
}   
}

//========================= arrayOfNoSortSelectedChannels ==================================
+ (NSArray*)arrayOfNoSortSelectedChannels:(NSManagedObjectContext*)_context_ 
{   
    //    NSManagedObjectContext *context__ = context;
    //    if (context__ == nil)
    //        context__ = [self createContext];    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];    
    NSError *error;    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"%K == YES", @"pSelected"];
    [fetchRequest setPredicate:pred1];         
    NSArray *items = [_context_ executeFetchRequest:fetchRequest error:&error];    
    return items;
}

+ (NSInteger)numberOfSelectedChannels:(NSManagedObjectContext*)_context_
{
//    if (_context_ == nil)
//        _context_ = [self createContext];
//        _context_ = self->context_;
    
    NSArray *items = [[self class] arrayOfNoSortSelectedChannels:_context_];
    if (items == nil) 
        return 0;
    return [items count];
}

//========================= arrayOfFavoriteChannels ==================================
+ (NSArray*)arrayOfFavoriteChannels:(NSManagedObjectContext*)_context_; 
{   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];    
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:@"pOrderValue" ascending:YES];
    NSSortDescriptor *sd2 = [NSSortDescriptor sortDescriptorWithKey:@"pName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sd1,sd2,nil]];    
    NSError *error;    
//    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K == YES)",@"pFavorite", @"pSelected"];
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(%K == YES)",@"pFavorite"];
    [fetchRequest setPredicate:pred1];         
    NSArray *items = [_context_ executeFetchRequest:fetchRequest error:&error];    
    return items;
}

//========================= arrayOfFavoriteChannels ==================================
+ (NSArray*)arrayOfNoSortFavoriteChannels:(NSManagedObjectContext*)_context_ 
{   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MTVChannel"];    
    NSError *error;    
//  NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(%K == YES)&&(%K == YES)",@"pFavorite", @"pSelected"];
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(%K == YES)",@"pFavorite"];
    [fetchRequest setPredicate:pred1];         
    NSArray *items = [_context_ executeFetchRequest:fetchRequest error:&error];    
    return items;
}

+ (NSInteger)numberOfFavoriteChannels:(NSManagedObjectContext*)_context_
{
    NSArray *items = [[self class] arrayOfNoSortFavoriteChannels:_context_];
    if (items == nil) 
        return 0;
    return [items count];
}


//=========================== saveForContext =========================================
+ (void)saveForContext:(NSManagedObjectContext *)context
{
    _NSLog(@"+++SAVE FOR CONTEXT");    
    NSError *error = nil;
    if (context != nil)
    {
        if ([context hasChanges] && ![context save:&error])
        {
            _NSLog0(@"Save for context error: %@, %@", error, [error userInfo]);
//            abort();
        } 
    }
    
}

//=========================== deleteAllObjectsIn =========================================
+ (NSInteger) deleteAllObjectsIn:(NSString *)entity forContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [fetchRequest setEntity:ent];    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    NSInteger sc=0;
    for (NSManagedObject *managedObject in items) {
//      _NSLog(@"%@ object deleted",entityDescription);
        [context deleteObject:managedObject];
        sc++;
    }
    if (![context save:&error]) {
        _NSLog(@"Error deleting %@ - error:%@",entity,error);
    }
//    _NSLog(@"+++DELETE (CLEAR) FOR CONTEXT_1 :%d objects in (%@)",sc,entity); 
    return sc;
}

+(void)deleteModelforContext:(NSManagedObjectContext *)managedObjectContext
{
//    _NSLog(@"--delete context 1--");  
    NSError *error;
    // retrieve the store URL
    NSURL * storeURL = [[managedObjectContext persistentStoreCoordinator] URLForPersistentStore:[[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject]];
    // lock the current context
    [managedObjectContext lock];
    [managedObjectContext reset];//to drop pending changes
    //delete the store from the current managedObjectContext
    if ([[managedObjectContext persistentStoreCoordinator] removePersistentStore:[[[managedObjectContext persistentStoreCoordinator] persistentStores] lastObject] error:&error])
    {
        // remove the file containing the data
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
        //recreate the store like in the  appDelegate method
        [[managedObjectContext persistentStoreCoordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];//recreates the persistent store
    }
    [managedObjectContext unlock];
//    _NSLog(@"--delete context 2--");  
}


//=========================== deleteAllObjectsWithSaveIn =========================================
+ (NSDictionary*) deleteAllObjectsWithSaveIn:(NSString *)entity forContext:(NSManagedObjectContext *)context
{
//    _NSLog(@"+++DELETE (DICT)_1");     
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:entity inManagedObjectContext:context];
    [fetchRequest setEntity:ent];    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:500];
    NSString *s1;
    NSString *s2;
    NSInteger sc=0;
    for (MTVChannel *managedObject in items) {
//        _NSLog(@" object deleted:%d %d",managedObject.pID,managedObject.pSelected);
        if ( managedObject.pSelected ) {
            managedObject.pOrderValue = 0.0123;
            s1 = [NSString stringWithFormat:@"%f__%@",managedObject.pOrderValue,managedObject.pFavorite?@"1":@"0"];
            s2 = [NSString stringWithFormat:@"%d",managedObject.pID];
            [dic setObject:s1 forKey:s2];             
//            _NSLog(@" object deleted:%d %d",managedObject.pID,managedObject.pSelected);
        }
//        [context deleteObject:managedObject];
//        if (![context save:&error]) {
//            _NSLog(@"Error deleting1 %@ - error:%@",entity,error);
//        }
        sc++;
    }
    [[self class] deleteModelforContext:context];
//    _NSLog(@"+++DELETE (DICT)_2"); 
    if (![context save:&error]) {
        _NSLog(@"Error deleting2 %@ - error:%@",entity,error);
    }
    _NSLog0(@"+++DELETED FOR CONTEXT :%d objects in (%@)",sc,entity); 
//    _NSLog(@"+++  save dic:(%@)",dic);     
    return [[NSDictionary alloc] initWithDictionary:dic];
}


#pragma mark - Fetched results controller
//==================================================================================
+ (NSFetchedResultsController *)ftResultsController:(UITableViewController <NSFetchedResultsControllerDelegate>*)tcont 
                                         ManagedObj:(NSManagedObjectContext*)context  
                                             Entity:(NSString*)ent  
                                            SortKey:(NSString*)sortKey  
                                 SectionNameKeyPath:(NSString*)section 
                                          CacheName:(NSString*)cache 
                                       SearchString:(NSString*)search 
                                          Ascending:(BOOL)asc; 
{ 
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:ent inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:asc];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
//    NSString *search = @"НТ";
    if ([search length] > 0) {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%K BEGINSWITH[cd] %@)", @"pName",search];    
        [fetchRequest setPredicate:pred]; 
    }
    
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:section cacheName:cache];
    
    aFetchedResultsController.delegate = tcont;
///    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
	    _NSLog0(@"Unresolved error %@, %@", error, [error userInfo]);
//	    abort();
	}
    
    return aFetchedResultsController;
}    




@end



