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
#import "APIClient.h"

@interface EventInviteesTableViewController ()

@property (strong, nonatomic) NSMutableArray *visitors;

@property (strong, nonatomic) ShortPathDataStore *dataStore;

@property (strong, nonatomic) APIClient *apiClient;

@property (strong, nonatomic) NSString *visitorIDString;

@end

@implementation EventInviteesTableViewController



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    self.apiClient = [[APIClient alloc]init];
    
    NSMutableArray *visitorIds = [NSMutableArray new];
    
    self.visitors = [NSMutableArray new];
    
    [self.apiClient fetchVisitorsForEvent:self.event ForUser:self.event.user Completion:^(NSArray *userDicts) {
        
        for (NSDictionary *dict in userDicts) {
            
            NSString *visitorId = [NSString stringWithFormat:@"%@", dict[@"event_guest"][@"contact"][@"id"]];
            
            [visitorIds addObject:visitorId];
        }
        
        for (NSString *visitorId in visitorIds) {
            
            NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Visitor"];
            
            NSPredicate *filter = [NSPredicate predicateWithFormat:@"identifier=%@", visitorId];
            
            request.predicate = filter;
            
            Visitor *visitor = [self.dataStore.managedObjectContext executeFetchRequest:request error:nil][0];
            
            [self.visitors addObject:visitor];
            
            
            
        }
        
        [self.tableView reloadData];
        //NSMutableString *visitorIDString = [[NSMutableString alloc]init];
        NSMutableArray *visitorIDArray = [[NSMutableArray alloc]init];
        for (Visitor *visitor in self.visitors) {
            [visitorIDArray addObject: visitor.identifier];
        }
        self.visitorIDString = [visitorIDArray componentsJoinedByString:@","];
        
    } Failure:^(NSInteger errorCode) {
        
        [self.apiClient handleError:errorCode InViewController:self];
    }];

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
    visitorsVC.visitorIDString = self.visitorIDString;
}



@end
