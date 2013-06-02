//
//  WriteAReviewViewController.m
//  Voter
//
//  Created by Khitryk Artsiom on 10.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WriteAReviewViewController.h"

#define FirstStarButtonTag 1001
#define SecondStarButtonTag 1002
#define ThirdStarButtonTag 1003
#define FourthStarButtonTag 1004
#define FifthStarButtonTag 1005

@interface WriteAReviewViewController()

- (void)writeReviewDidSuccess:(id)object;
- (void)writeReviewDidFail:(id)object;

@end

@implementation WriteAReviewViewController
@synthesize reviewTextView = reviewTextView_;
@synthesize firstStarButton = firstStarButton_, secondStarButton = secondStarButton_, thirdStarButton = thirdStarButton_, fourthStarButton = fourthStarButton_, fifthStarButton = fifthStarButton_;
@synthesize postPreviewButton = postPreviewButton_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        writeViewDic_ = [[NSMutableDictionary alloc]init];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.reviewTextView = nil;
    self.firstStarButton = nil;
    self.secondStarButton = nil;
    self.thirdStarButton = nil;
    self.fourthStarButton = nil;
    self.fifthStarButton =nil;
    self.postPreviewButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action Methods

-(void)voteStar:(id)sender
{
    NSInteger tag;
    if ([sender isKindOfClass:[UIButton class]])
    {
        tag = ((UIButton* )sender).tag;
    }
    switch (tag)
    {
        case FirstStarButtonTag:
        {
            self.firstStarButton.backgroundColor = [UIColor blueColor];
            self.secondStarButton.backgroundColor = [UIColor clearColor];
            self.thirdStarButton.backgroundColor = [UIColor clearColor];
            self.fourthStarButton.backgroundColor = [UIColor clearColor];
            self.fifthStarButton.backgroundColor = [UIColor clearColor];
        }
            break;
        case SecondStarButtonTag:
        {
            self.firstStarButton.backgroundColor = [UIColor blueColor];
            self.secondStarButton.backgroundColor = [UIColor blueColor];
            self.thirdStarButton.backgroundColor = [UIColor clearColor];
            self.fourthStarButton.backgroundColor = [UIColor clearColor];
            self.fifthStarButton.backgroundColor = [UIColor clearColor];
        }
            break;
        case ThirdStarButtonTag:
        {
            self.firstStarButton.backgroundColor = [UIColor blueColor];
            self.secondStarButton.backgroundColor = [UIColor blueColor];
            self.thirdStarButton.backgroundColor = [UIColor blueColor];
            self.fourthStarButton.backgroundColor = [UIColor clearColor];
            self.fifthStarButton.backgroundColor = [UIColor clearColor];
        }
            break;
        case FourthStarButtonTag:
        {
            self.firstStarButton.backgroundColor = [UIColor blueColor];
            self.secondStarButton.backgroundColor = [UIColor blueColor];
            self.thirdStarButton.backgroundColor = [UIColor blueColor];
            self.fourthStarButton.backgroundColor = [UIColor blueColor];
            self.fifthStarButton.backgroundColor = [UIColor clearColor];
        }
            break;
        case FifthStarButtonTag:
        {
            self.firstStarButton.backgroundColor = [UIColor blueColor];
            self.secondStarButton.backgroundColor = [UIColor blueColor];
            self.thirdStarButton.backgroundColor = [UIColor blueColor];
            self.fourthStarButton.backgroundColor = [UIColor blueColor];
            self.fifthStarButton.backgroundColor = [UIColor blueColor];
        }
            break;
        default:
            break;
    }
}

- (void)postReview:(id)sender
{
    RequestsManager* requestManager = [RequestsManager sharedInstance];
    UserInfo* userInfo = [UserInfo sharedInstance];
    [writeViewDic_ setValue:userInfo.token forKey:@"token"];
    [writeViewDic_ setValue:userInfo.businessID forKey:@"business_id"];
    [writeViewDic_ setValue:@"3" forKey:@"mark"];
    [writeViewDic_ setValue:self.reviewTextView.text forKey:@"review"];
    [requestManager writeReview:writeViewDic_ andDelegate:self doneSelector:@selector(writeReviewDidSuccess:) failSelector:@selector(writeReviewDidFail:)];

}

#pragma mark - Private method

- (void)writeReviewDidSuccess:(id)object
{
    if (!ObjectIsVoterServerError(object))
    {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"Your review has been posted. Would you like to share this review?" delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles:@"Share", nil];
        [alertView show];
        [alertView release];    
    }
    else
    {
        
    }
}

- (void)writeReviewDidFail:(id)object
{
    
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
#if DEBUG
        NSLog(@"Go to share");
        
        ShareViewController* shareViewController = [[[ShareViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]]autorelease];
        shareViewController.delegate = self;
        [self presentModalViewController:shareViewController animated:YES];
#endif
    }
    else
    {
#if DEBUG
        NSLog(@"Go to reviews");
#endif
        
        ReviewsViewController* reviewsViewController = [[[ReviewsViewController alloc]initWithNibName:nil bundle:[NSBundle mainBundle]]autorelease];
        [self.navigationController pushViewController:reviewsViewController animated:YES];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return FALSE;
    }
    return TRUE;
}

#pragma mark - ShareViewControllerDelegate

- (void)popToRootViewController
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - dealloc

- (void)dealloc
{
    [reviewTextView_ release];
    [firstStarButton_ release];
    [secondStarButton_ release];
    [thirdStarButton_ release];
    [fourthStarButton_ release];
    [fifthStarButton_ release];
    [postPreviewButton_ release];
    
    [writeViewDic_ release];
    
    [super dealloc];
}

@end
