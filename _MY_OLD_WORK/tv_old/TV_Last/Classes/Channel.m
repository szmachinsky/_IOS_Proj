//
//  Channel.m
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Channel.h"
#import "Show.h"
//#import "SBJSON.h"
#import "TVDataSingelton.h"

@implementation Channel
@synthesize name, iconName, chId, program;
//@synthesize fileName;

-(id) init
{
    self = [super init];
    program = [[NSMutableDictionary alloc] init];
    wasUpdateToTimezone = NO;
    return self;
}

- (void)updatePrograms {
    
}

-(void) createProgramData:(Show *)show
{
    if (program == nil) {
        program = [[NSMutableDictionary alloc] init];
    }
    
    NSString *day = show.day;
    NSMutableArray *programsByDay = [program objectForKey:day];
    if (programsByDay == nil) {
        programsByDay = [[NSMutableArray alloc] init];
    }
    if (![programsByDay containsObject:show]) {
        [programsByDay addObject:show];
    }

    [program setValue:programsByDay forKey:day];
}

-(Show *) getShowByName:(NSString *)showName forDay:(NSString *) day
{
    Show * show = nil;
    NSMutableArray *programsByDay = [program objectForKey:day];
    for (int i = 0; i < [programsByDay count]; i++) {
        Show * s = [programsByDay objectAtIndex:i];
        if([[s name] isEqualToString:showName])
        {
            show = s;
            break;
        }
    }
    return show;
}

NSInteger timeSort(id num1, id num2, void *context)
{
    Show *v1 = num1;
    Show *v2 = num2;
    int h1 = [v1 getStartHour];
    int h2 = [v2 getStartHour];
    if (h1 < h2)
        return NSOrderedAscending;
    else if (h1 > h2)
        return NSOrderedDescending;
    else
    {
        int min1 = [v1 getStartMin];
        int min2 = [v2 getStartMin];
        if(min1 < min2)
            return NSOrderedAscending;
        else if(min1 > min2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }
}

-(void) setUpdatedDate:(NSString *)date
{
    updateDate = [[NSDate dateWithTimeIntervalSince1970:[date intValue]] copy];
///    _NSLog(@"upd_date=%@",[updateDate description]  );
}

-(void) sortPrograms
{
    NSArray * keys = [program allKeys];
    for (int i = 0; i < [keys count]; i++) {
        NSString *day  = [keys objectAtIndex:i];
        NSMutableArray *programsByDay = [program objectForKey:day];
        NSArray *sortedArray; 
        sortedArray = [programsByDay sortedArrayUsingFunction:timeSort context:NULL];
        [program setObject:sortedArray forKey:day];
    }
}

-(void) setUpdateToTimezone:(bool)val
{
    wasUpdateToTimezone = val;
}

-(NSMutableArray *) getCurrentDayProgram:(NSString *) day
{
    NSMutableArray * currentDayProgram = [program objectForKey:day];
    if (currentDayProgram == nil)
    {
        NSString *docDir = [SZUtils pathTmpDirectory];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@_%@.json", docDir, chId, day];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            //NSLog(@"!!!!!!!Parsing channel for %@", chId);
            NSData *fileContent = [[NSData alloc] initWithContentsOfFile:filePath];
/*            
            SBJsonParser *parser = [[SBJsonParser alloc] init];  
            NSArray *data = (NSArray *) [parser objectWithData:fileContent];
*/            
            NSError *err;
            NSArray *data = [NSJSONSerialization JSONObjectWithData:fileContent options:kNilOptions error:&err];
            
            NSEnumerator *enumerator = [data objectEnumerator];
            id value;
            [self clearCache];
            while (value = [enumerator nextObject]) {
                
                NSString * start = [value objectForKey:@"start"];
                Show * show = [[Show alloc] init];
                show.name = [value objectForKey:@"title"];
                [show setBeginDate:start];
                [show setFinishDate:[value objectForKey:@"stop"]];
                show.description = [value objectForKey:@"desc"];
                [show setCategory:[value objectForKey:@"category"]];
                show.channelName = [[self name] copy];
                show.channelIconName = [[self iconName]copy];
                //[show updateToTimezone];
                [self createProgramData:show];
                [[TVDataSingelton sharedTVDataInstance] addShowByCategory:show];
            }
            [self sortPrograms];
            currentDayProgram = [program objectForKey:day];
        }
    }
    return currentDayProgram;
}

-(NSMutableArray *)getProgramsByDate:(NSString *) date
{
    return [self getCurrentDayProgram:date];
}

- (Show *)getCurrentShow:(NSString *)day hour:(int)currentHour min:(int)currentMin fromProgram:(NSArray *)dayProgram index:(NSInteger *)index {
    Show* current = nil;

    int i = 0;
    (*index) = -1;
    for (Show * show in dayProgram)  {
        if([show getStartHour] <= currentHour) {
            if ([show getStartHour] == currentHour) {
                if ([show getStartMin] <= currentMin) {
                    
                    if ([show getEndHour] > currentHour) {
                        current = show;
                        (*index) = i;
                        return current;
                    }
                    else if ([show getEndHour] == currentHour && [show getEndMin] >= currentMin) {
                        current = show;
                        (*index) = i;
                        return current;
                    }
                }
            }
            else
            {
                if ([show getEndHour] > currentHour) {
                    current = show;
                    (*index) = i;
                    return current;
                }
                else if ([show getEndHour] == currentHour && [show getEndMin] > currentMin) {
                    current = show;
                    (*index) = i;
                    return current;     
                }
            }
        }
        i++;
    }
    return current;
}

- (Show *)getCurrentShow:(NSString *)day hour:(int)currentHour min:(int)currentMin fromProgram:(NSArray *)dayProgram {
    NSInteger index = 0;
    return [self getCurrentShow:day hour:currentHour min:currentMin fromProgram:dayProgram index:&index];
}

-(Show*) getCurrentShow:(NSString *)day hour:(int)currentHour min:(int)currentMin {
    return [self getCurrentShow:day hour:currentHour min:currentMin fromProgram:[self getCurrentDayProgram:day]];
}

-(Show*) getNextShow:(Show*)current
{
    Show* nextShow = nil;
    if([current startDate] != nil)
    {
        NSString *day  =  current.day;
        NSArray * currentDayProgram = [self getCurrentDayProgram:day];
        int index = [currentDayProgram indexOfObject:current];
        if((index + 1) < [currentDayProgram count])
            nextShow = [currentDayProgram objectAtIndex:(index+1)];
    }
    return nextShow;
}

- (Show *)getNextShowFromProgram:(NSArray *)dayProgram currShowIndex:(NSInteger)index {
    return (index + 1 < dayProgram.count) ? [dayProgram objectAtIndex:index + 1] : nil;
}

-(BOOL) shouldBeUpdated
{
    BOOL res = YES;
    // TODO: get update days
    NSDate *chUpdateDate = [NSDate date]; // updateDate
    if (lastUpdateDate != nil) 
    {
        unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
        NSDateComponents *updateComponents = [[NSCalendar currentCalendar] components:flags fromDate:chUpdateDate];
        NSDateComponents *lastUpdateComponents = [[NSCalendar currentCalendar] components:flags fromDate:lastUpdateDate];
        if ([updateComponents year] == [lastUpdateComponents year]) {
            if ([updateComponents month] == [lastUpdateComponents month]) {
                if ([updateComponents day] == [lastUpdateComponents day]) {
                    res = NO;
                }
            }
        }
    }
    return res;
}

-(void) setLastUpdateDate:(NSDate *)date
{
    lastUpdateDate = [date copy];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	if (self = [super init]) {
		name = [aDecoder decodeObjectForKey:@"name"];
		iconName = [aDecoder decodeObjectForKey:@"iconName"];
        chId = [aDecoder decodeObjectForKey:@"chId"];
        program = [aDecoder decodeObjectForKey:@"program"];//key date, value array of programs
        wasUpdateToTimezone = [aDecoder decodeBoolForKey:@"wasUpdateToTimezone"];
        urlToData = [aDecoder decodeObjectForKey:@"urlToData"];
        updateDate = [aDecoder decodeObjectForKey:@"updateDate"];
        lastUpdateDate = [aDecoder decodeObjectForKey:@"lastUpdateDate"];
	}
	
	return self;
	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:iconName forKey:@"iconName"];
    [aCoder encodeObject:chId forKey:@"chId"];
    [aCoder encodeObject:program forKey:@"program"];
    [aCoder encodeBool:wasUpdateToTimezone forKey:@"wasUpdateToTimezone"];
    [aCoder encodeObject:urlToData forKey:@"urlToData"];
    [aCoder encodeObject:updateDate forKey:@"updateDate"];
    [aCoder encodeObject:lastUpdateDate forKey:@"lastUpdateDate"];
	
}

-(void) dealloc
{
    [program removeAllObjects];
}

-(void) setUrlsToData:(NSArray *)array
{
    if (urlToData == nil) {
        urlToData = [[NSMutableDictionary alloc] init];
    }
    for (NSString * url in array) {
///        _NSLog(@"(%@)+url>:%@", name, url);
        NSRange range = [[url lastPathComponent] rangeOfString:@"_"];
        NSRange dataRange = NSMakeRange(range.location + 1, 8);
        NSString *key = [[url lastPathComponent] substringWithRange:dataRange];
///        _NSLog(@"url:%@  key:%@",url, key);
        [urlToData setValue:url forKey:key];
    }
}

-(NSMutableDictionary *) getUrlsToData
{
    return urlToData;
}


-(void) clearCache
{
    [program removeAllObjects];
}

@end
