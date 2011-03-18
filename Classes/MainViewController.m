//
//  MainViewController.m
//  ORD Countdown
//
//  Created by Fuzzie on 2/12/11.
//  Copyright 2011 Fazli Sapuan
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MainViewController.h"


@implementation MainViewController

@synthesize daysWorkingLabel, daysHolidayLabel, daysORDLabel, bookoutsLeftLabel, percentCompleteLabel, leaveLabel, percentCompleteProgress;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  
	if ([prefs boolForKey:@"isConfigured"]) {  
		// If configured, calculate ORD information
		[self update];
	} else {
		// Else, flip to configuration side
		[self showInfo:nil];
	}
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (int)calculateWorkingDaysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	// Calculate number of days between dates
	NSDateComponents *difference = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit fromDate:fromDate toDate:toDate options:0];
	
	// Get what day of the week toDate is
	NSDateComponents *toDateComponents = [calendar components:NSWeekdayCalendarUnit fromDate:toDate];
	int toDateDay = [toDateComponents weekday];
	
	// For every 7 consecutive days, 5 days are weekdays
	int lengthInDays = ([difference day] / 7) * 5;
	
	// Sadly, not every number is divisible by 7
	int normalized;
	for (int i=0; i < [difference day]%7; i++) {
		// Normalize negative values
		normalized = toDateDay-1-i;
		while (normalized < 0)
			normalized += 7;
		
		// If this overflow day is a weekday, increment weekday count
		if (normalized > 1 && normalized< 7) {
			lengthInDays++;
		}
	}
	
	// Return final number of weekdays
	return lengthInDays;
}

- (void)update {
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	// Load settings
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  
	NSDate *enlistmentDate = [prefs objectForKey:@"EnlistmentDate"];
	BOOL isPTP = [prefs boolForKey:@"isPTP"];
	
	// Get todays date and remove time information
	NSDate *_now = [NSDate date];
	NSDateComponents *_nowComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:_now];
	NSDate *now = [calendar dateFromComponents:_nowComponents];
	
	// Calculate ORD date
	NSDateComponents *serviceDuration = [[[NSDateComponents alloc] init] autorelease];
	if (isPTP) {
		// PTP is 2 years
		[serviceDuration setYear:2];
	}else {
		// Normal is 1 year 10 months
		[serviceDuration setYear:1];
		[serviceDuration setMonth:10];
	}
	// ...minus 1 day
	NSDateComponents *minusOneDay = [[[NSDateComponents alloc] init] autorelease];
	[minusOneDay setDay:-1];
	NSDate *ORDDate = [calendar dateByAddingComponents:serviceDuration toDate:enlistmentDate options:0];
	
	ORDDate = [calendar dateByAddingComponents:minusOneDay toDate:ORDDate options:0];
	if ([ORDDate compare:[NSDate date]] == NSOrderedAscending) {
		// If NSMan ORDed no calculations are necessary
		[daysORDLabel setText:[NSString stringWithFormat:@"%d", 0]];
		[daysWorkingLabel setText:[NSString stringWithFormat:@"%d", 0]];
		[daysHolidayLabel setText:[NSString stringWithFormat:@"%d", 0]];
		[bookoutsLeftLabel setText:[NSString stringWithFormat:@"%d", 0]];
		[percentCompleteLabel setText:[NSString stringWithFormat:@"%d%%", 100]];
		[percentCompleteProgress setProgress:1];
		[leaveLabel setText:[NSString stringWithFormat:@"%d", 0]];
		
		return;
	} else if ([enlistmentDate compare:[NSDate date]] == NSOrderedDescending) {
		// If NSMan have not enlisted, calculations should use enlistment date to prevent negative values
		now = enlistmentDate;
	}
	// Get days to ORD 
	NSDateComponents *serviceLeftDays = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit fromDate:now toDate:ORDDate options:0];
	[daysORDLabel setText:[NSString stringWithFormat:@"%d", [serviceLeftDays day]]];
	
	// Calculate working days and weekends
	int workingDays = [self calculateWorkingDaysFromDate:now toDate:ORDDate];
	[daysWorkingLabel setText:[NSString stringWithFormat:@"%d", workingDays]];
	[daysHolidayLabel setText:[NSString stringWithFormat:@"%d", [serviceLeftDays day] - workingDays]];
	
	if ([prefs boolForKey:@"isStayOut"]) {
		// Estimate number of bookouts by assuming 1 bookout per work day
		[bookoutsLeftLabel setText:[NSString stringWithFormat:@"%d", workingDays]];
	}else {
		// Estimate number of bookouts by assuming 1 bookout per week
		NSDateComponents *serviceLeftWeeks = [calendar components:NSWeekCalendarUnit fromDate:now toDate:ORDDate options:0];
		[bookoutsLeftLabel setText:[NSString stringWithFormat:@"%d", [serviceLeftWeeks week]]];
	}

	// Calculate completion rate
	NSDateComponents *serviceDays = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit fromDate:enlistmentDate toDate:ORDDate options:0];
	[percentCompleteLabel setText:[NSString stringWithFormat:@"%d%%", 100 - [serviceLeftDays day]*100/[serviceDays day]]];
	[percentCompleteProgress setProgress:1 - (float)[serviceLeftDays day] / (float)[serviceDays day]];
	
	// Calculate this year's leave
	NSDateComponents *enlistmentYear = [calendar components:NSYearCalendarUnit fromDate:enlistmentDate];
	NSDateComponents *ordYear = [calendar components:NSYearCalendarUnit fromDate:ORDDate];
	NSDateComponents *thisYear = [calendar components:NSYearCalendarUnit fromDate:now];
	int leave;
	NSDateComponents *serviceDaysInCurrentYear;
	if ([thisYear year] == [enlistmentYear year]) {
		NSDateComponents *endOfYear = [[[NSDateComponents alloc] init] autorelease];
		[endOfYear setYear:[thisYear year]];
		[endOfYear setMonth:12];
		[endOfYear setDay:31];
		serviceDaysInCurrentYear = [calendar components:NSDayCalendarUnit fromDate:enlistmentDate toDate:[calendar dateFromComponents:endOfYear] options:0];
		leave = [serviceDaysInCurrentYear day]*14/365;
	} else if ([thisYear year] == [ordYear year]) {
		NSDateComponents *startOfYear = [[[NSDateComponents alloc] init] autorelease];
		[startOfYear setYear:[thisYear year]];
		[startOfYear setMonth:1];
		[startOfYear setDay:1];
		serviceDaysInCurrentYear = [calendar components:NSDayCalendarUnit fromDate:[calendar dateFromComponents:startOfYear] toDate:ORDDate options:0];
		leave = [serviceDaysInCurrentYear day]*14/365;
	} else {
		leave = 14;
	}
	[leaveLabel setText:[NSString stringWithFormat:@"%d", leave]];
}

- (IBAction)showInfo:(id)sender {    
	//Flip to other side with animation
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dealloc {
	[super dealloc];
}


@end
