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
        [_manager.requestSerializer setValue:@"Bearer qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" forHTTPHeaderField:@"Authorization"];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates=YES;
        _manager.securityPolicy=securityPolicy;
    }
    return _manager;
}


-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock
{
    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //[self.manager.requestSerializer setValue:@"Bearer qFSIRW5HTyKdCEGltw16GFtG3oT4Dl2VCZPlH5Lk" forHTTPHeaderField:@"Authorization"];
    
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    securityPolicy.allowInvalidCertificates=YES;
//    self.manager.securityPolicy=securityPolicy;
    
    NSString *urlString = @"https://core.staging.shortpath.net/api/users/me.json";

    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *dict = responseObject[@"user"];
        completionBlock(dict);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error on API call %@", error);
    }];

}

- (void)fetchEventsForUser: (User *)user Completion: (void(^)(NSArray *))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"https://core.staging.shortpath.net/api/groups/%@/events", user.group_id];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *eventDicts = responseObject;
        
        NSLog(@"%@", responseObject);
        
        completionBlock(eventDicts);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error on API call %@", error);
    }];
}





@end
