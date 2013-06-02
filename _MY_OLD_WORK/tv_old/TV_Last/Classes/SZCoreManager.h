//
//  CoreManager.h
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTVChannel;

@interface SZCoreManager : NSObject {
@private
    NSString *file_;
    NSString *model_;
    NSURL *fileURL_;
    NSURL *modelURL_;
    
    NSManagedObjectContext  *context_;
    NSArray *arrChannels; 
    NSData *imData;        
    NSInteger scDat,scImg;
    
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *model;


//@property (readonly, strong, nonatomic) NSManagedObjectContext  *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel    *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)initWithFile:(NSString*)file Model:(NSString*)model;

- (NSManagedObjectContext *)createContext;

- (MTVChannel*)selChannelByName:(NSString*)name context:(NSManagedObjectContext*)context;

+ (NSArray*)arrayOfSelectedChannels:(NSManagedObjectContext*)_context_; 
+ (NSArray*)arrayOfFavoriteChannels:(NSManagedObjectContext*)_context_;

+ (NSArray*)arrayOfNoSortSelectedChannels:(NSManagedObjectContext*)_context_;
+ (NSInteger)numberOfSelectedChannels:(NSManagedObjectContext*)_context_;

+ (NSArray*)arrayOfNoSortFavoriteChannels:(NSManagedObjectContext*)_context_;
+ (NSInteger)numberOfFavoriteChannels:(NSManagedObjectContext*)_context_;

+ (void)saveForContext:(NSManagedObjectContext *)context;
+ (NSInteger)deleteAllObjectsIn:(NSString *)entity forContext:(NSManagedObjectContext *)context;
+ (NSDictionary*)deleteAllObjectsWithSaveIn:(NSString *)entity forContext:(NSManagedObjectContext *)context;
 
+ (NSFetchedResultsController *)ftResultsController:(UITableViewController <NSFetchedResultsControllerDelegate>*)tcont 
                                         ManagedObj:(NSManagedObjectContext*)context  
                                             Entity:(NSString*)ent  
                                            SortKey:(NSString*)sortKey  
                                 SectionNameKeyPath:(NSString*)section 
                                          CacheName:(NSString*)cache  
                                       SearchString:(NSString*)search 
                                          Ascending:(BOOL)asc; 




@end
