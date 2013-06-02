//
//  RoundRectLabel.h
//  MyVisas
//
//  Created by Nnn on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundRectLabel : UILabel {
    id   lTarget;
    SEL  lAction;
}

@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) BOOL editMode;
@property (nonatomic, retain) UIColor *color;

- (void)addTarget:(id)target action:(SEL)action;

@end
