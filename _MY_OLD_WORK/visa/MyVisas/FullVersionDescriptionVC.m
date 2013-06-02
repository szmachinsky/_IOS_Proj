//
//  FullVersionDescriptionVC.m
//  MyVisas
//
//  Created by Natalia Tsybulenko on 29.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "FlurryAnalytics.h"
#import "FullVersionDescriptionVC.h"
#import "InAppPurchaseManager.h"
#import "Utils.h"

@implementation FullVersionDescriptionVC
@synthesize info;
@synthesize bannerButton;

- (void)dealloc {
    self.info = nil;
    [infoLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)close {
    [FlurryAnalytics logEvent:EVENT_VIEW_FULL_INFO];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    bannerButton.titleLabel.textAlignment = UITextAlignmentCenter;
//    bannerButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
//    [bannerButton setTitle:NSLocalizedString(@"Remove banner\nGet 5 visas", @"banner button")  forState:UIControlStateNormal];
    
    if ([[AppData sharedAppData].shopManager isBannerRemoved])
    {
        bannerButton.hidden = YES;
    }
    
    if (isSystemVersionMoreThen(5.0)) {
        for (UIView *v in self.navigationController.navigationBar.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UINavigationBarBackground")]) {
                UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"top.png"]] autorelease];
                [v insertSubview:imageView atIndex:1];
            }
        }
    }
    self.navigationItem.title = @"My Visa";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"cancel") style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
    infoLabel.text = self.info;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVisasCountLabel) name:@"freeVisasAdded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBannerButton) name:@"bannerRemoving" object:nil];
}

-(void)updateVisasCountLabel
{
    [infoLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%d visas are still avaliable.", @"%d visas avaliable"),[[AppData sharedAppData].shopManager visasAvaliable]]];
}

-(void)hideBannerButton
{
    bannerButton.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buyBtnPressed:(id)sender {
    [FlurryAnalytics logEvent:EVENT_BUY_BUTTON_PRESSED];
    
    InAppPurchaseManager *appPurchase = [InAppPurchaseManager sharedAppPurchaseInstance];
    [appPurchase beginPurchase];
    [self dismissModalViewControllerAnimated:YES];
}


-(IBAction)purchase1Visa;
{
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.1Visa"];
//    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.VisaUnlock"];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[AppData sharedAppData].shopManager buyVisas:1];
}

-(IBAction)purchase5Visas;
{
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.5Visas"];
//    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.VisaUnlock"];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[AppData sharedAppData].shopManager buyVisas:5];
}

-(IBAction)purchase15Visas;
{
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.15Visas"];
//    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.VisaUnlock"];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[AppData sharedAppData].shopManager buyVisas:15];
}

-(IBAction)purchase10Visas;
{
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.15Visas"];
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.VisaUnlock"];
    //    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[AppData sharedAppData].shopManager buyVisas:10];
}

-(IBAction)purchase5VisasAndRemoveBanner
{
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.removeBannerVisa"];
//    SKPayment *payment = [SKPayment paymentWithProductIdentifier:@"com.redplanetsoft.VisaUnlock"];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[AppData sharedAppData].shopManager buyBannerRemoving];
}

//-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
//{
//    SKProduct *validProduct = nil;
//    int count = [response.products count];
//    if (count > 0)
//    {
//        validProduct = [response.products objectAtIndex:0];
//    }
//    else if (!validProduct)
//    {
//        NSLog(@"No product avaliable");
//    }
//}

//-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
//{
//    for (SKPaymentTransaction *transaction in transactions)
//    {
//        BOOL removeBanner = NO;
//        switch (transaction.transactionState) {
//            case SKPaymentTransactionStatePurchasing:
//                break;
//            case SKPaymentTransactionStatePurchased:
//            {
//                int newVisasCount = 0;
//                if ([transaction.payment.productIdentifier isEqualToString:@"com.redplanetsoft.VisaUnlock"])
//                {
//                    newVisasCount = 1;
//                }
//                else if ([transaction.payment.productIdentifier isEqualToString:@"com.redplanetsoft.1Visa"])
//                {
//                    newVisasCount = 1;
//                }
//                else if ([transaction.payment.productIdentifier isEqualToString:@"com.redplanetsoft.5Visas"])
//                {
//                    newVisasCount = 5;
//                }
//                else if ([transaction.payment.productIdentifier isEqualToString:@"com.redplanetsoft.15Visas"])
//                {
//                    newVisasCount = 15;
//                }
//                else if ([transaction.payment.productIdentifier isEqualToString:@"com.redplanetsoft.removeBannerVisa"])
//                {
//                    newVisasCount = 5;
//                    removeBanner = YES;
//                    bannerButton.hidden = YES;
//                }
//                if (removeBanner)
//                {
//                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"bannerRemoved"];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"bannerRemoving" object:nil];
//                }
//                int avaliableCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"avaliableVisas"];
//                [[NSUserDefaults standardUserDefaults] setInteger:(avaliableCount+newVisasCount) forKey:@"avaliableVisas"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                self.info = [NSString stringWithFormat: NSLocalizedString(@"You succesfully bought %d visas.", @"%d visas bought"),newVisasCount];
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//            }
//            case SKPaymentTransactionStateRestored:
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//            case SKPaymentTransactionStateFailed:
//                if (transaction.error.code != SKErrorPaymentCancelled)
//                {
//                    NSLog(@"An error encountered");
//                }
//                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//                break;
//        }
//    }
//}

@end
