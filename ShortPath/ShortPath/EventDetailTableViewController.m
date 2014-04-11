//
//  EventDetailTableViewController.m
//  ShortPath
//
//  Created by Dare Ryan on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "EventDetailTableViewController.h"

@interface EventDetailTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *startDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDateCell;


@end

@implementation EventDetailTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleCell.textLabel.text = self.event.identifier;
    self.startDateCell.detailTextLabel.text = [self formatDate:self.event.start];
    self.endDateCell.detailTextLabel.text = [self formatDate:self.event.end];

}

- (NSString *)formatDate: (NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    
    //[formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}


@end
