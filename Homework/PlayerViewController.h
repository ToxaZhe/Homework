//
//  PlayerViewController.h
//  Homework
//
//  Created by user on 11/13/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import "ViewController.h"

@interface PlayerViewController : ViewController
@property(strong,nonatomic) NSString* mp3Url;
@property(nonatomic,strong) NSData* mp3File;
@property(nonatomic,strong)NSString* fileName;
@end
