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
//    NSString* song2UrlString = @"http://promodj.com/download/5979204/Anna%20Lee%20-%20Live%20%40%20Sea%20Trance%20Fest%20%2831.07.2016%29%20%28promodj.com%29.mp3";
    NSString* song2UrlString = @"https://promodj.com/download/4490536/KRABeretto%20%E2%80%93%20Attack%20on%20titan%20%28promodj.com%29.mp3";
//    NSString* song3UrlString = @"https://promodj.com/download/5866036/Styline%20ft.%20Dragonfly%20-%20Temptation%20%28Original%20Mix%29%20%28promodj.com%29.mp3";
    NSString* song3UrlString = @"https://promodj.com/download/3782490/Zveroboyz%20-%20Russian%20Language%20%28promodj.com%29.mp3";
//    NSString* song4UrlString = @"https://promodj.com/download/6087320/Be%20Your%20Self%20%28promodj.com%29.mp3";
    NSString* song4UrlString = @"https://promodj.com/download/4293305/Syntetica%20Org%20-%20Marine%20Voyager%20%28Radio%20Mix%29%20%28promodj.com%29.mp3";
//    NSString* song5UrlString = @"https://promodj.com/download/6079318/Mikhail%20Evdokimov%20-%20Deep%20Frequency%20Radio%20Show%20%2329%20%28promodj.com%29.mp3";
    NSString* song5UrlString = @"https://promodj.com/download/5920607/Kristina%20Schtotz%20-%20Like%20A%20Bird%20%28A-Mase%20Chill-Out%20Version%29%20%28promodj.com%29.mp3";
    self.dowloadManagerCollection = [NSMutableArray new];
    self.dataManager = [CoraDataManager new];
    [self.dataManager clearCoreData];
    [self.tableView setSeparatorColor:[UIColor cyanColor]];
    self.urlStrings = [[NSMutableArray alloc] initWithObjects:song1UrlString, song2UrlString,song3UrlString, song4UrlString, song5UrlString,  nil];
    
    for (NSString* urlString in _urlStrings) {
        DownloadManager* loadManager = [[DownloadManager alloc] init];
        [self.dowloadManagerCollection addObject:loadManager];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [loadManager bigFileDownloadingAsync:urlString];
        });
        
        
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.t = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}

-(void) onTick{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.urlStrings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.dataTableViewCell = @"DataTableViewCell";
    DataTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: self.dataTableViewCell];
    NSInteger index = indexPath.row;
    
    cell.download = [_dowloadManagerCollection objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"Push to dowload Song %li", index + 1];
    if (cell.download.fileDownloaded && cell.moved) {
        NSMutableArray* fetchedCoreDataString = self.dataManager.getSavedDowloadInfo;
        NSInteger completedDownloadsNumber = [fetchedCoreDataString count];
        NSInteger finishedNumber = completedDownloadsNumber - 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.progresLabel.text = [fetchedCoreDataString objectAtIndex:0];
            NSLog(@"%@", fetchedCoreDataString);
            NSLog(@"finished number - %li against indexPath.row - %li", finishedNumber, indexPath.row);
            cell.moved = NO;
        });
    } else if (cell.moved) {
        NSString* progress = [NSString stringWithFormat:@"%.2f", (double)cell.download.bigFileData.length / (double)cell.download.expectedBigFileLength * 100.0];
        cell.progresLabel.text = progress;
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadManager *download = [_dowloadManagerCollection objectAtIndex:indexPath.row];
    [download resumePauseDownload];
}


-(void)dealloc {
//    [_t invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
