//
//  TVProgramAppDelegate.h
//  TVProgram
//
//  Created by User1 on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerManager;
@class SZChannelsConfigController;
@class SZCoreManager;



@interface TVProgramAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UIPopoverControllerDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
    NSInteger * isTimeZoneChanged;
    ServerManager *controller;
    SZChannelsConfigController *channelsConfigController;
    UIAlertView *progressAlert_;
    
    BOOL handlingNotification;
    NSMutableArray *schNotifications;  
    NSDictionary *currNoteDict;
    
    SZCoreManager *coreM_;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;

@property (nonatomic, retain) NSMutableArray *schNotifications;
@property (nonatomic, retain) NSDictionary *currNoteDict;

@property (atomic, retain) UIAlertView *progressAlert;


- (BOOL)shouldHandleError:(NSInteger)errCode;
//- (void)stopUpdate:(NSNotification *)notification; //zs
- (void)updateComplete:(NSNotification *)notification;
- (void)_updateComplete:(NSNotification *)note;
-(void) _updateStart;
@end

BOOL isSystemVersionMoreThen(CGFloat version);
