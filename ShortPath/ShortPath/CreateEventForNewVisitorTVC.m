//
//  CreateEventForNewVisitorTVC.m
//  ShortPath
//
//  Created by Dare Ryan on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "CreateEventForNewVisitorTVC.h"

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
- (IBAction)startDateDidChange:(id)sender;
- (IBAction)endDateDidChange:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end

@implementation CreateEventForNewVisitorTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isEditingStartDate = NO;
    self.isEditingEndDate = NO;
    [self.startDatePicker setHidden:YES];
    [self.endDatePicker setHidden:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    self.startDateCell.textLabel.text = @"Arrival";
    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
}

- (IBAction)endDateDidChange:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.endDateCell.textLabel.text = @"Departure";
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
    if ([self.firstNameTextField.text isEqualToString:@""] && [self.lastNameTextField.text isEqualToString:@""] && [self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create an event for this visitor, the visitor must have a first name, last name and valid departure date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else if ([self.firstNameTextField.text isEqualToString:@""] && [self.lastNameTextField.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create an event for this visitor, the visitor must have a first and last name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];

    }
    else if ([self.firstNameTextField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order add a new visitor, you must enter a first name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else if ([self.lastNameTextField.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order add a new visitor, you must enter a last name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    else if ([self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create a new event, it must have a valid End Date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
    }
    else if(![self.firstNameTextField.text isEqualToString:@""] && ![self.lastNameTextField.text isEqualToString:@""] && !([self.startDatePicker.date timeIntervalSinceDate:self.endDatePicker.date] >= 0)){
        
        /*
         Add code to insert event and visitor object into coredata. Event title should be set to [NSString stringWithFormat:@"%@ %@ visits", self.firstNameTextField.text, self.lastNameTextField.text];
         */
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }

    
    
   
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
