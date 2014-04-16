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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:dateString];

    return date;
}

+(NSString *)timeStampFromDate: (NSDate *)date
{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    NSString *iso8601String = [dateFormatter stringFromDate:date];
    
    return iso8601String;
}

+ (NSString *)dateStringFromDate: (NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [format stringFromDate:date];
    return dateString;
}

+ (NSString *)timeStringFromDate: (NSDate *)date
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH.mm"];
    NSString *timeString = [timeFormat stringFromDate:date];
    NSString *timeFraction = [timeString substringFromIndex:3];
    if ([timeFraction isEqualToString: @"00"]) {
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH.0"];
        NSString *timeString = [timeFormat stringFromDate:date];
        return timeString;
        
    } else {
        
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH.5"];
        NSString *timeString = [timeFormat stringFromDate:date];
        return timeString;
    }

}

+ (Event *)getEventFromDict: (NSDictionary *)dict ToContext: (NSManagedObjectContext *)context
{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSString *searchID = dict[@"event"][@"id"];
    NSLog(@"%@", searchID);
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@",searchID];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *events = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([events count] == 0) {
            
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];

        newEvent.start = [self dateFromString:dict[@"event"][@"start_time"]];
        newEvent.end = [self dateFromString:dict[@"event"][@"end_time"]];
        newEvent.last_edit = [self dateFromString:dict[@"event"][@"updated_at"]];
        newEvent.title = [NSString stringWithFormat:@"%@", dict[@"event"][@"subject"]];
        newEvent.location_id = [NSString stringWithFormat:@"%@", dict[@"event"][@"location_id"]];

        newEvent.identifier = [NSString stringWithFormat:@"%@", dict[@"event"][@"id"]];
        

        return newEvent;
        
    } else {
        
        //Event *ev = events[0];
        
        //NSLog(@"%@", ev.identifier);
        
        return events[0];
    }

}

@end
