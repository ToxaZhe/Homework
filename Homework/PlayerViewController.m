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

@end

@implementation PlayerViewController


- (NSURL *)documentsDirectoryUrl {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController* nav = [UINavigationController new];
    [nav setNavigationBarHidden:NO animated:NO];
    NSError* error;
    NSURL *url = [NSURL URLWithString:_mp3Url];
    
    NSString *fileName = [url pathComponents].lastObject;
    NSURL *documentsURL = [self documentsDirectoryUrl];
    NSString *fullFileName = [NSString stringWithFormat:@"%@/%@", documentsURL.path, fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullFileName]) {
        NSData* mp3Data = [NSData dataWithContentsOfFile:fullFileName];
        self.musicPlayer = [[AVAudioPlayer alloc] initWithData:mp3Data error:&error];
        [self.musicPlayer prepareToPlay];
        self.musicPlayer.numberOfLoops = -1;
    }
    
//    self.musicPlayer = [[AVAudioPlayer alloc] initWithData:_mp3File error:&error];
//    [self.musicPlayer prepareToPlay];
//    self.musicPlayer.numberOfLoops = -1;
    
}

-(void) playSongAgain {
    [self.musicPlayer play];
}

- (IBAction)PlayBtnAction:(UIButton *)sender {
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.musicPlayer = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
