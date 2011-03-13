//
//  FlipsideViewController.h
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

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController <ADBannerViewDelegate> {
	id <FlipsideViewControllerDelegate> delegate;
	
	ADBannerView *adView;
	BOOL bannerIsVisible;
}

@property(nonatomic, retain) ADBannerView *adView;
@property(nonatomic, assign) BOOL bannerIsVisible;

@property (nonatomic, retain) IBOutlet UIDatePicker *enlistmentDatePicker;
@property (nonatomic, retain) IBOutlet UISegmentedControl *serviceDurationControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *stayInStayOutControl;

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
- (BOOL)validate;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
