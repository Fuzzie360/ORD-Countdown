//
//  FlipsideViewController.h
//  ORD Countdown
//
//  Created by Fuzzie on 2/12/11.
//  Copyright 2011 Fuzzie. All rights reserved.
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
