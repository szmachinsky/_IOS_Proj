//
//  RssData.h
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RssItem;


@interface RssData : NSObject {

    NSMutableArray *rssArray;
    
}

-(id) init;

-(int) count;

-(void) removeAllRssData;
-(void) addItem:(RssItem*)rssItem;
-(void) addCopyItem:(RssItem*)rssItem;
-(RssItem*) itemWithIndex:(int)index;

@end
