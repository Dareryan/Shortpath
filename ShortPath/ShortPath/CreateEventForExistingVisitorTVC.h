//
//  CreateEventForExistingVisitorTVC.h
//  ShortPath
//
//  Created by Dare Ryan on 4/10/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Visitor+Methods.h"

@interface CreateEventForExistingVisitorTVC : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) Visitor *visitor;

@end
