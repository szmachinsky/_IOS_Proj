//
//  InAppPurchaseManager.m
//  MyVisas
//
//  Created by Irina on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "InAppPurchaseManager.h"

@interface InAppPurchaseManager()
@property (nonatomic, retain) SKProduct *proUpgradeProduct;
@property (nonatomic, retain) SKProductsRequest *productsRequest;
@property (nonatomic, retain) UIAlertView *activityAlert;
@end

@implementation InAppPurchaseManager
@synthesize proUpgradeProduct, productsRequest, activityAlert;

#define kInAppPurchaseProUpgradeProductId @"com.redplanetsoft.VisaUnlock"

+ (InAppPurchaseManager*)sharedAppPurchaseInstance {
	
	static InAppPurchaseManager *sharedGameStateInstance;
	
	@synchronized(self) {
		if(!sharedGameStateInstance) {
			sharedGameStateInstance = [[InAppPurchaseManager alloc] init];
		}
	}
	
	return sharedGameStateInstance;
}

- (void)requestProUpgradeProductData {
    NSSet *productIdentifiers = [NSSet setWithObject:kInAppPurchaseProUpgradeProductId];
    self.productsRequest = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers] autorelease];
    self.productsRequest.delegate = self;
    [productsRequest start];
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    self.proUpgradeProduct = ([products count] == 1) ? [products objectAtIndex:0] : nil;
    if (self.proUpgradeProduct) {
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
    }
    
    self.productsRequest = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

-(BOOL)isProductInfoAvailable {
    return proUpgradeProduct != nil;
}

- (NSString *)getTitle {
    return proUpgradeProduct.localizedTitle;
}

- (NSString *)getDescription {
    return proUpgradeProduct.localizedDescription;
}

- (NSString *)getPrice {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:proUpgradeProduct.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:proUpgradeProduct.price];
    return formattedString;
}


// call this method once on startup
- (void)loadStore {
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    [self requestProUpgradeProductData];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)purchaseProUpgrade {
    if (proUpgradeProduct) {
        SKPayment *payment = [SKPayment paymentWithProduct:proUpgradeProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kInAppPurchaseProUpgradeProductId])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:@"proUpgradeTransactionReceipt" ];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId {
    if ([productId isEqualToString:kInAppPurchaseProUpgradeProductId]) {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bannerRemoving" object:nil];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

-(void)showActivity {
    UIActivityIndicatorView *progressView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130.0f, 30.0f, 25.0f, 25.0f)] autorelease];  
    progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;  
    
    self.activityAlert = [[[UIAlertView alloc] initWithTitle: @"" message: @"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil] autorelease];     
    [self.activityAlert addSubview:progressView];  
    [progressView startAnimating];    
    [self.activityAlert show];  
}

- (void)beginPurchase {
    InAppPurchaseManager *appPurchase = [InAppPurchaseManager sharedAppPurchaseInstance];
    [appPurchase loadStore];
    [self showActivity];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyNow:) name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
}

-(void)buyNow:(NSNotification *)notification {
    [self.activityAlert dismissWithClickedButtonIndex:self.activityAlert.cancelButtonIndex animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerProductsFetchedNotification object:nil];
    InAppPurchaseManager *appPurchase = [InAppPurchaseManager sharedAppPurchaseInstance];
    if ([appPurchase isProductInfoAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[appPurchase getTitle] message:[appPurchase getDescription] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"cancel") otherButtonTitles:[appPurchase getPrice], nil];
        [alert show];
        [alert release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:NSLocalizedString(@"problems", @"problems")
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)unlock:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    //NSLog(@"unlock");
    [self.activityAlert dismissWithClickedButtonIndex:self.activityAlert.cancelButtonIndex animated:NO];
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"LevelDidWinNotification" object:nil]];
}

-(void)unlockFailed:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
    //NSLog(@"unlockFailed");
    [self.activityAlert dismissWithClickedButtonIndex:self.activityAlert.cancelButtonIndex animated:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:NSLocalizedString(@"problems", @"problems")
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.activityAlert dismissWithClickedButtonIndex:self.activityAlert.cancelButtonIndex animated:NO];
    if (buttonIndex != alertView.cancelButtonIndex) {
        InAppPurchaseManager *appPurchase = [InAppPurchaseManager sharedAppPurchaseInstance];
        if ([appPurchase canMakePurchases]) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlock:) name:kInAppPurchaseManagerTransactionSucceededNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockFailed:) name:kInAppPurchaseManagerTransactionFailedNotification object:nil];
            [appPurchase purchaseProUpgrade];
        }
        else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Purchases are disabled.", @"purchases are disabled") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"ok") otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}

@end
