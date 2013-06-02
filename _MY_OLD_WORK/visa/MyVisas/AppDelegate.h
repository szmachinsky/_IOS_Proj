//
//  AppDelegate.h
//  MyVisas
//
//  Created by Nnn on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class LocationManager;

@interface TabBarItem : UITabBarItem 
@property (nonatomic, retain) UIImage *selImage;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
    BOOL handlingNotification;
    BOOL actionSheetShown;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (nonatomic, retain) LocationManager *locationManager;
@property (nonatomic, assign) BOOL settingsChanged;

- (void)updateLocation;
- (void)createNotificationForVisa:(NSMutableDictionary *)visaData;
- (void)changeNotificationForVisa:(NSMutableDictionary *)visaData;
- (void)createNotificationForPassport;
- (void)createNotificationForDuration;
- (void)scrollToVisaByCurrLocation;
- (void)handleNotification:(UILocalNotification *)notification;
- (void)recreateNotifications;
- (void)switchOffLocationServices;

@end
