//
//  FISTabBarControllerViewController.m
//  ShortPath
//
//  Created by Eugene Watson on 4/3/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "FISTabBarControllerViewController.h"


@interface FISTabBarControllerViewController ()

@end

@implementation FISTabBarControllerViewController

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

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    [self.tabBarController setSelectedIndex:2];
}

@end
