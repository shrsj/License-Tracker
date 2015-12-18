//
//  AddNewEntryController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ViewController.h"
#import "ViewAllController.h"

@interface AddNewEntryController : UIViewController
@property (nonatomic, strong) DBManager *model;
@property (weak, nonatomic) IBOutlet UITextField *licenseName;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;


- (IBAction)pickerAction:(id)sender;
- (IBAction)save:(UIButton *)sender;
- (IBAction)cancel:(UIButton *)sender;


@end
