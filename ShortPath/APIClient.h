//
//  APIClient.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User+Methods.h"
#import "Location+Methods.h"
#import "Visitor+Methods.h"

@interface APIClient : NSObject

-(void)fetchUserInfoWithCompletion: (void(^)(NSDictionary *))completionBlock Failure: (void(^)(NSInteger))failureBlock;

- (void)fetchEventsForUser:(User *)user Completion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock;

- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime Title:(NSString *)title Location: (Location *)location Completion: (void(^)())completionBlock Failure: (void(^)(NSInteger))failureBlock;

- (void)fetchLocationsWithCompletion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock;

- (void)handleError: (NSInteger)errorCode InViewController: (UIViewController *)controller;

- (void)fetchAllVisitorsforUser: (User *)user Completion: (void(^)(NSArray *))completionBlock Failure: (void(^)(NSInteger))failureBlock;


- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime Title:(NSString *)title Location: (Location *)location Visitor: (Visitor *)visitor  Completion: (void(^)())completionBlock Failure: (void(^)(NSInteger))failureBlock;

- (void)postEventForUser:(User *)user WithStartDate:(NSString *)startDate Time:(NSString *)startTime Title:(NSString *)title Location: (Location *)location VisitorWithNoId: (Visitor *)visitor  Completion: (void(^)(NSDictionary *))completionBlock Failure: (void(^)(NSInteger))failureBlock;


@end
