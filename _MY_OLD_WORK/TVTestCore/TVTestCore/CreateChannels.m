//
//  CreateChannels.m
//  TVTestCore
//
//  Created by Admin on 18.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateChannels.h"

@implementation CreateChannels

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString*)pathDocDir 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"]; 
    return documentPath;     
}


- (NSString *)pathInDocDir:(NSString*)fileName 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"]; 
    return [documentPath stringByAppendingPathComponent:fileName];     
}


- (void)parseFile:(NSString*)file 
{
    NSString *filePath = [self pathInDocDir:@"index.json"];
     
    NSError *err;
    NSData *dat = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dat options:kNilOptions error:&err];        
    NSLog(@" parsed %d records",[data count]); 
}



@end
