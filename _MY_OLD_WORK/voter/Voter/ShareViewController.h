//
//  ShareViewController.h
//  Voter
//
//  Created by Khitryk Artsiom on 13.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShareViewControllerDelegate

- (void)popToRootViewController;

@end

@interface ShareViewController : UIViewController
{
@private
    
    id <ShareViewControllerDelegate> delegate_;
    
}

@property (nonatomic, assign) id <ShareViewControllerDelegate> delegate;

-(IBAction)cancel:(id)sender;

@end
