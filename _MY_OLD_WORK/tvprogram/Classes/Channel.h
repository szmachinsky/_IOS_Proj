//
//  Channel.h
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Show;
@interface Channel : NSObject<NSCoding>{
    NSString * name;
    NSString * chId;
    NSString * iconName;
 
    NSMutableDictionary *urlToData;//key is date, value is url to data
    NSDate *updateDate;
    
//zs NSString *fileName;
    NSMutableDictionary *program;  //key date, value array of programs
    
    bool wasUpdateToTimezone;
    NSDate *lastUpdateDate;
    BOOL selected;
}

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *chId;
@property(nonatomic,strong) NSString *iconName;

//zs @property(nonatomic,strong) NSString * fileName;
@property(nonatomic,strong) NSMutableDictionary *program;



-(NSMutableArray *) getCurrentDayProgram:(NSString *) day;

-(Show *) getCurrentShow:(NSString *)day hour:(int)currentHour min:(int)currentMin;
-(Show *) getCurrentShow:(NSString *)day hour:(int)currentHour min:(int)currentMin fromProgram:(NSArray *)dayProgram index:(NSInteger *)index;

-(Show *) getNextShow:(Show*)current;
-(Show *) getNextShowFromProgram:(NSArray *)dayProgram currShowIndex:(NSInteger)index;
-(Show *) getShowByName:(NSString *)showName forDay:(NSString *) day;

-(void) setUpdateToTimezone:(bool)val;
-(void) updatePrograms;
-(void) setUpdatedDate:(NSString *)date;
-(void) setLastUpdateDate:(NSDate *)date;
-(BOOL) shouldBeUpdated;

-(void) clearCache;
-(NSMutableArray *)getProgramsByDate:(NSString *) date;
-(void) setUrlsToData:(NSArray *)array;
-(NSMutableDictionary *) getUrlsToData;

@end
