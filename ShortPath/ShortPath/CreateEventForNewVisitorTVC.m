//
//  CreateEventForNewVisitorTVC.m
//  ShortPath
//
//  Created by Dare Ryan on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <AFNetworking.h>
#import "CreateEventForNewVisitorTVC.h"
#import "Visitor+Methods.h"
#import "ShortPathDataStore.h"
#import "Event+Methods.h"
#import "User+Methods.h"
#import "FISViewController.h"
#import "APIClient.h"
#import "Location+Methods.h"


@interface CreateEventForNewVisitorTVC ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDateCell;
@property (nonatomic) BOOL isEditingStartDate;
@property (nonatomic) BOOL isEditingEndDate;
@property (nonatomic) BOOL isEditingLocation;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (readonly, nonatomic, assign) BOOL reachable;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (strong, nonatomic) APIClient *apiClient;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) NSArray *hours;
@property (strong, nonatomic) NSArray *minutes;
@property (nonatomic) NSInteger eventDurationInSeconds;
@property (strong, nonatomic) Visitor *visitor;

- (IBAction)startDateDidChange:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@property (strong, nonatomic) ShortPathDataStore *dataStore;

@end

@implementation CreateEventForNewVisitorTVC


- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        [_manager.requestSerializer setValue:@"Bearer qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" forHTTPHeaderField:@"Authorization"];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates=YES;
        _manager.securityPolicy=securityPolicy;
    }
    return _manager;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hours = @[@"Hours", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    self.minutes = @[@"Minutes", @"0", @"30"];
    
   
    
    
    self.apiClient = [[APIClient alloc]init];
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        NSLog(@"IS REACHABILE");
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Connected" message:@"Please check your connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        //NSLog(@"NOT REACHABLE");
    }
    
    UITapGestureRecognizer *locationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    locationGestureRecognizer.delegate = self;
    locationGestureRecognizer.cancelsTouchesInView = NO;
    [self.locationPicker addGestureRecognizer:locationGestureRecognizer];
    
    UITapGestureRecognizer *durationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    durationGestureRecognizer.delegate = self;
    durationGestureRecognizer.cancelsTouchesInView = NO;
    [self.durationPicker addGestureRecognizer:durationGestureRecognizer];

    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    self.user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
    
    NSFetchRequest *locRequest = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
    self.locations = [self.dataStore.managedObjectContext executeFetchRequest:locRequest error:nil];
    
    //NSLog(@"Locations: %@", self.locations);
    
    self.isEditingStartDate = NO;
    self.isEditingEndDate = NO;
    self.isEditingLocation = NO;
    [self.startDatePicker setHidden:YES];
    [self.durationPicker setHidden:YES];
    [self.locationPicker setHidden:YES];
    self.locationPicker.dataSource = self;
    self.locationPicker.delegate = self;
    self.durationPicker.delegate = self;
    self.durationPicker.dataSource = self;
    self.startDateCell.textLabel.text = @"Arrival";
    self.endDateCell.textLabel.text = @"Duration";
    //self.locationCell.textLabel.text = @"Location";
    
    
    [self.locationPicker selectRow:0 inComponent:0 animated:NO];
    self.selectedLocation = [self.locations objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
    self.locationCell.textLabel.text = self.selectedLocation.title;
    

//    NSString *urlString = @"https://core.staging.shortpath.net/api/users/me.json";
//    
//    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSDictionary *dict = responseObject[@"user"];
//        //completionBlock(dict);
//        NSLog(@"%@", dict);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Error Code %long",  error.code);
//    }];

//    NSString *urlString = @"https://core.staging.shortpath.net/api/users/me.json";
//    
//    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSDictionary *dict = responseObject[@"user"];
//        //completionBlock(dict);
//        NSLog(@"%@", dict);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        NSLog(@"Error Code %long",  error.code);
//        
//    }];

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    

    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *startIP = [NSIndexPath indexPathForRow:1 inSection:5];
    NSIndexPath *endIP = [NSIndexPath indexPathForRow:1 inSection:6];
    NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:7];
    if(indexPath.section==5 && indexPath.row == 0)
    {
        self.isEditingStartDate = !self.isEditingStartDate;
        self.isEditingEndDate = NO;
        self.isEditingLocation = NO;
        
        if (self.isEditingStartDate) {
            [self.startDatePicker setHidden:NO];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[startIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:startIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if (indexPath.section == 6 && indexPath.row == 0) {
        self.isEditingEndDate = !self.isEditingEndDate;
        self.isEditingStartDate = NO;
        self.isEditingLocation = NO;
        
        if (self.isEditingEndDate){
            [self.durationPicker setHidden:NO];
        }
        [self.tableView reloadRowsAtIndexPaths:@[endIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:endIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if (indexPath.section == 7 && indexPath.row ==0) {
        self.isEditingLocation = !self.isEditingLocation;
        self.isEditingStartDate = NO;
        self.isEditingEndDate = NO;
        
        if (self.isEditingLocation) {
            [self.locationPicker setHidden:NO];
        }
        [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:locIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else{
        if (!(indexPath.section == 5 && indexPath.row ==1)){
            self.isEditingStartDate = NO;
            [self.tableView reloadRowsAtIndexPaths:@[startIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
        }
        if (!(indexPath.section == 6 && indexPath.row ==1)) {
            self.isEditingEndDate = NO;
            [self.tableView reloadRowsAtIndexPaths:@[endIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
        }
        if (!(indexPath.section == 7 && indexPath.row ==1)) {
            self.isEditingLocation = NO;
            [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section ==5 && indexPath.row ==1) {
        if (self.isEditingStartDate){
            return 225.0;
        }else{
            return 0.0;
        }
    }
    if (indexPath.section ==6 && indexPath.row == 1) {
        if (self.isEditingEndDate) {
            return 225.0;
        }
        else{
            return 0;
        }
    }
    if (indexPath.section == 7 && indexPath.row == 1) {
        if (self.isEditingLocation) {
            return 225.0;
        }
        else{
            return 0;
        }
    }
    return self.tableView.rowHeight;
}


- (IBAction)startDateDidChange:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create an event for this visitor, the visitor must have a first name, last name, location and valid departure date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([self.firstNameTextField.text isEqualToString:@""] || [self.lastNameTextField.text isEqualToString:@""] || self.eventDurationInSeconds == 0 || self.selectedLocation == nil) {
        
        [alertView show];
        
    } else if(![self.firstNameTextField.text isEqualToString:@""] && ![self.lastNameTextField.text isEqualToString:@""] && self.eventDurationInSeconds != 0 && self.selectedLocation != nil) {
        
        /*
         Add code to insert event and visitor object into coredata. Event title should be set to [NSString stringWithFormat:@"%@ %@ visits", self.firstNameTextField.text, self.lastNameTextField.text];
         */
        
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"key"]) {
                
                [self postNewVisitorEventToServer];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                //CONTINUE POST
                
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Application is not authorized" message:@"Please re-log in to retrieve a new access key" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Authorize",nil];
                [alertView show];
                //[self writeNewVisitorEventToCoreData];
                
                //STORE TO CORE DATA
                //GO TO AUTH HOME SCREEN
            }
            
            
            
            //[self writeNewVisitorEventToCoreData];
            
            NSLog(@"IS REACHABLE");
            
        } else {
            
            UIAlertView *alertConnect = [[UIAlertView alloc] initWithTitle:@"Not Connected" message:@"Please check your connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertConnect show];
            
        }
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"pressed No");
    }
    else {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FISViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"logIn"];
        [self presentViewController:loginVC animated:YES completion:nil];
        self.tabBarController.navigationController.viewControllers = @[loginVC];
        [self.tabBarController.navigationController pushViewController:loginVC animated:YES];

    }
}


- (void)createNewVisitorForEvent
{
    self.visitor = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:self.dataStore.managedObjectContext];
    self.visitor.firstName = self.firstNameTextField.text;
    self.visitor.lastName = self.lastNameTextField.text;
    self.visitor.company = self.companyTextField.text;
    self.visitor.phone = self.phoneNumberTextField.text;
    self.visitor.email = self.emailTextField.text;
    
    //[self.event addVisitorsObject:self.visitor];
    
    //[self.dataStore saveContext];
}


//api call POST event

-(void)postNewVisitorEventToServer
{
    [self createNewVisitorForEvent];
    
    NSString *startDate = [Event dateStringFromDate:self.startDatePicker.date];
    NSString *time = [Event timeStringFromDate:self.startDatePicker.date];
    NSString *title = [NSString stringWithFormat:@"Meeting with: %@ %@", self.firstNameTextField.text, self.lastNameTextField.text];
    
    [self.apiClient postEventForUser:self.user WithStartDate:startDate Time:time Title:title Location:self.selectedLocation VisitorWithNoId:self.visitor Completion:^(NSDictionary *json) {
        
        self.visitor.identifier = [NSString stringWithFormat:@"%@", json[@"contact"][@"id"]];
        
        [self.apiClient postEventForUser:self.user WithStartDate:startDate Time:time Title:title Location:self.selectedLocation Visitor:self.visitor Completion:^{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postRequestComplete" object:nil];
            
            //[self.dataStore.managedObjectContext deleteObject:self.event];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *TabBarVC = [storyboard instantiateInitialViewController];
            [self.navigationController presentViewController:TabBarVC animated:YES completion:nil];
            
        } Failure:^(NSInteger errorCode) {
            
            [self.apiClient handleError:errorCode InViewController:self];
            
            NSLog(@"Error adding new visitor for new event: %d", errorCode);
            
        }];
        
    } Failure:^(NSInteger errorCode) {
        
        [self.apiClient handleError:errorCode InViewController:self];
        
        NSLog(@"Error adding new visitor for new event: %d", errorCode);
    }];
    
}


-(void)writeNewVisitorEventToCoreData
{
    
    Visitor *newVisitor = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:self.dataStore.managedObjectContext];
    newVisitor.firstName = self.firstNameTextField.text;
    newVisitor.lastName = self.lastNameTextField.text;
    newVisitor.company = self.companyTextField.text;
    newVisitor.phone = self.phoneNumberTextField.text;
    newVisitor.email = self.emailTextField.text;
    
    Event *visitorsEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.dataStore.managedObjectContext];
    visitorsEvent.start = self.startDatePicker.date;
    visitorsEvent.end = [NSDate dateWithTimeInterval:self.eventDurationInSeconds sinceDate:visitorsEvent.start];
    visitorsEvent.title = [NSString stringWithFormat:@"Meeting with: %@", newVisitor.firstName];
    visitorsEvent.identifier = @"";
    visitorsEvent.location_id = self.selectedLocation.identifier;

    [visitorsEvent addVisitorsObject:newVisitor];
    
    [self.user addEventsObject:visitorsEvent];
    
    [self.dataStore saveContext];
    
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark PickerView methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.locationPicker) {
        return [self.locations count];
    }
    else if (pickerView == self.durationPicker) {
        if (component == 0) {
            return 14;
        }
        else if (component == 1){
            return 3;
        }
    }
    
    return 0;
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.locationPicker) {
        return 1;
    }
    else if (pickerView == self.durationPicker) {
        return 2;
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == self.locationPicker) {
        
        NSMutableArray *names = [[NSMutableArray alloc]init];
        
        for (Location *loc in self.locations) {
            
            [names addObject:loc.title];
        }
        return [names objectAtIndex:row];
    }
    else if (pickerView == self.durationPicker){
        if (component == 0) {
            
            return [self.hours objectAtIndex:row];
        }
        
        if (component == 1) {
            return [self.minutes objectAtIndex:row];
        }
    }
    return nil;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)pickerViewTapGestureRecognized:(UITapGestureRecognizer*)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
    
    CGRect frame = self.locationPicker.frame;
    CGRect selectorFrame = CGRectInset( frame, 0.0, self.locationPicker.bounds.size.height * 0.85 / 2.0 );
    if ([self.locationPicker.gestureRecognizers containsObject:gestureRecognizer]) {
        
        
        if( CGRectContainsPoint( selectorFrame, touchPoint) )
        {
            self.selectedLocation = [self.locations objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
            self.isEditingLocation = NO;
            self.locationCell.textLabel.text = self.selectedLocation.title;
            NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:3];
            [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadData];
        }
    }
    else if ([self.durationPicker.gestureRecognizers containsObject:gestureRecognizer]){
        self.eventDurationInSeconds = 0;
        BOOL minutesSelected = NO;
        BOOL hoursSelected = NO;
        NSString *hourString;
        NSString *minuteString;
        if ([[self.hours objectAtIndex:[self.durationPicker selectedRowInComponent:0]] isEqualToString:@"Hours"]) {
            hourString = @"";
        }
        else{
            hourString = [NSString stringWithFormat:@"%@ hours", [self.hours objectAtIndex:[self.durationPicker selectedRowInComponent:0]]];
            hoursSelected = YES;
        }
        if ([[self.minutes objectAtIndex:[self.durationPicker selectedRowInComponent:1]] isEqualToString:@"Minutes"]) {
            minuteString = @"";
        }
        else{
            minuteString = [NSString stringWithFormat:@"%@ minutes", [self.minutes objectAtIndex:[self.durationPicker selectedRowInComponent:1]]];
            minutesSelected = YES;
        }
        
        if (hoursSelected && minutesSelected) {
            self.eventDurationInSeconds = ([[self.hours objectAtIndex:[self.durationPicker selectedRowInComponent:0]] integerValue] *60 *60) + ([[self.minutes objectAtIndex:[self.durationPicker selectedRowInComponent:1]] integerValue] *60);
        }
        else if (hoursSelected && !minutesSelected){
            self.eventDurationInSeconds = ([[self.hours objectAtIndex:[self.durationPicker selectedRowInComponent:0]] integerValue] *60 *60);
        }
        else if (!hoursSelected && minutesSelected){
            self.eventDurationInSeconds = ([[self.minutes objectAtIndex:[self.durationPicker selectedRowInComponent:1]] integerValue] *60);
        }
        NSLog(@"%d", self.eventDurationInSeconds);
        self.endDateCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",hourString, minuteString];
        self.isEditingEndDate = NO;
        // self.departureTimeCell.textLabel.text = self.selectedLocation.title;
        NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:6];
        [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}



@end
