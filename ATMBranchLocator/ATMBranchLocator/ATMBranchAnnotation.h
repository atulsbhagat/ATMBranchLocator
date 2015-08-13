//
//  ATMBranchAnnotation.h
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ATMBranchAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) int tag;

-(id)initWithTitle:(NSString *)title withCoordinate:(CLLocationCoordinate2D)coordinate withTag:(int)tag;

@end
