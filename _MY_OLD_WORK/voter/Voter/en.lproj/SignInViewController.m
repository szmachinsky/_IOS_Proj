//
//  SignInViewController.m
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"
#import "ForgotViewController.h"
#import "NewLabelTextCell.h"
#import "NewButtonCell.h"


#define kTagEmail       1
#define kTagPassword    2


@interface SignInViewController ()
- (void)pressSignIn;
@end


//------------------------------------------------------------------------------
@implementation SignInViewController
@synthesize email=email_, password=password_;


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

    [facebookButton_ release];
    [twitterButton_ release];
    [googleButton_ release];
    [signUpButton_ release];
    [forgotPassButton_ release];
    
    self.email = nil;
    self.password = nil;
     
    [signButton_ release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [infoTableView_ release];
    infoTableView_ = nil;

    [facebookButton_ release];
    facebookButton_ = nil;
    [twitterButton_ release];
    twitterButton_ = nil;
    [googleButton_ release];
    googleButton_ = nil;
    [signUpButton_ release];
    signUpButton_ = nil;
    [forgotPassButton_ release];
    forgotPassButton_ = nil;
    
    [signButton_ release];
    signButton_ = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Local Voter";    
//    self.navigationItem.titleView.backgroundColor=[UIColor redColor];
//    UIView *title = self.navigationItem.titleView;
//    self.infoTableView.allowsSelection=NO;

//  [infoTableView_ reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View lifecycle

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    } else {
        return 1;
    }
}        


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =nil;    
    
    if (indexPath.section == 0) 
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
        
        switch (indexPath.row) {
           case 0: 
                [cell setFields:@"Email" editString:self.email Delegate:self Tag:kTagEmail Pos:60];
                break;
            case 1: 
                [cell setFields:@"Password" editString:self.password Delegate:self Tag:kTagPassword Pos:90];
                cell.cellText.secureTextEntry = YES;
                break;
                
            default:
                break;
        }
        return cell;                  
    }
    
    if (indexPath.section >= 1) 
    {    
        NewButtonCell *cell = (NewButtonCell*)[tableView dequeueReusableCellWithIdentifier:@"NewButtonCell"];
        if (cell == nil) 
        {
            NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"NewButtonCell" owner:self options:nil];
            for (UIView* aCell in loadedViews)
            {
                if ([aCell isMemberOfClass:[NewButtonCell class]])
                {
                    cell = (NewButtonCell*) aCell;
                    break;
                }         
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        if (indexPath.row == 0)
        {
            [cell.cellButton setTitle:@"Sign in" forState:UIControlStateNormal]; 
            [cell.cellButton addTarget:self action:@selector(pressSignIn) forControlEvents:UIControlEventTouchUpInside];
        }       
        return cell;   
    }
    
    return cell;
}

/*
- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef DEBUG
    NSLog(@"will select row %d in section %d)",indexPath.row,indexPath.section);
#endif 
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef DEBUG
    NSLog(@"was seleted row %d in section %d)", indexPath.row, indexPath.section);
#endif 
    if (indexPath.row==0 && indexPath.section == 1) {
        [self pressSignIn:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
*/

- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{   
#ifdef DEBUG   
//    NSLog(@"  enter(%@) from field %d)",textField.text,textField.tag);
#endif 
    NSString *text=textField.text; 
    switch (textField.tag) {
        case kTagEmail:
            self.email = text;
#ifdef DEBUG 
    NSLog(@" email=(%@)",self.email);
#endif                         
            break;
            
        case kTagPassword:
            self.password = text;
#ifdef DEBUG 
    NSLog(@" password=(%@)",self.password);
#endif                          
            break;
            
        default:
            break;
    }
    [textField resignFirstResponder];
//  [self.infoTableView reloadData];
    return YES;
}


#pragma mark - Button's press actions

- (void)pressSignIn {
#ifdef DEBUG
    NSLog(@"-pressSignIn");
#endif  
    [self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)pressFacebook:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressFacebook");
#endif        
}

- (IBAction)pressTwitter:(id)sender
{
#ifdef DEBUG
    NSLog(@"-pressTwitter");
#endif    
}

- (IBAction)pressGoogle:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressGoogle");
#endif    
}

- (IBAction)pressSignUp:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressSignUp");
#endif    
}

- (IBAction)pressForgotPassword:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressForgotPassword");    
#endif   
    forgotViewController_ = [[[ForgotViewController alloc] initWithNibName:@"ForgotViewController" bundle:nil] autorelease];
    forgotViewController_.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:forgotViewController_ animated:YES];                  
}

@end
