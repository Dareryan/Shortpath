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
#import "APIClient.h"
#import "User+Methods.h"

@interface CalendarViewController ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;

@property (strong, nonatomic) APIClient *apiClient;

@property (strong, nonatomic) User *user;

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
    
    self.apiClient = [[APIClient alloc]init];
    

//    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
//    
//    self.user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
//
//    [self.apiClient postEventForUser:self.user WithStartDate:@"04/17/2014" Time:@"17.5" EndDate:@"04/16/2014" Title:@"hello from flatiron app"];

    

    //[self.apiClient postEventForUser:self.user WithStartDate:@"04/15/2014" Time:@"17.5" EndDate:@"04/16/2014" Title:@"hello from flatiron app"];

   
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
    
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    
    
    if ([[self.dataStore.managedObjectContext executeFetchRequest:req error:nil] count]!= 0) {
        self.user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
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
    
    if ([[self.dataStore.managedObjectContext executeFetchRequest:eventsRequest error:nil]count] != 0) {
       
        Event *targetEvent = [self.dataStore.managedObjectContext executeFetchRequest:eventsRequest error:nil][0];
        
        Visitor *david = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:cont];
        david.firstName = @"John";
        
        [targetEvent addVisitorsObject:david];
        
        [self.dataStore saveContext];
    }
   
    
}

-(void)addLocalEventsToAPI
{
    
}

@end
