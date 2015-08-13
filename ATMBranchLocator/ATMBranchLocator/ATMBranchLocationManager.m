//
//  ATMBranchLocationManager.m
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import "ATMBranchLocationManager.h"
#import "AFNetworking.h"
#import "ATMBranchDetails.h"

@implementation ATMBranchLocationManager

+(ATMBranchLocationManager *)sharedATMBranchLocationManager
{
    static ATMBranchLocationManager *locationMgr = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        locationMgr = [[self alloc] init];
    });
    
    return locationMgr;
}

-(CLLocationManager *)mLocationManager
{
    if(!_mLocationManager)
    {
        _mLocationManager = [[CLLocationManager alloc] init];
        _mLocationManager.delegate = self;
    }
    
    return _mLocationManager;
}

-(id)init
{
    self = [super init];
    if(self)
    {
    }
    
    return self;
}

-(void)startFetchingCurrentLocation
{
    if(IOS_8_OR_LATER)
    {
        NSUInteger code = [CLLocationManager authorizationStatus];
        
        if(code == kCLAuthorizationStatusNotDetermined)
        {
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]
                && [self.mLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.mLocationManager requestAlwaysAuthorization];
            }
            else if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]
                && [self.mLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [self.mLocationManager requestWhenInUseAuthorization];
            }
        }
    }
    
    [self.mLocationManager startUpdatingLocation];
    self.mRetrievedCurrentLocation = NO;
}

#pragma mark - Location Manager

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];

    if(currentLocation != nil)
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(didUpdateWithCurrentLocation:withLongitude:)])
        {
            if(!self.mRetrievedCurrentLocation)
            {
                [self.mLocationManager stopUpdatingLocation];
                self.mRetrievedCurrentLocation = YES;
                
                [self.delegate didUpdateWithCurrentLocation:currentLocation.coordinate.latitude withLongitude:currentLocation.coordinate.longitude];
            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailCurrentLocationWithError:)])
    {
        [self.delegate didFailCurrentLocationWithError:error];
    }
}

#pragma mark - ATM/Branch List

- (void)startFetchingATMBranchesForLocation:(double)latitude longitude:(double)longitude
{
    NSString *string = [NSString stringWithFormat:@"%@?lat=%lf&lng=%lf", URL_ATM_BRANCH_LOCATION_SERVICE, latitude, longitude];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"%@", dict);
        
        //This can be done in separate thread in asynchronous fashion
        NSArray *atmBranchArray = [self getATMBranchesArray:dict];

        if(self.delegate && [self.delegate respondsToSelector:@selector(didUpdateWithATMBranchLocations:)])
        {
            [self.delegate didUpdateWithATMBranchLocations:atmBranchArray];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(didFailRetrievingATMBranchLocations:)])
        {
            [self.delegate didFailRetrievingATMBranchLocations:error];
        }
        
    }];
    
    [operation start];
}

-(NSArray *)getATMBranchesArray:(NSDictionary *)dict
{
    NSMutableArray *atmBranchesArray = [[NSMutableArray alloc] init];
    NSArray *array = dict[@"locations"];
    
    for (NSDictionary *modelDict in array)
    {
        ATMBranchDetails *model = [[ATMBranchDetails alloc] init];
        
        [model setMBankName:modelDict[BANK_NAME]];
        [model setMBranchName:modelDict[BANK_BRANCH_NAME]];
        [model setMLocationType:modelDict[BANK_LOC_TYPE]];
        [model setMAddress:modelDict[BANK_ADDRESS]];
        [model setMCity:modelDict[BANK_CITY]];
        [model setMZip:[NSString stringWithFormat:@"%@", modelDict[BANK_ZIP]]];
        [model setMState:modelDict[BANK_STATE]];
        [model setMLatitude:[modelDict[BANK_LATITUDE] doubleValue]];
        [model setMLongitude:[modelDict[BANK_LONGITUDE] doubleValue]];
        [model setMATMs:modelDict[BANK_ATMS]];
        [model setMPhone:modelDict[BANK_PHONE]];
        [model setMDistance:modelDict[BANK_DISTANCE]];
        
        [atmBranchesArray addObject:model];
    }
    
    return atmBranchesArray;
}

@end
