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
        //[requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        _manager.requestSerializer = requestSerializer;
    
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates=YES;
        _manager.securityPolicy=securityPolicy;
    }
    return _manager;
}


-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock
{
    
    NSString *urlString = @"https://core.staging.shortpath.net/api/users/me.json";

    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"user"];
        
        completionBlock(dict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error on API call %@", error);
    }];

}


- (void)fetchEventsForUser:(User *)user Completion: (void(^)(NSArray *))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events", user.group_id];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *eventDicts = responseObject;
        
        completionBlock(eventDicts);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"Error on API call %@", error);
    }];
}


- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime EndDate:(NSString *)endDate Title:(NSString *)title
{
    
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events.json", user.group_id];
    
    NSString *str = [NSString stringWithFormat:@"{\"event\":{\"starts_at_date\":\"%@\",\"starts_at_time\":\"%@\",\"duration\":1,\"repeats\":\"0\",\"location_id\":7144,\"subject\":\"postman\"}}", startDate, startTime];
    
//    NSDictionary *innerDict = [[NSDictionary alloc]initWithObjects:@[startDate, startTime, endDate, title, @"7144"] forKeys:@[@"starts_at_date", @"starts_at_time", @"ends_at_date", @"subject", @"location"]];
//    
//    NSDictionary *bodyJson = [[NSDictionary alloc]initWithObjects:@[innerDict] forKeys:@[@"event"]];
    
    //NSData *postData = [NSJSONSerialization dataWithJSONObject:bodyJson options:0 error:nil];
    
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

        NSLog(@"%@", response);

    }];
    
    [task resume];
 
}








@end
