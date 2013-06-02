//
//  ProgrammCell.m
//  TVProgram
//
//  Created by User1 on 22.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProgrammCell.h"
#import "CustomProgressView.h"

@implementation ProgrammCell

@synthesize primaryLabel,secondaryLabel, thirdLabel, arrowImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = UITextAlignmentLeft;
        primaryLabel.font = [UIFont boldSystemFontOfSize:14];
        primaryLabel.textColor = [UIColor blackColor];
        
        secondaryLabel = [[UILabel alloc]init];
        secondaryLabel.textAlignment = UITextAlignmentLeft;
        secondaryLabel.font = [UIFont boldSystemFontOfSize:14];
        secondaryLabel.lineBreakMode = UILineBreakModeWordWrap;
        secondaryLabel.textColor = [UIColor blackColor];
        secondaryLabel.numberOfLines = 2;  
        
        thirdLabel = [[UILabel alloc]init];
        thirdLabel.textAlignment = UITextAlignmentCenter;
        thirdLabel.font = [UIFont boldSystemFontOfSize:16]; //zs 14
        thirdLabel.textColor = [UIColor blackColor];
        CGRect frame = CGRectMake(126.0, 20.0, 100, 10);
        progressBar = [[CustomProgressView alloc] initWithFrame:frame];
        progressBar.progressViewStyle = UIProgressViewStyleDefault;
        progressBar.progress = 0.5;
        
        arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray.png"]];
        arrowImage.frame = CGRectMake(300, 15, 9, 14);
        arrowImage.contentMode = UIViewContentModeLeft;
        
        [self.contentView addSubview:progressBar];
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
        [self.contentView addSubview:thirdLabel];
        [self.contentView addSubview:arrowImage];
         self.contentView.backgroundColor = [SZUtils color02];
        primaryLabel.backgroundColor = [UIColor clearColor];
        secondaryLabel.backgroundColor = [UIColor clearColor];
        thirdLabel.backgroundColor = [UIColor clearColor];
        
        progressBar.hidden = YES;
        thirdLabel.hidden = YES;
    }
    return self;
}

-(void)setCurrent:(bool)isCurrent
{
    //NSLog(@"progressBar.hidden %d", progressBar.hidden);
    progressBar.hidden = !isCurrent;
    thirdLabel.hidden = !isCurrent;
    //NSLog(@"progressBar.hidden after %d", progressBar.hidden);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //NSLog(@"layoutSubviews %@", secondaryLabel.text);
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGFloat width = contentRect.size.width;
    CGRect frame;
    
//    frame= CGRectMake(boundsX + 50 ,26, width - 75, 10); //zs -60
//    frame= CGRectMake(boundsX + 50 ,0, width - 60, contentRect.size.height); //zs -60
    frame= CGRectMake(0 ,0, width, contentRect.size.height); //zs -60
    progressBar.frame = frame;
    
    
    frame= CGRectMake(boundsX + 10, 0, 50, 44);
    primaryLabel.frame = frame;
    
    frame= CGRectMake(boundsX + 54 ,0, width - 65, 44);
    secondaryLabel.frame = frame;
    
//zs    frame= CGRectMake(boundsX,30, 80, 30);
    frame= CGRectMake(width - 22 ,0, 18, 30);   
    thirdLabel.frame = frame;
    
    arrowImage.frame = CGRectMake(width - 20, 15, 9, 14);    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setTimeFromBeginning:(float) min durationOfShow:(float)duration
{
    float value = min/duration;
    if(value < 0)
        value = 0;
    if(value > 1)
        value = 1;
    progressBar.progress = value;
}


@end
