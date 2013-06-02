//
//  Show.h
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Show : NSObject<NSCoding> {
    NSString * name;
    NSString * category;
    NSString * description;
    NSString * channelName;
    NSString * channelIconName;
    NSDate * startDate;
    NSDate * endDate;
    
    NSString * day;
    NSString * endDay;
    NSNumber * startHour;
    NSNumber * startMin;
    NSNumber * endHour;
    NSNumber * endMin;
    int gmtOffsetFromServer;
}

@property(nonatomic,strong) NSString * name;
@property(nonatomic,strong) NSString * day;
@property(nonatomic,strong) NSString * endDay;
//@property(nonatomic,readonly) NSString * category;
@property(nonatomic,strong) NSString * description;
@property(nonatomic,readonly) NSDate * startDate;
@property(nonatomic,strong) NSString * channelName;
@property(nonatomic,strong) NSString * channelIconName;
@property(nonatomic,readonly) NSDate * endDate;
@property(nonatomic,strong) NSNumber * startHour;
@property(nonatomic,strong) NSNumber * startMin;

-(id) init;

-(int) getStartHour;
-(int) getStartMin;
-(int) getEndHour;
-(int) getEndMin;
-(BOOL) setBeginDate:(NSString *)date;
-(void) setFinishDate:(NSString *)date;
-(float) getDuration;
-(void) setCategory:(NSString *) cat;
-(void) updateToTimezone;
-(int) timeFromBeginning:(int)hour withMin:(int)min;
-(NSString *)getCategory;

@end
