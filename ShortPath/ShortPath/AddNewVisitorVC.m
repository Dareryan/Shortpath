//
//  AddNewVisitorVC.m
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-05.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "AddNewVisitorVC.h"
#import "InputCell.h"

#import "Visitor+Methods.h"
#import "ShortPathDataStore.h"

#import <AFNetworking.h>




@interface AddNewVisitorVC ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFIeld;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@property (strong, nonatomic) ShortPathDataStore *dataStore;




- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;


@end

@implementation AddNewVisitorVC





- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    self.firstNameTextField.placeholder = @"First Name";
    self.lastNameTextField.placeholder = @"Last Name";
    self.companyTextField.placeholder = @"Company";
    self.phoneNumberTextFIeld.placeholder = @"Phone Number";
    self.emailTextField.placeholder = @"Email Address";
    
    
}

//add to api
- (void)createNewVisitorForEvent
{
    Visitor *newVisitor = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:self.dataStore.managedObjectContext];
    newVisitor.firstName = self.firstNameTextField.text;
    newVisitor.lastName = self.lastNameTextField.text;
    newVisitor.company = self.companyTextField.text;
    newVisitor.phone = self.phoneNumberTextFIeld.text;
    newVisitor.email = self.emailTextField.text;
    
    [self.event addVisitorsObject:newVisitor];
    
    [self.dataStore saveContext];
}

#pragma mark - Table view data source


- (IBAction)doneButtonPressed:(id)sender {
    
    
    //[self createNewVisitorForEvent];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create an event for this visitor, the visitor must have a first name, last name and valid departure date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([self.firstNameTextField.text isEqualToString:@""] || [self.lastNameTextField.text isEqualToString:@""]) {
        [alertView show];
    } else if(![self.firstNameTextField.text isEqualToString:@""] && ![self.lastNameTextField.text isEqualToString:@""]) {
        [self createNewVisitorForEvent];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
