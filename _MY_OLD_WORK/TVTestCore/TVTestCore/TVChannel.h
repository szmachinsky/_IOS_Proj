//
//  TVChannel.h
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TVChannel : NSManagedObject

@property (nonatomic, retain) NSNumber * bLoaded;
@property (nonatomic, retain) NSNumber * bSelected;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSNumber * idChan;
@property (nonatomic, retain) NSString * urlLogo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * urlProgr;
@property (nonatomic, retain) NSSet *tvShow;
@end

@interface TVChannel (CoreDataGeneratedAccessors)

- (void)addTvShowObject:(NSManagedObject *)value;
- (void)removeTvShowObject:(NSManagedObject *)value;
- (void)addTvShow:(NSSet *)values;
- (void)removeTvShow:(NSSet *)values;

@end
