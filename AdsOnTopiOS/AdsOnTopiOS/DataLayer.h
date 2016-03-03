//
//  DataLayer.h
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/21/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Driver.h"

@interface DataLayer : NSObject

+(int)daysLeftInTrial;
+(Driver*)getDriver;

@end
