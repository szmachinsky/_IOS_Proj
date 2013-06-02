//
//  Calc_1AppDelegate.h
//  Calc_1
//
//  Created by Administrator on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalcViewController;

@interface CalcAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CalcViewController *viewController;

@end
