//
//  MainViewController.h
//  ORD Countdown
//
//  Created by Fuzzie on 2/12/11.
//  Copyright 2011 Fazli Sapuan
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
