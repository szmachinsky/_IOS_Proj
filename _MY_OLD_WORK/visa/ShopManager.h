//
//  ShopManager.h
//  MyVisas
//
//  Created by Alexei Slizh on 5/8/12.
//  Copyright (c) 2012 RedPlanetSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

extern NSString *const visaShopIdTemplate;
extern NSString *const bannerRemovingProductId;
extern NSString *const countStoreString;
extern NSString *const bannerRemovedStoreString;
extern NSString *const redplanetsoftId;

extern NSString *const loggedInFbStoreString;
extern NSString *const likedInFbStoreString;

@interface ShopManager : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    int avaliableVisasCount;
    bool bannerRemoved;
    bool loggedInFb;
    bool likedInFb;
    //user's luck with full version
    bool userLuck;
}
-(void)buyVisas:(int)numberOfVisas;
-(bool)isOneVisaAvaliable;
-(int)visasAvaliable;
-(void)buyBannerRemoving;
-(bool)isShoppingAvaliable;
-(bool)isBannerRemoved;
-(void)useVisa;

-(bool)isLoggedInFb;
-(bool)doesLikeInFb;
-(void)getVisaForLike;
-(void)sayThatWeloggedInFb;

-(bool)isProductVisa:(NSString *)productId;
-(void)saveInfoToStore;
-(void)readInfoFromStore;
-(void)provideContentById:(NSString *)identity;

-(bool)isUserLucky;

@end
