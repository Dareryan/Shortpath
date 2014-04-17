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
- (IBAction)endDatePickerValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (strong, nonatomic) NSArray *locations;
@property (strong, nonatomic) Location *selectedLocation;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) APIClient *apiClient;
@property (weak, nonatomic) IBOutlet UITableViewCell *inviteesCell;


@end

@implementation AddNewEventVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createEvent];
    [self.inviteesCell setHidden:YES];
}

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    self.locationPicker.showsSelectionIndicator = YES;
    UITapGestureRecognizer *locationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    locationGestureRecognizer.delegate = self;
    locationGestureRecognizer.cancelsTouchesInView = NO;
    [self.locationPicker addGestureRecognizer:locationGestureRecognizer];
    
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        NSLog(@"IS REACHABILE");
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Connected" message:@"Please check your connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        //NSLog(@"NOT REACHABLE");
    }
    
    
    self.apiClient = [[APIClient alloc]init];
    self.dataStore = [ShortPathDataStore sharedDataStore];

    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    self.user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
    //NSLog(@"User to add event: %@", self.user.group_id);

    
    self.locationPicker.dataSource = self;
    self.locationPicker.delegate = self;
    
    NSFetchRequest *locRequest = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
    self.locations = [self.dataStore.managedObjectContext executeFetchRequest:locRequest error:nil];
    
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
    [self.endDatePicker setHidden:YES];
    [self.locationPicker setHidden:YES];
    self.startDateCell.textLabel.text = @"Start Date";
    self.endDateCell.textLabel.text = @"End Date";
    self.locationCell.textLabel.text = @"Location";

    
    
    //    [self.tableView registerClass:[SwitchCell class] forCellReuseIdentifier:@"switchCell"];
    //    [self.tableView registerClass:[DateCell class] forCellReuseIdentifier:@"dateCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
   
    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
    
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *startIP = [NSIndexPath indexPathForRow:1 inSection:1];
    NSIndexPath *endIP = [NSIndexPath indexPathForRow:1 inSection:2];
    NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:4];
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
            [self.endDatePicker setHidden:NO];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[endIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:endIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    else if (indexPath.section == 4 && indexPath.row ==0){
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
        if (!(indexPath.section == 4 && indexPath.row == 1)) {
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
    
    if (indexPath.section ==4 && indexPath.row ==1) {
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
    
    if ([self.titleLabel.text isEqualToString:@""] || [self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0 || self.selectedLocation == nil) {
        
        [alertView show];
        
    } else if(![self.titleLabel.text isEqualToString:@""] && ![self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0 && self.selectedLocation != nil) {
        
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
    NSLog(@"%@", startDate);
    NSString *time = [Event timeStringFromDate:self.startDatePicker.date];
    
    [self.apiClient postEventForUser:self.user WithStartDate:startDate Time:time Title:self.titleTextField.text Location:self.selectedLocation Completion:^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"postRequestComplete" object:nil];
        
    } Failure:^(NSInteger errorCode) {
        
        NSLog(@"Post new event error code: %d", errorCode);
        
    }];

}


- (void)writeEventToCoreData
{
    [self.dataStore.managedObjectContext insertObject:self.event];
    self.event.start = self.startDatePicker.date;
    self.event.end = self.endDatePicker.date;
    self.event.title = self.self.titleTextField.text;
    self.event.identifier = @"";
    self.event.location_id = self.selectedLocation.identifier;
    [self.user addEventsObject:self.event];
    [self.dataStore saveContext];
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
    
    if (([self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0)) {
    [self.endDatePicker setDate:[NSDate dateWithTimeInterval: 1800 sinceDate:self.startDatePicker.date]];
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    }
    
}
- (IBAction)endDatePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
}

-(void)pickerViewTapped
{
    NSLog(@"tapped");
}

#pragma mark PickerView methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.locations count];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSMutableArray *names = [[NSMutableArray alloc]init];
    
    for (Location *loc in self.locations) {
        
        [names addObject:loc.title];
    }
    
    return [names objectAtIndex:row];
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
    
    if( CGRectContainsPoint( selectorFrame, touchPoint) )
    {
        self.selectedLocation = [self.locations objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
        self.isEditingLocation = NO;
        self.locationCell.textLabel.text = self.selectedLocation.title;
        NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:4];
         [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        
    }
}

@end
