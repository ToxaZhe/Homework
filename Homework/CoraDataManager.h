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

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationsDocumentsDirectory;
-(NSMutableArray*) getSavedDowloadInfo;
-(void) saveDownloadStartDate: (NSDate*)startDate andEndDate: (NSDate*)endDate;
-(void) clearCoreData;
@end
