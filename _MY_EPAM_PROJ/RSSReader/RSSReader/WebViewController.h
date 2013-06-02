//
//  WebViewController.h
//  TestRssReader
//
//  Created by Sergei Zmachinsky on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RssItem;


@interface WebViewController : UIViewController <UIWebViewDelegate>  {
//  NSString *stringLink; 
    NSString *urlString;
       
    IBOutlet UIWebView *myWebView;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;
    RssItem  *feedItem;

}

//@property (nonatomic, retain) IBOutlet NSString *stringLink;

@property (nonatomic, retain) UIWebView *myWebView;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) RssItem *feedItem;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;


- (IBAction) launchSafari:(id)sender;


@end
