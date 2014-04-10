//
//  APIClient.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "APIClient.h"
#import <AFNetworking/AFNetworking.h>


@interface APIClient ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) NSString *token;

@end

@implementation APIClient

-(void)singletonInit
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.token = [defaults objectForKey:@"token"];
}

+(APIClient *) sharedInstance
{
    static APIClient *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
        [_sharedInstance singletonInit];
    });
    
    return _sharedInstance;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

-(void)fetchUserInfo
{
    
}




//- (void)fetchInterestingPhotosWithCompletion: (void(^)(NSArray *))completionBlock
//{
//    NSString *URLString = [NSString stringWithFormat:@"%@/?method=flickr.interestingness.getList&api_key=%@&%@", BASE_URL, FlickrAPIKey, PARAMS];
//    
//    [self.manager GET:URLString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSArray *photos = responseObject[@"photos"][@"photo"];
//        
//        completionBlock(photos);
//        
//    } failure:nil];
//}


@end
