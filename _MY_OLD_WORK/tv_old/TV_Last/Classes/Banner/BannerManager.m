//
//  BannerManager.m
//  MyVisas
//
//  Created by Alexei Slizh on 5/18/12.
//  Copyright (c) 2012 RedPlanetSoft. All rights reserved.
//

#import "BannerManager.h"

//#include "WPBannerInfo.h"
//#include "AppData.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation BannerManager

//@synthesize wpBannerView1;
//@synthesize wpBannerView2;

@synthesize adBannerView1;
@synthesize adBannerView2;

-(id)init
{
    self = [super init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBannersFromViews) name:@"bannerRemoving" object:nil];
    
    return self;
}

- (void) adjustBannerView
{
    CGRect contentViewFrame = adBannerView2.superview.bounds;
    CGRect adBannerFrame = adBannerView2.frame;
    
    if([adBannerView2 isBannerLoaded])
    {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:adBannerView2.currentContentSizeIdentifier];
        contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    else
    {
        adBannerFrame.origin.y = contentViewFrame.size.height;
    }
    [UIView animateWithDuration:0.5 animations:^{
        adBannerView2.frame = adBannerFrame;
        //self.contentView.frame = contentViewFrame;        
    }];
}

-(void)addAdBannerToView:(UIView*)view markedByNumber:(int)number
{
//    adBannerView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.view.frame), CGRectGetWidth(adBannerView.frame), CGRectGetHeight(adBannerView.frame));
    //TODO:
    adBannerView2 = [[ADBannerView alloc] initWithFrame:CGRectZero];
    //CGRect bannerFrame = self.adBannerView2.frame;
    //bannerFrame.origin.y = self.view.frame.size.height;
    //adBannerView2.frame = bannerFrame;
    adBannerView2.delegate = self;
    adBannerView2.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait, nil];
    adBannerView2.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    adBannerView2.frame = CGRectMake(0.0f, CGRectGetMaxY(view.frame), CGRectGetWidth(adBannerView2.frame), CGRectGetHeight(adBannerView2.frame));
    
    [view addSubview:adBannerView2];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation))
        self.adBannerView2.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    else
        self.adBannerView2.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self adjustBannerView];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self adjustBannerView];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    //TO DO
    //Check internet connecction here
     if(![BannerManager hasConnectivity])
     {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet." message:@"Please make sure an internet connection is available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     [alert release];
     return NO;
     }
    return YES;
}


-(void)addWPBannerToView:(UIView*)view markedByNumber:(int)number
{
/*    WPBannerRequestInfo *requestInfo = [[WPBannerRequestInfo alloc] initWithApplicationId:6504];
    
    switch (number) {
        case 1:
        {
            break;
        }
        case 2:
        {
            wpBannerView2 = [[WPBannerView alloc] initWithBannerRequestInfo:requestInfo]; 
            wpBannerView2.showCloseButton = NO;
            wpBannerView2.autoupdateTimeout = 10;
            wpBannerView2.delegate = self;
            wpBannerView2.hideWhenEmpty = NO;
            wpBannerView2.isMinimized = NO;
            [view addSubview:wpBannerView2];
            [wpBannerView2 showFromBottom:YES];
            [wpBannerView2 reloadBanner];
            break;
        }
    }
    
    [requestInfo release];
*/
}

-(void)addWPBannerToTableView:(UITableView*)tView markedByNumber:(int)number
{
/*    
    WPBannerRequestInfo *requestInfo = [[WPBannerRequestInfo alloc] initWithApplicationId:6504];
    
    wpBannerView1 = [[WPBannerView alloc] initWithBannerRequestInfo:requestInfo]; 
    wpBannerView1.showCloseButton = NO;
    wpBannerView1.autoupdateTimeout = 10;
    wpBannerView1.delegate = self;
    wpBannerView1.hideWhenEmpty = NO;
    wpBannerView1.isMinimized = NO;
    //[view addSubview:wpBannerView1];
    [wpBannerView1 showFromTop:YES];
    [wpBannerView1 reloadBanner];
    
    tView.tableHeaderView = nil;
    tView.tableHeaderView = wpBannerView1;
    [tView reloadData];
    
    wpTableView = tView;
    [requestInfo release];
*/ 
}

-(void)addAdBannerToTableView:(UITableView*)tView markedByNumber:(int)number
{
    adTableView = tView;
    adBannerView1 = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adBannerView1.delegate = self;
    adBannerView1.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, nil];
    adBannerView1.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    adBannerView1.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(adBannerView2.frame), CGRectGetHeight(adBannerView2.frame));
    tView.tableHeaderView = nil;
    tView.tableHeaderView = adBannerView1;
    [tView reloadData];
}


+(BOOL)isEnglishLocale
{
    if ([[[[NSLocale currentLocale] localeIdentifier] substringToIndex:2] isEqualToString:@"en"])
    {
        return YES;
    }
    return NO;
}

-(void)removeBannersFromViews
{
    if(![BannerManager isEnglishLocale])
    {
//        [wpBannerView1 removeFromSuperview];
//        [wpBannerView2 removeFromSuperview];
        wpTableView.tableHeaderView = nil;
        [wpTableView reloadData];
    }
    else
    {
        [adBannerView1 removeFromSuperview];
        [adBannerView2 removeFromSuperview];
        adTableView.tableHeaderView = nil;
        [adTableView reloadData];
    }
}

/*
- (void) bannerViewPressed:(WPBannerView *) bannerView
{    
	if (bannerView.bannerInfo.responseType == WPBannerResponseWebSite)
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:bannerView.bannerInfo.link]];
    
	[bannerView reloadBanner];
}
*/

-(void)dealloc
{
//    [wpBannerView1 release];
//    [wpBannerView2 release];
    
    [adBannerView1 release];
    [adBannerView2 release];
    
    [super dealloc];
}


+(BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

@end
