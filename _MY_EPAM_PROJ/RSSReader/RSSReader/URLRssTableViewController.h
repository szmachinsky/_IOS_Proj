//
//  URLRssTableViewController.h
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditUrlViewController.h"


@interface URLRssTableViewController : UITableViewController <UrlEditFlipsideViewControllerDelegate> {
  
    NSString *linkToScan;
}

@property (nonatomic,retain) NSString *linkToScan;;


@end
