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
@property(nonatomic, strong) NSMutableArray* dowloadManagerCollection;

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
    self.dowloadManagerCollection = [NSMutableArray new];
    [self.tableView setSeparatorColor:[UIColor cyanColor]];
    self.dataManager = [CoraDataManager new];
//    self.dowloadManager = [[DownloadManager alloc] init];
    self.urlStrings = [[NSMutableArray alloc] initWithObjects:song1UrlString, song2UrlString,song3UrlString, song4UrlString, song5UrlString,  nil];
}

-(void) onTick: (NSTimer*) timer {
    
//    for (DownloadManager* loadManager in _dowloadManagerCollection) {
    NSNumber* index = timer.userInfo;
    NSLog(@"index = %@", index);
//    NSInteger newIndex = [index integerValue];
//        DownloadManager* loadManager = [self.dowloadManagerCollection objectAtIndex:newIndex];
//        self.dowloadingProgress = [NSString stringWithFormat:@"%.2f", (double)loadManager.bigFileData.length / (double)loadManager.expectedBigFileLength * 100.0];
//        self.finished = loadManager.fileDownloaded;
        [self.tableView reloadData];
//    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.urlStrings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.dataTableViewCell = @"DataTableViewCell";
    DataTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: self.dataTableViewCell];
    
    NSInteger index = indexPath.row;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"Push to dowload Song %li", index + 1];
    if (_finished) {
        [self.t invalidate];
        NSMutableArray* fetchedCoreDataString = self.dataManager.getSavedDowloadInfo;
        cell.progresLabel.text = [fetchedCoreDataString lastObject];
    } else {
        for (DownloadManager* download in _dowloadManagerCollection) {
            cell.progresLabel.text = [NSString stringWithFormat:@"%.2f", (double)download.bigFileData.length / (double)download.expectedBigFileLength * 100.0];
        }
//        cell.progresLabel.text = self.dowloadingProgress;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* urlString = [self.urlStrings objectAtIndex:indexPath.row];
    ;
//    NSInteger dowloadsCount = [_dowloadManagerCollection count];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSNumber* indexOfCell = [NSNumber numberWithInteger:lastIndexPath.row];
   
    [tableView moveRowAtIndexPath:indexPath toIndexPath:lastIndexPath];
    DownloadManager* loadManager = [[DownloadManager alloc] init];
    [self.dowloadManagerCollection addObject:loadManager];
    [loadManager bigFileDownloadingAsync:urlString];
    NSLog(@"%ld", (long)lastIndexPath.row);
    
    self.t = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTick:) userInfo:indexOfCell repeats:YES];
}


-(void)dealloc {
    [_t invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
