//
//  DBManager.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "DBManager.h"
static sqlite3 *database;
@implementation DBManager
/*
 CREATE TABLE licenseDetails(LID integer not null primary key,licenseName nvarchar(100) not null,expiryDate DATE not null);
 CREATE TABLE licenselog(lid integer not null primary key,timelog varchar(30) not null);
 */

-(id) init
{
    self = [super init];
    if (self) {
        NSString *dbBundlePath = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"sqlite3"];
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error;
        if(![manager fileExistsAtPath:[self dbDocPath]])
        {
            [manager copyItemAtPath:dbBundlePath toPath:[self dbDocPath] error:&error];
            if (error) {
                NSLog(@"Error copyinmg file: %@",[error description]);
            }
        }
    }
    return self;
}

-(NSString *) dbDocPath
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[docPaths objectAtIndex:0] stringByAppendingString:@"/license.sqlite3"];
    return path;
}

-(void) openDB
{
    if ((sqlite3_open([[self dbDocPath] UTF8String], &database))!= SQLITE_OK) {
        
        NSLog(@"Error: cannot open database");
    }
}

-(void) closeDB
{
    sqlite3_close(database);
}

-(NSDictionary *) upcomingLicenses:(NSString*)firstDate
                      lastDate:(NSString*)lastDate
{
    [self openDB];
   
  //  NSMutableArray *licenseTable1 = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
 //   NSMutableArray *test = [[NSMutableDictionary alloc]initWithCapacity:5];
    NSString *selectSQL = [NSString stringWithFormat: @"SELECT licenseName,expiryDate FROM licenseDetails where expiryDate BETWEEN '%@' AND '%@' ORDER BY expiryDate ASC",firstDate,lastDate];
     // NSLog(@"selectSQL Query=%@",selectSQL);
    const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *aName = (char *) sqlite3_column_text(query_stmt, 0);
        char *expiryDate = (char *) sqlite3_column_text(query_stmt, 1);
        NSString *areaName = [[NSString alloc] initWithUTF8String:aName];
        NSString *licenseExpiryDate = [[NSString alloc] initWithUTF8String:expiryDate];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:licenseExpiryDate,areaName, nil];
        [test addEntriesFromDictionary:dict];
         //NSArray *entry = @[areaName,licenseExpiryDate];
        //[licenseTable1 addObject:entry];
        }
  //  NSLog(@"test%@=",test);
    [self closeDB];
    return test;
}

-(int) deleteLicense:(NSString *)licenseName
          expiryDate:(NSString *)expiryDate
{
    [self openDB];
    NSString *deleteString = [NSString stringWithFormat:@"delete from licenseDetails where licenseName= '%@' and expiryDate= '%@'",licenseName,expiryDate];
    NSLog(@"Delete query=%@",deleteString);
    const char* query = [deleteString UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if(sqlite3_prepare(database, query, -1, &query_stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error preparing %@",deleteString);
        return 0;
    }
    if(sqlite3_step(query_stmt)!=SQLITE_DONE)
    {
        NSLog(@"Error running delete %s",query);
        return 0;
    }
    [self closeDB];
    return 1;
}

#pragma mark ViewAll View Functions

-(NSDictionary *) allLicenseList
{
    [self openDB];
    // NSMutableArray *licenseTable = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableDictionary *test = [[NSMutableDictionary alloc]init];
    NSString *selectSQL = @"SELECT licenseName,expiryDate FROM licenseDetails ";
    NSLog(@"selectSQL Query=%@",selectSQL);
    const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *aName = (char *) sqlite3_column_text(query_stmt, 0);
        char *expiryDate = (char *) sqlite3_column_text(query_stmt, 1);
        NSString *areaName = [[NSString alloc] initWithUTF8String:aName];
        NSString *licenseExpiryDate = [[NSString alloc] initWithUTF8String:expiryDate];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:licenseExpiryDate,areaName, nil];
        [test addEntriesFromDictionary:dict];
    }
    NSLog(@"test%@=",test);
    [self closeDB];
    return test;
}


#pragma mark EDIT View Functions

-(int) updateLicense:(NSString *)orgLicenseName
          expiryDate:(NSString *)orgExpiryDate
       uLicenseName :(NSString *)uLicenseName
        uExpiryDate :(NSString *)uExpiryDate
{
    [self openDB];
    NSString *updateString = [NSString stringWithFormat:@"update licenseDetails SET licenseName= '%@', expiryDate= '%@' WHERE licenseName= '%@' and expiryDate= '%@'",uLicenseName,uExpiryDate,orgLicenseName,orgExpiryDate ];
    NSLog(@"updated=%@",updateString);
    const char* query = [updateString UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if(sqlite3_prepare(database, query, -1, &query_stmt, NULL) != SQLITE_OK)
    {
        NSLog(@"Error preparing %@",updateString);
        return 0;
    }
    if(sqlite3_step(query_stmt)!=SQLITE_DONE)
    {
        NSLog(@"Error running update %s",query);
        return 0;
    }
    [self closeDB];
    return 1;
}

#pragma mark ADD View functions

-(int) addLicense:(NSString*)licenseName
       expiryDate:(NSString*)expiryDate
{
    
    [self openDB];
    NSString *insertString = [NSString stringWithFormat:@"INSERT INTO licenseDetails(licenseName,expiryDate) VALUES('%@','%@')",licenseName,expiryDate];
    NSLog(@"Insert Query=%@",insertString);
    const char* query = [insertString UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        NSLog(@"Error preparing %@", insertString);
        return 0;
    }
    if(sqlite3_step(query_stmt)!= SQLITE_DONE)
    {NSLog(@"Error running insert %s",query);
        return 0;
    }
    [self closeDB];
    return 1;
}

#pragma mark Log View functions

-(NSArray *) allLogList
{
    [self openDB];
    NSMutableArray *test = [[NSMutableArray alloc]init];
    NSString *selectSQL = @"SELECT timelog FROM licenselog ORDER BY datetime(timelog) DESC";
    NSLog(@"selectSQL Query=%@",selectSQL);
    const char* query = [selectSQL UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        
        NSLog(@"Error preparing %@", selectSQL);
        return nil;
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logtime = (char *) sqlite3_column_text(query_stmt, 0);
        
        NSString *areaName = [[NSString alloc] initWithUTF8String:logtime];
        //NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
       //[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"];
       // NSDate *test1 = [dateFormat dateFromString:areaName];
        
        NSArray *dict = [NSArray arrayWithObject:areaName];
        [test addObjectsFromArray:dict];
       // NSLog(@"test1 %@=",);
    }
    NSLog(@"test1 %@=",test);
    [self closeDB];
    return test;
}


-(int) addLog:(NSString *)logDate
{
    
    [self openDB];
    NSString *insertString1 = [NSString stringWithFormat:@"INSERT INTO licenselog(timelog) VALUES(datetime('now','localtime'))"];
   // NSString *insertString1 = [NSString stringWithFormat:@"DROP TABLE licenselog" ];
    //NSString *insertString1 = [NSString stringWithFormat:@"CREATE TABLE licenselog(lid integer not null primary key,timelog datetime default current_timestamp not null)"];
    NSLog(@"Insert Query=%@",insertString1);
    const char* query = [insertString1 UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
       // NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        NSLog(@"Error preparing %@", insertString1);
        return 0;
    }
    if(sqlite3_step(query_stmt)!= SQLITE_DONE)
    {NSLog(@"Error running insert %s",query);
        return 0;
    }
    [self closeDB];
    return 1;
}

#pragma mark Graph View Functions


-(double ) calcPecrcentage:(NSString *)firstDayOfPreviousWeek
             lastDayOfPrevious:(NSString *)lastDayOfPreviousWeek
                firstDayOfWeek:(NSString *)firstDayOfTheWeek
                lastDayOfWeek:(NSString *)lastDayOfWeek
{
    [self openDB];
    double result1 = 0.0,result2 = 0.0,result3 = 0.0;
    
    NSString *getcnt = [NSString stringWithFormat:@"SELECT COUNT(*) FROM licenselog WHERE   timelog BETWEEN  '%@%%' AND '%@%%'",firstDayOfPreviousWeek,lastDayOfPreviousWeek];
    NSLog(@"get last id query = %@",getcnt);
    const char* query = [getcnt UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        NSLog(@"Error preparing %@", getcnt);
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logtime = (char *) sqlite3_column_text(query_stmt, 0);
        
        NSString *result = [[NSString alloc] initWithUTF8String:logtime];
        result1 = [result doubleValue];
    }

    NSString *getcnt1 = [NSString stringWithFormat:@"SELECT COUNT(*) FROM licenselog WHERE   timelog BETWEEN  '%@%%' AND '%@%%'",firstDayOfTheWeek,lastDayOfWeek];
    NSLog(@"get last id query = %@",getcnt1);
    const char* query1 = [getcnt1 UTF8String];
    sqlite3_stmt *query_stmt1 = NULL;
    if (sqlite3_prepare_v2(database, query1, -1, &query_stmt1, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        NSLog(@"Error preparing %@", getcnt1);
    }
    while (sqlite3_step(query_stmt1)==SQLITE_ROW) {
        char *logtime1 = (char *) sqlite3_column_text(query_stmt1, 0);
        
        NSString *result = [[NSString alloc] initWithUTF8String:logtime1];
        result2 = [result doubleValue];
    }
    if (result1 == 0.0) {
        return 0;
    }
    else
    {
    result3 = ((result2 - result1)/result1) * 100;
    }
    [self closeDB];
    return result3;
}

-(NSString *) lastrow
{
    [self openDB];
    NSString *lastTime = [[NSString alloc] init];
    NSString *getLast = [NSString stringWithFormat:@"SELECT timelog FROM licenselog WHERE   lid = (SELECT MAX(lid)  FROM licenselog)"];
    NSLog(@"get last id query = %@",getLast);
    const char* query = [getLast UTF8String];
    sqlite3_stmt *query_stmt = NULL;
    if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
        NSLog(@"Error preparing %@", getLast);
    }
    while (sqlite3_step(query_stmt)==SQLITE_ROW) {
        char *logtime = (char *) sqlite3_column_text(query_stmt, 0);
        lastTime = [[NSString alloc] initWithUTF8String:logtime];
    }
    [self closeDB];
    return lastTime;
}




-(NSArray *) weeklyList
{
    [self openDB];
    NSMutableArray *test = [[NSMutableArray alloc]init];
    NSString *day = [[NSString alloc] init];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComp = [cal components:(NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:[NSDate date]];
    NSInteger n = dateComp.day;
    n = n - 6;
    
    for (NSInteger  i = 0 ; i<7; i++)
    {
        
        [dateComp setDay: n];
        NSDate *today = [cal dateFromComponents:dateComp];
        day = [dateForm stringFromDate:today];
        
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT COUNT(*)FROM licenselog WHERE timelog LIKE ?"];
        NSLog(@"selectSQL Query=%@",selectSQL);
        const char* query = [selectSQL UTF8String];
        sqlite3_stmt *query_stmt = NULL;
        if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
            
            NSLog(@"Error preparing %@", selectSQL);
            return nil;
        }
        
        NSString *bindParam = [NSString stringWithFormat:@"%%%@%%", day];
        if(sqlite3_bind_text(query_stmt, 1, [bindParam UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK){
            NSLog(@"Problem binding search text param.");
        }
        
        
        while (sqlite3_step(query_stmt)==SQLITE_ROW) {
            char *logtime = (char *) sqlite3_column_text(query_stmt, 0);
            
            NSString *areaName = [[NSString alloc] initWithUTF8String:logtime];
            NSArray *dict = [NSArray arrayWithObject:areaName];
            [test addObjectsFromArray:dict];
        }
        n++;
    }
    
    
        NSLog(@"test%@=",test);
    [self closeDB];
    return test;
}

-(NSArray *) yearList
{
    [self openDB];
    
    NSMutableArray *test = [[NSMutableArray alloc]init];
    NSString *today = [[NSString alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM"];
    
    
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [myCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:[NSDate date]];
    NSInteger n =currentComps.month;
    n = n+1;
    
    for (NSInteger i = 1; i < n; i++)
    {
        [currentComps setMonth: i];
        NSDate *date = [myCalendar dateFromComponents:currentComps];
        today = [dateFormat stringFromDate:date];
    
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT COUNT(*) timelog FROM licenselog WHERE timelog LIKE ?"];
        NSLog(@"selectSQL Query=%@",selectSQL);
        const char* query = [selectSQL UTF8String];
        sqlite3_stmt *query_stmt = NULL;
        if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
            
            NSLog(@"Error preparing %@", selectSQL);
            return nil;
        }

        NSString *bindParam = [NSString stringWithFormat:@"%@%%", today];
        if(sqlite3_bind_text(query_stmt, 1, [bindParam UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK){
        NSLog(@"Problem binding search text param.");
        }
        while (sqlite3_step(query_stmt)==SQLITE_ROW) {
            char *logtime = (char *) sqlite3_column_text(query_stmt, 0);
        
            NSString *areaName = [[NSString alloc] initWithUTF8String:logtime];
            NSArray *dict = [NSArray arrayWithObject:areaName];
            [test addObjectsFromArray:dict];
        }
    }
    NSLog(@"test year %@=",test);
    [self closeDB];
    return test;
}


-(NSArray *) monthList
{
    [self openDB];
    
    NSMutableArray *test = [[NSMutableArray alloc]init];
    NSString *today = [[NSString alloc] init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [myCalendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay) fromDate:[NSDate date]];
    NSInteger n = currentComps.day;
    n = n +1;
    //for loop will come here
    
    for (NSInteger i = 1; i < n ; i++)
    {
        [currentComps setDay:i];
        NSDate *date = [myCalendar dateFromComponents:currentComps];
        today = [dateFormat stringFromDate:date];
        
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT COUNT(*) FROM licenselog WHERE timelog LIKE ?  ORDER BY timelog DESC"];
        NSLog(@"selectSQL Query=%@",selectSQL);
        const char* query = [selectSQL UTF8String];
        sqlite3_stmt *query_stmt = NULL;
        if (sqlite3_prepare_v2(database, query, -1, &query_stmt, NULL) != SQLITE_OK) {
            
            NSLog(@"Error preparing %@", selectSQL);
            return nil;
        }
        NSString *bindParam = [NSString stringWithFormat:@"%%%@%%", today];
        if(sqlite3_bind_text(query_stmt, 1, [bindParam UTF8String], -1, SQLITE_TRANSIENT) != SQLITE_OK){
            NSLog(@"Problem binding search text param.");
        }
        while (sqlite3_step(query_stmt)==SQLITE_ROW) {
            char *logtime = (char *) sqlite3_column_text(query_stmt, 0);
            
            NSString *areaName = [[NSString alloc] initWithUTF8String:logtime];
            NSArray *dict = [NSArray arrayWithObject:areaName];
            [test addObjectsFromArray:dict];
        }
    }

    
    NSLog(@"test month %@=",test);
    [self closeDB];
    return test;
}

@end
