//
//  MyCalc.h
//  Calc_1
//
//  Created by Administrator on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum calcCodes {
    mycalcBasic = 1,
    mycaclAdvanced = 2,
    mycalcExpert = 3,
    calcOpPlus,
    calcOpMinus,
    calcOpMult,
    calcOpDiv,
    calcOpSign,
    decMode,
    hexMode,
    binMode    
};


enum calcButtonsTags {
    button_0=100,
    button_1=101, 
    button_2=102,
    button_3=103,
    button_4=104,
    button_5=105,
    button_6=106,
    button_7=107,
    button_8=108,
    button_9=109,
    button_A=210,
    button_B=211,
    button_C=212,
    button_D=213,
    button_E=214,
    button_F=215,
    buttons_Basic_Lelev=100,
    buttons_Advanced_Level=200,
    buttons_Expert_Level=300, 
};

@interface MyCalc : NSObject {
    
    double x1,x2,y;
    long xx1,xx2;
    int decimalMode;
    BOOL floatMode,resFlMode;
    int state,oper;
    int level;
           
}

-(NSString*)resultString;

-(id)initWithLevel:(int)Level;

-(BOOL)isViewHiddenByCalcLevel:(int)Tag;    

-(BOOL)isButtonEnabledByInputMode:(int)Tag;    

-(void)numButtonPressed:(int)Value;

-(void)operButtonPressed:(NSString*)Label;

-(void)modeButtonPressed:(NSString*)Label;

-(void)inputModeButtonPressed:(int)Value;

@end
