//
//  MTVShow.h
//  TVProgram
//
//  Created by Admin on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTVChannel;

@interface MTVShow : NSManagedObject

@property (nonatomic) NSInteger pCategory;
@property (nonatomic) NSInteger pDay;
@property (nonatomic, retain) NSString * pDescription;
@property (nonatomic) NSInteger pId;
@property (nonatomic,retain) NSDate * pStart;
@property (nonatomic,retain) NSDate * pStop;
@property (nonatomic, retain) NSString * pTitle;
@property (nonatomic, retain) MTVChannel *rTVChannel;


-(float)duration;
-(NSString*)name;
-(NSString*)descript;

-(NSString*)day;
-(NSInteger)startMin;
-(NSInteger)startHour;
-(NSInteger)endMin;
-(NSInteger)endHour;

@end
