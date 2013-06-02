//
//  ProgramSelectionDelegate.h
//  TVProgram
//
//  Created by Admin on 11.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTVShow;

@protocol ProgramSelectionDelegate <NSObject>
@required
//- (void) programIsSelected:(Show *)show;
- (void) programIsSelectedMTV:(MTVShow*)show;
@end

@protocol ChannelSelectionDelegate <NSObject>
@required
- (void) channelIsSelected:(NSString *)channel;
@optional
- (void) channelIsSelected:(NSString *)channel chID:(NSInteger)chId;
@end

@protocol CategorySelectionDelegate <NSObject>
- (void)categorySelected:(int)cat;
@end
