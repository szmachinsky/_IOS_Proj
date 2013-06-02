//
//  BZFile.h
//  AutoUnion
//
//  Created by Alex Shchyrko on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include <zlib.h>
#import "bzlib.h"

@interface BZFile : NSObject {

	BZFILE *pBz;
	FILE* f_src;
	FILE* dst;
	char buffer[8192];
	int bzerror;
    
    
}
- (id)initWithFileName:(NSString*)filename;
- (int)decompressFile:(NSString*)targetfile;
- (int)bzOpen;

+ (NSData*)decompressData:(NSData*)data;

@end
