//
//  InAppPurchaseManager.h
//  MyVisas
//
//  Created by Irina on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate> {
    
}

+ (InAppPurchaseManager*)sharedAppPurchaseInstance;


- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade;
- (BOOL)isProductInfoAvailable;
- (NSString *)getTitle;
- (NSString *)getDescription;
- (NSString *)getPrice;

- (void)beginPurchase;

@end
