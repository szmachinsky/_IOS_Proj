//
//  EditUrlViewController.h
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UrlEditFlipsideViewControllerDelegate;


@interface EditUrlViewController : UIViewController  <UITextFieldDelegate> {
    
    UITextField *_editLink;
    IBOutlet UIButton *buttonOK;
    IBOutlet UIButton *buttonCancel;
//    NSString *resultLink;
}
@property (nonatomic, assign) id <UrlEditFlipsideViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UITextField *editLink;

//@property (nonatomic, retain) NSString *resultLink;

-(IBAction) pressOK:(id) object;
-(IBAction) pressCancel:(id) object;

@end



@protocol UrlEditFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(EditUrlViewController *)controller;
- (void)linkWasChanged:(EditUrlViewController *)controller Link:(NSString*)link; 
@end
