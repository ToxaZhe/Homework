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
@property (strong,nonatomic) NSString* dataUrl;
@end


@implementation DownloadManager


#pragma mark: custom methods to manage the downloads

- (void)bigFileDownloadingAsync:(NSString *)urlString {

    self.dataUrl = urlString;
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

#pragma mark: native NSURLSession methods to handle with downloads

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
            NSURL *url = [NSURL URLWithString:_dataUrl];
            NSString* fileName = [[url pathComponents] lastObject];
            [self saveMp3FileToPath:self.bigFileData mp3FileName:fileName];
            [dataManager saveDownloadStartDate:_startingDowload andEndDate:_finishedDowload];
            self.fileDownloaded = YES;
        }
    }
}

#pragma mark:Handle saving data files to cache methods

- (NSURL *)documentsDirectoryUrl {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveMp3FileToPath:(NSData *)mp3Data
              mp3FileName:(NSString *)mp3FileName {
    NSURL *documentsURL = [self documentsDirectoryUrl];
    NSString *filePath = documentsURL.path;
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.mp3", filePath, mp3FileName];
    [mp3Data writeToFile:fileName atomically:YES];
}

@end
