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
@property(nonatomic, strong) NSMutableArray*  urlStrings;
@property(nonatomic, strong) DownloadManager* dowloadManager;
@property(nonatomic, strong) NSString* dowloadingProgress;
@property(nonatomic, strong) NSTimer* t;
@property(nonatomic, strong) CoraDataManager* dataManager;

@property BOOL finished;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* song1UrlString = @"https://promodj.com/download/5908259/Eugene%20Kushner%20-%20the%20dreamer%20%28promodj.com%29.mp3@";
    NSString* song2UrlString = @"http://promodj.com/download/5979204/Anna%20Lee%20-%20Live%20%40%20Sea%20Trance%20Fest%20%2831.07.2016%29%20%28promodj.com%29.mp3";
    NSString* song3UrlString = @"https://promodj.com/download/5866036/Styline%20ft.%20Dragonfly%20-%20Temptation%20%28Original%20Mix%29%20%28promodj.com%29.mp3";
    NSString* song4UrlString = @"https://promodj.com/download/6087320/Be%20Your%20Self%20%28promodj.com%29.mp3";
    NSString* song5UrlString = @"https://promodj.com/download/6079318/Mikhail%20Evdokimov%20-%20Deep%20Frequency%20Radio%20Show%20%2329%20%28promodj.com%29.mp3";
    [self.tableView setSeparatorColor:[UIColor cyanColor]];
    self.dataManager = [CoraDataManager new];
    self.dowloadManager = [[DownloadManager alloc] init];
    self.urlStrings = [[NSMutableArray alloc] initWithObjects:song1UrlString, song2UrlString,song3UrlString, song4UrlString, song5UrlString,  nil];
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
    if (_finished) {
        [self.t invalidate];
        NSMutableArray* fetchedCoreDataString = self.dataManager.getSavedDowloadInfo;
        cell.progresLabel.text = [fetchedCoreDataString lastObject];
    } else {
        cell.progresLabel.text = self.dowloadingProgress;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* urlString = [self.urlStrings objectAtIndex:indexPath.row];
    [self.dowloadManager bigFileDownloadingAsync:urlString];
    
    self.t = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}


-(void)dealloc {
    [_t invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
