//
//  VisaCell.m
//  MyVisas
//
//  Created by Nnn on 24.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import "VisaCell.h"

@implementation VisaCell
@synthesize delegate, country, countryLabel, datesLabel, entriesLabel, durationLabel, remainsLabel;
@synthesize entriesButton, entriesTextLabel, durationTextLabel, remainsTextLabel, topColor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGFloat radius = 10.0f;
    CGRect partFrame = CGRectMake(10.0f, 1.0f, 300.0f, 51.0f);
    UIColor *backColor = BACK_COLOR;
    
    // top part of cell
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, topColor != nil ? topColor.CGColor : backColor.CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(partFrame) + radius, CGRectGetMinY(partFrame));
    CGContextAddArc(context, CGRectGetMaxX(partFrame) - radius, CGRectGetMinY(partFrame) + radius, radius, 3 * M_PI / 2, 0, 0);
    CGContextAddLineToPoint(context, CGRectGetMaxX(partFrame), CGRectGetMaxY(partFrame));
    CGContextAddLineToPoint(context, CGRectGetMinX(partFrame), CGRectGetMaxY(partFrame));
    CGContextAddArc(context, CGRectGetMinX(partFrame) + radius, CGRectGetMinY(partFrame) + radius, radius, M_PI, 3 * M_PI / 2, 0);
    
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    // bottom part of cell
    radius = 12.0f;
    partFrame = CGRectMake(10.0f, 52.0f, 300.0f, 80.0f);
    CGContextSetFillColorWithColor(context, backColor.CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX(partFrame), CGRectGetMinY(partFrame));
    CGContextAddLineToPoint(context, CGRectGetMaxX(partFrame), CGRectGetMinY(partFrame));
    CGContextAddArc(context, CGRectGetMaxX(partFrame) - radius, CGRectGetMaxY(partFrame) - radius, radius, 0, M_PI / 2, 0);
    CGContextAddArc(context, CGRectGetMinX(partFrame) + radius, CGRectGetMaxY(partFrame) - radius, radius, M_PI / 2, M_PI, 0);
  
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (IBAction)entriesPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(entriesBtnPressedForCountry:)]) {
        [(id)delegate entriesBtnPressedForCountry:self.country];
    }
}

- (void)dealloc {
    self.countryLabel = nil;
    self.datesLabel = nil;
    self.entriesLabel = nil;
    self.durationLabel = nil;
    self.remainsLabel = nil;
    self.entriesTextLabel = nil;
    self.durationLabel = nil;
    self.remainsTextLabel = nil;
    self.topColor = nil;
    self.country = nil;
    
    [super dealloc];
}


@end
