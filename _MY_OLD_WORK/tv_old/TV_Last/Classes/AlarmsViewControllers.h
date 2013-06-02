//
//  AlarmsViewControllers.h
//  TVProgram
//
//  Created by User1 on 25.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowDescriptionCell;

@interface AlarmsViewControllers : UITableViewController {
    UITableView *tableview;
    IBOutlet ShowDescriptionCell *alarmCell;    
}

-(id)initWithTabBar;
-(void)update;

@end
