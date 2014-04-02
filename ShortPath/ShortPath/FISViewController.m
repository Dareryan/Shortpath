//
//  FISViewController.m
//  ShortPath
//
//  Created by Eugene Watson on 4/1/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "FISViewController.h"

@interface FISViewController ()
@property (weak, nonatomic) IBOutlet UILabel *logoText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


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
    
    self.logoText.font = [UIFont fontWithName:@"Oswald-Regular" size:50.0];
    
    self.logoText.text = @"Shortpath";

    self.imageView.alpha = 0; [UIView animateWithDuration:0.5f animations:^{
        self.imageView.hidden = NO;
        
        self.imageView.alpha=1.0;
        
        
    }];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat: M_PI];
    rotate.duration = .5;
    [self.imageView.layer addAnimation:rotate forKey:nil];


    
    

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

@end
