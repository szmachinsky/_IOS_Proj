//
//  BizProfileViewController.m
//  Voter
//
//  Created by Khitryk Artsiom on 10.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "BizProfileViewController.h"

@interface BizProfileViewController()

- (void)getBusinessDidSuccess:(id)object;
- (void)getBusinessDidFail:(id)object;
- (CGSize)calculateSizeForText:(NSString*)text withFont:(NSString*)font size:(CGFloat)size;
- (void)createViewForBizProfileUnclaimed;
- (void)createViewForBizProfileBasic;
- (void)createViewForBizProfilePlus;
- (void)createViewForBizProfilePremier;
- (void)createViewForBizProfilePremPlus;
- (void)createFooterView;
- (void)createHeaderView;

@end



@implementation BizProfileViewController
@synthesize nominationLabel = nominationLabel_, siteButton = siteButton_, adressLabel = adressLabel_, phoneButton = phoneButton_, phoneLabel = phoneLabel_, siteLabel = siteLabel_;
@synthesize webView = webView_;
@synthesize voteForUsButton = voteForUsButton_, writeAReviewButton = writeAReviewButton_, reviewsLabel = reviewsLabel_, reviewsButton = reviewsButton_;
@synthesize facebookButton = facebookButton_, twitterButton = twitterButton_, googleButton = googleButton_;
@synthesize profileDic = profileDic_;
@synthesize profileInfo = profileInfo_;
@synthesize descriptionLabel = descriptionLabel_, scheduleLabel = scheduleLabel_, nameOfscheduleLabel = nameOfScheduleLabel_, nameOfdescriptionLabel = nameOfDescriptionLabel_;
@synthesize menuButton = menuButton_, menuLabel = menuLabel_, printCouponButton = printCouponButton_, printCouponLabel = printCouponLabel_;
@synthesize scrollView = scrollView_;
@synthesize voteForUsView = voteForUsView_, reviewView = reviewView_, informationView = informationView_, shareView = shareView_, headerView = headerView_, contentView = contentView_, menuView = menuView_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Biz Profile";
    self.profileDic = [[NSDictionary alloc]init];
    requestProfileDic_ = [[NSMutableDictionary alloc]init];
    self.profileInfo = [[ProfileInfo alloc]init];
    waitScreen_ = [[WaitScreenView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:waitScreen_];
    
    self.scrollView.contentSize = CGSizeMake(320, 600);
    self.scrollView.scrollEnabled = YES;
    
    //initForViews
    self.scheduleLabel = [[UILabel alloc]init];
    self.scheduleLabel.font = [UIFont systemFontOfSize:13.0];
    self.scheduleLabel.numberOfLines = 0;
    
    self.nameOfscheduleLabel = [[UILabel alloc]init];
    
    self.nameOfdescriptionLabel = [[UILabel alloc]init];
    
    self.descriptionLabel = [[UILabel alloc]init];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13.0];
    self.descriptionLabel.numberOfLines = 0;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    UserInfo* userInfo = [UserInfo sharedInstance];
    RequestsManager* requsetManager = [RequestsManager sharedInstance];
    
    [requestProfileDic_ setValue:userInfo.businessID forKey:@"business_id"];
    [waitScreen_ showWaitScreen];
    [requsetManager getBusiness:requestProfileDic_ andDelegate:self doneSelector:@selector(getBusinessDidSuccess:) failSelector:@selector(getBusinessDidFail:)];
    
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

#pragma mark - Action Methods

- (void)voteForUs:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)writeAReview:(id)sender
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

- (void)goToReviews:(id)sender
{
    ReviewsViewController* reviewsViewController = [[[ReviewsViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]]autorelease];
    [self.navigationController pushViewController:reviewsViewController animated:YES];
}

- (IBAction)nextLink:(id)sender
{
    id nextObj = sender;
    
//    currentNumberOfLink_++;
//    if (currentNumberOfLink_ < [self.profileInfo.contentOfLink count])
//    {
//        UIWebView* nextWebView = [[UIWebView alloc]initWithFrame:CGRectMake(270, 10, 220, 160)];
//        NSURL* url = [NSURL URLWithString:[self.profileInfo.contentOfLink objectAtIndex:currentNumberOfLink_]];
//        NSURLRequest* request = [NSURLRequest requestWithURL:url];
//        [nextWebView loadRequest:request];
//        
//        [UIView animateWithDuration:2.0 animations:^{
//                
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
}
- (IBAction)previousLink:(id)sender
{
    
}

#pragma mark - Private methods

- (CGSize)calculateSizeForText:(NSString *)text withFont:(NSString *)font size:(CGFloat)size
{
    CGSize scrollSize = CGSizeMake(290, INFINITY);
    CGSize stringSize = [text sizeWithFont:[UIFont fontWithName:font size:size] constrainedToSize:scrollSize lineBreakMode:UILineBreakModeTailTruncation];
    return stringSize;
}

- (void)createFooterView
{
    self.nameOfscheduleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    self.nameOfscheduleLabel.text = @"Hours:";
    self.nameOfscheduleLabel.frame = CGRectMake(self.reviewView.frame.origin.x + 10, self.reviewView.frame.origin.y + self.reviewView.frame.size.height + 10, 60, 12);
    [self.scrollView addSubview:self.nameOfscheduleLabel];
    
    
    CGSize scheduleSize;
    scheduleSize = [self calculateSizeForText:self.profileInfo.schedule withFont:@"Helvetica" size:13.0];    
    self.scheduleLabel.frame = CGRectMake(self.nameOfscheduleLabel.frame.origin.x, self.nameOfscheduleLabel.frame.origin.y + self.nameOfscheduleLabel.frame.size.height + 5, scheduleSize.width, scheduleSize.height);
    self.scheduleLabel.text = self.profileInfo.schedule;
    [self.scrollView addSubview:self.scheduleLabel];
    
    self.nameOfdescriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    self.nameOfdescriptionLabel.text = @"Description:";
    self.nameOfdescriptionLabel.frame = CGRectMake(self.scheduleLabel.frame.origin.x, self.scheduleLabel.frame.origin.y + self.scheduleLabel.frame.size.height + 5, 100, 15);
    [self.scrollView addSubview:self.nameOfdescriptionLabel];
    
    CGSize descriptionSize;
    descriptionSize = [self calculateSizeForText:self.profileInfo.description withFont:@"Helvetica" size:13.0];
    self.descriptionLabel.frame = CGRectMake(self.nameOfdescriptionLabel.frame.origin.x, self.nameOfdescriptionLabel.frame.origin.y + self.nameOfdescriptionLabel.frame.size.height + 5, descriptionSize.width, descriptionSize.height);
    self.descriptionLabel.text = self.profileInfo.description;
    [self.scrollView addSubview:self.descriptionLabel];
    
    self.shareView.frame = CGRectMake(self.descriptionLabel.frame.origin.x - 20, self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height +5, 320, 61);
    [self.scrollView addSubview:self.shareView];
    
    self.scrollView.contentSize = CGSizeMake(320, self.shareView.frame.origin.y + self.shareView.frame.size.height + 10);

}

- (void)createHeaderView
{
    CGSize addressSize;
    addressSize = [self calculateSizeForText:self.profileInfo.address withFont:@"Helvetica" size:13.0];
    self.adressLabel.frame = CGRectMake(self.nominationLabel.frame.origin.x, self.nominationLabel.frame.origin.y + self.nominationLabel.frame.size.height + 5, addressSize.width, addressSize.height);
    self.adressLabel.text = self.profileInfo.address;
    
    self.siteLabel.frame = CGRectMake(self.adressLabel.frame.origin.x, self.adressLabel.frame.origin.y + self.adressLabel.frame.size.height, 160, 21);
    self.siteButton.frame = self.phoneLabel.frame;
    
    self.phoneLabel.frame = CGRectMake(self.siteLabel.frame.origin.x + self.siteLabel.frame.size.width + 32, self.siteLabel.frame.origin.y, 88, 21);
    self.phoneButton.frame = self.phoneLabel.frame;
    self.headerView.frame = CGRectMake(0, 0, 320, self.phoneLabel.frame.origin.y + self.phoneLabel.frame.size.height + 5);
}

- (void)createViewForBizProfileUnclaimed
{
    
}

- (void)createViewForBizProfileBasic
{
    [self createHeaderView];
    
    self.voteForUsView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y + self.headerView.frame.size.height, 320, 37);

    self.reviewView.frame = CGRectMake(self.voteForUsView.frame.origin.x, self.voteForUsView.frame.origin.y + self.voteForUsView.frame.size.height + 7, 320, 82);
    
    [self createFooterView];
        
}

- (void)createViewForBizProfilePlus
{
    [self createHeaderView];
    
    self.contentView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y + self.headerView.frame.size.height + 5, 320, 180);
    [self.scrollView addSubview:self.contentView];
    self.voteForUsView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + self.contentView.frame.size.height + 5, 320, 37);
    self.reviewView.frame = CGRectMake(self.voteForUsView.frame.origin.x, self.voteForUsView.frame.origin.y + self.voteForUsView.frame.size.height + 5, 320, 82);
    [self createFooterView];
    
    
}

- (void)createViewForBizProfilePremier
{
    //tempInitForLink
    [self.profileInfo.contentOfLink addObject:@"http://cs303110.userapi.com/u4454409/-14/x_05deae3b.jpg"];
    [self.profileInfo.contentOfLink addObject:@"http://cs303110.userapi.com/u4454409/-14/x_35a4e36d.jpg"];
    [self.profileInfo.contentOfLink addObject:@"http://cs303110.userapi.com/u4454409/-14/x_c0f72b67.jpg"];
    
    [self createHeaderView];
    self.contentView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y + self.headerView.frame.size.height + 5, 320, 180);
    currentNumberOfLink_ = 0;
    NSURL* url = [NSURL URLWithString:[self.profileInfo.contentOfLink objectAtIndex:currentNumberOfLink_]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    UIWebView* webView = [[UIWebView alloc]init];
    webView.frame = CGRectMake(50, 10, 220, 160);
    [webView loadRequest:request];
    webView.scalesPageToFit = YES;
    [self.contentView addSubview:webView];
    
    [self.scrollView addSubview:self.contentView];
    self.voteForUsView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y + self.contentView.frame.size.height + 10, 320, 37);
    self.menuView.frame = CGRectMake(self.voteForUsView.frame.origin.x, self.voteForUsView.frame.origin.y + self.voteForUsView.frame.size.height + 5, 320, 50);
    [self.scrollView addSubview:self.menuView];
    self.reviewView.frame = CGRectMake(self.menuView.frame.origin.x, self.menuView.frame.origin.y + self.menuView.frame.size.height + 5, 320, 82);
    [self createFooterView];
    
    
}

- (void)getBusinessDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        NSDictionary* dic = (NSDictionary*)object;
        self.profileInfo = [[ProfileInfo alloc]init];
        self.profileInfo.name = [dic objectForKey:@"name"];
        self.profileInfo.site = [dic objectForKey:@"site"];
        self.profileInfo.description = @"When Mercedes wanted to promote its new fuel cell vehicle, instead of placing it squarely in front of everyone in the world, the company decided to make the";
        //self.profileInfo.description = [dic objectForKey:@"description"];
        self.profileInfo.idProfile = [dic objectForKey:@"id"];
        //self.profileInfo.schedule = [dic objectForKey:@"schedule"];
        self.profileInfo.schedule = @"Lace up the track shoes, plug in the ear buds, and outdistance.";
        self.profileInfo.address = [dic objectForKey:@"address"];
        self.profileInfo.phone = [dic objectForKey:@"phone"];
        
        //IBOutlets
        self.nominationLabel.text = self.profileInfo.name;
        self.siteButton.titleLabel.text = self.profileInfo.site;
        self.descriptionLabel.text = self.profileInfo.description;
        self.adressLabel.text = self.profileInfo.address;
        self.siteButton.titleLabel.text = self.profileInfo.site;
        self.phoneButton.titleLabel.text = self.profileInfo.phone;
        
        //[self createViewForBizProfileBasic];
        //[self createViewForBizProfilePlus];
        [self createViewForBizProfilePremier];
        [waitScreen_ hideWaitScreen];
    }
    else
    {
        
    }
}

- (void)getBusinessDidFail:(id)object
{
    
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

#pragma mark - dealloc

- (void)dealloc
{
    [nominationLabel_ release];
    [adressLabel_ release];
    [siteButton_ release];
    [phoneButton_ release];
    [phoneLabel_ release];
    [siteLabel_ release];
    
    [webView_ release];
    
    [voteForUsButton_ release];
    [writeAReviewButton_ release];
    [reviewsButton_ release];
    [reviewsLabel_ release];
    
    [facebookButton_ release];
    [twitterButton_ release];
    [googleButton_ release];
    
    [nameOfScheduleLabel_ release];
    [nameOfDescriptionLabel_ release];
    [descriptionLabel_ release];
    [scheduleLabel_ release];
    [scrollView_ release];
    
    [menuLabel_ release];
    [menuButton_ release];
    [printCouponLabel_ release];
    [printCouponButton_ release];

    [voteForUsView_ release];
    [reviewView_ release];
    [informationView_ release];
    [shareView_ release];
    [headerView_ release];
    [contentView_ release];
    [menuView_ release];
    
    [profileDic_ release];
    [requestProfileDic_ release];
    [profileInfo_ release];
    [waitScreen_ release];
    
    [super dealloc];
}

@end
