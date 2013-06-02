//
//  Calc_1ViewController.h
//  Calc_1
//
//  Created by Administrator on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyCalc;

#import "FlipsideViewController.h" //zs
//#import "AboutViewController.h" //zs


@interface CalcViewController : UIViewController <FlipsideViewControllerDelegate> { //zs
//@interface CalcViewController : UIViewController <AboutViewControllerDelegate> { //zs
//@interface CalcViewController : UIViewController { 
        
    MyCalc* calc;

    IBOutlet UILabel *labelResult;

}

- (void)createCalculator;  

- (IBAction)numberButtonPressed:(id)sender;

- (IBAction)operationButtonPressed:(id)sender;

- (IBAction)modeButtonPressed:(id)sender;

- (IBAction)inputModeChanged:(id)sender;

- (IBAction)infoButtonPressed:(id)sender;

@end
