//
//  CalendarViewController.m
//  ShortPath
//
//  Created by Dare Ryan on 4/2/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "CalendarViewController.h"
#import <FontAwesomeKit.h>
#import "FISViewController.h"
#import "ShortPathDataStore.h"
#import "Event+Methods.h"
#import "Visitor+Methods.h"

@interface CalendarViewController ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;

@end

@implementation CalendarViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    //[self eventsToCoreData];
    
    //[self addFakeVisitorsToEventForApr13th:self.dataStore.managedObjectContext];
   
}


-(void)viewDidAppear:(BOOL)animated

{

    [super viewDidAppear:animated];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FISViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"logIn"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"key"]) {
        NSLog(@"key found");
        
    } else {
        
        NSLog(@"There is no key");
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }
    
}


-(UITabBarItem *)tabBarItem
{
    FAKIonIcons *tabIconUnselected = [FAKIonIcons ios7CalendarOutlineIconWithSize:30];
    UIImage *tabIconImageUnselected = [tabIconUnselected imageWithSize:CGSizeMake(30,30)];
    
    FAKIonIcons *tabIconSelected = [FAKIonIcons ios7CalendarIconWithSize:30.0f];
    UIImage *tabIconImageSelected = [tabIconSelected imageWithSize:CGSizeMake(30,30)];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Events" image:tabIconImageUnselected selectedImage:tabIconImageSelected];
    
    return tabBarItem;
}


#pragma mark - helpers to populate core data

- (void)eventsToCoreData
{
    __weak typeof(self) weakSelf = self;
    
    [self.dataStore addUserToCoreDataWithCompletion:^(User *user) {
        
        [weakSelf.dataStore addEventsForUser:user ToCoreDataWithCompletion:^(Event *event) {
            
            [user addEventsObject:event];
            
            [weakSelf.dataStore saveContext];
        }];
        
    }];
    
}


- (void)removeEventsFromCoreData
{
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    NSArray *events = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil];
    
    for (NSManagedObject *ev in events) {
        
        [self.dataStore.managedObjectContext deleteObject:ev];
        [self.dataStore saveContext];
    }
    
}

- (void)addFakeVisitorsToEventForApr13th: (NSManagedObjectContext *)cont
{
    NSFetchRequest *eventsRequest = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"identifier==%@", @"593716"];
    
    eventsRequest.predicate = filter;
    
    Event *targetEvent = [self.dataStore.managedObjectContext executeFetchRequest:eventsRequest error:nil][0];
    
    Visitor *david = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:cont];
    david.firstName = @"John";
    
    [targetEvent addVisitorsObject:david];
    
    [self.dataStore saveContext];
    
}

-(void)addLocalEventsToAPI
{
    
}



@end
