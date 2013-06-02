//
//  FullVersionDescriptionVC.h
//  MyVisas
//
//  Created by Natalia Tsybulenko on 29.02.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"
//#import <StoreKit/StoreKit.h>

@interface FullVersionDescriptionVC : UIViewController{// <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    IBOutlet UILabel *infoLabel;
    IBOutlet UIButton *bannerButton;
}
@property (nonatomic, retain) NSString *info;
@property (nonatomic, retain) UIButton *bannerButton;

- (IBAction)buyBtnPressed:(id)sender;
- (void)setInfo:(NSString *)info;

-(void)updateVisasCountLabel;
-(void)hideBannerButton;

-(IBAction)purchase1Visa;
-(IBAction)purchase5Visas;
-(IBAction)purchase10Visas;
-(IBAction)purchase15Visas;
-(IBAction)purchase5VisasAndRemoveBanner;
@end
