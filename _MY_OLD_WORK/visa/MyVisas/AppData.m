//
//  AppData.m
//  MyVisas
//
//  Created by Nnn on 12.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"
#import "AppDelegate.h"

@implementation AppData

@synthesize shopManager;
@synthesize bannerManager;
@synthesize isVisaOnEdit;

@synthesize visas, passportInfo, showAlerts, alertsBeginDays, repeatDays, alertsTime;
@synthesize isLocationOn, currCountry, nextVisaNum, lastDateOpened, isInCountry, entries;
@synthesize lastLocation, locationHandled;
@synthesize appRated, mailToFriendSend;

static AppData *soleAppData = nil;

+ (AppData *)sharedAppData {
    if (soleAppData == nil) {
        soleAppData = [[super allocWithZone:NULL] init];
        
        //restoring saved data
        BOOL noData = YES;
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSData *archive = [NSData dataWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"app_data"]];
        if (archive) {
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archive];
            noData = ![unarchiver containsValueForKey:@"app_data"];
            [unarchiver decodeObjectForKey:@"app_data"];
            [unarchiver release];
        }
        
        if (noData) {
            soleAppData.visas = [NSMutableArray array];
            soleAppData.passportInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNull null], @"issueDate", [NSNull null], @"expiryDate", nil];
            soleAppData.showAlerts = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
            soleAppData.alertsBeginDays = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:7], [NSNumber numberWithInt:3], [NSNumber numberWithInt:180], nil];
            soleAppData.repeatDays = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
            soleAppData.alertsTime = [NSMutableArray arrayWithObjects:@"12:00", @"12:00", @"12:00", nil];
            soleAppData.isLocationOn = NO;
            soleAppData.isInCountry = NO;
            soleAppData.lastDateOpened = [NSDate date];
            soleAppData.lastLocation = [NSDictionary dictionary];
            soleAppData.locationHandled = YES;
            soleAppData.entries = [NSMutableDictionary dictionary];
            soleAppData.appRated = NO;
            soleAppData.mailToFriendSend = NO;
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
    }
    return soleAppData;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedAppData] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

- (void)setIsLocationOn:(BOOL)locationOn {
    isLocationOn = locationOn;
    [[NSNotificationCenter defaultCenter] postNotificationName:kLocationSettingChanged object:nil];
}

- (void)save {
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"app_data"];
    [archiver finishEncoding];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [data writeToFile:[documentsDirectory stringByAppendingPathComponent:@"app_data"] atomically:YES];
    [archiver release];
}

#pragma NSCoding protocol

- (id)initWithCoder:(NSCoder *)decoder {
    self.visas = [decoder decodeObjectForKey:@"visas"];
    self.passportInfo = [decoder decodeObjectForKey:@"passportInfo"];
    self.showAlerts = [decoder containsValueForKey:@"showAlerts"] ? [decoder decodeObjectForKey:@"showAlerts"]
    : [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];
    self.alertsBeginDays = [decoder containsValueForKey:@"alertsBeginDays"] ? [decoder decodeObjectForKey:@"alertsBeginDays"] 
    : [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:7], [NSNumber numberWithInt:3], [NSNumber numberWithInt:180], nil];
    self.repeatDays = [decoder containsValueForKey:@"repeatDays"] ? [decoder decodeObjectForKey:@"repeatDays"] 
    : [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil];
    self.alertsTime = [decoder containsValueForKey:@"alertsTime"] ? [decoder decodeObjectForKey:@"alertsTime"] 
    : [NSMutableArray arrayWithObjects:@"12:00", @"12:00", @"12:00", nil];
    self.currCountry = [decoder decodeObjectForKey:@"currCountry"];
    self.isLocationOn = [decoder decodeBoolForKey:@"isLocationOn"];
    self.nextVisaNum = [decoder decodeIntForKey:@"nextVisaNum"];
    self.lastDateOpened = [decoder containsValueForKey:@"lastDateOpened"] ? [decoder decodeObjectForKey:@"lastDateOpened"] : [NSDate date];
    self.isInCountry = [decoder decodeBoolForKey:@"isInCountry"];
    self.lastLocation = [decoder decodeObjectForKey:@"lastLocation"];
    self.locationHandled = [decoder decodeBoolForKey:@"locationHandled"];
    self.entries = [decoder containsValueForKey:@"entries"] ? [decoder decodeObjectForKey:@"entries"] : [NSMutableDictionary dictionary];
    self.appRated = [decoder decodeBoolForKey:@"appRated"];
    self.mailToFriendSend = [decoder decodeBoolForKey:@"mailToFriendSend"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:visas forKey:@"visas"];
    [encoder encodeObject:passportInfo forKey:@"passportInfo"];
    [encoder encodeObject:showAlerts forKey:@"showAlerts"];
    [encoder encodeObject:alertsBeginDays forKey:@"alertsBeginDays"];
    [encoder encodeObject:repeatDays forKey:@"repeatDays"];
    [encoder encodeObject:alertsTime forKey:@"alertsTime"];
    [encoder encodeObject:currCountry forKey:@"currCountry"];
    [encoder encodeBool:isLocationOn forKey:@"isLocationOn"];
    [encoder encodeInt:nextVisaNum forKey:@"nextVisaNum"];
    [encoder encodeObject:lastDateOpened forKey:@"lastDateOpened"];
    [encoder encodeBool:isInCountry forKey:@"isInCountry"];
    [encoder encodeObject:lastLocation forKey:@"lastLocation"];
    [encoder encodeBool:locationHandled forKey:@"locationHandled"];
    [encoder encodeObject:entries forKey:@"entries"];
    [encoder encodeBool:appRated forKey:@"appRated"];
    [encoder encodeBool:mailToFriendSend forKey:@"mailToFriendSend"];
}

@end
