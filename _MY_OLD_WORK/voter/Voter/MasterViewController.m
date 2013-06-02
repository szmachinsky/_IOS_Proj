//
//  MasterViewController.m
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "SignInViewController.h"
#import "ForgotViewController.h"
#import "SignUpViewController.h"
#import "EditProfileViewController.h"

#import "TestViewController.h"
#import "TestScrollController.h"

#import "MyProfileViewController.h"

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)dealloc
{
    [_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // Configure the cell.
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Detail";
            break;
        case 1:
            cell.textLabel.text = @"sign in";
            break;
        case 2:
            cell.textLabel.text = @"forgot";
            break;
        case 3:
            cell.textLabel.text = @"sign up";
            break;
        case 4:
            cell.textLabel.text = @"edit profile";
            break;
        case 5:
            cell.textLabel.text = @"test";
            break;
        case 6:
            cell.textLabel.text = @"test scroll";
            break;
            
        case 7:
            cell.textLabel.text = @"my profile";
            break;
           
        default:
            break;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)flipsideViewControllerDidFinish:(UIViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if (!self.detailViewController) {
                self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
  
            }
            [self.navigationController pushViewController:self.detailViewController animated:YES];            
            break;
        case 1:
//          SignInViewController *detailController = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease]; 
            signInViewController_ = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];
//          signInViewController_.delegate=self;
            signInViewController_.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:signInViewController_ animated:YES];            
            break;
            
        case 2:
            forgotViewController_ = [[[ForgotViewController alloc] initWithNibName:@"ForgotViewController" bundle:nil] autorelease];
//          forgotViewController.delegate=self;
            forgotViewController_.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:forgotViewController_ animated:YES];            
            break;
            
        case 3:
            signUpViewController_ = [[[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil] autorelease];
//          signUpViewController_.delegate=self;
            signUpViewController_.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:signUpViewController_ animated:YES];            
            break;
            
        case 4:
            if (!editProfileViewController_)
                editProfileViewController_ = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil] ;                  
            [self.navigationController pushViewController:editProfileViewController_ animated:YES];            
            break;
            
        case 5:
            testViewController = [[[TestViewController alloc] initWithNibName:@"TestViewController" bundle:nil] autorelease];
            //          signUpViewController_.delegate=self;
            testViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:testViewController animated:YES];            
            break;
            
        case 6:
            testScrollController = [[[TestScrollController alloc] initWithNibName:@"TestScrollController" bundle:nil] autorelease];
            //          signUpViewController_.delegate=self;
            testScrollController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:testScrollController animated:YES];            
            break;
            
        case 7:
            myProfileViewController = [[[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil] autorelease];
            //          signUpViewController_.delegate=self;
            myProfileViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:myProfileViewController animated:YES];            
            break;
            
        default:
            break;
    }
    

    
}

@end
