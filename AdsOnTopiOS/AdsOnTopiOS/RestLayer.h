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

+(AFHTTPSessionManager*)getDriver:(int)i;
+(AFHTTPSessionManager*)getCampaign:(int)i;

@end
