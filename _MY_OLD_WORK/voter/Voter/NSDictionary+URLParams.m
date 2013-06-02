//
//  NSDictionary+URLParams.m
//  Voter
//
//  Created by Khitryk Artsiom on 21.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+URLParams.h"

@implementation NSDictionary (URLParams)
- (NSString*)stringWithGetParams
{
    NSMutableString* paramsString = [NSMutableString string];
    
    NSArray* keys = [self allKeys];
    for (NSString* key in keys)
    {
        
        if ([[self objectForKey:key] isKindOfClass:[NSArray class]])
        {
            NSArray* obj = [self objectForKey:key];
            for (NSString* string in obj)
            {
                NSString* param = string;
                [paramsString appendFormat:[NSString stringWithFormat:@"&%@=%@",key,param]];
            }
        }
        else
        {
            NSString* param = [self objectForKey:key];
            [paramsString appendFormat:[NSString stringWithFormat:@"&%@=%@",key,param]]; 
        }

    }
    
    if (paramsString.length != 0)
    {
        NSRange range;
        range.location = 0;
        range.length = 1;
        
        [paramsString deleteCharactersInRange:range];
    }
    else
    {
        paramsString =  nil;
    }
    
    return paramsString;
}
@end
