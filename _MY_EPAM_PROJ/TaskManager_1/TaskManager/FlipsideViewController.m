//
//  FlipsideViewController.m
//  ViewUtility
//
//  Created by Administrator on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController
//@synthesize test;

@synthesize delegate=_delegate,showBar;

- (void)dealloc
{
    [navigationBar release];
//    [test release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
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
    self.title = NSLocalizedString(@"About",@"title of view");
    
    //[[test image] size];
    //   self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];  
//    self.
}

- (void)viewDidUnload
{
    [navigationBar release];
    navigationBar = nil;
//    [self setTest:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
//    NSLog(@"--go Back!");
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (IBAction)callMy:(id)sender {
//    NSLog(@"--call me");
}

- (IBAction)mailMy:(id)sender {
//    NSLog(@"--mail me");    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
        {
            NSLog(@"ok");
            }
    else
        {
            NSLog(@"cancel");
            }
}

-(IBAction)sendFeedback:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send feedback",@"feedback to me") message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"OK",@"ok in alert") otherButtonTitles: NSLocalizedString(@"Cancel",@"cancel in alert"), nil];
    [alert show];
    [alert release];
    
}

@end
