//
//  ViewController.h
//  Game_XO
//
//  Created by svp on 25.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameXO.h"

//--------------------------------------------------------------------------------
@interface UIImageViewT : UIImageView {  
}
@property(nonatomic,assign) id delegate;
@property(nonatomic,assign) SEL selToCall;
@end

//--------------------------------------------------------------------------------
@interface ViewController : UIViewController  <GameXODelegate> {
    UIImage *im,*imH,*imX,*imO,*imD,*imD1,*imG;
    int sc1;
        
    NSMutableArray *arrImg;
    
    GameXO *game;
    
    IBOutlet UILabel *msgLabel;
    
//    IBOutlet UIImageView *tstImage;  
//    IBOutlet UIButton *tstBut;
//    UIImageViewT *tstt;
    
    IBOutlet UIButton *tstBut;
    IBOutlet UIImageView *tstImg;
    IBOutlet UIButton *tstButIm;
    
    
    
    IBOutlet UIButton *buttStart;
    IBOutlet UISegmentedControl *segLevel;
}

-(void) setupGameFields:(id)sender;
-(void) setSatusOfCell:(int)stat I:(int)i J:(int)j Animation:(BOOL)anim;

- (void)pressImage:(id)sender;
- (IBAction)pressStart:(id)sender;
- (IBAction)levelChanged:(id)sender;

-(IBAction)tstButtPress:(id)sender;

@end
