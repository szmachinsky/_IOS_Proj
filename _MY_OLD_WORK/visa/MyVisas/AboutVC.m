//
//  AboutVC.m
//  MyVisas
//
//  Created by Natalia Tsybulenko on 25.01.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutVC.h"
#import "AppConfig.h"
#import "AppData.h"
#import "FlurryAnalytics.h"
#import "FullVersionDescriptionVC.h"
#import "InAppPurchaseManager.h"
#import "Utils.h"

@interface AboutVC () <FacebookLikeViewDelegate, FBSessionDelegate>
@property (nonatomic, retain) UIAlertView *activityAlert;
@end

@implementation AboutVC
@synthesize rightsLabel = _rightsLabel;
@synthesize activityAlert;
@synthesize facebookLikeView=_facebookLikeView;
@synthesize fbCoverButton;

- (id)init {
    if (self = [super init]) {
        _facebook = [[Facebook alloc] initWithAppId:@"158575400878173" andDelegate:self];
    }
    return self;
}

#pragma mark FBSessionDelegate methods

- (void)fbDidLogin {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
    [[AppData sharedAppData].shopManager sayThatWeloggedInFb];
    
    [_facebook requestWithGraphPath:@"me/likes" andDelegate:self];
}

- (void)fbDidLogout {
	self.facebookLikeView.alpha = 1;
    [self.facebookLikeView load];
}

#pragma mark FacebookLikeViewDelegate methods

- (void)facebookLikeViewRequiresLogin:(FacebookLikeView *)aFacebookLikeView {
    [_facebook authorize:[NSArray array]];
}

- (void)facebookLikeViewDidRender:(FacebookLikeView *)aFacebookLikeView {
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelay:0.5];
    self.facebookLikeView.alpha = 1;
    [UIView commitAnimations];
}

- (void)request:(FBRequest *)request didLoad:(id)result 
{
    NSString *mylikeName = @"";
    bool gotIt = NO;
    
    if ([result objectForKey:@"data"])
    {
        NSArray *likes = [result objectForKey:@"data"];
        
        for (NSDictionary* mylike in likes) 
        {
            mylikeName = [mylike objectForKey:@"name"];
            if ([mylikeName isEqualToString:@"My Visa"])
            {
                [_facebookLikeView removeLikeButton];
                gotIt = YES;
                break;
            }
        }
        if (!gotIt)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You have logged in!","@fb_logged_in") message:NSLocalizedString(@"Now you can like it to get one free visa!", @"message_like") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

//- (void)facebookLikeViewDidLike:(FacebookLikeView *)aFacebookLikeView {
//    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Liked"
//                                                     message:@"You liked Yardsellr. Thanks!"
//                                                    delegate:self 
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil] autorelease];
//    [alert show];
//}

//- (void)facebookLikeViewDidUnlike:(FacebookLikeView *)aFacebookLikeView {
//    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Unliked"
//                                                     message:@"You unliked Yardsellr. Where's the love?"
//                                                    delegate:self 
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil] autorelease];
//    [alert show];
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.facebookLikeView = nil;
}


- (void)dealloc {
    [buyButton release];
    [feedbackButton release];
    [rateButton release];
    [bottomButtonsView release];
    self.activityAlert = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"About My Visa", @"about");
    
    // prepare data for rights label
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *year = [dateFormatter stringFromDate:[NSDate date]];
    
    self.rightsLabel.text = [NSString stringWithFormat:@"Redplanetsoft, My Visa %@ All rights reserved, %@", version, year];
    
    if (isSystemVersionMoreThen(5.0)) {
        for (UIView *v in self.navigationController.navigationBar.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UINavigationBarBackground")]) {
                UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]] autorelease];
                [v insertSubview:imageView atIndex:1];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullVersionUnlocked) name:kInAppPurchaseUnlock object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverButton) name:removeFBLikeButtonNotification object:nil];
    
    
    if (![[AppData sharedAppData].shopManager doesLikeInFb])
    {
        self.facebookLikeView.href = [NSURL URLWithString:@"http://www.facebook.com/redplanetsoftmyvisa"];
        self.facebookLikeView.layout = @"button_count";
        self.facebookLikeView.showFaces = NO;
        
        self.facebookLikeView.alpha = 0;
        [self.facebookLikeView load];
    }
    else
    {
        [self.facebookLikeView removeFromSuperview];
        [fbCoverButton removeFromSuperview];
    }
}

-(void)removeCoverButton
{
    [fbCoverButton removeFromSuperview];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [rateButton setTitle:NSLocalizedString(@"Rate it!", @"rate app") forState:UIControlStateNormal];
    [feedbackButton setTitle:NSLocalizedString(@"Send feedback", @"send feedback") forState:UIControlStateNormal];
    [buyButton setTitle:NSLocalizedString(@"Buy Full version", @"buy full version") forState:UIControlStateNormal];
    
    UIImage *backImage = [[UIImage imageNamed:@"button_small.png"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:0.0f];
    UIImage *highlImage = [[UIImage imageNamed:@"button_small_on.png"] stretchableImageWithLeftCapWidth:10.0f topCapHeight:0.0f];
    
    [rateButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [feedbackButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [buyButton setBackgroundImage:backImage forState:UIControlStateNormal];
    
    [rateButton setBackgroundImage:highlImage forState:UIControlStateHighlighted];
    [feedbackButton setBackgroundImage:highlImage forState:UIControlStateHighlighted];
    [buyButton setBackgroundImage:highlImage forState:UIControlStateHighlighted];

    feedbackButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

//- (void)fullVersionUnlocked {
    //buyButton.hidden = YES;
    //bottomButtonsView.frame = CGRectMake(34.0f, 227.0f, 253.0f, 45.0f);
//}

#pragma mark -
#pragma mark Buttons actions

- (IBAction)aboutPressed:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:[NSURL URLWithString:RPS_SITE_URL]];
}

- (IBAction)feedbackPressed:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[[MFMailComposeViewController alloc] init] autorelease];
        mailVC.mailComposeDelegate = self;
        [mailVC setToRecipients:[NSArray arrayWithObject:@"contact@redplanetsoft.com"]];
        [mailVC setSubject:@"My Visa Feedback"];
       
        [self presentModalViewController:mailVC animated:YES];
    }
    else {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mail is not configured", @"mail is not configured") message:NSLocalizedString(@"Please, configure mail account", @"please configure mail account") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"ok") otherButtonTitles:nil] autorelease];
        [alertView show];
    }
    
    [FlurryAnalytics logEvent:EVENT_SEND_MAIL_PRESSED];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Mail is not sent", @"mail is not sent") message:NSLocalizedString(@"Fail to send mail.", @"fail to send mail") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"ok") otherButtonTitles:nil] autorelease];
        [alertView show];
    }
}

- (IBAction)reviewPressed:(id)sender {
    [FlurryAnalytics logEvent:EVENT_RATE_IT_PRESSED];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:APP_STORE_URL_FORMAT, APP_STORE_ID]];
    UIApplication *app = [UIApplication sharedApplication];
    [app openURL:url];
}

#pragma mark -
#pragma mark Purchase

- (IBAction)buyPressed:(id)sender {
    int avaliableVisas = [[AppData sharedAppData].shopManager visasAvaliable];
    NSString *info = [NSString stringWithFormat:NSLocalizedString(@"%d visas are still avaliable.", @"%d visas avaliable"),avaliableVisas];
    showFullVersionInfo(info, self);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
