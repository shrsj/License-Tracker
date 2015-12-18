//
//  logViewController.h
//  license_tracker
//
//  Created by Mac-Mini-2 on 16/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface logViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
- (IBAction)logTime:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableLog;
@property (nonatomic,strong) DBManager *model;
@property (weak, nonatomic) IBOutlet UITextView *todaysDate;

@end
