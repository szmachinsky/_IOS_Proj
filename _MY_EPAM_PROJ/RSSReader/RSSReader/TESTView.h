//
//  TESTView.h
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TESTView : UIViewController {
    NSString *urlString;
    
    IBOutlet UIWebView *myWebView;
    
}
@property (nonatomic, retain) UIWebView *myWebView;
@property (nonatomic, retain) NSString *urlString;

@end
