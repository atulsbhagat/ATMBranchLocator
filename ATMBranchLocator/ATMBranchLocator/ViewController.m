//
//  ViewController.m
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 12/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import "ViewController.h"
#import "ATMBranchAnnotation.h"
#import "ATMBranchLocationManager.h"
#import "AFNetworking.h"
#import "ATMBranchDetails.h"
#import "ATMBranchDetailsViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *mATMBranchLocationsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _mMapView.delegate = self;
    [self setMapMode:MAP_MODE_STANDARD];
    
    [self retrieveCurrentLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location

-(void)retrieveCurrentLocation
{
    ATMBranchLocationManager *locationManager = [ATMBranchLocationManager sharedATMBranchLocationManager];
    locationManager.delegate = self;
    [locationManager startFetchingCurrentLocation];
}

-(void)didUpdateWithCurrentLocation:(double)latitude withLongitude:(double)longitude
{
    //hardcoded text can be removed
    [self.mWaitLbl setText:@"Locating ATM/Branches. Please wait..."];
    
    [self retrieveATMBranchLocationsForLocation:latitude withLongitude:longitude];
}

-(void)didFailCurrentLocationWithError:(NSError *)error
{
    //Below 3 lines can be added to a generic method
    [self.mSearchAgainButton setHidden:NO];
    [self.mWaitActivityIndicator stopAnimating];
    [self.mWaitLbl setText:@"Some error occurred"]; //hardcoded text can be removed
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error in retrieving your current location. Please try later."
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - ATM/Branch Location

-(void)retrieveATMBranchLocationsForLocation:(double)latitude withLongitude:(double)longitude
{
    ATMBranchLocationManager *locationManager = [ATMBranchLocationManager sharedATMBranchLocationManager];
    locationManager.delegate = self;
    [locationManager startFetchingATMBranchesForLocation:latitude longitude:longitude];
}

-(void)didUpdateWithATMBranchLocations:(NSArray *)atmBranchLocationsArray
{
    [self showMapView];
    
    //This method can be optimized further
    [self showATMBranchLocationsOnMap:(NSArray *)atmBranchLocationsArray];
}

-(void)didFailRetrievingATMBranchLocations:(NSError *)error
{
    //Below 3 lines can be added to a generic method
    [self.mSearchAgainButton setHidden:NO];
    [self.mWaitActivityIndicator stopAnimating];
    [self.mWaitLbl setText:@"Some error occurred"]; //hardcoded text can be removed
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error in retrieving ATM/Branch locations. Please try later."
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - mapView

-(void)showMapView
{
    [self.mWaitLbl setHidden:YES];
    [self.mWaitActivityIndicator stopAnimating];
    
    [self.mMapView setHidden:NO];
    [self.mMapModeSegmentedControl setHidden:NO];
}

-(void)showATMBranchLocationsOnMap:(NSArray *)atmBranchLocationsArray
{
    int annotationTag = 0;
    self.mATMBranchLocationsArray = atmBranchLocationsArray;
    
    for (ATMBranchDetails *atmBranchDetail in atmBranchLocationsArray)
    {
        [self addATMBranchMapAnnotation:[atmBranchDetail mLocationType] withLatitude:[atmBranchDetail mLatitude] withLongitude:[atmBranchDetail mLongitude] withTag:annotationTag++];
    }
}

-(void)addATMBranchMapAnnotation:(NSString *)title
                    withLatitude:(double)latitude
                   withLongitude:(double)longitude
                         withTag:(int)tag
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    
    ATMBranchAnnotation *newAnnotation = [[ATMBranchAnnotation alloc] initWithTitle:title withCoordinate:coordinate withTag:tag];
    [self.mMapView addAnnotation:newAnnotation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reusableAnnotationId = @"reuseAnnId";
    
    MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusableAnnotationId];
    if(view == nil)
    {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusableAnnotationId];
        view.animatesDrop = YES;
        view.canShowCallout = YES;
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        view.rightCalloutAccessoryView = detailButton;
        
        ATMBranchAnnotation *atmbranchAnn = (ATMBranchAnnotation *)annotation;
        [view setTag:[atmbranchAnn tag]];
    }
    else
    {
        view.annotation = annotation;
    }
    
    return view;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    int index = [view tag];
    
    ATMBranchDetailsViewController *ctrl = [[ATMBranchDetailsViewController alloc] initWithNibName:@"ATMBranchDetailsViewController" bundle:nil];
    ctrl.mATMBranchdetails = self.mATMBranchLocationsArray[index];
    
    [[self navigationController] pushViewController:ctrl animated:YES];
}

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id<MKAnnotation> mp = [annotationView annotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
    [mapView setRegion:region animated:YES];
    [mapView selectAnnotation:mp animated:YES];
}

#pragma mark - Other

- (IBAction)onATMBranchMapModeChanged:(id)sender
{
    int selectedIndex = [(UISegmentedControl *)sender selectedSegmentIndex];
    [self setMapMode:selectedIndex];
}

- (IBAction)onSearchAgainClicked:(id)sender
{
    //hardcoded text can be removed
    [self.mWaitLbl setText:@"Getting current location, Please wait..."];
    [self.mSearchAgainButton setHidden:YES];
    [self.mWaitActivityIndicator startAnimating];
    
    [self retrieveCurrentLocation];
}

- (void)setMapMode:(ATMBranchMapMode)mapMode
{
    if(mapMode == MAP_MODE_STANDARD)
    {
        [self.mMapView setMapType:MKMapTypeStandard];
        return;
    }
    
    if(mapMode == MAP_MODE_SATELLITE)
    {
        [self.mMapView setMapType:MKMapTypeSatellite];
        return;
    }
    
    [self.mMapView setMapType:MKMapTypeHybrid];
}

@end
