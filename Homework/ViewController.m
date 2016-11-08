//
//  ViewController.m
//  Homework
//
//  Created by user on 11/3/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import "ViewController.h"
#import "DataTableViewCell.h"
#import "CoraDataManager.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSString* dataTableViewCell;
@property(nonatomic, strong) NSMutableArray* __block urlStrings;
@property(nonatomic, strong) DownloadManager* __block dowloadManager;
@property(nonatomic, strong) NSString* __block dowloadingProgress;
@property(nonatomic, strong) NSTimer* t;
@property(nonatomic, strong) CoraDataManager* dataManager;

@property BOOL finished;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* mp3UrlString = @"https://promodj.com/download/5908259/Eugene%20Kushner%20-%20the%20dreamer%20%28promodj.com%29.mp3@"/*http://promodj.com/download/5979204/Anna%20Lee%20-%20Live%20%40%20Sea%20Trance%20Fest%20%2831.07.2016%29%20%28promodj.com%29.mp3"*/;
    self.dataManager = [CoraDataManager new];
    self.dowloadManager = [[DownloadManager alloc] init];
    self.urlStrings = [[NSMutableArray alloc] init];
    [self.urlStrings addObject:mp3UrlString];
    
}

-(void) onTick {
    self.dowloadingProgress = [NSString stringWithFormat:@"%.2f", (double)self.dowloadManager.bigFileData.length / (double)self.dowloadManager.expectedBigFileLength * 100.0];
    self.finished = self.dowloadManager.fileDownloaded;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.urlStrings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.dataTableViewCell = @"DataTableViewCell";
    DataTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: self.dataTableViewCell];
    if (self.finished) {
        [self.t invalidate];
        NSMutableArray* fetchedCoreDataString = self.dataManager.getSavedDowloadInfo;
        cell.progresLabel.text = [fetchedCoreDataString lastObject];
    } else {
       cell.progresLabel.text = self.dowloadingProgress; 
    }
    
    
    

    cell.beginDowload = ^{
        NSString* urlString = [self.urlStrings objectAtIndex:indexPath.row ];
        [self.dowloadManager bigFileDownloadingAsync:urlString];
            };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* urlString = [self.urlStrings objectAtIndex:indexPath.row ];
    [self.dowloadManager bigFileDownloadingAsync:urlString];
    
    self.t = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}


-(void)dealloc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
