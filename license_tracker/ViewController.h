//
//  ViewController.h
//  license_tracker
//
//  Created by shravan on 06/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DBManager.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) DBManager *model;
@property (weak, nonatomic) IBOutlet UITableView *utblView;

- (IBAction)viewLog:(UIButton *)sender;

@end

