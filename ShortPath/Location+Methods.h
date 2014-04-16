//
//  Location+Methods.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/16/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "Location.h"

@interface Location (Methods)

+ (Location *)getLocationFromDict: (NSDictionary *)locationDict ToContext: (NSManagedObjectContext *)context;

@end
