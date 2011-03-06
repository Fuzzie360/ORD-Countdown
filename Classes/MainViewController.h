//
//  MainViewController.h
//  ORD Countdown
//
//  Created by Fuzzie on 2/12/11.
//  Copyright 2011 Fuzzie. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	
}

@property (nonatomic, retain) IBOutlet UILabel *daysWorkingLabel;
@property (nonatomic, retain) IBOutlet UILabel *daysHolidayLabel;
@property (nonatomic, retain) IBOutlet UILabel *daysORDLabel;
@property (nonatomic, retain) IBOutlet UILabel *bookoutsLeftLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentCompleteLabel;
@property (nonatomic, retain) IBOutlet UILabel *leaveLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *percentCompleteProgress;

- (IBAction)showInfo:(id)sender;
- (void)update;
- (int)calculateWorkingDaysFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;
@end
