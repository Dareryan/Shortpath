//
//  User+Methods.h
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "User.h"

@interface User (Methods)

+(User *)getUserFromDict: (NSDictionary *)userDict ToContext: (NSManagedObjectContext *)context;

@end
