//
//  APIClient.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "APIClient.h"
#import <AFNetworking.h>
#import "FISViewController.h"



@interface APIClient ()

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation APIClient

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        
        _manager = [AFHTTPSessionManager manager];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        
        [requestSerializer setValue:@"Bearer qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" forHTTPHeaderField:@"Authorization"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        _manager.requestSerializer = requestSerializer;
    
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates=YES;
        _manager.securityPolicy=securityPolicy;
    }
    
    return _manager;
}


- (void)handleError: (NSInteger)errorCode InViewController: (UIViewController *)controller
{
    
    if (errorCode == 401) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FISViewController *loginVC = [storyBoard instantiateViewControllerWithIdentifier:@"logIn"];
        
        [controller presentViewController:loginVC animated:YES completion:nil];
        controller.tabBarController.navigationController.viewControllers = @[loginVC];
        [controller.tabBarController.navigationController pushViewController:loginVC animated:YES];
        
    } else if (errorCode == 500) {
        
        UIAlertView *alertConnect = [[UIAlertView alloc] initWithTitle:@"Not Connected" message:@"Please check your connection" delegate:controller cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertConnect show];
        
    } else if (errorCode == 404) {
        
        UIAlertView *alertBad = [[UIAlertView alloc] initWithTitle:@"That's bad" message:@"try again, but it wouldn't help" delegate:controller cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertBad show];
    }
    
    
}


-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    
    NSString *urlString = @"https://core.staging.shortpath.net/api/users/me.json";

    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"user"];
        
        completionBlock(dict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        //NSInteger errorCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        failureBlock(response.statusCode);
    }];

}


- (void)fetchVisitorsForEvent: (Event *)event ForUser: (User *)user Completion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events/%@", user.group_id, event.identifier];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSDictionary *eventDict = responseObject;
        NSArray *guests = eventDict[@"event"][@"event_guests"]; //array if dicts with guest info
        
        completionBlock(guests);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        failureBlock(response.statusCode);
    }];

}

- (void)fetchLocationsWithCompletion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/users/locations"];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *locationsArray = responseObject;
        
        completionBlock(locationsArray);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        failureBlock(response.statusCode);
    }];

}



- (void)fetchEventsForUser:(User *)user Completion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events", user.group_id];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *eventDicts = responseObject;
        
        completionBlock(eventDicts);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        failureBlock(response.statusCode);
    }];
}


- (void)fetchAllVisitorsforUser: (User *)user Completion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/contacts", user.group_id];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *visitorsDicts = responseObject;
        
        completionBlock(visitorsDicts);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        
        failureBlock(response.statusCode);
    }];
}



- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime Title:(NSString *)title Location: (Location *)location Completion: (void(^)())completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    //make a gist!!!
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events", user.group_id];
    
    NSString *str = [NSString stringWithFormat:@"{\"event\":{\"starts_at_date\":\"%@\",\"starts_at_time\":\"%@\",\"duration\":1,\"repeats\":\"0\",\"location_id\":\"%@\",\"subject\":\"%@\"}}", startDate, startTime, location.identifier, title];
    
    
    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
  
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    
    [request setHTTPBody:postData];
    
    //set headers
    
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"Bearer qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {

        if (!error) {
            
            //NSLog(@"%@", response);
            
            completionBlock();
            
        } else {
            
            NSInteger errorCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            
            failureBlock(errorCode);
        }

    }];
    
    [task resume];

}


- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime Title:(NSString *)title Location: (Location *)location Visitor: (Visitor *)visitor  Completion: (void(^)())completionBlock Failure: (void(^)(NSInteger))failureBlock
{
    //make a gist!!!
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events", user.group_id];
    
    NSString *str = [NSString stringWithFormat:@"{\"event\":{\"starts_at_date\":\"%@\",\"starts_at_time\":\"%@\",\"duration\":1,\"repeats\":\"0\",\"location_id\":\"%@\",\"subject\":\"%@\", \"guests_attributes\" : {\"%@\" : {\"company\":\"%@\", \"name\" : \"%@\",\"email\":\"%@\"}}}}", startDate, startTime, location.identifier, title, visitor.identifier, visitor.company, visitor.firstName, visitor.email];
    
    
    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    
    [request setHTTPBody:postData];
    
    //set headers
    
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"Bearer qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (!error) {
            
            //NSLog(@"%@", response);
            
            completionBlock();
            
        } else {
            
            NSInteger errorCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            
            failureBlock(errorCode);
        }
        
    }];
    
    [task resume];
}





- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime Title:(NSString *)title Location: (Location *)location VisitorWithNoId: (Visitor *)visitor  Completion: (void(^)(NSDictionary *))completionBlock Failure: (void(^)(NSInteger))failureBlock
{

    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/contacts.json", user.group_id];
    
    NSString *str = [NSString stringWithFormat:@"{\"contact\": {\"first_name\": \"%@\", \"last_name\": \"%@\", \"company\": \"%@\", \"email\": \"%@\", \"phone_number\":\"%@\"}}", visitor.firstName, visitor.lastName, visitor.company, visitor.email, visitor.phone];
    
    
    NSData *postData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    
    
    [request setHTTPBody:postData];
    
    //set headers
    
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:@"Bearer qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" forHTTPHeaderField:@"Authorization"];
    
    
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (!error) {
            
            NSDictionary *json = responseObject;
            
            //NSLog(@"responce: %@", responseObject);
            
            completionBlock(json);
            
        } else {
            
            NSInteger errorCode = [[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            
            failureBlock(errorCode);
        }
        
    }];
    
    [task resume];
    
}














@end
