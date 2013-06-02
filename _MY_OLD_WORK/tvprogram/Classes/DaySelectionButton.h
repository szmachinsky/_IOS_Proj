//
//  DaySelectionButton.h
//  TVProgram
//
//  Created by User1 on 18.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DaySelectionButton : UIButton {
    NSString *day;
}

@property (readonly)NSString *day;

-(void)setDate:(NSString*)date forShort:(BOOL)isShort forIndex:(int)index;

@end
