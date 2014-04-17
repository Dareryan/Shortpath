//
//  EventInviteesTableViewController.m
//  ShortPath
//
//  Created by Dare Ryan on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "EventInviteesTableViewController.h"
#import "ShortPathDataStore.h"
#import "Event+Methods.h"
#import "Visitor+Methods.h"
#import "VisitorsVC.h"

@interface EventInviteesTableViewController ()

@property (strong, nonatomic) NSArray *visitors;

@property (strong, nonatomic) ShortPathDataStore *dataStore;

@end

@implementation EventInviteesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    
    
    [self getVisitorsForEvent:self.event];
    
}

//here goes API call????
- (void)getVisitorsForEvent: (Event *)event
{
    NSFetchRequest *eventsRequest = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"identifier=%@", event.identifier];
    
    eventsRequest.predicate = filter;
    
    Event *currentEvent = [self.dataStore.managedObjectContext executeFetchRequest:eventsRequest error:nil][0];
    
    self.visitors = [currentEvent.visitors allObjects];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.visitors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Visitor *visitor = self.visitors[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",visitor.firstName, visitor.lastName];
    cell.detailTextLabel.text = visitor.email;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VisitorsVC *visitorsVC = ((VisitorsVC *)[[segue destinationViewController] topViewController]);
    
    visitorsVC.event = self.event;
}



@end
