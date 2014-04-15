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
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) AFHTTPSessionManager *manager;


- (IBAction)startDateDidChange:(id)sender;
- (IBAction)endDateDidChange:(id)sender;
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
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    self.isEditingStartDate = NO;
    self.isEditingEndDate = NO;
    [self.startDatePicker setHidden:YES];
    [self.endDatePicker setHidden:YES];
    
    
    [super viewDidLoad];
    
    NSString *urlString = @"https://core.staging.shortpath.net/api/users/me.json";
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"user"];
        //completionBlock(dict);
        NSLog(@"%@", dict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error Code %d",  error.code);
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.startDateCell.textLabel.text = @"Arrival";
    self.endDateCell.textLabel.text = @"Departure";
    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *topIP = [NSIndexPath indexPathForRow:1 inSection:5];
    NSIndexPath *bottomIP = [NSIndexPath indexPathForRow:1 inSection:6];
    if(indexPath.section==5 && indexPath.row == 0)
    {
        self.isEditingStartDate = !self.isEditingStartDate;
        self.isEditingEndDate = NO;
        
        if (self.isEditingStartDate) {
            [self.startDatePicker setHidden:NO];
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[topIP] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:topIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else if (indexPath.section == 6 && indexPath.row == 0) {
        self.isEditingEndDate = !self.isEditingEndDate;
        self.isEditingStartDate = NO;
        
        if (self.isEditingEndDate){
            [self.endDatePicker setHidden:NO];
        }
        [self.tableView reloadRowsAtIndexPaths:@[bottomIP] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:bottomIP atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else{
        if (!(indexPath.section == 5 && indexPath.row ==1)){
            self.isEditingStartDate = NO;
            [self.tableView reloadRowsAtIndexPaths:@[topIP] withRowAnimation:UITableViewRowAnimationFade];
            [tableView reloadData];
        }
        if (!(indexPath.section == 6 && indexPath.row ==1)) {
            self.isEditingEndDate = NO;
            [self.tableView reloadRowsAtIndexPaths:@[bottomIP] withRowAnimation:UITableViewRowAnimationFade];
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
    return self.tableView.rowHeight;
}


- (IBAction)startDateDidChange:(id)sender {
    
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

- (IBAction)endDateDidChange:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create an event for this visitor, the visitor must have a first name, last name and valid departure date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([self.firstNameTextField.text isEqualToString:@""] || [self.lastNameTextField.text isEqualToString:@""] || [self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0) {
        
        [alertView show];
        
    } else if(![self.firstNameTextField.text isEqualToString:@""] && ![self.lastNameTextField.text isEqualToString:@""] && !([self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0)) {
        
        /*
         Add code to insert event and visitor object into coredata. Event title should be set to [NSString stringWithFormat:@"%@ %@ visits", self.firstNameTextField.text, self.lastNameTextField.text];
         */
        [self createNewVisitorEvent];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

//api call POST event
-(void)createNewVisitorEvent
{
    
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    
    
    Visitor *newVisitor = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:self.dataStore.managedObjectContext];
    newVisitor.firstName = self.firstNameTextField.text;
    newVisitor.lastName = self.lastNameTextField.text;
    newVisitor.company = self.companyTextField.text;
    newVisitor.phone = self.phoneNumberTextField.text;
    newVisitor.email = self.emailTextField.text;
    
    Event *visitorsEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.dataStore.managedObjectContext];
    visitorsEvent.start = self.startDatePicker.date;
    visitorsEvent.end = self.endDatePicker.date;
    visitorsEvent.title = [NSString stringWithFormat:@"Meeting with: %@", newVisitor.firstName];
    visitorsEvent.identifier = @"";
    
    [visitorsEvent addVisitorsObject:newVisitor];
    
    
    if ([[self.dataStore.managedObjectContext executeFetchRequest:req error:nil] count] != 0) {
        User *user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
        [user addEventsObject:visitorsEvent];
    }
    
    [self.dataStore saveContext];
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
