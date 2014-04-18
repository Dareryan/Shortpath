//
//  ShortPathDataStore.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Visitor+Methods.h"
#import "User+Methods.h"
#import "Location+Methods.h"

@interface ShortPathDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)addUserToCoreDataWithCompletion: (void(^)(User *))completionBlock Failure: (void(^)(NSInteger))failureBlock;
- (void)addEventsForUser: (User *)user ToCoreDataWithCompletion: (void(^)())completionBlock Failure: (void(^)(NSInteger))failureBlock;
- (void)addLocationsToCoreDataForUser: (User *)user Completion: (void(^)(Location *))completionBlock Failure: (void(^)(NSInteger))failureBlock;
- (void)addVisitorsForUser: (User *)user Completion: (void(^)(BOOL))completionBlock Failure: (void(^)(NSInteger))failureBlock;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+(ShortPathDataStore*) sharedDataStore;


- (NSInteger)numberOfVisitors;
- (void)fetchVisitors;

@end
