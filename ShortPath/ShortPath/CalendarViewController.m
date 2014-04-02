//
//  CalendarViewController.m
//  ShortPath
//
//  Created by Dare Ryan on 4/2/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "CalendarViewController.h"
#import <FontAwesomeKit.h>

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITabBarItem *)tabBarItem
{
    FAKIonIcons *tabIcon = [FAKIonIcons ios7CalendarIconWithSize:30];
    [tabIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImage *tabIconImage = [tabIcon imageWithSize:CGSizeMake(30,30)];
    
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"Events" image:tabIconImage selectedImage:tabIconImage];
    
    return tabBarItem;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
