//
//  AddNewVisitorVC.h
//  ShortPath
//
//  Created by Bram Vandevelde on 2014-04-05.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+Methods.h"
#import "Location+Methods.h"

@interface AddNewVisitorVC : UITableViewController

@property (strong, nonatomic) Event *event;
@property (strong, nonatomic) Location *location;

@end
