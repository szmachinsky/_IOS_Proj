//
//  GameXO.m
//  Game_XO
//
//  Created by svp on 28.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameXO.h"



@implementation CombXO

-(id) init:(t_comb)val {
    if (self == [super init]) {
        ar=val;
//      NSLog(@">>> %d %d | %d %d |: %d %d ",ar.ij[0][0],ar.ij[0][1],ar.ij[1][0],ar.ij[1][1],ar.ij[2][0],ar.ij[2][1]);
    }
    return self;      
}

-(NSString*)description {
    NSString *sss = [NSString stringWithFormat:@">>> (%d,%d)(%d,%d)(%d,%d)",ar.ij[0][0],ar.ij[0][1],ar.ij[1][0],ar.ij[1][1],ar.ij[2][0],ar.ij[2][1]];
    return sss;
}

@end



@implementation GameXO
@synthesize delegate=_delegate;


- (void)dealloc
{   
    [comb release];
    [super dealloc];
}

-(void)resetState {
    int ij=0;
    for (int i=0; i<maxI; i++) {
        for (int j=0; j<maxJ; j++, ij++) {
            arij[ij][0]=i;
            arij[ij][1]=j;
            if (j==3) {
                stt[i][j]=-1;
                if ((i+1) == nCell)
                    stt[i][j]=0;                 
            } else {
                stt[i][j]=0;  
            }                   
        }
    }
    isRunning=NO;
    isThinking=NO;
}

-(void)setBasicRules {
    CombXO *com;   
    t_comb t0 = {0,0,0,1,0,2};
    com = [[[CombXO alloc] init:t0] autorelease];
    [comb addObject:com];      
    t_comb t1 = {1,0,1,1,1,2};
    com = [[[CombXO alloc] init:t1] autorelease];
    [comb addObject:com];
    t_comb t2 = {2,0,2,1,2,2};
    com = [[[CombXO alloc] init:t2] autorelease];
    [comb addObject:com];
    
    t_comb t3 = {0,0,1,0,2,0};
    com = [[[CombXO alloc] init:t3] autorelease];
    [comb addObject:com];
    t_comb t4 = {0,1,1,1,2,1};
    com = [[[CombXO alloc] init:t4] autorelease];
    [comb addObject:com];
    t_comb t5 = {0,2,1,2,2,2};
    com = [[[CombXO alloc] init:t5] autorelease];
    [comb addObject:com];
    
    t_comb t6 = {0,0,1,1,2,2};
    com = [[[CombXO alloc] init:t6] autorelease];
    [comb addObject:com];
    t_comb t7 = {2,0,1,1,0,2};
    com = [[[CombXO alloc] init:t7] autorelease];
    [comb addObject:com];    
}

-(void)setAdditionalRulesFor:(int)num {
    CombXO *com;
    if (num==1){
        t_comb t8 = {0,1,0,2,0,3};
        com = [[[CombXO alloc] init:t8] autorelease];
        [comb addObject:com];
        t_comb t9 = {2,1,1,2,0,3};
        com = [[[CombXO alloc] init:t9] autorelease];
        [comb addObject:com];        
    }
    if (num==2){
        t_comb t8 = {1,1,1,2,1,3};
        com = [[[CombXO alloc] init:t8] autorelease];
        [comb addObject:com];     
    }   
    if (num==3){
        t_comb t8 = {2,1,2,2,2,3};
        com = [[[CombXO alloc] init:t8] autorelease];
        [comb addObject:com];
        t_comb t9 = {0,1,1,2,2,3};
        com = [[[CombXO alloc] init:t9] autorelease];
        [comb addObject:com];        
    }    
}

//-----------------------------------initWithLevel-------------------------------------------
-(id)initWithLevel:(int)lev {
    if (self == [super init]) {
        level=lev;
        isRunning=NO;
        isThinking=NO;
        nCell=0;
        [self resetState];
        
        comb=[[NSMutableArray alloc] initWithCapacity:15];
        [self setBasicRules];
        
    }
    return self;      
}

-(void)addCell:(int)num {
    nCell=num;
    [comb removeAllObjects];
    
    [self setBasicRules];    
    [self setAdditionalRulesFor:num];
    
    [self initGame];
}


-(void)setLevel:(int)lev {
//  NSLog(@" level=%d",lev);
    level=lev;
}

-(void) shiftRand {
    long rnd = (time(NULL) % 100) + (clock()%100);
//  NSLog(@" rand=%lu",rnd);
    for(int id=0; id<=rnd; id++) rand(); //shift rand    
}

-(void)initGame { 
    [self resetState];
    for (int i=0; i<maxI; i++) {
        for (int j=0; j<maxJ; j++) {
            [_delegate setSatusOfCell:stt[i][j] I:i J:j Animation:NO];
        }
    }
    [self shiftRand];
    isRunning=YES;
}

-(void)sendMessageWin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youWinXONotification" object:self userInfo:nil];
    isRunning=NO; isThinking=NO; 
}

-(void)sendMessageLose {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youLoseXONotification" object:self userInfo:nil];
    isRunning=NO; isThinking=NO;
}

-(void)sendMessageDraw {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"youDrawXONotification" object:self userInfo:nil];
    isRunning=NO; isThinking=NO;
}


-(BOOL) checkIfWinBy:(int)val {
    BOOL res=NO;
    int ii,s,i,j,v;
    t_comb tt;
    CombXO *com;
    for (ii=0; ii<maxI*maxJ; ii++) {
        ars[ii]=-1; ari[ii]=-1; arj[ii]=-1;
    }
//  for (com in comb) {
    for (ii=0;ii<[comb count];ii++) {
        com=[comb objectAtIndex:ii];   
        tt=com->ar; s=0;
//      NSLog(@"check in %@",com);
        for (int id=0; id<3; id++) {
            i = tt.ij[id][0];
            j = tt.ij[id][1];
            v = stt[i][j];
            //if (v>0) { 
                s=s+v;
            //};
            if (v==0) {
                ari[ii]=i; arj[ii]=j;
            }
        };
        ars[ii]=s;
        if (s==val*3) {
            if (s==30) {
                for (int id=0; id<3; id++) {
                    i = tt.ij[id][0]; 
                    j = tt.ij[id][1];                    
                    [_delegate setSatusOfCell:stt[i][j] I:i J:j Animation:YES]; 
                }
                
            }
            
            return YES; 
        }
    }
    
    return res;
}

-(int)getRandI:(int*)ir J:(int*)jr From:(int)cn {
    int i,j,v,ij1;
    int ij=rand() % (maxI*maxJ);
    ij1=ij;
    do {
        i=arij[ij][0];j=arij[ij][1]; v=stt[i][j];
        if (v==0) {
            if (cn) {
                if ((ij==0 || ij==2 || ij==8 || ij==10)) {
//                    NSLog(@" ++Rand_con: %d,%d",i,j);
                    *ir=i; *jr=j; return 1;                 
                }
            } else {                
//                NSLog(@" ++Rand: %d,%d",i,j);
                *ir=i; *jr=j; return 2;
            }
        }
        ij++;
        ij= ij % (maxI*maxJ); 
    } while (ij1!=ij);    
    return -1;
}


-(int)getI:(int*)ir J:(int*)jr {
//  int v=0,j,i,ii,ij;
    int ii;
    
    for (ii=0; ii<maxI*maxJ; ii++) {
        if (ars[ii] == 20) {
//            NSLog(@" +win: %d,%d",ari[ii],arj[ii]);
            *ir=ari[ii]; *jr=arj[ii]; return 1;
        }
    }
    
    if (level > 0)
    for (ii=0; ii<maxI*maxJ; ii++) {
        if (ars[ii] == 2) {
//            NSLog(@" +bad: %d,%d",ari[ii],arj[ii]);
            *ir=ari[ii]; *jr=arj[ii]; return 2;
        }
    }
    
    if (level > 0) {
        if (stt[1][1] == 0) {
//          NSLog(@" +center");
            *ir=1; *jr=1; return 3; 
        }
        if ((nCell==2)&&(stt[1][2] == 0)) {
            *ir=1; *jr=2; return 3; 
        }           
        if (level>=2) {
            if ((nCell==1)&&(stt[0][2] == 0)) {
                *ir=0; *jr=2; return 3; 
            }
            if ((nCell==3)&&(stt[2][2] == 0)) {
                *ir=2; *jr=2; return 3; 
            }
            if ((nCell>0)&&(stt[1][2] == 0)) {
                *ir=1; *jr=2; return 3; 
            }           
        }
        if (level>=1) {
            if ([self getRandI:ir J:jr From:1]>0) {
                return 4;
            }                        
        }
    }
    
    
    if ([self getRandI:ir J:jr From:0]>0) {
//        NSLog(@" +rand: %d,%d",*ir,*jr);        
        return 5;
    }
    
    NSLog(@" ++++empty move");
    return -1;
}


-(void)makeMoveO:(id)sender {
    if (isThinking==NO) return;
    int ii=1,jj=3;
    int res=[self getI:&ii J:&jj];
//    NSLog(@"Move_O = %d",res);
    if (res >= 0) {
        stt[ii][jj]=10; //set O
        [_delegate setSatusOfCell:stt[ii][jj] I:ii J:jj Animation:YES]; 
        if ([self checkIfWinBy:10]) {
            [self sendMessageLose]; //Lose!!!
            return;
        }            
    }
    if ([self getRandI:&ii J:&jj From:0] < 0)  {
        NSLog(@"DRAW detected");
        [self sendMessageDraw]; //Draw!!!       
    }
    isThinking=NO;   
}


-(void)makeMoveX:(int)i J:(int)j {
    if (isRunning==NO) return;
    if (isThinking==YES) return;
    if (i >= maxI)  return;
    if (j >= maxJ)  return;
    if ((stt [i][j] == -1)&&(j==3)) {
        [self addCell:(i+1)];
        return;
    }    
    if (stt[i][j] != 0) return;
    
    stt[i][j]=1; //set X
    [_delegate setSatusOfCell:stt[i][j] I:i J:j Animation:NO];
    
    if ([self checkIfWinBy:1]) {
        [self sendMessageWin]; //Win!!!
        return;
    }  
    
    isThinking=YES;
//  [self makeMoveO:nil];
    [self performSelector:@selector(makeMoveO:) withObject:nil afterDelay:1.0];
//  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(makeMoveO:) userInfo:nil repeats:NO];
    
}


@end
