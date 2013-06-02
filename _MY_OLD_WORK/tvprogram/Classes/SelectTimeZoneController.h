//
//  SelectChannelsController.h
//  TVProgram
//
//  Created by User1 on 09.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTimeZoneController : UITableViewController { 
    UITableView *mytableView;
    NSMutableArray *zones;
    NSTimeZone * prevTimeZone;
}

@end
