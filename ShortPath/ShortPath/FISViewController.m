//
//  FISViewController.m
//  ShortPath
//
//  Created by Eugene Watson on 4/1/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "FISViewController.h"
#import "FISTabBarControllerViewController.h"

@interface FISViewController ()
@property (weak, nonatomic) IBOutlet UILabel *logoText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *authenticateButton;


- (IBAction)logInButton:(id)sender;


@end



@implementation FISViewController


-(void)viewWillAppear:(BOOL)animated
{
   
    self.imageView.hidden = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
    
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0.475 blue:0.82 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0.231 blue:0.51 alpha:1.0] CGColor], nil];
    
    [self.view.layer insertSublayer:gradient atIndex:0];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    

    self.authenticateButton.titleLabel.font = [UIFont fontWithName:@"Oswald-Regular" size:30.0];
 
    [self.authenticateButton setTitle:@"Authenticate" forState:UIControlStateNormal];
    
    
 
    
    self.logoText.font = [UIFont fontWithName:@"Oswald-Regular" size:50.0];
    
    self.logoText.text = @"Shortpath";

    self.imageView.alpha = 0; [UIView animateWithDuration:1.0f animations:^{
        
        self.imageView.hidden = NO;
        
        self.imageView.alpha=1.0;
   
    }];
    
}
-(void)viewWillLayoutSubviews
{
  
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInButton:(id)sender
{
    //will go to site, hit API and rectrieve token
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FISTabBarControllerViewController *tabBarVC = (FISTabBarControllerViewController *) [storyBoard instantiateViewControllerWithIdentifier:@"tabBarVC"];
    [self.navigationController pushViewController:tabBarVC animated:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *testKey = @"ImAKey";
    [defaults setObject:testKey forKey:@"key"];
    [defaults synchronize];
    
    NSLog(@"Keyfournd");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
