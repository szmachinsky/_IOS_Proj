//
//  HypnosisView.m
//  Hypnose
//
//  Created by Administrator on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "HypnosisView.h"

//typedef float (*pRandFunc) (id,SEL,float,float,float,float);

@implementation HypnosisView
@synthesize boost;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        c1=0.5; c2=0.5; c3=0.5;
        al=0.75; al1=0.75, al2=0.5;
        self.boost=1;
        
        pRndFunc = (pRandFunc)[self methodForSelector:@selector(SetRandValue:Min:Max:Speed:)];

        SelRnd=@selector(SetRandValue:Min:Max:Speed:);
        
//      ppRndFunc = (float(*)(id,SEL,float,float,float,float))[self methodForSelector:@selector(SetRandValue:Min:Max:Speed:)];
        ppRndFunc = (float(*)(id,SEL,float,float,float,float))[self methodForSelector:SelRnd];
    }
    return self;
}

-(float) SetRandValue:(float)val Min:(float)min Max:(float)max Speed:(float)speed {
    float res=val;
    int rnd=rand() % 100;
    rnd=rnd-50;
    res=rnd/speed;
    res=val+res;
    if (res<min) res=min;
    if (res>max) res=max;        
    return res;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//  pRandFunc pRndFunc = (pRandFunc)[self methodForSelector:@selector(SetRandValue:Min:Max:Speed:)];
//    float res=pRndFunc(self,@selector(SetRandValue:Min:Max:Speed:), 0.5,0.2,0.7,1000.);
//    NSLog(@"res=%f",res);
    
    // What rectangle am I filling? 
    CGRect bounds = [self bounds];
//    CGRect bounds1 = rect;
/*    
    NSLog(@"bound0: %f %f %f %f",bounds.origin.x,bounds.origin.y,bounds.size.width,bounds.size.height);
    NSLog(@"bound1: %f %f %f %f",bounds1.origin.x,bounds1.origin.y,bounds1.size.width,bounds1.size.height);
    NSLog(@"bound1: %f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
*/    
    // Where is its center? 
    CGPoint center; 
    center.x = bounds.origin.x + bounds.size.width / 2.0; 
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    // From the center how far out to a corner? 
    float maxRadius = (hypot(bounds.size.width, bounds.size.height) / 2.0) + 20.0;
    // Get the context being draw upon 
    CGContextRef context = UIGraphicsGetCurrentContext();
    // All lines will be drawn 10 points wide 
    CGContextSetLineWidth(context, 10);
    // Set the stroke color to light gray 
//  [[UIColor lightGrayColor] setStroke]; //zs
//  [[UIColor blueColor] setStroke];
    
/*  c1=[self SetRandValue:c1 Min:0.01 Max:1.0 Speed:3000];
    c2=[self SetRandValue:c2 Min:0.01 Max:1.0 Speed:3000];
    c3=[self SetRandValue:c3 Min:0.01 Max:1.0 Speed:3000];
    al=[self SetRandValue:al Min:0.5 Max:1.0 Speed:3000]; */    
/*  c1=pRndFunc(self,@selector(SetRandValue:Min:Max:Speed:), c1, 0.01, 1.0, 2500.);
    c2=pRndFunc(self,@selector(SetRandValue:Min:Max:Speed:), c2, 0.01, 1.0, 2500.);
    c3=pRndFunc(self,@selector(SetRandValue:Min:Max:Speed:), c3, 0.01, 1.0, 2500.);
    al=pRndFunc(self,@selector(SetRandValue:Min:Max:Speed:), al, 0.5, 1.0, 2500.); */
    c1=ppRndFunc(self,SelRnd, c1, 0.01, 1.0, 2500.);
    c2=ppRndFunc(self,SelRnd, c2, 0.01, 1.0, 2500.);
    c3=ppRndFunc(self,SelRnd, c3, 0.01, 1.0, 2500.);
    al=ppRndFunc(self,SelRnd, al, 0.5, 1.0, 2500.);
    
  [[UIColor colorWithRed:c1 green:c2 blue:c3 alpha:al] setStroke];
    // Draw concentric circles from the outside in 
    float mx=maxRadius-col*self.boost;
    if (mx < maxRadius -20) { mx=maxRadius; col=0;};    
    for (float currentRadius = mx; currentRadius > 0; currentRadius -=20)
    {	CGContextAddArc(context, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        CGContextStrokePath(context);
    } 
    
    
    // Create a string 
    NSString *text = @"You are getting sleepy.";
    // Get a font to draw it in 
    UIFont *font = [UIFont boldSystemFontOfSize:22];
    // Where am I going to draw it? 
    CGRect textRect; 
    textRect.size = [text sizeWithFont:font]; 
    textRect.origin.x = center.x - textRect.size.width / 2.0;
    textRect.origin.y = center.y - textRect.size.height / 2.0;
    // Set the fill color 
/*  al1=[self SetRandValue:al1 Min:0.3 Max:1.0 Speed:1500];
    al2=[self SetRandValue:al2 Min:0.3 Max:0.9 Speed:1500]; */
    al1=pRndFunc(self,SelRnd, al1, 0.3, 1.0, 2500.);
    al2=pRndFunc(self,SelRnd, al2, 0.3, 1.0, 2500.);


//  [[UIColor blackColor] setFill]; //zs
///    [[UIColor redColor] setFill];
    [[UIColor colorWithRed:1.0 green:c2/5.0 blue:c3/5.0 alpha:al1] setFill];
    // Set the shadow 
    CGSize offset = CGSizeMake(4, -3); 
//  CGColorRef color = [[UIColor darkGrayColor] CGColor]; //zs
///    CGColorRef color = [[UIColor greenColor] CGColor]; 
    CGColorRef color = [[UIColor colorWithRed:c2 green:c3 blue:c1 alpha:al2] CGColor];
    CGContextSetShadowWithColor(context, offset, 2.0, color);
    // Draw the string 
    [text drawInRect:textRect withFont:font];    
    
    col++;
//  NSLog(@"-drawRect- %d",col);    
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
