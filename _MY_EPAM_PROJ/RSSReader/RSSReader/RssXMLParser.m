//
//  RssXMLParser.m
//  RSSReader
//
//  Created by Sergei Zmachinsky on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RssXMLParser.h"
#import "RssItem.h"
#import "RssData.h"


@implementation RssXMLParser
//@synthesize xmlData;
@synthesize rssData,mainDelegate;

-(id) init {
	self = [super init];
	if (!self)
		return nil;
    rssItem = [[RssItem alloc] init]; 
    NSLog(@"!!-p-parser_init");    
    return self;
}

- (void)dealloc {
    NSLog(@"!!-p-parser_released");    
    
    [rssItem release];
    
    [super dealloc];
}




//========================================XML PARSER=============================================================
-(void) runXMLParserWithXMLData:(NSMutableData*)xmlDat 
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;     
    NSLog(@"-p->>>Parser start--");
    
    [rssData removeAllRssData];
    
    // Create the parser object with the data received from the web service
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlDat];
    // Give it a delegate 
    [parser setDelegate:self];
    // Tell it to start parsing - the document will be parsed and 
    // the delegate of NSXMLParser will get all of its delegate messages 
    // sent to it before this line finishes execution - it is blocking 
//    NSLog(@"--Parser start--");
    [parser parse];
//    NSLog(@"--Parser finish--");
    
    // The parser is done (it blocks until done), you can release it immediately
    [parser release]; 
    NSLog(@"<<<-p-Parser finish--");
    
//    [[self tableView] reloadData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;     

    [pool release];        
 }


-(void) runParsing:(NSMutableData*) xmlData 
{
//  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];   
    [NSThread detachNewThreadSelector:@selector(runXMLParserWithXMLData:) toTarget:self withObject:xmlData];    
//  [pool release];        
}


- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"<<<-p-Parsing completed--");
    [mainDelegate performSelectorOnMainThread:@selector(parsingDidFinished:) withObject:nil waitUntilDone:NO];
    // [mainDelegate reloadData];
}


//---------------------------------------------------------------------------------------
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI  
 qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict 
{	
    if([elementName isEqual:@"item"]) { 
        //      NSLog(@"Found a new Item");
        waitingForItemTitle = YES;
    }
    if (waitingForItemTitle == NO)
        return;
    
    
    if ([elementName isEqual:@"title"] || [elementName isEqual:@"link"] 
        || [elementName isEqual:@"description"] || [elementName isEqual:@"pubDate"]) 
    { 
        //        NSLog(@"found tag %@!",elementName);
        if (dataString) {
            [dataString release]; dataString = nil; 
        }
        dataString = [[NSMutableString alloc] init];
        //      [rssItem clearItem];
    }	
    
}	

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{	
    [dataString appendString:string];
}	

-(void) reloadRssData:(id) object{
//    [mainDelegate reloadData];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName 
{	
    if (waitingForItemTitle == NO)
        return;
    
    if ([elementName isEqual:@"item"]) { 
        //    NSLog(@">>ended Item = %@",rssItem);
        waitingForItemTitle = NO;
        [rssData addCopyItem:rssItem];
        [rssItem clearItem];
        
//        [self performSelectorOnMainThread:@selector(reloadRssData:) withObject:nil waitUntilDone:NO]; 
//        [mainDelegate performSelectorOnMainThread:@selector(reloadRssData:) withObject:nil waitUntilDone:NO];
//        [NSThread sleepForTimeInterval:0.2];       
        
    }	
    
    BOOL bTitle=[elementName isEqual:@"title"];
    BOOL bLink=[elementName isEqual:@"link"];
    BOOL bDEscription=[elementName isEqual:@"description"];
    BOOL bDate=[elementName isEqual:@"pubDate"];
        
    if ((bTitle) || (bLink) || (bDEscription) || (bDate) ) {
        /// NSLog(@"ended tag: %@", dataString);
        if (bTitle)
            rssItem.rssTitle=dataString;
        if (bLink) {
            rssItem.rssLink=dataString;
            rssItem.rssUrl = [NSURL URLWithString:dataString];
//          NSLog(@">>> Item link=%@  url=%@",rssItem.rssLink,rssItem.rssUrl);                
        }        
        if (bDEscription)
            rssItem.rssDescr=dataString;  
        if (bDate) {
            rssItem.rssDate=[self dateStringToDate:dataString];
            rssItem.rssText=dataString;
//          NSLog(@">>> Item date=%@ = %@",rssItem.rssText,rssItem.rssDate);                    
        }
        [dataString release]; dataString = nil;
    }	
}	
//---------------------------------------------------------------------------------------

-(NSDate *) dateStringToDate:(NSString *) dateString {
    // NSLog(@"%s %@", __FUNCTION__, dateString);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLenient:NO];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];   // the formatter should live in UTC
//    NSString *s = nil;
    
    NSArray *dateFormats = [NSArray arrayWithObjects:
                            @"EEE, dd MMM yyyy HHmmss zzz",  // no colons, see below
                            @"dd MMM yyyy HHmmss zzz",
                            @"yyyy-MM-dd'T'HHmmss'Z'",
                            @"yyyy-MM-dd'T'HHmmssZ",
                            @"EEE MMM dd HHmm zzz yyyy",
                            @"EEE MMM dd HHmmss zzz yyyy",
                            nil];
    
    // iOS's limited implementation of unicode date formating is missing support for colons in timezone offsets 
    // so we just take all the colons out of the string -- it's more flexible like this anyway
    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSDate * date = nil;
    for (NSString *format in dateFormats) {
        [dateFormatter setDateFormat:format];
        // store the NSDate object
        if((date = [dateFormatter dateFromString:dateString])) {
            // message(@"%@ (%@) -> %@", dateString, format, date);
            break;
        }
    }
    
    if (!date) date = [NSDate date];    // no date? use now.
    
 // [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];   // SQL date format
 // s = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return date;
}


@end
