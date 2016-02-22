//
//  RestLayer.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/21/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import "RestLayer.h"

@implementation RestLayer

// This will be the general library for REST calls for all the pages in the app.
static NSString * const BaseURLString = @"http://localhost:8000/mobile/";

+(AFHTTPSessionManager*)getDriver:(int)i {
    NSString* fullUrl = [NSString stringWithFormat:@"%@driver/%i", BaseURLString, i];
    NSURL *baseURL = [NSURL URLWithString:fullUrl];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

+(AFHTTPSessionManager*)getCampaign:(int)i {
    NSString* fullUrl = [NSString stringWithFormat:@"%@campaign/%i", BaseURLString, i];
    NSURL *baseURL = [NSURL URLWithString:fullUrl];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

@end
