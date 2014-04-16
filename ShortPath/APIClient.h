//
//  APIClient.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+Methods.h"

@interface APIClient : NSObject

-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock;

- (void)fetchEventsForUser:(User *)user Completion: (void(^)(NSArray *))completionBlock;

- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime EndDate:(NSString *)endDate Title:(NSString *)title;

- (void)fetchLocationsWithCompletion: (void(^)(NSArray *))completionBlock;

@end
