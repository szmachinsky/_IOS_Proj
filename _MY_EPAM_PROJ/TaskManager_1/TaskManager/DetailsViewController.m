//
//  DetailsViewController.m
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailsViewController.h"
//#import "CellItem.h"
#import "DataSource.h"
#import "Task.h"

@implementation DetailsViewController
@synthesize taskDat,taskID,taskInd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
     NSLog(@"--Dealloc--");
    [doneButton release];
    [editButton release];
    
    [taskName release];
    [taskDetails release];
    [taskDate release];
    
    [taskID release];
    
    [deleteButton release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Details";
    
    UIBarButtonItem *edButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(showEdit)];    
    [[self navigationItem] setRightBarButtonItem:edButton animated:YES];
    [edButton release];
    
    editButton.hidden=YES;
    
    //deleteButton.titleLabel.text=NSLocalizedString(@"Delete task",);
    // Do any additional setup after loading the view from its nib.
//    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:100 ];
}

- (void)viewDidUnload
{
    NSLog(@"--DidUnload--");
    
    [doneButton release];
    doneButton=nil;
    
    [editButton release];
    editButton = nil;
    
    [taskName release];
    taskName=nil;
    
    [taskDetails release];
    taskDetails=nil;
 
    [taskID release];
    taskID = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
     
    [deleteButton release];
    deleteButton = nil;
    
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//===========================================================
- (void)viewWillAppear:(BOOL)animated { //zs
//    NSLog(@"--will Appear--id=%d",[taskID row]);
    [super viewWillAppear:animated];
    
//  task = [taskDat taskByIndex:taskID];
    task = [taskDat objByIndex:taskInd];
    
    [taskName setText:task.taskName];
    NSString *ss;
    if (task.taskCompleted == 0) {
        ss=task.taskComment;
    } else {
        ss=[NSString stringWithFormat:@"%@ (Completed)",task.taskComment];
    }
    [taskDetails setText:ss];
    
    [taskDate setText:[NSString stringWithFormat:@"%@",task.dateDueTo]];    
//  [taskDate setText:[cellDat strDueDateByIndex:cellID FormStyle:NSDateFormatterFullStyle]];
    
    
    self.title = @"Details1";
    [[self navigationItem] setTitle:task.taskName];
}

-(void)viewWillDisappear:(BOOL)animated { //zs
//NSLog(@"--will Disappear--");
    [super viewWillDisappear:animated];
    
}

//--------------------------------------------------------------------------------------
- (IBAction)buttonPressed:(id)sender {
//    NSLog(@"button DONE pressed");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Task",) message:NSLocalizedString(@"will be marked as Completed in task list!",) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",) otherButtonTitles: NSLocalizedString(@"Cancel",), nil];
    alert.tag=1;
    [alert show];
    [alert release];    
//  [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)delButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Task",) message:NSLocalizedString(@"will be Deleted from task list!",) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",) otherButtonTitles: NSLocalizedString(@"Cancel",), nil];
    alert.tag=2;
    [alert show];
    [alert release];    
    
}

//--------------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
//        NSLog(@"ok");
        if (taskInd < [taskDat count]) {
            int tag=actionSheet.tag;
//          NSLog(@"tag=%d",actionSheet.tag);
            if (tag==1) { //completed
                task.taskCompleted=1;
                task.dateDueTo=[NSDate date];
            }
            if (tag==2) { //deleted
                [taskDat removeByIndex:taskInd]; //zs
            }
        
            
            [taskDat saveReloadtaskList];
        }
        
        [[self navigationController] popViewControllerAnimated:YES];
        
    }
    else
    {
//        NSLog(@"cancel");
    }
}


//=======================================================================================
- (void)flipsideViewControllerDidFinish:(EditViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    [[self navigationController] popViewControllerAnimated:NO]; //redirect to main
    
}


- (void)showEdit
{    
    EditViewController *controller = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    
    controller.delegate = self;
    //controller.delegate = [[[self navigationController] viewControllers] objectAtIndex:0];

    controller.showBar = 1;
    
    controller.taskDat=taskDat;
    controller.taskID=taskID;
    controller.taskInd=taskInd;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    [[controller navigationItem] setTitle:@"Edit_task"];
    
    [controller release];
}

//=======================================================================================


- (IBAction)edButtonPressed:(id)sender{
    NSLog(@"button EDIT pressed");    
    [self showEdit];
}



@end
