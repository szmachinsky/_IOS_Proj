//
//  KeyboardView.h
//  MyVisas
//
//  Created by Nnn on 01.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardDelegate <NSObject>
- (void)keyboardBtnPressed;
- (void)keyboardDone;
@end

@interface KeyboardView : UIView {
    IBOutlet UIButton *multButton;
}

@property (nonatomic, assign) id<KeyboardDelegate> delegate;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) BOOL withMultButton;

- (IBAction)btnPressed:(id)sender;
- (IBAction)donePressed:(id)sender;

@end
