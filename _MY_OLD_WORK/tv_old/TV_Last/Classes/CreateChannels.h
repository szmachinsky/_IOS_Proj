//
//  CreateChannels.h
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "TVChannel.h"

@interface CreateChannels : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)init; 
- (void)parseFile:(NSString*)file; 
- (void)parseFile:(NSString*)file mergeDict:(NSDictionary*)mDict;
- (void)parseDate:(NSData*)dat mergeDict:(NSDictionary*)mDict;

+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz Radius:(float)radius;


+ (void)addRandomChannels;

@end
