//
//  editViewController.m
//  license_tracker
//
//  Created by Mac-Mini-2 on 11/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import "editViewController.h"


@interface editViewController ()

@end
NSString *formatedDate1;
@implementation editViewController

-(DBManager *) model
{
    if (!_model) {
        _model = [[DBManager alloc] init];
    }
    return _model;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.originalDetail1.text = self.orgLicenseName;
    self.originalDetailDate.text = self.orgExpiryDate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pickerAction1:(UIDatePicker *)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    formatedDate1 = [dateFormat stringFromDate:self.udatePicker.date];
    self.ulicenseDate.text = formatedDate1;
}


- (IBAction)update:(id)sender {
    
    if([self.ulicenseName.text isEqual:@""])
    {
        [self displayAlert:@"Please enter License name!"];
    }
    else
    {
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:self.udatePicker.date];
        if(result == 1)
        {
            
            [self displayAlert:@"Invalid Expiry Date! Please select future date."];
            
        }
        else{
            [self Notify];
            int value=  [self.model updateLicense:self.orgLicenseName expiryDate:self.orgExpiryDate  uLicenseName:self.ulicenseName.text uExpiryDate:formatedDate1 ];
            if(value == 1)
            {
                [self displayAlert:@"Data entered succesfully."];
                self.ulicenseDate.text = @"";
                self.ulicenseName.text = @"";
                [self.udatePicker setDate:[NSDate date]];
            }
        }
    }
}

- (IBAction)ucancel:(id)sender {
    [self.udatePicker setDate:[NSDate date]];
    [self.ulicenseName setText:nil];
    //UIViewController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"viewAll"];
    //[self showViewController:monitorMenuViewController sender:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



-(void) Notify
{
    NSDate *fireDate = [[NSDate alloc] init];
    fireDate = self.udatePicker.date;
    NSLog(@"The original date is %@",fireDate);
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate: fireDate ];
    [dateComp setHour: -24];
    [dateComp setMinute:0];
    [dateComp setSecond:+20];
    
    
    NSDate *dd = [cal dateByAddingComponents:dateComp toDate: fireDate options:0];
    NSLog(@"The modified date is %@",dd);
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    [notification setFireDate:dd];
    
    NSString *alert1 = @"Hi ";
    alert1 = [alert1 stringByAppendingString:self.ulicenseName.text];
    alert1 = [alert1 stringByAppendingString:@" Will Expire Tomorrow"];
    [notification setAlertBody:alert1];
    [notification setAlertAction:@"View in App"];
    NSUInteger nextBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count] + 1;
    [notification setApplicationIconBadgeNumber: nextBadgeNumber];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSString *display = [NSDateFormatter localizedStringFromDate:dd dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
    self.ulicenseDate.text = display;
}



-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.ulicenseName endEditing:YES];
}

@end
