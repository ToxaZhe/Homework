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
//    NSString *urlString = @"http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-cd/debian-8.6.0-amd64-CD-1.iso";
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (self.bigFileTask.state == NSURLSessionTaskStateRunning) {
        [self.bigFileTask cancel];
    }
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *myQueue ;
    myQueue.maxConcurrentOperationCount = 1;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.bigFileTask = [defaultSession dataTaskWithURL:url];

    

    
        //    self.bigFileTask = [defaultSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        NSLog(@"FINISHED!");
    //    }];
    self.fileDownloaded = NO;
    
    [self.bigFileTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    if (dataTask == self.bigFileTask) {
        self.startingDowload = [NSDate date];
        NSLog(@"Response received. Starting download");
        
        self.expectedBigFileLength = [response expectedContentLength];
        self.bigFileData = [NSMutableData data];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if (dataTask == self.bigFileTask) {
        [self.bigFileData appendData:data];
        NSLog(@"%ld, %ld", (long)self.bigFileTask.state, dataTask.state);
        if (self.bigFileData.length == self.expectedBigFileLength) {
            self.finishedDowload = [NSDate date];
            CoraDataManager* dataManager = [CoraDataManager new];
            [dataManager saveDownloadStartDate:self.startingDowload andEndDate:self.finishedDowload];
            self.fileDownloaded = YES;
            
        }
//                NSLog(@"Received: %lu", (unsigned long)self.bigFileData.length);
//        NSLog(@"Received: %.2f", ((double)self.bigFileData.length / (double)self.expectedBigFileLength) * 100.0);
    }
    

}


@end
