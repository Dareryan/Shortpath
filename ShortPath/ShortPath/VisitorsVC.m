//
//  VisitorsVC.m
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-04.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "VisitorsVC.h"
#import <FontAwesomeKit.h>
#import "ShortPathDataStore.h"
#import "Visitor+Methods.h"
#import "AddNewEventVC.h"
#import "FISViewController.h"
#import "CreateEventForNewVisitorTVC.h"
#import "CreateEventForExistingVisitorTVC.h"

@interface VisitorsVC ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;


@property (strong, nonatomic) NSArray *visitors;
@property (strong, nonatomic) NSArray *letters;

@property (strong, nonatomic) NSMutableDictionary *sections;//of section letter to visiotrs array

@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UISearchDisplayController *searchController;

- (IBAction)cancelButtonPressed:(id)sender;



@end



@implementation VisitorsVC

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"Visitor"];
    
    self.visitors = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.visitors count]];
    
    self.sections = [[NSMutableDictionary alloc] init];
    
    //self.letters = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    [self createSectionToVisitorsDictionary];


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
    FAKIonIcons *tabIconUnselected = [FAKIonIcons ios7PeopleOutlineIconWithSize:30.0f];
    UIImage *tabIconImageUnselected = [tabIconUnselected imageWithSize:CGSizeMake(30,30)];
    
    FAKIonIcons *tabIconSelected = [FAKIonIcons ios7PeopleIconWithSize:30.0f];
    UIImage *tabIconImageSelected = [tabIconSelected imageWithSize:CGSizeMake(30,30)];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Visitors" image:tabIconImageUnselected selectedImage:tabIconImageSelected];
    
    return tabBarItem;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        return 1;
        
    } else {
        
        return [[self.sections allKeys] count];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if  (tableView == self.searchDisplayController.searchResultsTableView){
        return nil;
    }
    
    else{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    return [self.searchResults count];
    } else {
    return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    }
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return self.letters;
//    //    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"visitorCell"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"visitorCell"];
    }
    
    Visitor *visitor;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        if ([self.searchResults count] != 0){
        visitor = [self.searchResults objectAtIndex:indexPath.row];
        }
        
    } else {
        
       visitor = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",visitor.firstName, visitor.lastName];
    cell.detailTextLabel.text = visitor.email;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"firstName contains[c] %@", searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.visitors filteredArrayUsingPredicate:resultPredicate]];

}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //NSLog(@"Letter %@", searchString);
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    //NSLog(@"Results %@", self.searchResults);
    
    return YES;
}



#pragma mark - map sections to visitors

- (void)createSectionToVisitorsDictionary
{
    BOOL found;
    // Loop through visitors and create keys
    
    for (Visitor *visitor in self.visitors) {
        
        NSString *c = [visitor.firstName substringToIndex:1];
        found = NO;
        
        for (NSString *str in [self.sections allKeys]) {
            
            if ([str isEqualToString:c]) {
                found = YES;
            }
        }
        if (!found) {
            
            [self.sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    
    // Loop again and sort visitors into their respective keys
    for (Visitor *visitor in self.visitors) {
        
        NSString *visitorName = [visitor.firstName substringToIndex:1];
        
        [[self.sections objectForKey:visitorName] addObject:visitor];
        
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys]) {
        
        [[self.sections objectForKey:key] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Add code to add visitor to event
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fromVisitor"]) {
        CreateEventForExistingVisitorTVC *existingVC = [segue destinationViewController];
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        Visitor *visitor = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:ip.section]] objectAtIndex:ip.row];
        
        existingVC.visitor = visitor;        
    }
}


- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
