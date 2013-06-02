//
//  EditUrlViewController.m
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditUrlViewController.h"


@implementation EditUrlViewController
@synthesize delegate=_delegate;
@synthesize editLink = _editLink;


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
    [_editLink release];
    [buttonOK release];
    [buttonCancel release];
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
    // Do any additional setup after loading the view from its nib.
    self.editLink.text=@"http://www.";
}

- (void)viewDidUnload
{
    [self setEditLink:nil];
    [buttonOK release];
    buttonOK = nil;
    [buttonCancel release];
    buttonCancel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL) textFieldShouldReturn:(UITextField *)stextField //zs
{
    //    NSLog(@"edit10 %@",[stextField text]);        
    [stextField resignFirstResponder];
    return YES;
}

-(IBAction) pressOK:(id) object
{
    [self.delegate linkWasChanged:self Link:[_editLink text]];
//    [self.delegate flipsideViewControllerDidFinish:self];    
}


-(IBAction) pressCancel:(id) object 
{
    [self.delegate flipsideViewControllerDidFinish:self];    
}


@end
