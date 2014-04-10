//
//  APIClient.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIClient : NSObject

-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock;

@end
