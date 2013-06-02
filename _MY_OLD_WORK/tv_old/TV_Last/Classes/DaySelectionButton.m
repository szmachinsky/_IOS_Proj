//
//  DaySelectionButton.m
//  TVProgram
//
//  Created by User1 on 18.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DaySelectionButton.h"
#import "CommonFunctions.h"

@implementation DaySelectionButton
@synthesize day;

+(id)buttonWithType:(UIButtonType)buttonType
{
    return [super buttonWithType:buttonType];
}

- (void)myCheckboxToggle:(id)sender
{
    if(!self.selected)
        self.selected = !self.selected; // toggle the selected property, just a simple BOOL
    
}

-(void)setDate:(NSString*)date forShort:(BOOL)isShort forIndex:(int)index
{
    day = [[NSString stringWithString:date] copy];
    if (isShort == YES) {
        if (index == 1) {
            [self setBackgroundImage:[UIImage imageNamed:@"butt_left.png"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"butt_left_on.png"] forState:UIControlStateSelected]; 
        }
        else if(index == 7)
        {
            [self setBackgroundImage:[UIImage imageNamed:@"butt_right.png"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"butt_right_on.png"] forState:UIControlStateSelected]; 
        }
        else
        {
            [self setBackgroundImage:[UIImage imageNamed:@"butt_center.png"] forState:UIControlStateNormal];
            [self setBackgroundImage:[UIImage imageNamed:@"butt_center_on.png"] forState:UIControlStateSelected];   
        }
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"day_button.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"day_button_on.png"] forState:UIControlStateSelected];    
    }
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addTarget:self action:@selector(myCheckboxToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *weekDay;
    if (isShort == YES) {
        weekDay = getShortWeekDay(date);
    }
    else
        weekDay =  getWeekDay(date);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self setTitle:weekDay forState:UIControlStateNormal];
}





@end
