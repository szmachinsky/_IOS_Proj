//
//  ProgrammByChannelController.h
//  TVProgram
//
//  Created by User1 on 20.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbImageView.h"

@class SZProgrammTableViewController;


@interface ProgrammByChannelController : UIViewController <ThumbImageViewDelegate> {
    NSString *channelName;
    NSString *currentDate;
    UILabel *channelNameLabel;
    SZProgrammTableViewController *tableController;
    NSMutableArray *buttons;
    UIScrollView *thumbScrollView;
    UIButton *favButton;
    NSMutableArray *channelsArray;
    BOOL isForFavorChannels; 
    float hightTableView;
    
    NSString *titleForBackButton_;
}

@property (nonatomic, strong) NSManagedObjectContext *context; //zs
@property (nonatomic, strong) NSString *titleForBackButton;

-(void) setChannelName:(NSString *)name initialDay:(NSString *)day isFavor:(BOOL)isFavor;

@end
