//
//  TVCell.m
//  TVProgram
//
//  Created by Admin on 13.09.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TVCell.h"

@implementation TVCell
//@synthesize progressBar;
@synthesize backImage;
@synthesize myImageView;
@synthesize channelNameLabel;
@synthesize currentShowLabel;
@synthesize nextShowLabel;
@synthesize currentTimeLabel;
@synthesize nextTimeLabel;
@synthesize channelButton;
@synthesize currentShowButton;
@synthesize nextShowButton;
@synthesize currentCategoryButton;
@synthesize nextCategoryButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier];
    return self;
}


-(void)initProgressBar{
    CGRect frame = CGRectMake(0, 45.0, 320, 39);
    if (progressBar == nil) {
        progressBar = [[CustomProgressView alloc] initWithFrame:frame];
        progressBar.frame = frame;
        progressBar.progressViewStyle = UIProgressViewStyleDefault;
        progressBar.progress = 0.5;
        [self.contentView addSubview:progressBar]; 
        [self.contentView sendSubviewToBack:progressBar];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTimeFromBeginning:(float) min durationOfShow:(float)duration
{
    [self initProgressBar];
    float value = min/duration;
    if(value < 0)
        value = 0;
    if(value > 1)
        value = 1;
    progressBar.progress = value;
}

- (void)setProgressBarVisible:(BOOL)isVisible
{
    [progressBar setHidden:!isVisible];
}


- (void)setIconImage:(UIImage*)icon
{
    myImageView.image = icon;   
}


@end
