//
//  Utils.m
//  MyVisas
//
//  Created by Nnn on 25.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "FullVersionDescriptionVC.h"

#pragma mark -
#pragma mark Working with dates

NSString *formattedDate(NSDate *date, BOOL longStyle) {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:chooseLocale()];
    [formatter setDateStyle:longStyle ? NSDateFormatterLongStyle : NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    return date ? [formatter stringFromDate:date] : @"";
}



NSDate *dateFromString(NSString *dateStr) {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setLocale:chooseLocale()];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [formatter dateFromString:dateStr];
    return (date == nil) ? nil : date;
}

NSString *configureDatesStrFromDates(NSDate *date1, NSDate *date2) {
    NSString *dateStr1 = checkForNotNull(date1) ? formattedDate(date1, NO) : @"...";
    NSString *dateStr2 = checkForNotNull(date2) ? formattedDate(date2, NO) : @"...";
    return [NSString stringWithFormat:@"%@ - %@", dateStr1, dateStr2];
}

NSInteger numOfDaysInMonth(NSDate *date) {
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return days.length;
}

NSInteger daysBetweenDates(NSDate *dt1, NSDate *dt2) {
    int numDays;
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    numDays = [components day];
    return numDays;
}

BOOL isNewDay(NSDate *date) {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"ddMMyy"];
    return ![[formatter stringFromDate:now] isEqualToString:[formatter stringFromDate:date]];
}

NSDictionary *getDaysAndMonthNumBetweenDates(NSDate *d1, NSDate *d2) {
    NSInteger monthNum, daysNum;

    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:cutTime(d1) toDate:cutTime(d2) options:0];
    daysNum = [components day];
    monthNum = [components month];
    
    return [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:monthNum], @"month", [NSNumber numberWithInt:daysNum], @"day", nil];
}

NSDate *cutTime(NSDate *date) {
    return dateFromString(formattedDate(date, NO));
}

BOOL isDateBetweenDates(NSDate *date, NSDate *d1, NSDate *d2) {
    return (!checkForNotNull(d1) && checkForNotNull(d2) && [[date earlierDate:d2] isEqualToDate:date])
    || (!checkForNotNull(d2) && checkForNotNull(d1) && [[date earlierDate:d1] isEqualToDate:d1])
    || ((checkForNotNull(d1) && checkForNotNull(d2)) && ([date isEqualToDate:d1] || [[date earlierDate:d1] isEqualToDate:d1]) && ([date isEqualToDate:d2] || [[date earlierDate:d2] isEqualToDate:date]));
}

#pragma mark -
#pragma mark Getting localized text

NSString *getTextForAlertDays(int numOfDays) {
    NSString *dayStr = nil;
    if (numOfDays == 180) {
        dayStr = NSLocalizedString(@"six month", @"six month");
    }
    else if (numOfDays == 30) {
        dayStr = NSLocalizedString(@"month", @"month");
    }
    else if (numOfDays == 14) {
        dayStr = NSLocalizedString(@"two weaks", @"two weeks");
    }
    else if (numOfDays == 7) {
        dayStr = NSLocalizedString(@"week", @"week");
    }
    else {
        dayStr = [NSString stringWithFormat:@"%d %@", numOfDays, daysStr(numOfDays)];
    }
    dayStr = [NSString stringWithFormat:NSLocalizedString(@"%@ before", @"days before"), dayStr];
    
    return dayStr;
}

NSString *daysStr(NSInteger numOfDays) {
    NSString *resStr = nil;
    NSString *numStr = [NSString stringWithFormat:@"%d", numOfDays];
    BOOL ruLang = [[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"ru"].location != NSNotFound;
    if (numStr.length) {
        if (ruLang) {
            if (numStr.length > 1 && [numStr characterAtIndex:numStr.length - 2] == '1') {
                resStr = NSLocalizedString(@"days", @"days");
            }
            else if ([numStr characterAtIndex:numStr.length - 1] == '1') {
                resStr = NSLocalizedString(@"day", @"day");
            }
            else if ([numStr characterAtIndex:numStr.length - 1] == '2' || [numStr characterAtIndex:numStr.length - 1] == '3' || [numStr characterAtIndex:numStr.length - 1] == '4') {
                resStr = NSLocalizedString(@"days2", @"days2");
            }
            else {
                resStr = NSLocalizedString(@"days", @"days");
            }
        }
        else {
            resStr = [numStr characterAtIndex:numStr.length - 1] == '1' ? NSLocalizedString(@"day", @"day")
            : NSLocalizedString(@"days", @"days");
        }
    }
    return resStr;
}

NSString *entriesStr(NSInteger num) {
    NSString *resStr = nil;
    NSString *numStr = [NSString stringWithFormat:@"%d", num];
    BOOL ruLang = [[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"ru"].location != NSNotFound;
    if (numStr.length) {
        if (ruLang) {
            if (numStr.length > 1 && [numStr characterAtIndex:numStr.length - 2] == '1') {
                resStr = NSLocalizedString(@"entries", @"entries");
            }
            else if ([numStr characterAtIndex:numStr.length - 1] == '1') {
                resStr = NSLocalizedString(@"entry", @"entry");
            }
            else if ([numStr characterAtIndex:numStr.length - 1] == '2' || [numStr characterAtIndex:numStr.length - 1] == '3' || [numStr characterAtIndex:numStr.length - 1] == '4') {
                resStr = NSLocalizedString(@"entries2", @"entries2");
            }
            else {
                resStr = NSLocalizedString(@"entries", @"entries");
            }
        }
        else {
            resStr = [numStr characterAtIndex:numStr.length - 1] == '1' ? NSLocalizedString(@"entry", @"entry")
            : NSLocalizedString(@"entries", @"entries");
        }
    }
    return resStr;
}

#pragma mark -
#pragma mark Getting info for visa

NSString *getCountryNameByCode(NSString *code) {
    NSLocale *locale = chooseLocale();
    return [code isEqualToString:@"SCH"] ? NSLocalizedString(@"Schengen", @"schengen") : [locale displayNameForKey:NSLocaleCountryCode value:code];
}

NSInteger getDurationNumForVisa(NSDictionary *visaData) {
    NSDate *entryDate = cutTime((NSDate *)[visaData objectForKey:@"entryDate"]);
    NSInteger stayDays = [visaData objectForKey:@"duration"] != nil ? [[visaData objectForKey:@"duration"] intValue] : 0;
    BOOL inCountry = [[visaData objectForKey:@"nowInCountry"] boolValue];
    if (checkForNotNull(entryDate) && inCountry && [[entryDate earlierDate:cutTime([NSDate date])] isEqualToDate:entryDate]) {
        stayDays = stayDays - daysBetweenDates(entryDate, cutTime([NSDate date]));
    }
    return stayDays > 0 ? stayDays : 0;
}

#pragma mark -
#pragma mark Other Utils

BOOL isSystemVersionMoreThen(CGFloat version) {
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= version;
}

BOOL checkForNotNull(id obj) {
    return (obj != nil && ![obj isEqual:[NSNull null]]);
}

NSLocale *chooseLocale(void) {
    NSString *localeID = [[[NSLocale preferredLanguages] objectAtIndex:0] rangeOfString:@"ru"].location == NSNotFound 
    ? @"en_US" : @"ru_RU";
    return [[[NSLocale alloc] initWithLocaleIdentifier:localeID] autorelease];
    
}

BOOL isCountryOfSchengen(NSString *countryCode) {
    NSArray *schengenCountries = [NSArray arrayWithObjects:@"AT", @"BE", @"HU", @"DE", @"GR", @"DK", @"IS", @"ES", @"IT", @"LV", 
                                                           @"LT", @"LU", @"MT", @"NL", @"NO", @"PL", @"PT", @"SK", @"SI", @"FI", 
                                                           @"FR", @"CZ", @"SZ", @"SE", @"EE", nil];
    return [schengenCountries indexOfObject:countryCode] != NSNotFound;
}

UIButton *createBackNavButton(void) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *btnFont = [UIFont boldSystemFontOfSize:12.0f];
    UIImage *image = [[UIImage imageNamed:@"back_btn.png"] stretchableImageWithLeftCapWidth:15.0f topCapHeight:0.0f];
    btn.frame = CGRectMake(0.0f, 0.0f, [NSLocalizedString(@"Back", @"back") sizeWithFont:btnFont].width + 30.0f, 32.0f);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setTitle:NSLocalizedString(@" Back", @"back") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = btnFont;
    return btn;
}

void showFullVersionInfo(NSString *info, UIViewController *vc) {
    FullVersionDescriptionVC *descrVC = [[[FullVersionDescriptionVC alloc] init] autorelease];
    descrVC.info = info;
    UINavigationController *navVC = [[[UINavigationController alloc] initWithRootViewController:descrVC] autorelease];
    [vc presentModalViewController:navVC animated:YES];
}
