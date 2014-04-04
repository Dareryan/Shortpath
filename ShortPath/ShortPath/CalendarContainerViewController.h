//
//  CalendarContainerViewController.h
//  ShortPath
//
//  Created by Dare Ryan on 4/4/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>

@interface CalendarContainerViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource>

@property (strong, nonatomic) TKCalendarMonthView *calendar;

@end
