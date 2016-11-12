//
//  DownloadManager.m
//  Homework
//
//  Created by user on 11/5/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import "DownloadManager.h"
#import "CoraDataManager.h"


@interface DownloadManager() <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>
@property (strong,nonatomic) NSDate* startingDowload;
@property (strong,nonatomic) NSDate* finishedDowload;
@end


@implementation DownloadManager

- (void)bigFileDownloadingAsync:(NSString *)urlString {

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.bigFileTask = [defaultSession dataTaskWithURL:url];
    self.fileDownloaded = NO;
//    [self.bigFileTask resume];
}

-(void) start {
    [self.bigFileTask resume];
}

-(void) stop {
    [self.bigFileTask suspend];
}

-(void)resumePauseDownload {
    if (_bigFileTask.state == NSURLSessionTaskStateSuspended) {
        [self start];
    } else if (_bigFileTask.state == NSURLSessionTaskStateRunning) {
        [self stop];
    } else if (_bigFileTask.state == NSURLSessionTaskStateCompleted) {
        NSLog(@"Task Completed");
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    if (dataTask == self.bigFileTask) {
        self.startingDowload = [NSDate date];
        self.expectedBigFileLength = [response expectedContentLength];
        self.bigFileData = [NSMutableData data];
    }
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (dataTask == self.bigFileTask) {
        [self.bigFileData appendData:data];
        if (self.bigFileData.length == self.expectedBigFileLength) {
            self.finishedDowload = [NSDate date];
            CoraDataManager* dataManager = [CoraDataManager new];
            [dataManager saveDownloadStartDate:_startingDowload andEndDate:_finishedDowload];
            self.fileDownloaded = YES;
        }
    }
}

@end
