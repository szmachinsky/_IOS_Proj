//
//  RssItem.m
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RssItem.h"


@implementation RssItem 
@synthesize rssTitle,rssLink,rssDescr,rssText,rssDate, rssUrl;

//-------------------------------------------------------------------
+(RssItem*) rssItem 
{
    RssItem *item = [[[self alloc] initWithTitle:@"" Link:nil] autorelease];
    return item;    
}

- (void)dealloc {
    [rssTitle release];
    [rssLink release];
    [rssDescr release];
    [rssText release];
    [rssDate release];
    [rssUrl release];
    
    [super dealloc];
}


//-------------------------------------------------------------------
- (id)initWithTitle:(NSString *)title Link:(NSString *)link Description:(NSString *)description 
               Text:(NSString *)text Date:(NSDate *)date Url:(NSURL*)url
         					
{    
	self = [super init];
	if (!self)
		return nil;
    
    self.rssTitle=title;
    self.rssLink=link;
    self.rssDescr=description;
    self.rssText=text;
    self.rssDate=date;
    self.rssUrl=url;
    
    return self;
}

- (id)initWithTitle:(NSString *)title Link:(NSString *)link 
{
	return [self initWithTitle:title Link:link Description:nil Text:nil Date:nil Url:nil];    
}

- (id)init 
{
	return [self initWithTitle:nil Link:nil Description:nil Text:nil Date:nil Url:nil];    
}

//-------------------------------------------------------------------

-(void) clearItem
{
    self.rssTitle=nil;
    self.rssLink=nil;
    self.rssDescr=nil;
    self.rssText=nil;
    self.rssDate=nil; 
    self.rssUrl=nil;
}


- (NSString *)description 
{
    return [NSString stringWithFormat:@"title=%@ / link=%@", rssTitle, rssLink];    
}


@end
