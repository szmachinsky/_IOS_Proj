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
    UILabel * titleLabel;
    UILabel * dateLabel;
    UILabel * timeLabel;
    UITextView * textLabel;
    UIButton *alarmButton;
    UIImageView *myImageView;
    UILabel * channelLabel;
    
//  Show *curentShow;
    MTVShow *curentShow;
    MTVChannel *curentChanel;
    int minutesBefore;
    
    UILocalNotification *localNotif;
    NSString *alertString;
}

//-(void) showProgramData:(Show *)show  channel:(NSString *)iconName minutesBefore:(int) min forChannelName:(NSString*)channelName;
-(void) showProgramDataMTV:(MTVShow *)show channel:(MTVChannel*)chanel
             minutesBefore:(int) min 
            forChannelName:(NSString*)channelName;

@end
