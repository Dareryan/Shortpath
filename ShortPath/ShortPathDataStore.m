//
//  ShortPathDataStore.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "ShortPathDataStore.h"
#import "Event+Methods.h"
#import "APIClient.h"


@interface ShortPathDataStore ()

@property (strong, nonatomic) NSArray *eventDicts;
@property (strong, nonatomic) NSArray *visitors;
@property (strong, nonatomic) APIClient *apiClient;

@end

@implementation ShortPathDataStore

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+(ShortPathDataStore*) sharedDataStore
{
    static ShortPathDataStore *_sharedDataStore = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedDataStore = [[self alloc] init];
    });
    
    return _sharedDataStore;
}


- (id)init
{
    self = [super init];
    if (self) {
        
        _apiClient = [[APIClient alloc]init];
    }
    return self;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - API to Core Data methods

- (void)addUserToCoreDataWithCompletion: (void(^)(User *))completionBlock
{
    
    [self.apiClient fetchUserInfoWithCompletion:^(NSDictionary *userDict) {
        
        User *newUser = [User getUserFromDict:userDict ToContext:self.managedObjectContext];
        
        //NSLog(@"%@", newUser.username);
        
        completionBlock(newUser);
    }];
}


- (void)addEventsForUser: (User *)user ToCoreDataWithCompletion: (void(^)(Event *))completionBlock
{
    [self.apiClient fetchEventsForUser:user Completion:^(NSArray *eventDicts) {
        
        for (NSDictionary *eventDict in eventDicts) {
            
            Event *newEvent = [Event getEventFromDict:eventDict ToContext:self.managedObjectContext];
            
            [user addEventsObject:newEvent];
            
            completionBlock(newEvent);
        }
    }];
}





#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShortPath" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ShortPath.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSInteger)numberOfVisitors
{
    return [self.visitors count];
}

- (void)fetchVisitors
{
    NSFetchRequest *visitorsFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Visitor"];
    
    self.visitors = [self.managedObjectContext executeFetchRequest:visitorsFetchRequest error:nil];
}

@end
