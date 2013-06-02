//
//  RSSTableViewController.h
//  TestRssReader
//
//  Created by Sergei Zmachinsky on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RssData;
@class RssItem;
//@protocol RssXMLParserDelegate;
#import "RssXMLParser.h"


@interface RSSTableViewController : UITableViewController <RssXMLParserDelegate>  {
    
    NSURLConnection *rssConnection;
    NSMutableData   *xmlData;
    
    NSString *rssFeedLink;
    NSString *rssFeedName;
    
    NSMutableString *dataString;    
    BOOL waitingForItemTitle;
    
    UIApplication* app;  
    
    RssData *rssData; 
    RssItem *rssItem;  
    
    RssXMLParser *parsXML;
    
    
}

-(IBAction) loadRSS:(id) object;

@property (nonatomic, retain) NSURLConnection *rssConnection;
@property (nonatomic, retain) NSMutableData *xmlData;

@property (nonatomic, retain) NSString *rssFeedLink;
@property (nonatomic, retain) NSString *rssFeedName;


@end
