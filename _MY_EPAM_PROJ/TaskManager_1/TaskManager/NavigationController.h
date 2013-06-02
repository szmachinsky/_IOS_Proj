//
//  NavigationController.h
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@class DataSource;
@class DetailsViewController;



@interface NavigationController : UITableViewController <FlipsideViewControllerDelegate> {
    
    DataSource *taskDat;
    int modeView;
    
}

- (IBAction)rightButtonPressed:(id)sender;

- (IBAction)selectorButtonPressed:(id)sender;

@end
