//
//  DetailsViewController.h
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
//@class CellItem;
@class DataSource;


@interface DetailsViewController : UIViewController  <UIAlertViewDelegate, FlipsideViewControllerDelegate>  {
    IBOutlet UIButton *doneButton;
    IBOutlet UILabel *taskName;
    IBOutlet UILabel *taskDetails;    
    IBOutlet UILabel *taskDate;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *deleteButton;
        
    DataSource  *taskDat;    
    NSIndexPath *taskID;
    int taskInd;

    Task *task; 
}
@property (nonatomic,assign) DataSource *taskDat; 
@property (nonatomic,retain) NSIndexPath *taskID;
@property (nonatomic) int taskInd;


- (IBAction)buttonPressed:(id)sender;
- (IBAction)edButtonPressed:(id)sender;
- (IBAction)delButtonPressed:(id)sender;


@end
