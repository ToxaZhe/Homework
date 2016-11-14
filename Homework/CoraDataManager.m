//
//  CoraDataManager.m
//  Homework
//
//  Created by user on 11/6/16.
//  Copyright © 2016 Toxa. All rights reserved.
//

#import "CoraDataManager.h"


@implementation CoraDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark: intializing methods for CoreData
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

#pragma mark:Saving enteties toCoreData methods

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

#pragma mark: Clear CoreData Enteties methods
-(void) clearCoreData {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DownloadInfo"];
    NSMutableArray* downloadInfoCollection = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSManagedObject *managedObject in downloadInfoCollection) {
        [_managedObjectContext deleteObject:managedObject];
        
    }
}

#pragma mark: get saved CoreData enteties methods
-(NSMutableArray*) getSavedDowloadInfo {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"DownloadInfo"];
    NSMutableArray* downloadInfoCollection = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    NSMutableArray * dateStrings = [NSMutableArray array];
    [self clearCoreData];
    for (NSManagedObject* downloadDate in downloadInfoCollection) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd.MM.YY HH:mm:ss"];
        NSDate *startedDate = [downloadDate valueForKey:@"startingTime"];
        NSDate *finishedDate = [downloadDate valueForKey:@"finishedTime"];
        NSString* started = [dateFormatter stringFromDate:startedDate];
        NSString* finished = [dateFormatter stringFromDate:finishedDate];
        NSString* loadedFileInfo = [NSString stringWithFormat:@"starting date %@ - finished date %@", started, finished];
        [dateStrings addObject:loadedFileInfo];
    }
    return dateStrings;
}

@end
