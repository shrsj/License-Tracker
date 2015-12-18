//
//  ViewAllLicenseController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 04/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "ViewAllController.h"
#import "editViewController.h"

@interface ViewAllLicenseController ()
{
    NSMutableArray *tableData1, *tableData2;
    int lastOfIndex, rownum;
    int count;
}
@end

@implementation ViewAllLicenseController
@synthesize searchLicense,filteredNames, filteredDates, isFiltered;

#pragma mark database

-(DBManager *) model
{
    if(!_model)
    {
        _model = [[DBManager alloc]init];
    }
    return _model;
}

#pragma mark - UITableView Delegate Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableData1 count]==0)
    {
        self.tblViewAllLicense.hidden =  YES;
        self.tblViewAllLicense.hidden = YES;
    }
    else if (isFiltered == YES)
    {
        self.tblViewAllLicense.hidden=NO;
        return filteredNames.count;
    }
    else
    {
        return [tableData1 count];
    }
    return [tableData1 count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if (isFiltered == YES) {
        
        for(UIView *eachView in [cell subviews])
            [eachView removeFromSuperview];
        
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(50,0,200,60)];
        [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
        [lbl1 setTextColor:[UIColor grayColor]];
        lbl1.text = [filteredNames objectAtIndex:indexPath.row];
        [cell addSubview:lbl1];
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(230,0,300,60)];
        [lbl2 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
        [lbl2 setTextColor:[UIColor blackColor]];
        lbl2.text = [filteredDates objectAtIndex:indexPath.row];
        [cell addSubview:lbl2];
        
    }
    else
    {
        for(UIView *eachView in [cell subviews])
            [eachView removeFromSuperview];
        
        
        UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(50,0,200,60)];
        [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
        [lbl1 setTextColor:[UIColor grayColor]];
        lbl1.text = [tableData1 objectAtIndex:indexPath.row];
        [cell addSubview:lbl1];
        
        
        UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(180,0,300,60)];
        [lbl2 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
        [lbl2 setTextColor:[UIColor blackColor]];
        lbl2.text = [tableData2 objectAtIndex:indexPath.row];
        [cell addSubview:lbl2];
        
    }
    /*
     for(UIView *eachView in [cell subviews])
     [eachView removeFromSuperview];
     
     
     UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(50,0,200,60)];
     [lbl1 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
     [lbl1 setTextColor:[UIColor grayColor]];
     lbl1.text = [tableData1 objectAtIndex:indexPath.row];
     [cell addSubview:lbl1];
     
     
     UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(230,0,300,60)];
     [lbl2 setFont:[UIFont fontWithName:@"FontName" size:12.0]];
     [lbl2 setTextColor:[UIColor blackColor]];
     lbl2.text = [tableData2 objectAtIndex:indexPath.row];
     [cell addSubview:lbl2];
     
     */
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if(count == 1)
    {
        if (isFiltered == YES) {
            editViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editViewController"];
            editVC.orgLicenseName = [filteredNames objectAtIndex:indexPath.row];
            editVC.orgExpiryDate = [filteredDates objectAtIndex:indexPath.row];
            [self.navigationController showViewController:editVC sender:self];
        }
        else
        {
            editViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editViewController"];
            editVC.orgLicenseName = [tableData1 objectAtIndex:indexPath.row];
            editVC.orgExpiryDate = [tableData2 objectAtIndex:indexPath.row];
            [self.navigationController showViewController:editVC sender:self];
        }
    }
    if (isFiltered == YES) {
        editViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editViewController"];
        editVC.orgLicenseName = [filteredNames objectAtIndex:indexPath.row];
        editVC.orgExpiryDate = [filteredDates objectAtIndex:indexPath.row];
        [self.navigationController showViewController:editVC sender:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (count == 1) {
        
        editingStyle = UITableViewCellEditingStyleDelete;
    }
    else
    {
        editingStyle = UITableViewCellEditingStyleNone;
    }
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self displayConfirmation];
        NSInteger row = indexPath.row;
        lastOfIndex = (int)row;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        [self.tblViewAllLicense reloadData];
    }else if(buttonIndex == 1)
    {
        int val=(int)lastOfIndex;
        NSString *value1=  [tableData1 objectAtIndex:val];
        NSString *value2=  [tableData2 objectAtIndex:val];
        int deltedValue =[self.model deleteLicense:value1 expiryDate:value2];
        if(deltedValue == 1)
        {
            [self displayAllLicenses];
            [self.tblViewAllLicense reloadData];
        }
    }
}


#pragma mark - SearchBar Delegate Methods.

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        //Set boolean flag
        isFiltered = NO;
    }
    else
    {
        isFiltered = YES;
        filteredNames = [[NSMutableArray alloc] init];
        filteredDates = [[NSMutableArray alloc] init];
        //fast enumeration
        for (NSString *licenseName in tableData1)
        {
            NSRange licenseRange = [licenseName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (licenseRange.location != NSNotFound) {
                [filteredNames addObject:licenseName];
                NSInteger row1 = [tableData1 indexOfObject:licenseName];
                [filteredDates addObject:tableData2[row1]];
                NSLog(@"These are filtered dates : %@",filteredDates);
            }
        }
    }
    //Reload the table view
    [self.tblViewAllLicense reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


#pragma mark View functions

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayAllLicenses];
    self.tblViewAllLicense.delegate = self;
    self.tblViewAllLicense.dataSource = self;
    
    //alloc and initialise objects
    
    // Hide the search bar until user scrolls up
    CGRect newBounds = [[self tblViewAllLicense] bounds];
    newBounds.origin.y = newBounds.origin.y + searchLicense.bounds.size.height;
    [[self tblViewAllLicense] setBounds:newBounds];
    self.searchLicense.hidden = YES;
    
    //Pan gesture initialisation
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate =self;
    [self.view addGestureRecognizer:panGesture];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UI Pan gesture

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:gesture.view];
    if (translation.y >15) {
        self.searchLicense.hidden = NO;
    }
}



#pragma mark display functions

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


#pragma mark confirmation/alert functions

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

#pragma mark Edit functions

- (IBAction)editCell:(UIButton *)sender {
    count = count +1;
    NSLog(@"the count is : %d",count );
    if(count == 1)
    {
        [_tblViewAllLicense setEditing:YES animated:YES];
        _tblViewAllLicense.allowsSelectionDuringEditing = YES;
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.editButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if (count == 2)
    {
        [_tblViewAllLicense setEditing:NO animated:YES];
        _tblViewAllLicense.allowsSelectionDuringEditing = NO;
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        count = 0;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchLicense endEditing:YES];
}

@end
