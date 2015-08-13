//
//  ATMBranchDetails.h
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BANK_NAME                   @"bank"
#define BANK_BRANCH_NAME            @"name"
#define BANK_LOC_TYPE               @"locType"
#define BANK_ADDRESS                @"address"
#define BANK_CITY                   @"city"
#define BANK_ZIP                    @"zip"
#define BANK_STATE                  @"state"
#define BANK_LATITUDE               @"lat"
#define BANK_LONGITUDE              @"lng"
#define BANK_ATMS                   @"atms"
#define BANK_PHONE                  @"phone"
#define BANK_DISTANCE               @"distance"

@interface ATMBranchDetails : NSObject

@property (nonatomic, strong) NSString *mBankName;
@property (nonatomic, strong) NSString *mBranchName;
@property (nonatomic, strong) NSString *mLocationType;
@property (nonatomic, strong) NSString *mAddress;
@property (nonatomic, strong) NSString *mCity;
@property (nonatomic, strong) NSString *mZip;
@property (nonatomic, strong) NSString *mState;
@property (nonatomic, assign) double mLatitude;
@property (nonatomic, assign) double mLongitude;
@property (nonatomic, strong) NSString *mATMs;
@property (nonatomic, strong) NSString *mPhone;
@property (nonatomic, strong) NSString *mDistance;

-(NSString *)getBankDetailsParagraph;
-(NSString *)getTitle;

@end
