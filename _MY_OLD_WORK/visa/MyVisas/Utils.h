//
//  Utils.h
//  MyVisas
//
//  Created by Nnn on 25.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int topBarImageTag = NSIntegerMax;

// functions for working with dates
NSString *formattedDate(NSDate *date, BOOL longStyle);
NSDate *dateFromString(NSString *dateStr);
NSString *configureDatesStrFromDates(NSDate *date1, NSDate *date2);
NSInteger numOfDaysInMonth(NSDate *date);
NSInteger daysBetweenDates(NSDate *dt1, NSDate *dt2);
BOOL isNewDay(NSDate *date);
NSDictionary *getDaysAndMonthNumBetweenDates(NSDate *d1, NSDate *d2);
NSDate *cutTime(NSDate *date);
BOOL isDateBetweenDates(NSDate *date, NSDate *d1, NSDate *d2);

// functions for getting localized text
NSString *getTextForAlertDays(int numOfDays);
NSString *daysStr(NSInteger numOfDays);
NSString *entriesStr(NSInteger num);

// functions for getting visa info
NSString *getCountryNameByCode(NSString *code);
NSInteger getDurationNumForVisa(NSDictionary *visaData);

// other utils
BOOL isSystemVersionMoreThen(CGFloat version);
BOOL checkForNotNull(id obj);
NSLocale *chooseLocale(void);
BOOL isCountryOfSchengen(NSString *countryCode);
UIButton *createBackNavButton(void);
void showFullVersionInfo(NSString *info, UIViewController *vc);


