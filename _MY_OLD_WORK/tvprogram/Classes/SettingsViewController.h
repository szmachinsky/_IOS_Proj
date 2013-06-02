//
//  SettingsViewController.h
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SelectTimeZoneController;
@class SelectUpdateDatesController;

@class PickerViewController;

//@class ChannelsConfigController;
@class SZChannelsConfigController;

@class ChannelsSortConfigController;
@class SZChannelsSortConfigController;

@interface SettingsViewController : UITableViewController {
    UITableView *settingsTableView;
    UILabel * minBefore;
    
    SZChannelsConfigController *channelsConfig;
//    ChannelsConfigController *channelsConfig;
    
    SelectUpdateDatesController *updateDates;
    SelectTimeZoneController *timeZone;
    
    SZChannelsSortConfigController *sortChannels;
//    ChannelsSortConfigController *sortChannels;
}

-(id)initWithTabBar;

//-(void) selectedChannels:(BOOL)isChanged channels:(NSArray*)chnArr;
-(void) selectedChannels:(BOOL)isChanged;
-(void) selectChannels;

@end
