//
//  DownloadManager.h
//  Homework
//
//  Created by user on 11/5/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadManager : NSObject
@property (strong, nonatomic) NSURLSessionDataTask *bigFileTask;
@property (strong, nonatomic) NSMutableData *bigFileData;
@property (nonatomic) double expectedBigFileLength;
@property BOOL fileDownloaded;


- (void)bigFileDownloadingAsync:(NSString *)urlString;
@end
