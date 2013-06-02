//
//  Calc_1ViewController.m
//  Calc_1
//
//  Created by Administrator on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalcViewController.h"
#import "MyCalc.h"

//#import "FlipsideViewController.h" //zs


@implementation CalcViewController

- (void)dealloc
{
    [calc release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle





// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createCalculator];  

}


- (void)viewDidUnload
{   
    [calc release];
    NSLog(@"MyCalc is released!");
    calc=nil;

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//---------------------------------------------------------------------------------------------
-(void)setResultFromCalc {
    [labelResult setText:[calc resultString]];    
}

//---------------------------------------------------------------------------------------------
- (void)makeButtonsVisible
{
    NSArray *Views = self.view.subviews;
    for (UIView *item in Views) {
        //      if ([UIButton class] == [item class]) {
        //      if ([item isKindOfClass:[UIButton class]]) {
        //          item.hidden=[Calc CheckIfHide:[[(UIButton*)item  titleLabel] text]];
        item.hidden=[calc isViewHiddenByCalcLevel:[(UIView*)item tag] ]; 
/*      if ([calc isButtonEnabled:[(UIView*)item tag] ]) {
            item.hidden=NO;
        } else {
            item.hidden=YES;            
        } */

    }
    
}

//---------------------------------------------------------------------------------------------
- (void)checkButtonsByInputMode  
{
    NSArray *Views = self.view.subviews;
    for (UIView *item in Views) {
        if ([item isKindOfClass:[UIButton class]]) {
            UIButton* btn=(UIButton*)item;
            BOOL enabl = [calc isButtonEnabledByInputMode:[btn tag]];
            btn.enabled = enabl;
            if (!enabl) {
 //             btn.currentTitleColor=[UIColor clearColor];   
                [btn setTitle:@"..." forState:UIControlStateDisabled];
            }
        }                
    }
    
}

//---------------------------------------------------------------------------------------------
- (void)createCalculator
{
//  calc = [[MyCalc alloc] initWithLevel:mycalcBasic]; // add calculator class
//  calc = [[MyCalc alloc] initWithLevel:mycaclAdvanced]; // add calculator class    
    calc = [[MyCalc alloc] initWithLevel:mycalcExpert]; // add calculator class  
    
    [self makeButtonsVisible];
    [self checkButtonsByInputMode];
    [self setResultFromCalc]; //get result string from Calc
    
}


- (IBAction)numberButtonPressed:(id)sender { //zs
//  NSLog(@"NumButtPress:%@",sender);    
//  NSString*str1 = [(UIButton*)sender currentTitle];
//  NSString*str2 = [[(UIButton*)sender titleLabel] text];
    int res = [(UIButton*)sender tag];
//  NSLog(@"Npress=%@=%d",str1,res);
//  if (res == button_9)
//      NSLog(@"BUTTON_9 pressed!");
        
    [calc numButtonPressed:res];
    
    [self setResultFromCalc]; //get result string from Calc
}
 

- (IBAction)operationButtonPressed:(id)sender {
    NSString*str = [(UIButton*)sender currentTitle];
    
    [calc operButtonPressed:str];
    [self setResultFromCalc]; //get result string from Calc
    
}



- (IBAction)modeButtonPressed:(id)sender {
    NSString*str = [(UIButton*)sender currentTitle];
    
    [calc modeButtonPressed:str];
    [self setResultFromCalc]; //get result string from Calc
    
}



- (IBAction)inputModeChanged:(id)sender {
    int res = [(UISegmentedControl*)sender  selectedSegmentIndex];
    NSString*str = [(UISegmentedControl*)sender titleForSegmentAtIndex:res];
    NSLog(@"Npress=%@=%d",str,res);
    int mode=decMode; //default
    if (res==0)
        mode=hexMode;
    if (res==1)
        mode=decMode;
    if (res==2)
        mode=binMode;
    
    [calc inputModeButtonPressed:mode];
    
    [self checkButtonsByInputMode];
    
    [self setResultFromCalc]; //get result string from Calc
    
}


//=======================================================================================
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
//- (void)flipsideViewControllerDidFinish:(AboutViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

//- (void)aboutViewControllerDidFinish:(AboutViewController *)controller
//{
//    [self dismissModalViewControllerAnimated:YES];
//}


- (IBAction)showInfo
{    
  FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
//  controller.view.backgroundColor = [UIColor redColor];
//  controller.delegate = self;
  
//    AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AbouViewController" bundle:nil];
//    AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AbouView" bundle:nil];

//  AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
    
    controller.delegate = self;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
    
    [controller release];
}
//=======================================================================================

- (IBAction)infoButtonPressed:(id)sender {
//  NSString*str = [(UIButton*)sender currentTitle];
    NSLog(@"Info Button Pressed");
    [self showInfo];
    
}




@end
