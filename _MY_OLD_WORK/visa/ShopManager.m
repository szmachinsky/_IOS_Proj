//
//  ShopManager.m
//  MyVisas
//
//  Created by Alexei Slizh on 5/8/12.
//  Copyright (c) 2012 RedPlanetSoft. All rights reserved.
//

#import "ShopManager.h"
NSString *const visaShopIdTemplate = @"com.redplanetsoft.Visa%d";
NSString *const bannerRemovingProductId = @"com.redplanetsoft.Visa5Banner";
NSString *const countStoreString = @"avaliable";
NSString *const bannerRemovedStoreString = @"bannerRemoved";
NSString *const redplanetsoftId = @"com.redplanetsoft.Visa";

NSString *const loggedInFbStoreString = @"fbLoggedIn";
NSString *const likedInFbStoreString = @"fbLiked";


@implementation ShopManager
//initialize our object properties

//check if user is lucky
-(bool)isUserLucky;
{
    return userLuck;
}
-(id)init
{
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:bannerRemovedStoreString];
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:countStoreString];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    userLuck = [[NSUserDefaults standardUserDefaults] boolForKey:@"isProUpgradePurchased"];
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isProUpgradePurchased"];
    BOOL notFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"notFirstStart"];
    if (!notFirstStart)
    {
        avaliableVisasCount = 1;
        bannerRemoved = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstStart"];
        [self saveInfoToStore];
    }
    else
    {
        [self readInfoFromStore];
        if ([self isShoppingAvaliable])
        {
            SKProductsRequest *productRequest1 = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:[NSString stringWithFormat:visaShopIdTemplate,1]]];
            productRequest1.delegate = self;
            [productRequest1 start];
            
            SKProductsRequest *productRequest5 = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:[NSString stringWithFormat:visaShopIdTemplate,5]]];
            productRequest5.delegate = self;
            [productRequest5 start];
            
            SKProductsRequest *productRequest15 = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:[NSString stringWithFormat:visaShopIdTemplate,15]]];
            productRequest15.delegate = self;
            [productRequest15 start];
            
            SKProductsRequest *productRequest10 = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:[NSString stringWithFormat:visaShopIdTemplate,10]]];
            productRequest10.delegate = self;
            [productRequest10 start];
            
            SKProductsRequest *productRequestBanner = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:bannerRemovingProductId]];
            productRequestBanner.delegate = self;
            [productRequestBanner start];
        }
    }
    return self;
}

//use visa
-(void)useVisa
{
    avaliableVisasCount = --avaliableVisasCount;
    [self saveInfoToStore];
}
//buy certain amount of visa
-(void)buyVisas:(int)numberOfVisas
{
    NSString *productIdentifier = [NSString stringWithFormat:visaShopIdTemplate,numberOfVisas];
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//check if at least user has one visa
-(bool)isOneVisaAvaliable
{
    return (avaliableVisasCount > 0);
}
//count of avaliable visas
-(int)visasAvaliable
{
    return avaliableVisasCount;
}
//buy banner removing
-(void) buyBannerRemoving
{
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:bannerRemovingProductId];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
//check if in-app shop is avaliable in iphone settings
-(bool)isShoppingAvaliable
{
    return ([SKPaymentQueue canMakePayments]);
}
//write changes to settings data store
-(void)saveInfoToStore
{
    [[NSUserDefaults standardUserDefaults] setInteger:avaliableVisasCount forKey:countStoreString];
    [[NSUserDefaults standardUserDefaults] setBool:bannerRemoved forKey:bannerRemovedStoreString];
    [[NSUserDefaults standardUserDefaults] setBool:loggedInFb forKey:loggedInFbStoreString];
    [[NSUserDefaults standardUserDefaults] setBool:likedInFb forKey:likedInFbStoreString];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//read from store
-(void)readInfoFromStore
{
    avaliableVisasCount = [[NSUserDefaults standardUserDefaults] integerForKey:countStoreString];
    bannerRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:bannerRemovedStoreString];
    loggedInFb = [[NSUserDefaults standardUserDefaults] boolForKey:loggedInFbStoreString];
    likedInFb = [[NSUserDefaults standardUserDefaults] boolForKey:likedInFbStoreString];
}


-(bool) isLoggedInFb
{
    return loggedInFb;
}

-(bool) doesLikeInFb
{
    return likedInFb;
}

-(void)getVisaForLike
{
    avaliableVisasCount++;
    likedInFb = YES;
    [self saveInfoToStore];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Thanks for Like","@like_thanks_header") message:NSLocalizedString(@"You have got one free visa for it.", @"message_like") delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

-(void)sayThatWeloggedInFb
{
    //TODO: remove save if don't restore session
    loggedInFb = YES;
    [self saveInfoToStore];
}

//say if banner is removed
-(bool)isBannerRemoved
{
    return bannerRemoved;
}
-(bool)isProductVisa:(NSString *)productId
{
    for (int i = redplanetsoftId.length; i < productId.length; i++)
    {
        if (!isdigit([productId characterAtIndex:i]))
        {
            return NO;
        }
    }
    return YES;
}
//parse product identifier to get visas number
-(int)getVisasCountToBuyFromIdentifier:(NSString *)identifier
{
    return [[identifier substringFromIndex:redplanetsoftId.length] intValue];
}
//implemented methods for delegate
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count > 0)
    {
        validProduct = [response.products objectAtIndex:0];
    }
    else if (!validProduct)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Problem with shop occured" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)provideContentById:(NSString *)identity
{
    int newVisasCount = 0;
    if ([self isProductVisa:identity])
    {
        newVisasCount = [self getVisasCountToBuyFromIdentifier:identity];
    }
    else if ([identity isEqualToString:bannerRemovingProductId])
    {
        newVisasCount = 5;
        bannerRemoved = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bannerRemoving" object:nil];
    }
    avaliableVisasCount = avaliableVisasCount + newVisasCount;
    [self saveInfoToStore];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"freeVisasAdded" object:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:NSLocalizedString(@"You have succesfully bought %d visas.", @"%d visas avaliable"),newVisasCount] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateRestored:
            {
                [self provideContentById:transaction.originalTransaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStatePurchased:
            {
                [self provideContentById:transaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

@end
