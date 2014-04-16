//
//  User.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/16/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * building_id;
@property (nonatomic, retain) NSString * group_id;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *locations;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addLocationsObject:(NSManagedObject *)value;
- (void)removeLocationsObject:(NSManagedObject *)value;
- (void)addLocations:(NSSet *)values;
- (void)removeLocations:(NSSet *)values;

@end
