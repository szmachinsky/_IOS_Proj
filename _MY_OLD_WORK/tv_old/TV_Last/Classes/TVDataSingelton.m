//
//  TVDataStorage.m
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TVDataSingelton.h"
#import "Channel.h"
#import "Show.h"
#import "AppInfo.h"
#import "CommonFunctions.h"

@implementation TVDataSingelton
@synthesize currentState = _currentState;

static TVDataSingelton *sharedTVDataInstance = nil;

+ (TVDataSingelton*)sharedTVDataInstance {
	
    if (sharedTVDataInstance)
        return sharedTVDataInstance;

    if (!sharedTVDataInstance)
        sharedTVDataInstance = [[TVDataSingelton alloc]init];
    
    return sharedTVDataInstance;
}

- (NSString*) actorDataFileName
{
    NSString* path = [SZUtils pathDocDirectory];
    return [path stringByAppendingPathComponent:@"tvdata.archive"];
}

//------------------------------------------------------------------------------
-(id)copyWithZone:(NSZone *)zone {
    return self;
}

-(id)allocWithZone 
{
    return nil;
}

-(id)init
{
	if (self = [super init])
	{
		NSData *settingsData = [[NSMutableData alloc] initWithContentsOfFile:[self actorDataFileName]];
        
		if (settingsData)
		{
			//----- EXISTING DATA EXISTS -----
			NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:settingsData];
            self->appInfo = [decoder decodeObjectForKey:@"appInfo"]; 
            
			[decoder finishDecoding];
		}
		else
		{
			//----- NO DATA EXISTS -----
			self->appInfo = [[AppInfo alloc] init];
            
		}
	}
    
	return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"TimeZoneHasChangedNotification"];
}

//------------------------------------------------------------------------------
- (void) saveData
{
	NSMutableData *settingsData = [NSMutableData data];
	NSKeyedArchiver *encoder =  [[NSKeyedArchiver alloc] initForWritingWithMutableData:settingsData];
    
	//Archive each instance variable/object using its name
	[encoder encodeObject:self->appInfo forKey:@"appInfo"];
    
	[encoder finishEncoding];
	[settingsData writeToFile:[self actorDataFileName] atomically:YES];
}

- (void)setIndexDownloadDate {
    [appInfo setIndexDownloadDate];
}

-(NSString *)getLastDateIdexDownload {
    return [appInfo getLastDateIdexDownload];
}

//------------------------------------------------------------------------------
-(void) addChanel:(Channel *) ch
{
    [appInfo addChanel:ch];
}

-(void) addChannelToFavor:(NSString *)name
{
    [appInfo addFavor:name];
}

-(void) removeChannelFromFavor:(NSString *)name
{
    [appInfo removeFavor:name];
}

-(bool) isChannelFavor:(NSString *)name
{
    return [appInfo isChannelFavor:name];
}


-(void) addChannelToSelected:(NSString *)name
{
    [appInfo addChannelToSelected:name];
}

- (void)removeChannelNameFromSelected:(NSString *)name {
    [appInfo removeChannelNameFromSelected:name];
}

-(void) removeChannelFromSelected:(NSString *)name
{
    [appInfo removeChannelFromSelected:name];
}

-(bool) isChannelSelected:(NSString *)name
{
    if ([[appInfo getSelectedChannels] containsObject:name]) {
        return YES;
    }
    return NO;
}


-(NSArray *)getDates
{
    return [appInfo getDates];
}

-(Channel*) getChannel:(NSString *)name
{
    return [appInfo getChannel:name];
}

-(Channel *)getChannelByChID:(NSString * )chId
{
    return [appInfo getChannelByChID:chId];
}

-(void) setLastUpdateDate:(NSDate*) date forChannel:(NSString *)name
{
    [appInfo setLastUpdateDate:date forChannel:name];
}

-(NSMutableArray *) favChannels
{
    return [appInfo getFavChannelsName];
}

-(void) addShowByCategory:(Show *)show
{
    [appInfo addShowByCategory:show];
}


-(void) setWiFiOnly:(BOOL)isWiFiOnly
{
    [appInfo setIsWiFiOnly:isWiFiOnly];
}

-(BOOL) getWiFiOnly
{
    return appInfo.isWiFiOnly;
}

-(void) setDownloadDays:(NSMutableArray*) days
{
    [appInfo setDownloadDays:days];
}

-(NSMutableArray *) getDownloadDates
{
    return [appInfo getDownloadDates];
}

-(void) setBeforeReminder:(int)val
{
    [appInfo setBeforeReminder:val];
}

-(int) getMinBeforeReminder
{
    return appInfo.minBeforeReminders;
}

-(void) setChannels
{
    [appInfo setChannels];
}

-(NSMutableArray *) selectedChanels
{
    return [appInfo getSelectedChannels];
}

-(void) updateToTimeZone
{
    [appInfo updateToTimeZone];
}
-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day
{
    return [appInfo getShowByName:name byDate:day];
}
-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day withStartDate:(NSDate *)time
{
    return [appInfo getShowByName:name byDate:day withStartDate:time];
}

-(void)selectAllChannels
{
    [appInfo.selectedChannelsName removeAllObjects];
    for (int i = 0; i < [appInfo.channels count]; i++) {
        Channel * channel = [appInfo.channels objectAtIndex:i];
        [self addChannelToSelected:[channel name]];
    }
}

-(BOOL) shouldBeDownloaded:(NSString *)name
{
    if ([appInfo.selectedChannelsName containsObject:name]) {
        return YES;
    }
    return NO;
}

-(void)unSelectAllChannels
{
    [appInfo.selectedChannelsName removeAllObjects];
}

- (void)deleteChannelData:(NSString *)chName {
    [appInfo removeChannelFromSelected:chName];
}

/*-(void)deleteAllChannels
{
    NSMutableArray *array = [appInfo.channels copy];
    for (Channel *ch in array) {
        [appInfo removeChannelFromSelected:ch.name];
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"UpdateComplete" object:nil]];
}*/

-(int)getNumberOfChannels
{
    if (appInfo.channels == nil) {
        return 0;
    }
    int num = appInfo.channels.count;
    return num;
}

-(int)getNumberOfCategories
{
    if (appInfo.categories == nil) {
        return 0;
    }
    return appInfo.categories.count;
}

-(int)getNumberOfFavChannels
{
    if (appInfo.favChannelsName == nil) {
        return 0;
    }
    return appInfo.favChannelsName.count;
}

-(NSString *)getCategoryName:(int)index
{
    return [[appInfo.categories allKeys] objectAtIndex:index];
}

-(NSMutableArray *) getCategoryData:(NSString *)catName
{
    return [appInfo.categories objectForKey:catName];
}

-(NSMutableArray *)getFavChannelsName
{
    return appInfo.favChannelsName;
}

-(int)getNumberOfSelectedChannels
{
    if (appInfo.selectedChannelsName == nil) {
        return 0;
    }
    return appInfo.selectedChannelsName.count;
}
-(Channel*) getSelectedChannel:(NSString *)name
{
    return [self getChannel:name];
}

-(NSString *)getSelectedChanelNameByIndex:(int)index
{
    return [appInfo.selectedChannelsName objectAtIndex:index];
}

-(Channel *)getChannelByIndex:(int)index
{
    return [appInfo.channels objectAtIndex:index];
}

-(NSString *)getFavChannelByIndex:(int)index
{
    return [appInfo.favChannelsName objectAtIndex:index];
}

/*
-(NSMutableArray *) getProgramsByCategoryName:(NSString *)categoryName
{
    return [appInfo.categories objectForKey:categoryName];
}*/

-(NSMutableArray *)getSelectedChannelsName
{
    return appInfo.selectedChannelsName;
}

-(void) insertChannelToSelected:(Channel *)ch atIndex:(int)toIndexPath
{
    [appInfo.selectedChannelsName insertObject:ch.name atIndex:toIndexPath];
}

-(void) changeChannelOrder:(int)fromIndexPath toIndexPath:(int)toIndexPath
{
    Channel *ch = [self getChannelByIndex:fromIndexPath];
    [appInfo.channels removeObject:ch];
    [appInfo.channels insertObject:ch atIndex:toIndexPath];
}

- (UIImage*)getIcon:(NSString*)iconName
{
    return [appInfo getIcon:iconName];
}

-(void) readChannelsData:(NSString *)currentDay
{
    [appInfo readChannelsData:currentDay];
}

-(void) addDate:(NSString *)day
{
    [appInfo addDate:day];
}

-(NSString *) getCurrentDate
{
    if (currentDate == nil) {
        currentDate = convertDataToString([NSDate date]);
    }
    return currentDate;
}

-(BOOL)isDateCorrespondToToday
{
    NSString *current = [self getCurrentDate];
    NSString *today = convertDataToString([NSDate date]);
///    _NSLog(@"dat1:%@ dat2:%@",current,today);   
    return [current isEqualToString:today];
}

-(void) setCurrentDate:(NSString *)date
{
    currentDate = [date copy];
}

-(void) clearCache
{
    [appInfo clearCache];
}

- (void)clearCategories {
    [appInfo clearCategories];
}

@end
