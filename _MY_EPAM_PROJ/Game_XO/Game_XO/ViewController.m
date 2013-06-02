//
//  ViewController.m
//  Game_XO
//
//  Created by svp on 25.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
//#import "GameXO.h"



#ifndef _Use_Butt
@implementation UIImageViewT

@synthesize delegate,selToCall;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//  NSLog(@"!!!Began touched... tag=%d",self.tag);
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//  NSLog(@"!!!Ended touched... tag=%d",self.tag);
    [delegate performSelector:selToCall withObject:self];
}
@end
#endif


@implementation ViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)showMessage:(NSString*)txt FromPoint:(CGPoint)point {
    
    msgLabel.center=point;//CGPointMake(160, 480);
    msgLabel.text=txt;
    msgLabel.hidden=NO;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    msgLabel.center=CGPointMake(160, 270);
    //  msgLabel.center=CGPointMake(160, 120);
    [UIView commitAnimations];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    tstButIm.hidden=YES;
    tstImg.hidden=YES;
    tstBut.hidden=YES;
    
    
    msgLabel.hidden=YES;
    segLevel.selectedSegmentIndex=1;
    buttStart.backgroundColor=[UIColor clearColor];
    
//  im= [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"XO_78" ofType:@"png"]];
    
    im= [[UIImage imageNamed:@"XO_78.png"] retain];
    imH=[[UIImage imageNamed:@"XO_78.png"] retain];
    imX=[[UIImage imageNamed:@"XO_78_X.png"] retain];
    imO=[[UIImage imageNamed:@"XO_78_O.png"] retain];
    
    imG=[[UIImage imageNamed:@"XO_78_GRAY.png"] retain];
    imD=[[UIImage imageNamed:@"XO_78_DARK.png"] retain];    
    imD1=[[UIImage imageNamed:@"XO_78_DARK1.png"] retain];    
    
    
    arrImg=[[NSMutableArray alloc] initWithCapacity:12];
    
    [self setupGameFields:nil];
        
    game=[[GameXO alloc] initWithLevel:1];
    game.delegate=self;
    [game initGame];    
    //[game addCell:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youWinXO:) name:@"youWinXONotification" object:game];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youLoseXO:) name:@"youLoseXONotification" object:game];   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youDrawXO:) name:@"youDrawXONotification" object:game];  
    
    [self showMessage:@"You may add additional field" FromPoint:CGPointMake(160, 480)];

}



-(void)youWinXO:(NSNotification*)n {
    NSLog(@"YOU WIN THE GAME!!!");
    [self showMessage:@"You Win Game!!!" FromPoint:CGPointMake(160, 480)];
 }


-(void)youLoseXO:(NSNotification*)n {
    NSLog(@"YOU LOSE THE GAME!!!");
    [self showMessage:@"You Lose Game!!!" FromPoint:CGPointMake(160, 480)];
}

-(void)youDrawXO:(NSNotification*)n {
    NSLog(@"DRAW!!!");
    [self showMessage:@"Draw... try again" FromPoint:CGPointMake(160, 480)];
}


-(void) addNextCelltoI:(int)i J:(int)j Tag:(int)tg Active:(int)act {
	CGRect initFrame=CGRectMake(120,360,78,78);
	CGRect workingFrame=CGRectMake(1+(j*80),1+(i*80),78,78);
 

#ifdef _Use_Butt    
//  UIButton *myView = [[[UIButton alloc] initWithFrame:initFrame] autorelease];  

//  [myView setCenter:CGPointMake(160, 75)];
    
//  UIButton *myView = [[UIButton buttonWithType:UIButtonTypeCustom] initWithFrame:initFrame];
    UIButton *myView = [UIButton buttonWithType:UIButtonTypeCustom];
    myView.frame=initFrame;
    
//  [myView setTitle:@"Button" forState:UIControlStateNormal];
    [myView addTarget:self action:@selector(pressImage:) forControlEvents:UIControlEventTouchUpInside];  
//  [myView addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchDownRepeat];  
#else
//  UIImageView *myView = [[[UIImageView alloc] initWithFrame:initFrame] autorelease]; 
    UIImageViewT *myView = [[[UIImageViewT alloc] initWithFrame:initFrame] autorelease]; 
    myView.userInteractionEnabled=YES; 
    myView.delegate=self;
    myView.selToCall=@selector(pressImage:);
#endif    
    
	myView.tag=tg;
//  UIColor *color=self.view.backgroundColor;
    [myView setBackgroundColor:[UIColor redColor]];
    if (act) {
#ifdef _Use_Butt        
        myView.adjustsImageWhenHighlighted=NO;
//      [myView setImage:im forState:UIControlStateNormal];
        [myView setBackgroundImage:im forState:UIControlStateNormal];
#else
        myView.image=im;
        myView.highlightedImage=imH;    
#endif        
    } else {
        myView.hidden=YES;
    }
        
	[self.view addSubview:myView];
    [arrImg addObject:myView];         
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [myView setFrame:workingFrame];
    [UIView commitAnimations];

}

/*
-(void) setupGameString:(int)i {
//  NSLog(@"  -add string:%d  %d",i,sc1);
    for (int j=0; j<4; j++) {
        [self addNextCelltoI:i J:j Tag:(i*10 + j) Active:1];
    }
    
}
*/

-(void) setupGameFields:(id)sender {
    NSLog(@"Init game Field_%d",sc1);    
    for (int i=0; i<3; i++) {
//      [self setupGameString:i];        
        for (int j=0; j<4; j++) {
            [self addNextCelltoI:i J:j Tag:(i*10 + j) Active:1]; 
        }
    }
}




-(void) setSatusOfCell:(int)stat I:(int)i J:(int)j {
    int ind = i*4 + j;
//  NSLog(@"  >pass(%d) to %d  i=%d j=%d",stat,ind,i,j);
#ifdef _Use_Butt       
    UIButton *item = [arrImg objectAtIndex:ind];
#else
    UIImageView *item = [arrImg objectAtIndex:ind];
#endif    
    item.hidden=NO;
    UIImage *imgg=im;
    switch (stat) {
        case -1:
//          item.hidden=YES;
            imgg=imG;
            break;
        case 0:
            imgg=im;
            break;
        case 1:
            imgg=imX;
            break;
        case 10:
            imgg=imO;
            break;            
        default:
            break;
    }
    
    
    [UIView transitionWithView:item duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft  
#ifdef _Use_Butt     
                        animations:^{ [item setImage:imgg forState:UIControlStateNormal];  }
#else     
                        animations:^{ [item setImage:imgg];  }
#endif     
                        completion:NULL];   
    
/*    
#ifdef _Use_Butt               
    [item setImage:imgg forState:UIControlStateNormal];
#else 
    [item setImage:imgg];
#endif 
*/
    
}


- (IBAction)pressImage:(id)sender {
#ifdef _Use_Butt        
    int res = [(UIButton*)sender tag];
#else
    int res = [(UIImageViewT*)sender tag];
#endif
    if  (msgLabel.hidden==NO)
        msgLabel.hidden=YES;
    int i=res / 10, j=res % 10;
//  NSLog(@"press image. tag=%d  i=%d  j=%d",res, i, j);
    [game makeMoveX:i J:j];
}


- (IBAction)pressStart:(id)sender {
    NSLog(@"Start game");
    msgLabel.hidden=YES;
   [game initGame];
}

- (IBAction)levelChanged:(id)sender {
    int res = [(UISegmentedControl*)sender  selectedSegmentIndex];
    int level=res;
    [game setLevel:level];
}    

-(IBAction)tstButtPress:(id)sender {
    NSLog(@"tst Button");
/*        
    [UIView transitionWithView:tstImg duration:1.0
                        options:UIViewAnimationOptionTransitionFlipFromLeft   
                        //animations:^{ [tstImg removeFromSuperview]; [tstImg setImage:imO]; [self.view addSubview:tstImg]; }
//                        animations:^{ [tstButIm setImage:imO forState:UIControlStateNormal];  }
                        animations:^{ [tstImg setImage:imO];  }

                    completion:NULL]; 
  
   [UIView animateWithDuration:1.0 //animations:^{ [tstImg setImage:imO];  }
                        animations:^{ [tstButIm setImage:imO forState:UIControlStateNormal];  }
    ];
    
    [UIView transitionFromView:tstImg toView:tstImg duration:1.0 options:UIViewAnimationTransitionFlipFromRight completion:NULL];
*/ 
}
//================================================================================================
- (void)viewDidUnload
{
    [buttStart release];
    buttStart = nil;
    
    [msgLabel release];
    msgLabel = nil;
    [segLevel release];
    segLevel = nil;
    
    [tstBut release];
    tstBut = nil;
    [tstImg release];
    tstImg = nil;
    [tstButIm release];
    tstButIm = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [buttStart release];
    
    [im release];
    [imH release];
    [imO release];
    [imX release];

    [imG release];
    [imD release];    
    [imD1 release];
    
    [arrImg release];
    
    [game release];
    
    [msgLabel release];
    [segLevel release];
    
    [tstBut release];
    [tstImg release];
    [tstButIm release];
    [super dealloc];
}
//================================================================================================
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return(interfaceOrientation == UIInterfaceOrientationPortrait);
    //return NO;
}


@end
