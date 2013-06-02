//
//  BZFile.m
//  AutoUnion
//
//  Created by Alex Shchyrko on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZFile.h"
//#import <bzlib.h>

NSString* DocumentDirectory(NSString *relPath);
@implementation BZFile


#define GB_Z_BUFFER 8192

- (id)initWithFileName:(NSString *)filename
{
	if (self = [super init]) 
	{
///		NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
///		NSString *path = [SZUtils _pathTmpDirectory];
///		path = [path stringByAppendingPathComponent: filename];
        
        NSString *path = filename; //zs
		strcpy(buffer,[path UTF8String]);
	}
	return self;
}
- (int)bzOpen
{
	if ((f_src = fopen(buffer, "rb")) == NULL) {
		NSLog(@"error fopen");
	}
	pBz = BZ2_bzReadOpen(&bzerror, f_src, 0, 0, NULL, 0);
	if (bzerror) {
		BZ2_bzReadClose(&bzerror, pBz);
		fclose(f_src);
		NSLog(@"UnableOpen file for writing %s",buffer);
	}
	return bzerror;
}


// take name~tmp file
//NSString* DocumentDirectory(NSString *relPath)
//{
///// NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
//    NSString *path = [SZUtils _pathTmpDirectory];
//    if (relPath != nil )
//        path = [path stringByAppendingPathComponent: relPath];
//    return path;
//}

//[SZUtils _pathTmpDirectory] stringByAppendingPathComponent:

- (int)decompressFile:(NSString*)targetfile
{
	long len;
	char buf[GB_Z_BUFFER];
	
///	const char* target = [DocumentDirectory(targetfile) UTF8String];
    const char* target = [targetfile UTF8String];
/// _NSLog(@"++> unzip to %s",target);	
	if (( dst = fopen(target, "w")) == NULL) 
	{
		BZ2_bzReadClose(&bzerror, pBz);
		NSLog(@"Unable open file for writing: %@",targetfile);
		return -1;
	}
	bzerror = BZ_OK;
	
	while (bzerror != BZ_STREAM_END) 
	{
		len=BZ2_bzRead(&bzerror,pBz,buf,sizeof(char)*GB_Z_BUFFER);
		if ( (bzerror!=BZ_OK) && (bzerror!=BZ_STREAM_END) )
		{
			BZ2_bzReadClose (&bzerror,pBz);
            fclose(f_src);
			fclose(dst);
			//remove(target);
            _NSLog(@"error while reading file");
			return -1;
		}
		if (len) 
		{
			if (len != fwrite((void*)buf,sizeof(char),len,dst) )
			{
				BZ2_bzReadClose (&bzerror,pBz);
				fclose(f_src);
				fclose(dst);
				NSLog(@"error while writing file");
				return -1;
			}
		}
	}
///    NSString* newName = [targetfile stringByReplacingOccurrencesOfString:@"~tmp" withString:@""];
    //NSLog(@"newName: %@",newName);
    //rename(target, [DocumentDirectory(newName) UTF8String]);
	BZ2_bzReadClose (&bzerror,pBz);
	fclose(f_src);
	fclose(dst);
    return 1;
}

#define bufSize 20000
+ (NSData*)decompressData:(NSData*)data
{
    NSData *res = nil;
    char buf1[10000];
    char buf2[bufSize];
    unsigned int len = [data length];
    unsigned int lenres = bufSize;
    if (len < 10000) {
        memcpy(buf1, [data bytes], len);
    } else {
        return res;
    }
    int err = BZ2_bzBuffToBuffDecompress(buf2,&lenres, buf1, len, 0, 0 );
//    _NSLog(@" %d :  %d %d",err,len,lenres);    
    if (err == BZ_OK) {
        res = [NSData dataWithBytes:buf2 length:lenres];
    }
    return res;
}

/*
 int BZ_API(BZ2_bzBuffToBuffDecompress) ( 
 char*         dest, 
 unsigned int* destLen,
 char*         source, 
 unsigned int  sourceLen,
 int           small, 
 int           verbosity 
 ); 
 
 
 int BZ_API(BZ2_bzRead) ( 
 int*    bzerror, 
 BZFILE* b, 
 void*   buf, 
 int     len 
 );
 
*/

@end
