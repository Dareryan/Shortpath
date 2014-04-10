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

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) NSString *token;

@end

@implementation APIClient

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"http://core.staging.shortpath.net/api/users/me.json"];
    
    [self.manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *userDict = responseObject[@"user"];
        
        NSLog(@"responce dict %@", responseObject);
        
        completionBlock(userDict);
        
    } failure:nil];
}





@end
