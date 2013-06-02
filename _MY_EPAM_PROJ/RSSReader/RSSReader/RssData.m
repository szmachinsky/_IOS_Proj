//
//  RssData.m
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RssData.h"
#import "RssItem.h"

@implementation RssData

//------------------------------------------------------------------------------------------
- (void)dealloc 
{
	[rssArray release]; 
	[super dealloc];
}

//------------------------------------------------------------------------------------------
-(id) init
{
    self = [super init];
    if (!self)
        return nil;  
    rssArray = [[NSMutableArray alloc] init];
    
    return self;
}

//------------------------------------------------------------------------------------------
-(int) count
{
    return [rssArray count];
}

//------------------------------------------------------------------------------------------
-(void) removeAllRssData 
{
    [rssArray removeAllObjects];
}

-(void) addItem:(RssItem*)rssItem 
{
    [rssArray addObject:rssItem];        
}

-(void) addCopyItem:(RssItem*)rssItem 
{
    RssItem *item = [[[RssItem alloc] initWithTitle:rssItem.rssTitle Link:rssItem.rssLink Description:rssItem.rssDescr Text:rssItem.rssText Date:rssItem.rssDate Url:rssItem.rssUrl] autorelease];
    [rssArray addObject:item];    
}

-(RssItem*) itemWithIndex:(int)index 
{
    if (index <= [rssArray count]) {
        return [rssArray objectAtIndex:index];
    } else {
        return nil;
    }
}


@end
