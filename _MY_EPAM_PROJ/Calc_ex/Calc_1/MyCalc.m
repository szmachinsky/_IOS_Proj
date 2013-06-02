//
//  MyCalc.m
//  Calc_1
//
//  Created by Administrator on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyCalc.h"


@implementation MyCalc

//-----------------------------------dealloc-------------------------------------------------
- (void)dealloc
{   
    [super dealloc];
}


-(NSString*)getBinary:(long long)data 
{
    NSMutableString *res=[NSMutableString stringWithCapacity:80];
    unsigned long long mask=0x8000000000000000;
//    int sz=sizeof(long long);
    BOOL bl=NO;
    for (; mask > 0; ) 
    {
        if (mask & data) {
            bl=YES;
            [res appendString:@"1"];
        } else {
            if (bl)
                [res appendString:@"0"];            
        }        
        mask >>=1;
    }
    if ([res length] == 0)
        [res appendString:@"0"];                    
    NSLog(@"==>(%@)",res);
    return res;
};   


//-----------------------------------calcResultString----------------------------------------------
-(NSString*)resultString {
    NSString *str = nil;
    double res=0;
    long long dres; //int64_t
    switch (state) {
        case (1):
            res=x1;
            break;
        case (2):
            if (x2) {
                res=x2;
            } else { res=x1; };
            break;
        case (3):
            res=y;
            break;
            
    } 
    if (decimalMode == 10)
//      if ((floatMode)||(state==3)) {
        if(resFlMode) {
//          str=[NSString stringWithFormat:@"%14.5f", res];             
            str=[NSString stringWithFormat:@"%16g", res];             
        } else {
            str=[NSString stringWithFormat:@"%10.0f", res];                        
        }
    if (decimalMode == 16) {
        dres = res;
        str=[NSString stringWithFormat:@"%lX", dres];
    }
    if (decimalMode == 2) {
        dres = res;
        str=[self getBinary:dres];
    }

    return str;
}



//-----------------------------------ClearParams----------------------------------------------
-(void) setParams:(double)X1 X2:(double)X2 Y:(double)Y STATE:(int)STATE OPER:(int)OPER {
    x1=X1; x2=X2; y=Y; state=STATE; oper=OPER;
    xx1=0; xx2=0;     
}


//-----------------------------------initWithLevel-------------------------------------------
-(id)initWithLevel:(int)Level {
    if (self == [super init]) {
        [self setParams:0 X2:0 Y:0 STATE:1 OPER:0];
        decimalMode=10; floatMode=0; level=1;
        xx1=0; xx2=0; 

        if (Level>=1 || Level<=3)
            level=Level;
//      self.resStr=@"0";
    }
    return self;      
}

//-----------------------------------description----------------------------------------------
-(NSString*)description {
//  NSString *str=[[[NSString alloc] initWithFormat:@"x1=%f x2=%f y=%f", x1,x2,y] autorelease];
    NSString *str=[NSString stringWithFormat:@"x1=%f x2=%f y=%f", x1,x2,y];    
    return str;
}


-(double)getDecimal:(long)xx {
    long xxx=xx;
    double fff=0, ff=0;
    while (xxx % 10) {
        ff=(xxx % 10);
        fff=(fff / 10.0) + (ff / 10.0);
        xxx=xxx / 10;
    };
    return fff; 
}

//-----------------------------------AddNUmber-------------------------------------------------
-(void) addNUmber:(int)Num {
    long xxx=0;
    double fff=0;
    switch (state) {
        case (1):
            if (floatMode) {
                if (xx1 < 10000)
                    xx1=(xx1*decimalMode)+Num;
                fff=[self getDecimal:xx1];
                xxx=x1; x1=xxx+fff;
                NSLog(@"x1= %lu  %g  %f",xx1,fff,x1);
            } else {
                if (x1 < 10000000)
                    x1=(x1*decimalMode)+Num;
            }
            break;
        case (2):
            if (floatMode) {
                if (xx2 < 10000)
                    xx2=(xx2*decimalMode)+Num;
                fff=[self getDecimal:xx2];
                xxx=x2; x2=xxx+fff;
                NSLog(@"x2= %lu  %g  %f",xx2,fff,x2);
            } else {
                if (x2 < 10000000)
                    x2=(x2*decimalMode)+Num;
            }
//          if (x2 < 10000000)
//              x2=(x2*decimalMode)+Num;
            break;
            
    }
    
 }


//------------------------------------RunOperation-----------------------------------------------
-(void)runOperation {
//  NSLog(@">Run1 op=%g %g %g",x1,x2,y);        
    switch (oper) {
        case (calcOpPlus):
            y=x1+x2;
            break;
        case (calcOpMinus):
            y=x1-x2;
            break;
        case (calcOpMult):
            y=x1*x2;
            break;
        case (calcOpDiv):
            y=x1/x2;
            break;
          
    }    
//  NSLog(@">Run2 op=%g %g %g",x1,x2,y);           
}


//------------------------------------PressNumButton---------------------------------------------
-(void)numButtonPressed:(int)Value {
    NSLog(@">got Num button with vaalue=%d",Value);    
//  self.resStr=[NSString stringWithFormat:@"%d", Value]; 
    Value%=100;
    if (Value > (decimalMode-1)) return;
    if (state >=3 ) {
        [self setParams:0 X2:0 Y:0 STATE:1 OPER:0];        
    };
    [self addNUmber:Value];
}


//------------------------------------PressOpButton---------------------------------------------
-(void)operButtonPressed:(NSString*)Label {
    if (Label==nil || [Label length]==0) return;   
    NSLog(@">got Op with label=%@",Label);
//  if (state > 2) return;
    floatMode=NO;
    if ([Label isEqualToString:@"+"]) {        
        oper=calcOpPlus;  state=2; //floatMode=NO;
    }   
    if ([Label isEqualToString:@"-"]) {        
        oper=calcOpMinus; state=2; //floatMode=NO;
    }   
    if ([Label isEqualToString:@"*"]) {        
        oper=calcOpMult;  state=2; //floatMode=NO;
    }   
    if ([Label isEqualToString:@"/"]) {        
        oper=calcOpDiv;   state=2; //floatMode=NO; 
    }  
    if ([Label isEqualToString:@"="]) {        
        [self runOperation];
        [self setParams:y X2:0 Y:y STATE:3 OPER:0];
        //floatMode=NO;
    }   

}


//------------------------------------PressModeButton----------------------------------------

//------------------------------------PressModeButton----------------------------------------
-(void)modeButtonPressed:(NSString*)Label {
    if (Label==nil || [Label length]==0) return;   
    //  NSString*str = [[(UIButton*)sender titleLabel] text];
    //  int i = [str intValue];
    NSLog(@">got Mode with label=%@",Label);
    if ([Label isEqualToString:@"+/-"]) {        
        if (state==1) x1=x1*(-1);
        if (state==2) x2=x2*(-1);
        
    }               
    if ([Label isEqualToString:@"C"]) {        
        [self setParams:0 X2:0 Y:0 STATE:1 OPER:0];
        resFlMode=NO;
    } 
    
    if ([Label isEqualToString:@"."]) {
        if (decimalMode == 10)
            floatMode=!floatMode;
        resFlMode=YES;
    NSLog(@">got Fl mode=%d",floatMode);        
    }     
    
}


-(void)inputModeButtonPressed:(int)Value {
    NSLog(@">got mode button with vaalue=%d",Value); 
    if (Value == decMode)
        decimalMode=10;
    if (Value == hexMode)
        decimalMode=16;
    if (Value == binMode)
        decimalMode=2;
    
}



//------------------------------------CheckIfHideTag------------------------------------------
-(BOOL)isViewHiddenByCalcLevel:(int)Tag {
    NSLog(@">check tag for hide=%d",Tag);
    BOOL  res = YES;
    if (Tag / 100 <= level) res=NO;
    return res;
}


-(BOOL)isButtonEnabledByInputMode:(int)Tag {
    BOOL  res = NO;
    if ((Tag % 100) < decimalMode ) res=YES;
    return res;
}

//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------


@end
