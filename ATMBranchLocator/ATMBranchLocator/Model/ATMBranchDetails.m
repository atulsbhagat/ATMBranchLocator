//
//  ATMBranchDetails.m
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import "ATMBranchDetails.h"

@implementation ATMBranchDetails

-(id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

-(NSString *)getTitle
{
    return [[NSString stringWithFormat:@"%@ %@", self.mBankName, self.mLocationType] uppercaseString];
}

-(NSString *)getBankDetailsParagraph
{
    //Formatting can be improved/more fields can be added for display
    NSString *detailsString = [NSString stringWithFormat:@"Bank Name: %@\nBranch: %@\nType: %@\nATMs: %@\nAddress: %@\nCity: %@\nState: %@, %@\nPhone: %@\nDistance: %@", (self.mBankName ? self.mBankName : @"-"),
                               (self.mBranchName ? self.mBranchName : @"-"),
                               (self.mLocationType ? self.mLocationType : @"-"),
                               (self.mATMs ? self.mATMs : @"-"),
                               (self.mAddress ? self.mAddress : @"-"),
                               (self.mCity ? self.mCity : @"-"),
                               (self.mState ? self.mState : @"-"),
                               (self.mZip ? self.mZip : @"-"),
                               (self.mPhone ? self.mPhone : @"-"),
                               (self.mDistance ? self.mDistance : @"-")];
    
    return detailsString;
}

@end
