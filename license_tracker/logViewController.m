//
//  logViewController.m
//  license_tracker
//
//  Created by Mac-Mini-2 on 16/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import "logViewController.h"

@interface logViewController ()
{
    NSMutableArray *tableData1, *tableData2;
    int lastOfIndex;
    int count;
}

@end

@implementation logViewController

-(DBManager *) model
{
    if(!_model)
    {
        _model = [[DBManager alloc]init];
    }
    return _model;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableData1 count]==0)
    {
        self.tableLog.hidden =  YES;
        self.tableLog.hidden = YES;
    }
    else{
        self.tableLog.hidden=NO;
        
    }
    return [tableData1 count];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self displayAllLogs];
    self.tableLog.delegate = self;
    self.tableLog.dataSource = self;
    
    //TOdays date
    NSDate *todaysDate = [NSDate date];
    NSString *formatedDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"eeee \n HH:MM a | MMMM dd,yyyy"];
    
    dateFormat.timeStyle = NSDateFormatterMediumStyle;
    dateFormat.dateStyle = NSDateFormatterLongStyle;
    formatedDate = [dateFormat stringFromDate:todaysDate];
    self.todaysDate.text = formatedDate;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"logCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    
    for(UIView *eachView in [cell subviews])
        [eachView removeFromSuperview];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0,0,400,50)];
    [lbl1 setFont:[UIFont fontWithName:@"FontName" size:8.0]];
    [lbl1 setTextColor:[UIColor grayColor]];
    lbl1.text = [tableData1 objectAtIndex:indexPath.row];
    [cell addSubview:lbl1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    editingStyle = UITableViewCellEditingStyleNone;
}
/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 if(buttonIndex == 0)
 {
 [self.tableLog reloadData];
 }else if(buttonIndex == 1)
 {
 int val=(int)lastOfIndex;
 NSString *value1=  [tableData1 objectAtIndex:val];
 
 int deltedValue =[self.model deleteLicense:value1 expiryDate:value2];
 if(deltedValue == 1)
 {
 [self logDisplay];
 [self.tableLog reloadData];
 }
 }
 }
 */

-(void) displayAllLogs
{
    NSArray *logList = [[NSArray alloc]init];
    logList =[self.model allLogList];
    if([logList count]==0)
    {
        [self displayAlert:@"License log Is Empty"];
        
    }
    else
    {
        tableData1 = [[NSMutableArray alloc]initWithArray:logList];
    }
}

-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"License Expiry Tracker" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}

-(void) displayConfirmation
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"License Expiry Tracker" message:@"Are you sure you want to delete?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alert show];
}


- (IBAction)logTime:(UIButton *)sender {
    NSDate *log = [NSDate date];
    NSLog(@"date is  %@",log);
    
    NSString * loggedDate = [[NSString alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormat setDateFormat:@"eeee dd MMMM, yyyy HH:mm a"];
    loggedDate = [dateFormat stringFromDate: log];
    NSLog(@"logged date is : %@",loggedDate);
    
    int value =  [self.model addLog:loggedDate];
    if(value == 1)
    {
        [self displayAlert:@"Time logged succesfully."];
    }
}

#pragma mark UI buttons

@end
