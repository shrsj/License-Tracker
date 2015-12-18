//
//  editViewController.h
//  license_tracker
//
//  Created by Mac-Mini-2 on 11/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ViewAllController.h"


@interface editViewController : UIViewController

@property (nonatomic, strong) DBManager *model;

@property (weak, nonatomic) IBOutlet UIDatePicker *udatePicker;
@property (weak, nonatomic) IBOutlet UITextField *ulicenseName;
@property (weak, nonatomic) IBOutlet UILabel *ulicenseDate;

@property (weak,nonatomic) NSString *orgLicenseName;
@property (weak,nonatomic) NSString *orgExpiryDate;

@property (weak, nonatomic) IBOutlet UILabel *originalDetail1;
@property (weak, nonatomic) IBOutlet UILabel *originalDetailDate;

- (IBAction)pickerAction1:(UIDatePicker *)sender;
- (IBAction)update:(UIButton *)sender;
- (IBAction)ucancel:(id)sender;


@end
