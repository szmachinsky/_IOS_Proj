//
//  FileDownloader.h
//  Test_1
//
//  Created by svp on 03.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFileDownloadNote  @"download_Finished"
#define kImageDownloadNote @"im_download_Finished"

@interface FileDownloader : NSObject {
}

@property(nonatomic,readonly) NSURLConnection *connection;
@property(nonatomic,readonly) NSMutableData *receivedData;

- (id)initWithRequest:(NSURLRequest*)req;
- (id)initWithString:(NSString*)str;

@end


@interface ImageDownloader : FileDownloader { 
}

@property(nonatomic,readonly) UIImage *image;
@property(nonatomic) int imSize;

@end