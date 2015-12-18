//
//  graphViewController.m
//  license_tracker
//
//  Created by Mac-Mini-2 on 18/11/15.
//  Copyright (c) 2015 shravan. All rights reserved.
//

#import "graphViewController.h"

@interface graphViewController ()
{
    NSMutableArray *values,*dates;
    int totalNumber;
    int functionFlag;
}

@end

@implementation graphViewController

#pragma mark DBManager

-(DBManager *) model
{
    if(!_model)
    {
        _model = [[DBManager alloc]init];
    }
    return _model;
}

#pragma mark UIVIEW controls

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //last logged date
    NSString * lastLogged = [self.model lastrow];
    NSDate *lastDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    lastDate = [dateFormat dateFromString:lastLogged];
    NSLog(@"last logged %@",lastDate);
    
    //todays date
    NSDateFormatter *trialFormat = [[NSDateFormatter alloc]init];
    [trialFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [trialFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *formatedCurrentDate = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"current date %@",formatedCurrentDate);
    
    NSDate *trialDate1 = [trialFormat dateFromString:formatedCurrentDate];
    NSLog(@"Trial11 = %@",trialDate1);
    
    [self remainingTime:lastDate endDate:trialDate1];
    [self changeInPercent];
    
    
    [self hydrateDatasets:[self.model weeklyList] dateslogged:[self retweekdates]];
    //LINE GRaph
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    self.graphView.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    
    // BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(8, 80, 360, 335)];
    self.graphView.delegate = self;
    self.graphView.dataSource = self;
    [self.view addSubview:self.graphView];
    
    // Enable and disable various graph properties and axis displays
    self.graphView.enableTouchReport = YES;
    self.graphView.enablePopUpReport = YES;
    self.graphView.enableYAxisLabel = YES;
    self.graphView.enableXAxisLabel = YES;
    self.graphView.autoScaleYAxis = YES;
    self.graphView.alwaysDisplayDots = NO;
    self.graphView.enableReferenceXAxisLines = YES;
    self.graphView.enableReferenceYAxisLines = YES;
    self.graphView.enableReferenceAxisFrame = YES;
    
    // Set the graph's animation style to draw, fade, or none
    self.graphView.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.graphView.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.graphView.formatStringForValues = @"%.1f";
    
    // Setup initial curve selection segment
    //self.curveChoice.selectedSegmentIndex = self.graphView.enableBezierCurve;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Display Statistics

-(void)remainingTime:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSDateComponents *components;
    NSInteger days = 0;
    NSInteger hour = 0;
    NSInteger minutes = 0;
    NSString *durationString, *durationString1, *durationString2, *durationString3;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute
                                                 fromDate:startDate toDate: endDate options: 0];
    if ([components day] != 0)
    {
        days = [components day];
        durationString1 = [NSString stringWithFormat:@"%ld days",(long)days];
    }
    else
    {
        days = 0;
        durationString1 = [NSString stringWithFormat:@"%ld days",(long)days];
    }
    if ([components hour] != 0)
    {
        hour = [components hour];
        durationString2 =[NSString stringWithFormat: @"%ld hours",(long)hour];
    }
    else
    {
        hour = 0;
        durationString2 =[NSString stringWithFormat: @"%ld hours",(long)hour];
    }
    if ([components minute] != 0)
    {
        minutes=[components minute];
        durationString3 =[NSString stringWithFormat:@"%ld minutes",(long)minutes];
    }
    else
    {
        minutes = 0;
        durationString3 =[NSString stringWithFormat:@"%ld minutes",(long)minutes];
    }
    durationString = [NSString stringWithFormat:@" %@ and %@ and %@",durationString1,durationString2,durationString3];
    self.lastTimelog.text = durationString;
}

-(void)changeInPercent
{
    NSDate *weekDate = [NSDate date];
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [myCalendar components:( NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:weekDate];
    
    //present Week
    int ff = (int)currentComps.weekOfYear;
    NSLog(@"Current week is : %d th WEEK", ff);
    
    [currentComps setWeekday:1]; // 1: sunday
    NSDate *firstDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    [currentComps setWeekday:7]; // 7: saturday
    NSDate *lastDayOfTheWeek = [myCalendar dateFromComponents:currentComps];
    
    // NEXT WEEEK
    [currentComps setWeekday:1];
    [currentComps setWeekOfYear:ff-1];
    NSDate *firstDayOfPreviousWeek = [myCalendar dateFromComponents:currentComps];
    [currentComps setWeekday:7];
    [currentComps setWeekOfYear:ff-1];
    NSDate *lastDayOfPreviousWeek = [myCalendar dateFromComponents:currentComps];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *firstDate=[dateFormat stringFromDate:firstDayOfTheWeek];
    NSString *lastDate=[dateFormat stringFromDate:lastDayOfTheWeek];
    NSString *firstDayPrev = [dateFormat stringFromDate:firstDayOfPreviousWeek];
    NSString *lastDayPrev  = [dateFormat stringFromDate:lastDayOfPreviousWeek];
    NSLog(@"startweek = %@ \n and endweek = %@ \n and \n firstDayOfPreviousWeek=%@ and lastDayOfPreviousWeek= \n %@",firstDate,lastDate,firstDayPrev
          ,lastDayPrev);
    
    NSInteger result1 = [self.model calcPecrcentage:firstDayPrev lastDayOfPrevious:lastDayPrev firstDayOfWeek:firstDate lastDayOfWeek:lastDate];
    NSString *resul = [NSString stringWithFormat:@" %ld %%compared to last week",(long)result1];
    if (result1 == 0) {
        self.result.text = @"Theres no increase in % OR Insufficient data";
    }
    else{
        self.result.text = resul;
    }
    
}


#pragma mark Simple Line Graph
/*
 - (void)hydrateDatasets {
 // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
 if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
 if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
 [self.arrayOfValues removeAllObjects];
 [self.arrayOfDates removeAllObjects];
 
 
 values = [[NSMutableArray alloc] initWithArray:[self.model weeklyList]];
 NSString *day = [[NSString alloc] init];
 NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
 [dateForm setDateFormat:@"MM-dd"];
 dates = [[NSMutableArray alloc] init];
 
 NSCalendar * cal = [NSCalendar currentCalendar];
 NSDateComponents *dateComp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:[NSDate date]];
 NSInteger n = dateComp.day;
 n = n - 6;
 
 for (NSInteger  i = 0 ; i<7; i++)
 {
 
 [dateComp setDay: n];
 NSDate *today = [cal dateFromComponents:dateComp];
 day = [dateForm stringFromDate:today];
 [dates addObject:day];
 n++;
 }
 NSLog(@"values : %@", values);
 NSLog(@"dates : %@", dates);
 
 
 NSArray *values1 = @[@10,@20,@30];
 NSArray *dates1 =@[@"10/2015",@"11/2015",@"12/2015"];
 for (int i=0; i<[values count]; i++)
 {
 [self.arrayOfValues addObject:values1[i]];
 [self.arrayOfDates addObject:dates1[i]];
 }
 
 }
 
 */

- (void)hydrateDatasets:(NSArray *)logs
            dateslogged:(NSArray *)dates
{
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    for (int i=0; i<[logs count]; i++)
    {
        [self.arrayOfValues addObject:logs[i]];
        [self.arrayOfDates addObject:dates[i]];
    }
}


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}
#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}
- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

- (NSString *)labelForDateAtIndex:(NSInteger)index
{
    NSArray *array = [[NSArray alloc] init];
    if (functionFlag == 3) {
        array = [[NSArray alloc] initWithArray:[self retYearDates]];
    }
    else if (functionFlag == 2)
    {
        array = [[NSArray alloc] initWithArray:[self retMonthDates]];
    }
    else
    {
        array = [[NSArray alloc] initWithArray:[self retweekdates]];
    }
    NSString *label = array[index];
    return label;
    
}

#pragma mark Graph buttons



- (IBAction)weekly:(UIButton *)sender
{
    values = [[NSMutableArray alloc] initWithArray:[self.model weeklyList]];
    dates = [[NSMutableArray alloc] initWithArray:[self retweekdates]];
    functionFlag =1;
    NSLog(@"values : %@", values);
    NSLog(@"dates : %@", dates);
    [self hydrateDatasets:values dateslogged:dates];
    [self.graphView reloadGraph];
}


- (IBAction)monthly:(UIButton *)sender
{
    values = [[NSMutableArray alloc] initWithArray:[self.model monthList]];
    dates = [[NSMutableArray alloc] initWithArray:[self retMonthDates]];
    functionFlag = 2;
    NSLog(@"values : %@", values);
    NSLog(@"dates : %@", dates);
    [self hydrateDatasets:values dateslogged:dates];
    [self.graphView reloadGraph];
}

- (IBAction)yearly:(UIButton *)sender
{
    values = [[NSMutableArray alloc] initWithArray:[self.model yearList]];
    dates = [[NSMutableArray alloc] initWithArray:[self retYearDates]];
    functionFlag = 3;
    NSLog(@"values : %@", values);
    NSLog(@"dates : %@", dates);
    [self hydrateDatasets:values dateslogged:dates];
    [self.graphView reloadGraph];
}

#pragma mark date functions


-(NSArray *) retweekdates
{
    NSString *day = [[NSString alloc] init];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"MM-dd"];
    dates = [[NSMutableArray alloc] init];
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:[NSDate date]];
    NSInteger n = dateComp.day;
    n = n - 6;
    
    for (NSInteger  i = 0 ; i<7; i++)
    {
        
        [dateComp setDay: n];
        NSDate *today = [cal dateFromComponents:dateComp];
        day = [dateForm stringFromDate:today];
        [dates addObject:day];
        n++;
    }
    return dates;
}
-(NSArray *)retMonthDates
{
    NSString *day = [[NSString alloc] init];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd"];
    dates = [[NSMutableArray alloc] init];
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:[NSDate date]];
    NSInteger n = dateComp.day;
    n = n +1;
    //for loop will come here
    
    for (NSInteger i = 1; i < n ; i++)
    {
        
        [dateComp setDay: i];
        NSDate *today = [cal dateFromComponents:dateComp];
        day = [dateForm stringFromDate:today];
        [dates addObject:day];
    }
    return dates;
    
}

-(NSArray *)retYearDates
{
    NSString *day = [[NSString alloc] init];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM"];
    dates = [[NSMutableArray alloc] init];
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:[NSDate date]];
    NSInteger n = dateComp.month;
    n = n +1;
    //for loop will come here
    
    for (NSInteger i = 1; i < n ; i++)
    {
        
        [dateComp setMonth: i];
        NSDate *today = [cal dateFromComponents:dateComp];
        day = [dateForm stringFromDate:today];
        [dates addObject:day];
    }
    return dates;
    
}

#pragma mark UI Buttons

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

@end
