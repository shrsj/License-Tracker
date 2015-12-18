//
//  ViewAllLicenseController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 04/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "AddController.h"
#import "editViewController.h"


@interface ViewAllLicenseController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) DBManager *model;
@property (weak, nonatomic) IBOutlet UITableView *tblViewAllLicense;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchLicense;


@property (weak,nonatomic) NSMutableArray *initialEntries;
@property (strong,nonatomic) NSMutableArray *filteredNames;
@property (strong,nonatomic) NSMutableArray *filteredDates;


@property BOOL isFiltered;

@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;


- (IBAction)editCell:(UIButton *)sender;

@end
