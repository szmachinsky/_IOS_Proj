//
//  TVCell.h
//  TVProgram
//
//  Created by Admin on 13.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomProgressView.h"

@interface TVCell : UITableViewCell {
    CustomProgressView *progressBar; 
//    UIImageView *myImageView;
    float iconH;
}

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *channelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextShowLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextTimeLabel;


@property (weak, nonatomic) IBOutlet UIButton *channelButton;

@property (weak, nonatomic) IBOutlet UIButton *currentShowButton;
@property (weak, nonatomic) IBOutlet UIButton *nextShowButton;

@property (weak, nonatomic) IBOutlet UIButton *currentCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *nextCategoryButton;


- (void)setTimeFromBeginning:(float) min durationOfShow:(float)duration;
- (void)setProgressBarVisible:(BOOL)isVisible;
- (void)setIconImage:(UIImage*)icon;

@end
