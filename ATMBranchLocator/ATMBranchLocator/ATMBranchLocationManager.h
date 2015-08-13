//
//  ATMBranchLocationManager.h
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "ATMBranchLocatorDelegate.h"

#define IOS_8_OR_LATER      ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define URL_ATM_BRANCH_LOCATION_SERVICE        @"https://m.chase.com/PSRWeb/location/list.action"

@interface ATMBranchLocationManager : NSObject <CLLocationManagerDelegate>
{
    
}

@property (nonatomic, strong) CLLocationManager *mLocationManager;
@property (nonatomic, assign) BOOL mRetrievedCurrentLocation;
@property (nonatomic, weak) id<ATMBranchLocatorDelegate> delegate;

+ (ATMBranchLocationManager *)sharedATMBranchLocationManager;
- (void)startFetchingCurrentLocation;
- (void)startFetchingATMBranchesForLocation:(double)latitude longitude:(double)longitude;

@end
