//
//  SignUpViewController.m
//  VoterTest
//
//  Created by User on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignInViewController.h"

#import "NewLabelTextCell.h"
#import "NewButtonCell.h"

#import "RequestsManager.h"
#import "VoterServerError.h"

#import "UserInfo.h"


#define kTagUsername    1
#define kTagEmail       2
#define kTagZipCode     3
#define kTagYearOfBirth 4
#define kTagPassword    5


@interface SignUpViewController ()
- (void)pressSignUp:(id)sender;
@end

//------------------------------------------------------------------------------
@implementation SignUpViewController
@synthesize username = username_, email = email_;
@synthesize zipCode = zipCode_, yearOfBirth = yearOfBirth_;
@synthesize password = password_;
@synthesize fbSession = fbSession_;
@synthesize twSession = twSession_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dictSignUp_ = [[NSMutableDictionary alloc] initWithCapacity:2]; //create dictionary for SignIn action
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
    [facebookButton_ release];
    facebookButton_ = nil;
    [twitterButton_ release];
    twitterButton_ = nil;
    [googleButton_ release];
    googleButton_ = nil;
    [signUpButton_ release];
    signUpButton_ = nil;
    [infoTableView_ release];
    infoTableView_ = nil;

    [scrollView_ release];
    scrollView_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [facebookButton_ release];
    [twitterButton_ release];
    [googleButton_ release];
    [signUpButton_ release];
    [infoTableView_ release];

    [scrollView_ release];
    
    self.username = nil;
    self.email = nil;
    self.zipCode = nil;
    self.yearOfBirth = nil;
    self.password = nil;
    
    [dictSignUp_ release];  
    
    [fbSession_ release];
    [twSession_ release];     
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    hideKeyboardShift = 0 + 5;
    
    self.username = @"";//[UserInfo sharedInstance].username;
    self.email = @"";//[UserInfo sharedInstance].email;
    self.password = @"";//[UserInfo sharedInstance].password;
    self.yearOfBirth = @"";//[UserInfo sharedInstance].yearOfBirth;
    self.zipCode = @"";//[UserInfo sharedInstance].zipCode;
 
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
        return 5;
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
                [cell setFields:@"Username" editString:self.username Delegate:self Tag:kTagUsername Pos:90];
                userField_ = cell.cellText;
                break;
            case 1: 
                [cell setFields:@"Email" editString:self.email Delegate:self Tag:kTagEmail Pos:60];
                emailField_ = cell.cellText;
                break;
            case 2: 
                [cell setFields:@"Zip code" editString:self.zipCode Delegate:self Tag:kTagZipCode Pos:80];
                zipField_ = cell.cellText;
                break;
            case 3: 
                [cell setFields:@"Year of Birth" editString:self.yearOfBirth Delegate:self Tag:kTagYearOfBirth Pos:105];
                yearField_ = cell.cellText;
                break;
           case 4: 
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
            [cell.cellButton setTitle:@"Sign up" forState:UIControlStateNormal]; 
            [cell.cellButton addTarget:self action:@selector(pressSignUp:) forControlEvents:UIControlEventTouchUpInside];
        }       
        return cell;   
    }
    
    return cell;
}


- (void) setTextFields 
{
    self.email = emailField_.text;
    self.username = userField_.text;
    self.zipCode = zipField_.text;
    self.yearOfBirth = yearField_.text;
    self.password = passField_.text;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{   
#ifdef DEBUG
    //  NSLog(@"  enter(%@) from field %d)",textField.text,textField.tag);    
#endif 
    [self setTextFields];
/*    
    NSString *text = textField.text;
    switch (textField.tag) 
    {
        case kTagUsername:
            self.username = text;
#ifdef DEBUG 
            NSLog(@" usename=(%@)",self.username);
#endif             
            break;
            
        case kTagEmail:
            self.email = text;
#ifdef DEBUG 
            NSLog(@" email=(%@)",self.email);
#endif             
            break;
            
        case kTagZipCode:
            self.zipCode = text;
#ifdef DEBUG 
            NSLog(@" zipCode=(%@)",self.zipCode);
#endif             
            break;
            
        case kTagYearOfBirth:
            self.yearOfBirth = text;
#ifdef DEBUG 
            NSLog(@" yearOfBirth=(%@)",self.yearOfBirth);
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
    return YES;
}



#pragma mark - Button's press actions


- (IBAction)pressFacebook:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressFacebook");
#endif       
    if (!fbSession_)
        fbSession_ = [[FBSession alloc] initWithDelegate:self];
    [fbSession_ facebookLogin];        
}

- (IBAction)pressTwitter:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressTwitter");
#endif
    if (!twSession_)
        twSession_ = [[TWSeccion alloc] initWithDelegate:self];
    [twSession_ twitterLogin];        
}

- (IBAction)pressGoogle:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressGoogle");
#endif    
}

- (IBAction)pressSignIn:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressSignIn");
#endif 
    [self dismissModalViewControllerAnimated:YES];     
//    SignInViewController *controller = [[[SignInViewController alloc] initWithNibName:@"SignInViewController" bundle:nil] autorelease];  
//    [self presentModalViewController:controller animated:YES];    
}



- (void)pressSignUp:(id)sender {
#ifdef DEBUG
    NSLog(@"-pressSignUp");
#endif 
    [self setTextFields];
    [self.view endEditing:YES];
    if (!self.email || !self.password || !self.username || !self.zipCode 
        || [email_ length] < 5 || [password_ length] < 1) 
    {  
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error Sign up" message:@"Enter valid Username Email Password and Zip code"  
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];        
        return;
    }
    int len = [self.password length];
    if (len <4 || len >20) 
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error Sign up" message:@"password must have from 4 to 20 chars"  
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];        
        return;
    }    
    
    RequestsManager* requestManager = [RequestsManager sharedInstance];
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:self.username, @"username",
                                self.email, @"email",
                                self.password, @"password",  
                                self.zipCode, @"zip_code",
 //                             self.yearOfBirth, @"birth_year",
                                nil];
    [dictSignUp_ removeAllObjects];
    [dictSignUp_ setValuesForKeysWithDictionary:dic];
    if ([self.yearOfBirth length] > 0)
        [dictSignUp_ setObject:self.yearOfBirth forKey:@"birth_year"];
    [requestManager registerUserWithParams:dictSignUp_ andDelegate:self doneSelector:@selector(registerUserDidSuccess:) failSelector:@selector(registerUserDidFail:)];
}

#pragma mark - Private methods

- (void)registerUserDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        NSDictionary* dic = (NSDictionary*)object;
        NSString *token = [dic objectForKey:@"token"];
        [UserInfo sharedInstance].username = self.username;
        [UserInfo sharedInstance].email = self.email;
        [UserInfo sharedInstance].password = self.password;
        [UserInfo sharedInstance].zipCode = self.zipCode;
        [UserInfo sharedInstance].yearOfBirth = self.yearOfBirth;
        [UserInfo sharedInstance].token = token;    
        
#if DEBUG
        NSLog(@"RegisterUser success. Token = %@",token);
#endif
    }
    else
    {
        VoterServerError* error = (VoterServerError*)object;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error Sign up" message:error.errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
    }
}

- (void)registerUserDidFail:(id)object
{
//    NSLog(@"Sign_UP FAIL!!!");    
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Fail Sign up" message:@"check your connection to Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
            NSLog(@"->screen_namе=(%@)",s2); 
            self.username = s2;
            [infoTableView_ reloadData];            
        }           
    }; 
}



@end
