//
//  EditViewController.m
//  TaskManager
//
//  Created by Sergei Zmachinsky on 8/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"
//#import "CellItem.h"
#import "DataSource.h"
#import "Task.h"


@implementation EditViewController
@synthesize navigationItem;
@synthesize delegate=_delegate,showBar;
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
    [editName release];
    [editDescription release];
    [navigationBar release];
    [navigationItem release];
    [dataPic release];
    
    [taskID release];

    [task release];
    
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
    if (showBar) {
        navigationBar.hidden = NO;
    } else {
        navigationBar.hidden = YES;
    }
    //self.title = @"Add new task";
    [[self navigationItem] setTitle:@"SRRTT"];
    
    NSDate *dat = [NSDate date];
    [dataPic setDate:dat];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [editName release];
    editName = nil;
    
    [editDescription release];
    editDescription = nil;
    
    [navigationBar release];
    navigationBar = nil;
    
    [self setNavigationItem:nil];
    
    [dataPic release];
    dataPic = nil;

    [task release];
    task=nil;
    
    [taskID release];
    taskID = nil;
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//===========================================================
- (void)viewWillAppear:(BOOL)animated { //zs
//    NSLog(@"--will Appear--id=%d",[taskID row]) ;
    [super viewWillAppear:animated];    
    
//  if (taskID == nil) { //add
    if (taskInd < 0) { //add
        task = [[Task alloc] initWithName:@"new task"];
        [editName setText:@"new task"];
        [editDescription setText:@""];

   } else {
//      task = [taskDat taskByIndex:taskID];
        task = [taskDat objByIndex:taskInd];
        [task retain];
        [editName setText:task.taskName];
        [editDescription setText:task.taskComment];
        dataPic.date=task.dateDueTo;

    }
}

-(void)viewWillDisappear:(BOOL)animated { //zs
//    NSLog(@"--will Disappear--");
    [super viewWillDisappear:animated];
    
    [editName resignFirstResponder];
    [editDescription resignFirstResponder];
}



- (IBAction)done:(id)sender
{
    NSLog(@"--go Back Done!");
//  NSDate *dat=[dataPic date];
    NSDate *dat=dataPic.date;

    task.taskName=[editName text];
    task.taskComment=[editDescription text];
    task.dateDueTo=dat;        
    
    if (taskID == nil) { //new 
        [taskDat addNewObject:task];         
    } else {        
    
    }
//    NSLog(@"task=%@",task);
//  [taskDat saveTaskListToFile:[taskDat nameOfFile]];   //save task list to file
//  [taskDat loadTaskListFromFile:[taskDat nameOfFile]]; //load task list from file  
    [taskDat saveReloadtaskList];
    
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)cancel:(id)sender
{
    NSLog(@"--go Back Cancel!");
    [self.delegate flipsideViewControllerDidFinish:self];
}


- (BOOL) textFieldShouldReturn:(UITextField *)stextField //zs
{
//    NSLog(@"edit10 %@",[stextField text]);        
    [stextField resignFirstResponder];
    return YES;
}



@end
