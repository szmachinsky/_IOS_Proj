//
//  RSSReaderAppDelegate.h
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSReaderAppDelegate : NSObject <UIApplicationDelegate> {

    UINavigationController *_rootNavigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *rootNavigationController;

@end
