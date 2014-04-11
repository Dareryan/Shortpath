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
#import "Visitor.h"

@interface VisitorsVC ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *visitors;
@property (strong, nonatomic) NSArray *letters;

@property (strong, nonatomic) NSMutableDictionary *sections;

@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) NSFetchedResultsController *

- (IBAction)addNewVisitor:(id)sender;


@end

#pragma mark -

@implementation VisitorsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Lifecycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    [self.dataStore fetchedResultsController];
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.visitors count]];
    
    self.sections = [[NSMutableDictionary alloc] init];
    self.letters = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    
    BOOL found;
    
    // Loop through visitors and create keys
    for (NSDictionary *visitor in self.visitors) {
        NSString *c = [[visitor objectForKey:@"firstName"] substringToIndex:1];
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
    for (NSDictionary *visitor in self.visitors) {
        [[self.sections objectForKey:[[visitor objectForKey:@"firstName"] substringToIndex:1]] addObject:visitor];
    }
    
    // Sort each section array
    for (NSString *key in [self.sections allKeys]) {
        [[self.sections objectForKey:key] sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES]]];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    }
    else {
//        return [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
        return [self.dataStore numberOfVisitors];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letters;
    //    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"visitorCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    // Configure the cell...
    Visitor *visitor;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        visitor = [self.searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = @"result";
    }
    else {
        NSDictionary *visitor = [[self.sections valueForKey:[[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        cell.textLabel.text = [visitor objectForKey:@"firstName"];
    }
    
    //    cell.detailTextLabel.text = @"testDetail";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Content Filtering

- (void)updateFilteredContentForSearchString:(NSString *)searchString productType:(NSString *)type
{
    // start out with the entire list
    self.searchResults = [self.visitors mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedStr = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedStr.length > 0)
    {
        searchItems = [strippedStr componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems)
    {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = (NSCompoundPredicate *)[NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    NSCompoundPredicate *finalCompoundPredicate = nil;
    
    if (type != nil)
    {
        // we have a scope type to narrow our search further
        //
        if (andMatchPredicates.count > 0)
        {
            // we have a scope type and other fields to search on -
            // so match up the fields of the Product object AND its product type
            //
            NSCompoundPredicate *compPredicate1 =
            (NSCompoundPredicate *)[NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
            NSPredicate *compPredicate2 = [NSPredicate predicateWithFormat:@"(SELF.type == %@)", type];
            
            finalCompoundPredicate =
            (NSCompoundPredicate *)[NSCompoundPredicate andPredicateWithSubpredicates:@[compPredicate1, compPredicate2]];
        }
        else
        {
            // match up by product scope type only
            finalCompoundPredicate =
            (NSCompoundPredicate *)[NSPredicate predicateWithFormat:@"(SELF.type == %@)", type];
        }
    }
    else
    {
        // no scope type specified, just match up the fields of the Product object
        finalCompoundPredicate =
        (NSCompoundPredicate *)[NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    }
    
    self.searchResults = [[self.searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
}

#pragma mark - State restoration

// Note:
// UITableView itself supports current scroll position and selected row if its data source
// supports UIDataSourceModeAssociation protocol.
//
// To make things simpler here, we choose to manually preserve/restore the table view selection
// and not support scroll position.

static NSString *SearchDisplayControllerIsActiveKey = @"SearchDisplayControllerIsActiveKey";
static NSString *SearchBarScopeIndexKey = @"SearchBarScopeIndexKey";
static NSString *SearchBarTextKey = @"SearchBarTextKey";
static NSString *SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

static NSString *SearchDisplayControllerSelectedRowKey = @"SearchDisplayControllerSelectedRowKey";
static NSString *TableViewSelectedRowKey = @"TableViewSelectedRowKey";


- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super encodeRestorableStateWithCoder:coder];
    
    UISearchDisplayController *searchDisplayController = self.searchDisplayController;
    
    BOOL searchDisplayControllerIsActive = [searchDisplayController isActive];
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchDisplayControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive)
    {
        [coder encodeObject:[searchDisplayController.searchBar text] forKey:SearchBarTextKey];
        [coder encodeInteger:[searchDisplayController.searchBar selectedScopeButtonIndex] forKey:SearchBarScopeIndexKey];
        
        NSIndexPath *selectedIndexPath = [searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        if (selectedIndexPath != nil)
        {
            [coder encodeObject:selectedIndexPath forKey:SearchDisplayControllerSelectedRowKey];
        }
        
        BOOL searchFieldIsFirstResponder = [searchDisplayController.searchBar isFirstResponder];
        [coder encodeBool:searchFieldIsFirstResponder forKey:SearchBarIsFirstResponderKey];
    }
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath != nil)
    {
        [coder encodeObject:selectedIndexPath forKey:TableViewSelectedRowKey];
    }
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    [super decodeRestorableStateWithCoder:coder];
    
    BOOL searchDisplayControllerIsActive = [coder decodeBoolForKey:SearchDisplayControllerIsActiveKey];
    
    if (searchDisplayControllerIsActive)
    {
        [self.searchDisplayController setActive:YES];
        
        // order is important here. Setting the search bar text causes
        // searchDisplayController:shouldReloadTableForSearchString: to be invoked.
        //
        NSInteger searchBarScopeIndex = [coder decodeIntegerForKey:SearchBarScopeIndexKey];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:searchBarScopeIndex];
        
        NSString *searchBarText = [coder decodeObjectForKey:SearchBarTextKey];
        if (searchBarText != nil)
        {
            [self.searchDisplayController.searchBar setText:searchBarText];
        }
        
        NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:SearchDisplayControllerSelectedRowKey];
        if (selectedIndexPath != nil)
        {
            [self.searchDisplayController.searchResultsTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        BOOL searchFieldIsFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
        if (searchFieldIsFirstResponder)
        {
            [self.searchDisplayController.searchBar becomeFirstResponder];
        }
    }
    
    NSIndexPath *selectedIndexPath = [coder decodeObjectForKey:TableViewSelectedRowKey];
    if (selectedIndexPath != nil)
    {
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
}

//- (IBAction)addNewVisitor:(id)sender {
//    UIActionSheet *newVisitorAS = [[UIActionSheet alloc] initWithTitle:@"Assign to" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Event", @"Existing Event", nil];
//    
//    [newVisitorAS showInView:self.view];
//}

@end
