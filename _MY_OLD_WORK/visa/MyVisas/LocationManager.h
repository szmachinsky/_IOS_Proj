//
//  LocationManager.h
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate, MKReverseGeocoderDelegate, UIAlertViewDelegate> {
    
}
@property (nonatomic, retain) CLLocationManager *manager;

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
- (void)showLocationErrorAlert;

@end
