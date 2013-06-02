//
//  RssXMLParser.h
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RssData;
@class RssItem;

@protocol RssXMLParserDelegate;


@interface RssXMLParser : NSObject <NSXMLParserDelegate> {
//  NSMutableData   *xmlData; 
    
    NSMutableString *dataString;    
    BOOL waitingForItemTitle;
        
    RssData *rssData; 
    RssItem *rssItem;  
    
    id mainDelegate;

}
//@property (nonatomic, retain) NSMutableData *xmlData;

@property (nonatomic,assign) id<RssXMLParserDelegate> mainDelegate;

@property (nonatomic,assign) RssData *rssData; 

-(id) init;
-(void)dealloc;
-(void)runParsing:(NSMutableData*) xmlData;

-(NSDate *) dateStringToDate:(NSString *) dateString;

@end


@protocol RssXMLParserDelegate <NSObject>
-(void) parsingDidFinished:(id) object;
@end