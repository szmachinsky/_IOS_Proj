//
//  AppInfo.m
//  TVProgram
//
//  Created by User1 on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppInfo.h"
#import "Channel.h"
#import "CommonFunctions.h"
#import "Show.h"
#import "TVDataSingelton.h"

@interface AppInfo ()
//@property (readonly) NSMutableArray * channels;
@end

@implementation AppInfo
@synthesize isWiFiOnly;
@synthesize minBeforeReminders;
//@synthesize timeZone;
@synthesize channels;
@synthesize categories;
@synthesize selectedChannelsName;
@synthesize favChannelsName;
@synthesize lastDateIndexDownload;
@synthesize selectedWeekday;

- (id)init{
	self = [super init];
	[self setIsWiFiOnly:NO];	
    [self setDownloadDays:[[NSMutableArray alloc] initWithObjects:@"Понедельник", nil]];
    [self setBeforeReminder:5];
    [self setSelectedChannels:[[NSMutableArray alloc] init]];
    [self set_FavChannelsName:[[NSMutableArray alloc] init]];    
    channels = [[NSMutableArray alloc] initWithCapacity:300];
    categories = [[NSMutableDictionary alloc] init];
    selectedWeekday = weekdayFromDate([NSDate date]);
    
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	[self setIsWiFiOnly:[aDecoder decodeBoolForKey:@"isWiFiOnly"]];	
    [self setDownloadDays:[aDecoder decodeObjectForKey:@"downloadedDays"]];
    [self setBeforeReminder:[aDecoder decodeIntegerForKey:@"RemindersTime"]];
    [self setSelectedChannels:[aDecoder decodeObjectForKey:@"channelsName"]];
    [self set_FavChannelsName:[aDecoder decodeObjectForKey:@"favChannelsName"]]; 
    channels = [aDecoder decodeObjectForKey:@"channels"];
    if (!channels) 
        channels = [[NSMutableArray alloc] initWithCapacity:300]; //zs
    categories = [aDecoder decodeObjectForKey:@"categories"];
    days = [aDecoder    decodeObjectForKey:@"days"];
    lastDateIndexDownload = [aDecoder decodeObjectForKey:@"lastDateIndexDownload"];
    selectedWeekday = [aDecoder decodeIntegerForKey:@"selectedWeekday"];

	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeBool:isWiFiOnly forKey:@"isWiFiOnly"];	
    [aCoder encodeObject:downloadDays forKey:@"downloadedDays"];
    [aCoder encodeInteger:minBeforeReminders forKey:@"RemindersTime"];
    [aCoder encodeObject:selectedChannelsName forKey:@"channelsName"];
    [aCoder encodeObject:favChannelsName forKey:@"favChannelsName"];
    //[aCoder encodeObject:timeZone forKey:@"timeZone"];  
    // to prevent crash while index.json parsing
    if ([TVDataSingelton sharedTVDataInstance].currentState != eIndexParsing) {
        [aCoder encodeObject:channels forKey:@"channels"];
    } else {
        _NSLog(@"!!!CHANNELS are parsed");
    }
    [aCoder encodeObject:categories forKey:@"categories"];
    [aCoder encodeObject:days forKey:@"days"];
    [aCoder encodeObject:lastDateIndexDownload forKey:@"lastDateIndexDownload"];
    [aCoder encodeInteger:selectedWeekday forKey:@"selectedWeekday"];
}

NSInteger daysSort(id num1, id num2, void *context)
{
    NSString *v1 = num1;
    NSString *v2 = num2;
    NSRange range;
    range.location = 0;
    range.length = 4;
    int y1 = [[v1 substringWithRange:range] intValue];
    int y2 = [[v2 substringWithRange:range] intValue];
    range.location = 4;
    range.length = 2;
    int m1 = [[v1 substringWithRange:range] intValue];
    int m2 = [[v2 substringWithRange:range] intValue];
    if (y1 < y2)
        return NSOrderedAscending;
    else if (y1 > y2)
        return NSOrderedDescending;
    else if (m1 > m2)
        return NSOrderedDescending;
    else if (m1 < m2)
        return NSOrderedAscending;
    else
    {
        range.location = 6;
        range.length = 2;
        int d1 = [[v1 substringWithRange:range] intValue];
        int d2 = [[v2 substringWithRange:range] intValue];
        if(d1 < d2)
            return NSOrderedAscending;
        else if(d1 > d2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }
}

-(void)setIsWiFiOnly:(BOOL)isTrue
{
    isWiFiOnly = isTrue;
}

-(void) setDownloadDays:(NSMutableArray*) newDays
{
    downloadDays = [newDays copy];
}

-(NSMutableArray *) getDownloadDates
{
    return downloadDays;
}

-(void) setBeforeReminder:(int)val
{
    minBeforeReminders = val;
}

-(NSMutableArray *) getSelectedChannels
{
    return selectedChannelsName;
}

-(NSMutableArray *) getFavChannelsName
{
    return favChannelsName;
}

-(NSMutableArray *) getChannels
{
    return channels;
}

-(NSMutableDictionary *) getCategories
{
    return categories;
}

-(void) setSelectedChannels:(NSMutableArray*) data
{
    selectedChannelsName = [data mutableCopy];
}

-(void) set_FavChannelsName:(NSMutableArray*) data
{
    favChannelsName = [data mutableCopy];
}

-(void) addChannelToSelected:(NSString *)name
{
    [selectedChannelsName addObject:name];
}

- (void)removeChannelNameFromSelected:(NSString *)name {
    if ([selectedChannelsName containsObject:name]) {
        [selectedChannelsName removeObject:name];
    }
}

-(void) removeChannelFromSelected:(NSString *)name
{
    if ([selectedChannelsName containsObject:name]) {
        [selectedChannelsName removeObject:name];
    }
    
    //clear show from categories
    Channel *ch = [self getChannel:name];
    for (NSString * key in ch.program.allKeys) {
        for (Show *show in [ch.program objectForKey:key]) {
            NSString * category = [show getCategory];
            NSMutableArray *programsByCategory = [categories objectForKey:category];
            if (programsByCategory != nil) {
                [programsByCategory removeObject:show];
            }
            
            [categories setValue:programsByCategory forKey:category];
        }
    }
    
    // clear other channel info
    ch.program = nil;
   
    //[channels removeObject:ch];
    [self clearCategories];
}

-(void) addChanel:(Channel *) ch
{
    if (!channels) 
        channels = [[NSMutableArray alloc] initWithCapacity:300]; //zs    
    [channels addObject:ch];
}

-(void) addFavor:(NSString *)name
{
    if (![favChannelsName containsObject:name])
        [favChannelsName addObject:name];
}

-(void) removeFavor:(NSString *)name
{
    if ([favChannelsName containsObject:name]) {
        [favChannelsName removeObject:name];
    }
}

-(BOOL) isChannelFavor:(NSString *)name
{
    if ([favChannelsName containsObject:name]) {
        return YES;
    }
    return NO;
}

-(Channel*) getChannel:(NSString *)name
{
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        if([ch.name isEqualToString:name])
            return ch;
    }

    return nil;
}

-(Channel *)getChannelByChID:(NSString * )chId
{
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        if([ch.chId isEqualToString:chId])
            return ch;
    }
    
    return nil;
}

-(void) setLastUpdateDate:(NSDate*) date forChannel:(NSString *)name
{
    NSString *channelId = [name substringToIndex:[name rangeOfString:@"_"].location];
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        if ([ch.chId isEqualToString:channelId]) {
            [ch setLastUpdateDate:date];
        }
    }
}


-(BOOL)checkContains:(NSMutableArray *) array string:(NSString *)name
{
    for (int i = 0; i < [array count]; i++) {
        NSString *item = [array objectAtIndex:i];
        if([item isEqualToString:name])
            return YES;
    }
    return NO;
}

- (void)clearCategories {
    if (categories != nil) {
        for (NSString *key in categories.allKeys) {
            NSMutableArray *programsByCategory = [categories objectForKey:key];
            if (programsByCategory.count == 0) {
                [categories removeObjectForKey:key];
            }
        }
    }
    else {
        categories = [[NSMutableDictionary alloc] init];
    }
}

-(void) addShowByCategory:(Show *)show
{
    //add categories if there is a show
    @synchronized(categories)
    {
        NSString * category = [show getCategory];
        //NSLog(@"addShowByCategory %@", category);
        NSMutableArray *programsByCategory = [categories objectForKey:category];
        if (programsByCategory == nil) {
            programsByCategory = [[NSMutableArray alloc] init ];
        }

        [programsByCategory addObject:show];
    
        [categories setObject:programsByCategory forKey:category];
    }
}

-(void) setUpdateToTimeZone
{
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        [ch setUpdateToTimezone:NO];
    }
}


NSInteger channelsNameSort(id num1, id num2, void *context)
{
    NSString *v1 = num1;
    NSString *v2 = num2;
    return [v1 compare:v2];
}

NSInteger channelsSort(id num1, id num2, void *context)
{
    Channel *v1 = num1;
    Channel *v2 = num2;
    return [[v1 name] compare:[v2 name]];
}

-(void) setChannels
{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [channels sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

-(void) updateToTimeZone
{
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        [ch updatePrograms];
    }
}

-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day
{
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        Show * show = [ch getShowByName:name forDay:day];
        if (show != nil) {
            return show;
        }
    }
    return nil;
}

-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day withStartDate:(NSDate *)time
{
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        Show * show = [ch getShowByName:name forDay:day];
        if (show != nil) {
            if ([[show startDate] isEqualToDate:time]) {
                return show;
            }
        }
    }
    return nil;
}

-(void) readChannelsData:(NSString *)currentDay
{
    for(int i = 0; i < [channels count]; i++)
    {
        Channel * ch = [channels objectAtIndex:i];
        if (ch != nil) {
            [ch getProgramsByDate:currentDay];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
}

- (UIImage*)getIcon:(NSString*)iconName
{
    UIImage* retImage = [staticImageDictionary objectForKey:iconName];
    if (retImage == nil)
    {
        NSString *docDir = [SZUtils pathTmpDirectory];
        retImage = [UIImage imageWithContentsOfFile:[docDir stringByAppendingPathComponent:[iconName lastPathComponent]]];//[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconName]]];

        if (staticImageDictionary == nil)
            staticImageDictionary = [NSMutableDictionary new];
        if (retImage != nil) {
            [staticImageDictionary setObject:retImage forKey:iconName];
        }
    }
    return retImage;
}

-(void) clearCache
{
    [staticImageDictionary removeAllObjects];
    for (int i = 0; i < [channels count]; i++) {
        Channel *ch = [channels objectAtIndex:i];
        [ch clearCache];
    }
}

-(NSMutableArray *) getDates
{
    return days;
}

-(void) addDate:(NSString *)day
{
    if (days == nil) {
        days = [[NSMutableArray alloc] init];
    }
    
    if (![days containsObject:day]) {
        [days addObject:day];
        NSArray *sortedArray; 
        sortedArray = [days sortedArrayUsingFunction:daysSort context:NULL];
        [days removeAllObjects];
        days = [NSMutableArray arrayWithArray:sortedArray];
    }
}

- (void)setIndexDownloadDate {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *currDate = [formatter stringFromDate:[NSDate date]];
    
    lastDateIndexDownload = currDate;
}

-(NSString *)getLastDateIdexDownload {
    return lastDateIndexDownload;
}


-(void)dealloc
{
}
@end
