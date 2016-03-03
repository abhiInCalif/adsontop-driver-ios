//
//  RestLayer.h
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/21/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RestLayer : NSObject

+(AFHTTPSessionManager*)getDriver:(NSString*)i;
+(AFHTTPSessionManager*)postDriver;
+(AFHTTPSessionManager*)getCampaign:(NSString*)i;
+(AFHTTPSessionManager*)postSignal;
+(AFHTTPSessionManager*)getDriverImage:(NSString*)uid;

@end
