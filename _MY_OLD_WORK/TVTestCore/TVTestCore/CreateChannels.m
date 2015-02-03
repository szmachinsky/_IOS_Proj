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
//    NSString *filePath = [self pathInDocDir:@"index.json"];
    
    NSString *rootPath = DOCUMENTS;
    NSLog(@"ROOT_DIR=%@",rootPath);
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"index.json" ofType:nil];
    NSLog(@"FILE=%@",filePath1);
    
     
    NSError *err;
    NSData *dat = [[NSData alloc] initWithContentsOfFile:filePath1];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:dat options:kNilOptions error:&err];        
    NSLog(@" parsed %d records",[data count]); 
}



@end
