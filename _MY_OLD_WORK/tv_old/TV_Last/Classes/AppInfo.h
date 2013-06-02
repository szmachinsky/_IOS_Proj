//
//  AppInfo.h
//  TVProgram
//
//  Created by User1 on 14.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Channel;
@class Show;
@interface AppInfo : NSObject <NSCoding>{
    BOOL isWiFiOnly;
    NSMutableArray *downloadDays;
    int minBeforeReminders;
    
    NSMutableArray *selectedChannelsName; //array of channel's name
    NSMutableArray *favChannelsName;//array of channel's names
    NSMutableArray *channels;
    
    NSMutableDictionary *categories;//key is category name, value array of show names by category
    NSMutableDictionary *staticImageDictionary;//store icons images
    NSMutableArray *days;
    NSString *lastDateIndexDownload;
}

@property (readonly) BOOL isWiFiOnly;
@property (readonly) int minBeforeReminders;
//@property (readonly) NSTimeZone *timeZone;
@property (readonly) NSMutableArray * channels;
@property (readonly) NSMutableArray * favChannelsName;
@property (readonly) NSMutableDictionary * categories;
@property (readonly) NSMutableArray *selectedChannelsName;
@property (strong) NSString *lastDateIndexDownload;
@property (assign) NSInteger selectedWeekday;

-(void)setIsWiFiOnly:(BOOL)isTrue;
-(void) setDownloadDays:(NSMutableArray*) days;
-(NSMutableArray *) getDownloadDates;
-(NSMutableArray *) getSelectedChannels;
-(NSMutableArray *) getFavChannelsName;
-(void) setSelectedChannels:(NSMutableArray*) data;
-(void) set_FavChannelsName:(NSMutableArray*) data;
-(void) setBeforeReminder:(int)val;
-(void) addChannelToSelected:(NSString *)name;
-(void) removeChannelFromSelected:(NSString *)name;
- (void)removeChannelNameFromSelected:(NSString *)name;
-(void) addFavor:(NSString *)name;
-(void) removeFavor:(NSString *)name;
-(BOOL) isChannelFavor:(NSString *)name;
-(NSArray *)getDates;
-(Channel*) getChannel:(NSString *)name;
-(Channel *)getChannelByChID:(NSString * )chId;
-(void) setLastUpdateDate:(NSDate*) date forChannel:(NSString *)name;
- (void)clearCategories;
-(void) addShowByCategory:(Show *)show;
-(void) setUpdateToTimeZone;
-(void) setChannels;
-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day;
-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day withStartDate:(NSDate *)time;
-(void) updateToTimeZone;
-(void) addChanel:(Channel *) ch;
- (UIImage*)getIcon:(NSString*)iconName;
-(void) clearCache;
-(void) readChannelsData:(NSString *)currentDay;
-(void) addDate:(NSString *)day;
-(void)setIndexDownloadDate;
-(NSString *)getLastDateIdexDownload;

@end
