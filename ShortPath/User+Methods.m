//
//  User+Methods.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "User+Methods.h"

@implementation User (Methods)

+(User *)getUserFromDict: (NSDictionary *)userDict ToContext: (NSManagedObjectContext *)context

{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"User"];
    NSString *searchID = userDict[@"id"];
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@", searchID];
    request.predicate = searchPredicate;
    
    NSArray *users = [context executeFetchRequest:request error:nil];
    
    if ([users count] == 0) {
        
        User *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        
        newUser.group_id = userDict[@"primary_group_id"];
        newUser.building_id = userDict[@"primary_building_id"];
        newUser.identifier = userDict[@"id"];
        newUser.username = userDict[@"username"];
        
        return newUser;
    } else {
        
        return users[0];
    }
 
}

@end
