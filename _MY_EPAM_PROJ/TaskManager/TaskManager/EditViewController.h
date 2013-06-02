//
//  EditViewController.h
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DataSource;
@class Task;

@protocol FlipsideViewControllerDelegate;

@interface EditViewController : UIViewController  <UITextFieldDelegate> {
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UITextField *editName;
    IBOutlet UITextField *editDescription;
    IBOutlet UIDatePicker *dataPic;
    UINavigationItem *navigationItem;
    
    DataSource  *taskDat;    
    NSIndexPath *taskID;
    int taskInd;
    
    Task *task;

}
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;

@property (nonatomic,assign) DataSource *taskDat; 
@property (nonatomic,retain) NSIndexPath *taskID;
@property (nonatomic) int taskInd;

@property (nonatomic) int showBar;


- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end



@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(EditViewController *)controller;
@end
