//
//  DataTableViewCell.h
//  Homework
//
//  Created by user on 11/5/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *progresLabel;
- (IBAction)startPauseDowloading:(UIButton *)sender;

@property (nonatomic, copy) void (^beginDowload)(void);

@end
