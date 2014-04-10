//
//  AddNewEventVC.m
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-08.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "AddNewEventVC.h"


@interface AddNewEventVC ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic) BOOL isEditingStartDate;
@property (nonatomic) BOOL isEditingEndDate;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDateCell;

- (IBAction)cancelTapped:(id)sender;
- (IBAction)doneTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *titleLabel;
- (IBAction)startDatePickerValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
- (IBAction)endDatePickerValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.isEditingStartDate = NO;
    self.isEditingEndDate = NO;
    [self.startDatePicker setHidden:YES];
    [self.endDatePicker setHidden:YES];
    
    //    [self.tableView registerClass:[SwitchCell class] forCellReuseIdentifier:@"switchCell"];
//    [self.tableView registerClass:[DateCell class] forCellReuseIdentifier:@"dateCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.startDateCell.textLabel.text = @"Start Date";
    self.endDateCell.textLabel.text = @"End Date";
    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
    
}

#pragma mark - Table view data source



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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==1 && indexPath.row == 0)
    {
        self.isEditingStartDate = !self.isEditingStartDate;
        self.isEditingEndDate = NO;
        
        if (self.isEditingStartDate) {
            [self.startDatePicker setHidden:NO];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView reloadData];
        }];
    }
    
    else if (indexPath.section == 2 && indexPath.row == 0) {
        self.isEditingEndDate = !self.isEditingEndDate;
        self.isEditingStartDate = NO;
        if (self.isEditingEndDate){
            [self.endDatePicker setHidden:NO];
        }
        
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView reloadData];
        }];
        
    }
    else{
        
        if (!(indexPath.section == 1 && indexPath.row ==1))
        {
            self.isEditingStartDate = NO;
            
            [UIView animateWithDuration:.4 animations:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                
                [tableView reloadData];
            }];
            
            
            
        }
        if (!(indexPath.section == 2 && indexPath.row ==1)) {
            self.isEditingEndDate = NO;
            
            [UIView animateWithDuration:.4 animations:^{
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
                
                [tableView reloadData];
            }];
            
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
    
    return self.tableView.rowHeight;
}



- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneTapped:(id)sender {
    //code
}

- (IBAction)startDatePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.startDateCell.textLabel.text = @"Start Date";
    self.startDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.startDatePicker.date];
    [self.startDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];

}
- (IBAction)endDatePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy – h:mm a"];
    
    self.endDateCell.textLabel.text = @"End Date";
    self.endDateCell.detailTextLabel.text = [dateFormatter stringFromDate:self.endDatePicker.date];
    [self.endDateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0.788 green:0.169 blue:0.078 alpha:1]];
}
@end
