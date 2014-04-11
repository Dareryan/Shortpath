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

@interface VisitorsVC ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;


@property (strong, nonatomic) NSArray *visitors;
@property (strong, nonatomic) NSArray *letters;

@property (strong, nonatomic) NSMutableDictionary *sections;//of section letter to visiotrs array

@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchController;




@end



@implementation VisitorsVC

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self setupSearch];
    
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

- (void)setupSearch {
    
    // create a new Search Bar and add it to the table view
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    self.tableView.tableHeaderView = self.searchBar;
    
    // we need to be the delegate so the cancel button works
    self.searchBar.delegate = self;
    
    // create the Search Display Controller with the above Search Bar
    self.searchController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
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
    NSInteger number = 0;
    
    if (tableView == self.tableView) {
        
        number = [[self.sections allKeys] count];
    }
    return number;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.searchDisplayController.active) {
        
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"visitorCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"visitorCell"];
    }
    

    Visitor *visitor;
    
    if (self.searchDisplayController.active) {
        
        visitor = [self.searchResults objectAtIndex:indexPath.row];
        
        cell.textLabel.text = @"result";
        
    } else {
        
       visitor = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = visitor.firstName;
    }
    
    //    cell.detailTextLabel.text = @"testDetail";
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


@end
