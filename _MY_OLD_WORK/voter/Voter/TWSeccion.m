//
//  TWSeccion.m
//  Voter
//
//  Created by User User on 3/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TWSeccion.h"
#import "SA_OAuthTwitterEngine.h"
#import "UserInfo.h"

/* Define the constants below with the Twitter 
 Key and Secret for your application. Create
 Twitter OAuth credentials by registering your
 application as an OAuth Client here: http://twitter.com/apps/new
 */

#define kOAuthConsumerKey       @"4BIl8gZZDEqpPq8EE0c5WA"		//REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret	@"ohaqZY9oSSHjuNtx7FNWrPpaaVMRmdPI5EzFCI10U"		//REPLACE With Twitter App OAuth Secret


@implementation TWSeccion
@synthesize delegate = delegate_;


- (id)initWithDelegate:(UIViewController<TWSeccionDelegate>*) delegate; 
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"---dealloc TWSession");
#endif    
    [engine_ release];
    
    [super dealloc];
}

//===================================================================================================
- (void)twitterLogin
{
#ifdef DEBUG
    NSLog(@":+twitterLogin");
#endif
    if(!engine_)
    {  
        engine_ = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        engine_.consumerKey    = kOAuthConsumerKey;  
        engine_.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    if(![engine_ isAuthorized])
    {  
#ifdef DEBUG
        NSLog(@":+twitterLogin : new session!!");    
#endif         
        [[UserInfo sharedInstance] requestNetworkActivityIndicator];
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:engine_ delegate:self];  
        
        if (controller){  
            [self.delegate presentModalViewController:controller animated:YES];  
        }  
        [[UserInfo sharedInstance] releaseNetworkActivityIndicator];            
    } else {
#ifdef DEBUG
        NSLog(@":+twitterLogin : already connected...");    
#endif
        if ([self.delegate respondsToSelector:@selector(twDidLogin:forUsername:)])
        {
            [self.delegate twDidLogin:[[NSUserDefaults standardUserDefaults] objectForKey:@"authData"]
                          forUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"usernameTwitterData"]];
        }
        
    }
}


- (void)twitterLogout
{
#ifdef DEBUG
    NSLog(@":+twitterLogout");
#endif
//    [engine_ release];
//    engine_ = nil;
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];    
//	[defaults setObject:nil forKey:@"authTwitterData"];
//  [defaults setObject:nil forKey:@"usernameTwitterData"];
    [defaults removeObjectForKey:@"authData"];
	[defaults synchronize];    
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username {
    NSLog(@"~store OAuth Data:(%@)",data);    
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];    
	[defaults setObject:data forKey:@"authData"];
    [defaults setObject:username forKey:@"usernameTwitterData"];
	[defaults synchronize];
    
    if ([self.delegate respondsToSelector:@selector(twDidLogin:forUsername:)])
    {
        [self.delegate twDidLogin:data forUsername:(NSString *)username];
    }
    
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *)username {
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"authData"];
    NSLog(@"~get Cached OAuth Data:(%@)",data);     
	return data;
}

// this is called once a login is successful
- (void)OAuthTwitterController:(SA_OAuthTwitterController *)controller authenticatedWithUsername:(NSString *)username 
{
    NSLog(@"~OAuthTwitterController:(%@)",username);         
}


//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded:(NSString *)requestIdentifier {
	NSLog(@"~Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed:(NSString *) requestIdentifier withError:(NSError *)error {
	NSLog(@"~Request %@ failed with error: %@", requestIdentifier, error);
}


@end
