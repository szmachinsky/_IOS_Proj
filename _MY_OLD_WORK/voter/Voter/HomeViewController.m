//
//  HomeViewController.m
//  Voter
//
//  Created by Khitryk Artsiom on 08.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"

#import "UserInfo.h"

#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "EditProfileViewController.h"


@interface HomeViewController()

- (void)registerUserDidSuccess:(id)object;
- (void)registerUserDidFail:(id)object;


@end

@implementation HomeViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UserInfo sharedInstance].username = @"User_123";
    [UserInfo sharedInstance].email = @"User_123@tut.by";
    [UserInfo sharedInstance].password = @"12345678";
    [UserInfo sharedInstance].zipCode = @"123456";
    [UserInfo sharedInstance].yearOfBirth = @"1980";
}

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

#pragma mark - Action methods

- (IBAction)start:(id)sender
{
    RequestsManager* requestManager = [RequestsManager sharedInstance];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user4", @"username",
                                                                @"12345678", @"password",
                                                                 @"user4@tut.by", @"email",
                                                                @"123456", @"zip_code",
                                                                nil];
    
    [requestManager registerUserWithParams:dic andDelegate:self doneSelector:@selector(registerUserDidSuccess:) failSelector:@selector(registerUserDidFail:)];
    
}

- (IBAction)testPress:(id)sender { 
    SignInViewController *controller = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];
//  SignUpViewController *controller = [[[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil] autorelease];    
//  EditProfileViewController *controller = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil] ;                  
    [self presentModalViewController:controller animated:YES];
    
}

#pragma mark - Private methods

- (void)registerUserDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
#if DEBUG
        NSLog(@"RegisterUser success");
#endif
        NSDictionary* dic = (NSDictionary*)object;
        UserInfo* userInfo = [UserInfo sharedInstance];
        userInfo.token = [dic objectForKey:@"token"];
    }
    else
    {
        VoterServerError* error = (VoterServerError*)object;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:error.errorMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)registerUserDidFail:(id)object
{
    
}

@end
