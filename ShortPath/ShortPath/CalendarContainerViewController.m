//
//  CalendarContainerViewController.m
//  ShortPath
//
//  Created by Dare Ryan on 4/4/14.
//  Copyright (c) 2014 Eugene Watson. All rights reserved.
//

#import "CalendarContainerViewController.h"
#import <TapkuLibrary/NSDate+TKCategory.h>
#import "ShortPathDataStore.h"
#import "Event+Methods.h"

@interface CalendarContainerViewController ()

@property (strong, nonatomic) ShortPathDataStore *dataStore;

@property (strong, nonatomic) NSArray *events;


@end

@implementation CalendarContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.calendar.delegate = self;
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.dataStore = [ShortPathDataStore sharedDataStore];
    
    NSFetchRequest *requestEvents = [[NSFetchRequest alloc]initWithEntityName:@"Event"];
    
    self.events = [self.dataStore.managedObjectContext executeFetchRequest:requestEvents error:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.calendar = [[TKCalendarMonthView alloc] init];
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    
    [self.view addSubview:self.calendar];
    
    
    
    //NSLog(@"Events for user: %d", [self.events count]);
    // Do any additional setup after loading the view.
    
}

#pragma mark - TKCalendarMonthViewDelegate methods

- (void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)d {

    NSDictionary *dateDict = [[NSDictionary alloc]initWithObjectsAndKeys:d, @"date",nil];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dateNotif" object:nil userInfo:dateDict];
    
	NSLog(@"calendarMonthView didSelectDate %@", d);
}

- (void)calendarMonthView:(TKCalendarMonthView *)monthView monthDidChange:(NSDate *)d {
	NSLog(@"calendarMonthView monthDidChange");
}


#pragma mark - TKCalendarMonthViewDataSource methods

- (NSArray*)calendarMonthView:(TKCalendarMonthView *)monthView marksFromDate:(NSDate *)startDate toDate:(NSDate *)lastDate {
	NSLog(@"calendarMonthView marksFromDate toDate");
	NSLog(@"Make sure to update 'data' variable to pull from CoreData, website, User Defaults, or some other source.");
	// When testing initially you will have to update the dates in this array so they are visible at the
	// time frame you are testing the code.
	//NSArray *data = @[[NSDate date], [NSDate dateWithTimeIntervalSince1970:1397144655], [NSDate dateWithTimeIntervalSince1970:1397100000]];
    
    NSMutableArray *data = [[NSMutableArray alloc]init];
    
    for (Event *event in self.events) {
        
        [data addObject:event.start];
    }

	
    
	// Initialise empty marks array, this will be populated with TRUE/FALSE in order for each day a marker should be placed on.
	NSMutableArray *marks = [NSMutableArray array];
	
	// Initialise calendar to current type and set the timezone to never have daylight saving
	NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone defaultTimeZone]];
	//[cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
	
	// Construct DateComponents based on startDate so the iterating date can be created.
	// Its massively important to do this assigning via the NSCalendar and NSDateComponents because of daylight saving has been removed
	// with the timezone that was set above. If you just used "startDate" directly (ie, NSDate *date = startDate;) as the first
	// iterating date then times would go up and down based on daylight savings.
	NSDateComponents *comp = [cal components:(NSCalendarUnitMonth | NSCalendarUnitMinute| NSCalendarUnitYear |
                                              NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitSecond)
                                    fromDate:startDate];
	NSDate *d = [cal dateFromComponents:comp];
	
	// Init offset components to increment days in the loop by one each time
	NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
	[offsetComponents setDay:1];
	
    
	// for each date between start date and end date check if they exist in the data array
	while (YES) {
		// Is the date beyond the last date? If so, exit the loop.
		// NSOrderedDescending = the left value is greater than the right
		if ([d compare:lastDate] == NSOrderedDescending) {
			break;
		}
		NSIndexSet *indexes=[data indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            NSDate *date = (NSDate *)obj;
            return [date isSameDay:d];
        }];
		// If the date is in the data array, add it to the marks array, else don't
		if ([indexes count]>0) {
			[marks addObject:[NSNumber numberWithBool:YES]];
		} else {
			[marks addObject:[NSNumber numberWithBool:NO]];
		}
		
		// Increment day using offset components (ie, 1 day in this instance)
		d = [cal dateByAddingComponents:offsetComponents toDate:d options:0];
	}
	
	return [NSArray arrayWithArray:marks];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
