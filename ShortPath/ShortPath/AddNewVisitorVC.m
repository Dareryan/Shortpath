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
#import "Event+Methods.h"
#import <AFNetworking.h>
#import "APIClient.h"




@interface AddNewVisitorVC ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextFIeld;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;


@property (strong, nonatomic) ShortPathDataStore *dataStore;
@property (strong, nonatomic) Visitor *visitor;
@property (strong, nonatomic) APIClient *apiClient;

- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonTapped:(id)sender;


@end

@implementation AddNewVisitorVC





- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.apiClient = [[APIClient alloc]init];

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
    self.visitor = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:self.dataStore.managedObjectContext];
    self.visitor.firstName = self.firstNameTextField.text;
    self.visitor.lastName = self.lastNameTextField.text;
    self.visitor.company = self.companyTextField.text;
    self.visitor.phone = self.phoneNumberTextFIeld.text;
    self.visitor.email = self.emailTextField.text;
    
    [self.event addVisitorsObject:self.visitor];
    
    //[self.dataStore saveContext];
}

#pragma mark - Table view data source


- (IBAction)doneButtonPressed:(id)sender {

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Required Fields Are Missing" message:@"In order to create an event for this visitor, the visitor must have a first name, last name and valid departure date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([self.firstNameTextField.text isEqualToString:@""] || [self.lastNameTextField.text isEqualToString:@""]) {
        
        [alertView show];
        
    } else if(![self.firstNameTextField.text isEqualToString:@""] && ![self.lastNameTextField.text isEqualToString:@""]) {
        
        [self createNewVisitorForEvent];
        
        NSString *startDate = [Event dateStringFromDate:self.event.start];
        NSString *time = [Event timeStringFromDate:self.event.start];
        
        [self.apiClient postEventForUser:self.event.user WithStartDate:startDate Time:time Title:self.event.title Location:self.location Visitor:self.visitor Completion:^{
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"postRequestComplete" object:nil];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        } Failure:^(NSInteger errorCode) {
            
            [self.apiClient handleError:errorCode InViewController:self];
            
            NSLog(@"Error adding new visitor for new event: %d", errorCode);
        }];
        
        
    }
    
    
}

- (IBAction)cancelButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
