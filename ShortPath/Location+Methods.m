//
//  Location+Methods.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/16/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "Location+Methods.h"

@implementation Location (Methods)


+ (Location *)getLocationFromDict: (NSDictionary *)locationDict ToContext: (NSManagedObjectContext *)context
{
    
    NSLog(@"Dict: %@", locationDict[@"space"]);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
    NSString *searchId = [NSString stringWithFormat:@"%@", locationDict[@"space"][@"id"]];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@", searchId];
    request.predicate = searchPredicate;
    
    NSArray *locations = [context executeFetchRequest:request error:nil];

    if ([locations count] == 0) {
        
        Location *newLocation = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        newLocation.title = locationDict[@"space"][@"name"];
        newLocation.identifier = [NSString stringWithFormat:@"%@", locationDict[@"space"][@"id"]];
       
        return newLocation;
        
    } else {
        return locations[0];
    }
    
    
    
}



@end
