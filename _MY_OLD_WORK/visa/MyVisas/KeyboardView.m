//
//  KeyboardView.m
//  MyVisas
//
//  Created by Nnn on 01.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KeyboardView.h"

@implementation KeyboardView
@synthesize value, text, delegate, withMultButton;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"Keyboard" owner:self options:nil];
        if (nibViews.count) {
            [self  addSubview:[nibViews objectAtIndex:0]];
        }
    }
    return self;
}

- (void)setWithMultButton:(BOOL)isWithMultButton {
    withMultButton = isWithMultButton;
    NSString *imageName = isWithMultButton ? @"mult.png" : @"blank.png";
    UIImage *btnImage = [UIImage imageNamed:imageName];
    [multButton setImage:btnImage forState:UIControlStateNormal];
    if (!isWithMultButton) {
        [multButton setImage:btnImage forState:UIControlStateHighlighted];
    }
}

- (IBAction)btnPressed:(id)sender {
    int tag = [(UIButton *)sender tag];
    if (tag < 10) {
        if (text.length == 0 || value == NSIntegerMax) {
            self.text = [NSString stringWithFormat:@"%d", tag];
        }
        else {
            self.text = [text stringByAppendingFormat:@"%d", tag];
        }
        value = [text integerValue];
    }
    else if (tag == 10) {
        // multi visa
        if (self.withMultButton) {
            self.text = @"MULT";
            value = NSIntegerMax;
        }
    }
    else {
        if (value == NSIntegerMax) {
            self.text = @"";
            value = 0;
        }
        else if (text.length) {
            self.text = [text stringByReplacingCharactersInRange:NSMakeRange(text.length - 1, 1) withString:@""];
            value = [text integerValue];
        }
    }
    if (delegate != nil && [(id)delegate respondsToSelector:@selector(keyboardBtnPressed)]) {
        [(id)delegate keyboardBtnPressed];
    }
}

- (IBAction)donePressed:(id)sender {
    if (delegate != nil && [(id)delegate respondsToSelector:@selector(keyboardDone)]) {
        [(id)delegate keyboardDone];
    }
}

- (void)dealloc {
    self.text = nil;
    [multButton release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
