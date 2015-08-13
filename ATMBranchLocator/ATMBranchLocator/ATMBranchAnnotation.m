//
//  ATMBranchAnnotation.m
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import "ATMBranchAnnotation.h"

@implementation ATMBranchAnnotation

-(id)initWithTitle:(NSString *)title withCoordinate:(CLLocationCoordinate2D)coordinate withTag:(int)tag
{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.coordinate = coordinate;
        self.tag = tag;
    }
    
    return self;
}

@end
