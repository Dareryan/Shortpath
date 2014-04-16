//
//  Event.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/16/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location, User, Visitor;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * last_edit;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * location_id;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *visitors;
@property (nonatomic, retain) Location *location;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addVisitorsObject:(Visitor *)value;
- (void)removeVisitorsObject:(Visitor *)value;
- (void)addVisitors:(NSSet *)values;
- (void)removeVisitors:(NSSet *)values;

@end
