//
//  RssItem.h
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RssItem : NSObject {
    
    NSString *rssTitle;
    NSString *rssLink;
    NSString *rssDescr;
    NSString *rssText;
    NSURL   *rssUrl; 
    
    NSDate *rssDate;
    
}

@property (nonatomic,retain) NSString *rssTitle;
@property (nonatomic,retain) NSString *rssLink;
@property (nonatomic,retain) NSString *rssDescr;
@property (nonatomic,retain) NSString *rssText; 
@property (nonatomic,retain) NSURL *rssUrl; 

@property (nonatomic,retain)  NSDate *rssDate;

- (void)dealloc;

+(RssItem*) rssItem;

- (NSString *)description;


- (id)initWithTitle:(NSString *)title Link:(NSString *)link Description:(NSString *)description 
               Text:(NSString *)text Date:(NSDate *)date Url:(NSURL*)url;

- (id)initWithTitle:(NSString *)title Link:(NSString *)link; 
- (id)init;

-(void) clearItem;

@end
