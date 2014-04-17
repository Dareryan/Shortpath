//
//  APIClient.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "APIClient.h"
#import <AFNetworking.h>



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


-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock Failure: (void(^)())failureBlock
{
    
    NSString *urlString = @"https://core.staging.shortpath.net/api/users/me.json";

    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"user"];
        
        completionBlock(dict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error on API call %d", error.code);
        
        failureBlock();
    }];

}

- (void)fetchLocationsWithCompletion: (void(^)(NSArray *))completionBlock Failure: (void(^)())failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/users/locations"];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *locationsArray = responseObject;
        
        //NSLog(@"Status code: %d", [responseObject statusCode]);
        
        completionBlock(locationsArray);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error on API call %@", error);
        
        failureBlock();
    }];

}



- (void)fetchEventsForUser:(User *)user Completion: (void(^)(NSArray *))completionBlock Failure: (void(^)())failureBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events", user.group_id];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *eventDicts = responseObject;
        
        completionBlock(eventDicts);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error on API call %@", error);
        
        failureBlock();
    }];
}



- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime Title:(NSString *)title Location: (Location *)location Completion: (void(^)())completionBlock Failure: (void(^)())failureBlock
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
            
            NSLog(@"%@", response);
            
            completionBlock();
            
        } else {
            
            failureBlock();
        }

    }];
    
    [task resume];
    
    
 
}








@end
