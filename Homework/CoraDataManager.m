//
//  CoraDataManager.m
//  Homework
//
//  Created by user on 11/6/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import "CoraDataManager.h"

@interface CoraDataManager()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSURL *)applicationsDocumentsDirectory;

@end


@implementation CoraDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil){
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Homework" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if(_persistentStoreCoordinator != nil){
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationsDocumentsDirectory] URLByAppendingPathComponent:@"Homework.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    if(_managedObjectContext != nil){
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if(coordinator != nil){
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

- (NSURL *)applicationsDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void) saveDownloadStartDate: (NSDate*)startDate andEndDate: (NSDate*)endDate{
    NSManagedObjectContext *context = [self managedObjectContext];
    
  
    NSManagedObject *newDownload = [NSEntityDescription insertNewObjectForEntityForName:@"DownloadInfo" inManagedObjectContext:context];
    [newDownload setValue:startDate forKey:@"startingTime"];
    [newDownload setValue:endDate forKey:@"finishedTime"];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

-(NSMutableArray*) getSavedDowloadInfo {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DownloadInfo"];
    NSMutableArray* downloadInfoCollection = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSMutableArray * dateStrings = [NSMutableArray array];
    for (NSManagedObject* downloadDate in downloadInfoCollection) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
        NSDate *startedDate = [downloadDate valueForKey:@"startingTime"];
        NSDate *finishedDate = [downloadDate valueForKey:@"finishedTime"];
        NSString* started = [dateFormatter stringFromDate:startedDate];
        NSString* finished = [dateFormatter stringFromDate:finishedDate];
        NSString* loadedFileInfo = [NSString stringWithFormat:@"starting date %@ - finished date %@", started, finished];
        [dateStrings removeAllObjects];
        [dateStrings addObject:loadedFileInfo];
    }
    return dateStrings;
}

@end
