//
//  CoraDataManager.h
//  Homework
//
//  Created by user on 11/6/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoraDataManager : NSObject
-(NSMutableArray*) getSavedDowloadInfo;
-(void) saveDownloadStartDate: (NSDate*)startDate andEndDate: (NSDate*)endDate;

@end
