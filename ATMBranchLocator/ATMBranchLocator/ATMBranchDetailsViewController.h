//
//  ATMBranchDetailsViewController.h
//  ATMBranchLocator
//
//  Created by Atul Bhagat on 13/08/15.
//  Copyright (c) 2015 Atul Bhagat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMBranchDetails.h"

@interface ATMBranchDetailsViewController : UIViewController

@property (nonatomic, weak) ATMBranchDetails *mATMBranchdetails;

@property (weak, nonatomic) IBOutlet UITextView *mATMBankDetailsTextView;

@end
