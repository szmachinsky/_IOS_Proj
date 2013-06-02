//
//  CreateChannels.m
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateChannels.h"
#import "MTVChannel.h"
#import "MTVShow.h"



@implementation CreateChannels
@synthesize managedObjectContext = __managedObjectContext;          //zs
//@synthesize persistentStoreCoordinator = __persistentStoreCoordinator; //zs

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString*)pathDocDir 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"]; 
    return documentPath;     
}


- (NSString *)pathInDocDir:(NSString*)fileName 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"]; 
    return [documentPath stringByAppendingPathComponent:fileName];     
}


//========================thumbnailFromImage===================================
#pragma mark Image's methods
+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz Radius:(float)radius
{
    float mx = sz;
    float my = sz;
    float x = imageFrom.size.width;
    float y = imageFrom.size.height;
    float d = x / y;
    if (d >= 1) {
        my = my / d;
    } else {
        mx = mx * d;
    }    
    CGRect imageRect = CGRectMake(0, 0, roundf(mx),roundf(my)); 
    UIGraphicsBeginImageContext(imageRect.size);    
    
    if (radius > 0.0) {
        UIBezierPath *bez = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:radius];
        [bez addClip];
    }
    
    // Render the big image onto the image context 
    [imageFrom drawInRect:imageRect];    
    // Make a new one from the image contextpickerCell_.cellImage.image    
    UIImage *imgTo = UIGraphicsGetImageFromCurrentImageContext();
    
    //  NSData *data1 = UIImageJPEGRepresentation(imageFrom, 0.75);
    //  NSData *data2 = UIImageJPEGRepresentation(imgTo, 0.75);
    //    NSData *data1 = UIImagePNGRepresentation(imageFrom);
    //    NSData *data2 = UIImagePNGRepresentation(imgTo);    
    //    int i1 = data1.length;
    //    int i2 = data2.length;
    //    _NSLog(@" image from %d to %d",i1,i2);
    
    // Clean up image context resources 
    UIGraphicsEndImageContext();    
    return imgTo;
}


- (MTVShow*)addRandomShowFor:(NSManagedObjectContext *)_context channel:(MTVChannel *)chn seconds:(NSTimeInterval)sec
{
    //static int idd = 1;
    static int sc = 1;
    
    MTVShow *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MTVShow"  
                                                              inManagedObjectContext:_context];    
    newManagedObject.pCategory = (sc++ % 5) + 1; 
    newManagedObject.pDescription = @" will show something";
    newManagedObject.pTitle = [NSString stringWithFormat:@"программа_%d",sc];    

    NSDate *dat1 = [NSDate dateWithTimeIntervalSinceNow:sec];
    newManagedObject.pStart = dat1;  
    
    NSDate *dat2 = [NSDate dateWithTimeIntervalSinceNow:sec+3600];
    newManagedObject.pStop = dat2;  
       
    newManagedObject.rTVChannel = chn;
    
    //    _NSLog(@" >> (%@) for %d days",newManagedObject.pName,[arr count]); 
    //    _NSLog(@"(%@)",sarr);
    return newManagedObject;
}



+ (void)addRandomChannel:(NSManagedObjectContext *)_context 
{
    static int idd = 1000;
    MTVChannel *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MTVChannel"  
                                                                 inManagedObjectContext:_context];    
    newManagedObject.pLoaded = NO; 
    newManagedObject.pSelected = NO;
    newManagedObject.pFavorite = NO;
    newManagedObject.pOrderValue = 0;
    newManagedObject.pID = idd++;    
    newManagedObject.pName = [NSString stringWithFormat:@"000__%d",idd];  
    
    newManagedObject.pLoadShow = [NSDate date];  
    newManagedObject.pLoadImage = [NSDate date];  
    
    newManagedObject.pProgramUrl = @"..........";
    
    newManagedObject.pLogoUrl =  @".........."; 
    
//    NSMutableArray *marr = [[NSMutableArray alloc] init];
//    for (int i=1; i<=20; i++) {
//        MTVShow *show = [self addShowFor:newManagedObject];
//        //        [newManagedObject.mTvShow setByAddingObject:show];
//        [marr addObject:show];
//    }
//    NSSet *set = [[NSSet alloc] initWithArray:marr];
    newManagedObject.rTVShow = nil;    
    
    _NSLog(@" >> add random (%@)",newManagedObject.pName); 
    //    _NSLog(@"(%@)",sarr);
}


- (NSArray*)requestForEntity:(NSString*)entity Context:(NSManagedObjectContext*)_context;
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entity inManagedObjectContext:_context];
    NSError *err=nil;
    NSArray *res = [_context executeFetchRequest:request error:&err];
    if (err) {
        _NSLog(@"ERROR"); return nil;
    };
//    NSMutableArray *result = [[NSMutableArray alloc] initWithArray:res];
    _NSLog(@" request for (%@) =%d",entity,[res count]);
    return res;
}



- (void) deleteAllObjects: (NSString *)entityDescription  
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    int sc=0;
    for (NSManagedObject *managedObject in items) {
//        _NSLog(@"%@ object deleted",entityDescription);
        [__managedObjectContext deleteObject:managedObject];
        sc++;
    }
    if (![__managedObjectContext save:&error]) {
        _NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    _NSLog(@" !!! %d  object deleted in (%@ )",sc,entityDescription);
    
}

//- (void)eraseData
//{
//        //Erase the persistent store from coordinator and also file manager.
//    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
//    NSError *error = nil;
//    NSURL *storeURL = store.URL;
//    [self.persistentStoreCoordinator removePersistentStore:store error:&error];
//    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];                
//    _NSLog(@">>Data Reset");        
//    //Make new persistent store for future saves   (Taken From Above Answer)
//    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//            // do something with the error
//        _NSLog(@"Error deleting :%@",error);
//    }        
//}

- (void)dataSave:(NSManagedObjectContext *)_context 
{
    NSError *error;
    if ([_context hasChanges] && ![_context save:&error])
    {
        _NSLog0(@"Unresolved error for SAVE!!! (%@), (%@)", error, [error userInfo]);
//        abort();
    }     
}

//----------------------------------addChannel----------------------------------------------
- (void)addChannel:(NSDictionary*)dic  mergeDict:(NSDictionary*)mDict context:(NSManagedObjectContext *)_context 
{
    //    static int idd = 1000;
    MTVChannel *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MTVChannel"  
                                                                 inManagedObjectContext:_context]; 
    NSString *str,*strd;
    NSArray *arr;
    newManagedObject.pLoaded = NO; 
    newManagedObject.pSelected = NO;
    newManagedObject.pFavorite = NO;
    newManagedObject.pOrderValue = 0;
    newManagedObject.pImage = nil;
    newManagedObject.pCategories = 0;
    
    NSString *name = [dic objectForKey:@"name"];
    newManagedObject.pName = [[name lowercaseString] capitalizedString];  
    
    int idd = [[dic objectForKey:@"id"] intValue];
    newManagedObject.pID = idd;
    if (mDict) {
        str = [NSString stringWithFormat:@"%d",idd];
        strd = [mDict objectForKey:str];
        if (strd) {
            newManagedObject.pSelected = YES; 
            arr = [strd componentsSeparatedByString:@"__"];
            NSString *ars0 = [arr objectAtIndex:0];
            if (ars0) {
                double d = [ars0 doubleValue]; 
                newManagedObject.pOrderValue = d;
            }
            NSString *ars1 = [arr objectAtIndex:1];
            if (ars1) {
                int i = [ars1 intValue]; 
                if (i)
                    newManagedObject.pFavorite = YES;
            }
//            _NSLog(@" set LOADED %d(%@) = %d %f %d",idd,newManagedObject.pName,newManagedObject.pSelected,
//                  newManagedObject.pOrderValue,newManagedObject.pFavorite);
        }
    }
    
    NSInteger val = [[dic objectForKey:@"updated"] intValue];
    NSDate *dat = [NSDate dateWithTimeIntervalSince1970:val];
    newManagedObject.pUpdated = dat;  
    
    newManagedObject.pLoadShow = nil;
    newManagedObject.pLoadImage = nil;
    
    arr = [dic objectForKey:@"url"];
    NSString *sarr = [UserTool stringFromArray:arr separateStr:@"||"];//[arr componentsJoinedByString:@"&&"];
    newManagedObject.pProgramUrl = [sarr lowercaseString];
    
    newManagedObject.pLogoUrl =  [[dic objectForKey:@"logo"] lowercaseString]; 
    
 //    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:seconds];
//    NSTimeInterval sec = - (3600*5);
//    NSMutableArray *marr = [[NSMutableArray alloc] init];
//    for (int i=1; i<=10; i++) {
//        MTVShow *show = [self addRandomShowFor:_context channel:newManagedObject seconds:sec];
//        show.pId = newManagedObject.pID;
//        sec +=3600;
//        [marr addObject:show];
//    }
//    NSSet *set = [[NSSet alloc] initWithArray:marr];    
//    newManagedObject.rTVShow = set;    
    
    //    _NSLog(@" >> (%@) for %d days",newManagedObject.pName,[arr count]); 
    //    _NSLog(@"(%@)",sarr);
}


//----------------------------------parseFile----------------------------------------------
- (void)parseFile:(NSString*)file 
{
    NSString *filePath = [self pathInDocDir:file];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!exist)
        return;
    
    NSError *err;
    NSData *dat = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray *data = [NSJSONSerialization JSONObjectWithData:dat options:kNilOptions error:&err];        
    _NSLog(@" will parse %d records",[data count]); 
    
//    NSArray *arr1 = [self requestForEntity:@"MTVChannel" Context:self.managedObjectContext];
//    NSArray *arr2 = [self requestForEntity:@"MTVShow" Context:self.managedObjectContext];
    
    [self dataSave:self.managedObjectContext]; 
    
    [self deleteAllObjects:@"MTVChannel"];
    
    [self dataSave:self.managedObjectContext];    
//    [self eraseData];   
    
//    NSArray *arr3 = [self requestForEntity:@"MTVChannel" Context:self.managedObjectContext];
//    NSArray *arr4 = [self requestForEntity:@"MTVShow" Context:self.managedObjectContext];
        
    for (NSDictionary *dic in data) {
        [self addChannel:dic mergeDict:nil context:self.managedObjectContext];
    }
    [self dataSave:self.managedObjectContext];    
}


//----------------------------------parseFile----------------------------------------------
- (void)parseFile:(NSString*)file mergeDict:(NSDictionary*)mDict
{
    NSString *filePath = [self pathInDocDir:file];
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!exist)
        return;
    
    NSError *err;
    NSData *dat = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray *data = [NSJSONSerialization JSONObjectWithData:dat options:kNilOptions error:&err];        
    _NSLog(@" will parse %d records",[data count]); 
    
//    NSArray *arr1 = [self requestForEntity:@"MTVChannel" Context:self.managedObjectContext];
//    NSArray *arr2 = [self requestForEntity:@"MTVShow" Context:self.managedObjectContext];
    
    for (NSDictionary *dic in data) {
        [self addChannel:dic mergeDict:mDict context:self.managedObjectContext];
    }
    
//    NSArray *arr3 = [self requestForEntity:@"MTVChannel" Context:self.managedObjectContext];
//    NSArray *arr4 = [self requestForEntity:@"MTVShow" Context:self.managedObjectContext];
    
    [self dataSave:self.managedObjectContext];
    
}


//----------------------------------parseFile----------------------------------------------
- (void)parseDate:(NSData*)dat mergeDict:(NSDictionary*)mDict
{
   if (!dat)
        return;
    NSError *err;
    NSArray *data = [NSJSONSerialization JSONObjectWithData:dat options:kNilOptions error:&err];        
    _NSLog(@" will parse %d records",[data count]); 
    
    for (NSDictionary *dic in data) {
        [self addChannel:dic mergeDict:mDict context:self.managedObjectContext];
    }
    [self dataSave:self.managedObjectContext];
    
}


+ (void)addRandomChannels
{
    NSManagedObjectContext *context = [[[SZAppInfo shared] coreManager] createContext];
    
    for (int i=0; i<2; i++) {
        [self addRandomChannel:context];
    }
    
//  [self dataSave:context];
    
    NSError *error;
    if ([context hasChanges] && ![context save:&error])
    {
        _NSLog0(@"Unresolved error for SAVE!!! (%@), (%@)", error, [error userInfo]);
//        abort();
    }       
    context = nil;
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"ContextUpdateCompleted" object:nil]];    
}


@end

/*
 @class MTVChannel;
 @interface MTVShow : NSManagedObject
 
 @property (nonatomic) NSInteger pCategory;
 @property (nonatomic) NSInteger pId;
 @property (nonatomic) NSInteger pDay;
 @property (nonatomic, retain) NSString * pDescription;
 @property (nonatomic, retain) NSDate *pStart;
 @property (nonatomic, retain) NSDate *pStop;
 @property (nonatomic, retain) NSString * pTitle;
 @property (nonatomic, retain) MTVChannel *rTVChannel;
 
 @end
 
/-------------------- 
 @class MTVShow;
 
 @interface MTVChannel : NSManagedObject
 
 @property (nonatomic, retain) NSDate *pDateLoad;
 @property (nonatomic) NSInteger pID;
 @property (nonatomic) BOOL pLoaded;
 @property (nonatomic, retain) NSString * pLogoUrl;
 @property (nonatomic, retain) NSString * pName;
 @property (nonatomic, retain) NSString * pProgramUrl;
 @property (nonatomic) BOOL pSelected;
 @property (nonatomic, retain) NSString * tSectionIdentifier;
 @property (nonatomic) BOOL pFavorite;
 @property (nonatomic) double pOrderValue;
 
 @property (nonatomic, retain) NSSet *rTVShow;
 @end
 
 @interface MTVChannel (CoreDataGeneratedAccessors)
 
 - (void)addRTVShowObject:(MTVShow *)value;
 - (void)removeRTVShowObject:(MTVShow *)value;
 - (void)addRTVShow:(NSSet *)values;
 - (void)removeRTVShow:(NSSet *)values;
 
 @end
 
 
 -(void)awakeFromFetch
 {
 [super awakeFromFetch];
 //    _NSLog(@" load %@ obj",self.pName);
 }
 -(NSString*)tSectionIdentifier 
 {
    NSString *str = [self.pName substringToIndex:1]; //self.pName;
    return str; 
 }
 
 
 
*/
