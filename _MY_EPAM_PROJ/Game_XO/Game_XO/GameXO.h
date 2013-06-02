//
//  GameXO.h
//  Game_XO
//
//  Created by svp on 28.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GameXODelegate;

#define maxI 3
#define maxJ 4

typedef struct {int ij[3][2];} t_comb;


@interface CombXO : NSObject {
@public
    t_comb ar;
}
@end



@interface GameXO : NSObject {
    int level;
    BOOL isRunning;
    BOOL isThinking;
    int nCell;
    int stt[maxI][maxJ];
    int ars[maxI*maxJ];
    int ari[maxI*maxJ];
    int arj[maxI*maxJ];
    int arij[maxI*maxJ][2];
    NSMutableArray *comb;
}

@property (nonatomic, assign) id <GameXODelegate> delegate;

-(id)initWithLevel:(int)lev;
-(void)initGame;

-(void)setLevel:(int)lev;

-(void)addCell:(int)num;

-(void)makeMoveX:(int)i J:(int)j;

@end



@protocol GameXODelegate
    -(void) setSatusOfCell:(int)stat I:(int)i J:(int)j;
@end
