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
    UIImageView *arrowImage;
    CustomProgressView *progressBar;
}

@property(nonatomic,strong)UILabel *primaryLabel;
@property(nonatomic,strong)UILabel *secondaryLabel;
@property(nonatomic,strong)UILabel *thirdLabel;
@property(nonatomic,strong)UIImageView *arrowImage;

-(void)setCurrent:(bool)isCurrent;
-(void)setTimeFromBeginning:(float) min durationOfShow:(float)duration;
@end
