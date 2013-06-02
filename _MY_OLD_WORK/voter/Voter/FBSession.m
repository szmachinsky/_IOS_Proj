//
//  FBSession.m
//  VoterTest
//
//  Created by User User on 3/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FBSession.h"
#import "UserInfo.h"

static NSString* kAppId = @"331663473546996";

@interface FBSession (FaceBookConnect)
- (void)fbDidLogin;
- (void)fbDidNotLogin:(BOOL)cancelled;
- (void)fbDidLogout;
- (void)request:(FBRequest *)request didLoad:(id)result;
@end



@implementation FBSession
@synthesize facebook = facebook_, permissions = permissions_;
@synthesize delegate = delegate_;
@synthesize result = result_;

- (id)initWithDelegate:(id<FBSeccionDelegate>) delegate; 
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
//      self.permissions = [NSArray arrayWithObjects:@"read_stream", @"offline_access", nil];   
        self.permissions = [NSArray arrayWithObjects:@"offline_access", nil];       
        self.result = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    return self;
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"---dealloc FBSession");
#endif    
    
    self.permissions = nil;  
    self.result = nil;
    [facebook_ release];
    
    [super dealloc];
}


//==============================================================================

- (void)fbDidLogin {
#ifdef DEBUG
#endif
    NSLog(@"++fbDidLogin");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook_ accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook_ expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize]; 
    if ([self.delegate respondsToSelector:@selector(fbDidLogin:expDate:)])
    {
//        [self facebookGetInfo];
        [self.delegate fbDidLogin:[facebook_ accessToken] expDate:[facebook_ expirationDate]];
    }
    [[UserInfo sharedInstance] releaseNetworkActivityIndicator];    
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
#ifdef DEBUG
    NSLog(@"++!!!fbDidNotLogin!!!");
#endif
    [[UserInfo sharedInstance] releaseNetworkActivityIndicator];        
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
#ifdef DEBUG
    NSLog(@"++fbDidLogout");
#endif
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }    
    [[UserInfo sharedInstance] releaseNetworkActivityIndicator];    
}


- (void)request:(FBRequest *)request didLoad:(id)result {
    // result - NSDictionary
    [[UserInfo sharedInstance] releaseNetworkActivityIndicator];        
    NSDictionary *res = (NSDictionary*)result;
#ifdef DEBUG
    NSLog(@"++request didLoad:%@",res);
#endif
    NSString *email = [res valueForKey:@"email"];
    NSString *name = [res valueForKey:@"name"];
//    NSString *token =  facebook_.accessToken;
//    NSDate *date = facebook_.expirationDate;
#ifdef DEBUG
//    NSLog(@"++token:%@",token);
//    NSLog(@"++date:%@",date);      
//    NSLog(@"++(%@)(%@)",email,name); 
#endif
    [result_ removeAllObjects];
    [result_ setObject:name forKey:@"name"];
    [result_ setObject:email forKey:@"email"];
    if ([self.delegate respondsToSelector:@selector(fbDidLogin:expDate:withInfo:)])
    {
        [self.delegate fbDidLogin:[facebook_ accessToken] expDate:[facebook_ expirationDate] withInfo:result_];
    }
}



- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt
{
#ifdef DEBUG
#endif    
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
#ifdef DEBUG
#endif    
}

//==============================================================================

- (void)facebookLogin
{
#ifdef DEBUG
    NSLog(@":+facebookLogin");
#endif
    if (!facebook_) 
        facebook_ = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook_.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook_.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }    
    
    if ([facebook_ isSessionValid] == NO) {     
#ifdef DEBUG
    NSLog(@":+facebookLogin : new session!!");    
#endif
        [UserInfo sharedInstance].faceBookCallController = facebook_;
        [[UserInfo sharedInstance] requestNetworkActivityIndicator];
        [facebook_ authorize:permissions_];
    } else 
    {
#ifdef DEBUG
    NSLog(@":+facebookLogin : already connected...");    
#endif
        if ([self.delegate respondsToSelector:@selector(fbDidLogin:expDate:)])
        {
//          [self facebookGetInfo];
            [self.delegate fbDidLogin:[facebook_ accessToken] expDate:[facebook_ expirationDate]];
        }
        
    }
}


/**
 * Invalidate the access token and clear the cookie.
 */
- (void)facebookLogout 
{
#ifdef DEBUG
    NSLog(@":+facebookLogout");
#endif
    [facebook_ logout:self];
}

- (void)facebookGetInfo 
{
    [[UserInfo sharedInstance] requestNetworkActivityIndicator];
    [facebook_ requestWithGraphPath:@"me" andDelegate:self];        
}


@end
