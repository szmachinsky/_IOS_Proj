//
//  ForgotViewController.m
//  VoterTest
//
//  Created by User on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgotViewController.h"
#import "SignInViewController.h"
#import "NewLabelTextCell.h"
#import "NewButtonCell.h"

#import "UserInfo.h"

#define kTagEmail       1


@interface ForgotViewController () 
- (void)pressSendNewPassword;
- (void)pressSignIn; 
- (void)pressCancel;
@end


//------------------------------------------------------------------------------
@implementation ForgotViewController
@synthesize email = email_;

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

- (void)dealloc {
    [infoTableView_ release];
    [infoLabel_ release];
    
    self.email = nil;
    
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [infoTableView_ release];
    infoTableView_ = nil;
    [infoLabel_ release];
    infoLabel_ = nil;
    
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


#pragma mark - Table View lifecycle

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (showMode_ == 1) return 1;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}        


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =nil;    
    int num = indexPath.section;
    if (showMode_ == 1) num = 1;
    
    if (num == 0) 
    {  
        NewLabelTextCell *cell = (NewLabelTextCell*)[tableView dequeueReusableCellWithIdentifier:@"NewLabelTextCell"];
        if (cell == nil) 
        {
            NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewLabelTextCell" owner:self options:nil];
            for (UIView* aCell in loadedViews)
            {
                if ([aCell isMemberOfClass:[NewLabelTextCell class]])
                {
                    cell = (NewLabelTextCell*) aCell; break;
                }                
            }            
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;       
        [cell setFields:@"Email" editString:self.email Delegate:self Tag:kTagEmail Pos:60];
        return cell;                  
    }
    
    if (num == 1) 
    {    
        NewButtonCell *cell = (NewButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"NewButtonCell"];
        if (cell == nil) 
        {
            NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewButtonCell" owner:self options:nil];
            for (UIView* aCell in loadedViews)
            {
                if ([aCell isMemberOfClass:[NewButtonCell class]])
                {
                    cell = (NewButtonCell*) aCell; break;
                }         
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        if (showMode_ == 1)
        {
            [cell.cellButton setTitle:@"Sign in" forState:UIControlStateNormal]; 
            [cell.cellButton addTarget:self action:@selector(pressSignIn) forControlEvents:UIControlEventTouchUpInside];
        }  else {
            [cell.cellButton setTitle:@"Send new password" forState:UIControlStateNormal]; 
            [cell.cellButton addTarget:self action:@selector(pressSendNewPassword) forControlEvents:UIControlEventTouchUpInside];            
        }
        return cell;   
    }
    
    if (num >= 2) 
    {    
        NewButtonCell *cell = (NewButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"NewButtonCell"];
        if (cell == nil) 
        {
            NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewButtonCell" owner:self options:nil];
            for (UIView* aCell in loadedViews)
            {
                if ([aCell isMemberOfClass:[NewButtonCell class]])
                {
                    cell = (NewButtonCell*) aCell; break;
                }         
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        [cell.cellButton setTitle:@"Cancel" forState:UIControlStateNormal]; 
        [cell.cellButton addTarget:self action:@selector(pressCancel) forControlEvents:UIControlEventTouchUpInside];     
        return cell;   
    }
 
    
    return cell;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{   
#ifdef DEBUG   
//    NSLog(@"  enter(%@) from field %d)",textField.text,textField.tag);
#endif 
    NSString *text=textField.text; 
    if (textField.tag == kTagEmail) 
    {
        self.email = text;
#ifdef DEBUG 
        NSLog(@" email=(%@)",self.email);
#endif                         
    }
    
    [textField resignFirstResponder];
//  [infoTableView_ reloadData];
    return YES;
}



#pragma mark - Button's press actions

- (void)pressSendNewPassword 
{
#ifdef DEBUG
    NSLog(@"-pressSendNewPassword");
#endif    
    infoLabel_.text = @"Your new password has been sent";
    infoLabel_.textAlignment = UITextAlignmentCenter;
    showMode_ = 1;    
    [infoTableView_ reloadData];    
}

- (void)pressSignIn 
{
#ifdef DEBUG
    NSLog(@"-pressSignIn");   
#endif 
/*    
    signInViewController_ = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];
    //  signInViewController_.delegate=self;
    signInViewController_.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:signInViewController_ animated:YES];            
*/
   [self dismissModalViewControllerAnimated:YES];     
}

- (void)pressCancel 
{
#ifdef DEBUG
    NSLog(@"-pressCancel");
#endif    
    [self dismissModalViewControllerAnimated:YES];    
}


@end
