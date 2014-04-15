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
#import "EventDetailTableViewController.h"

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
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
  
}


 - (NSArray *) returnStartAndEndOfGivenDate:(NSDate *)date

{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    
    NSDate *startDate = [calendar dateFromComponents:dateComponents];
    
    dateComponents.hour = 24;
    
    NSDate *endDate = [calendar dateFromComponents:dateComponents];
    
    NSArray *dates = @[startDate, endDate];
    
    return dates;
}


- (void)notificatonReceived: (NSNotification *)notification
{

    NSDictionary *dict = [notification userInfo];
    
    self.selectedDate = dict[@"date"]; //epoch
    
    NSArray *startAndEnd = [self returnStartAndEndOfGivenDate:self.selectedDate];
    
    NSDate *beginningOfDay = startAndEnd[0];
    
    NSDate *endOfDay = startAndEnd[1];
 
    NSFetchRequest *eventsRequest = [[NSFetchRequest alloc]initWithEntityName:@"Event"];

    NSPredicate *filter = [NSPredicate predicateWithFormat:@"(start >= %@) AND (start < %@)", beginningOfDay, endOfDay];
    
    eventsRequest.predicate = filter;
    
    self.eventsForDate = [self.dataStore.managedObjectContext executeFetchRequest:eventsRequest error:nil];
    
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"h:mm a"];
    
    cell.detailTextLabel.text = [dateFormatter stringFromDate:currentEvent.start];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    
    Event *event = self.eventsForDate[ip.row];
    
    EventDetailTableViewController *eventDetailVC = [segue destinationViewController];
    
    eventDetailVC.event = event;
    
}



@end
