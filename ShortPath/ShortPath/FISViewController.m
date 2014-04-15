//
//  FISViewController.m
//  ShortPath
//
//  Created by Eugene Watson on 4/1/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "FISViewController.h"
#import "FISTabBarControllerViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AFOAuth2Client/AFOAuth2Client.h>

@interface FISViewController ()
@property (weak, nonatomic) IBOutlet UILabel *logoText;
@property (weak, nonatomic) IBOutlet UILabel *logoTextBottom;
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
    
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0.475 blue:0.82 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0.137 green:0.329 blue:0.518 alpha:1.0] CGColor], nil];
    //gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:0 green:0.475 blue:0.82 alpha:1.0] CGColor], (id)[[UIColor colorWithRed:0 green:0.231 blue:0.51 alpha:1.0] CGColor], nil];
    
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
    
    
 
    
    self.logoText.font = [UIFont fontWithName:@"Oswald-Regular" size:40.0];
    
    //self.logoText.text = @"Building";

    self.logoTextBottom.font = [UIFont fontWithName:@"Oswald-Regular" size:40.0];
    
    //self.logoTextBottom.text = @"Intelligence";
    
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
    
    NSURL *url = [NSURL URLWithString:@"https://core.staging.shortpath.net/oauth/authorize?client_id=DGSqzOPpA52alnof48tUDpg4tMiwOT68E2JNRpkM&response_type=code&redirect_uri=flatironshortpath://oauthCallback"];
    [[UIApplication sharedApplication] openURL:url];
    
    AFOAuthCredential *cred = [[AFOAuthCredential alloc] initWithOAuthToken:@"qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" tokenType:@"bearer" response:nil];
    [AFOAuthCredential storeCredential:cred withIdentifier:@"FlationShortPathCred"];
    AFOAuth2Client *client = [[AFOAuth2Client alloc] init];
    client.requestSerializer = [AFJSONRequestSerializer serializer];
    [client setAuthorizationHeaderWithCredential:cred];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [client setSecurityPolicy:securityPolicy];
    //
    //
    [client GET:@"https://core.staging.shortpath.net/api/groups/8351/events/?start=2014-04-07T11:39:43-04:00&end=2014-04-07T11:39:43-05:00" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *testKey = @"responseObject";
    [defaults setObject:testKey forKey:@"key"];
    [defaults synchronize];
    
    NSLog(@"Keyfournd");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
