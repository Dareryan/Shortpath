//
//  EventsTableViewController.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "EventsTableViewController.h"
#import "ShortPathDataStore.h"
#import "Event+Methods.h"

@interface EventsTableViewController ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSArray *eventsForDate;

@end

@implementation EventsTableViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificatonReceived:) name:@"dateNotif" object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
}

- (NSDate *)setTimeToMidnight: (NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    CGFloat shift = interval - 14400;
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:shift];

    return newDate;
}


- (NSDate *)setTimeToEndOfDay: (NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    CGFloat shift = interval + 71999;
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:shift];
    
    return newDate;
}



- (void)notificatonReceived: (NSNotification *)notification
{

    NSDictionary *dict = [notification userInfo];
    
    self.selectedDate = dict[@"date"]; //epoch
    
    NSDate *beginningOfDay = [self setTimeToMidnight:self.selectedDate];
    NSDate *endOfDay = [self setTimeToEndOfDay:self.selectedDate];
 
    NSFetchRequest *eventsRequest = [[NSFetchRequest alloc]initWithEntityName:@"Event"];

    NSPredicate *filter = [NSPredicate predicateWithFormat:@"(start >= %@) AND (start <= %@)", beginningOfDay, endOfDay];
    
    eventsRequest.predicate = filter;
    
    self.eventsForDate = [self.dataStore.managedObjectContext executeFetchRequest:eventsRequest error:nil];
    
    //NSLog(@"Events for this date: %@", self.eventsForDate);
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventsForDate count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Event *currentEvent = self.eventsForDate[indexPath.row];
    
    cell.textLabel.text = currentEvent.title;
    
    return cell;
}


//- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    Event *event = [self.dataStore.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.textLabel.text = event.title;
//}
//
//#pragma mark - NSFetchedResultsControllerDelegate Methods
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView beginUpdates];
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
//           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
//{
//    switch(type) {
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath {
//    
//    UITableView *tableView = self.tableView;
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
//                    atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    [self.tableView endUpdates];
//}



@end
