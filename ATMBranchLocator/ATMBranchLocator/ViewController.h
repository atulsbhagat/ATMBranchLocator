//
//  ViewController.h
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 12/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ATMBranchLocatorDelegate.h"

typedef enum
{
    MAP_MODE_STANDARD,
    MAP_MODE_SATELLITE,
    MAP_MODE_HYBRID
}ATMBranchMapMode;

@interface ViewController : UIViewController <MKMapViewDelegate, ATMBranchLocatorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *mWaitLbl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mWaitActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *mSearchAgainButton;

@property (weak, nonatomic) IBOutlet MKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mMapModeSegmentedControl;

- (IBAction)onATMBranchMapModeChanged:(id)sender;
- (IBAction)onSearchAgainClicked:(id)sender;

@end

