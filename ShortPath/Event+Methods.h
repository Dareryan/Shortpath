//
//  Event+Methods.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/8/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "Event.h"

@interface Event (Methods)

+ (Event *)getEventFromDict: (NSDictionary *)dict ToContext: (NSManagedObjectContext *)context;

+(NSString *)timeStampFromDate: (NSDate *)date;

+ (NSDate *)dateFromString: (NSString *)dateString;

+ (NSString *)dateStringFromDate: (NSDate *)date;

+ (NSString *)timeStringFromDate: (NSDate *)date;

@end
