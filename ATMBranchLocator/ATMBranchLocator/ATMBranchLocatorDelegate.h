//
//  ATMBranchLocatorDelegate.h
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ATMBranchLocatorDelegate <NSObject>

-(void)didUpdateWithCurrentLocation:(double)latitude withLongitude:(double)longitude;
-(void)didFailCurrentLocationWithError:(NSError *)error;

-(void)didUpdateWithATMBranchLocations:(NSArray *)atmBranchLocationsArray;
-(void)didFailRetrievingATMBranchLocations:(NSError *)error;

@end
