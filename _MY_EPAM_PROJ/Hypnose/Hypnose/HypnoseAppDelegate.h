//
//  HypnoseAppDelegate.h
//  Hypnose
//
//  Created by Administrator on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HypnosisView;

@interface HypnoseAppDelegate : NSObject <UIApplicationDelegate> {
    
    HypnosisView *view;
    int tim;
    NSTimer* timer;
    
    IBOutlet UISlider *slider;
    int del1,del0;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction) pressButton:(UIButton*)button;
- (IBAction) holdButton:(UIButton*)button;
- (IBAction) changeSliderValue:(id)sender;


@end
