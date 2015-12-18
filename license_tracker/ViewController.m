//
//  ViewController.m
//  license_tracker
//
//  Created by shravan on 06/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *tableData1, *tableData2;
    int lastOfIndex;
}


@end

@implementation ViewController

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
        self.utblView.hidden =  YES;
        self.utblView.hidden = YES;
    }
    else{
        self.utblView.hidden=NO;
        
    }
    return [tableData1 count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    
    for(UIView *eachView in [cell subviews])
        [eachView removeFromSuperview];
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(10,0,300,60)];
    [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
    [lbl1 setTextColor:[UIColor grayColor]];
    lbl1.text = [tableData1 objectAtIndex:indexPath.row];
    [cell addSubview:lbl1];
    
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(150,0,300,60)];
    [lbl2 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
    [lbl2 setTextColor:[UIColor blackColor]];
    lbl2.text = [tableData2 objectAtIndex:indexPath.row];
    [cell addSubview:lbl2];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self displayConfirmation];
        NSInteger row = indexPath.row;
        lastOfIndex = (int)row;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        [self.utblView reloadData];
    }else if(buttonIndex == 1)
    {
        int val=(int)lastOfIndex;
        NSString *value1=  [tableData1 objectAtIndex:val];
        NSString *value2=  [tableData2 objectAtIndex:val];
        int deltedValue =[self.model deleteLicense:value1 expiryDate:value2];
        if(deltedValue == 1)
        {
            [self displayAllLicenses];
            [self.utblView reloadData];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self displayAllLicenses];
    self.utblView.delegate = self;
    self.utblView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) displayAllLicenses
{
    NSDictionary *licenseList = [[NSDictionary alloc]init];
    licenseList =[self.model allLicenseList];
    //NSLog(@"Dictiopnary=%@",licenseList);
    NSArray *dictionaryKeys = [licenseList allKeys];
    NSArray *dictionaryValues = [licenseList allValues];
    if([dictionaryKeys count]==0)
    {
        [self displayAlert:@"License list Is Empty"];
        
    }
    else
    {
        tableData1 = [[NSMutableArray alloc]initWithArray:dictionaryKeys];
        tableData2 =[[NSMutableArray alloc]initWithArray:dictionaryValues];
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

- (IBAction)viewLog:(UIButton *)sender {
    UIViewController *monitorMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"logView"];
    [self presentViewController:monitorMenuViewController animated:YES completion:nil];
}


@end
