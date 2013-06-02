//
//  LocationManager.m
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"
#import "AppDelegate.h"
#import "FlurryAnalytics.h"
#import "LocationManager.h"
#import "Utils.h"

@interface LocationManager() 
@property (nonatomic, retain) MKReverseGeocoder *geoCoder;
@end

@implementation LocationManager 
@synthesize manager, geoCoder;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.manager = [[[CLLocationManager alloc] init] autorelease];
        self.manager.delegate = self; 
    }
    return self;
}

#pragma mark - Location delegate

- (void)showCountryChangedAlert:(NSString *)countryCode prevCode:(NSString *)prevCode {
    NSArray *countries = [[AppData sharedAppData].visas valueForKey:@"country"];
    BOOL arrive = NO;
    BOOL departure = NO;
    if ([countries indexOfObject:countryCode] != NSNotFound) {
        arrive = YES;
    }
    else if ([countries indexOfObject:prevCode] != NSNotFound) {
        departure = YES;
    }
    if (arrive || departure) {
        NSString *code = arrive ? countryCode : prevCode;
        NSString *country = getCountryNameByCode(code);
        NSString *alertText = arrive ? [NSString stringWithFormat:NSLocalizedString(@"Welcome to %@ (%@). Save the information about entry.", @"location change alert"), country, formattedDate([NSDate date], YES)]
        : [NSString stringWithFormat:NSLocalizedString(@"You left out %@ (%@). Save the information about the departure?", @"location change alert 2"), country, formattedDate([NSDate date], YES)];
        
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"MyVisas" message:alertText delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"no") otherButtonTitles:NSLocalizedString(@"Yes", @"yes"), nil] autorelease];
            [alert show];
        }
        else {
            UILocalNotification *localNote = [[[UILocalNotification alloc] init] autorelease];
            localNote.alertBody = alertText;
            localNote.alertAction = NSLocalizedString(@"Yes", @"yes");
            localNote.soundName = UILocalNotificationDefaultSoundName;
            localNote.applicationIconBadgeNumber = 1;
            localNote.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"location", @"type", code, @"countryCode", nil];
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNote];
            
            [AppData sharedAppData].lastLocation = [NSDictionary dictionaryWithObjectsAndKeys:alertText, @"text", code, @"countryCode", nil];
            [AppData sharedAppData].locationHandled = NO;
        }
    }
}

- (void)showLocationErrorAlert {
    [AppData sharedAppData].isLocationOn = NO;
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location error", @"location error") message:NSLocalizedString(@"Location can't be determined. Please, check your location services settings.", @"error message") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [alert show];
    [(AppDelegate *)[UIApplication sharedApplication].delegate switchOffLocationServices];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (isSystemVersionMoreThen(5.0)) {
        CLGeocoder *clGeoCoder = [[[CLGeocoder alloc] init] autorelease];
        [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
             if(placemarks.count > 0) {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 NSString *countryCode = placemark.ISOcountryCode;
                 BOOL schengen = isCountryOfSchengen(countryCode) && [[[AppData sharedAppData].visas valueForKey:@"country"] indexOfObject:@"SCH"] != NSNotFound;
                 if ((schengen || [[[AppData sharedAppData].visas valueForKey:@"country"] indexOfObject:countryCode] != NSNotFound) && checkForNotNull([AppData sharedAppData].currCountry) && ![countryCode isEqualToString:[AppData sharedAppData].currCountry]) {
                     [self showCountryChangedAlert:countryCode prevCode:[AppData sharedAppData].currCountry];
                 }
                 [AppData sharedAppData].currCountry = countryCode;
                 // TODO: delete NSLog
                 //NSLog(@"Country code:%@", countryCode);
             }
         }];
    }
    else {
        self.geoCoder = [[[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate] autorelease];
        geoCoder.delegate = self;
        [geoCoder start];
    }
    
    [FlurryAnalytics setLatitude:newLocation.coordinate.latitude            
                       longitude:newLocation.coordinate.longitude            
              horizontalAccuracy:newLocation.horizontalAccuracy            
                verticalAccuracy:newLocation.verticalAccuracy];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //NSLog(@"locationManager didFailWithError:%@", [error description]);
}

#pragma mark Geocoder delegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
    NSString *countryCode = placemark.countryCode;
    BOOL schengen = isCountryOfSchengen(countryCode) && [[[AppData sharedAppData].visas valueForKey:@"country"] indexOfObject:@"SCH"] != NSNotFound;
    if ((schengen || [[[AppData sharedAppData].visas valueForKey:@"country"] indexOfObject:countryCode] != NSNotFound) && checkForNotNull([AppData sharedAppData].currCountry) && ![countryCode isEqualToString:[AppData sharedAppData].currCountry]) {
        [self showCountryChangedAlert:countryCode prevCode:[AppData sharedAppData].currCountry];
    }
    [AppData sharedAppData].currCountry = countryCode;
    // TODO: delete NSLog
    //NSLog(@"Location:%@", countryCode);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
    // TODO: delete NSLog
    //NSLog(@"reverseGeocoder:%@ didFailWithError:%@", [geocoder description], [error description]);
}

#pragma mark -
#pragma mark Alerts delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate scrollToVisaByCurrLocation];
    }
}

- (void)dealloc {
    self.manager = nil;
    self.geoCoder = nil;
    [super dealloc];
}

@end
