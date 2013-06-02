//
//  RssDetailsViewController.h
//  TestRssReader
//
//  Created by Sergei Zmachinsky on 8/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RssItem;


@interface RssDetailsViewController : UIViewController {
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *linkLabel;
    IBOutlet UITextView *detailText;
    IBOutlet UIWebView *webView;
    IBOutlet UILabel *dateLabel;
    
    RssItem *rssItem;
    
}

@property (nonatomic, retain) RssItem *rssItem;


-(IBAction) webMapButton:(id)object;

@end
