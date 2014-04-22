//
//  AddNewEventVC.m
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-08.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <AFNetworking.h>
#import "AddNewEventVC.h"
#import "Event+Methods.h"
#import "ShortPathDataStore.h"
#import "Event.h"
#import "Location+Methods.h"
#import "APIClient.h"
#import "VisitorsVC.h"



@interface AddNewEventVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic) BOOL isEditingStartDate;
@property (nonatomic) BOOL isEditingEndDate;
@property (strong, nonatomic) ShortPathDataStore *dataStore;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationPickerViewCell;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (nonatomic) BOOL isEditingLocation;
@property (strong, nonatomic) Event *event;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
- (IBAction)startDatePickerValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) APIClient *apiClient;
@property (weak, nonatomic) IBOutlet UITableViewCell *inviteesCell;
@property (nonatomic) NSInteger eventDurationInSeconds;
@property (strong, nonatomic) NSArray *hours;
@property (strong, nonatomic) NSArray *minutes;


@end

@implementation AddNewEventVC


-(void)viewWillAppear:(BOOL)animated
{
    
    //[self.inviteesCell setHidden:YES];
}

- (void)viewDidLoad

{
    [super viewDidLoad];
    

    
    
    self.locationPicker.showsSelectionIndicator = YES;

    self.hours = @[@"Hours", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    self.minutes = @[@"Minutes", @"0", @"30"];
    
    UITapGestureRecognizer *locationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    locationGestureRecognizer.delegate = self;
    locationGestureRecognizer.cancelsTouchesInView = NO;
    [self.locationPicker addGestureRecognizer:locationGestureRecognizer];
    
    UITapGestureRecognizer *durationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    durationGestureRecognizer.delegate = self;
    durationGestureRecognizer.cancelsTouchesInView = NO;
    [self.durationPicker addGestureRecognizer:durationGestureRecognizer];
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        NSLog(@"IS REACHABILE");
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Connected" message:@"Please check your connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        //NSLog(@"NOT REACHABLE");
    }
    
    
    self.apiClient = [[APIClient alloc]init];
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    //[self createEvent];

    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    self.user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
    //NSLog(@"User to add event: %@", self.user.group_id);

    
    self.locationPicker.dataSource = self;
    self.locationPicker.delegate = self;
    self.durationPicker.delegate = self;
    self.durationPicker.dataSource = self;
    
    NSFetchRequest *locRequest = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
    self.locations = [self.dataStore.managedObjectContext executeFetchRequest:locRequest error:nil];
    
    [self.locationPicker selectRow:0 inComponent:0 animated:NO];
    self.selectedLocation = [self.locations objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
    self.locationCell.textLabel.text = self.selectedLocation.title;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.titleTextField.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isEditingStartDate = NO;
    self.isEditingEndDate = NO;
    self.isEditingLocation = NO;
    [self.startDatePicker setHidden:YES];
    [self.durationPicker setHidden:YES];
    [self.locationPicker setHidden:YES];
    self.startDateCell.textLabel.text = @"Start Date";
    self.endDateCell.textLabel.text = @"Duration";
   // self.locationCell.textLabel.text = @"Location";

    
    
    //    [self.tableView registerClass:[SwitchCell class] forCellReuseIdentifier:@"switchCell"];
    //    [self.tableView registerClass:[DateCell class] forCellReuseIdentifier:@"dateCell"];
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

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *startIP = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *endIP = [NSIndexPath indexPathForRow:1 inSection:2];
    NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:3];
    if(indexPath.section==1 && indexPath.row == 0)
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
    
    else if (indexPath.section == 2 && indexPath.row == 0) {
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
    
    else if (indexPath.section == 3 && indexPath.row ==0){
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
        
        if (!(indexPath.section == 1 && indexPath.row ==1))
        {
            self.isEditingStartDate = NO;
            
            [self.tableView reloadRowsAtIndexPaths:@[startIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
            
        }
        if (!(indexPath.section == 2 && indexPath.row ==1)) {
            self.isEditingEndDate = NO;
            
            [self.tableView reloadRowsAtIndexPaths:@[endIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
           
        }
        if (!(indexPath.section == 3 && indexPath.row == 1)) {
            self.isEditingLocation = NO;
            
            [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
        }
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section ==1 && indexPath.row ==1) {
        
        if (self.isEditingStartDate)
        {
            return 225.0;
        }
        else
        {
            return 0.0;
        }
    }
    
    if (indexPath.section ==2 && indexPath.row == 1) {
        if (self.isEditingEndDate) {
            
            return 225.0;
            
        }
        else{
            return 0;
            
        }
    }
    
    if (indexPath.section ==3 && indexPath.row ==1) {
        if (self.isEditingLocation) {
            return 225.0;
        }
        else{
            return 0;
        }
    }
    
    return self.tableView.rowHeight;
}



- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)doneTapped:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create a new event, please specify a title, location and valid end date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([self.titleLabel.text isEqualToString:@""] || self.eventDurationInSeconds == 0 || self.selectedLocation == nil) {
        
        [alertView show];
        
    } else if(![self.titleLabel.text isEqualToString:@""] && self.eventDurationInSeconds != 0 && self.selectedLocation != nil) {
        
        //Create and Add New Event Object Here
        if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
            
            [self postNewEventToServer];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"IS REACHABILE");
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Connected" message:@"Please check your connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            //NSLog(@"NOT REACHABLE");
        }

    }
}

-(void)postNewEventToServer
{
    NSString *startDate = [Event dateStringFromDate:self.startDatePicker.date];
    //NSLog(@"%@", startDate);
    NSString *time = [Event timeStringFromDate:self.startDatePicker.date];
    
    [self.apiClient postEventForUser:self.user WithStartDate:startDate Time:time Title:self.titleTextField.text Location:self.selectedLocation Completion:^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"postRequestComplete" object:nil];
        
        [self.dataStore.managedObjectContext deleteObject:self.event];
        
        [self.dataStore saveContext];
        
        
    } Failure:^(NSInteger errorCode) {
        
        [self.apiClient handleError:errorCode InViewController:self];
        
        NSLog(@"Post new event error code: %d", errorCode);
        
    }];

}


- (void)writeEventToCoreData

{

    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.dataStore.managedObjectContext];
    event.start = self.startDatePicker.date;
    event.end = [NSDate dateWithTimeInterval:self.eventDurationInSeconds sinceDate:event.start];
    event.title = self.self.titleTextField.text;
    event.identifier = @"";
    event.location_id = self.selectedLocation.identifier;
    [self.user addEventsObject:event];
    //[self.dataStore saveContext];
}

-(void)createEvent
{
    NSEntityDescription *eventDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.dataStore.managedObjectContext];
    self.event = [[Event alloc]initWithEntity:eventDescription insertIntoManagedObjectContext:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)startDatePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
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
        NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    VisitorsVC *visitorsVC = [segue destinationViewController];
    
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.dataStore.managedObjectContext];
    event.start = self.startDatePicker.date;
    event.end = [NSDate dateWithTimeInterval:self.eventDurationInSeconds sinceDate:event.start];
    event.title = self.self.titleTextField.text;
    event.identifier = @"";
    event.location_id = self.selectedLocation.identifier;
    
    [self.user addEventsObject:event];
    
    visitorsVC.event = event;
    visitorsVC.location = self.selectedLocation;
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create a new event, please specify a title, location and valid end date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([self.titleLabel.text isEqualToString:@""] || self.eventDurationInSeconds == 0 || self.selectedLocation == nil) {
        
        [alertView show];
        return NO;
        
    } else {
        
        return YES;
    }
}

@end
