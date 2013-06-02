//
//  Show.m
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Show.h"

@implementation Show
@synthesize name;
//@synthesize category;
@synthesize description;
@synthesize day;
@synthesize startDate, startHour, startMin;
@synthesize endDate;
@synthesize channelName;
@synthesize channelIconName;
@synthesize endDay;


-(id) init
{
    self = [super init]; //zs
    return self;
}


- (NSDate *) convertDateToTimeZone:(NSDate *)value hour:(int)h minutes:(int)m 
{
//    NSDateFormatter *f;
    
    unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:flags fromDate:startDate];
    int year = [weekdayComponents year];
    int mounth = [weekdayComponents month];
    int day1 = [weekdayComponents day];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:h];
    [comps setMinute:m];
    [comps setDay:day1];
    [comps setMonth:mounth];
    [comps setYear:year];
    NSDate* date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSDateFormatter *localFormatter = [[NSDateFormatter alloc] init];
    [localFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [localFormatter setDateStyle:NSDateFormatterShortStyle];
    [localFormatter setTimeStyle:NSDateFormatterLongStyle];
    [localFormatter setDateFormat:@"yyyyMMddHHmmss"];
    [localFormatter setLocale:[NSLocale currentLocale]];

    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:timeZoneOffset];
    return localDate;
}

-(void) updateStartDate:(NSDate *)updatedDate
{
    startDate = [updatedDate copy];
    unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit;
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:flags fromDate:startDate];
    day = [[NSString stringWithFormat:@"%04i%02i%02i", [weekdayComponents year], [weekdayComponents month], [weekdayComponents day]] copy];
    startHour = [[NSNumber numberWithInt:[weekdayComponents hour]] copy];
    startMin = [[NSNumber numberWithInt:[weekdayComponents minute]] copy];
}

-(void) updateFinishDate:(NSDate *)updatedDate
{
    endDate = [updatedDate copy];
    unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:flags fromDate:endDate];
    endDay = [[NSString stringWithFormat:@"%04i%02i%02i", [weekdayComponents year], [weekdayComponents month], [weekdayComponents day]] copy];
    endHour = [[NSNumber numberWithInt:[weekdayComponents hour]] copy];
    endMin = [[NSNumber numberWithInt:[weekdayComponents minute]] copy];
    //NSLog(@"end %d %d", [self getEndHour], [self getEndMin]);
}

-(void) updateToTimezone
{
    NSDate *locallyFormattedDate1;
    locallyFormattedDate1 = [self convertDateToTimeZone: startDate hour:[self getStartHour] minutes:[self getStartMin]];
    [self updateStartDate:locallyFormattedDate1];
    locallyFormattedDate1 = [self convertDateToTimeZone: endDate hour:[self getEndHour] minutes:[self getEndMin]];
    [self updateFinishDate:locallyFormattedDate1];
}

-(BOOL) setBeginDate:(NSString *)date
{
    startDate = [[NSDate dateWithTimeIntervalSince1970:[date intValue]] copy];
    //NSLog(@"%@", startDate);
    unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekCalendarUnit;
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:flags fromDate:startDate];
    day = [[NSString stringWithFormat:@"%04i%02i%02i", [weekdayComponents year], [weekdayComponents month], [weekdayComponents day]] copy];
    startHour = [[NSNumber numberWithInt:[weekdayComponents hour]] copy];
    startMin = [[NSNumber numberWithInt:[weekdayComponents minute]] copy];
    //NSLog(@"setBeginDate %@", day);
    //check if the day belongs to current week
    /*NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2]; // Sunday == 1, Saturday == 7
    weekdayComponents = [gregorian components:flags fromDate:[NSDate date]];
    NSUInteger curWeek = [weekdayComponents week];
    weekdayComponents = [gregorian components:flags fromDate:startDate];
    NSInteger weekOfDate = [weekdayComponents week];
    if (weekOfDate == curWeek) {
        return YES;
    }
    else
        return NO;*/
    return YES;
    //NSLog(@"setBeginDate %@", day);
    
    //NSLog(@"start %@ %d %d", day, [self getStartHour], [self getStartMin]);
}

-(void) setFinishDate:(NSString *)date
{
    endDate = [[NSDate dateWithTimeIntervalSince1970:[date intValue]] copy];
    unsigned flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:flags fromDate:endDate];
    endDay = [[NSString stringWithFormat:@"%04i%02i%02i", [weekdayComponents year], [weekdayComponents month], [weekdayComponents day]] copy];
    endHour = [[NSNumber numberWithInt:[weekdayComponents hour]] copy];
    endMin = [[NSNumber numberWithInt:[weekdayComponents minute]] copy];
    //NSLog(@"end %d %d", [self getEndHour], [self getEndMin]);
}

-(float) getDuration
{
    float durationHour;
    float durationMin;
    if (![day isEqualToString:endDay]) {
        durationHour = 24 - [startHour intValue];
        durationMin = 0 - [startMin intValue];
    }
    else
    {
        durationHour = [endHour intValue] - [startHour intValue];
        durationMin = [endMin intValue] - [startMin intValue];
    }
    
    float duration = durationHour * 60 + durationMin;
    return duration;
}

-(int) timeFromBeginning:(int)hour withMin:(int)min
{
    int result = 0;
    
    float start = [startHour intValue] * 60 + [startMin intValue];
    float current = hour * 60 + min;
    result = (current - start);
    
    return result;
}

-(int) getStartHour;
{
    //NSLog(@"getStartHour %@", [startHour stringValue]);
    return [startHour intValue];
}

-(int) getStartMin
{
    //NSLog(@"getStartMin %@", [startMin stringValue]);
    return [startMin intValue];
}

-(int) getEndHour
{
    //NSLog(@"endHour %@", [endHour stringValue]);
    return [endHour intValue];
}

-(int) getEndMin
{
    //NSLog(@"endMin %@", [endMin stringValue]);
    return [endMin intValue];
}

-(void) setCategory:(NSString *) cat
{
    //NSLog(@"%@", cat);
    int index = [cat intValue];
    switch (index) {
        case 1:
            category = [NSString stringWithString:@"Документальный сериал"];
            break;
        case 2:
            category = [NSString stringWithString:@"Документальный фильм"];
            break;
        case 3:
            category = [NSString stringWithString:@"Мультипликационный сериал"];
            break;
        case 4:
            category = [NSString stringWithString:@"Мультипликационный фильм"];
            break;
        case 5:
            category = [NSString stringWithString:@"Телевизионный сериал"];
            break;
        case 6:
            category = [NSString stringWithString:@"Художественный фильм"];
            break;
        case 7:
            category = [NSString stringWithString:@"Спортивная программа"];
            break;
        case 8:
            category = [NSString stringWithString:@"Новостная программа"];
            break;
        case 9:
            category = [NSString stringWithString:@"Музыкальная программа"];
            break;
        default:
            //NSLog(@"категория %d", index);
            category = [[NSString stringWithString:@"Без категории"] copy];
            break;
    }
}

-(NSString *)getCategory
{
    return category;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	if (self = [super init]) {
		name = [aDecoder decodeObjectForKey:@"name"];
		day = [aDecoder decodeObjectForKey:@"day"];
        endDay = [aDecoder decodeObjectForKey:@"endDay"];
        category = [aDecoder decodeObjectForKey:@"category"];
        description = [aDecoder decodeObjectForKey:@"description"];
        startDate = [aDecoder decodeObjectForKey:@"startDate"];
        channelName = [aDecoder decodeObjectForKey:@"channelName"];
        channelIconName = [aDecoder decodeObjectForKey:@"channelIconName"];
        endDate = [aDecoder decodeObjectForKey:@"endDate"];
        startHour = [aDecoder decodeObjectForKey:@"startHour"];
        startMin = [aDecoder decodeObjectForKey:@"startMin"];
        endHour = [aDecoder decodeObjectForKey:@"endHour"];
        endMin = [aDecoder decodeObjectForKey:@"endMin"];
	}
	
	return self;
	
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	
	[aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:day forKey:@"day"];
    [aCoder encodeObject:endDay forKey:@"endDay"];
    [aCoder encodeObject:category forKey:@"category"];
    [aCoder encodeObject:description forKey:@"description"];
    [aCoder encodeObject:startDate forKey:@"startDate"];
    [aCoder encodeObject:channelName forKey:@"channelName"];
    [aCoder encodeObject:channelIconName forKey:@"channelIconName"];
    [aCoder encodeObject:endDate forKey:@"endDate"];
    [aCoder encodeObject:startHour forKey:@"startHour"];
    [aCoder encodeObject:startMin forKey:@"startMin"];
    [aCoder encodeObject:endHour forKey:@"endHour"];
    [aCoder encodeObject:endMin forKey:@"endMin"];
}
@end
