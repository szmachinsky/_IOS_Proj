//
//  VoteModeViewController.m
//  Voter
//
//  Created by Khitryk Artsiom on 09.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kBizProfileUnclaimedView @"BizProfileUnclaimedViewController"
#define kBizProfileBasicView @"BizProfileBasicViewController"
#define kBizProfilePlusView @"BizProfilePlusViewController"
#define kBizProfilePremierView @"BizProfilePremierViewController"
#define kBizProfilePremPlusView @"BizProfilePremPlusViewController"

#import "VoteModeViewController.h"

@interface VoteModeViewController()

- (void)getBusinessessDidSuccess:(id)object;
- (void)getBusinessessDidFail:(id)object;

@end

@implementation VoteModeViewController
@synthesize tableView = tableView_;
@synthesize customCell = customCell_;
@synthesize voteDSArray = voteDSArray_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        voteDSArray_ = [[NSMutableArray alloc]init];
        voteDic_ = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(void) dealloc
{
    [tableView_ release];
    [customCell_ release];
    [voteDSArray_ release];
    
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

    self.navigationItem.title = @"Vote Mode";
    self.navigationItem.backBarButtonItem.title = @"Back";
}

- (void)viewWillAppear:(BOOL)animated
{
    UserInfo* userInfo = [UserInfo sharedInstance];
    RequestsManager* requestManager = [RequestsManager sharedInstance];
    [voteDic_ setValue:userInfo.subCategoryID forKey:@"subcategory_id[]"];
    [requestManager getBusinesses:voteDic_ andDelegate:self doneSelector:@selector(getBusinessessDidSuccess:) failSelector:@selector(getBusinessessDidFail:)];
}
- (void)viewDidUnload
{
    [super viewDidUnload];

    self.customCell = nil;
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.voteDSArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    
    UICustomVoteModeCell* cell = nil;
    
    [[NSBundle mainBundle] loadNibNamed:@"UICustomVoteModeCell" owner:self options:nil];
    
    cell = (UICustomVoteModeCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UICustomVoteModeCell alloc]initWithReuseIdentifier:cellIdentifier]autorelease];
        cell = self.customCell;
        self.customCell = nil;
        
        for (UICustomVoteModeCell* iteratorCell in [cell subviews])
        {
            if ([iteratorCell isMemberOfClass:[UITableView class]])
            {
                [iteratorCell removeFromSuperview];
            }
        }
    }
    
    cell.voteButton.tag = 100 + indexPath.row;
    
    
    cell.nominationLabel.text = (NSString*)[[self.voteDSArray objectAtIndex:indexPath.row] nameOfVote];
    //cell.nominationLabel.text
    //NSLog(@"%@", (NSString*)[[self.voteDSArray objectAtIndex:indexPath.row]nameOfVote]);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UserInfo* userInfo = [UserInfo sharedInstance];
    userInfo.businessID = (NSString*)[[self.voteDSArray objectAtIndex:indexPath.row]idVoteMode];
    
    BizProfileViewController* bizProfileViewController = [[[BizProfileViewController alloc]initWithNibName:kBizProfilePremierView bundle:[NSBundle mainBundle]]autorelease];
    [self.navigationController pushViewController:bizProfileViewController animated:YES];
}

#pragma mark - Actions Methods

- (IBAction)vote:(id)sender
{
    UserInfo* userInfo = [UserInfo sharedInstance];
    if (userInfo.isUserLogin)
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Thanks for your vote! Would you like to share this?" delegate:self cancelButtonTitle:@"Share" otherButtonTitles:@"No Thanks", nil];
        [alertView show];
        [alertView release];   
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Sign in to vote" message:@"You must be signed in to fill out your ballot." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
        [alertView show];
        [alertView release];  
    }

}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UserInfo* userInfo = [UserInfo sharedInstance];
    
    if (userInfo.isUserLogin)
    {
        if (buttonIndex == 0)
        {
            ShareViewController* shareViewController = [[[ShareViewController alloc]initWithNibName:nil bundle:nil]autorelease];
            [self presentModalViewController:shareViewController animated:YES];
        }
        else
        {
            
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            SignInViewController* signInViewController = [[[SignInViewController alloc]initWithNibName:nil bundle:nil]autorelease];
            [self presentModalViewController:signInViewController animated:YES];
        }
        else
        {
            
        }
    }

}

#pragma mark - Private Methods

- (void)getBusinessessDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        NSArray* array = (NSArray*)object;
        [self.voteDSArray removeAllObjects];
        
        for (NSDictionary* dic in array)
        {
            VoteMode* vote = [[VoteMode alloc]init];
            vote.image = @"http://vote.jpg";
            vote.idVoteMode = [dic objectForKey:@"id"];
            vote.nameOfVote = [dic objectForKey:@"name"];
            
            [self.voteDSArray addObject:vote];
            [vote release];
        }
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"error");
    }
}

- (void)getBusinessessDidFail:(id)object
{
    
}

@end
