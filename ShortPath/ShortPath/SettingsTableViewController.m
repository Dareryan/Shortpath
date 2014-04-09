//
//  SettingsTableViewController.m
//  ShortPath
//
//  Created by Eugene Watson on 4/2/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "SettingsTableViewController.h"
#import <FontAwesomeKit.h>
#import "FISViewController.h"
#import "FISAppDelegate.h"


@interface SettingsTableViewController ()

@property (strong, nonatomic) NSArray *content;

@end

@implementation SettingsTableViewController

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
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.content = [[NSArray alloc] initWithObjects:@"Team", @"Building", @"Notifications", nil];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FISViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"logIn"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"key"]) {
        NSLog(@"key found");
        
    } else {
        
        NSLog(@"There is no key");
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }
    
}

-(UITabBarItem *)tabBarItem
{
    FAKIonIcons *tabIconUnselected = [FAKIonIcons ios7GearOutlineIconWithSize:30];
    UIImage *tabIconImageUnselected = [tabIconUnselected imageWithSize:CGSizeMake(30,30)];
    
    FAKIonIcons *tabIconSelected = [FAKIonIcons ios7GearIconWithSize:30.0f];
    UIImage *tabIconImageSelected = [tabIconSelected imageWithSize:CGSizeMake(30,30)];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Settings" image:tabIconImageUnselected selectedImage:tabIconImageSelected];
    
    return tabBarItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark – Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section ==0) {
        return [self.content count];
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"settingsCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.section==0) {
        NSString *content = [self.content objectAtIndex:indexPath.row];
        [cell.textLabel setText:content];
    }
    
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setText:@"Log Out"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0)
    {
        [self performSegueWithIdentifier:@"detailSegue" sender:self];
    }
    else if (indexPath.section ==1)
    {
        [self vibrate];
        NSLog(@"I shook");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Log Out" message: @"Are you sure you want to log out?" delegate:self  cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        [alert show];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.section ==1)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1];
        cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1];
        cell.selectedBackgroundView =   [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1];
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
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"key"];
        [defaults synchronize];
        NSLog(@"Key Deleted");
        
    }
}

-(void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}



//pop to root view controller

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

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//
//{
//    if ([segue.identifier isEqualToString:@"detail"]) {
//        UIViewController *destination = (UIViewController *)segue.destinationViewController;
//        UITableViewCell *cell = (UITableViewCell *) sender;
//        destination.title = cell.textLabel.text;
//    }
//}





@end
