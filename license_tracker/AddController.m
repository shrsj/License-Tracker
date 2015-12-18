//
//  AddNewEntryController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "AddController.h"

@interface AddNewEntryController ()

@end
NSString *formatedDate;
@implementation AddNewEntryController

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pickerAction:(id)sender {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    formatedDate = [dateFormat stringFromDate:self.datePicker.date];
}

- (IBAction)save:(UIButton *)sender {
    if([self.licenseName.text isEqual:@""])
    {
        [self displayAlert:@"Please enter License name!"];
    }
    else
    {
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:self.datePicker.date];
        
        if(result == 1)
        {
            [self displayAlert:@"Invalid Expiry Date! Please select future date."];
            
        }
        else{
            [self Notify];
            int value=  [self.model addLicense:self.licenseName.text expiryDate:formatedDate];
            if(value == 1)
            {
                [self displayAlert:@"Data entered succesfully."];
                self.licenseName.text = @"";
                [self.datePicker setDate:[NSDate date]];
            }
        }
    }
}

- (IBAction)cancel:(UIButton *)sender
{
    [self.datePicker setDate:[NSDate date]];
    [self.licenseName setText:nil];
}

-(void) Notify
{
    NSDate *fireDate = [[NSDate alloc] init];
    fireDate = self.datePicker.date;
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
    alert1 = [alert1 stringByAppendingString:self.licenseName.text];
    alert1 = [alert1 stringByAppendingString:@" Will Expire Tomorrow"];
    [notification setAlertBody:alert1];
    [notification setAlertAction:@"View in App"];
    
    
    NSUInteger nextBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count] + 1;
    [notification setApplicationIconBadgeNumber: nextBadgeNumber];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    //NSString * display = [NSDateFormatter localizedStringFromDate:dd dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
    
}





-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.licenseName endEditing:YES];
}


@end
