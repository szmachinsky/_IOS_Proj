//
//  SignInViewController.m
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignInViewController.h"
#import "SignUpViewController.h"

#import "ForgotViewController.h"
#import "NewLabelTextCell.h"
#import "NewButtonCell.h"

#import "UserInfo.h"


//static NSString* kAppId = @"331663473546996";


#define kTagEmail       1
#define kTagPassword    2


@interface SignInViewController (FB_TW_Connection)
@end


@interface SignInViewController ()
- (void)pressSignIn;
- (void)signInDidSuccess:(id)object;
- (void)signInDidFail:(id)object;

@end


//------------------------------------------------------------------------------
@implementation SignInViewController
@synthesize email=email_, password=password_;
@synthesize fbSession = fbSession_;
@synthesize twSession = twSession_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dictSignIn_ = [[NSMutableDictionary alloc] initWithCapacity:2]; //create dictionary for SignIn action
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
     
    [dictSignIn_ release];
    
    [fbSession_ release];
    [twSession_ release];     
    
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
   
    self.email = @"";//[UserInfo sharedInstance].email;
    self.password = @"";//[UserInfo sharedInstance].password;

//  [infoTableView_ reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
     
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
                emailField_ = cell.cellText;
                break;
            case 1: 
                [cell setFields:@"Password" editString:self.password Delegate:self Tag:kTagPassword Pos:90];
                passField_ = cell.cellText;
                cell.cellText.secureTextEntry = YES;
                cell.cellText.clearsOnBeginEditing = YES;
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
    self.email = emailField_.text;
    self.password = passField_.text;
/*    
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
*/    
    [textField resignFirstResponder];
//  [self.infoTableView reloadData];
    return YES;
}


#pragma mark - Button's press actions
//===============================================================================
- (IBAction)pressFacebook:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressFacebook");
#endif 
    if (!fbSession_)
        fbSession_ = [[FBSession alloc] initWithDelegate:self];
    [fbSession_ facebookLogin];    
}

- (IBAction)pressTwitter:(id)sender
{
#ifdef DEBUG
    NSLog(@"-pressTwitter");
#endif  
    if (!twSession_)
        twSession_ = [[TWSeccion alloc] initWithDelegate:self];
    [twSession_ twitterLogin];        
}

- (IBAction)pressGoogle:(id)sender {
#ifdef DEBUG
//    NSLog(@"-pressGoogle");
#endif    
}

- (IBAction)pressSignUp:(id)sender {
#ifdef DEBUG
//    NSLog(@"-pressSignUp");
#endif 
//  [self dismissModalViewControllerAnimated:YES];         
    [self.view endEditing:YES];
//  [twSession_ twitterLogout];
    
    SignUpViewController *controller = [[[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil] autorelease];  
    [self presentModalViewController:controller animated:YES];    
    
}

- (IBAction)pressForgotPassword:(id)sender {
#ifdef DEBUG
//    NSLog(@"-pressForgotPassword");    
#endif   
    forgotViewController_ = [[[ForgotViewController alloc] initWithNibName:@"ForgotViewController" bundle:nil] autorelease];
    forgotViewController_.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    forgotViewController_.email = self.email;
    [self presentModalViewController:forgotViewController_ animated:YES];                  
}


#pragma mark - Sign In methods
//===============================================================================
- (void)pressSignIn {
#ifdef DEBUG
   NSLog(@"-pressSignIn");
#endif  
    self.email = emailField_.text;
    self.password = passField_.text;
    [self.view endEditing:YES];
    if (!self.email || !self.password || [email_ length] < 5 || [password_ length] < 1) 
    {
//NSLog(@"(%@) : (%@)",self.email, self.password);        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error Sign in" message:@"Enter valid Email and Password"  
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];        
        return;
    }
    int len = [self.password length];
//NSLog(@"(%@) : (%@) : %d",self.email,self.password,len);
    if (len <4 || len >20) 
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error Sign in" message:@"Password must have from 4 to 20 chars"  
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];        
        return;
    }
    
    RequestsManager* requestManager = [RequestsManager sharedInstance];
//  dictSignIn_ = [[NSMutableDictionary alloc] initWithObjectsAndKeys:password_, @"password", email_,  @"username", nil];
    [dictSignIn_ removeAllObjects];
    [dictSignIn_ setObject:self.email forKey:@"username"];   
    [dictSignIn_ setObject:self.password forKey: @"password"];         
    [requestManager signIn:dictSignIn_ andDelegate:self doneSelector:@selector(signInDidSuccess:) failSelector:@selector(signInDidFail:)];
}


#pragma mark - Private Methods
- (void)signInDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {        
        NSDictionary* dic = (NSDictionary*)object;
        NSString* token = (NSString*)[dic objectForKey:@"token"];
        [UserInfo sharedInstance].email = self.email;
        [UserInfo sharedInstance].password = self.password;
        [UserInfo sharedInstance].token = token;    

        UserInfo* userInfo = [UserInfo sharedInstance];
        userInfo.isUserLogin = YES;
        
        [self dismissModalViewControllerAnimated:YES];
#if DEBUG
        NSLog(@"Sign_In success. Token = %@",token);
#endif
        
    }
    else
    {
        VoterServerError* error = (VoterServerError*)object;        
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error Sign in" message:error.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];        
    }
}

- (void)signInDidFail:(id)object
{
//  NSLog(@"Sign_In FAIL!!!");   
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Fail Sign in" message:@"check your connection to Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];            
}



#pragma mark - delegate for FaceBookSeccion
//===============================================================================
- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date 
{
#ifdef DEBUG
    NSLog(@"FBdelegate:token:(%@)",token);
    NSLog(@"FBdelegate:date:%@",date); 
#endif
    [fbSession_ facebookGetInfo];   
}

- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date withInfo:(NSMutableDictionary*)result 
{
    NSString *email = [result valueForKey:@"email"];
    NSString *name = [result valueForKey:@"name"];    
#ifdef DEBUG
    NSLog(@"FBdelegate:token:(%@)",token);
    NSLog(@"FBdelegate:date:%@",date);   
    NSLog(@"(%@)(%@)",email,name);     
#endif
    self.email = email;
    [infoTableView_ reloadData];
}


#pragma mark - delegate for TwitterSeccion
//===============================================================================
- (void)twDidLogin:(NSString*)data forUsername:(NSString *)username
{
#ifdef DEBUG
//    NSLog(@"TWdelegate:username:(%@)",username);
    NSLog(@"TWdelegate:data:(%@)",data);
#endif    
    NSArray *ar;
    NSString *s1, *s2;
    NSArray *arr = [data componentsSeparatedByString:@"&"];
    for (NSString *str in arr) {
//        NSLog(@"->(%@)",str);
        ar = [str componentsSeparatedByString:@"="];
        s1 = [ar objectAtIndex:0];
        s2 = [ar objectAtIndex:1];
//        NSLog(@"->(%@)==(%@)",s1,s2); 
        if ([s1 isEqualToString:@"oauth_token"]) {
            NSLog(@"->oauth_token=(%@)",s2);         
        }
        if ([s1 isEqualToString:@"oauth_token_secret"]) {
            NSLog(@"->oauth_token_secret=(%@)",s2);                     
        }
        if ([s1 isEqualToString:@"screen_name"]) {
            NSLog(@"->screen_name=(%@)",s2);         
        }           
    }; 
}



@end


