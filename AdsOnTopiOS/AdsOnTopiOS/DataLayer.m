//
//  DataLayer.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/21/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import "DataLayer.h"
#import "Driver.h"

@implementation DataLayer

+(int)daysLeftInTrial {
    NSArray* d_list = [Driver MR_findAll];
    Driver* d = [d_list objectAtIndex:0];
    NSDate* trial_end_date = d.trial_end_date;
    NSDate* today_date = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today_date toDate:trial_end_date options:0];
    
    return components.day + 30 * components.month;
}

+(Driver*)getDriver {
    NSArray* d_list = [Driver MR_findAll];
    Driver* d = [d_list objectAtIndex:0];
    return d;
}

@end
