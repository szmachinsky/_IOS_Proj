//
//  TVDataStorage.h
//  TVProgram
//
//  Created by User1 on 27.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum  {
    eNone,
    eNeedsIndexDownload,
    eIndexDownloadError,
    eIndexDownloading,
    eIndexDownload,
    eIndexParsing,
    eIndexParse,
    eChannelsDataDownloading,
    eChannelsDownloadError,
}StatesEnum;

@class Channel;
@class Show;
@class AppInfo;


@interface TVDataSingelton : NSObject 
{
    AppInfo *appInfo;
    StatesEnum _currentState; 
    NSString *currentDate;
}
@property (nonatomic) StatesEnum currentState;

+ (TVDataSingelton*)sharedTVDataInstance;

//days of week with existing program data
-(void) addDate:(NSString *)day; //adds date to list of available days
-(NSArray *)getDates; // returns list of dates available to display
-(NSString *)getCurrentDate;//returns selected day of week
-(void) setCurrentDate:(NSString *)date;//remember currently selected day to display all data
-(BOOL)isDateCorrespondToToday;


//settings
-(void) setWiFiOnly:(BOOL)isWiFiOnly; //set to settings if only wifi should be used for the data downloading
-(BOOL) getWiFiOnly; // returns value from settings
-(void) setDownloadDays:(NSMutableArray*) days;//sets days of the week to download data from server side
-(NSMutableArray *) getDownloadDates; // returns array of days to download data from server side
-(void) setBeforeReminder:(int)val; // set min before show to display notification
-(int) getMinBeforeReminder; // returns min before from settings









//data
-(void) clearCache;//clear unneccessary objects
-(void) saveData; // saves data to archive
-(void)setIndexDownloadDate;
-(NSString *)getLastDateIdexDownload;



//channel
-(void) addChanel:(Channel *) ch; // add channel object
-(void) setLastUpdateDate:(NSDate*) date forChannel:(NSString *)name; //set date when channel data was updated last time
-(Channel*) getChannel:(NSString *)name; //returns Channel object by name
-(Channel *)getChannelByChID:(NSString * )chId; //returns Channel object by channel ID
-(int)getNumberOfChannels;//returns number of channels
-(Channel *)getChannelByIndex:(int)index; //returns channel object by index
-(BOOL) shouldBeDownloaded:(NSString *)name;//returns NO if data was updated today
-(UIImage*)getIcon:(NSString*)iconName; //returns icon image object
-(void) readChannelsData:(NSString *)currentDay;//parse json for channel of neccessary

//category
-(NSString *)getCategoryName:(int)index; //returns category name by index
-(NSMutableArray *) getCategoryData:(NSString *)catName;//returns array of show by category
-(int)getNumberOfCategories;//returns number of categories

//favorite channels
-(void) addChannelToFavor:(NSString *)name; //add channel's name to favorite
-(void) removeChannelFromFavor:(NSString *)name; //remove channel name from favorite
-(bool) isChannelFavor:(NSString *)name; //returns YES if channel is favorite
-(int)getNumberOfFavChannels;//returns number of favorite channels
-(NSString *)getFavChannelByIndex:(int)index;//get favorite channle name by index
-(NSMutableArray *)getFavChannelsName;//returns fav channels names

//selected channels
-(void) setChannels; // sets channels as selected
-(void) addChannelToSelected:(NSString *)name;//add channel name to selected
-(void)removeChannelNameFromSelected:(NSString *)name;
-(void) removeChannelFromSelected:(NSString *)name;//remive channel name from selected
-(bool) isChannelSelected:(NSString *)name;//returns YES if channel is selected
-(void)selectAllChannels;//mark all channels as selected
-(void)unSelectAllChannels;//mark all channels as unselected
-(int)getNumberOfSelectedChannels;//returns number of selected channels
-(NSMutableArray *)getSelectedChannelsName;//returns selected channels names
-(NSString *)getSelectedChanelNameByIndex:(int)index;//returns name of selected channel by index
-(void) insertChannelToSelected:(Channel *)ch atIndex:(int)toIndexPath;//insert channel in selected shannels at index
-(void) changeChannelOrder:(int)fromIndexPath toIndexPath:(int)toIndexPath;//channels order

//show
-(void) addShowByCategory:(Show *)show; //add show by Category
-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day; // returns show object by name and day
-(Show *) getShowByName:(NSString *)name byDate:(NSString *)day withStartDate:(NSDate *)time;//for category

- (void)deleteChannelData:(NSString *)chName;
//-(void)deleteAllChannels;

- (void)clearCategories;

@end
