//
//  DBManager.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManager : NSObject
-(void) openDB;
-(void) closeDB;
-(NSDictionary *) allLicenseList;

-(int) addLicense:(NSString*)licenseName expiryDate:(NSString*)expiryDate;
-(NSDictionary *) upcomingLicenses:(NSString*)firstDate
                          lastDate:(NSString*)lastDate;

-(int) deleteLicense:(NSString *)licenseName
          expiryDate:(NSString *)expiryDate;

-(int) updateLicense:(NSString *)orgLicenseName
          expiryDate:(NSString *)orgExpiryDate
       uLicenseName :(NSString *)uLicenseName
        uExpiryDate :(NSString *)uExpiryDate;

-(int) addLog:(NSString*)logDate;
-(NSArray *) allLogList;

-(NSString *) lastrow;
-(NSArray *) weeklyList;
-(NSArray *) monthList;
-(NSArray *) yearList;

-(double ) calcPecrcentage:(NSString *)firstDayOfPreviousWeek
         lastDayOfPrevious:(NSString *)lastDayOfPreviousWeek
            firstDayOfWeek:(NSString *)firstDayOfTheWeek
             lastDayOfWeek:(NSString *)lastDayOfWeek;

@end
