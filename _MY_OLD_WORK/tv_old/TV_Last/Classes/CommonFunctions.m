//
//  CommonFunctions.m
//  TVProgram
//
//  Created by User1 on 23.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommonFunctions.h"

int getCurrentHour()
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    
    [formatter setDateFormat:@"HH"];
    
    NSString * time = [formatter stringFromDate:date];
    return [time intValue];
}

int getCurrentMin()
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    
    [formatter setDateFormat:@"mm"];
    
    NSString * time = [formatter stringFromDate:date];
    return [time intValue];
}

NSString *convertDataToString(NSDate * date)
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyyMMdd"];
    
    NSString * convertedDate = [formatter stringFromDate:date];
    return convertedDate;
}

NSDate *convertStringToDate(NSString *dateStr) {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter dateFromString:dateStr];
}

NSString *convertDateToUserView(NSString *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date1 = [dateFormatter dateFromString:date];
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE dd MMM"];    
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [theDateFormatter setLocale:usLocale];
    NSString *weekDay =  [theDateFormatter stringFromDate:date1];
    return weekDay;
}

NSString *convertDateToUserView2(NSString *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date1 = [dateFormatter dateFromString:date];
    
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
//    [theDateFormatter setDateFormat:@"EEEE d MMMM"];    
    [theDateFormatter setDateFormat:@"d MMMM',' EEEE"];    
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [theDateFormatter setLocale:usLocale];
    NSString *weekDay =  [theDateFormatter stringFromDate:date1];
    return weekDay;
}


NSString *getWeekDay(NSString *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date1 = [dateFormatter dateFromString:date];

    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"EEEE, dd MMM"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [theDateFormatter setLocale:usLocale];
    NSString *weekDay =  [theDateFormatter stringFromDate:date1];
    return [weekDay capitalizedString];
}

NSString *getShortWeekDay(NSString *date)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date1 = [dateFormatter dateFromString:date];
    NSDateFormatter* theDateFormatter = [[NSDateFormatter alloc] init];
    [theDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [theDateFormatter setDateFormat:@"E"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [theDateFormatter setLocale:usLocale];
    NSString *weekDay =  [theDateFormatter stringFromDate:date1];
    return [weekDay capitalizedString];
}

NSInteger weekdayFromDate(NSDate *date) {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit | NSWeekdayCalendarUnit fromDate:date];
    return [components weekday];
}

BOOL diffWeeks(NSDate *date1, NSDate *date2) {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.firstWeekday = 2; // Sunday = 1, Saturday = 7
    NSDateComponents *components1 = [gregorian components:NSWeekCalendarUnit fromDate:date1];
    NSDateComponents *components2 = [gregorian components:NSWeekCalendarUnit fromDate:date2];
    NSUInteger weekOfYear1 = [components1 week];
    NSUInteger weekOfYear2 = [components2 week];
    
    return weekOfYear1 != weekOfYear2;
}

NSDictionary *getCurrentTime(void) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"HH mm"];
    NSString *hour = nil;
    NSString *min = nil;
    NSString *timeStr = [formatter stringFromDate:date];
    NSArray *components = [timeStr componentsSeparatedByString:@" "];
    BOOL isPM = components.count > 2 && [[components objectAtIndex:2] isEqualToString:@"PM"];
    
    hour = [components objectAtIndex:0];
    if (isPM && [hour intValue] != 12) {
        hour = [NSString stringWithFormat:@"%d", [hour intValue] + 12];
    }
    min = [components objectAtIndex:1];
    return [NSDictionary dictionaryWithObjectsAndKeys:hour, @"hour", min, @"min", nil];
}
