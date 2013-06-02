//
//  HypnosisView.h
//  Hypnose
//
//  Created by Administrator on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef float (*pRandFunc) (id,SEL,float,float,float,float);

@interface HypnosisView : UIView {
    int col;
    float c1,c2,c3,al,al1,al2;
    int boost;
    pRandFunc pRndFunc;
    float (*ppRndFunc) (id,SEL,float,float,float,float);
    SEL SelRnd;
}
@property (assign) int boost;

@end
