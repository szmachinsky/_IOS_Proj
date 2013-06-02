//
//  ReviewsViewController.m
//  Voter
//
//  Created by Khitryk Artsiom on 14.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReviewsViewController.h"

@interface ReviewsViewController()

- (void)getReviewsDidSuccess:(id)object;
- (void)getReviewsDidFail:(id)object;
- (void)reportUserDidSuccess:(id)object;
- (void)reportUserDidFail:(id)object;

@end

@implementation ReviewsViewController
@synthesize  tableView = tableView_;
@synthesize customCell = customCell_;
@synthesize reviewsDSArray = reviewDSArray_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        reviewDSArray_ = [[NSMutableArray alloc]init];
        getReviewDic_ = [[NSMutableDictionary alloc]init];
        reportDic_ = [[NSMutableDictionary alloc]init];
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
    
    self.navigationItem.title = @"Reviews";

}

- (void)viewWillAppear:(BOOL)animated
{
    RequestsManager* requestManager = [RequestsManager sharedInstance];
    UserInfo* userInfo = [UserInfo sharedInstance];
    [getReviewDic_ setValue:userInfo.businessID forKey:@"business_id"];
    [requestManager getReviews:getReviewDic_ andDelegate:self doneSelector:@selector(getReviewsDidSuccess:) failSelector:@selector(getReviewsDidFail:)];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.tableView = nil;
    self.customCell = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - dealloc

- (void)dealloc
{
    [tableView_ release];
    [customCell_ release];
    [reviewDSArray_ release];
    [getReviewDic_ release];
    
    [super dealloc];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reviewsDSArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    UICustomReviewsCell* cell = nil;
    
    [[NSBundle mainBundle] loadNibNamed:@"UICustomReviewsCell" owner:self options:nil];
    
    cell = (UICustomReviewsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UICustomReviewsCell alloc]initWithReuseIdentifier:cellIdentifier]autorelease];
        cell = self.customCell;
        self.customCell = nil;
        
        for (UICustomReviewsCell* iteratorCell in [cell subviews]) 
        {
            if ([iteratorCell isMemberOfClass:[UITableViewCell class]])
                [iteratorCell removeFromSuperview];
        }
    }
    
    cell.nameLabel.text = (NSString*)[[self.reviewsDSArray objectAtIndex:indexPath.row]userName];
    cell.descriptionLabel.text = (NSString*)[[self.reviewsDSArray objectAtIndex:indexPath.row]review];
    cell.repotrButton.tag = 500 + indexPath.row;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

#pragma mark - Private Methods

- (void)getReviewsDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        NSArray* dic = (NSArray*)object;
        [self.reviewsDSArray removeAllObjects];
        
        for (NSDictionary* oneReview in dic)
        {
            Review* review = [[Review alloc]init];
            review.review = [oneReview objectForKey:@"review"];
            review.userName = [[oneReview objectForKey:@"user"] objectForKey:@"username"];
            review.photo = [[oneReview objectForKey:@"user"] objectForKey:@"photo"];
            review.mark = [oneReview objectForKey:@"mark"];
            review.idUser = [[oneReview objectForKey:@"user"] objectForKey:@"id"];
            
            [self.reviewsDSArray addObject:review];
        }
        
        [self.tableView reloadData];
    }
    else
    {
        
    }
}

- (void)getReviewsDidFail:(id)object
{
    
}

- (void)reportUserDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        
    }
    else
    {
        
    }
}

- (void)reportUserDidFail:(id)object
{
    
}

#pragma mark - Action Methods

- (IBAction)writeAReview:(id)sender
{
    UserInfo* userInfo = [UserInfo sharedInstance];
    if (userInfo.isUserLogin)
    {
        WriteAReviewViewController* writeAReviewViewController = [[[WriteAReviewViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]]autorelease];
        [self.navigationController pushViewController:writeAReviewViewController animated:YES]; 
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Sign in to vote" message:@"You must be signed in to fill out your ballot." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In", nil];
        [alertView show];
        [alertView release];  
    }

}

- (IBAction)reportUser:(id)sender
{
    UserInfo* userInfo = [UserInfo sharedInstance];
    if (userInfo.isUserLogin)
    {
        UIButton* buttonWithTag =(UIButton*)sender; 
        RequestsManager* requestManager = [RequestsManager sharedInstance];
        UserInfo* userInfo = [UserInfo sharedInstance];
        [reportDic_ setValue:userInfo.token forKey:@"token"];
        [reportDic_ setValue:(NSString*)[[self.reviewsDSArray objectAtIndex:buttonWithTag.tag - 500]idUser]  forKey:@"id"];
        
        [requestManager reportUser:reportDic_ andDelegate:self doneSelector:@selector(reportUserDidSuccess:) failSelector:@selector(reportUserDidFail:)];
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
    if (buttonIndex == 1)
    {
        SignInViewController* signInViewController = [[[SignInViewController alloc]initWithNibName:nil bundle:nil]autorelease];
        [self presentModalViewController:signInViewController animated:YES];
    }
}

@end
