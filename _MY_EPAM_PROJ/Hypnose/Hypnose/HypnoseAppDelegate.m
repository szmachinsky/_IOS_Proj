//
//  HypnoseAppDelegate.m
//  Hypnose
//
//  Created by Administrator on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HypnoseAppDelegate.h"
#import "HypnosisView.h"

@implementation HypnoseAppDelegate


@synthesize window=_window;

-(void) showGypnosys:(NSTimer*)tm
{
//    NSLog(@"repeat");
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showGypnosys) userInfo:nil repeats:NO];
    [view setNeedsDisplay];
//    NSLog(@"count3=%d tim=%d",[self retainCount],[tm retainCount]);    
}

- (IBAction) pressButton:(UIButton*) button
{
    NSLog(@"----But pressed--");
//    [view setNeedsDisplay];
//    [self showGypnosys]; 
    if (tim==0){
//        NSLog(@"count1=%d",[self retainCount]);
        timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showGypnosys:) userInfo:nil repeats:YES];
        tim=1;
//      NSLog(@"count2=%d tim=%d",[self retainCount],[timer retainCount]);
        
    }   else {
        [timer invalidate];
        timer=nil;
        tim=0;
    }

}

- (IBAction) holdButton:(UIButton*) button
{
//    NSLog(@"----But hold---");
    [view setNeedsDisplay];
}

- (IBAction)changeSliderValue:(id)sender {
    del1 = slider.value; //получаем значение слайдер
//    NSLog(@"del1=%d del0=%d",del1,del0);
    if (del1==0){
        [timer invalidate];
        timer=nil;        
    }   else {
        if (del1 != del0) {
            [timer invalidate];
            timer=nil;  
            float interval=(100. - (del1*2.0))/1000.0;
            if (del1 == 31) {
                view.boost=2;
                interval=0.05;
                NSLog(@"Ops!!!");                
            } else {
                view.boost=1;
            }
            timer=[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(showGypnosys:) userInfo:nil repeats:YES];            
        }
    }
    del0=del1;                                                                
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//  CGRect wholeWindow = [self.window bounds]; 
//  CGRect wholeWindow = CGRectMake(20, 40, 320-20*2,480-20-40);
    CGRect wholeWindow = CGRectMake(0, 20, 320,480-20-20);
    
    view = [[HypnosisView alloc] initWithFrame:wholeWindow]; 
//  view = [[HypnosisView alloc] initWithFrame:CGRectMake(20, 40, 320-20*2,480-20-40)]; 
    
    [view setBackgroundColor:[UIColor clearColor]]; 
    [self.window addSubview:view]; 
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{   
    [view release];
    [_window release];
    [slider release];
    [super dealloc];
}

@end
