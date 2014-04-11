//
//  Event+Methods.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "Event+Methods.h"

@implementation Event (Methods)


+ (NSDate *)dateFromString: (NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    //[dateFormatter setTimeZone:timeZone];
    
    NSString *dateStr = [dateString substringToIndex:[dateString length] - 6];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];

    return date;
}


+ (Event *)getEventFromDict: (NSDictionary *)dict ToContext: (NSManagedObjectContext *)context
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSString *searchID = dict[@"event_occurence"][@"id"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@",searchID];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *events = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([events count] == 0) {
    
        //NSLog(@"%@", dict[@"event_occurrence"]);
            
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];

        //NSNumber *dateNumber = dict[@"event_occurrence"][@"start_time"];
        
        newEvent.start = [self dateFromString:dict[@"event_occurrence"][@"start_time"]];
        newEvent.end = [self dateFromString:dict[@"event_occurrence"][@"end_time"]];
                
        //newEvent.start = [NSDate dateWithTimeIntervalSince1970:[dateNumber doubleValue]];

        newEvent.identifier = [NSString stringWithFormat:@"%@", dict[@"event_occurrence"][@"id"]];

        return newEvent;
        
    } else {
        
        //Event *ev = events[0];
        
        //NSLog(@"%@", ev.identifier);
        
        return events[0];
    }

}

@end
