//
//  CreateEventForExistingVisitorTVC.m
//  ShortPath
//
//  Created by Dare Ryan on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "CreateEventForExistingVisitorTVC.h"
#import "Event+Methods.h"
#import "ShortPathDataStore.h"
#import "User+Methods.h"
#import "Visitor+Methods.h"
#import "Location+Methods.h"
#import "APIClient.h"

@interface CreateEventForExistingVisitorTVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *arrivalTimeCell;
- (IBAction)arrivalDateDidChange:(id)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *departureTimeCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *arrivalDatePicker;
@property (nonatomic) BOOL arrivalTimeIsEditing;
@property (nonatomic) BOOL departureTimeIsEditing;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (nonatomic) BOOL isEditingLocation;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPicker;
@property (strong, nonatomic) NSArray *hours;
@property (strong, nonatomic) NSArray *minutes;
@property (nonatomic) NSInteger eventDurationInSeconds;


@property (strong, nonatomic) ShortPathDataStore *dataStore;

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSArray *locations;

@property (strong, nonatomic) APIClient *apiClient;
@property (strong, nonatomic) Location *selectedLocation;


- (IBAction)doneButtonTapped:(id)sender;

@end

@implementation CreateEventForExistingVisitorTVC

- (IBAction)doneButtonPressed:(id)sender
{
    //[self createNewVisitorEvent];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hours = @[@"Hours", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    self.minutes = @[@"Minutes", @"0", @"30"];
    
    self.title = @"Create Event";
    self.dataStore = [ShortPathDataStore sharedDataStore];
    self.apiClient = [[APIClient alloc]init];
    
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    self.user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
    
    NSFetchRequest *locRequest = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
    self.locations = [self.dataStore.managedObjectContext executeFetchRequest:locRequest error:nil];
    
    self.locationPicker.dataSource = self;
    self.locationPicker.delegate = self;
    self.durationPicker.delegate = self;
    self.durationPicker.dataSource = self;
    
    self.arrivalTimeIsEditing = NO;
    self.departureTimeIsEditing = NO;
    
    [self.arrivalDatePicker setHidden:YES];
    [self.durationPicker setHidden:YES];
    [self.locationPicker setHidden:YES];
    
    self.nameCell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.visitor.firstName, self.visitor.lastName];
    
    
    UITapGestureRecognizer *locationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    locationGestureRecognizer.delegate = self;
    locationGestureRecognizer.cancelsTouchesInView = NO;
    [self.locationPicker addGestureRecognizer:locationGestureRecognizer];
    
    UITapGestureRecognizer *durationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    durationGestureRecognizer.delegate = self;
    durationGestureRecognizer.cancelsTouchesInView = NO;
    [self.durationPicker addGestureRecognizer:durationGestureRecognizer];
    
    self.arrivalTimeCell.textLabel.text = @"Arrival";
    self.departureTimeCell.textLabel.text = @"Duration";
    self.departureTimeCell.detailTextLabel.text = @"";
    self.locationCell.textLabel.text = @"Location";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.arrivalTimeCell.detailTextLabel.text = [dateFormatter stringFromDate:self.arrivalDatePicker.date];
    
    //self.departureTimeCell.detailTextLabel.text = [dateFormatter stringFromDate:self.departureDatePicker.date];
    [self.arrivalTimeCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    [self.departureTimeCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *arrivalCellIP = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *departureCellIP = [NSIndexPath indexPathForRow:1 inSection:2];
    NSIndexPath *locationCellIP = [NSIndexPath indexPathForRow:1 inSection:3];
    
    if(indexPath.section==1 && indexPath.row == 0)
    {
        self.arrivalTimeIsEditing = !self.arrivalTimeIsEditing;
        self.departureTimeIsEditing = NO;
        self.isEditingLocation = NO;
        
        if (self.arrivalTimeIsEditing) {
            [self.arrivalDatePicker setHidden:NO];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[arrivalCellIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:arrivalCellIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    else if (indexPath.section == 2 && indexPath.row == 0) {
        self.departureTimeIsEditing = !self.departureTimeIsEditing;
        self.arrivalTimeIsEditing = NO;
        self.isEditingLocation = NO;
        if (self.departureTimeIsEditing){
            [self.durationPicker setHidden:NO];
        }
        
        
        [self.tableView reloadRowsAtIndexPaths:@[departureCellIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:departureCellIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
    }
    else if (indexPath.section == 3 && indexPath.row == 0){
        self.isEditingLocation = !self.isEditingLocation;
        self.departureTimeIsEditing = NO;
        self.arrivalTimeIsEditing = NO;
        if (self.isEditingLocation) {
            [self.locationPicker setHidden:NO];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[locationCellIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:locationCellIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
    }
    else{
        
        if (!(indexPath.section == 1 && indexPath.row ==1))
        {
            self.arrivalTimeIsEditing = NO;
            
            [self.tableView reloadRowsAtIndexPaths:@[arrivalCellIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
            
        }
        if (!(indexPath.section == 2 && indexPath.row ==1)) {
            self.departureTimeIsEditing = NO;
            
            [self.tableView reloadRowsAtIndexPaths:@[departureCellIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
            
        }
        if (!(indexPath.section == 3 && indexPath.row == 1)) {
            self.isEditingLocation = NO;
            
            [self.tableView reloadRowsAtIndexPaths:@[locationCellIP] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView reloadData];
            
        }
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1 && indexPath.row ==1) {
        if (self.arrivalTimeIsEditing)
        {
            return 225.0;
        } else {
            return 0.0;
        }
    } if (indexPath.section ==2 && indexPath.row == 1) {
        if (self.departureTimeIsEditing) {
            return 225.0;
        } else {
            return 0;
        }
    }
    if (indexPath.section == 3 && indexPath.row ==1) {
        if (self.isEditingLocation) {
            return 225.0;
        }
        else{
            return 0;
        }
    }
    
    return self.tableView.rowHeight;
}

- (IBAction)arrivalDateDidChange:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    
    self.arrivalTimeCell.detailTextLabel.text = [dateFormatter stringFromDate:self.arrivalDatePicker.date];
    [self.arrivalTimeCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
}



- (IBAction)doneButtonTapped:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required fields are missing" message:@"Please select a start date, duration and location to create a new event" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    if (self.eventDurationInSeconds > 0 && self.selectedLocation != nil) {
        [self writeNewVisitorEventToCoreData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //Create and Add New Event Object Here
    else{
        [alertView show];
    }
    
}



-(void)writeNewVisitorEventToCoreData
{
    Event *visitorsEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.dataStore.managedObjectContext];
    
    visitorsEvent.start = self.arrivalDatePicker.date;
    visitorsEvent.end = [NSDate dateWithTimeInterval:self.eventDurationInSeconds sinceDate:self.arrivalDatePicker.date];
    visitorsEvent.title = [NSString stringWithFormat:@"Meeting with: %@", self.visitor.firstName];
    visitorsEvent.identifier = @"";
    visitorsEvent.location_id = self.selectedLocation.identifier;
    
    [visitorsEvent addVisitorsObject:self.visitor];
    
    [self.user addEventsObject:visitorsEvent];
    
    [self.dataStore saveContext];
    
}

- (void)postNewVisitorEventToServer
{
    NSString *startDate = [Event dateStringFromDate:self.arrivalDatePicker.date];
    NSString *time = [Event timeStringFromDate:self.arrivalDatePicker.date];
    NSString *title = [NSString stringWithFormat:@"Meeting with: %@ %@", self.visitor.firstName, self.visitor.lastName];
    
    [self.apiClient postEventForUser:self.user WithStartDate:startDate Time:time Title:title Location:self.selectedLocation Completion:^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"postRequestComplete" object:nil];
        
    } Failure:^(NSInteger errorCode) {
        
        [self.apiClient handleError:errorCode InViewController:self];
        
        NSLog(@"Post new event for existing visitor error code: %d", errorCode);
        
    }];
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
        self.departureTimeCell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",hourString, minuteString];
        self.departureTimeIsEditing = NO;
        // self.departureTimeCell.textLabel.text = self.selectedLocation.title;
        NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:3];
        [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
    }
}



@end
