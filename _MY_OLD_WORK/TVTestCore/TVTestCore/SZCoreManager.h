//
//  CoreManager.h
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZCoreManager : NSObject {
@private
    NSString *file_;
    NSString *model_;
    NSURL *fileURL_;
    NSURL *modelURL_;
}

@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *model;

@property (readonly, strong, nonatomic) NSManagedObjectContext  *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel    *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)initWithFile:(NSString*)file Model:(NSString*)model;
- (void)saveContext;

+ (NSFetchedResultsController *)ftResultsController:(UITableViewController <NSFetchedResultsControllerDelegate>*)tcont 
                                              ManagedObj:(NSManagedObjectContext*)context  
                                                  Entity:(NSString*)ent CacheName:(NSString*)cache 
                                                 SortKey:(NSString*)sortKey 
                                               Ascending:(BOOL)asc; 


@end
