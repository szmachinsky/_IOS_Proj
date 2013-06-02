//
//  MTVShow.m
//  TVProgram
//
//  Created by Admin on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTVShow.h"
#import "MTVChannel.h"


@implementation MTVShow

@dynamic pCategory;
@dynamic pDay;
@dynamic pDescription;
@dynamic pId;
@dynamic pStart;
@dynamic pStop;
@dynamic pTitle;
@dynamic rTVChannel;


//------------------------------------------------------------------------------
-(float)duration
{
    NSDate *d1 = self.pStart;
    NSDate *d2 = self.pStop;
    float dur = fabs([d2 timeIntervalSinceDate:d1]/60.0);
    return dur;
}

-(NSString*)name
{
    return self.pTitle;
}

-(NSString*)descript
{
    return self.pDescription;
}


-(NSString*)day
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *res = [formatter stringFromDate:self.pStart];
    return res;
}

-(NSInteger)startMin
{
    NSDate *dat = self.pStart;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //  unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit;    
    unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
    NSDateComponents *components = [gregorian components:flags fromDate:dat];
    //  NSInteger day = [components day];
    //  NSInteger weekday = [components weekday];
    NSInteger min = [components minute];
    return min;
}

-(NSInteger)startHour
{
    NSDate *dat = self.pStart;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
    NSDateComponents *components = [gregorian components:flags fromDate:dat];
    NSInteger hour = [components hour];    
    return hour;
}

-(NSInteger)endMin
{
    NSDate *dat = self.pStop;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
    NSDateComponents *components = [gregorian components:flags fromDate:dat];
    NSInteger min = [components minute];
    return min;
}

-(NSInteger)endHour
{
    NSDate *dat = self.pStop;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned flags = NSMinuteCalendarUnit | NSHourCalendarUnit; 
    NSDateComponents *components = [gregorian components:flags fromDate:dat];
    NSInteger hour = [components hour];    
    return hour;
}



@end
