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
#import "PlayerViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) NSString* dataTableViewCell;
@property(nonatomic, strong) NSArray*  urlStrings;
@property(nonatomic, strong) DownloadManager* dowloadManager;
@property(nonatomic, strong) NSString* dowloadingProgress;
@property(nonatomic, strong) NSTimer* t;
@property(nonatomic, strong) CoraDataManager* dataManager;
@property(nonatomic, strong) NSMutableArray* dowloadManagerCollection;
@property(nonatomic, strong) NSMutableDictionary* completedDownloadsDates;
@property(nonatomic, strong) NSMutableSet *cellIndexes;

@property BOOL finished;

@end

@implementation ViewController

#pragma mark: native viewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationController* nav = [UINavigationController new];
    [nav setNavigationBarHidden:YES animated:YES];
    [self.tableView setSeparatorColor:[UIColor cyanColor]];
    _completedDownloadsDates = [[NSMutableDictionary alloc] init];
    _cellIndexes = [NSMutableSet set];
    [self initAndCleanCoreData];
    [self fillArrayWithUrlStrings];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.t = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTick) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"GoListenTrack"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PlayerViewController *destVC = [segue destinationViewController];
        destVC.mp3Url = [_urlStrings objectAtIndex:indexPath.row];
        DownloadManager* download = [_dowloadManagerCollection objectAtIndex:indexPath.row];
        destVC.mp3File = download.bigFileData;
    }
}



#pragma mark: table view delegate and data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.urlStrings.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    self.dataTableViewCell = @"DataTableViewCell";
    DataTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: self.dataTableViewCell];
    NSInteger index = indexPath.row;
    
    cell.download = [_dowloadManagerCollection objectAtIndex:indexPath.row];
    if (cell.download.fileDownloaded) {
        NSMutableArray* fetchedCoreDataString = self.dataManager.getSavedDowloadInfo;
//        NSInteger completedDownloadsNumber = [fetchedCoreDataString count];
        if (cell.moved) {
          [self.completedDownloadsDates setObject:[fetchedCoreDataString lastObject] forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
            [self.cellIndexes addObject: [NSNumber numberWithInteger:index]];
            cell.moved = NO;
        }
        
//        NSInteger finishedNumber = completedDownloadsNumber - 1;
        
        if ([_cellIndexes containsObject: [NSNumber numberWithInteger:index]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.progresLabel.text = [self.completedDownloadsDates objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                NSLog(@"%@", [self.completedDownloadsDates objectForKey:[NSString stringWithFormat:@"%@", indexPath]]);
                cell.nameLabel.text = @"Push to listen";
                NSLog(@"%@", self.completedDownloadsDates);
            });
        } else {
            cell.nameLabel.text = [NSString stringWithFormat:@"Push to dowload Song %li", index + 1];
            NSString* progress = [NSString stringWithFormat:@"%.2f", (double)cell.download.bigFileData.length / (double)cell.download.expectedBigFileLength * 100.0];
            cell.progresLabel.text = progress;
        }
        
//            NSLog(@"finished number - %li against indexPath.row - %li", finishedNumber, indexPath.row);
            
        
        if (fetchedCoreDataString.count == _urlStrings.count){
            [_t invalidate];
        }
    } else if (cell.moved) {
         cell.nameLabel.text = [NSString stringWithFormat:@"Push to dowload Song %li", index + 1];
        NSString* progress = [NSString stringWithFormat:@"%.2f", (double)cell.download.bigFileData.length / (double)cell.download.expectedBigFileLength * 100.0];
        cell.progresLabel.text = progress;
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadManager *download = [_dowloadManagerCollection objectAtIndex:indexPath.row];
    [download resumePauseDownload];
    if (download.fileDownloaded){
        [self performSegueWithIdentifier:@"GoListenTrack" sender:NULL];
    }
}


#pragma mark: custom methods

-(void) fillArrayWithUrlStrings {
    NSString* song1UrlString = @"https://promodj.com/download/5908259/Eugene%20Kushner%20-%20the%20dreamer%20%28promodj.com%29.mp3@";
    NSString* song2UrlString = @"http://promodj.com/download/503851/mu5ex%20-%20happy%20new%20you%20%28promodj.com%29.mp3";
    NSString* song3UrlString = @"https://promodj.com/download/3782490/Zveroboyz%20-%20Russian%20Language%20%28promodj.com%29.mp3";
    NSString* song4UrlString = @"https://promodj.com/download/4293305/Syntetica%20Org%20-%20Marine%20Voyager%20%28Radio%20Mix%29%20%28promodj.com%29.mp3";
    NSString* song5UrlString = @"https://promodj.com/download/5920607/Kristina%20Schtotz%20-%20Like%20A%20Bird%20%28A-Mase%20Chill-Out%20Version%29%20%28promodj.com%29.mp3";
     NSString* song6UrlString = @"http://promodj.com/download/4828023/Da%20Rave%20-%20Milky%20Way%20%28Original%20Mix%29%20%28promodj.com%29.mp3";
     NSString* song7UrlString = @"http://promodj.com/download/1746719/%D0%AF%D0%B6%D0%B5%D0%92%D0%B8%D0%BA%D0%B0%20%E2%80%94%20%D0%9B%D0%B5%D1%82%D0%BE%20%28original%29%20%28promodj.com%29.mp3";
    NSString* song8UrlString = @"http://promodj.com/download/5658805/SNV%20Production%20-%20Alone%20%28promodj.com%29.mp3";
    NSString* song9UrlString = @"http://promodj.com/download/439301/Implex%20-%20The%20Shape%20of%20Time%20%28promodj.com%29.mp3";
    NSString* song10UrlString = @"http://promodj.com/download/770564/Trance%20Brothers%20Eternal%20Life%20%28promodj.com%29.mp3";
    NSString* song11UrlString = @"http://promodj.com/download/5491668/AN.DU%20-%20Africanizm%20%28Original%20Mix%29%20%28promodj.com%29.mp3";
    NSString* song12UrlString = @"http://promodj.com/download/2903865/Sac%20Noel%20vs%20DJ.Steel%20%28%20%D0%9A%D0%B5%D0%BC%D0%B5%D1%80%D0%BE%D0%B2%D0%BE%29%20%28promodj.com%29.mp3";
    NSString* song13UrlString = @"http://promodj.com/download/723082/KLUBBDANCE%20DJS%20-%20Poky%20Beats%20%28Original%20Mix%29%20%28promodj.com%29.mp3";
    NSString* song14UrlString = @"http://promodj.com/download/532922/EXIT%20project%20%3A%3A%20Shanti%20Place%20-%20%20%27Opium-v.2%27%20%28promodj.com%29.mp3";
    NSString* song15UrlString = @"http://promodj.com/download/2043067/DJ%20Schmolli%20-%20Rock%20Wit%20The%20Original%20Waterpumpee%20%28Mashup%29%20%28promodj.com%29.mp3";
    NSString* song16UrlString = @"http://promodj.com/download/5019030/Timian%2C%20Rusalina%20feat.%20Syntheticsax%20-%20I%27m%20falling%20for%20you%20%28Original%20mix%29%20%28promodj.com%29.mp3";
    
    self.urlStrings = [[NSArray alloc] initWithObjects:song1UrlString, song2UrlString,song3UrlString, song4UrlString, song5UrlString,song6UrlString, song7UrlString, song8UrlString, song9UrlString, song10UrlString, song11UrlString, song12UrlString, song13UrlString, song14UrlString, song15UrlString, song16UrlString,  nil];
    [self setDownloadsForDownloadManager:_urlStrings];
}

-(void) setDownloadsForDownloadManager:(NSArray*) urlStringsArray {
    self.dowloadManagerCollection = [NSMutableArray new];
    for (NSString* urlString in urlStringsArray) {
        DownloadManager* loadManager = [[DownloadManager alloc] init];
        [self.dowloadManagerCollection addObject:loadManager];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [loadManager bigFileDownloadingAsync:urlString];
        });
        
        
    }

}

-(void) onTick{
    [self.tableView reloadData];
}

-(void) initAndCleanCoreData {
    self.dataManager = [CoraDataManager new];
    [self.dataManager clearCoreData];
}

@end
