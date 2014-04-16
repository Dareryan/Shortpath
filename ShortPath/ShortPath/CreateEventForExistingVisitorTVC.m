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

@interface CreateEventForExistingVisitorTVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *arrivalTimeCell;
- (IBAction)arrivalDateDidChange:(id)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *departureTimeCell;
- (IBAction)departureDateDidChange:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *arrivalDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *departureDatePicker;
@property (nonatomic) BOOL arrivalTimeIsEditing;
@property (nonatomic) BOOL departureTimeIsEditing;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationCell;
@property (weak, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (nonatomic) BOOL isEditingLocation;


@property (strong, nonatomic) ShortPathDataStore *dataStore;

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
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    self.locationPicker.dataSource = self;
    self.locationPicker.delegate = self;
    
    self.arrivalTimeIsEditing = NO;
    self.departureTimeIsEditing = NO;
    
    [self.arrivalDatePicker setHidden:YES];
    [self.departureDatePicker setHidden:YES];
    [self.locationPicker setHidden:YES];
    
    self.nameCell.textLabel.text = self.visitor.firstName;
    
    self.locationPicker.showsSelectionIndicator = YES;
    UITapGestureRecognizer *locationGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickerViewTapGestureRecognized:)];
    locationGestureRecognizer.delegate = self;
    locationGestureRecognizer.cancelsTouchesInView = NO;
    [self.locationPicker addGestureRecognizer:locationGestureRecognizer];

    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.arrivalTimeCell.textLabel.text = @"Arrival";
    self.departureTimeCell.textLabel.text = @"Departure";
    self.arrivalTimeCell.detailTextLabel.text = [dateFormatter stringFromDate:self.arrivalDatePicker.date];
    self.departureTimeCell.detailTextLabel.text = [dateFormatter stringFromDate:self.departureDatePicker.date];
    [self.arrivalTimeCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    [self.departureTimeCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
}


-(void)createNewVisitorEvent
{
    
    NSFetchRequest *req = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    
    
    
    Event *visitorsEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.dataStore.managedObjectContext];
    
    visitorsEvent.start = self.arrivalDatePicker.date;
    visitorsEvent.end = self.departureDatePicker.date;
    visitorsEvent.title = [NSString stringWithFormat:@"Meeting with: %@", self.visitor.firstName];
    visitorsEvent.identifier = @"";
    
    [visitorsEvent addVisitorsObject:self.visitor];
    
    if ([[self.dataStore.managedObjectContext executeFetchRequest:req error:nil] count] != 0) {
        User *user = [self.dataStore.managedObjectContext executeFetchRequest:req error:nil][0];
        [user addEventsObject:visitorsEvent];
    }
    
    
    [self.dataStore saveContext];
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==1 && indexPath.row == 0)
    {
        self.arrivalTimeIsEditing = !self.arrivalTimeIsEditing;
        self.departureTimeIsEditing = NO;
        self.isEditingLocation = NO;
        
        if (self.arrivalTimeIsEditing) {
            [self.arrivalDatePicker setHidden:NO];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView reloadData];
        }];
    }
    
    else if (indexPath.section == 2 && indexPath.row == 0) {
        self.departureTimeIsEditing = !self.departureTimeIsEditing;
        self.arrivalTimeIsEditing = NO;
        self.isEditingLocation = NO;
        if (self.departureTimeIsEditing){
            [self.departureDatePicker setHidden:NO];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView reloadData];
        }];
        
    }
    else if (indexPath.section == 3 && indexPath.row == 0){
        self.isEditingLocation = !self.isEditingLocation;
        self.departureTimeIsEditing = NO;
        self.arrivalTimeIsEditing = NO;
        if (self.isEditingLocation) {
            [self.locationPicker setHidden:NO];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView reloadData];
        }];

        
        
    }
    else{
        
        if (!(indexPath.section == 1 && indexPath.row ==1))
        {
            self.arrivalTimeIsEditing = NO;
            
            [UIView animateWithDuration:.4 animations:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                
                [tableView reloadData];
            }];
            
        }
        if (!(indexPath.section == 2 && indexPath.row ==1)) {
            self.departureTimeIsEditing = NO;
            
            [UIView animateWithDuration:.4 animations:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
                
                [tableView reloadData];
            }];
            
        }
        if (!(indexPath.section == 3 && indexPath.row == 1)) {
            self.isEditingLocation = NO;
            
            [UIView animateWithDuration:.4 animations:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationFade];
                
                [tableView reloadData];
            }];
            
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
    
    if (([self.arrivalDatePicker.date timeIntervalSinceDate:self.departureDatePicker.date] >= 0)) {
        [self.departureDatePicker setDate:[NSDate dateWithTimeInterval: 1800 sinceDate:self.arrivalDatePicker.date]];
        self.departureTimeCell.detailTextLabel.text = [dateFormatter stringFromDate:self.departureDatePicker.date];
        [self.departureTimeCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    }
}


- (IBAction)departureDateDidChange:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.departureTimeCell.detailTextLabel.text = [dateFormatter stringFromDate:self.departureDatePicker.date];
    [self.departureTimeCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
}
- (IBAction)doneButtonTapped:(id)sender {
    
    
    
    if ([self.arrivalDatePicker.date timeIntervalSinceDate:self.departureDatePicker.date] >= 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create a new event, it must have a valid End Date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        
    } else {
        
        //Create and Add New Event Object Here
        [self createNewVisitorEvent];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark PickerView methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
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
        //self.selectedLocation = [self.locations objectAtIndex:[self.locationPicker selectedRowInComponent:0]];
        self.isEditingLocation = NO;
       // self.locationCell.textLabel.text = self.selectedLocation.title;
        NSIndexPath *locIP = [NSIndexPath indexPathForRow:1 inSection:3];
        [self.tableView reloadRowsAtIndexPaths:@[locIP] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadData];
        
    }
}



@end
