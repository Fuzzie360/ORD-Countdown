//
//  FlipsideViewController.m
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

#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate, enlistmentDatePicker, serviceDurationControl, stayInStayOutControl;
@synthesize adView, bannerIsVisible;

static NSString * const kADBannerViewClass = @"ADBannerView";

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];    
	
	// Load settings and set up the controls
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  
	if ([prefs objectForKey:@"EnlistmentDate"])
	{
		[enlistmentDatePicker setDate:[prefs objectForKey:@"EnlistmentDate"] animated:NO];
		if ([prefs boolForKey:@"isPTP"]) {
			[serviceDurationControl setSelectedSegmentIndex:1];
		} else {
			[serviceDurationControl setSelectedSegmentIndex:0];
		}
		if ([prefs boolForKey:@"isStayOut"]) {
			[stayInStayOutControl setSelectedSegmentIndex:1];
		} else {
			[stayInStayOutControl setSelectedSegmentIndex:0];
		}
	} else {
		[enlistmentDatePicker setDate:[NSDate date] animated:NO];
	}

	
	// Initialize ad banner if os supports it
	if (NSClassFromString(kADBannerViewClass) != nil) {
		if (self.adView == nil) {
			self.adView = [[[ADBannerView alloc] init] autorelease];
			self.adView.delegate = self;
			self.adView.frame = CGRectMake(0, -50, 320, 50);
			if (&ADBannerContentSizeIdentifierPortrait != nil) {
				// iOS>=4.2
				self.adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
			} else {
				// iOS<4.2 (deprecated)
				self.adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
			}

			[self.view addSubview:self.adView];
			[self.view sendSubviewToBack:self.adView]; 
		}
	}
}

- (BOOL)validate {
	// If the enlistment date is in the future, settings are invalid
	/*if ([[enlistmentDatePicker date] compare:[NSDate date]] == NSOrderedDescending) 
	{
		return NO;
	}*/
	
	return YES;
}
- (IBAction)done:(id)sender {
	// If settings are invalid, display error and prompt new settings
	if (![self validate]) {
		UIAlertView *invalidError = [[UIAlertView alloc] initWithTitle: @"Invalid settings" message: @"You have entered an invalid date." delegate: self cancelButtonTitle: @"Dismiss" otherButtonTitles: nil];
		[invalidError show];
		[invalidError release];
		return;
	}
	
	// If settings are valid, save them
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  
	[prefs setObject:[enlistmentDatePicker date] forKey:@"EnlistmentDate"];
	if ([serviceDurationControl selectedSegmentIndex] == 1) {
		[prefs setBool:YES forKey:@"isPTP"];
	} else {
		[prefs setBool:NO forKey:@"isPTP"];
	}
	if ([stayInStayOutControl selectedSegmentIndex] == 1) {
		[prefs setBool:YES forKey:@"isStayOut"];
	} else {
		[prefs setBool:NO forKey:@"isStayOut"];
	}
	[prefs setBool:YES forKey:@"isConfigured"];
	
	// ...and flip sides
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	if (!self.bannerIsVisible) {
		[UIView beginAnimations:nil context:NULL];
		banner.frame = CGRectOffset(banner.frame, 0, 94);
		[UIView commitAnimations];
		self.bannerIsVisible = YES;
	}
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	if (self.bannerIsVisible) {
		[UIView beginAnimations:nil context:NULL];
		banner.frame = CGRectOffset(banner.frame, 0, -50);
		[UIView commitAnimations];
		self.bannerIsVisible = NO;
	}
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewWillDisappear:(BOOL)animated {
	if (self.adView) {
		self.adView.delegate = nil;
		self.adView = nil;
		[self.adView removeFromSuperview];
	}
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
	[super dealloc];
}


@end
