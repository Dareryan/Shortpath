//
//  VisitorsVC.h
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-04.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+Methods.h"
#import "Location+Methods.h"

@interface VisitorsVC : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Location *location;
@property (strong, nonatomic) NSString *visitorIDString;

@end
