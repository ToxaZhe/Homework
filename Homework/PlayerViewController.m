//
//  PlayerViewController.m
//  Homework
//
//  Created by user on 11/13/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import "PlayerViewController.h"
#import "DownloadManager.h"
@import  AVFoundation;

@interface PlayerViewController ()
@property(nonatomic,strong) AVAudioPlayer* musicPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@end

@implementation PlayerViewController


- (NSURL *)documentsDirectoryUrl {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


# pragma mark: self ViewController native methods method

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController* nav = [UINavigationController new];
    [nav setNavigationBarHidden:NO animated:NO];
    [self initPlayerWithData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _songNameLabel.text = _fileName;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.musicPlayer = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark: Methods to handle with AVAudioPlayer

-(void) initPlayerWithData {
    NSError* error;
    NSURL *url = [NSURL URLWithString:_mp3Url];
    
    self.fileName = [url pathComponents].lastObject;
    NSURL *documentsURL = [self documentsDirectoryUrl];
    NSString *fullFileName = [NSString stringWithFormat:@"%@/%@.mp3", documentsURL.path, _fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullFileName]) {
        self.mp3File = [NSData dataWithContentsOfFile:fullFileName];
        self.musicPlayer = [[AVAudioPlayer alloc] initWithData:_mp3File error:&error];
        [self.musicPlayer prepareToPlay];
        self.musicPlayer.numberOfLoops = -1;
    }
    
}


-(void) playPausePlayer {
    if (_musicPlayer.playing) {
        NSString *play = [NSString stringWithFormat:@"Play"];
        [_playButton setTitle:play forState:0];
        [self.musicPlayer pause];
    } else {
        NSString *pause = [NSString stringWithFormat:@"Pause"];
        [_playButton setTitle:pause forState:0];
        [self.musicPlayer play];
    }

}

- (IBAction)PlayBtnAction:(UIButton *)sender {
    [self playPausePlayer];
    }



@end
