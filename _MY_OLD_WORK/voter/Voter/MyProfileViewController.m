//
//  MyProfileViewController.m
//  VoterTest
//
//  Created by User User on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyProfileViewController.h"

#define kShiftPos 220

@implementation MyProfileViewController
@synthesize tableView = tableView_;
@synthesize reportUser = reportUser_, editProfile = editProfile_;
@synthesize name = name_, address = address_, image = image_;
@synthesize customCell = customCell_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDelegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    UICustomProfileCell* cell = nil;
    
    [[NSBundle mainBundle] loadNibNamed:@"UICustomProfileCell" owner:self options:nil];
    
    cell = (UICustomProfileCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UICustomProfileCell alloc]initWithReuseIdentifier:cellIdentifier]autorelease];
        cell = self.customCell;
        self.customCell = nil;
        
        for (UICustomProfileCell* iteratorCell in [cell subviews]) 
        {
            if ([iteratorCell isMemberOfClass:[UITableViewCell class]])
                [iteratorCell removeFromSuperview];
        }
    }
    
    return cell;
}

#pragma mark - dealloc

- (void)dealloc
{
    [tableView_ release];
    [reportUser_ release];
    [editProfile_ release];
    [image_ release];
    [name_ release];
    [address_ release];
    
    [customCell_ release];
    
    [super dealloc];
}

@end
