//
//  ProgrammDataViewController.h
//  TVProgram
//
//  Created by User1 on 24.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTVShow.h"
#import "MTVChannel.h"

//@class Show;

@interface ProgrammDataViewController : UIViewController {
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UITextView *textLabel;
    
    __weak IBOutlet UIImageView *channelFrameImage;
    __weak IBOutlet UIImageView *channelImage;
    __weak IBOutlet UIImageView *categoryImage;
    
    __weak IBOutlet UIImageView *lineImage;
    
    UIButton *alarmButton,*favButton;
    UILabel * channelLabel;    
    UIImageView *buttonView;  
    
    MTVShow *curentShow;
    MTVChannel *curentChanel;
    int minutesBefore;
    NSString *channel_Name;
    
    UILocalNotification *localNotif;
    NSString *alertString;
}

//-(void) showProgramData:(Show *)show  channel:(NSString *)iconName minutesBefore:(int) min forChannelName:(NSString*)channelName;
-(void) showProgramDataMTV:(MTVShow *)show channel:(MTVChannel*)chanel
             minutesBefore:(int) min 
            forChannelName:(NSString*)channelName;

@end
