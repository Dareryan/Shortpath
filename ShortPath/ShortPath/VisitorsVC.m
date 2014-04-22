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
#import "APIClient.h"
#import "User+Methods.h"
#import "AddNewVisitorVC.h"



@interface VisitorsVC ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;


@property (strong, nonatomic) NSArray *visitors;
@property (strong, nonatomic) NSArray *letters;

@property (strong, nonatomic) NSMutableDictionary *sections;//of section letter to visiotrs array

@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UISearchDisplayController *searchController;
@property (strong, nonatomic) APIClient *apiClient;
@property (strong, nonatomic) Visitor *selectedVisitor;




- (IBAction)cancelButtonPressed:(id)sender;



@end



@implementation VisitorsVC

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view
//    [self.tableView setBackgroundView:nil];
//    UIView *tableBG = [[UIView alloc]init];
//    [tableBG setBackgroundColor:[UIColor redColor]];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.024 green:0.439 blue:0.659 alpha:1.0]];
    
    
    
    self.apiClient = [[APIClient alloc]init];
    
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
    [tableView setBackgroundColor:[UIColor colorWithRed:0.024 green:0.439 blue:0.659 alpha:1.0]];
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
    
    if ([visitor.firstName isEqualToString:@""]) {
        cell.textLabel.text = visitor.lastName;
    } else {
    
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", visitor.firstName, visitor.lastName];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = [UIColor colorWithRed:0.024 green:0.439 blue:0.659 alpha:0.2];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    return cell;
}


#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"firstName contains[c] %@", searchText];
    NSPredicate *lastNameResultPredicate = [NSPredicate predicateWithFormat:@"lastName contains[c] %@", searchText];
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[resultPredicate, lastNameResultPredicate]];
    
    self.searchResults = [NSMutableArray arrayWithArray:[self.visitors filteredArrayUsingPredicate:compoundPredicate]];

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
    
    NSMutableArray *noLastNameVisitors = [NSMutableArray new];
    
    NSMutableArray *mutableVisitors = [self.visitors mutableCopy];
    
    for (Visitor *visitor in self.visitors) {

        NSString *c = [visitor.lastName substringToIndex:1];
        c = [c capitalizedString];
        
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
        
        NSString *visitorName = [visitor.lastName substringToIndex:1];
        visitorName = [visitorName capitalizedString];
       
        [[self.sections objectForKey:visitorName] addObject:visitor];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys]) {

        [[self.sections objectForKey:key] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES],]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *startDate = [Event dateStringFromDate:self.event.start];
    NSString *time = [Event timeStringFromDate:self.event.start];
    
    if (buttonIndex == 1) {
        
        [self.apiClient postEventForUser:self.event.user WithStartDate:startDate Time:time Title:self.event.title Location:self.location Visitor:self.selectedVisitor Completion:^{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postRequestComplete" object:nil];
            
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } Failure:^(NSInteger errorCode) {
            
            [self.apiClient handleError:errorCode InViewController:self];
            
            NSLog(@"Error adding visitor from existing visitors: %d", errorCode);
        }];
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Visitor *visitor;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        if ([self.searchResults count] != 0){
            
            visitor = [self.searchResults objectAtIndex:indexPath.row];
        }
        
    } else {
        
        visitor = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    }
    
    
    [self.event addVisitorsObject:visitor];
    
    if (self.navigationController.viewControllers[0] == self) {
        
       // [self.navigationController popViewControllerAnimated:YES];
        
        
    } else {
        
        self.selectedVisitor = self.visitors[indexPath.row];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Add event?" message:@"Would you like to create an event with this visitor?" delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
        
        [alertView show];
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"fromVisitor"]) {
        
        CreateEventForExistingVisitorTVC *existingVC = [segue destinationViewController];
        
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        
        if (self.searchDisplayController.isActive) {
            
            Visitor *visitor = [self.searchResults objectAtIndex:ip.row];
            
            existingVC.visitor = visitor;

        } else {
            
            Visitor *visitor = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:ip.section]] objectAtIndex:ip.row];
            
            existingVC.visitor = visitor;

        }

        
    } else if ([segue.identifier isEqualToString:@"addNewVisitor"]) {
        
        UINavigationController *navController = [segue destinationViewController];
        
        AddNewVisitorVC *addNewVisitor = navController.viewControllers[0];
        
        addNewVisitor.event = self.event;
        addNewVisitor.location = self.location;
        
    }
}


- (IBAction)cancelButtonPressed:(id)sender {
    
    if (self.navigationController.viewControllers[0] == self) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
