//
//  graphViewController.h
//  license_tracker
//
//  Created by Mac-Mini-2 on 18/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "BEMSimpleLineGraphView.h"


@interface graphViewController : UIViewController <BEMSimpleLineGraphDelegate,BEMSimpleLineGraphDataSource>


@property (nonatomic, strong) DBManager *model;
@property (weak, nonatomic) IBOutlet UILabel *result;

@property (weak, nonatomic) IBOutlet UILabel *lastTimelog;
@property (weak, nonatomic) IBOutlet BEMSimpleLineGraphView *graphView;

@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;

- (IBAction)weekly:(UIButton *)sender;
- (IBAction)monthly:(UIButton *)sender;
- (IBAction)yearly:(UIButton *)sender;

-(void)remainingTime:(NSDate*)startDate endDate:(NSDate*)endDate;
@end
