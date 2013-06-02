//
//  MTVChannel.h
//  TVProgram
//
//  Created by Admin on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTVShow;

@interface MTVChannel : NSManagedObject

@property (nonatomic) NSInteger pCategories;
@property (nonatomic) BOOL pFavorite;
@property (nonatomic) NSInteger pID;
@property (nonatomic, retain) NSData * pImage;
@property (nonatomic) BOOL pLoaded;
@property (nonatomic,retain) NSDate * pLoadImage;
@property (nonatomic,retain) NSDate * pLoadShow;
@property (nonatomic, retain) NSString * pLogoUrl;
@property (nonatomic, retain) NSString * pLogoUrlLoaded;
@property (nonatomic, retain) NSString * pName;
@property (nonatomic) float pOrderValue;
@property (nonatomic, retain) NSString * pProgramUrl;
@property (nonatomic, retain) NSString * pProgramUrlLoaded;
@property (nonatomic) BOOL pSelected;
@property (nonatomic,retain) NSDate * pUpdated;
@property (nonatomic, retain) NSString * tSectionIdentifier;
@property (nonatomic, retain) NSSet *rTVShow;

-(UIImage*)icon;

@end

@interface MTVChannel (CoreDataGeneratedAccessors)

- (void)addRTVShowObject:(MTVShow *)value;
- (void)removeRTVShowObject:(MTVShow *)value;
- (void)addRTVShow:(NSSet *)values;
- (void)removeRTVShow:(NSSet *)values;

@end
