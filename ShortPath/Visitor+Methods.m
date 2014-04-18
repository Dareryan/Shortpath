//
//  Visitor+Methods.m
//  ShortPath
//
//  Created by Nadia Yudina on 4/11/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "Visitor+Methods.h"

@implementation Visitor (Methods)


+ (Visitor *)getVisitorFromDict: (NSDictionary *)dict ToContext: (NSManagedObjectContext *)context
{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Visitor"];
    NSString *searchID = [NSString stringWithFormat:@"%@", dict[@"contact"][@"id"]];
    NSLog(@"%@", searchID);
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier==%@",searchID];
    fetchRequest.predicate = searchPredicate;
    
    NSArray *visitors = [context executeFetchRequest:fetchRequest error:nil];
    
    if ([visitors count] == 0) {
        
        Visitor *newVisitor = [NSEntityDescription insertNewObjectForEntityForName:@"Visitor" inManagedObjectContext:context];
        
        newVisitor.firstName = [NSString stringWithFormat:@"%@", dict[@"contact"][@"first_name"]];
        
        if ([dict[@"contact"][@"last_name"] isEqual:[NSNull null]]) {
            
            newVisitor.lastName = @" ";
            
        } else {
            
            newVisitor.lastName = [NSString stringWithFormat:@"%@", dict[@"contact"][@"last_name"]];
        }
       
        newVisitor.phone = [NSString stringWithFormat:@"%@", dict[@"contact"][@"phone_number"]];
        newVisitor.email = [NSString stringWithFormat:@"%@", dict[@"contact"][@"email"]];
        newVisitor.identifier = [NSString stringWithFormat:@"%@", dict[@"contact"][@"id"]];
        
        
        return newVisitor;
        
    } else {
        
        //Event *ev = events[0];
        
        //NSLog(@"%@", ev.identifier);
        
        return visitors[0];
    }
    
}




@end
