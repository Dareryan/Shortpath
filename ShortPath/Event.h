//
//  Event.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Visitor;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * allDay;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * end;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *visitors;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addVisitorsObject:(Visitor *)value;
- (void)removeVisitorsObject:(Visitor *)value;
- (void)addVisitors:(NSSet *)values;
- (void)removeVisitors:(NSSet *)values;

@end
