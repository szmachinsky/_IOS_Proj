//
//  ProgrammCell.h
//  TVProgram
//
//  Created by User1 on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomProgressView;
@interface ProgrammCell : UITableViewCell {
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
    UILabel *thirdLabel;
    CustomProgressView *progressBar;
}

@property(nonatomic,strong)UILabel *primaryLabel;
@property(nonatomic,strong)UILabel *secondaryLabel;
@property(nonatomic,strong)UILabel *thirdLabel;

-(void)setCurrent:(bool)isCurrent;
-(void)setTimeFromBeginning:(float) min durationOfShow:(float)duration;
@end
