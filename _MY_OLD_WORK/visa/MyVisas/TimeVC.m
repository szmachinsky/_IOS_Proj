//
//  TimeVC.m
//  MyVisas
//
//  Created by Nnn on 26.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"
#import "AppDelegate.h"
#import "TimeVC.h"
#import "Utils.h"

@implementation TimeVC
@synthesize index;

- (void)dealloc {
    [datePicker release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = createBackNavButton();
    [btn addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)backPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *timeStr = [[AppData sharedAppData].alertsTime objectAtIndex:index];
    NSString *format = [[timeStr componentsSeparatedByString:@" "] count] > 1 ? @"HH:mm a" : @"HH:mm";
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:format];
    NSDate *time = [formatter dateFromString:timeStr];
    if (checkForNotNull(time)) {
        datePicker.date = time;
    }
}

- (void)saveNewSettings {
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"HH:mm"];
    [[AppData sharedAppData].alertsTime replaceObjectAtIndex:index withObject:[formatter stringFromDate:[datePicker date]]];
    [(AppDelegate *)[UIApplication sharedApplication].delegate recreateNotifications];
}

- (void)appResignActive {
    [self saveNewSettings];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self saveNewSettings];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
