//
//  Event+Methods.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "Event+Methods.h"

@implementation Event (Methods)

+ (Event *)addEventFromDict: (NSDictionary *)dict ToContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSString *searchID = dict[@"id"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@",searchID];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *events = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([events count] == 0) {
        
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        
        newEvent.start = dict[@"start"];
        newEvent.title = dict[@"title"];
        newEvent.identifier = [NSString stringWithFormat:@"%@", dict[@"id"]];
        
        return newEvent;
    } else {
        return events[0];
    }

}

@end
